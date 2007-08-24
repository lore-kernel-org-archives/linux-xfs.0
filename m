Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 20:59:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O3xb4p025116
	for <linux-xfs@oss.sgi.com>; Thu, 23 Aug 2007 20:59:41 -0700
Message-ID: <46CE581A.2000405@sgi.com>
Date: Fri, 24 Aug 2007 14:01:30 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 969192: Default mount option "noikeep" makes the inode generation
 number non-persistent
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com

XFS inodes are dynamically allocated on demand, rather than being allocated
at mkfs time. Chunks of 64 inodes are allocated at once, but they are
never freed. Over time, this can lead to filesystem fragmentation, clusters
of inodes and the btrees which point at them can be scattered around the
system.

By freeing clusters as they are emptied, we reduce fragmentation of the
free space after removing files. This in turn allows us to make better
placement decisions when repopulating a filesystem. The XFSMNT_IDELETE
mount option enables freeing clusters when they get empty.

Unfortunately a side effect of freeing inode clusters is that the inode
generation numbers of such inodes would be reset to zero when the cluster
is reclaimed. This is a problem in particular for a DMAPI enabled filesystem
as the the DMAPI handles need to be unique and persistent in time. An unique
DMAPI handle is built with the help of the inode generation number. When the
last one is prematurely reset by an inode cluster reclaim, there is
a high probability of different generation inodes to end up having identical
DMAPI handles.

To avoid the problem with identical DMAPI handles, the XFSMNT_IDELETE mount
option should be set as default, only if the filesystem is not mounted with
XFSMNT_DMAPI.

Date:  Fri Aug 24 13:54:57 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs
Inspected by:  dgc, markgw
Author:  vapo

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29486a
fs/xfs/xfs_vfsops.c - 1.527 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.527&r2=text&tr2=1.526&f=h
        - pv 969192, rv dgc, markgw - Imply "ikeep" default mount option 
for DMAPI enabled filestems.
