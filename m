Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81ANX6H128121 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 05:23:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D78EA179B808
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 03:24:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xGqL4i1oz4IxLmpZ for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 03:24:12 -0700 (PDT)
Date: Wed, 1 Sep 2010 06:24:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 4K drives, sectsz=512, bsize=4096
Message-ID: <20100901102412.GF31648@infradead.org>
References: <201008300956.21264@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201008300956.21264@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Mon, Aug 30, 2010 at 09:56:16AM +0200, Michael Monnerie wrote:
> I have 2x 2TB 4K sector drives, joined with LVM to RAID-0. On top of 
> that, I created an XFS, but that has sectsz=512.
> 
> Will there be any real difference if I re-format with sectsz=4096? 
> AFAIK, XFS will do I/O based on block size, so the sector size doesn't 
> do any harm. Is that correct?

As nathan mentioned XFS issues log I/O based on the sector size, and
we do allow direct I/O down to the sector size.  That's two reasons
why or why you don't want a 4096 byte sector size.  Depending on the rmv
implementation of the drive log I/O might be really slow if you set the
512 byte sector size.  On the other hand there's lots of applications
that have the 512 byte alignment for direct I/O hardcoded, which will
break if you have a larger sector size.  That's one of the fun things
4k sector size disks will bring up, especially the real 4k SAS disks
that do not accept any I/O smaller than that.

> A question for LVM: Is there anything I need to tell to LVM to let it 
> know that those are 4K sector drives and I/O should be aligned to that? 
> Drives are reported as 512b sectors, but really are 4K. There seems to 
> be no way to instruct the kernel to see those drives as 4K drives.

If you have a recent enough LVM all metdata is aligned on 1MB boundaries
which will do just fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
