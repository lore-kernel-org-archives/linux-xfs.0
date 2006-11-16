Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 14:01:12 -0800 (PST)
Received: from cuda.sgi.com (cuda0.sgi.com [192.48.168.32])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGM17aG018832
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:01:08 -0800
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA912DB68AC4
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 11:00:32 -0800 (PST)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kAGJ0Wjk007231
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:00:32 -0500
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAGJ0VGl022127
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:00:31 -0500
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kAGJ0VbI004433
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 14:00:31 -0500
Message-ID: <455CB54F.8080901@sandeen.net>
Date: Thu, 16 Nov 2006 13:00:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

see also https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=212201

Bugzilla Bug 212201: Cannot build sysem with XFS file system.

I turned on attr2 in FC6 at nathan's suggestion, for selinux goodness 
with more efficient xattr space usage.

But, many reports that this was totally broken in fc6, on x86_64.

Install went ok, but on reboot the filesystem was found to be corrupt.

The filesystem was also found to be marked w/ attr1, not attr2....

If you do a fresh mkfs.xfs on x86_64, with -i attr=2, and dump out the
superblock (or look at it with xfs_db) you will find that although the
versionnum says that there is a morebits bit, the features2 flag is 0.

if you dd/hexdump the superblock, you will find the attr2 flag, but at
the wrong offset.

This is because the xfs_sb_t struct is padded out to 64 bits on 64-bit
arches, and the xfs_xlatesb() routine and xfs_sb_info[] array take this
padding to mean that the last item is 4 bytes bigger than it is, and
treats sb_features2 as 8 bytes not four.  This then gets endian-flipped out...

I can't quite figure out how this winds up causing problems if you stay
on the x86_64 arch, as I'd expect that if the offset is wrong, it should
at least be consistently wrong.  And in fact if you do mkfs,mount,xfs_info,
it will tell you that you do have attr2. But somewhere along the line thing
go wrong, and post-install, post-reboot, the filesystem thinks it is attr1,
and is therefore corrupt.

I think that maybe some accesses are post-xfs_xlatesb, while others
may access the un-flipped sb directly?  Or maybe this is sb logging
code that has messed things up?  Not sure... needs more investigation.

In any case, dd does not lie, and this patch for the kernel, and a 
corresponding one for userspace, at least make "mkfs.xfs -i attr=2" 
puts the features2 flag in the right place, as shown by inspection via dd.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux-2.6.18/fs/xfs/xfs_sb.h
===================================================================
--- linux-2.6.18.orig/fs/xfs/xfs_sb.h
+++ linux-2.6.18/fs/xfs/xfs_sb.h
@@ -149,7 +149,7 @@ typedef struct xfs_sb
 	__uint16_t	sb_logsectsize;	/* sector size for the log, bytes */
 	__uint32_t	sb_logsunit;	/* stripe unit size for the log */
 	__uint32_t	sb_features2;	/* additional feature bits */
-} xfs_sb_t;
+} __attribute__ ((packed)) xfs_sb_t;
 
 /*
  * Sequence number values for the fields.
