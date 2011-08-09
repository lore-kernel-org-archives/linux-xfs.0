Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p798lRm7082972 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 03:47:27 -0500
Received: from fileserver.binf.ku.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9852C151E5D2
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 01:48:46 -0700 (PDT)
Received: from fileserver.binf.ku.dk (174.binf.ku.dk [130.225.125.174]) by
	cuda.sgi.com with ESMTP id vGUbLuzu3RNx6vmx for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 01:48:46 -0700 (PDT)
Date: Tue, 9 Aug 2011 10:47:23 +0200 (CEST)
From: Hanne Munkholm <hanne@binf.ku.dk>
Subject: Re: "Corrupt dinode 6242615, (btree extents).  This is a bug."
In-Reply-To: <20110808235859.GN3162@dastard>
Message-ID: <alpine.OSX.1.00.1108091011030.2688@pegasus.binf.ku.dk>
References: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
	<20110808235859.GN3162@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Thank you very much.

I have my file system running again.

The real problem turned out to be that the device had changed
it's name from sdc to sdd. I have seen that before and should
have noticed. It refused to mount the file system with the same
ID "again" even after xfs_repair because it had not been really
umounted from sdc.

My dmesg was cluttered by a lot of kernel traces instead
of the revealing "Filesystem "sdc": xfs_log_force: error 5
returned." until after the xfs_repair, however, I could see that
the device name had changed and should have known what it meant.

I had to reboot to fix the problem. I now wonder if a reboot
right away had done it, and xfs had happily recovered, or the
xfs_repair was needed. In both cases, the log would have been
lost anyway.

It was the segfault that made me write to the list. I can see
why I got the segfault when running in -n mode, I suspected that
myself, but I wasn't sure, I needed someone to tell me that I
should not panic :).

Now I have one more experience with xfs, and next time someone
googles this they might not have to ask.

Thank you very much for your time.

Med venlig hilsen / Best regards
--
Hanne Munkholm                      Email: hanne@binf.ku.dk
Systemadministrator                 Tlf: +45 35 32 13 49

Bioinformatik-centret
K=F8benhavns Biocenter, Biologisk Institut
Ole Maal=F8es Vej 5, 2200 K=F8benhavn N



On Tue, 9 Aug 2011, Dave Chinner wrote:

> On Mon, Aug 08, 2011 at 12:05:09PM +0200, Hanne Munkholm wrote:
>> Hi list.
>>
>> I have an xfs file system which got damaged due to not being
>> properly unmounted before the iSCSI connection terminated (I
>> think. Corrupted it is).
>>
>> I cannot mount it. mount: wrong fs type, bad option, bad superblock
>> on /dev/sdd,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so
>
> That is the default error message from mount when the kernel throws
> and error. The error message in dmesg will tell you exactly what the
> error was - can you post that?
>
>> xfs_check suggests running xfs_repair -L. ERROR: The filesystem has
>> valuable metadata changes in a log
>> which needs to be replayed.  Mount the filesystem to replay the log, and
>> unmount it before re-running xfs_check.  If you are unable to mount the
>> filesystem, then use the xfs_repair -L option to destroy the log and att=
empt a
>> repair.  Note that destroying the log may cause corruption -- please
>> attempt a mount of the filesystem before doing this.
>>
>> I haven't done that yet.
>
> You won't be able to because mounting is failing. Hence you only
> option for recovery is to use xfs_repair -L to zero the log.
>
>> Instead I ran
>> xfs_repair -n.
>> I got a lot of output that looks promising for a repair IMO, at
>> least it acknowleges an xfs system beoing there:
>>
>> xfs_repair -n /dev/sdd
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>          - scan filesystem freespace and inode maps...
>>          - found root inode chunk
>> Phase 3 - for each AG...
>>          - scan (but don't clear) agi unlinked lists...
>>          - process known inodes and perform inode discovery...
>>          - agno =3D 0
>> bad nblocks 952 for inode 6242615, would reset to 972
>> bad nextents 182 for inode 6242615, would reset to 185
>> imap claims a free inode 13352640 is in use, would correct imap and clea=
r inode
>> imap claims a free inode 13352641 is in use, would correct imap and clea=
r inode
>> <snip>
>>         - agno =3D 1
>>          - agno =3D 2
>>          - agno =3D 3
>>          - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>          - setting up duplicate extent list...
>>          - check for inodes claiming duplicate blocks...
>>          - agno =3D 0
>>          - agno =3D 3
>>          - agno =3D 2
>>          - agno =3D 1
>> bad nblocks 952 for inode 6242615, would reset to 972
>> bad nextents 182 for inode 6242615, would reset to 185
>> entry "sample_000001299840_0_0.000000.pdb" at block 764 offset
>> 2512 in directory inode 6242615 references free inode 13352640
>>  	would clear inode number in entry at offset 2512...
>> entry "sample_000001299860_0_0.000000.pdb" at block 764 offset
>> 2560 in directory inode 6242615 references free inode 13352641
>> <snip>
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>          - traversing filesystem ...
>> corrupt dinode 6242615, (btree extents).  This is a bug.
>
> That's one of the inodes that has already been found to be bad, and
> woul dhave had parts of it fixed before getting to phase 6. Hence
> this problem may have already been fixed by this stage.
>
>> Please capture the filesystem metadata with xfs_metadump and
>> report it to xfs@oss.sgi.com.
>> corrupt dinode 6242615, (btree extents).  This is a bug.
>> Please capture the filesystem metadata with xfs_metadump and
>> report it to xfs@oss.sgi.com.
>> corrupt dinode 6242615, (btree extents).  This is a bug.
>> Please capture the filesystem metadata with xfs_metadump and
>> report it to xfs@oss.sgi.com.
>> Segmentation fault
>
> And the chance is that this won't happen.
>
>> I have placed a xfs_metadump here:
>> http://people.binf.ku.dk/hanne/tmp/metadata.gz
>
> Downloading it now. it's about 550MB, so will take a little while...
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
