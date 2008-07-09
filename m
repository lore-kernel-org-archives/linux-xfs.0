Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 00:33:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m697Wxo4031601
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 00:32:59 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72237DD1B6D
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 00:34:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id H9xWhGySNu0A3cSw for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 00:34:03 -0700 (PDT)
Date: Wed, 9 Jul 2008 17:33:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709073358.GT11558@disturbed>
References: <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <20080709065950.GR11558@disturbed> <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1KGTrq-0006qj-1u@pomaz-ex.szeredi.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: arjan@infradead.org, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, Jul 09, 2008 at 09:13:34AM +0200, Miklos Szeredi wrote:
> On Wed, 9 Jul 2008, Dave Chinner wrote:
> > The argument against Miklos' version is that there may be multiple
> > commands to execute while the fs is frozen.
> 
> Which is what a shell is for ;)

Yeah, weĺl, with your method I ca't tell a user to:

	# xfs_freeze -f /mntpt
	# xfs_db -r -c 'sb 0' -c 'p rootino' /dev/foo
	128
	# xfs_db -r -c 'ino 128' -c 'p core.format' /dev/foo
	core.format = 2 (extents)
	# xfs_db .....
	.....
	# xfs_freeze -u /mntpt

i.e. using the freeze to force all metadata to disk and
prevent it from changing while doing interactive debugging
of some problem.

Yes, a one-shot freeze/unfreeze mechanism works for some
use cases. The point is that it does not work for them all.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
