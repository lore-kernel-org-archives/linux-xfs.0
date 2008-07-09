Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 06:55:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69Dt2xn014620
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 06:55:04 -0700
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CC802CE915
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 06:56:05 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by cuda.sgi.com with ESMTP id jQxmJ2otFpFsA7On for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 06:56:05 -0700 (PDT)
Date: Wed, 9 Jul 2008 06:55:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709065540.57305d91@infradead.org>
In-Reply-To: <20080709114958.GV11558@disturbed>
References: <20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
	<20080708234120.5072111f@infradead.org>
	<E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu>
	<20080708235502.1c52a586@infradead.org>
	<20080709071346.GS11558@disturbed>
	<20080709110900.GI9957@mit.edu>
	<20080709114958.GV11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Tso <tytso@mit.edu>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, 9 Jul 2008 21:49:58 +1000
Dave Chinner <david@fromorbit.com> wrote:

> 
> (e) none of the above.  The kernel compilation will appear to pause
> until the filesystem is unfrozen. No other visible effect should
> occur. It will get blocked in a write or filesystem transaction
> because the fs is frozen.
> 
> Look at vfs_check_frozen() - any call to that will block if the
> filesystem is frozen or being frozen. The generic hook is in
> __generic_file_aio_write_nolock() and various other filesystems have
> calls in their specific write paths (fuse, ntfs, ocfs2, xfs, xip) to
> do this.

yeah and mmap doesn't happen
> 
> For all other modifications, filesystem specific methods of
> blocking transactions are used. XFS uses vfs_check_frozen() in
> xfs_trans_alloc(), ext3 (and probably ocfs2) do it via
> their ->write_super_lockfs method calling journal_lock_updates(),
> ext4 via jbd2_lock_updates() and so on....

and what if it's the process that you need to unfreeze the fs later?
Good luck.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
