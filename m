Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 13:54:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m69Kscd1027876
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 13:54:39 -0700
Received: from spitz.ucw.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8ED52D1C3D
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 13:55:34 -0700 (PDT)
Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60]) by cuda.sgi.com with ESMTP id DDNL9ouyg4f96XWD for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 13:55:34 -0700 (PDT)
Date: Wed, 9 Jul 2008 22:48:30 +0200
From: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709204829.GH11006@ucw.cz>
References: <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org> <E1KGTmZ-0006oz-Qi@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KGTmZ-0006oz-Qi@pomaz-ex.szeredi.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: arjan@infradead.org, hch@infradead.org, tytso@mit.edu, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed 2008-07-09 09:08:07, Miklos Szeredi wrote:
> On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> > I tihnk the idea there is
> > 
> > freeze . do the snapshot op . unfreeze . make backup of snapshot
> 
> Ah, so then my proposal would become
> 
>   run_frozen mountpoint do-snapshot
>   do-backup
>   release-snapshot
> 
> and if they are afraid of deadlocks they can just implement the
> timeout in userspace:
> 
>   run_frozen -t timeout mountpoint do-snapshot
> 
> 'run_frozen' can be a trivial 30 line app, that can be guaranteed not
> to deadlock.

Userland apps can be swapped out and need kernel memory allocations
during syscalls.

I bet even sleep(30) uses kmalloc internally.

So yes, even trivial applications can deadlock.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
