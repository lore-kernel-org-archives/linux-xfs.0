Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 04:49:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69BmvXR000817
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 04:48:58 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C7592CDC81
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 04:50:02 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id IZiavC6JSiK1pWVM for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 04:50:02 -0700 (PDT)
Date: Wed, 9 Jul 2008 21:49:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709114958.GV11558@disturbed>
References: <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <20080709071346.GS11558@disturbed> <20080709110900.GI9957@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709110900.GI9957@mit.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, Jul 09, 2008 at 07:09:00AM -0400, Theodore Tso wrote:
> > 
> > Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
> > *clean*? That the process of freezing it ensures all dirty data and
> > metadata is written out before the freeze completes? And that once
> > frozen, it can't be dirtied until unfrozen?
> 
> What do you mean by "it can't be diritied until unfrozen".  What
> happens if I have a kernel compilation happening on a filesystem which
> I am trying to freeze?   Does

> (a) the freeze fail (because the checks equivalent to what happens
> when you remount a filesystem read-only happen)?
> 
> (b) The process gets a kill -9 when it tries to write a file on the
> frozen filesystem?
> 
> (c) The process gets a kill -STOP when it tries to write
> to a file on the frozen filesystem?  
> 
> (d) The process won't fail, but just continue to run, filling the page
> cache with dirty pages that can't be written out because the
> filesystem is frozen?

(e) none of the above.  The kernel compilation will appear to pause
until the filesystem is unfrozen. No other visible effect should
occur. It will get blocked in a write or filesystem transaction
because the fs is frozen.

Look at vfs_check_frozen() - any call to that will block if the
filesystem is frozen or being frozen. The generic hook is in
__generic_file_aio_write_nolock() and various other filesystems have
calls in their specific write paths (fuse, ntfs, ocfs2, xfs, xip) to
do this.

For all other modifications, filesystem specific methods of
blocking transactions are used. XFS uses vfs_check_frozen() in
xfs_trans_alloc(), ext3 (and probably ocfs2) do it via
their ->write_super_lockfs method calling journal_lock_updates(),
ext4 via jbd2_lock_updates() and so on....

When the filesystem is unfrozen the journal is unlocked and
anything sleeping on the vfs_check_frozen() waitqueue is
woken.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
