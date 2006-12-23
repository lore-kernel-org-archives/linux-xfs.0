Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 15:09:58 -0800 (PST)
Received: from cfa.harvard.edu (cfa.harvard.edu [131.142.10.1])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBNN9qqw029292
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 15:09:53 -0800
Date: Sat, 23 Dec 2006 18:08:58 -0500 (EST)
From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Subject: Re: unexpected XFS SB magic number
In-Reply-To: <458C6C5A.6090504@sandeen.net>
Message-ID: <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu>
 <458C6719.6080106@sandeen.net> <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu>
 <458C6C5A.6090504@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

Hi, Eric,

RE:
> it looks like you wound up with an efi bootloader splatted over the
> front of your partition.  maybe the raid got scrambled around?  Or maybe
> someone actually installed a bootloader over an otherwise-ok filesystem?
>   hard to say.  not sure what could have prevented either of those.

To summarize; this is a hardware RAID-6 (and not a RAID-5 as I wrote
earlier) of 12 x 500Gb disks, thus the size is 5Tb.
The RAID card is an ARECA 1130-ML card.
The computer runs FC5 with 2.6.17-6 (kernel.org) kernel.
It was quite stable for 4 monhts.

I remember originally there was a problem with partitioning. fdisk
could not handle the 5Tb partition size (I needed one big partition, it
was out of question to split it up).

Then per recommendation of someone from another list, I used gparted
and set the partition type to GPT. This indeed made the job, and I was
able to create a 5Tb partition.
mkfs.xfs worked fine (xfsprogs-2.7.3-1.2.1)

I can definitely say that the RAID was not scrambled around.
There are only few users on this computer, and only one superuser
(myself) and no physical access to the computer by others.

One of the users was running quite memory and disk IO intensive tasks
past week. This lead to a crash. (I was not around to keep an eye on
it). The computer rebooted, and few days later another crash, etc.
Finally, when I returned this week, I found it powered off.

And then I realized that the sdc1 partition can not be mounted any more.

> i also remember something about parted (maybe...) finding a backup gpt
> signature at the end of a disk, and "helpfully" copying it over the
> front end if so.  This was a bug.  sgi guys do you remember?

But for this one has to invoke parted, and commit the operations done,
am I right?
Maybe there is a nasty daemon doing something. The fs was also exported
as NFS and mounted by two other hosts.

---------
So the questions are:
- what partition type to choose next time?
- is there a simpler way of recovery (than xfs_recovery), i.e. the
  first few bytes of the partition need to be changed back to something
  XFS magic, and the rest is probably untouched?

Cheers
Gaspar
