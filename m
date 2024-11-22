Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5F722339;
	Fri, 22 Nov 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294306; cv=none; b=OabfP+CudKuvayGYBJr8Yw+EHcN2Sphj+9kZQIttoMcXHCQefL8u3DQWdM9loOwz9+xrDHF1SUVStnl16g/LQ9oyswx1NXUQd4xy8k863Wk/mhh2jlrXf4sR5IRiXw28CWZEkQuKXmG4JiLr48FGC27a3yh9GVx3aFEnaATI/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294306; c=relaxed/simple;
	bh=XwDXAj8ZTLJd/AYQ9y/0nH0aQPW2AvFBH+YaBLeB52E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PWKb8VuxVdzOgAbwgxcUyfdEL7LcAm2+VUDpjD12W3dMqM3IAymlmcuqPA2EsCF1R5DkQumsKQJoP8DD5GewnkisTp0KkK6ukdK03CZ1LOkQJwh2z7Ub51kk6SOC8dZP26mjAXU3URX1Pqr23niVSxQpb33UPM/eDUAbtgr8CUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8TuXT11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8TuXT11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5ECC4CECE;
	Fri, 22 Nov 2024 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294306;
	bh=XwDXAj8ZTLJd/AYQ9y/0nH0aQPW2AvFBH+YaBLeB52E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i8TuXT11TVeYY8RAxJXufEH1P1LYOYkruI0SGYKjh7b1j0+ZykZSEOTwST2Xdycti
	 287KsQU9Xb7XpntZXQUllDRl2enHhjV16Wk+14Tiv+jKt3bkOWkwxnCQ9h01J7r6kN
	 TIb2Ab9CYWHn3xRUGHQO1Sm2vW24guPVEEZ8SjQHnAB4i4ZC7pX6SrA+UerRS5UL7G
	 qL+K52fbVgMi+sEPeskK34FjS0AVJ48lUMSyiMJUut8RCSQyv17CDTzJ1ys/C7nKv9
	 kbyHuYa0TERmh/ZebqK9YMSh1Bq5HuYRh8j4Mk2jdn8Ac/wV+P6wDFUwJxK0Ri4ieU
	 PHkC/cscQdEuA==
Date: Fri, 22 Nov 2024 08:51:45 -0800
Subject: [PATCH 05/17] logwrites: only use BLKDISCARD if we know discard
 zeroes data
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420088.358248.16258645435851782707.stgit@frogsfrogsfrogs>
In-Reply-To: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
References: <173229419991.358248.8516467437316874374.stgit@frogsfrogsfrogs>
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
index 24a8a25ace277f..7a8a9078cb8b65 100644
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

