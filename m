Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 19:54:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5D2s5Wt007406
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 19:54:07 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA26301; Wed, 13 Jun 2007 12:53:58 +1000
Message-ID: <466F5C45.6040306@sgi.com>
Date: Wed, 13 Jun 2007 12:53:57 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: XFS with project quota under linux?
References: <950DD867A5E1B04ABE82A56FCDC03A5E9CE8CF@HDHS0111.euro1.voith.net>
In-Reply-To: <950DD867A5E1B04ABE82A56FCDC03A5E9CE8CF@HDHS0111.euro1.voith.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Jahnke, Steffen" <Steffen.Jahnke@vs-hydro.com>
Cc: xfs@oss.sgi.com

Jahnke, Steffen wrote:
> I recently switched the quota usrquota to pquota on our Altix 4700 under SLES10. 
> I then found out that the project quota is not updated if files are moved within 
> the same filesystem. E.g. if I move a file from a different project to a new project 
> it still belongs to the old project. The same thing happens if I move a file which not 
> belongs to any project but which is on the filesystem mounted with pquota.
> 
> Some details of our system:
> 
> hdhu0250:/home/t # cat /etc/*release
> LSB_VERSION="core-2.0-noarch:core-3.0-noarch:core-2.0-ia64:core-3.0-ia64"
> SGI ProPack 5SP1 for Linux, Build 501r2-0703010508
> SUSE Linux Enterprise Server 10 (ia64)
> VERSION = 10

Hi Steffen,

I've checked and Nathan fixed this bug back in January. The fix is in
mainline and will ship in Sles10sp1 when it releases.

 > Any help would be very appreciated. Maybe there is a developer version
 > which is already to be able to handle pquota correctly?

If you're not able to upgrade to sp1 but don't mind rebuilding the kernel.
the following patch will solve your problem.

Donald


Date: Mon, Jan 15 2007 14:32:14 +1100
Subject: Fix a project quota space accounting leak on rename.

===========================================================================
Index: xfs_rename.c
===========================================================================

--- a/fs/xfs/xfs_rename.c       2007-01-15 14:32:15.000000000 +1100
+++ b/fs/xfs/xfs_rename.c       2007-01-15 14:32:15.000000000 +1100
@@ -316,6 +316,18 @@ xfs_rename(
                 }
         }

+       /*
+        * If we are using project inheritance, we only allow renames
+        * into our tree when the project IDs are the same; else the
+        * tree quota mechanism would be circumvented.
+        */
+       if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+                    (target_dp->i_d.di_projid != src_ip->i_d.di_projid))) {
+               error = XFS_ERROR(EXDEV);
+               xfs_rename_unlock4(inodes, XFS_ILOCK_SHARED);
+               goto rele_return;
+       }
+
         new_parent = (src_dp != target_dp);
         src_is_directory = ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR);


===========================================================================
Index: xfs_vnodeops.c
===========================================================================

--- a/fs/xfs/xfs_vnodeops.c     2007-01-15 14:32:15.000000000 +1100
+++ b/fs/xfs/xfs_vnodeops.c     2007-01-15 14:32:15.000000000 +1100
@@ -2663,7 +2663,7 @@ xfs_link(
          */
         if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
                      (tdp->i_d.di_projid != sip->i_d.di_projid))) {
-               error = XFS_ERROR(EPERM);
+               error = XFS_ERROR(EXDEV);
                 goto error_return;
         }
