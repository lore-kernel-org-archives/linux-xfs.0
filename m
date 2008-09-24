Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:45:04 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8j083009443
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:45:01 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 5679C3040B3
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:46:35 -0700 (PDT)
Received: from pc-bnaujok.melbourne.sgi.com (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA02635 for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:46:33 +1000
Date: Wed, 24 Sep 2008 18:47:35 +1000
Subject: REVIEW: Don't reset dirty inode flag in xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-ID: <op.uhy9dlyz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

If an inode is dirtied due to some error in an inode, the very last
check (nlink version) in process_dinode_int() in xfs_repair sets the
dirty flag rather than just bumping it if it dirtied the inode.

So, if something earlier dirtied the inode without marking it bad
(eg. resetting the inode's next unlinked field in the example that
detected this issue), that dirty state will be lost if the nlink
version checks out fine.


===========================================================================
xfsprogs/db/check.c
===========================================================================

--- a/xfsprogs/db/check.c       2008-09-24 18:30:53.000000000 +1000
+++ b/xfsprogs/db/check.c       2008-09-24 18:04:48.215871460 +1000
@@ -2689,6 +2689,12 @@ process_inode(
                 }
                 return;
         }
+       if (be32_to_cpu(dip->di_next_unlinked) != NULLAGINO) {
+               if (!sflag || isfree || id->ilist || CHECK_BLIST(bno))
+                       dbprintf("bad next unlinked %#x for inode %lld\n",
+                               be32_to_cpu(dip->di_next_unlinked), ino);
+               error++;
+       }
         /*
          * di_mode is a 16-bit uint so no need to check the < 0 case
          */

===========================================================================
xfsprogs/repair/dinode.c
===========================================================================

--- a/xfsprogs/repair/dinode.c  2008-09-24 18:30:53.000000000 +1000
+++ b/xfsprogs/repair/dinode.c  2008-09-24 18:29:19.477386207 +1000
@@ -2694,7 +2694,7 @@ process_dinode_int(xfs_mount_t *mp,
          * just leave nlinks alone.  even if it's set wrong,
          * it'll be reset when read in.
          */
-       *dirty = process_check_inode_nlink_version(dinoc, lino);
+       *dirty += process_check_inode_nlink_version(dinoc, lino);

         return retval;
