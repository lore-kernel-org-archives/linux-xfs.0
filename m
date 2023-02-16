Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ADFC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBPVOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBPVOj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED6C497C1;
        Thu, 16 Feb 2023 13:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 273EF60C0D;
        Thu, 16 Feb 2023 21:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B652C433D2;
        Thu, 16 Feb 2023 21:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582077;
        bh=vcVPeS9tcXwbqIIJgTp0PQMP7R9xfzIRK36pmTr0ank=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=KXszolhyfsa+Jo/kPVHF2F4NXM8U9qbDDgTeIOQURfi0hN7Lb7wzkZkjdkBsFeeAG
         JYRReyIqdNu9kSEse5rop+B0FQDMTUlinNFKt2nHEWqVHrxD1/OHXFLsutThyY97Yn
         kLZOspMiiitK+FlESfBXuhV6wkuqTttG2XPxpDLsChSFIXQLxmWiZM0HCH/6j5ggPh
         2CLH3QPC0lstlDg1+wt1FKxmus9rQjNkzVYboI+JGnLUGoraIW0Onfb4ZmolT9+oXK
         Bvg4DjQukgyND10OjBgLvcmHb5gdGWIHSeewQao+zhP0IYmfrDNxFqYL9fmaoDQS3s
         WCu2UTtxve+/A==
Date:   Thu, 16 Feb 2023 13:14:37 -0800
Subject: [PATCH 04/14] generic/050: adapt for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884539.3481377.10493385325732880718.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix this test when quotas and parent pointers are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/050                    |    9 +++++++++
 tests/generic/050.cfg                |    1 +
 tests/generic/050.out.xfsquotaparent |   23 +++++++++++++++++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 tests/generic/050.out.xfsquotaparent


diff --git a/tests/generic/050 b/tests/generic/050
index 0664f8c0e4..8af0d13842 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -36,6 +36,15 @@ elif [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
 	# Mounting with quota on XFS requires a writable fs, which means
 	# we expect to fail the ro blockdev test with with EPERM.
 	features="xfsquota"
+
+	if _xfs_has_feature $SCRATCH_DEV parent; then
+		# If we have quotas and parent pointers enabled, the primary
+		# superblock will be written out with the quota flags set when
+		# the logged xattrs log_incompat feature is set.  Hence the
+		# norecovery mount won't fail due to quota rejecting the
+		# mismatch between the mount qflags and the ondisk ones.
+		features="xfsquotaparent"
+	fi
 fi
 _link_out_file "$features"
 
diff --git a/tests/generic/050.cfg b/tests/generic/050.cfg
index 1d9d60bc69..85924d117d 100644
--- a/tests/generic/050.cfg
+++ b/tests/generic/050.cfg
@@ -1,2 +1,3 @@
 nojournal: nojournal
 xfsquota: xfsquota
+xfsquotaparent: xfsquotaparent
diff --git a/tests/generic/050.out.xfsquotaparent b/tests/generic/050.out.xfsquotaparent
new file mode 100644
index 0000000000..b341aca5be
--- /dev/null
+++ b/tests/generic/050.out.xfsquotaparent
@@ -0,0 +1,23 @@
+QA output created by 050
+setting device read-only
+mounting read-only block device:
+mount: SCRATCH_MNT: permission denied
+unmounting read-only filesystem
+umount: SCRATCH_DEV: not mounted
+setting device read-write
+mounting read-write block device:
+touch files
+going down:
+unmounting shutdown filesystem:
+setting device read-only
+mounting filesystem that needs recovery on a read-only device:
+mount: device write-protected, mounting read-only
+mount: cannot mount device read-only
+unmounting read-only filesystem
+umount: SCRATCH_DEV: not mounted
+mounting filesystem with -o norecovery on a read-only device:
+mount: device write-protected, mounting read-only
+unmounting read-only filesystem
+setting device read-write
+mounting filesystem that needs recovery with -o ro:
+*** done

