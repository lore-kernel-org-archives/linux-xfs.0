Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF0A8BEA;
	Mon,  1 Jan 2024 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOGYau8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2840FC433C8;
	Mon,  1 Jan 2024 00:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069787;
	bh=rHPXov+qTbWS5pe23Vm2Q3xG5ecWJPBAuI5/hUi32Lw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JOGYau8enQUZbVBi7NoOyiMWkRS4YYk5ZqPGONlxfjeb/mGa+tiqLpDOyKoWX0WNK
	 zvHwrRU5P0Xn1DwFYeu0cK1BNeKhKAP6bxO2KleDFIf3Mph1cVEtGNKXltIz3pmHyP
	 /7GAnlNjqBIkmUpYgXj/kCDP1nQZf3yC7sBMEzJNCtOyHAywLYx9GoWcuvkUCJNy3W
	 PBCobjWsmK8XjRQ3YlbRbtjnBnaoQLGoLGl6i+6TjIePeKtLHMAJnev0yH1UGQEuwo
	 iDi6vgPTN0XHj+5/L7SexYRaHXnJZXCWxUwHpaYYbNaIB7RAWt1db11sNCVukQ+M/n
	 qPUXkwI3BoVsQ==
Date: Sun, 31 Dec 2023 16:43:06 +9900
Subject: [PATCH 2/3] fuzzy: allow FUZZ_REWRITE_DURATION to control fsstress
 runtime when fuzzing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405025627.1821776.10663317801956236526.stgit@frogsfrogsfrogs>
In-Reply-To: <170405025600.1821776.14517378233107318876.stgit@frogsfrogsfrogs>
References: <170405025600.1821776.14517378233107318876.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For each iteration of the fuzz test loop, we try to correct the problem,
and then we run fsstress on the (allegedly corrected) filesystem to
check that subsequent use of the filesystem won't crash the kernel or
panic.

Now that fsstress has a --duration switch, let's add a new config
variable that people can set to constrain the amount of time that a fuzz
test run takes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 check        |   12 ++++++++++++
 common/fuzzy |    7 +++++--
 2 files changed, 17 insertions(+), 2 deletions(-)


diff --git a/check b/check
index 71b9fbd075..e567c5e4bb 100755
--- a/check
+++ b/check
@@ -382,6 +382,18 @@ if [ -n "$SOAK_DURATION" ]; then
 	fi
 fi
 
+# If the test config specified a fuzz rewrite test duration, see if there are
+# any unit suffixes that need converting to an integer seconds count.
+if [ -n "$FUZZ_REWRITE_DURATION" ]; then
+	FUZZ_REWRITE_DURATION="$(echo "$FUZZ_REWRITE_DURATION" | \
+		sed -e 's/^\([.0-9]*\)\([a-z]\)*/\1 \2/g' | \
+		$AWK_PROG -f $here/src/soak_duration.awk)"
+	if [ $? -ne 0 ]; then
+		status=1
+		exit 1
+	fi
+fi
+
 if [ -n "$subdir_xfile" ]; then
 	for d in $SRC_GROUPS $FSTYP; do
 		[ -f $SRC_DIR/$d/$subdir_xfile ] || continue
diff --git a/common/fuzzy b/common/fuzzy
index 35cf581cd3..bbf7f83d9e 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -6,15 +6,18 @@
 
 # Modify various files after a fuzzing operation
 _scratch_fuzz_modify() {
+	local fsstress_args=(-n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) )
+	test -n "${FUZZ_REWRITE_DURATION}" && fsstress_args+=("--duration=${FUZZ_REWRITE_DURATION}")
+
 	echo "+++ stressing filesystem"
 	mkdir -p $SCRATCH_MNT/data
 	_xfs_force_bdev data $SCRATCH_MNT/data
-	$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/data
+	$FSSTRESS_PROG "${fsstress_args[@]}" -d $SCRATCH_MNT/data
 
 	if _xfs_has_feature "$SCRATCH_MNT" realtime; then
 		mkdir -p $SCRATCH_MNT/rt
 		_xfs_force_bdev realtime $SCRATCH_MNT/rt
-		$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/rt
+		$FSSTRESS_PROG "${fsstress_args[@]}" -d $SCRATCH_MNT/rt
 	else
 		echo "+++ xfs realtime not configured"
 	fi

