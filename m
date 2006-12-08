Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Dec 2006 07:45:18 -0800 (PST)
Received: from bay0-omc1-s31.bay0.hotmail.com (bay0-omc1-s31.bay0.hotmail.com [65.54.246.103])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB8FjBqw021325
	for <xfs@oss.sgi.com>; Fri, 8 Dec 2006 07:45:12 -0800
Message-ID: <BAY116-W64E893DB16B1A8692B9FDC9D30@phx.gbl>
From: Dennis Varouxis <dennisvarouxis@hotmail.com>
Subject: Unable to mount XFS partition on Sun Ultra/Linux 2.6.17 - Function
 not implemented
Date: Fri, 8 Dec 2006 15:32:19 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I've got an ailing SGI which currently doesn't boot, so I plucked the disk out
and slotted it into my Sun box to snoop around. Unfortunately despite my
best technical and google skills I haven't been able to resolve this.

Attempting to mount the main disk partition with a simple "mount -t xfs
/dev/sda1 /mnt/sgidisk" yields only "mount: Function not implemented".

That's it, that's all I've got. Except that I know from debugging mount that the mount
syscall raises errno 90, which goes into strerror() which returns the "not
implemented" message.

It's a SCSI disk formatted to XFS by IRIX. IRIX and linux XFS are reportedly disk
compatible so I don't see a problem there. There's a boot partition (1), a swap
partition (2), and the 9 and 11 partitions used for the SGI disk label.

The host system is a Sun Ultra 5 (sparc64 sun4u) with an Adaptec aix7xxx
controller, running Gentoo Linux kernel 2.6.17-r8. The kernel has been built
with SGI partition map support. I've got the aic7xxx and xfs drivers compiled as modules 
and set to autoload (I've tried with built-in versions as well and get the same result).

The kernel at this point has been compiled with debug enabled and with CONFIG_XFS_DEBUG=y. 
The XFS driver confirms this in dmesg:

"SGI XFS with ACLs, security attributes, large block/inode numbers, debug
enabled
SGI XFS Quota Management subsystem"

However when I mount there's nothing emitted in /var/log/messages.

Note the partition type says "SGI efs". However trying to mount -t efs fails
with the expected "mount: wrong fs type". (EFS compiled as a module and
modprobed).

The output from xfs_db which admittedly doesn't mean much, to me at least,  is:

azrael ~ # xfs_db -c sb -c p /dev/sda1
magicnum = 0x58465342
blocksize = 4096
dblocks = 491395
rblocks = 0
rextents = 0
uuid = dbfdfd61-f556-1021-8e74-0800690ac5d3
logstart = 262148
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 16
agblocks = 61425
agcount = 8
rbmblocks = 0
logblocks = 1000
versionnum = 0x1094
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 16
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 35648
ifree = 1636
fdblocks = 164789
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 0

Also interesting is the output from xfs_check:

"ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_check."

Although this indicates that the filesystems should at least be mountable.

Any help would be appreciated - what am I missing? Is there somewhere else
that the kernel and/or the xfs driver would log their debug messages?


thanks

dennis


features2 = 0

_________________________________________________________________
Be one of the first to try Windows Live Mail.
http://ideas.live.com/programpage.aspx?versionId=5d21c51a-b161-4314-9b0e-4911fb2b2e6d
