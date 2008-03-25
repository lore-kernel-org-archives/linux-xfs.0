Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 14:38:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PLbx3W031808
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:38:01 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9388D102C6EE
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:38:33 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id nOMF6T5nyLQecY4p for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:38:33 -0700 (PDT)
From: "NeilBrown" <neilb@suse.de>
Date: Wed, 26 Mar 2008 08:38:22 +1100 (EST)
Message-ID: <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
In-Reply-To: <20080325212425.GA20257@josefsipek.net>
References: <47CF62C5.7000908@m2000.com>
    <18384.50909.866848.966192@notabene.brown>
    <9a8748490803121513w285cd45rb6b26a3d842cac1b@mail.gmail.com>
    <20080312221511.GC31632@fieldses.org>
    <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com>
    <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com>
    <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org>
    <32953.192.168.1.70.1206477121.squirrel@neil.brown.name>
    <20080325212425.GA20257@josefsipek.net>
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, lkml@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

On Wed, March 26, 2008 8:24 am, Josef 'Jeff' Sipek wrote:

> Unless you specify the "ikeep" mount option, XFS will remove unused inode
> clusters.  The newly freed blocks can be then used to store data or
> possibly
> a new inode cluster.  If the blocks get reused for inodes, you'll end up
> with inodes whose generation numbers regressed. (inode number = f(block
> number))
>
> Using the "ikeep" mount option causes to _never_ free empty inode
> clusters.
> This means that if you create many files and then unlink them, you'll end
> up
> with many unused inodes that are still allocated (and taking up disk
> space)
> but free to be used by the next creat(2)/mkdir(2)/etc..
>
> This "problem" is inherent to any file system which dynamically allocates
> inodes.

Yes, I understand all that.

However you still need to do something about the generation number.  It
must be set to something.

When you allocate an inode that doesn't currently exist on the device,
you obviously cannot increment the old value and use that.
However you can do a lot better than always using 0.

The simplest would be to generate a 'random' number (get_random_bytes).
Slightly better would be to generate a random number at boot time
and use that, incrementing it each time it is used to set the
generation number for an inode.

Even better would be store store that 'next generation number' in the
superblock so there would be even less risk of the 'random' generation
producing repeats.
This is what ext3 does.  It doesn't dynamically allocate inodes,
but it doesn't want to pay the cost of reading an old inode from
storage just to see what the generation number is.  So it has
a number in the superblock which is incremented on each inode allocation
and is used as the generation number.

Certainly anything would be better than always using the same number.

NeilBrown
