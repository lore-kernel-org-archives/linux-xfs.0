Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n06G6juP026629 for <xfs@oss.sgi.com>; Tue, 6 Jan 2009 10:06:45 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A67D566395
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2009 08:06:44 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Wo3ciQXdCoOLFTKR for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2009 08:06:44 -0800 (PST)
Message-ID: <49638190.3070803@sandeen.net>
Date: Tue, 06 Jan 2009 10:06:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: need help to repair XFS partition
References: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
In-Reply-To: <b75ef8170901060111l52b9a803uf31dc7baa80df721@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Gergely Soos <sogerc1@gmail.com>
Cc: xfs@oss.sgi.com

Gergely Soos wrote:
> Greetings
> 
> I heard that people compliment XFS for being the fastest FS these days
> so I thought I give it a try.
> What I did was that I converted my old 107GB FAT32 partition to XFS (I
> created an XFS over it) and I wanted to use it as /home
> Everything went as it should, I moved the files from my old /home then I
> restarted (cleanly!) under windows.
> When I got back from windows I was no longer able to mount the XFS
> partition.

Which partition was it?  I wonder if a gpt label got re-written over it
or something.

> xfs_repair only said that the superblock is invalid and attempts to find
> secondary superblocks but all candidates fail.
> So I created a file on another computer with the exact same size as the
> partition on my computer and created an XFS on it.

> Then I extracted the first 512 bytes and copied to my HDD using dd. But
> it complained about the UUID so I corrected it using khexedit.

Did you keep the original first 512 bytes?  It would be worth looking
at; try hexdump -C on it (the original) and send that if you have it.

> Then xfs_db complained that it cannot find the root inode so I wrote a
> little perl script to search it.
> You can find it in myxfs.tar.bz2. It seems that it found the root inode
> because after I corrected the address using khexedit
> xfs_db started complaining about the realtime bitmap inodes, so I
> corrected those too (using inode numbers rootino+1 and rootino+2).
> And this is where I'm stuck.
> The mount still fails, dmesg says that it cannot find the root inode,
> xfs_repair says the same old thing, xfs_check says a lot of things,
> most of them are messages like this: can't seek in filesystem at bb
> <some numbers> or: ag bad magick number.
> That exceeds my knowledge.
> Please help me restore the partition, It contains lots of programmes I
> wrote over the years and some of them are not backed up,
> some of them are, but only an older version. I also have personal stuff
> on it like my bill records that I cannot recover from anywhere else.
> myxfs.tar.bz2 contains the perl script I mentioned above and the inodes
> it found. The one staring with ri is the root inode,
> the files starting with sb are the suspected superblocks (I also took
> one of those at random and corrected the three inode numbers
> with khexedit but the result is the same) and the file backup_bootsect
> contains the original superblock that was on the disk after I came back
> from windows xp. It does not look like anything to me...
> The numbers after ri and sb are the starting address in bytes of the
> inode on the disk.
> I would also attach the output of xfs_metadump which I created after I
> corrected the three inode numbers in the superblock but even bzip-ed
> it is more than 3MB and the administrator of this list does not accept it.

As Chris suggested, I would find a spare 100G somewhere and make a dd
image now, so you have something to experiment with + a backup if things
go wrong.

It sounds like something under windows clobbered your filesystem, I
guess, unless it's the gpt thing I mentioned, it's very strange.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
