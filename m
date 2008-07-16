Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Jul 2008 19:38:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6G2ctap012031
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:38:55 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0630AE28C74
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:40:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Jp7wkW3YmNvSMGDH for <xfs@oss.sgi.com>; Tue, 15 Jul 2008 19:40:02 -0700 (PDT)
Message-ID: <487D5F80.1050909@sandeen.net>
Date: Tue, 15 Jul 2008 21:40:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Power loss causes bad magic number??
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephen Porter <stephenp@r-s.com.au>
Cc: xfs@oss.sgi.com

Stephen Porter wrote:
> Hello,
> 
> Hoping someone may be able to offer some advice/assistance.
> 
> I lost power twice (within a few hours) to my machine which had a ~2.2TB
> XFS volume on it.  The first time the machine (running Xubuntu 8.04)
> came back up ok, the second time the XFS volume will not mount.  Is
> there any chance of recovering the data? /dev/sdc is seen by xubuntu as
> one ~2.2TB disk, and I put the XFS file system straight onto the disk.
> It's 4x750GB drives on a hardware raid controller (rocketraid 2320).
> Driver/module for rocket raid (rr232x) is loaded ok.

hm, not an in-kernel driver, I guess?

> In the system log I see:
> 
> XFS: bad magic number
> 
> XFS: SB validate failed
> 
> I tried running xfs_check, the result of this was:
> 
> xfs_check /dev/sdc
> xfs_check: unexpected XFS SB magic number 0x33c08ed0
> xfs_check: size check failed
> xfs_check: read failed: Invalid argument
> xfs_check: data size check failed
> xfs_check: failed to alloc -225176656 bytes: Cannot allocate memory
> 
> I looked at running xfs_repair, but the man page states that this will
> only work on a volume that has been unmounted cleanly... as I lost power
> the volume has not been unmounted cleanly, but I cannot mount it again
> to unmount it cleanly.

If you have to, you can zero the log w/ xfs_repair as a last resort.

> Running xfs_repair gives the following:
> 
> xfs_repair -n /dev/sdc
> 
> Phase 1 - find and verify superblock...
> 
> bad primary superblock - bad magic number !!!
> 
> ...attempting to find secondary superblock...
> 
> ...found candidate secondary superblock... unable to verify superblock,
> continuing...

I always wished it said where, and why it did not verify....

> (the above appears a few times, until finally)
> 
> ...Sorry, could not find valid secondary superblock
> 
> Exiting now.
> 
> I've seen it mentioned in other posts to the xfs archive to check that
> there is an xfs volume there, so I've also included the output of "dd
> if=/dev/sdc bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x" below:
> 
> $ dd if=/dev/sdc bs=512 count=1 iflag=direct 2> /dev/null | od -Ax -x
> 
> 000000 c033 d08e 00bc fb7c 0750 1f50 befc 7c1b
> 000010 1bbf 5006 b957 01e5 a4f3 bdcb 07be 04b1


Can you try piping it through "hexdump -C" instead, I'm more used to
eyeballing that output :)

You might also try looking a bit further:

dd if=/dev/sdc bs=512 count=128 iflag=direct | hexdump -C | grep XFSB

to see if maybe the raid card does something else at the front of your
disk and the superblock is further in, and something got scrambled up?
Just a longshot....

-Eric
