Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mADEXZvT023043 for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:33:37 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 302531556E45
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:33:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id WAcgOOtNJrhAzbXd for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2008 06:33:35 -0800 (PST)
Date: Thu, 13 Nov 2008 09:32:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20081113143233.GA7977@infradead.org>
References: <491C3842.4090902@poczta.onet.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <491C3842.4090902@poczta.onet.pl>
Subject: Re: [xfs] Calltrace in 2.6.27 kernel
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
To: "aluno3@poczta.onet.pl" <aluno3@poczta.onet.pl>
Cc: xfs@oss.sgi.com

On Thu, Nov 13, 2008 at 03:22:58PM +0100, aluno3@poczta.onet.pl wrote:
> Hi
> 
> I tested kernel 2.6.27 with stress test using fsstress,dd,LVM and
> snapshots. After a few hours and overflow of snapshot I got call trace:
> 
> device-mapper: snapshots: Invalidating snapshot: Unable to allocate
> exception.

This is a message from device mapper telling your that it got an EIO
in pending_complete()

> I/O error in filesystem ("dm-49") meta-data dev dm-49 block
> 0x1d4c3b0       ("xlog_recover_do..(read#2)")
>  error 5 buf count 8192
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed

And now XFS complains that it got this error passed up, so far so good.

> BUG: unable to handle kernel NULL pointer dereference at 0000002c
> IP: [<c029553d>] xfs_log_force_umount+0x3d/0x170
> *pdpt = 00000000345cf001 *pde = 0000000000000000

But ut should not crash.  Can you run 

	addr2line -e /path/to/your/kernel xfs_log_force_umount+0x3d/0x170

(you'll need a kernel with debuginfo for that)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
