Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Dec 2007 08:50:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB6GoW5g000647
	for <xfs@oss.sgi.com>; Thu, 6 Dec 2007 08:50:34 -0800
Received: from hobbit.corpit.ru (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 443A4AED0CC
	for <xfs@oss.sgi.com>; Thu,  6 Dec 2007 08:40:04 -0800 (PST)
Received: from hobbit.corpit.ru (hobbit.corpit.ru [81.13.94.6]) by cuda.sgi.com with ESMTP id YZC2orqAp5qZCiMR for <xfs@oss.sgi.com>; Thu, 06 Dec 2007 08:40:04 -0800 (PST)
Message-ID: <475825C0.4070605@msgid.tls.msk.ru>
Date: Thu, 06 Dec 2007 19:39:28 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
MIME-Version: 1.0
Subject: Re: assemble vs create an array.......
References: <474F869D.5040503@mpigani.org> <18255.41044.614676.410107@notabene.brown> <47501D7E.7000804@dgreaves.com> <475552D2.4000802@mpigani.org> <47568DE1.1050108@dgreaves.com> <4758129D.40600@mpigani.org>
In-Reply-To: <4758129D.40600@mpigani.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dragos <dragos@mpigani.org>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org, xfs@oss.sgi.com

[Cc'd to xfs list as it contains something related]

Dragos wrote:
> Thank you.
> I want to make sure I understand.

[Some background for XFS list.  The talk is about a broken linux software
raid (the reason for breakage isn't relevant anymore).  The OP seems to
lost the order of drives in his array, and now tries to create new array
ontop, trying different combinations of drives.  The filesystem there
WAS XFS.  One point is that linux refuses to mount it, saying
"structure needs cleaning".  This all is mostly md-related, but there
are several XFS-related questions and concerns too.]

> 
> 1- Does it matter which permutation of drives I use for xfs_repair (as
> long as it tells me that the Structure needs cleaning)? When it comes to
> linux I consider myself at intermediate level, but I am a beginner when
> it comes to raid and filesystem issues.

The permutation DOES MATTER - for all the devices.
Linux, when mounting an fs, only looks at the superblock of the filesystem,
which is usually located at the beginning of the device.

So in each case linux actually recognizes the filesystem (instead of
seeing complete garbage), the same device is the first one - I.e, this
way you found your first device.  The rest may be still out of order.

Raid5 data is laid like this (with 3 drives for simplicity, it's similar
with more drives):

       DiskA       DiskB       DiskC
Blk0   Data0       Data1       P0
Blk1   P1          Data2       Data3
Blk2   Data4       P2          Data5
Blk3   Data6       Data7       P3
... and so on .......................

where your actual data blocks are Data0, Data1, ... DataN,
and PX are parity blocks.

As long as DiskA remains in this position, the beginning of
the array is Data0 block, -- hence linux sees the beginning
of the filesystem and recognizes it.  But you can switch
DiskB and DiskC still, and the rest of the data will be
complete garbage, only data blocks on DiskA will be in
place.

So you still need to find order of the other drives
(you found your first drive, DriveA, already).

Note also that if Data1 block is all-zeros (a situation
which is unlikely for a non-empty filesystem), P0 (first
parity block) will be exactly the same as Data0, because
XORing anything with zeros gives the same "anything" again
(XOR is the operation used to calculate parity blocks in
RAID5).  So there's still a remote chance you've TWO
"first" disks...

What to do is to give repairfs a try for each permutation,
but again without letting it to actually fix anything.
Just run it in read-only mode and see which combination
of drives gives less errors, or no fatal errors (there
may be several similar combinations, with the same order
of drives but with different drive "missing").

It's sad that xfs refuses mount when "structure needs
cleaning" - the best way here is to actually mount it
and see how it looks like, instead of trying repair
tools.  Is there some option to force-mount it still
(in readonly mode, knowing it may OOPs kernel etc)?

I'm not very familiar with xfs yet - it seems to be
much faster than ext3 for our workload (mostly databases),
and I'm experimenting with it slowly.  But this very
thread prompted me to think.  If I can't force-mount it
(or browse it using other ways) as I can almost always
do with (somewhat?) broken ext[23] just to examine things,
maybe I'm trying it before it's mature enough? ;)  Note
the smile, but note there's a bit of joke in every joke... :)

> 2- After I do it, assuming that it worked, how do I reintegrate the
> 'missing' drive while keeping my data?

Just add it back -- mdadm --add /dev/mdX /dev/sdYZ.
But don't do that till you actually see your data.

/mjt
