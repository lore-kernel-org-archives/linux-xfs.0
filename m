Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0LBGJMm068430 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 05:16:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E906D1C6A5F0
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:17:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id y8RB7jpECcBXaHqz for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:17:20 -0800 (PST)
Date: Thu, 21 Jan 2010 06:17:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [help] project quota information incorrect over nfs ...
Message-ID: <20100121111720.GA20641@infradead.org>
References: <77cc6e171001202012y9472a42m849bcea8910ca290@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <77cc6e171001202012y9472a42m849bcea8910ca290@mail.gmail.com>
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
To: "Guk-Bong, Kwon" <gbkwon@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 21, 2010 at 01:12:06PM +0900, Guk-Bong, Kwon wrote:
> nfs client "nfs_server:/test/111" Size is correct..(100M)
> 
> but nfs client "nfs_server:/test/111" Avail is incorrect.. (500M)
> 
> "Avail" is big than "Size" ...
> 
> this stat is normal??

No, it's not.  The patch below should fix it, but I'm not sure how
easily backportable it is to 2.6.27:

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6.orig/fs/xfs/quota/xfs_qm_bhv.c	2010-01-21 12:13:51.397003969 +0100
+++ linux-2.6/fs/xfs/quota/xfs_qm_bhv.c	2010-01-21 12:14:14.290009571 +0100
@@ -59,7 +59,7 @@ xfs_fill_statvfs_from_dquot(
 		be64_to_cpu(dp->d_blk_hardlimit);
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
-		statp->f_bfree =
+		statp->f_bfree = statp->f_bavail =
 			(statp->f_blocks > be64_to_cpu(dp->d_bcount)) ?
 			 (statp->f_blocks - be64_to_cpu(dp->d_bcount)) : 0;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
