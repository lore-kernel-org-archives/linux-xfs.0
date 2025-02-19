Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE0F1586C8;
	Wed, 19 Feb 2025 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926220; cv=none; b=goF8ByO5qxILATiYlGB/kyRvNGlWx+5RE6Oz7J02QAvNjdnVlcc6916INRyiq+GtNbo0n/ksHewHPHs7u1cUJPYHkx5Cc7vensLzp2YnEVLplAMnsVSYJpMGY4r2ra3Wr95cQuQz5xUq9KG11zcoV5ZRBPjezJINmeWRnp11mjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926220; c=relaxed/simple;
	bh=TsSMnjKtE+SIRtkHK/xoJs0IUyUvd3znhcLf9lWRSY0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MvLWYIXl8sutkIgMjHCweYpMxnAC2mgAQ/JvJr+CTsKixw7Cy+QP4L2YNXGH03P8xr1z5wVBwylV6PdHS+aPAswHMjSwsyHkx4RbrW2s0eWU2+zfPVk6Uu1UYRPGExPQHpySJ0WB0iSC6FNFds+GJShCiEIS3spzz+5MuJd8qYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osEj5qcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osEj5qcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F6FC4CEE2;
	Wed, 19 Feb 2025 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926220;
	bh=TsSMnjKtE+SIRtkHK/xoJs0IUyUvd3znhcLf9lWRSY0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=osEj5qcfW7ItjirzaorGAcw6hPBM7db3Ph+NKhQXHvZMdq4jx3etWfyvo8eUtmbNS
	 xbzRC9N6zzTKLFThRpq6jQjt46nUeeLn8PMjPpVVVlJKouBBuFwKV233dHyT9YGqw3
	 SBACNWDzOy5Y7bybu2T4/QaaQ/m8GgCLTOrLtZRygKaCDSQLkw7LBJgvLi7kqYf5LS
	 7nLt6hphWi0FRxZYdwArmzRLxsFuVQA0Q/n3WRYZ6jjHBlv8d8wXQ2z6SBW8yVYH2W
	 O/leP0S7bBnE/hk+NenJ281geKvvtZ0e/jQzXU02KUJ1EM/B5TzUReyY7jO/FBz1MZ
	 MZrvJX1Aam2lQ==
Date: Tue, 18 Feb 2025 16:50:19 -0800
Subject: [PATCH 3/3] logwrites: only use BLKDISCARD if we know discard zeroes
 data
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992587022.4078081.2598103027724572042.stgit@frogsfrogsfrogs>
In-Reply-To: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
References: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Building off the checks established in the previous patch, only enable
the use of BLKDISCARD if we know that the logwrites device guarantees
that reads after a discard return zeroes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/dmlogwrites          |   10 ++++++++--
 src/log-writes/replay-log.c |    8 ++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)


diff --git a/common/dmlogwrites b/common/dmlogwrites
index 96101d53c38b4a..fbc8beb5ce597e 100644
--- a/common/dmlogwrites
+++ b/common/dmlogwrites
@@ -81,7 +81,10 @@ _log_writes_check_bdev()
 	test "$(cat "$sysfs/queue/discard_max_bytes")" -eq 0 && return
 
 	# dm-thinp guarantees that reads after discards return zeroes
-	dmsetup status "$blkdev" 2>/dev/null | grep -q '^0.* thin ' && return
+	if dmsetup status "$blkdev" 2>/dev/null | grep -q '^0.* thin '; then
+		LOGWRITES_REPLAY_ARGS+=(--discard-zeroes-data)
+		return
+	fi
 
 	echo "HINT: $blkdev doesn't guarantee that reads after DISCARD will return zeroes" >> $seqres.hints
 	echo "      This is required for correct journal replay on some filesystems (e.g. xfs)" >> $seqres.hints
@@ -110,6 +113,7 @@ _log_writes_init()
 		BLK_DEV_SIZE=$((length / blksz))
 	fi
 
+	LOGWRITES_REPLAY_ARGS=()
 	LOGWRITES_NAME=logwrites-test
 	LOGWRITES_DMDEV=/dev/mapper/$LOGWRITES_NAME
 	LOGWRITES_TABLE="0 $BLK_DEV_SIZE log-writes $blkdev $LOGWRITES_DEV"
@@ -161,7 +165,8 @@ _log_writes_replay_log()
 	[ $? -ne 0 ] && _fail "mark '$_mark' does not exist"
 
 	$here/src/log-writes/replay-log --log $LOGWRITES_DEV --replay $_blkdev \
-		--end-mark $_mark >> $seqres.full 2>&1
+		--end-mark $_mark "${LOGWRITES_REPLAY_ARGS[@]}" \
+		>> $seqres.full 2>&1
 	[ $? -ne 0 ] && _fail "replay failed"
 }
 
@@ -231,6 +236,7 @@ _log_writes_replay_log_range()
 	echo "=== replay to $end ===" >> $seqres.full
 	$here/src/log-writes/replay-log -vv --log $LOGWRITES_DEV \
 		--replay $blkdev --limit $(($end + 1)) \
+		"${LOGWRITES_REPLAY_ARGS[@]}" \
 		>> $seqres.full 2>&1
 	[ $? -ne 0 ] && _fail "replay failed"
 }
diff --git a/src/log-writes/replay-log.c b/src/log-writes/replay-log.c
index 968c82ab64a9ad..e07401f63af573 100644
--- a/src/log-writes/replay-log.c
+++ b/src/log-writes/replay-log.c
@@ -18,6 +18,7 @@ enum option_indexes {
 	FIND,
 	NUM_ENTRIES,
 	NO_DISCARD,
+	DISCARD_ZEROES_DATA,
 	FSCK,
 	CHECK,
 	START_MARK,
@@ -37,6 +38,7 @@ static struct option long_options[] = {
 	{"find", no_argument, NULL, 0},
 	{"num-entries", no_argument, NULL, 0},
 	{"no-discard", no_argument, NULL, 0},
+	{"discard-zeroes-data", no_argument, NULL, 0},
 	{"fsck", required_argument, NULL, 0},
 	{"check", required_argument, NULL, 0},
 	{"start-mark", required_argument, NULL, 0},
@@ -155,6 +157,7 @@ int main(int argc, char **argv)
 	int ret;
 	int print_num_entries = 0;
 	int discard = 1;
+	int use_kernel_discard = 0;
 	enum log_replay_check_mode check_mode = 0;
 
 	while ((c = getopt_long(argc, argv, "v", long_options,
@@ -242,6 +245,9 @@ int main(int argc, char **argv)
 		case NO_DISCARD:
 			discard = 0;
 			break;
+		case DISCARD_ZEROES_DATA:
+			use_kernel_discard = 1;
+			break;
 		case FSCK:
 			fsck_command = strdup(optarg);
 			if (!fsck_command) {
@@ -299,6 +305,8 @@ int main(int argc, char **argv)
 
 	if (!discard)
 		log->flags |= LOG_IGNORE_DISCARD;
+	if (!use_kernel_discard)
+		log->flags |= LOG_DISCARD_NOT_SUPP;
 
 	log->start_sector = start_sector;
 	log->end_sector = end_sector;

