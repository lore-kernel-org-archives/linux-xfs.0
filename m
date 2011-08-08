Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78A5DUw027705 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 05:05:14 -0500
Received: from fileserver.binf.ku.dk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22C31C53C9
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 03:05:11 -0700 (PDT)
Received: from fileserver.binf.ku.dk (174.binf.ku.dk [130.225.125.174]) by
	cuda.sgi.com with ESMTP id T4OlV2LDI4EZQz2g for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 03:05:11 -0700 (PDT)
Received: from ASSP.nospam (firewall.binf.ku.dk [10.10.0.254])
	by fileserver.binf.ku.dk (Postfix) with ESMTP id D2C62E4367
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 12:05:09 +0200 (CEST)
Received: from pegasus.binf.ku.dk (pegasus.binf.ku.dk [10.10.3.242])
	by fileserver.binf.ku.dk (Postfix) with ESMTPSA
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 12:05:09 +0200 (CEST)
Date: Mon, 8 Aug 2011 12:05:09 +0200 (CEST)
From: Hanne Munkholm <hanne@binf.ku.dk>
Subject: "Corrupt dinode 6242615, (btree extents).  This is a bug."
Message-ID: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
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
To: xfs@oss.sgi.com

Hi list.

I have an xfs file system which got damaged due to not being
properly unmounted before the iSCSI connection terminated (I
think. Corrupted it is).

I cannot mount it. =

mount: wrong fs type, bad option, bad superblock on /dev/sdd,
         missing codepage or helper program, or other error
         In some cases useful info is found in syslog - try
         dmesg | tail  or so

xfs_check suggests running xfs_repair -L. =

ERROR: The filesystem has valuable metadata changes in a log
which needs to be replayed.  Mount the filesystem to replay the log, and
unmount it before re-running xfs_check.  If you are unable to mount the
filesystem, then use the xfs_repair -L option to destroy the log and attemp=
t a
repair.  Note that destroying the log may cause corruption -- please
attempt a mount of the filesystem before doing this.

I haven't done that yet.

Instead I ran
xfs_repair -n.
I got a lot of output that looks promising for a repair IMO, at
least it acknowleges an xfs system beoing there:

xfs_repair -n /dev/sdd
Phase 1 - find and verify superblock...
Phase 2 - using internal log
          - scan filesystem freespace and inode maps...
          - found root inode chunk
Phase 3 - for each AG...
          - scan (but don't clear) agi unlinked lists...
          - process known inodes and perform inode discovery...
          - agno =3D 0
bad nblocks 952 for inode 6242615, would reset to 972
bad nextents 182 for inode 6242615, would reset to 185
imap claims a free inode 13352640 is in use, would correct imap and clear i=
node
imap claims a free inode 13352641 is in use, would correct imap and clear i=
node
<snip>
         - agno =3D 1
          - agno =3D 2
          - agno =3D 3
          - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
          - setting up duplicate extent list...
          - check for inodes claiming duplicate blocks...
          - agno =3D 0
          - agno =3D 3
          - agno =3D 2
          - agno =3D 1
bad nblocks 952 for inode 6242615, would reset to 972
bad nextents 182 for inode 6242615, would reset to 185
entry "sample_000001299840_0_0.000000.pdb" at block 764 offset
2512 in directory inode 6242615 references free inode 13352640
  	would clear inode number in entry at offset 2512...
entry "sample_000001299860_0_0.000000.pdb" at block 764 offset
2560 in directory inode 6242615 references free inode 13352641
<snip>
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
          - traversing filesystem ...
corrupt dinode 6242615, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
corrupt dinode 6242615, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
corrupt dinode 6242615, (btree extents).  This is a bug.
Please capture the filesystem metadata with xfs_metadump and
report it to xfs@oss.sgi.com.
Segmentation fault

But then it fails in phase 6, as shown above.

My questions are now:

a) Does it look like clearing the log with -L would be a good
idea? To me it looks like a lot of errors that are not log
errors is found?

b) What's with the segfault? What happens when the "real" repair
with no -n gets to the segfault? Is it dangerous to try it if it
segfaults somewhere halfway? (More dangerous than it would
normally be).

It is a 6TB file system and I am running a terribly old Xen
kernel: 2.6.26-2-xen-amd64 #1 SMP Mon Jun 13 18:44:16 UTC 2011
x86_64 GNU/Linux

I have placed a xfs_metadump here:
http://people.binf.ku.dk/hanne/tmp/metadata.gz

Thanks in advance for some help in interpreting what the xfs
tools are telling me.

PS We do have some backup so I am not interested in smug
comments about backup :) only in technical help in repairing
this file system or concluding that we cannot).


Med venlig hilsen / Best regards
--
Hanne Munkholm                      Email: hanne@binf.ku.dk
Systemadministrator                 Tlf: +45 35 32 13 49

Bioinformatik-centret
K=F8benhavns Biocenter, Biologisk Institut
Ole Maal=F8es Vej 5, 2200 K=F8benhavn N

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
