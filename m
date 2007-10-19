Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 18:23:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9J1NLnq003701
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 18:23:23 -0700
Message-ID: <47180769.6070200@sgi.com>
Date: Fri, 19 Oct 2007 11:24:57 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: TAKE 972004 - Make xfs_bulkstat() to report unlinked but referenced
 inodes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs mailing list <xfs@oss.sgi.com>

Make xfs_bulkstat() to report unlinked but referenced inodes

We need xfs_bulkstat() to report inode stat for inodes with
link count zero but reference count non zero.

The fix here:


changed this behavior and made xfs_bulkstat() to filter all
unlinked inodes including those that are not destroyed yet but
held by reference.

The attached patch returns back to the original behavior by
marking the on-disk inode buffer "dirty" when di_mode is cleared
(at that time both inode link and reference counter are zero).


Date:  Fri Oct 19 11:21:26 AEST 2007
Workarea:  soarer.melbourne.sgi.com:/home/vapo/isms/linux-xfs1
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29914a
fs/xfs/xfs_itable.c - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
    - pv 972004, rv dgc - Make xfs_bulkstat() to report unlinked but 
referenced inodes

fs/xfs/xfs_inode.c - 1.484 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.484&r2=text&tr2=1.483&f=h
    - pv 972004, rv dgc - Make xfs_bulkstat() to report unlinked but 
referenced inodes
