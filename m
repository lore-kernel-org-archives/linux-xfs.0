Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 23:12:53 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m696ClCO015387
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 23:12:50 -0700
Received: from pomaz-ex.szeredi.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D3BD1895704
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 23:13:52 -0700 (PDT)
Received: from pomaz-ex.szeredi.hu (fxip-0047f.externet.hu [88.209.222.127]) by cuda.sgi.com with ESMTP id jKmeAoP2O8F4UDTV for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 23:13:52 -0700 (PDT)
In-reply-to: <20080709010922.GE9957@mit.edu> (message from Theodore Tso on
	Tue, 8 Jul 2008 21:09:22 -0400)
Subject: Re: [PATCH 3/3] Add timeout feature
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu>
Message-Id: <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jul 2008 08:13:21 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: tytso@mit.edu
Cc: pavel@suse.cz, hch@infradead.org, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, 8 Jul 2008, Theodore Tso wrote:
> On Wed, Jul 09, 2008 at 10:52:54AM +1000, Dave Chinner wrote:
> > If you walk enough inodes while the filesystem is frozen, it
> > theoretically could happen.  Typically a filesystem is only for a
> > few seconds at a time so in the real world this has never, ever been
> > a problem.
> 
> I had argued for the timeout (and so it's mostly my fault that
> Takashi-San included it as a feature) mainly because I was (and still
> amm) deeply paranoid about the competence of the application
> programers who might use this feature.  I could see them screwing up
> leaving it locked forever --- perhaps when their program core dumps or
> when the user types ^C and they forgot to install a signal handler,
> leaving the filesystem frozen forever.

A much better way to deal with that would be to limit the freeze to
the lifetime of the process somehow.  E.g. the freeze ioctl sets a bit
in struct file (I'm sure we have some available) and release on the
file checks this bit and thaws the filesystem.

This would mean that freeze and thaw will have to be done on the same
file descriptor, but this isn't unreasonable to expect, is it?

Miklos
