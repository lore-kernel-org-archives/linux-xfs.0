Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KCDc1B010322 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 06:13:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C55331829943
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 04:13:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ZX6rV2TEToCMcPZf for
	<xfs@oss.sgi.com>; Tue, 20 Jan 2009 04:13:36 -0800 (PST)
Date: Tue, 20 Jan 2009 07:13:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120121335.GA19182@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net>
	<20090120004611.GA6445@disturbed>
	<20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com>
	<20090120114906.GA12526@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090120114906.GA12526@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
> > > Just curious:  do you have CONFIG_LBD set?
> > > 
> > Hi Christoph,
> > 
> > the answer is:
> > $ grep LBD .config
> > # CONFIG_LBD is not set
> 
> Ok, let me reproduce it without that set..

Ok, on 32-bit x86 without CONFIG_LBD I can reliably reproduce the issue
with the following script:


#!/bin/bash

TESTDIR=/mnt/test
SCRATCHMNT=/mnt/scratch
file=$SCRATCHMNT/f

do_pwrite()
{
	offset=`expr $1 \* 512`
	end=`expr $2 \* 512`
	length=`expr $end - $offset`

	xfs_io -d -f $file -c "pwrite $offset $length" >/dev/null
}


mkfs.xfs \
	-b size=1024 \
	-d file,name=$TESTDIR/fsfile,size=40146592b,agcount=16 \
	-i attr=0 \
	-l version=1

mount -o loop,rw,noatime,nodiratime $TESTDIR/fsfile $SCRATCHMNT

do_pwrite 30792 31039
do_pwrite 30320 30791
do_pwrite 29688 30319
do_pwrite 29536 29687
do_pwrite 27216 29535
do_pwrite 24368 27215
do_pwrite 21616 24367
do_pwrite 20608 21615
do_pwrite 19680 20607
do_pwrite 19232 19679
do_pwrite 17840 19231
do_pwrite 16928 17839
do_pwrite 15168 16927
do_pwrite 14048 15167
do_pwrite 12152 14047
do_pwrite 11344 12151
do_pwrite 8792 11343
do_pwrite 6456 8791
do_pwrite 5000 6455
do_pwrite 1728 4999
do_pwrite 0 1727

sync
sync

> $SCRATCHMNT/bigfile

#umount $SCRATCH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
