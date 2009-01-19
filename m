Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0J1q6tT016934 for <xfs@oss.sgi.com>; Sun, 18 Jan 2009 19:52:06 -0600
Date: Sun, 18 Jan 2009 20:52:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] Remaining 2.6.29 queue
Message-ID: <20090119015204.GA28128@infradead.org>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090118170241.GA21181@infradead.org>
	<9305FAB6-0189-4F82-9E12-22656A7ABF9F@sgi.com>
	<4973DCD8.2070705@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4973DCD8.2070705@sgi.com>
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
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 19, 2009 at 12:52:24PM +1100, Lachlan McIlroy wrote:
> They applied okay but the first patch caused this build failure.
>
>    CC      init/version.o
>    LD      init/built-in.o
>    LD      .tmp_vmlinux1
> fs/built-in.o: In function `xfs_handle_to_dentry':
> /home/lachlan/git/xfs-update/fs/xfs/linux-2.6/xfs_ioctl.c:211: undefined reference to `exportfs_decode_fh'
> make: *** [.tmp_vmlinux1] Error 1

That was, as noted in the thread a missing select EXPORTFS in the
Kconfig.  It's fixed in the kernel.org git tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
