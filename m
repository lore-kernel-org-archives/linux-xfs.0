Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 23:41:15 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m696fCgg018235
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 23:41:12 -0700
Received: from casper.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B418D18955AB
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 23:42:16 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by cuda.sgi.com with ESMTP id Z9CVRXgRLVRWfmvP for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 23:42:16 -0700 (PDT)
Date: Tue, 8 Jul 2008 23:41:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080708234120.5072111f@infradead.org>
In-Reply-To: <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
References: <20080630212450t-sato@mail.jp.nec.com>
	<20080701081026.GB16691@infradead.org>
	<20080707110730.GG5643@ucw.cz>
	<20080708231026.GP11558@disturbed>
	<20080708232031.GE18195@elf.ucw.cz>
	<20080709005254.GQ11558@disturbed>
	<20080709010922.GE9957@mit.edu>
	<E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu>
	<20080709061621.GA5260@infradead.org>
	<E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Wed, 09 Jul 2008 08:22:56 +0200
Miklos Szeredi <miklos@szeredi.hu> wrote:

> On Wed, 9 Jul 2008, Christoph Hellwig wrote:
> > On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> > > This would mean that freeze and thaw will have to be done on the
> > > same file descriptor, but this isn't unreasonable to expect, is
> > > it?
> > 
> > It is certainly not the current use case, where you run one command
> > to freeze the filesystem and another one to unfreeze it.
> 
> So instead of
> 
>   freeze_fs mountpoint
>   backup-command
>   unfreeze_fs mountpoint
> 
> the user would have do to
> 
>   run_freezed mountpoint backup-command
> 
> I find the second one nicer, regardless of any reliability issues.

nah he needs to do

make_snapshot ; backup-command ; unref_snapshot.

freezing isn't the right solution for the backup problem ;)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
