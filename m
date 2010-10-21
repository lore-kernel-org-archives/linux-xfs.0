Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LCp52s256880 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 07:51:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D64A41DA68C3
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 05:52:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id bamKSclS0wQnDLC9 for
	<xfs@oss.sgi.com>; Thu, 21 Oct 2010 05:52:19 -0700 (PDT)
Date: Thu, 21 Oct 2010 08:52:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
Message-ID: <20101021125219.GA21472@infradead.org>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Oct 21, 2010 at 05:41:43PM +0530, Ajeet Yadav wrote:
> Dear member,
> If I remove USB flash storage from PC/ARM/MIPS target (i.e
> without umount) while copying file to XFS partition and connect it to MIPS
> target I always get
> XFS: xlog_recover_process_data: bad clientid
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed
> This problem does not occur, if I connect the same USB flash to PC/ARM
> target.
> I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend with
> MIPS)

Since Linux 2.6.34 Linux uses the flush_kernel_vmap_range/
invalidate_kernel_vmap_range APIs to make I/O to vmapped
areas work on systems with virtually indexed caches.

Unfortunately only arm, parisc and sh actually implement these so far.
You'll need to implement an implementation of these APIs for your cache
architecture to make XFS work on MIPS with virtually indexed caches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
