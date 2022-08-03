Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACB0C19F2B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiHCEWq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbiHCEWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F756B85;
        Tue,  2 Aug 2022 21:22:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3C61B82185;
        Wed,  3 Aug 2022 04:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A58C433D6;
        Wed,  3 Aug 2022 04:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500561;
        bh=pKUYjByPuJ29LOCUiZU9sKenDRnvO+UwLIiir20XrtU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QiR8JgBXmpGrIpFYKNJXdfjb6q9By1I/S0LhImrYKmz0rM278LaV+VfvZNAUFCHoh
         6a5NR7RY0aYLAydUkJ+F5NFEuZD3g7VA9YMlV2t+P6A26mOMY6bVP35nxOZapGUrxA
         S+5xGja8MTT1OatMigQXBxLivGBdx6zuyouXP1CgaBZlswELpuJGrYE8deCHDbyhkV
         d1rKuxpEN6djDZMSeGvPTILOrULmCjiG+DKY6I9CQ2zVv3rmi3vVTLSXiR/ebuQ41O
         siRZ1rVg0Jm0/tY+7eJcEG6o1qHZwWfDaKK2GNK+uqvduBA0AQqcPGhXFNnB94S2Qx
         awZP8of+JcAKQ==
Subject: [PATCH 3/3] common: filter internal errors during io error testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:40 -0700
Message-ID: <165950056086.199222.18041854919038769019.stgit@magnolia>
In-Reply-To: <165950054404.199222.5615656337332007333.stgit@magnolia>
References: <165950054404.199222.5615656337332007333.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The goal of an EIO shutdown test is to examine the shutdown and recovery
behavior if we make the underlying storage device return EIO.  On XFS,
it's possible that the shutdown will come from a thread that cancels a
dirty transaction due to the EIO.  This is expected behavior, but
_check_dmesg will flag it as a test failure.

Make it so that we can add simple regexps to the default check_dmesg
filter function, then add the "Internal error" string to filter function
when we invoke an EIO test.  This fixes periodic regressions in
generic/019 and generic/475.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check      |    1 +
 common/rc  |   19 ++++++++++++++++++-
 common/xfs |    7 +++++++
 3 files changed, 26 insertions(+), 1 deletion(-)


diff --git a/check b/check
index 0b2f10ed..000e31cb 100755
--- a/check
+++ b/check
@@ -896,6 +896,7 @@ function run_section()
 			echo "run fstests $seqnum at $date_time" > /dev/kmsg
 			# _check_dmesg depends on this log in dmesg
 			touch ${RESULT_DIR}/check_dmesg
+			rm -f ${RESULT_DIR}/dmesg_filter
 		fi
 		_try_wipe_scratch_devs > /dev/null 2>&1
 
diff --git a/common/rc b/common/rc
index 119cc477..0f233892 100644
--- a/common/rc
+++ b/common/rc
@@ -4164,8 +4164,25 @@ _check_dmesg_for()
 # lockdep.
 _check_dmesg_filter()
 {
+	local extra_filter=
+	local filter_file="${RESULT_DIR}/dmesg_filter"
+
+	test -e "$filter_file" && extra_filter="-f $filter_file"
+
 	egrep -v -e "BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low" \
-		-e "BUG: MAX_STACK_TRACE_ENTRIES too low"
+		-e "BUG: MAX_STACK_TRACE_ENTRIES too low" \
+		$extra_filter
+}
+
+# Add a simple expression to the default dmesg filter
+_add_dmesg_filter()
+{
+	local regexp="$1"
+	local filter_file="${RESULT_DIR}/dmesg_filter"
+
+	if [ ! -e "$filter_file" ] || ! grep -q "$regexp" "$filter_file"; then
+		echo "$regexp" >> "${RESULT_DIR}/dmesg_filter"
+	fi
 }
 
 # check dmesg log for WARNING/Oops/etc.
diff --git a/common/xfs b/common/xfs
index 65234c8b..ae81b3fe 100644
--- a/common/xfs
+++ b/common/xfs
@@ -841,6 +841,13 @@ _xfs_prepare_for_eio_shutdown()
 	local dev="$1"
 	local ctlfile="error/fail_at_unmount"
 
+	# Once we enable IO errors, it's possible that a writer thread will
+	# trip over EIO, cancel the transaction, and shut down the system.
+	# This is expected behavior, so we need to remove the "Internal error"
+	# message from the list of things that can cause the test to be marked
+	# as failed.
+	_add_dmesg_filter "Internal error"
+
 	# Don't retry any writes during the (presumably) post-shutdown unmount
 	_has_fs_sysfs "$ctlfile" && _set_fs_sysfs_attr $dev "$ctlfile" 1
 

