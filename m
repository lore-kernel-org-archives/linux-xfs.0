Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 07:17:54 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALFHd0P007356
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 07:17:43 -0800
Date: Wed, 21 Nov 2007 15:17:47 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bulkstat fixups
Message-ID: <20071121151747.GC8454@infradead.org>
References: <4733EEF2.9010504@sgi.com> <20071111214759.GS995458@sgi.com> <4737C11D.8030007@sgi.com> <20071112041121.GT66820511@sgi.com> <473D1DE0.1090106@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473D1DE0.1090106@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

+#define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
+

	I don't think this macro is really helpful.  An inline would
	have been useful if statstruct_size was constant, but this
	way it's much better to just write out the comparism the four
	times it's used.

+	if (!ubcountp || *ubcountp <= 0) {
+		return EINVAL;
+	}

	No need for the braces here.


I also must say I don't like the cond_resched() calls very much.  They
look entirely random to me.  We really should only need cond_resched
when it's absolutely needed, and it deserves a comment why it's needed
then.
