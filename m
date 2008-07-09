Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 01:10:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m698AI67001386
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 01:10:18 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0139ADD1D0A
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 01:11:23 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id 5nczH8YF61fTiAPW for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 01:11:23 -0700 (PDT)
In-reply-to: <20080709073358.GT11558@disturbed> (message from Dave Chinner on
	Wed, 9 Jul 2008 17:33:58 +1000)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed> <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu> <20080709073358.GT11558@disturbed>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1KGUlR-0006zH-FT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 10:11:01 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: david@fromorbit.com
Cc: miklos@szeredi.hu, arjan@infradead.org, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, 9 Jul 2008, Dave Chinner wrote:
> On Wed, Jul 09, 2008 at 09:13:34AM +0200, Miklos Szeredi wrote:
> > On Wed, 9 Jul 2008, Dave Chinner wrote:
> > > The argument against Miklos' version is that there may be multiple
> > > commands to execute while the fs is frozen.
> > 
> > Which is what a shell is for ;)
> 
> Yeah, weĺl, with your method I ca't tell a user to:
> 
> 	# xfs_freeze -f /mntpt
> 	# xfs_db -r -c 'sb 0' -c 'p rootino' /dev/foo
> 	128
> 	# xfs_db -r -c 'ino 128' -c 'p core.format' /dev/foo
> 	core.format = 2 (extents)
> 	# xfs_db .....
> 	.....
> 	# xfs_freeze -u /mntpt
> 
> i.e. using the freeze to force all metadata to disk and
> prevent it from changing while doing interactive debugging
> of some problem.

	# run_freeze /mntpt /bin/bash
	# ...
	# ^D

It's the same, no?

Miklos
