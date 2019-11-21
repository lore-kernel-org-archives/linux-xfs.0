Return-Path: <SRS0=udUw=ZN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B560EC432C0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 18:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C1D206CC
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Nov 2019 18:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="MKuEv4pg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUSJd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Nov 2019 13:09:33 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39330 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUSJc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Nov 2019 13:09:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id y11so2487299wrt.6
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2019 10:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=xgEE1qnniZ8FuT8t/VG4m6M/AWTtNbgGzTczlefVNOU=;
        b=MKuEv4pgk89VcfNKB4IQ3+jJ+CoDNxm8lv9kMQdxlgOcX/L/jbU5vh4w2trqp1SNzm
         pFBYB/tzKU3EaoHfsNWiV3u6aN3mCBqq1hxKOh/0Q/a/GGCwW5sj0VkJEy+YKORqvowB
         Nlg71FdnBrYlYzsFiyt+odBM+7zRC9r/i+tXDi8sirJRQkVz6XQkHer4iHjOJ9sLOFrp
         kcZuYq6FPLLW50xj/xwgxO8uBJQrAn2nZVADp1ZELRBPDfRP0afaU0/BQERC9q763YEp
         w51Wyemj0z714efI99FX9PvXcxP4DGCIMheaOtVK274xQhGXI12brzPbSOEyMED8Z3uL
         1h2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xgEE1qnniZ8FuT8t/VG4m6M/AWTtNbgGzTczlefVNOU=;
        b=sJL1TJ0v4+xdEBGFSDD61hnmq/ssCkBJ+kniynfgDqK3U/5TFHmWczTTbh4XA+LHOo
         dme+4vj/LHDHCxZPMuNqkPw+tK/YPaD9Gn5lNf7s+c5O0MPdkCoP5OPQVpcx1+21NZRm
         eqGZ6Mxc2fw2zaSoc9pvYt103pcKm7vL7kgZHOBf5dWcF6kZ0zL3W1DzcB5Xtp62FtIp
         86dcNeRM6+hgWyiqPZpJItEf3cx1+zAOf3IPdjc7o0EM/LAmYtmug0hO/Et5yxhG6EG0
         RTG8hFTogfGSAWuh1IBqGXiJzB5rSMzetdDimQgGbi6uC2fQeDuuTS9tBZc+5xCFzwEf
         lWrQ==
X-Gm-Message-State: APjAAAVuTG+d6DYqJSDa8TIzTGJMUb4UWADEQfRlGUrQBJQja8FFpn45
        +Gm/aLTL5oBtgfaLZX24ifW+Tkl92J0=
X-Google-Smtp-Source: APXvYqyoK/gMSX59mZu2n8XyCyn7aJDftQFEsyvOaaQtqhnBy4QHyVB3cVzYAeXEqBO/cn3n2KOz2Q==
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr12468494wrm.366.1574359769383;
        Thu, 21 Nov 2019 10:09:29 -0800 (PST)
Received: from localhost.localdomain ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id r15sm4414598wrc.5.2019.11.21.10.09.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 21 Nov 2019 10:09:28 -0800 (PST)
From:   Alex Lyakas <alex@zadara.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, alex@zadara.com, bfoster@redhat.com
Subject: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to match those provided during mount
Date:   Thu, 21 Nov 2019 20:08:19 +0200
Message-Id: <1574359699-10191-1-git-send-email-alex@zadara.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We are hitting the following issue: if XFS is mounted with sunit/swidth different from those
specified during mkfs, then xfs_repair reports false corruption and eventually segfaults.

Example:

# mkfs
mkfs.xfs -f -K -p /etc/zadara/xfs.protofile -d sunit=64,swidth=64 -l sunit=32 /dev/vda

#mount with a different sunit/swidth:
mount -onoatime,sync,nouuid,sunit=32,swidth=32 /dev/vda /mnt/xfs

#umount
umount /mnt/xfs

#xfs_repair
xfs_repair -n /dev/vda
# reports false corruption and eventually segfaults[1]

The root cause seems to be that repair/xfs_repair.c::calc_mkfs() calculates the location of first inode chunk based on the current superblock sunit:
	/*
	 * ditto the location of the first inode chunks in the fs ('/')
	 */
	if (xfs_sb_version_hasdalign(&mp->m_sb) && do_inoalign)  {
		first_prealloc_ino = XFS_OFFBNO_TO_AGINO(mp, roundup(fino_bno,
					mp->m_sb.sb_unit), 0);
...

and then compares to the value in the superblock:

	/*
	 * now the first 3 inodes in the system
	 */
	if (mp->m_sb.sb_rootino != first_prealloc_ino)  {
		do_warn(
_("sb root inode value %" PRIu64 " %sinconsistent with calculated value %u\n"),
			mp->m_sb.sb_rootino,
			(mp->m_sb.sb_rootino == NULLFSINO ? "(NULLFSINO) ":""),
			first_prealloc_ino);

		if (!no_modify)
			do_warn(
		_("resetting superblock root inode pointer to %u\n"),
				first_prealloc_ino);
		else
			do_warn(
		_("would reset superblock root inode pointer to %u\n"),
				first_prealloc_ino);

		/*
		 * just set the value -- safe since the superblock
		 * doesn't get flushed out if no_modify is set
		 */
		mp->m_sb.sb_rootino = first_prealloc_ino;
	}

and sets the "correct" value into mp->m_sb.sb_rootino.

And from there xfs_repair uses the wrong value, leading to false corruption reports.

Looking at the kernel code of XFS, there seems to be no need to update the superblock sunit/swidth if the mount-provided sunit/swidth are different.
The superblock values are not used during runtime.

With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.

However, I am not sure whether this is the proper approach. Otherwise, should we not allow specifying different sunit/swidth during mount?

[1]
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
sb root inode value 128 inconsistent with calculated value 96
would reset superblock root inode pointer to 96
sb realtime bitmap inode 129 inconsistent with calculated value 97
would reset superblock realtime bitmap ino pointer to 97
sb realtime summary inode 130 inconsistent with calculated value 98
would reset superblock realtime summary ino pointer to 98
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 16:09:57: scanning filesystem freespace - 16 of 16 allocation groups done
root inode chunk not found
avl_insert: Warning! duplicate range [96,160]
add_inode - duplicate inode range
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 16:09:57: scanning agi unlinked lists - 16 of 16 allocation groups done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 0
inode 129 not rt bitmap
bad .. entry in directory inode 128, points to self, would clear inode number
inode 129 not rt bitmap
would fix bad flags.
...
Segmentation fault (core dumped)

Signed-off-by: Alex Lyakas <alex@zadara.com>
---
 fs/xfs/xfs_mount.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3..e8263b4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -399,19 +399,13 @@
 		}
 
 		/*
-		 * Update superblock with new values
-		 * and log changes
+		 * If sunit/swidth specified during mount do not match
+		 * those in the superblock, use the mount-specified values,
+		 * but do not update the superblock.
+		 * Otherwise, xfs_repair reports false corruption.
+		 * Here, only verify that superblock supports data alignment.
 		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
-		} else {
+		if (!xfs_sb_version_hasdalign(sbp)) {
 			xfs_warn(mp,
 	"cannot change alignment: superblock does not support data alignment");
 			return -EINVAL;
-- 
1.9.1

