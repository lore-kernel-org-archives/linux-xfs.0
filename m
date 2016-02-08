Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1F8DB7CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 01:54:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A712AAC001
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 23:54:08 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 9X5Uhc5Fm15DWLrQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Feb 2016 23:54:03 -0800 (PST)
Date: Sun, 7 Feb 2016 23:54:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: Introduce writeback context for writepages
Message-ID: <20160208075403.GA29242@infradead.org>
References: <1440479153-1584-1-git-send-email-david@fromorbit.com>
	<1440479153-1584-3-git-send-email-david@fromorbit.com>
	<20160208073631.GA1789@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208073631.GA1789@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 07, 2016 at 11:36:31PM -0800, Christoph Hellwig wrote:
> FYI, I recently started testing this series again after a trivial
> rebase to 4.5-rc2, and this patch seems to cause reproducible failures
> of generic/311 (fsync tester)

And by coincidence you posted a new version the night before I posted
this mail.  It still shows that same failure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
