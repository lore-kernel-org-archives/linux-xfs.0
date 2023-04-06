Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7601C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbjDFTnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbjDFTn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0AA275;
        Thu,  6 Apr 2023 12:43:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A24B064BE2;
        Thu,  6 Apr 2023 19:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9BBC433EF;
        Thu,  6 Apr 2023 19:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810181;
        bh=K3BpCPcw5QcolF6/fvOmKqU6PzJ39+BNrWoE9SK8owM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uvOlVG8+5aP4PrCoB77z5/PrGTceMpakTfrSTnFW8JHPZ2Thewx9vmAi2HXBri7Aw
         H1Ifdl2U++fV+kQVCaTSYOeNAOQ2NEjXT7jFrGIPhhoNT3++O22lJzi1+ORk7mI4CR
         vc3n3GVoFKOpM1mo8LcZ8Ny6U9t0xLawOvU4yF/3mBTElDcmSaNyaF8igkdKes8OkF
         Wjufh+XP2RpOAEZOaBVDmezpOJLGDe0p8Sr1qoAlMDdcqddNQTOEv1QP+kTdlsgJME
         rMuvgmk46PJcMHaDURogQLEwUrdf87f0Tzfc3T1MzPi85Wix0ZPbE+asCeP2XMgZZ7
         vkBC3ec73D2vA==
Date:   Thu, 06 Apr 2023 12:43:00 -0700
Subject: [PATCH 05/11] generic/050: adapt for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <168080829072.618488.6093743999148734644.stgit@frogsfrogsfrogs>
In-Reply-To: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
References: <168080829003.618488.1769223982280364994.stgit@frogsfrogsfrogs>
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
 tests/generic/050                    |   10 ++++++++++
 tests/generic/050.cfg                |    1 +
 tests/generic/050.out.xfsquotaparent |   23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+)
 create mode 100644 tests/generic/050.out.xfsquotaparent


diff --git a/tests/generic/050 b/tests/generic/050
index 0664f8c0e4..b38401b9fc 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -36,6 +36,16 @@ elif [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
 	# Mounting with quota on XFS requires a writable fs, which means
 	# we expect to fail the ro blockdev test with with EPERM.
 	features="xfsquota"
+
+	if _xfs_has_feature $SCRATCH_DEV parent && \
+	   ! _xfs_has_feature $SCRATCH_DEV realtime; then
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

