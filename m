Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBe1DN206173 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:40:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEBD11358614
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:40:00 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	D0vpNxgVFDgiluci for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:40:00 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:39:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
Message-ID: <20110724113959.GD26332@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

> @@ -1247,6 +1247,7 @@ xlog_bdstrat(
>  {
>  	struct xlog_in_core	*iclog = bp->b_fspriv;
>  
> +	bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);

I don't think this is correct, we set these before calling into
xlog_bdstrat, so this means we'll always stip it off after that.

Given that this area is more complicated than the pure macro removal
how about letting it as-is for now?  I have some bigger refactoring
in this area in my queue, and I'll just incorporate the
XFS_BUF_ZEROFLAGS into it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
