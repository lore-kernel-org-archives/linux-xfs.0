Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5423135A5A;
	Mon,  3 Jun 2024 20:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717445563; cv=none; b=aIDQylF/iAY5TtG/9+Wl1v/x8kvpl08aLyKOcebw8PPVL0G7xTIpEEKBCezK7UH0KcwKwN+HdvAfZqEz1o7AqDcBZNRth/EPUk8S0prkliBOIPInoFJVq0qbGKmTudLeaEiSNbms+gGNp4/pbAsuokhnd+mIFf8Htm+f9YZ3Ijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717445563; c=relaxed/simple;
	bh=pqjlqNU/7nU+scmAkCmQhfSIjPQ31EkQjBzyEFo1j+U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NHgyVL3zlUlGHXc6o5plZYiiF9RN8MsuaI+FXUx3/b4/GMYqLy/JRJ++vLbivGYO3xef7Z7GAJCLnrDAl2S3NcWyjn8Sey0Q0TrL2WJEhH9yjvvgnC2LUf907QEfuvmyrykFq2f4bNWFVXKZzTQBKKLz/QTMO69ZbbnJqFMP2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QUVWptre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QUVWptre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E168C2BD10;
	Mon,  3 Jun 2024 20:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717445563;
	bh=pqjlqNU/7nU+scmAkCmQhfSIjPQ31EkQjBzyEFo1j+U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QUVWptreKTVG2XwaUoWnsrKm6b5E580yR+F+4HJA1ZRTqIrEoB9uKy5CjdlyqK5CY
	 Bd6hS4Y5v8LY3N+4nDG09OoZsrnQ+pbPI8KOgOkLFTh83wEKkvBNPQInyJ51psrJ79
	 p49MRvOiLHhIu/BlMZPypFHTbcRpdxw40+nZcojOnnXhTZDAT2SmXy2kiyAk9MZWwo
	 CaeADqCsx5SnwftUF0CwIzPG2KxXVdCA2mWSuh8z74z0OLlkyXkcLCc6BJceFv0vYb
	 T1yFMyTjSLMNTJF9A6Fy06z2WH8vyqr20H7Qz+quOGPbqvGur16HuElJru3XIK/fHc
	 7v4uIKRFuhhTQ==
Date: Mon, 03 Jun 2024 13:12:42 -0700
Subject: [PATCH 2/3] fuzzy: allow FUZZ_REWRITE_DURATION to control fsstress
 runtime when fuzzing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <171744525454.1532034.7496724268125813931.stgit@frogsfrogsfrogs>
In-Reply-To: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
References: <171744525419.1532034.11916603461335062550.stgit@frogsfrogsfrogs>
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
index 723a52e30d..9222cd7e4f 100755
--- a/check
+++ b/check
@@ -376,6 +376,18 @@ if [ -n "$SOAK_DURATION" ]; then
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
index c07f461b61..ed79dbc7e5 100644
--- a/common/fuzzy
+++ b/common/fuzzy
@@ -6,16 +6,19 @@
 
 # Modify various files after a fuzzing operation
 _scratch_fuzz_modify() {
+	local fsstress_args=(-n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) )
+	test -n "${FUZZ_REWRITE_DURATION}" && fsstress_args+=("--duration=${FUZZ_REWRITE_DURATION}")
+
 	echo "+++ stressing filesystem"
 	mkdir -p $SCRATCH_MNT/data
 	[ "$FSTYP" == "xfs" ] && _xfs_force_bdev data $SCRATCH_MNT/data
-	$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/data
+	$FSSTRESS_PROG "${fsstress_args[@]}" -d $SCRATCH_MNT/data
 
 	if [ "$FSTYP" = "xfs" ]; then
 		if _xfs_has_feature "$SCRATCH_MNT" realtime; then
 			mkdir -p $SCRATCH_MNT/rt
 			_xfs_force_bdev realtime $SCRATCH_MNT/rt
-			$FSSTRESS_PROG -n $((TIME_FACTOR * 10000)) -p $((LOAD_FACTOR * 4)) -d $SCRATCH_MNT/rt
+			$FSSTRESS_PROG "${fsstress_args[@]}" -d $SCRATCH_MNT/rt
 		else
 			echo "+++ xfs realtime not configured"
 		fi

