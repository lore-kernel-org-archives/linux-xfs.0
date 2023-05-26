Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE8BC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbjEZCD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjEZCD1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:03:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6231194;
        Thu, 25 May 2023 19:03:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A776619B3;
        Fri, 26 May 2023 02:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA76C433EF;
        Fri, 26 May 2023 02:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066604;
        bh=hqym1WiZgs1BU230iPp2vfb3KuQ5wXeQQCRy6rkSTp0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=e2+KMeyrwui4sGFzIaPzsQYVfPT/npKJfcEoeIGbhlrr1+ueDoXZ21kRBSaA1k+Z9
         41r6MrYAzw4VWhf3Ij/yHxQ4hEZloVbzp0IkXkDp+UkVg16euMgnCvnz9ra33nLIaO
         1tnmbHzIFVF+0930UviPb5fPyb1dfeSnY5xHwmg6sJpx4jkD6INzukcycaocT1fp/R
         Vi5D8ACafkClEQLokd7LNLk4sJ1QzI3IEg9yr8RWxEi+dUJ70U1GC/UWO1VmW2k56f
         ikgUswSX03i9fP3Rq3LyW/3pId6w7FML6lhVFWF00Ek4J4MG5Ub4i4pw7klB0xq5Ja
         X65cC3YbsXyFA==
Date:   Thu, 25 May 2023 19:03:24 -0700
Subject: [PATCH 05/11] generic/050: adapt for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060915.3732476.5106446538351117289.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
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
 tests/generic/050                    |   20 ++++++++++++++++++--
 tests/generic/050.cfg                |    1 +
 tests/generic/050.out.xfsquotaparent |   23 +++++++++++++++++++++++
 3 files changed, 42 insertions(+), 2 deletions(-)
 create mode 100644 tests/generic/050.out.xfsquotaparent


diff --git a/tests/generic/050 b/tests/generic/050
index 0664f8c0e4..0edeeee10a 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -33,9 +33,25 @@ features=""
 if ! _has_metadata_journaling $SCRATCH_DEV >/dev/null; then
 	features="nojournal"
 elif [ "$FSTYP" = "xfs" ] && echo "$MOUNT_OPTIONS" | grep -q quota ; then
-	# Mounting with quota on XFS requires a writable fs, which means
-	# we expect to fail the ro blockdev test with with EPERM.
+	# *Trying* to mount with quota on XFS requires a writable fs, which
+	# means we expect to fail the ro blockdev test with with EPERM.  It
+	# doesn't matter if xfs_mount would ultimately decide that quota is not
+	# supported.
 	features="xfsquota"
+
+	if _xfs_has_feature $SCRATCH_DEV parent && \
+	   ! _xfs_has_feature $SCRATCH_DEV realtime; then
+		# If we have quotas and parent pointers enabled, the primary
+		# superblock will be written out with the quota flags set when
+		# the logged xattrs log_incompat feature is set.  Hence the
+		# ro-norecovery mount won't fail with EPERM because the ondisk
+		# super's qflags actually match the mount qflags.
+		#
+		# Quota is not supported with realtime; in that case, the
+		# ondisk super's qflags will be zero and hence not match the
+		# mount qflags.  Select 'xfsquota' in that case.
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

