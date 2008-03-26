Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 20:27:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2Q3R2aP008192
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 20:27:05 -0700
Message-ID: <47E9C29E.6090703@sgi.com>
Date: Wed, 26 Mar 2008 14:27:26 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [opensuse] nfs_update_inode: inode X mode changed, Y to Z
References: <47CF62C5.7000908@m2000.com>    <18384.50909.866848.966192@notabene.brown>    <9a8748490803121513w285cd45rb6b26a3d842cac1b@mail.gmail.com>    <20080312221511.GC31632@fieldses.org>    <9a8748490803121516u36395872i70cc88b0439adc74@mail.gmail.com>    <18394.1501.991087.80264@notabene.brown> <47DAEFD0.9020407@m2000.com>    <47E92F8E.7030504@m2000.com> <20080325190943.GF2237@fieldses.org>    <32953.192.168.1.70.1206477121.squirrel@neil.brown.name>    <20080325212425.GA20257@josefsipek.net> <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
In-Reply-To: <34178.192.168.1.70.1206481102.squirrel@neil.brown.name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: NeilBrown <neilb@suse.de>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, "J. Bruce Fields" <bfields@fieldses.org>, xfs@oss.sgi.com, Adam Schrotenboer <adam@m2000.com>, Jesper Juhl <jesper.juhl@gmail.com>, Trond Myklebust <trond.myklebust@netapp.com>, lkml@vger.kernel.org, linux-nfs@vger.kernel.org, Thomas Daniel <tdaniel@m2000.com>, Frederic Revenu <frevenu@m2000.com>, Jeff Doan <jdoan@m2000.com>

Hi Neil,

NeilBrown wrote:
> On Wed, March 26, 2008 8:24 am, Josef 'Jeff' Sipek wrote:
> 
>> Unless you specify the "ikeep" mount option, XFS will remove unused inode
>> clusters.  The newly freed blocks can be then used to store data or
>> possibly
>> a new inode cluster.  If the blocks get reused for inodes, you'll end up
>> with inodes whose generation numbers regressed. (inode number = f(block
>> number))
>>
>> Using the "ikeep" mount option causes to _never_ free empty inode
>> clusters.
>> This means that if you create many files and then unlink them, you'll end
>> up
>> with many unused inodes that are still allocated (and taking up disk
>> space)
>> but free to be used by the next creat(2)/mkdir(2)/etc..
>>
>> This "problem" is inherent to any file system which dynamically allocates
>> inodes.
> 
> Yes, I understand all that.
> 
> However you still need to do something about the generation number.  It
> must be set to something.
> 
> When you allocate an inode that doesn't currently exist on the device,
> you obviously cannot increment the old value and use that.
> However you can do a lot better than always using 0.
> 
Yes, this is a known problem.
We came across it in about August last year I believe in the context of
DMF as it wants to keep persistent file handles with gen#s in them:
   SGI bug:
   969192: Default mount option "noikeep" makes the inode generation number non-persistent
I vaguely remember at the time that a number of different schemes were
tossed around but in the end we just turned off the ikeep
for DMAPI mounted filesystems.
I thought we had a bug open to do a real fix but can't see
it at the moment. Will look into it and discuss with our group.

Cheers,
--Tim
