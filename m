Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73KrsJw112941 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 15:53:55 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D417D1BD4A31
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 13:54:43 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.9])
	by cuda.sgi.com with ESMTP id 0Eg5uanNuoV6jVhq for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 13:54:43 -0700 (PDT)
Date: Mon, 3 Aug 2009 13:54:42 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: kernel BUG at lib/radix-tree.c:464
In-Reply-To: <20090803122440.GA11033@infradead.org>
Message-ID: <alpine.DEB.2.01.0908031340300.5831@bogon.housecafe.de>
References: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
	<20090803122440.GA11033@infradead.org>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, 3 Aug 2009 at 08:24, Christoph Hellwig wrote:
> On Sun, Aug 02, 2009 at 11:28:21PM -0700, Christian Kujau wrote:
> > Hi,
> > 
> > while lots of I/O (read, write) was in progress, this was captured via 
> > remote syslog:
> 
> Can you test the patch I posted in
> http://bugzilla.kernel.org/show_bug.cgi?id=13375 ?

I'm using the latest -git tree atm, the patch cannot be applied cleanly:

$ patch --dry-run -p1 < iget-fixes_bug13375.patch
[...]
Hunk #4 FAILED at 215.
1 out of 4 hunks FAILED -- saving rejects to file fs/inode.c.rej
Hunk #1 FAILED at 51.
1 out of 1 hunk FAILED -- saving rejects to file 
fs/xfs/linux-2.6/xfs_sync.h.rej

I'll try to go back to 2.6.30, but I'm not sure if I can even reproduce 
this one reliably.

Thanks,
Christian.
-- 
BOFH excuse #182:

endothermal recalibration

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
