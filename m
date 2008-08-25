Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Aug 2008 20:25:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7P3P1N2028282
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 20:25:01 -0700
Received: from larry.melbourne.sgi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id CC3A3FAF57F
	for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 20:26:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130]) by cuda.sgi.com with SMTP id x9BU1go9UiRBbiFJ for <xfs@oss.sgi.com>; Sun, 24 Aug 2008 20:26:22 -0700 (PDT)
Message-ID: <48B22659.9050301@sgi.com>
Date: Mon, 25 Aug 2008 13:26:17 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: agi unlinked bucket
References: <alpine.DEB.1.10.0808230017150.20126@sheep.housecafe.de> <alpine.DEB.1.10.0808231412230.20126@sheep.housecafe.de> <20080825003929.GN5706@disturbed> <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.10.0808250254380.26780@sheep.housecafe.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Christian Kujau wrote:
> On Mon, 25 Aug 2008, Dave Chinner wrote:
>> If you do a mount then unmount then rerun xfs-check, does it go
>> away?
> 
> Did that a few times already, and the fs is getting mounted during boot
> anyway, but xfs_check still complains:
> 
> --------------------------------------
> # xfs_check /dev/mapper/md3 2>&1 | tee fsck_md3.log
> agi unlinked bucket 26 is 20208090 in ag 0 (inode=20208090)
> link count mismatch for inode 128 (name ?), nlink 335, counted 336
> link count mismatch for inode 20208090 (name ?), nlink 0, counted 1
> # mount /mnt/md3
> # dmesg | tail -2
>  XFS mounting filesystem dm-3
>  Ending clean XFS mount for filesystem: dm-3
> # grep xfs /proc/mounts
> /dev/mapper/md3 /mnt/md3 xfs ro,nosuid,nodev,noexec,nobarrier,noquota 0 0
> --------------------------------------
> 
> 
> The fs is ~138 GB in size. I shall run a backup and then just let
> xfs_repair have its way. I just thought you guys might have an idea what
> these messages are about and why mounting the fs (Thanks, Dave) does not
> seem to care.
> 
The file systems is divided up into allocation groups, AGs.
In each AG we have an unlinked list which is a hash table array
whose elements (often called buckets) can point to a linked list
of inodes. There is a next unlinked pointer in each inode.
The list is used to represent unlinked inodes (inodes removed from directories)
but are still referenced by processes. If we don't have a clean
unmount then the unlinked lists may not be empty and we have to remove
the inodes on the next mount (done at the same stage as log replay) by
traversing the lists.
So in your case, it looks like in AG#0 on the 26th element of the array it is pointing
to inode# 20208090. Which would infer that inode#20208090 was unlinked
but still had references to it at the time the filesystem was not cleanly
unmounted (power loss, crash etc..). It looks like for the root directory inode #128
it has a count of 335 but it is finding 336 entries.
And for inode#20208090 it has a link count of 0 and yet it has 1 entry
in the directory. It's as if the inode was deleted (its link count decremented
to zero and its parent directory decremented, unlinked list updated)
but the directory wasn't updated properly.

Hence Dave's comments:
> Ok, so if you do a 'ls -i /' do you see an inode numbered 20208090?
> i.e. is it the unlinked bucket that is incorrect, or the root
> directory.
> You are not using barriers. Are you using write caching? The
> problems with filesystem corruption on powerloss when using volatile
> write caching have traditionally shown up in directory
> corruptions...


--Tim
