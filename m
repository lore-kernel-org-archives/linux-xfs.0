Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB1ChvZp207784 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 06:43:57 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E4EF140434D
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 04:45:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Iy0vDivUZzxRXprn for
	<xfs@oss.sgi.com>; Wed, 01 Dec 2010 04:45:40 -0800 (PST)
Date: Wed, 1 Dec 2010 07:45:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/14] xfs: make AIL tail pushing independent of the
	grant lock
Message-ID: <20101201124540.GC612@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290994712-21376-6-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Once l_tail_lsn and l_last_sync_lsn are converted to atomic64_ts later
in the series passing them in separately becomes pointless again.  Maybe
scale the patch back a bit and require the caller to hold l_grant_lock
for now, until the atomic64_t conversion happens. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
