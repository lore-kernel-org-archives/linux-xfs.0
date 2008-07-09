Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Jul 2008 23:58:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m696wsJS020013
	for <xfs@oss.sgi.com>; Tue, 8 Jul 2008 23:58:54 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C016F2CCC83
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2008 23:59:58 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ss6UxDx18WfqtSiz for <xfs@oss.sgi.com>; Tue, 08 Jul 2008 23:59:58 -0700 (PDT)
Date: Wed, 9 Jul 2008 16:59:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709065950.GR11558@disturbed>
References: <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708234120.5072111f@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, Jul 08, 2008 at 11:41:20PM -0700, Arjan van de Ven wrote:
> On Wed, 09 Jul 2008 08:22:56 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> > > > This would mean that freeze and thaw will have to be done on the
> > > > same file descriptor, but this isn't unreasonable to expect, is
> > > > it?
> > > 
> > > It is certainly not the current use case, where you run one command
> > > to freeze the filesystem and another one to unfreeze it.
> > 
> > So instead of
> > 
> >   freeze_fs mountpoint
> >   backup-command
> >   unfreeze_fs mountpoint
> > 
> > the user would have do to
> > 
> >   run_freezed mountpoint backup-command
> > 
> > I find the second one nicer, regardless of any reliability issues.
> 
> nah he needs to do
> 
> make_snapshot ; backup-command ; unref_snapshot.
> 
> freezing isn't the right solution for the backup problem ;)

You're forgetting that to take a snapshot you generally need to
freeze the filesystem. ;) i.e:

freeze; make_snapshot; unfreeze
backup-command
unref_snapshot

Yes, dm_snapshot does the freeze/snapshot/unfreeze for you, but the
point is there is a freeze in the example you gave.

The argument against Miklos' version is that there may be multiple
commands to execute while the fs is frozen.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
