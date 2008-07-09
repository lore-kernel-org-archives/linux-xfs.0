Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Jul 2008 00:12:49 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m697Cki6024019
	for <xfs@oss.sgi.com>; Wed, 9 Jul 2008 00:12:47 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7FB7A1895C07
	for <xfs@oss.sgi.com>; Wed,  9 Jul 2008 00:13:50 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id xlNqlC7GTwPId4lW for <xfs@oss.sgi.com>; Wed, 09 Jul 2008 00:13:50 -0700 (PDT)
Date: Wed, 9 Jul 2008 17:13:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080709071346.GS11558@disturbed>
References: <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org> <E1KGTTm-0006ke-Jh@pomaz-ex.szeredi.hu> <20080708235502.1c52a586@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708235502.1c52a586@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org, tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com, akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, Jul 08, 2008 at 11:55:02PM -0700, Arjan van de Ven wrote:
> On Wed, 09 Jul 2008 08:48:42 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > On Tue, 8 Jul 2008, Arjan van de Ven wrote:
> > > nah he needs to do
> > > 
> > > make_snapshot ; backup-command ; unref_snapshot.
> > > 
> > > freezing isn't the right solution for the backup problem ;)
> > 
> > Confused, what's freezing _is_ for then?  Patch description says:
> > 
> >   Currently, ext3 in mainline Linux doesn't have the freeze feature
> > which suspends write requests.  So, we cannot take a backup which
> > keeps the filesystem's consistency with the storage device's features
> >   (snapshot and replication) while it is mounted.
> 
> I tihnk the idea there is
> 
> freeze . do the snapshot op . unfreeze . make backup of snapshot
> 
> one can argue about the need of doing the first 3 steps via a userland
> loop; it sure sounds like one needs to be really careful to not do any
> writes to the fs from the app that does snapshots (and that includes
> doing any syscalls in the kernel that allocate memory.. just because
> that already could cause unrelated data to be written from inside the
> app. Not fun.)

Bloody hell! Doesn't *anyone* understand that a frozen filesystem is
*clean*? That the process of freezing it ensures all dirty data and
metadata is written out before the freeze completes? And that once
frozen, it can't be dirtied until unfrozen?

That's 3 (or is it 4 - maybe 5 now that I think about it) different
ppl in 24 hours that have made this same broken argument about
being unable to write back dirty data on a frozen filesystem......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
