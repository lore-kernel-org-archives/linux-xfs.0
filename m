Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31279BA32;
	Mon,  1 Jan 2024 00:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmnhnUhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA809C433C8;
	Mon,  1 Jan 2024 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069850;
	bh=+2ux9E95IUS2AuAFOA2CtvKv+fJIff2pO8MIoKmkbdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FmnhnUhVBP2WKOjlLAcQokTUJVkwSeDH8U0jNKK+c6zq+2M6fezaMKlQ8/KN+vM6r
	 rHBYMGAxx8iT4mfZ+hoJnDRbvPHJCX3sWjGf/mP6NRoxhe2evElGWzZXlgR1oubG9i
	 8t3Jndd2LQg3xEbY+Zz+oDWMqNLwBgWu55Rh5hzNCeRDPK3QrkGwG7VjZ9rh2qnM0x
	 5vfq5BfEkmvJIAC6LBfWB5CMGJ2VKhbJ1eWIcyiIjtX94IDg6kNSDtrIno/vHqoRas
	 rc+PZGih+ZSmSqvE8wr6+W7x8TEb4ywRpu3B+dpZG5ZNrB37CTksmH4Yn8gSzIllq/
	 74YMgX/uuz1Hg==
Date: Sun, 31 Dec 2023 16:44:09 +9900
Subject: [PATCH 2/4] xfs: offline fuzz test known output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026255.1823639.16865136362993557074.stgit@frogsfrogsfrogs>
In-Reply-To: <170405026226.1823639.16368830178504929409.stgit@frogsfrogsfrogs>
References: <170405026226.1823639.16368830178504929409.stgit@frogsfrogsfrogs>
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

Record all the currently known failures of the xfs_repair check and
repair code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/350.out |   91 +++++++++
 tests/xfs/354.out |   87 +++++++++
 tests/xfs/356.out |   13 +
 tests/xfs/358.out |    5 
 tests/xfs/360.out |   30 +++
 tests/xfs/362.out |    5 
 tests/xfs/364.out |    6 +
 tests/xfs/366.out |    6 +
 tests/xfs/368.out |    8 +
 tests/xfs/370.out |  417 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/372.out |    5 
 tests/xfs/374.out |   35 +++
 tests/xfs/376.out |   22 ++
 tests/xfs/378.out |   22 ++
 tests/xfs/382.out |    4 
 tests/xfs/384.out |   38 ++++
 tests/xfs/386.out |   28 +++
 tests/xfs/388.out |  535 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/392.out |    7 +
 tests/xfs/394.out |   12 +
 tests/xfs/398.out |   38 ++++
 tests/xfs/400.out |   26 +++
 tests/xfs/402.out |    7 +
 tests/xfs/404.out |   33 +++
 tests/xfs/410.out |    6 +
 tests/xfs/412.out |   21 ++
 tests/xfs/414.out |   23 ++
 tests/xfs/416.out |   22 ++
 tests/xfs/418.out |   90 +++++++++
 tests/xfs/425.out |  258 ++++++++++++++++++++++++++
 tests/xfs/427.out |  258 ++++++++++++++++++++++++++
 tests/xfs/429.out |  258 ++++++++++++++++++++++++++
 tests/xfs/496.out |   24 ++
 tests/xfs/734.out |    9 +
 tests/xfs/737.out |   14 +
 tests/xfs/754.out |   23 ++
 tests/xfs/785.out |   23 ++
 37 files changed, 2509 insertions(+)


diff --git a/tests/xfs/350.out b/tests/xfs/350.out
index 3bb9762b30..a0b70cf907 100644
--- a/tests/xfs/350.out
+++ b/tests/xfs/350.out
@@ -1,4 +1,95 @@
 QA output created by 350
 Format and populate
 Fuzz superblock
+rgblocks = middlebit: offline scrub didn't fail.
+rgblocks = lastbit: offline scrub didn't fail.
+rgblocks = add: offline scrub didn't fail.
+rgblocks = sub: offline scrub didn't fail.
+fname = ones: offline scrub didn't fail.
+fname = firstbit: offline scrub didn't fail.
+fname = middlebit: offline scrub didn't fail.
+fname = lastbit: offline scrub didn't fail.
+imax_pct = zeroes: offline scrub didn't fail.
+imax_pct = middlebit: offline scrub didn't fail.
+imax_pct = lastbit: offline scrub didn't fail.
+qflags = zeroes: offline scrub didn't fail.
+qflags = ones: offline scrub didn't fail.
+qflags = firstbit: offline scrub didn't fail.
+qflags = middlebit: offline scrub didn't fail.
+qflags = lastbit: offline scrub didn't fail.
+qflags = add: offline scrub didn't fail.
+qflags = sub: offline scrub didn't fail.
+dirblklog = lastbit: online post-mod scrub failed (1).
+logsunit = zeroes: offline scrub didn't fail.
+logsunit = zeroes: online post-mod scrub failed (1).
+logsunit = lastbit: offline scrub didn't fail.
+logsunit = lastbit: online post-mod scrub failed (1).
+bad_features2 = zeroes: offline scrub didn't fail.
+features_compat = ones: offline repair failed (1).
+features_compat = ones: offline re-scrub failed (1).
+features_compat = ones: pre-mod mount failed (32).
+features_compat = firstbit: offline repair failed (1).
+features_compat = firstbit: offline re-scrub failed (1).
+features_compat = firstbit: pre-mod mount failed (32).
+features_compat = middlebit: offline repair failed (1).
+features_compat = middlebit: offline re-scrub failed (1).
+features_compat = middlebit: pre-mod mount failed (32).
+features_compat = lastbit: offline repair failed (1).
+features_compat = lastbit: offline re-scrub failed (1).
+features_compat = lastbit: pre-mod mount failed (32).
+features_compat = add: offline repair failed (1).
+features_compat = add: offline re-scrub failed (1).
+features_compat = add: pre-mod mount failed (32).
+features_compat = sub: offline repair failed (1).
+features_compat = sub: offline re-scrub failed (1).
+features_compat = sub: pre-mod mount failed (32).
+features_ro_compat = zeroes: offline re-scrub failed (1).
+features_ro_compat = zeroes: offline post-mod scrub failed (1).
+features_ro_compat = ones: offline repair failed (1).
+features_ro_compat = ones: offline re-scrub failed (1).
+features_ro_compat = ones: pre-mod mount failed (32).
+features_ro_compat = firstbit: offline repair failed (1).
+features_ro_compat = firstbit: offline re-scrub failed (1).
+features_ro_compat = firstbit: pre-mod mount failed (32).
+features_ro_compat = middlebit: offline repair failed (1).
+features_ro_compat = middlebit: offline re-scrub failed (1).
+features_ro_compat = middlebit: pre-mod mount failed (32).
+features_ro_compat = lastbit: offline re-scrub failed (1).
+features_ro_compat = lastbit: offline post-mod scrub failed (1).
+features_ro_compat = add: offline repair failed (1).
+features_ro_compat = add: offline re-scrub failed (1).
+features_ro_compat = add: pre-mod mount failed (32).
+features_ro_compat = sub: offline repair failed (1).
+features_ro_compat = sub: offline re-scrub failed (1).
+features_ro_compat = sub: pre-mod mount failed (32).
+features_incompat = ones: offline repair failed (1).
+features_incompat = ones: offline re-scrub failed (1).
+features_incompat = ones: pre-mod mount failed (32).
+features_incompat = middlebit: offline repair failed (1).
+features_incompat = middlebit: offline re-scrub failed (1).
+features_incompat = middlebit: pre-mod mount failed (32).
+features_incompat = lastbit: offline repair failed (1).
+features_incompat = lastbit: offline re-scrub failed (1).
+features_incompat = lastbit: pre-mod mount failed (32).
+features_incompat = sub: offline repair failed (1).
+features_incompat = sub: offline re-scrub failed (1).
+features_incompat = sub: pre-mod mount failed (32).
+features_log_incompat = ones: offline scrub didn't fail.
+features_log_incompat = ones: offline repair failed (1).
+features_log_incompat = ones: offline re-scrub failed (1).
+features_log_incompat = ones: pre-mod mount failed (32).
+features_log_incompat = firstbit: offline scrub didn't fail.
+features_log_incompat = middlebit: offline scrub didn't fail.
+features_log_incompat = middlebit: offline repair failed (1).
+features_log_incompat = middlebit: offline re-scrub failed (1).
+features_log_incompat = middlebit: pre-mod mount failed (32).
+features_log_incompat = lastbit: offline scrub didn't fail.
+features_log_incompat = add: offline scrub didn't fail.
+features_log_incompat = add: offline repair failed (1).
+features_log_incompat = add: offline re-scrub failed (1).
+features_log_incompat = add: pre-mod mount failed (32).
+features_log_incompat = sub: offline scrub didn't fail.
+features_log_incompat = sub: offline repair failed (1).
+features_log_incompat = sub: offline re-scrub failed (1).
+features_log_incompat = sub: pre-mod mount failed (32).
 Done fuzzing superblock
diff --git a/tests/xfs/354.out b/tests/xfs/354.out
index d8b33f64ea..0e53e4909f 100644
--- a/tests/xfs/354.out
+++ b/tests/xfs/354.out
@@ -1,6 +1,93 @@
 QA output created by 354
 Format and populate
 Fuzz AGFL
+magicnum = zeroes: offline scrub didn't fail.
+magicnum = ones: offline scrub didn't fail.
+magicnum = firstbit: offline scrub didn't fail.
+magicnum = middlebit: offline scrub didn't fail.
+magicnum = lastbit: offline scrub didn't fail.
+magicnum = add: offline scrub didn't fail.
+magicnum = sub: offline scrub didn't fail.
+seqno = ones: offline scrub didn't fail.
+seqno = firstbit: offline scrub didn't fail.
+seqno = middlebit: offline scrub didn't fail.
+seqno = lastbit: offline scrub didn't fail.
+seqno = add: offline scrub didn't fail.
+seqno = sub: offline scrub didn't fail.
+uuid = zeroes: offline scrub didn't fail.
+uuid = ones: offline scrub didn't fail.
+uuid = firstbit: offline scrub didn't fail.
+uuid = middlebit: offline scrub didn't fail.
+uuid = lastbit: offline scrub didn't fail.
+bno[0] = zeroes: offline scrub didn't fail.
+bno[0] = firstbit: offline scrub didn't fail.
+bno[0] = middlebit: offline scrub didn't fail.
+bno[0] = lastbit: offline scrub didn't fail.
+bno[0] = add: offline scrub didn't fail.
+bno[0] = sub: offline scrub didn't fail.
+bno[1] = zeroes: offline scrub didn't fail.
+bno[1] = ones: offline scrub didn't fail.
+bno[1] = firstbit: offline scrub didn't fail.
+bno[1] = middlebit: offline scrub didn't fail.
+bno[1] = lastbit: offline scrub didn't fail.
+bno[1] = add: offline scrub didn't fail.
+bno[1] = sub: offline scrub didn't fail.
+bno[2] = zeroes: offline scrub didn't fail.
+bno[2] = ones: offline scrub didn't fail.
+bno[2] = firstbit: offline scrub didn't fail.
+bno[2] = middlebit: offline scrub didn't fail.
+bno[2] = lastbit: offline scrub didn't fail.
+bno[2] = add: offline scrub didn't fail.
+bno[2] = sub: offline scrub didn't fail.
+bno[3] = zeroes: offline scrub didn't fail.
+bno[3] = ones: offline scrub didn't fail.
+bno[3] = firstbit: offline scrub didn't fail.
+bno[3] = middlebit: offline scrub didn't fail.
+bno[3] = lastbit: offline scrub didn't fail.
+bno[3] = add: offline scrub didn't fail.
+bno[3] = sub: offline scrub didn't fail.
+bno[4] = zeroes: offline scrub didn't fail.
+bno[4] = ones: offline scrub didn't fail.
+bno[4] = firstbit: offline scrub didn't fail.
+bno[4] = middlebit: offline scrub didn't fail.
+bno[4] = lastbit: offline scrub didn't fail.
+bno[4] = add: offline scrub didn't fail.
+bno[4] = sub: offline scrub didn't fail.
+bno[5] = zeroes: offline scrub didn't fail.
+bno[5] = ones: offline scrub didn't fail.
+bno[5] = firstbit: offline scrub didn't fail.
+bno[5] = middlebit: offline scrub didn't fail.
+bno[5] = lastbit: offline scrub didn't fail.
+bno[5] = add: offline scrub didn't fail.
+bno[5] = sub: offline scrub didn't fail.
+bno[6] = zeroes: offline scrub didn't fail.
+bno[6] = ones: offline scrub didn't fail.
+bno[6] = firstbit: offline scrub didn't fail.
+bno[6] = middlebit: offline scrub didn't fail.
+bno[6] = lastbit: offline scrub didn't fail.
+bno[6] = add: offline scrub didn't fail.
+bno[6] = sub: offline scrub didn't fail.
+bno[7] = zeroes: offline scrub didn't fail.
+bno[7] = ones: offline scrub didn't fail.
+bno[7] = firstbit: offline scrub didn't fail.
+bno[7] = middlebit: offline scrub didn't fail.
+bno[7] = lastbit: offline scrub didn't fail.
+bno[7] = add: offline scrub didn't fail.
+bno[7] = sub: offline scrub didn't fail.
+bno[8] = zeroes: offline scrub didn't fail.
+bno[8] = ones: offline scrub didn't fail.
+bno[8] = firstbit: offline scrub didn't fail.
+bno[8] = middlebit: offline scrub didn't fail.
+bno[8] = lastbit: offline scrub didn't fail.
+bno[8] = add: offline scrub didn't fail.
+bno[8] = sub: offline scrub didn't fail.
+bno[9] = zeroes: offline scrub didn't fail.
+bno[9] = ones: offline scrub didn't fail.
+bno[9] = firstbit: offline scrub didn't fail.
+bno[9] = middlebit: offline scrub didn't fail.
+bno[9] = lastbit: offline scrub didn't fail.
+bno[9] = add: offline scrub didn't fail.
+bno[9] = sub: offline scrub didn't fail.
 Done fuzzing AGFL
 Fuzz AGFL flfirst
 Done fuzzing AGFL flfirst
diff --git a/tests/xfs/356.out b/tests/xfs/356.out
index ca7834467a..aa40e3e1a3 100644
--- a/tests/xfs/356.out
+++ b/tests/xfs/356.out
@@ -1,4 +1,17 @@
 QA output created by 356
 Format and populate
 Fuzz AGI
+newino = zeroes: offline scrub didn't fail.
+newino = ones: offline scrub didn't fail.
+newino = firstbit: offline scrub didn't fail.
+newino = middlebit: offline scrub didn't fail.
+newino = lastbit: offline scrub didn't fail.
+newino = add: offline scrub didn't fail.
+newino = sub: offline scrub didn't fail.
+dirino = zeroes: offline scrub didn't fail.
+dirino = firstbit: offline scrub didn't fail.
+dirino = middlebit: offline scrub didn't fail.
+dirino = lastbit: offline scrub didn't fail.
+dirino = add: offline scrub didn't fail.
+dirino = sub: offline scrub didn't fail.
 Done fuzzing AGI
diff --git a/tests/xfs/358.out b/tests/xfs/358.out
index e1ec8623ad..0e04f3a81c 100644
--- a/tests/xfs/358.out
+++ b/tests/xfs/358.out
@@ -1,4 +1,9 @@
 QA output created by 358
 Format and populate
 Fuzz bnobt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing bnobt recs
diff --git a/tests/xfs/360.out b/tests/xfs/360.out
index fd7ce6cdb3..30011ce698 100644
--- a/tests/xfs/360.out
+++ b/tests/xfs/360.out
@@ -1,4 +1,34 @@
 QA output created by 360
 Format and populate
 Fuzz bnobt keyptr
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startblock = zeroes: offline scrub didn't fail.
+keys[1].startblock = ones: offline scrub didn't fail.
+keys[1].startblock = firstbit: offline scrub didn't fail.
+keys[1].startblock = middlebit: offline scrub didn't fail.
+keys[1].startblock = lastbit: offline scrub didn't fail.
+keys[1].startblock = add: offline scrub didn't fail.
+keys[1].startblock = sub: offline scrub didn't fail.
+keys[1].blockcount = zeroes: offline scrub didn't fail.
+keys[1].blockcount = ones: offline scrub didn't fail.
+keys[1].blockcount = firstbit: offline scrub didn't fail.
+keys[1].blockcount = middlebit: offline scrub didn't fail.
+keys[1].blockcount = lastbit: offline scrub didn't fail.
+keys[1].blockcount = add: offline scrub didn't fail.
+keys[1].blockcount = sub: offline scrub didn't fail.
+keys[2].startblock = zeroes: offline scrub didn't fail.
+keys[2].startblock = ones: offline scrub didn't fail.
+keys[2].startblock = firstbit: offline scrub didn't fail.
+keys[2].startblock = middlebit: offline scrub didn't fail.
+keys[2].startblock = lastbit: offline scrub didn't fail.
+keys[2].startblock = add: offline scrub didn't fail.
+keys[2].startblock = sub: offline scrub didn't fail.
+keys[2].blockcount = zeroes: offline scrub didn't fail.
+keys[2].blockcount = ones: offline scrub didn't fail.
+keys[2].blockcount = firstbit: offline scrub didn't fail.
+keys[2].blockcount = middlebit: offline scrub didn't fail.
+keys[2].blockcount = lastbit: offline scrub didn't fail.
+keys[2].blockcount = add: offline scrub didn't fail.
+keys[2].blockcount = sub: offline scrub didn't fail.
 Done fuzzing bnobt keyptr
diff --git a/tests/xfs/362.out b/tests/xfs/362.out
index d39175e590..9c5fb8064d 100644
--- a/tests/xfs/362.out
+++ b/tests/xfs/362.out
@@ -1,4 +1,9 @@
 QA output created by 362
 Format and populate
 Fuzz cntbt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing cntbt
diff --git a/tests/xfs/364.out b/tests/xfs/364.out
index 2d6fad24e4..2df69904ed 100644
--- a/tests/xfs/364.out
+++ b/tests/xfs/364.out
@@ -1,4 +1,10 @@
 QA output created by 364
 Format and populate
 Fuzz inobt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+rightsib = sub: offline scrub didn't fail.
 Done fuzzing inobt
diff --git a/tests/xfs/366.out b/tests/xfs/366.out
index 14906508ea..0970587bc9 100644
--- a/tests/xfs/366.out
+++ b/tests/xfs/366.out
@@ -1,4 +1,10 @@
 QA output created by 366
 Format and populate
 Fuzz finobt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+rightsib = sub: offline scrub didn't fail.
 Done fuzzing finobt
diff --git a/tests/xfs/368.out b/tests/xfs/368.out
index 370ea0ef9a..213e1dab3d 100644
--- a/tests/xfs/368.out
+++ b/tests/xfs/368.out
@@ -1,4 +1,12 @@
 QA output created by 368
 Format and populate
 Fuzz rmapbt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+recs[3].startblock = lastbit: offline scrub didn't fail.
+recs[3].blockcount = lastbit: offline scrub didn't fail.
+recs[6].owner = lastbit: offline scrub didn't fail.
 Done fuzzing rmapbt recs
diff --git a/tests/xfs/370.out b/tests/xfs/370.out
index 6858e135ad..84b9ded9b5 100644
--- a/tests/xfs/370.out
+++ b/tests/xfs/370.out
@@ -1,4 +1,421 @@
 QA output created by 370
 Format and populate
 Fuzz rmapbt keyptr
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startblock = lastbit: offline scrub didn't fail.
+keys[1].owner = zeroes: offline scrub didn't fail.
+keys[1].owner = ones: offline scrub didn't fail.
+keys[1].owner = firstbit: offline scrub didn't fail.
+keys[1].owner = middlebit: offline scrub didn't fail.
+keys[1].owner = lastbit: offline scrub didn't fail.
+keys[1].owner = add: offline scrub didn't fail.
+keys[1].owner = sub: offline scrub didn't fail.
+keys[1].offset = ones: offline scrub didn't fail.
+keys[1].offset = firstbit: offline scrub didn't fail.
+keys[1].offset = middlebit: offline scrub didn't fail.
+keys[1].offset = lastbit: offline scrub didn't fail.
+keys[1].offset = add: offline scrub didn't fail.
+keys[1].offset = sub: offline scrub didn't fail.
+keys[1].extentflag = ones: offline scrub didn't fail.
+keys[1].extentflag = firstbit: offline scrub didn't fail.
+keys[1].extentflag = middlebit: offline scrub didn't fail.
+keys[1].extentflag = lastbit: offline scrub didn't fail.
+keys[1].extentflag = add: offline scrub didn't fail.
+keys[1].extentflag = sub: offline scrub didn't fail.
+keys[1].attrfork = ones: offline scrub didn't fail.
+keys[1].attrfork = firstbit: offline scrub didn't fail.
+keys[1].attrfork = middlebit: offline scrub didn't fail.
+keys[1].attrfork = lastbit: offline scrub didn't fail.
+keys[1].attrfork = add: offline scrub didn't fail.
+keys[1].attrfork = sub: offline scrub didn't fail.
+keys[1].bmbtblock = ones: offline scrub didn't fail.
+keys[1].bmbtblock = firstbit: offline scrub didn't fail.
+keys[1].bmbtblock = middlebit: offline scrub didn't fail.
+keys[1].bmbtblock = lastbit: offline scrub didn't fail.
+keys[1].bmbtblock = add: offline scrub didn't fail.
+keys[1].bmbtblock = sub: offline scrub didn't fail.
+keys[1].startblock_hi = ones: offline scrub didn't fail.
+keys[1].startblock_hi = firstbit: offline scrub didn't fail.
+keys[1].startblock_hi = middlebit: offline scrub didn't fail.
+keys[1].startblock_hi = lastbit: offline scrub didn't fail.
+keys[1].startblock_hi = add: offline scrub didn't fail.
+keys[1].startblock_hi = sub: offline scrub didn't fail.
+keys[1].owner_hi = ones: offline scrub didn't fail.
+keys[1].owner_hi = firstbit: offline scrub didn't fail.
+keys[1].owner_hi = middlebit: offline scrub didn't fail.
+keys[1].owner_hi = lastbit: offline scrub didn't fail.
+keys[1].owner_hi = add: offline scrub didn't fail.
+keys[1].owner_hi = sub: offline scrub didn't fail.
+keys[1].offset_hi = ones: offline scrub didn't fail.
+keys[1].offset_hi = firstbit: offline scrub didn't fail.
+keys[1].offset_hi = middlebit: offline scrub didn't fail.
+keys[1].offset_hi = add: offline scrub didn't fail.
+keys[1].offset_hi = sub: offline scrub didn't fail.
+keys[1].extentflag_hi = ones: offline scrub didn't fail.
+keys[1].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[1].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[1].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[1].extentflag_hi = add: offline scrub didn't fail.
+keys[1].extentflag_hi = sub: offline scrub didn't fail.
+keys[1].attrfork_hi = ones: offline scrub didn't fail.
+keys[1].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[1].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[1].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[1].attrfork_hi = add: offline scrub didn't fail.
+keys[1].attrfork_hi = sub: offline scrub didn't fail.
+keys[1].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[1].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[1].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[1].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[1].bmbtblock_hi = add: offline scrub didn't fail.
+keys[1].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[2].owner = zeroes: offline scrub didn't fail.
+keys[2].offset = zeroes: offline scrub didn't fail.
+keys[2].offset = lastbit: offline scrub didn't fail.
+keys[2].extentflag = ones: offline scrub didn't fail.
+keys[2].extentflag = firstbit: offline scrub didn't fail.
+keys[2].extentflag = middlebit: offline scrub didn't fail.
+keys[2].extentflag = lastbit: offline scrub didn't fail.
+keys[2].extentflag = add: offline scrub didn't fail.
+keys[2].extentflag = sub: offline scrub didn't fail.
+keys[2].startblock_hi = ones: offline scrub didn't fail.
+keys[2].startblock_hi = firstbit: offline scrub didn't fail.
+keys[2].startblock_hi = middlebit: offline scrub didn't fail.
+keys[2].startblock_hi = lastbit: offline scrub didn't fail.
+keys[2].startblock_hi = add: offline scrub didn't fail.
+keys[2].startblock_hi = sub: offline scrub didn't fail.
+keys[2].owner_hi = ones: offline scrub didn't fail.
+keys[2].owner_hi = firstbit: offline scrub didn't fail.
+keys[2].owner_hi = middlebit: offline scrub didn't fail.
+keys[2].owner_hi = lastbit: offline scrub didn't fail.
+keys[2].owner_hi = add: offline scrub didn't fail.
+keys[2].owner_hi = sub: offline scrub didn't fail.
+keys[2].offset_hi = ones: offline scrub didn't fail.
+keys[2].offset_hi = firstbit: offline scrub didn't fail.
+keys[2].offset_hi = middlebit: offline scrub didn't fail.
+keys[2].offset_hi = add: offline scrub didn't fail.
+keys[2].offset_hi = sub: offline scrub didn't fail.
+keys[2].extentflag_hi = ones: offline scrub didn't fail.
+keys[2].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[2].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[2].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[2].extentflag_hi = add: offline scrub didn't fail.
+keys[2].extentflag_hi = sub: offline scrub didn't fail.
+keys[2].attrfork_hi = ones: offline scrub didn't fail.
+keys[2].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[2].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[2].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[2].attrfork_hi = add: offline scrub didn't fail.
+keys[2].attrfork_hi = sub: offline scrub didn't fail.
+keys[2].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[2].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[2].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[2].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[2].bmbtblock_hi = add: offline scrub didn't fail.
+keys[2].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[3].owner = zeroes: offline scrub didn't fail.
+keys[3].offset = zeroes: offline scrub didn't fail.
+keys[3].offset = lastbit: offline scrub didn't fail.
+keys[3].extentflag = ones: offline scrub didn't fail.
+keys[3].extentflag = firstbit: offline scrub didn't fail.
+keys[3].extentflag = middlebit: offline scrub didn't fail.
+keys[3].extentflag = lastbit: offline scrub didn't fail.
+keys[3].extentflag = add: offline scrub didn't fail.
+keys[3].extentflag = sub: offline scrub didn't fail.
+keys[3].startblock_hi = ones: offline scrub didn't fail.
+keys[3].startblock_hi = firstbit: offline scrub didn't fail.
+keys[3].startblock_hi = middlebit: offline scrub didn't fail.
+keys[3].startblock_hi = lastbit: offline scrub didn't fail.
+keys[3].startblock_hi = add: offline scrub didn't fail.
+keys[3].startblock_hi = sub: offline scrub didn't fail.
+keys[3].owner_hi = ones: offline scrub didn't fail.
+keys[3].owner_hi = firstbit: offline scrub didn't fail.
+keys[3].owner_hi = middlebit: offline scrub didn't fail.
+keys[3].owner_hi = lastbit: offline scrub didn't fail.
+keys[3].owner_hi = add: offline scrub didn't fail.
+keys[3].offset_hi = ones: offline scrub didn't fail.
+keys[3].offset_hi = firstbit: offline scrub didn't fail.
+keys[3].offset_hi = middlebit: offline scrub didn't fail.
+keys[3].offset_hi = add: offline scrub didn't fail.
+keys[3].offset_hi = sub: offline scrub didn't fail.
+keys[3].extentflag_hi = ones: offline scrub didn't fail.
+keys[3].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[3].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[3].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[3].extentflag_hi = add: offline scrub didn't fail.
+keys[3].extentflag_hi = sub: offline scrub didn't fail.
+keys[3].attrfork_hi = ones: offline scrub didn't fail.
+keys[3].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[3].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[3].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[3].attrfork_hi = add: offline scrub didn't fail.
+keys[3].attrfork_hi = sub: offline scrub didn't fail.
+keys[3].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[3].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[3].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[3].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[3].bmbtblock_hi = add: offline scrub didn't fail.
+keys[3].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[4].owner = zeroes: offline scrub didn't fail.
+keys[4].owner = sub: offline scrub didn't fail.
+keys[4].offset = zeroes: offline scrub didn't fail.
+keys[4].offset = lastbit: offline scrub didn't fail.
+keys[4].extentflag = ones: offline scrub didn't fail.
+keys[4].extentflag = firstbit: offline scrub didn't fail.
+keys[4].extentflag = middlebit: offline scrub didn't fail.
+keys[4].extentflag = lastbit: offline scrub didn't fail.
+keys[4].extentflag = add: offline scrub didn't fail.
+keys[4].extentflag = sub: offline scrub didn't fail.
+keys[4].startblock_hi = ones: offline scrub didn't fail.
+keys[4].startblock_hi = firstbit: offline scrub didn't fail.
+keys[4].startblock_hi = middlebit: offline scrub didn't fail.
+keys[4].startblock_hi = lastbit: offline scrub didn't fail.
+keys[4].startblock_hi = add: offline scrub didn't fail.
+keys[4].startblock_hi = sub: offline scrub didn't fail.
+keys[4].owner_hi = ones: offline scrub didn't fail.
+keys[4].owner_hi = firstbit: offline scrub didn't fail.
+keys[4].owner_hi = middlebit: offline scrub didn't fail.
+keys[4].owner_hi = lastbit: offline scrub didn't fail.
+keys[4].owner_hi = add: offline scrub didn't fail.
+keys[4].offset_hi = ones: offline scrub didn't fail.
+keys[4].offset_hi = firstbit: offline scrub didn't fail.
+keys[4].offset_hi = middlebit: offline scrub didn't fail.
+keys[4].offset_hi = add: offline scrub didn't fail.
+keys[4].offset_hi = sub: offline scrub didn't fail.
+keys[4].extentflag_hi = ones: offline scrub didn't fail.
+keys[4].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[4].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[4].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[4].extentflag_hi = add: offline scrub didn't fail.
+keys[4].extentflag_hi = sub: offline scrub didn't fail.
+keys[4].attrfork_hi = ones: offline scrub didn't fail.
+keys[4].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[4].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[4].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[4].attrfork_hi = add: offline scrub didn't fail.
+keys[4].attrfork_hi = sub: offline scrub didn't fail.
+keys[4].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[4].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[4].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[4].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[4].bmbtblock_hi = add: offline scrub didn't fail.
+keys[4].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[5].owner = zeroes: offline scrub didn't fail.
+keys[5].owner = sub: offline scrub didn't fail.
+keys[5].offset = zeroes: offline scrub didn't fail.
+keys[5].offset = lastbit: offline scrub didn't fail.
+keys[5].extentflag = ones: offline scrub didn't fail.
+keys[5].extentflag = firstbit: offline scrub didn't fail.
+keys[5].extentflag = middlebit: offline scrub didn't fail.
+keys[5].extentflag = lastbit: offline scrub didn't fail.
+keys[5].extentflag = add: offline scrub didn't fail.
+keys[5].extentflag = sub: offline scrub didn't fail.
+keys[5].startblock_hi = ones: offline scrub didn't fail.
+keys[5].startblock_hi = firstbit: offline scrub didn't fail.
+keys[5].startblock_hi = middlebit: offline scrub didn't fail.
+keys[5].startblock_hi = lastbit: offline scrub didn't fail.
+keys[5].startblock_hi = add: offline scrub didn't fail.
+keys[5].startblock_hi = sub: offline scrub didn't fail.
+keys[5].owner_hi = ones: offline scrub didn't fail.
+keys[5].owner_hi = firstbit: offline scrub didn't fail.
+keys[5].owner_hi = middlebit: offline scrub didn't fail.
+keys[5].owner_hi = lastbit: offline scrub didn't fail.
+keys[5].owner_hi = add: offline scrub didn't fail.
+keys[5].offset_hi = ones: offline scrub didn't fail.
+keys[5].offset_hi = firstbit: offline scrub didn't fail.
+keys[5].offset_hi = middlebit: offline scrub didn't fail.
+keys[5].offset_hi = add: offline scrub didn't fail.
+keys[5].offset_hi = sub: offline scrub didn't fail.
+keys[5].extentflag_hi = ones: offline scrub didn't fail.
+keys[5].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[5].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[5].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[5].extentflag_hi = add: offline scrub didn't fail.
+keys[5].extentflag_hi = sub: offline scrub didn't fail.
+keys[5].attrfork_hi = ones: offline scrub didn't fail.
+keys[5].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[5].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[5].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[5].attrfork_hi = add: offline scrub didn't fail.
+keys[5].attrfork_hi = sub: offline scrub didn't fail.
+keys[5].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[5].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[5].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[5].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[5].bmbtblock_hi = add: offline scrub didn't fail.
+keys[5].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[6].owner = zeroes: offline scrub didn't fail.
+keys[6].owner = sub: offline scrub didn't fail.
+keys[6].offset = zeroes: offline scrub didn't fail.
+keys[6].offset = lastbit: offline scrub didn't fail.
+keys[6].extentflag = ones: offline scrub didn't fail.
+keys[6].extentflag = firstbit: offline scrub didn't fail.
+keys[6].extentflag = middlebit: offline scrub didn't fail.
+keys[6].extentflag = lastbit: offline scrub didn't fail.
+keys[6].extentflag = add: offline scrub didn't fail.
+keys[6].extentflag = sub: offline scrub didn't fail.
+keys[6].startblock_hi = ones: offline scrub didn't fail.
+keys[6].startblock_hi = firstbit: offline scrub didn't fail.
+keys[6].startblock_hi = middlebit: offline scrub didn't fail.
+keys[6].startblock_hi = lastbit: offline scrub didn't fail.
+keys[6].startblock_hi = add: offline scrub didn't fail.
+keys[6].owner_hi = ones: offline scrub didn't fail.
+keys[6].owner_hi = firstbit: offline scrub didn't fail.
+keys[6].owner_hi = middlebit: offline scrub didn't fail.
+keys[6].owner_hi = lastbit: offline scrub didn't fail.
+keys[6].owner_hi = add: offline scrub didn't fail.
+keys[6].offset_hi = ones: offline scrub didn't fail.
+keys[6].offset_hi = firstbit: offline scrub didn't fail.
+keys[6].offset_hi = middlebit: offline scrub didn't fail.
+keys[6].offset_hi = add: offline scrub didn't fail.
+keys[6].offset_hi = sub: offline scrub didn't fail.
+keys[6].extentflag_hi = ones: offline scrub didn't fail.
+keys[6].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[6].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[6].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[6].extentflag_hi = add: offline scrub didn't fail.
+keys[6].extentflag_hi = sub: offline scrub didn't fail.
+keys[6].attrfork_hi = ones: offline scrub didn't fail.
+keys[6].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[6].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[6].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[6].attrfork_hi = add: offline scrub didn't fail.
+keys[6].attrfork_hi = sub: offline scrub didn't fail.
+keys[6].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[6].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[6].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[6].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[6].bmbtblock_hi = add: offline scrub didn't fail.
+keys[6].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[7].owner = zeroes: offline scrub didn't fail.
+keys[7].owner = lastbit: offline scrub didn't fail.
+keys[7].owner = sub: offline scrub didn't fail.
+keys[7].offset = zeroes: offline scrub didn't fail.
+keys[7].offset = lastbit: offline scrub didn't fail.
+keys[7].extentflag = ones: offline scrub didn't fail.
+keys[7].extentflag = firstbit: offline scrub didn't fail.
+keys[7].extentflag = middlebit: offline scrub didn't fail.
+keys[7].extentflag = lastbit: offline scrub didn't fail.
+keys[7].extentflag = add: offline scrub didn't fail.
+keys[7].extentflag = sub: offline scrub didn't fail.
+keys[7].startblock_hi = ones: offline scrub didn't fail.
+keys[7].startblock_hi = firstbit: offline scrub didn't fail.
+keys[7].startblock_hi = middlebit: offline scrub didn't fail.
+keys[7].startblock_hi = lastbit: offline scrub didn't fail.
+keys[7].startblock_hi = add: offline scrub didn't fail.
+keys[7].owner_hi = ones: offline scrub didn't fail.
+keys[7].owner_hi = firstbit: offline scrub didn't fail.
+keys[7].owner_hi = middlebit: offline scrub didn't fail.
+keys[7].owner_hi = add: offline scrub didn't fail.
+keys[7].offset_hi = ones: offline scrub didn't fail.
+keys[7].offset_hi = firstbit: offline scrub didn't fail.
+keys[7].offset_hi = middlebit: offline scrub didn't fail.
+keys[7].offset_hi = add: offline scrub didn't fail.
+keys[7].offset_hi = sub: offline scrub didn't fail.
+keys[7].extentflag_hi = ones: offline scrub didn't fail.
+keys[7].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[7].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[7].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[7].extentflag_hi = add: offline scrub didn't fail.
+keys[7].extentflag_hi = sub: offline scrub didn't fail.
+keys[7].attrfork_hi = ones: offline scrub didn't fail.
+keys[7].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[7].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[7].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[7].attrfork_hi = add: offline scrub didn't fail.
+keys[7].attrfork_hi = sub: offline scrub didn't fail.
+keys[7].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[7].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[7].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[7].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[7].bmbtblock_hi = add: offline scrub didn't fail.
+keys[7].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[8].owner = zeroes: offline scrub didn't fail.
+keys[8].owner = lastbit: offline scrub didn't fail.
+keys[8].owner = sub: offline scrub didn't fail.
+keys[8].offset = zeroes: offline scrub didn't fail.
+keys[8].offset = lastbit: offline scrub didn't fail.
+keys[8].extentflag = ones: offline scrub didn't fail.
+keys[8].extentflag = firstbit: offline scrub didn't fail.
+keys[8].extentflag = middlebit: offline scrub didn't fail.
+keys[8].extentflag = lastbit: offline scrub didn't fail.
+keys[8].extentflag = add: offline scrub didn't fail.
+keys[8].extentflag = sub: offline scrub didn't fail.
+keys[8].startblock_hi = ones: offline scrub didn't fail.
+keys[8].startblock_hi = firstbit: offline scrub didn't fail.
+keys[8].startblock_hi = middlebit: offline scrub didn't fail.
+keys[8].startblock_hi = lastbit: offline scrub didn't fail.
+keys[8].startblock_hi = add: offline scrub didn't fail.
+keys[8].owner_hi = ones: offline scrub didn't fail.
+keys[8].owner_hi = firstbit: offline scrub didn't fail.
+keys[8].owner_hi = middlebit: offline scrub didn't fail.
+keys[8].owner_hi = lastbit: offline scrub didn't fail.
+keys[8].owner_hi = add: offline scrub didn't fail.
+keys[8].offset_hi = ones: offline scrub didn't fail.
+keys[8].offset_hi = firstbit: offline scrub didn't fail.
+keys[8].offset_hi = middlebit: offline scrub didn't fail.
+keys[8].offset_hi = add: offline scrub didn't fail.
+keys[8].offset_hi = sub: offline scrub didn't fail.
+keys[8].extentflag_hi = ones: offline scrub didn't fail.
+keys[8].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[8].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[8].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[8].extentflag_hi = add: offline scrub didn't fail.
+keys[8].extentflag_hi = sub: offline scrub didn't fail.
+keys[8].attrfork_hi = ones: offline scrub didn't fail.
+keys[8].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[8].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[8].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[8].attrfork_hi = add: offline scrub didn't fail.
+keys[8].attrfork_hi = sub: offline scrub didn't fail.
+keys[8].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[8].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[8].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[8].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[8].bmbtblock_hi = add: offline scrub didn't fail.
+keys[8].bmbtblock_hi = sub: offline scrub didn't fail.
+keys[9].owner = zeroes: offline scrub didn't fail.
+keys[9].owner = sub: offline scrub didn't fail.
+keys[9].offset = zeroes: offline scrub didn't fail.
+keys[9].offset = lastbit: offline scrub didn't fail.
+keys[9].extentflag = ones: offline scrub didn't fail.
+keys[9].extentflag = firstbit: offline scrub didn't fail.
+keys[9].extentflag = middlebit: offline scrub didn't fail.
+keys[9].extentflag = lastbit: offline scrub didn't fail.
+keys[9].extentflag = add: offline scrub didn't fail.
+keys[9].extentflag = sub: offline scrub didn't fail.
+keys[9].startblock_hi = ones: offline scrub didn't fail.
+keys[9].startblock_hi = firstbit: offline scrub didn't fail.
+keys[9].startblock_hi = middlebit: offline scrub didn't fail.
+keys[9].startblock_hi = lastbit: offline scrub didn't fail.
+keys[9].startblock_hi = add: offline scrub didn't fail.
+keys[9].owner_hi = ones: offline scrub didn't fail.
+keys[9].owner_hi = firstbit: offline scrub didn't fail.
+keys[9].owner_hi = middlebit: offline scrub didn't fail.
+keys[9].owner_hi = lastbit: offline scrub didn't fail.
+keys[9].owner_hi = add: offline scrub didn't fail.
+keys[9].offset_hi = ones: offline scrub didn't fail.
+keys[9].offset_hi = firstbit: offline scrub didn't fail.
+keys[9].offset_hi = middlebit: offline scrub didn't fail.
+keys[9].offset_hi = add: offline scrub didn't fail.
+keys[9].offset_hi = sub: offline scrub didn't fail.
+keys[9].extentflag_hi = ones: offline scrub didn't fail.
+keys[9].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[9].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[9].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[9].extentflag_hi = add: offline scrub didn't fail.
+keys[9].extentflag_hi = sub: offline scrub didn't fail.
+keys[9].attrfork_hi = ones: offline scrub didn't fail.
+keys[9].attrfork_hi = firstbit: offline scrub didn't fail.
+keys[9].attrfork_hi = middlebit: offline scrub didn't fail.
+keys[9].attrfork_hi = lastbit: offline scrub didn't fail.
+keys[9].attrfork_hi = add: offline scrub didn't fail.
+keys[9].attrfork_hi = sub: offline scrub didn't fail.
+keys[9].bmbtblock_hi = ones: offline scrub didn't fail.
+keys[9].bmbtblock_hi = firstbit: offline scrub didn't fail.
+keys[9].bmbtblock_hi = middlebit: offline scrub didn't fail.
+keys[9].bmbtblock_hi = lastbit: offline scrub didn't fail.
+keys[9].bmbtblock_hi = add: offline scrub didn't fail.
+keys[9].bmbtblock_hi = sub: offline scrub didn't fail.
 Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/372.out b/tests/xfs/372.out
index da95f3d5eb..45fcdfc61f 100644
--- a/tests/xfs/372.out
+++ b/tests/xfs/372.out
@@ -1,4 +1,9 @@
 QA output created by 372
 Format and populate
 Fuzz refcountbt
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startblock = zeroes: offline scrub didn't fail.
+keys[1].startblock = lastbit: offline scrub didn't fail.
+keys[1].startblock = sub: offline scrub didn't fail.
 Done fuzzing refcountbt
diff --git a/tests/xfs/374.out b/tests/xfs/374.out
index 853d07a90b..116a4c17ec 100644
--- a/tests/xfs/374.out
+++ b/tests/xfs/374.out
@@ -2,4 +2,39 @@ QA output created by 374
 Format and populate
 Find btree-format dir inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online post-mod scrub failed (4).
+core.size = lastbit: offline scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+core.rtinherit = ones: offline scrub didn't fail.
+core.rtinherit = firstbit: offline scrub didn't fail.
+core.rtinherit = middlebit: offline scrub didn't fail.
+core.rtinherit = lastbit: offline scrub didn't fail.
+core.rtinherit = add: offline scrub didn't fail.
+core.rtinherit = sub: offline scrub didn't fail.
+core.projinherit = ones: offline scrub didn't fail.
+core.projinherit = firstbit: offline scrub didn't fail.
+core.projinherit = middlebit: offline scrub didn't fail.
+core.projinherit = lastbit: offline scrub didn't fail.
+core.projinherit = add: offline scrub didn't fail.
+core.projinherit = sub: offline scrub didn't fail.
+core.nosymlinks = ones: offline scrub didn't fail.
+core.nosymlinks = firstbit: offline scrub didn't fail.
+core.nosymlinks = middlebit: offline scrub didn't fail.
+core.nosymlinks = lastbit: offline scrub didn't fail.
+core.nosymlinks = add: offline scrub didn't fail.
+core.nosymlinks = sub: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+u3.bmbt.ptrs[1] = firstbit: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/376.out b/tests/xfs/376.out
index 40f360e97f..de52138584 100644
--- a/tests/xfs/376.out
+++ b/tests/xfs/376.out
@@ -2,4 +2,26 @@ QA output created by 376
 Format and populate
 Find extents-format file inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.size = zeroes: offline scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/378.out b/tests/xfs/378.out
index f0b1c640d8..04a10ba1c4 100644
--- a/tests/xfs/378.out
+++ b/tests/xfs/378.out
@@ -2,4 +2,26 @@ QA output created by 378
 Format and populate
 Find btree-format file inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.size = zeroes: offline scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/382.out b/tests/xfs/382.out
index 255bd382db..a20d560f74 100644
--- a/tests/xfs/382.out
+++ b/tests/xfs/382.out
@@ -2,4 +2,8 @@ QA output created by 382
 Format and populate
 Find symlink remote block
 Fuzz symlink remote block
+data = ones: offline scrub didn't fail.
+data = firstbit: offline scrub didn't fail.
+data = middlebit: offline scrub didn't fail.
+data = lastbit: offline scrub didn't fail.
 Done fuzzing symlink remote block
diff --git a/tests/xfs/384.out b/tests/xfs/384.out
index 6d0a6ae14a..3b11cb3f7d 100644
--- a/tests/xfs/384.out
+++ b/tests/xfs/384.out
@@ -2,4 +2,42 @@ QA output created by 384
 Format and populate
 Find inline-format dir inode
 Fuzz inline-format dir inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.rtinherit = ones: offline scrub didn't fail.
+core.rtinherit = firstbit: offline scrub didn't fail.
+core.rtinherit = middlebit: offline scrub didn't fail.
+core.rtinherit = lastbit: offline scrub didn't fail.
+core.rtinherit = add: offline scrub didn't fail.
+core.rtinherit = sub: offline scrub didn't fail.
+core.projinherit = ones: offline scrub didn't fail.
+core.projinherit = firstbit: offline scrub didn't fail.
+core.projinherit = middlebit: offline scrub didn't fail.
+core.projinherit = lastbit: offline scrub didn't fail.
+core.projinherit = add: offline scrub didn't fail.
+core.projinherit = sub: offline scrub didn't fail.
+core.nosymlinks = ones: offline scrub didn't fail.
+core.nosymlinks = firstbit: offline scrub didn't fail.
+core.nosymlinks = middlebit: offline scrub didn't fail.
+core.nosymlinks = lastbit: offline scrub didn't fail.
+core.nosymlinks = add: offline scrub didn't fail.
+core.nosymlinks = sub: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = middlebit: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = lastbit: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = add: offline scrub didn't fail.
 Done fuzzing inline-format dir inode
diff --git a/tests/xfs/386.out b/tests/xfs/386.out
index a1f1afc8a6..9d9f9c6818 100644
--- a/tests/xfs/386.out
+++ b/tests/xfs/386.out
@@ -2,4 +2,32 @@ QA output created by 386
 Format and populate
 Find data-format dir block
 Fuzz data-format dir block
+bhdr.hdr.crc = zeroes: offline scrub didn't fail.
+bhdr.hdr.crc = ones: offline scrub didn't fail.
+bhdr.hdr.crc = firstbit: offline scrub didn't fail.
+bhdr.hdr.crc = middlebit: offline scrub didn't fail.
+bhdr.hdr.crc = lastbit: offline scrub didn't fail.
+bhdr.hdr.crc = add: offline scrub didn't fail.
+bhdr.hdr.crc = sub: offline scrub didn't fail.
+bhdr.hdr.owner = zeroes: offline re-scrub failed (1).
+bhdr.hdr.owner = zeroes: online post-mod scrub failed (1).
+bhdr.hdr.owner = zeroes: offline post-mod scrub failed (1).
+bhdr.hdr.owner = ones: offline re-scrub failed (1).
+bhdr.hdr.owner = ones: online post-mod scrub failed (1).
+bhdr.hdr.owner = ones: offline post-mod scrub failed (1).
+bhdr.hdr.owner = firstbit: offline re-scrub failed (1).
+bhdr.hdr.owner = firstbit: online post-mod scrub failed (1).
+bhdr.hdr.owner = firstbit: offline post-mod scrub failed (1).
+bhdr.hdr.owner = middlebit: offline re-scrub failed (1).
+bhdr.hdr.owner = middlebit: online post-mod scrub failed (1).
+bhdr.hdr.owner = middlebit: offline post-mod scrub failed (1).
+bhdr.hdr.owner = lastbit: offline re-scrub failed (1).
+bhdr.hdr.owner = lastbit: online post-mod scrub failed (1).
+bhdr.hdr.owner = lastbit: offline post-mod scrub failed (1).
+bhdr.hdr.owner = add: offline re-scrub failed (1).
+bhdr.hdr.owner = add: online post-mod scrub failed (1).
+bhdr.hdr.owner = add: offline post-mod scrub failed (1).
+bhdr.hdr.owner = sub: offline re-scrub failed (1).
+bhdr.hdr.owner = sub: online post-mod scrub failed (1).
+bhdr.hdr.owner = sub: offline post-mod scrub failed (1).
 Done fuzzing data-format dir block
diff --git a/tests/xfs/388.out b/tests/xfs/388.out
index 175d3b46f2..4848c6c9de 100644
--- a/tests/xfs/388.out
+++ b/tests/xfs/388.out
@@ -2,4 +2,539 @@ QA output created by 388
 Format and populate
 Find data-format dir block
 Fuzz data-format dir block
+dhdr.hdr.crc = zeroes: offline scrub didn't fail.
+dhdr.hdr.crc = ones: offline scrub didn't fail.
+dhdr.hdr.crc = firstbit: offline scrub didn't fail.
+dhdr.hdr.crc = middlebit: offline scrub didn't fail.
+dhdr.hdr.crc = lastbit: offline scrub didn't fail.
+dhdr.hdr.crc = add: offline scrub didn't fail.
+dhdr.hdr.crc = sub: offline scrub didn't fail.
+dhdr.hdr.bno = zeroes: offline re-scrub failed (1).
+dhdr.hdr.bno = zeroes: online post-mod scrub failed (1).
+dhdr.hdr.bno = zeroes: offline post-mod scrub failed (1).
+dhdr.hdr.bno = ones: offline re-scrub failed (1).
+dhdr.hdr.bno = ones: online post-mod scrub failed (1).
+dhdr.hdr.bno = ones: offline post-mod scrub failed (1).
+dhdr.hdr.bno = firstbit: offline re-scrub failed (1).
+dhdr.hdr.bno = firstbit: online post-mod scrub failed (1).
+dhdr.hdr.bno = firstbit: offline post-mod scrub failed (1).
+dhdr.hdr.bno = middlebit: offline re-scrub failed (1).
+dhdr.hdr.bno = middlebit: online post-mod scrub failed (1).
+dhdr.hdr.bno = middlebit: offline post-mod scrub failed (1).
+dhdr.hdr.bno = lastbit: offline re-scrub failed (1).
+dhdr.hdr.bno = lastbit: online post-mod scrub failed (1).
+dhdr.hdr.bno = lastbit: offline post-mod scrub failed (1).
+dhdr.hdr.bno = add: offline re-scrub failed (1).
+dhdr.hdr.bno = add: online post-mod scrub failed (1).
+dhdr.hdr.bno = add: offline post-mod scrub failed (1).
+dhdr.hdr.bno = sub: offline re-scrub failed (1).
+dhdr.hdr.bno = sub: online post-mod scrub failed (1).
+dhdr.hdr.bno = sub: offline post-mod scrub failed (1).
+dhdr.hdr.uuid = zeroes: offline re-scrub failed (1).
+dhdr.hdr.uuid = zeroes: online post-mod scrub failed (1).
+dhdr.hdr.uuid = zeroes: offline post-mod scrub failed (1).
+dhdr.hdr.uuid = ones: offline re-scrub failed (1).
+dhdr.hdr.uuid = ones: online post-mod scrub failed (1).
+dhdr.hdr.uuid = ones: offline post-mod scrub failed (1).
+dhdr.hdr.uuid = firstbit: offline re-scrub failed (1).
+dhdr.hdr.uuid = firstbit: online post-mod scrub failed (1).
+dhdr.hdr.uuid = firstbit: offline post-mod scrub failed (1).
+dhdr.hdr.uuid = middlebit: offline re-scrub failed (1).
+dhdr.hdr.uuid = middlebit: online post-mod scrub failed (1).
+dhdr.hdr.uuid = middlebit: offline post-mod scrub failed (1).
+dhdr.hdr.uuid = lastbit: offline re-scrub failed (1).
+dhdr.hdr.uuid = lastbit: online post-mod scrub failed (1).
+dhdr.hdr.uuid = lastbit: offline post-mod scrub failed (1).
+dhdr.hdr.owner = zeroes: offline re-scrub failed (1).
+dhdr.hdr.owner = zeroes: online post-mod scrub failed (1).
+dhdr.hdr.owner = zeroes: offline post-mod scrub failed (1).
+dhdr.hdr.owner = ones: offline re-scrub failed (1).
+dhdr.hdr.owner = ones: online post-mod scrub failed (1).
+dhdr.hdr.owner = ones: offline post-mod scrub failed (1).
+dhdr.hdr.owner = firstbit: offline re-scrub failed (1).
+dhdr.hdr.owner = firstbit: online post-mod scrub failed (1).
+dhdr.hdr.owner = firstbit: offline post-mod scrub failed (1).
+dhdr.hdr.owner = middlebit: offline re-scrub failed (1).
+dhdr.hdr.owner = middlebit: online post-mod scrub failed (1).
+dhdr.hdr.owner = middlebit: offline post-mod scrub failed (1).
+dhdr.hdr.owner = lastbit: offline re-scrub failed (1).
+dhdr.hdr.owner = lastbit: online post-mod scrub failed (1).
+dhdr.hdr.owner = lastbit: offline post-mod scrub failed (1).
+dhdr.hdr.owner = add: offline re-scrub failed (1).
+dhdr.hdr.owner = add: online post-mod scrub failed (1).
+dhdr.hdr.owner = add: offline post-mod scrub failed (1).
+dhdr.hdr.owner = sub: offline re-scrub failed (1).
+dhdr.hdr.owner = sub: online post-mod scrub failed (1).
+dhdr.hdr.owner = sub: offline post-mod scrub failed (1).
+du[0].inumber = ones: offline re-scrub failed (1).
+du[0].inumber = ones: online post-mod scrub failed (1).
+du[0].inumber = ones: offline post-mod scrub failed (1).
+du[0].inumber = sub: offline re-scrub failed (1).
+du[0].inumber = sub: online post-mod scrub failed (1).
+du[0].inumber = sub: offline post-mod scrub failed (1).
+du[0].namelen = zeroes: offline re-scrub failed (1).
+du[0].namelen = zeroes: online post-mod scrub failed (1).
+du[0].namelen = zeroes: offline post-mod scrub failed (1).
+du[0].namelen = ones: offline re-scrub failed (1).
+du[0].namelen = ones: online post-mod scrub failed (1).
+du[0].namelen = ones: offline post-mod scrub failed (1).
+du[0].namelen = firstbit: offline re-scrub failed (1).
+du[0].namelen = firstbit: online post-mod scrub failed (1).
+du[0].namelen = firstbit: offline post-mod scrub failed (1).
+du[0].namelen = middlebit: offline re-scrub failed (1).
+du[0].namelen = middlebit: online post-mod scrub failed (1).
+du[0].namelen = middlebit: offline post-mod scrub failed (1).
+du[0].namelen = lastbit: offline re-scrub failed (1).
+du[0].namelen = lastbit: online post-mod scrub failed (1).
+du[0].namelen = lastbit: offline post-mod scrub failed (1).
+du[0].namelen = add: offline re-scrub failed (1).
+du[0].namelen = add: online post-mod scrub failed (1).
+du[0].namelen = add: offline post-mod scrub failed (1).
+du[0].namelen = sub: offline re-scrub failed (1).
+du[0].namelen = sub: online post-mod scrub failed (1).
+du[0].namelen = sub: offline post-mod scrub failed (1).
+du[0].name = zeroes: offline re-scrub failed (1).
+du[0].name = zeroes: online post-mod scrub failed (1).
+du[0].name = zeroes: offline post-mod scrub failed (1).
+du[0].name = ones: offline re-scrub failed (1).
+du[0].name = ones: online post-mod scrub failed (1).
+du[0].name = ones: offline post-mod scrub failed (1).
+du[0].name = firstbit: offline re-scrub failed (1).
+du[0].name = firstbit: online post-mod scrub failed (1).
+du[0].name = firstbit: offline post-mod scrub failed (1).
+du[0].name = middlebit: offline re-scrub failed (1).
+du[0].name = middlebit: online post-mod scrub failed (1).
+du[0].name = middlebit: offline post-mod scrub failed (1).
+du[0].name = lastbit: offline re-scrub failed (1).
+du[0].name = lastbit: online post-mod scrub failed (1).
+du[0].name = lastbit: offline post-mod scrub failed (1).
+du[0].name = add: offline re-scrub failed (1).
+du[0].name = add: online post-mod scrub failed (1).
+du[0].name = add: offline post-mod scrub failed (1).
+du[0].name = sub: offline re-scrub failed (1).
+du[0].name = sub: online post-mod scrub failed (1).
+du[0].name = sub: offline post-mod scrub failed (1).
+du[0].tag = zeroes: offline re-scrub failed (1).
+du[0].tag = zeroes: online post-mod scrub failed (1).
+du[0].tag = zeroes: offline post-mod scrub failed (1).
+du[0].tag = ones: offline re-scrub failed (1).
+du[0].tag = ones: online post-mod scrub failed (1).
+du[0].tag = ones: offline post-mod scrub failed (1).
+du[0].tag = firstbit: offline re-scrub failed (1).
+du[0].tag = firstbit: online post-mod scrub failed (1).
+du[0].tag = firstbit: offline post-mod scrub failed (1).
+du[0].tag = middlebit: offline re-scrub failed (1).
+du[0].tag = middlebit: online post-mod scrub failed (1).
+du[0].tag = middlebit: offline post-mod scrub failed (1).
+du[0].tag = lastbit: offline re-scrub failed (1).
+du[0].tag = lastbit: online post-mod scrub failed (1).
+du[0].tag = lastbit: offline post-mod scrub failed (1).
+du[0].tag = add: offline re-scrub failed (1).
+du[0].tag = add: online post-mod scrub failed (1).
+du[0].tag = add: offline post-mod scrub failed (1).
+du[0].tag = sub: offline re-scrub failed (1).
+du[0].tag = sub: online post-mod scrub failed (1).
+du[0].tag = sub: offline post-mod scrub failed (1).
+du[1].inumber = ones: offline re-scrub failed (1).
+du[1].inumber = ones: online post-mod scrub failed (1).
+du[1].inumber = ones: offline post-mod scrub failed (1).
+du[1].inumber = sub: offline re-scrub failed (1).
+du[1].inumber = sub: online post-mod scrub failed (1).
+du[1].inumber = sub: offline post-mod scrub failed (1).
+du[1].namelen = ones: offline re-scrub failed (1).
+du[1].namelen = ones: online post-mod scrub failed (1).
+du[1].namelen = ones: offline post-mod scrub failed (1).
+du[1].namelen = firstbit: offline re-scrub failed (1).
+du[1].namelen = firstbit: online post-mod scrub failed (1).
+du[1].namelen = firstbit: offline post-mod scrub failed (1).
+du[1].namelen = middlebit: offline re-scrub failed (1).
+du[1].namelen = middlebit: online post-mod scrub failed (1).
+du[1].namelen = middlebit: offline post-mod scrub failed (1).
+du[1].namelen = add: offline re-scrub failed (1).
+du[1].namelen = add: online post-mod scrub failed (1).
+du[1].namelen = add: offline post-mod scrub failed (1).
+du[1].namelen = sub: offline re-scrub failed (1).
+du[1].namelen = sub: online post-mod scrub failed (1).
+du[1].namelen = sub: offline post-mod scrub failed (1).
+du[1].tag = zeroes: offline re-scrub failed (1).
+du[1].tag = zeroes: online post-mod scrub failed (1).
+du[1].tag = zeroes: offline post-mod scrub failed (1).
+du[1].tag = ones: offline re-scrub failed (1).
+du[1].tag = ones: online post-mod scrub failed (1).
+du[1].tag = ones: offline post-mod scrub failed (1).
+du[1].tag = firstbit: offline re-scrub failed (1).
+du[1].tag = firstbit: online post-mod scrub failed (1).
+du[1].tag = firstbit: offline post-mod scrub failed (1).
+du[1].tag = middlebit: offline re-scrub failed (1).
+du[1].tag = middlebit: online post-mod scrub failed (1).
+du[1].tag = middlebit: offline post-mod scrub failed (1).
+du[1].tag = lastbit: offline re-scrub failed (1).
+du[1].tag = lastbit: online post-mod scrub failed (1).
+du[1].tag = lastbit: offline post-mod scrub failed (1).
+du[1].tag = add: offline re-scrub failed (1).
+du[1].tag = add: online post-mod scrub failed (1).
+du[1].tag = add: offline post-mod scrub failed (1).
+du[1].tag = sub: offline re-scrub failed (1).
+du[1].tag = sub: online post-mod scrub failed (1).
+du[1].tag = sub: offline post-mod scrub failed (1).
+du[2].inumber = ones: offline re-scrub failed (1).
+du[2].inumber = ones: online post-mod scrub failed (1).
+du[2].inumber = ones: offline post-mod scrub failed (1).
+du[2].inumber = sub: offline re-scrub failed (1).
+du[2].inumber = sub: online post-mod scrub failed (1).
+du[2].inumber = sub: offline post-mod scrub failed (1).
+du[2].namelen = zeroes: offline re-scrub failed (1).
+du[2].namelen = zeroes: online post-mod scrub failed (1).
+du[2].namelen = zeroes: offline post-mod scrub failed (1).
+du[2].namelen = ones: offline re-scrub failed (1).
+du[2].namelen = ones: online post-mod scrub failed (1).
+du[2].namelen = ones: offline post-mod scrub failed (1).
+du[2].namelen = firstbit: offline re-scrub failed (1).
+du[2].namelen = firstbit: online post-mod scrub failed (1).
+du[2].namelen = firstbit: offline post-mod scrub failed (1).
+du[2].namelen = middlebit: offline re-scrub failed (1).
+du[2].namelen = middlebit: online post-mod scrub failed (1).
+du[2].namelen = middlebit: offline post-mod scrub failed (1).
+du[2].namelen = add: offline re-scrub failed (1).
+du[2].namelen = add: online post-mod scrub failed (1).
+du[2].namelen = add: offline post-mod scrub failed (1).
+du[2].namelen = sub: offline re-scrub failed (1).
+du[2].namelen = sub: online post-mod scrub failed (1).
+du[2].namelen = sub: offline post-mod scrub failed (1).
+du[2].tag = zeroes: offline re-scrub failed (1).
+du[2].tag = zeroes: online post-mod scrub failed (1).
+du[2].tag = zeroes: offline post-mod scrub failed (1).
+du[2].tag = ones: offline re-scrub failed (1).
+du[2].tag = ones: online post-mod scrub failed (1).
+du[2].tag = ones: offline post-mod scrub failed (1).
+du[2].tag = firstbit: offline re-scrub failed (1).
+du[2].tag = firstbit: online post-mod scrub failed (1).
+du[2].tag = firstbit: offline post-mod scrub failed (1).
+du[2].tag = middlebit: offline re-scrub failed (1).
+du[2].tag = middlebit: online post-mod scrub failed (1).
+du[2].tag = middlebit: offline post-mod scrub failed (1).
+du[2].tag = lastbit: offline re-scrub failed (1).
+du[2].tag = lastbit: online post-mod scrub failed (1).
+du[2].tag = lastbit: offline post-mod scrub failed (1).
+du[2].tag = add: offline re-scrub failed (1).
+du[2].tag = add: online post-mod scrub failed (1).
+du[2].tag = add: offline post-mod scrub failed (1).
+du[2].tag = sub: offline re-scrub failed (1).
+du[2].tag = sub: online post-mod scrub failed (1).
+du[2].tag = sub: offline post-mod scrub failed (1).
+du[3].inumber = ones: offline re-scrub failed (1).
+du[3].inumber = ones: online post-mod scrub failed (1).
+du[3].inumber = ones: offline post-mod scrub failed (1).
+du[3].inumber = sub: offline re-scrub failed (1).
+du[3].inumber = sub: online post-mod scrub failed (1).
+du[3].inumber = sub: offline post-mod scrub failed (1).
+du[3].namelen = zeroes: offline re-scrub failed (1).
+du[3].namelen = zeroes: online post-mod scrub failed (1).
+du[3].namelen = zeroes: offline post-mod scrub failed (1).
+du[3].namelen = ones: offline re-scrub failed (1).
+du[3].namelen = ones: online post-mod scrub failed (1).
+du[3].namelen = ones: offline post-mod scrub failed (1).
+du[3].namelen = firstbit: offline re-scrub failed (1).
+du[3].namelen = firstbit: online post-mod scrub failed (1).
+du[3].namelen = firstbit: offline post-mod scrub failed (1).
+du[3].namelen = middlebit: offline re-scrub failed (1).
+du[3].namelen = middlebit: online post-mod scrub failed (1).
+du[3].namelen = middlebit: offline post-mod scrub failed (1).
+du[3].namelen = add: offline re-scrub failed (1).
+du[3].namelen = add: online post-mod scrub failed (1).
+du[3].namelen = add: offline post-mod scrub failed (1).
+du[3].namelen = sub: offline re-scrub failed (1).
+du[3].namelen = sub: online post-mod scrub failed (1).
+du[3].namelen = sub: offline post-mod scrub failed (1).
+du[3].tag = zeroes: offline re-scrub failed (1).
+du[3].tag = zeroes: online post-mod scrub failed (1).
+du[3].tag = zeroes: offline post-mod scrub failed (1).
+du[3].tag = ones: offline re-scrub failed (1).
+du[3].tag = ones: online post-mod scrub failed (1).
+du[3].tag = ones: offline post-mod scrub failed (1).
+du[3].tag = firstbit: offline re-scrub failed (1).
+du[3].tag = firstbit: online post-mod scrub failed (1).
+du[3].tag = firstbit: offline post-mod scrub failed (1).
+du[3].tag = middlebit: offline re-scrub failed (1).
+du[3].tag = middlebit: online post-mod scrub failed (1).
+du[3].tag = middlebit: offline post-mod scrub failed (1).
+du[3].tag = lastbit: offline re-scrub failed (1).
+du[3].tag = lastbit: online post-mod scrub failed (1).
+du[3].tag = lastbit: offline post-mod scrub failed (1).
+du[3].tag = add: offline re-scrub failed (1).
+du[3].tag = add: online post-mod scrub failed (1).
+du[3].tag = add: offline post-mod scrub failed (1).
+du[3].tag = sub: offline re-scrub failed (1).
+du[3].tag = sub: online post-mod scrub failed (1).
+du[3].tag = sub: offline post-mod scrub failed (1).
+du[4].inumber = ones: offline re-scrub failed (1).
+du[4].inumber = ones: online post-mod scrub failed (1).
+du[4].inumber = ones: offline post-mod scrub failed (1).
+du[4].inumber = sub: offline re-scrub failed (1).
+du[4].inumber = sub: online post-mod scrub failed (1).
+du[4].inumber = sub: offline post-mod scrub failed (1).
+du[4].namelen = zeroes: offline re-scrub failed (1).
+du[4].namelen = zeroes: online post-mod scrub failed (1).
+du[4].namelen = zeroes: offline post-mod scrub failed (1).
+du[4].namelen = ones: offline re-scrub failed (1).
+du[4].namelen = ones: online post-mod scrub failed (1).
+du[4].namelen = ones: offline post-mod scrub failed (1).
+du[4].namelen = firstbit: offline re-scrub failed (1).
+du[4].namelen = firstbit: online post-mod scrub failed (1).
+du[4].namelen = firstbit: offline post-mod scrub failed (1).
+du[4].namelen = middlebit: offline re-scrub failed (1).
+du[4].namelen = middlebit: online post-mod scrub failed (1).
+du[4].namelen = middlebit: offline post-mod scrub failed (1).
+du[4].namelen = add: offline re-scrub failed (1).
+du[4].namelen = add: online post-mod scrub failed (1).
+du[4].namelen = add: offline post-mod scrub failed (1).
+du[4].namelen = sub: offline re-scrub failed (1).
+du[4].namelen = sub: online post-mod scrub failed (1).
+du[4].namelen = sub: offline post-mod scrub failed (1).
+du[4].tag = zeroes: offline re-scrub failed (1).
+du[4].tag = zeroes: online post-mod scrub failed (1).
+du[4].tag = zeroes: offline post-mod scrub failed (1).
+du[4].tag = ones: offline re-scrub failed (1).
+du[4].tag = ones: online post-mod scrub failed (1).
+du[4].tag = ones: offline post-mod scrub failed (1).
+du[4].tag = firstbit: offline re-scrub failed (1).
+du[4].tag = firstbit: online post-mod scrub failed (1).
+du[4].tag = firstbit: offline post-mod scrub failed (1).
+du[4].tag = middlebit: offline re-scrub failed (1).
+du[4].tag = middlebit: online post-mod scrub failed (1).
+du[4].tag = middlebit: offline post-mod scrub failed (1).
+du[4].tag = lastbit: offline re-scrub failed (1).
+du[4].tag = lastbit: online post-mod scrub failed (1).
+du[4].tag = lastbit: offline post-mod scrub failed (1).
+du[4].tag = add: offline re-scrub failed (1).
+du[4].tag = add: online post-mod scrub failed (1).
+du[4].tag = add: offline post-mod scrub failed (1).
+du[4].tag = sub: offline re-scrub failed (1).
+du[4].tag = sub: online post-mod scrub failed (1).
+du[4].tag = sub: offline post-mod scrub failed (1).
+du[5].inumber = ones: offline re-scrub failed (1).
+du[5].inumber = ones: online post-mod scrub failed (1).
+du[5].inumber = ones: offline post-mod scrub failed (1).
+du[5].inumber = sub: offline re-scrub failed (1).
+du[5].inumber = sub: online post-mod scrub failed (1).
+du[5].inumber = sub: offline post-mod scrub failed (1).
+du[5].namelen = zeroes: offline re-scrub failed (1).
+du[5].namelen = zeroes: online post-mod scrub failed (1).
+du[5].namelen = zeroes: offline post-mod scrub failed (1).
+du[5].namelen = ones: offline re-scrub failed (1).
+du[5].namelen = ones: online post-mod scrub failed (1).
+du[5].namelen = ones: offline post-mod scrub failed (1).
+du[5].namelen = firstbit: offline re-scrub failed (1).
+du[5].namelen = firstbit: online post-mod scrub failed (1).
+du[5].namelen = firstbit: offline post-mod scrub failed (1).
+du[5].namelen = middlebit: offline re-scrub failed (1).
+du[5].namelen = middlebit: online post-mod scrub failed (1).
+du[5].namelen = middlebit: offline post-mod scrub failed (1).
+du[5].namelen = add: offline re-scrub failed (1).
+du[5].namelen = add: online post-mod scrub failed (1).
+du[5].namelen = add: offline post-mod scrub failed (1).
+du[5].namelen = sub: offline re-scrub failed (1).
+du[5].namelen = sub: online post-mod scrub failed (1).
+du[5].namelen = sub: offline post-mod scrub failed (1).
+du[5].tag = zeroes: offline re-scrub failed (1).
+du[5].tag = zeroes: online post-mod scrub failed (1).
+du[5].tag = zeroes: offline post-mod scrub failed (1).
+du[5].tag = ones: offline re-scrub failed (1).
+du[5].tag = ones: online post-mod scrub failed (1).
+du[5].tag = ones: offline post-mod scrub failed (1).
+du[5].tag = firstbit: offline re-scrub failed (1).
+du[5].tag = firstbit: online post-mod scrub failed (1).
+du[5].tag = firstbit: offline post-mod scrub failed (1).
+du[5].tag = middlebit: offline re-scrub failed (1).
+du[5].tag = middlebit: online post-mod scrub failed (1).
+du[5].tag = middlebit: offline post-mod scrub failed (1).
+du[5].tag = lastbit: offline re-scrub failed (1).
+du[5].tag = lastbit: online post-mod scrub failed (1).
+du[5].tag = lastbit: offline post-mod scrub failed (1).
+du[5].tag = add: offline re-scrub failed (1).
+du[5].tag = add: online post-mod scrub failed (1).
+du[5].tag = add: offline post-mod scrub failed (1).
+du[5].tag = sub: offline re-scrub failed (1).
+du[5].tag = sub: online post-mod scrub failed (1).
+du[5].tag = sub: offline post-mod scrub failed (1).
+du[6].inumber = ones: offline re-scrub failed (1).
+du[6].inumber = ones: online post-mod scrub failed (1).
+du[6].inumber = ones: offline post-mod scrub failed (1).
+du[6].inumber = sub: offline re-scrub failed (1).
+du[6].inumber = sub: online post-mod scrub failed (1).
+du[6].inumber = sub: offline post-mod scrub failed (1).
+du[6].namelen = zeroes: offline re-scrub failed (1).
+du[6].namelen = zeroes: online post-mod scrub failed (1).
+du[6].namelen = zeroes: offline post-mod scrub failed (1).
+du[6].namelen = ones: offline re-scrub failed (1).
+du[6].namelen = ones: online post-mod scrub failed (1).
+du[6].namelen = ones: offline post-mod scrub failed (1).
+du[6].namelen = firstbit: offline re-scrub failed (1).
+du[6].namelen = firstbit: online post-mod scrub failed (1).
+du[6].namelen = firstbit: offline post-mod scrub failed (1).
+du[6].namelen = middlebit: offline re-scrub failed (1).
+du[6].namelen = middlebit: online post-mod scrub failed (1).
+du[6].namelen = middlebit: offline post-mod scrub failed (1).
+du[6].namelen = add: offline re-scrub failed (1).
+du[6].namelen = add: online post-mod scrub failed (1).
+du[6].namelen = add: offline post-mod scrub failed (1).
+du[6].namelen = sub: offline re-scrub failed (1).
+du[6].namelen = sub: online post-mod scrub failed (1).
+du[6].namelen = sub: offline post-mod scrub failed (1).
+du[6].tag = zeroes: offline re-scrub failed (1).
+du[6].tag = zeroes: online post-mod scrub failed (1).
+du[6].tag = zeroes: offline post-mod scrub failed (1).
+du[6].tag = ones: offline re-scrub failed (1).
+du[6].tag = ones: online post-mod scrub failed (1).
+du[6].tag = ones: offline post-mod scrub failed (1).
+du[6].tag = firstbit: offline re-scrub failed (1).
+du[6].tag = firstbit: online post-mod scrub failed (1).
+du[6].tag = firstbit: offline post-mod scrub failed (1).
+du[6].tag = middlebit: offline re-scrub failed (1).
+du[6].tag = middlebit: online post-mod scrub failed (1).
+du[6].tag = middlebit: offline post-mod scrub failed (1).
+du[6].tag = lastbit: offline re-scrub failed (1).
+du[6].tag = lastbit: online post-mod scrub failed (1).
+du[6].tag = lastbit: offline post-mod scrub failed (1).
+du[6].tag = add: offline re-scrub failed (1).
+du[6].tag = add: online post-mod scrub failed (1).
+du[6].tag = add: offline post-mod scrub failed (1).
+du[6].tag = sub: offline re-scrub failed (1).
+du[6].tag = sub: online post-mod scrub failed (1).
+du[6].tag = sub: offline post-mod scrub failed (1).
+du[7].inumber = ones: offline re-scrub failed (1).
+du[7].inumber = ones: online post-mod scrub failed (1).
+du[7].inumber = ones: offline post-mod scrub failed (1).
+du[7].inumber = sub: offline re-scrub failed (1).
+du[7].inumber = sub: online post-mod scrub failed (1).
+du[7].inumber = sub: offline post-mod scrub failed (1).
+du[7].namelen = zeroes: offline re-scrub failed (1).
+du[7].namelen = zeroes: online post-mod scrub failed (1).
+du[7].namelen = zeroes: offline post-mod scrub failed (1).
+du[7].namelen = ones: offline re-scrub failed (1).
+du[7].namelen = ones: online post-mod scrub failed (1).
+du[7].namelen = ones: offline post-mod scrub failed (1).
+du[7].namelen = firstbit: offline re-scrub failed (1).
+du[7].namelen = firstbit: online post-mod scrub failed (1).
+du[7].namelen = firstbit: offline post-mod scrub failed (1).
+du[7].namelen = middlebit: offline re-scrub failed (1).
+du[7].namelen = middlebit: online post-mod scrub failed (1).
+du[7].namelen = middlebit: offline post-mod scrub failed (1).
+du[7].namelen = add: offline re-scrub failed (1).
+du[7].namelen = add: online post-mod scrub failed (1).
+du[7].namelen = add: offline post-mod scrub failed (1).
+du[7].namelen = sub: offline re-scrub failed (1).
+du[7].namelen = sub: online post-mod scrub failed (1).
+du[7].namelen = sub: offline post-mod scrub failed (1).
+du[7].tag = zeroes: offline re-scrub failed (1).
+du[7].tag = zeroes: online post-mod scrub failed (1).
+du[7].tag = zeroes: offline post-mod scrub failed (1).
+du[7].tag = ones: offline re-scrub failed (1).
+du[7].tag = ones: online post-mod scrub failed (1).
+du[7].tag = ones: offline post-mod scrub failed (1).
+du[7].tag = firstbit: offline re-scrub failed (1).
+du[7].tag = firstbit: online post-mod scrub failed (1).
+du[7].tag = firstbit: offline post-mod scrub failed (1).
+du[7].tag = middlebit: offline re-scrub failed (1).
+du[7].tag = middlebit: online post-mod scrub failed (1).
+du[7].tag = middlebit: offline post-mod scrub failed (1).
+du[7].tag = lastbit: offline re-scrub failed (1).
+du[7].tag = lastbit: online post-mod scrub failed (1).
+du[7].tag = lastbit: offline post-mod scrub failed (1).
+du[7].tag = add: offline re-scrub failed (1).
+du[7].tag = add: online post-mod scrub failed (1).
+du[7].tag = add: offline post-mod scrub failed (1).
+du[7].tag = sub: offline re-scrub failed (1).
+du[7].tag = sub: online post-mod scrub failed (1).
+du[7].tag = sub: offline post-mod scrub failed (1).
+du[8].inumber = ones: offline re-scrub failed (1).
+du[8].inumber = ones: online post-mod scrub failed (1).
+du[8].inumber = ones: offline post-mod scrub failed (1).
+du[8].inumber = sub: offline re-scrub failed (1).
+du[8].inumber = sub: online post-mod scrub failed (1).
+du[8].inumber = sub: offline post-mod scrub failed (1).
+du[8].namelen = zeroes: offline re-scrub failed (1).
+du[8].namelen = zeroes: online post-mod scrub failed (1).
+du[8].namelen = zeroes: offline post-mod scrub failed (1).
+du[8].namelen = ones: offline re-scrub failed (1).
+du[8].namelen = ones: online post-mod scrub failed (1).
+du[8].namelen = ones: offline post-mod scrub failed (1).
+du[8].namelen = firstbit: offline re-scrub failed (1).
+du[8].namelen = firstbit: online post-mod scrub failed (1).
+du[8].namelen = firstbit: offline post-mod scrub failed (1).
+du[8].namelen = middlebit: offline re-scrub failed (1).
+du[8].namelen = middlebit: online post-mod scrub failed (1).
+du[8].namelen = middlebit: offline post-mod scrub failed (1).
+du[8].namelen = add: offline re-scrub failed (1).
+du[8].namelen = add: online post-mod scrub failed (1).
+du[8].namelen = add: offline post-mod scrub failed (1).
+du[8].namelen = sub: offline re-scrub failed (1).
+du[8].namelen = sub: online post-mod scrub failed (1).
+du[8].namelen = sub: offline post-mod scrub failed (1).
+du[8].tag = zeroes: offline re-scrub failed (1).
+du[8].tag = zeroes: online post-mod scrub failed (1).
+du[8].tag = zeroes: offline post-mod scrub failed (1).
+du[8].tag = ones: offline re-scrub failed (1).
+du[8].tag = ones: online post-mod scrub failed (1).
+du[8].tag = ones: offline post-mod scrub failed (1).
+du[8].tag = firstbit: offline re-scrub failed (1).
+du[8].tag = firstbit: online post-mod scrub failed (1).
+du[8].tag = firstbit: offline post-mod scrub failed (1).
+du[8].tag = middlebit: offline re-scrub failed (1).
+du[8].tag = middlebit: online post-mod scrub failed (1).
+du[8].tag = middlebit: offline post-mod scrub failed (1).
+du[8].tag = lastbit: offline re-scrub failed (1).
+du[8].tag = lastbit: online post-mod scrub failed (1).
+du[8].tag = lastbit: offline post-mod scrub failed (1).
+du[8].tag = add: offline re-scrub failed (1).
+du[8].tag = add: online post-mod scrub failed (1).
+du[8].tag = add: offline post-mod scrub failed (1).
+du[8].tag = sub: offline re-scrub failed (1).
+du[8].tag = sub: online post-mod scrub failed (1).
+du[8].tag = sub: offline post-mod scrub failed (1).
+du[9].inumber = ones: offline re-scrub failed (1).
+du[9].inumber = ones: online post-mod scrub failed (1).
+du[9].inumber = ones: offline post-mod scrub failed (1).
+du[9].inumber = sub: offline re-scrub failed (1).
+du[9].inumber = sub: online post-mod scrub failed (1).
+du[9].inumber = sub: offline post-mod scrub failed (1).
+du[9].namelen = zeroes: offline re-scrub failed (1).
+du[9].namelen = zeroes: online post-mod scrub failed (1).
+du[9].namelen = zeroes: offline post-mod scrub failed (1).
+du[9].namelen = ones: offline re-scrub failed (1).
+du[9].namelen = ones: online post-mod scrub failed (1).
+du[9].namelen = ones: offline post-mod scrub failed (1).
+du[9].namelen = firstbit: offline re-scrub failed (1).
+du[9].namelen = firstbit: online post-mod scrub failed (1).
+du[9].namelen = firstbit: offline post-mod scrub failed (1).
+du[9].namelen = middlebit: offline re-scrub failed (1).
+du[9].namelen = middlebit: online post-mod scrub failed (1).
+du[9].namelen = middlebit: offline post-mod scrub failed (1).
+du[9].namelen = add: offline re-scrub failed (1).
+du[9].namelen = add: online post-mod scrub failed (1).
+du[9].namelen = add: offline post-mod scrub failed (1).
+du[9].namelen = sub: offline re-scrub failed (1).
+du[9].namelen = sub: online post-mod scrub failed (1).
+du[9].namelen = sub: offline post-mod scrub failed (1).
+du[9].tag = zeroes: offline re-scrub failed (1).
+du[9].tag = zeroes: online post-mod scrub failed (1).
+du[9].tag = zeroes: offline post-mod scrub failed (1).
+du[9].tag = ones: offline re-scrub failed (1).
+du[9].tag = ones: online post-mod scrub failed (1).
+du[9].tag = ones: offline post-mod scrub failed (1).
+du[9].tag = firstbit: offline re-scrub failed (1).
+du[9].tag = firstbit: online post-mod scrub failed (1).
+du[9].tag = firstbit: offline post-mod scrub failed (1).
+du[9].tag = middlebit: offline re-scrub failed (1).
+du[9].tag = middlebit: online post-mod scrub failed (1).
+du[9].tag = middlebit: offline post-mod scrub failed (1).
+du[9].tag = lastbit: offline re-scrub failed (1).
+du[9].tag = lastbit: online post-mod scrub failed (1).
+du[9].tag = lastbit: offline post-mod scrub failed (1).
+du[9].tag = add: offline re-scrub failed (1).
+du[9].tag = add: online post-mod scrub failed (1).
+du[9].tag = add: offline post-mod scrub failed (1).
+du[9].tag = sub: offline re-scrub failed (1).
+du[9].tag = sub: online post-mod scrub failed (1).
+du[9].tag = sub: offline post-mod scrub failed (1).
 Done fuzzing data-format dir block
diff --git a/tests/xfs/392.out b/tests/xfs/392.out
index 9ff34805a8..8bc5d14cd2 100644
--- a/tests/xfs/392.out
+++ b/tests/xfs/392.out
@@ -2,4 +2,11 @@ QA output created by 392
 Format and populate
 Find leafn-format dir block
 Fuzz leafn-format dir block
+lhdr.info.crc = zeroes: offline scrub didn't fail.
+lhdr.info.crc = ones: offline scrub didn't fail.
+lhdr.info.crc = firstbit: offline scrub didn't fail.
+lhdr.info.crc = middlebit: offline scrub didn't fail.
+lhdr.info.crc = lastbit: offline scrub didn't fail.
+lhdr.info.crc = add: offline scrub didn't fail.
+lhdr.info.crc = sub: offline scrub didn't fail.
 Done fuzzing leafn-format dir block
diff --git a/tests/xfs/394.out b/tests/xfs/394.out
index bc50b85217..5c26f64289 100644
--- a/tests/xfs/394.out
+++ b/tests/xfs/394.out
@@ -2,4 +2,16 @@ QA output created by 394
 Format and populate
 Find node-format dir block
 Fuzz node-format dir block
+nhdr.info.hdr.back = ones: offline scrub didn't fail.
+nhdr.info.hdr.back = ones: online post-mod scrub failed (1).
+nhdr.info.hdr.back = firstbit: offline scrub didn't fail.
+nhdr.info.hdr.back = firstbit: online post-mod scrub failed (1).
+nhdr.info.hdr.back = middlebit: offline scrub didn't fail.
+nhdr.info.hdr.back = middlebit: online post-mod scrub failed (1).
+nhdr.info.hdr.back = lastbit: offline scrub didn't fail.
+nhdr.info.hdr.back = lastbit: online post-mod scrub failed (1).
+nhdr.info.hdr.back = add: offline scrub didn't fail.
+nhdr.info.hdr.back = add: online post-mod scrub failed (1).
+nhdr.info.hdr.back = sub: offline scrub didn't fail.
+nhdr.info.hdr.back = sub: online post-mod scrub failed (1).
 Done fuzzing node-format dir block
diff --git a/tests/xfs/398.out b/tests/xfs/398.out
index 63c899d2e5..11bac3af85 100644
--- a/tests/xfs/398.out
+++ b/tests/xfs/398.out
@@ -2,4 +2,42 @@ QA output created by 398
 Format and populate
 Find inline-format attr inode
 Fuzz inline-format attr inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+a.sfattr.list[1].name = ones: offline scrub didn't fail.
+a.sfattr.list[1].name = firstbit: offline scrub didn't fail.
+a.sfattr.list[1].name = middlebit: offline scrub didn't fail.
+a.sfattr.list[1].name = lastbit: offline scrub didn't fail.
+a.sfattr.list[1].name = add: offline scrub didn't fail.
+a.sfattr.list[1].name = sub: offline scrub didn't fail.
+a.sfattr.list[2].name = ones: offline scrub didn't fail.
+a.sfattr.list[2].name = firstbit: offline scrub didn't fail.
+a.sfattr.list[2].name = middlebit: offline scrub didn't fail.
+a.sfattr.list[2].name = lastbit: offline scrub didn't fail.
+a.sfattr.list[2].name = add: offline scrub didn't fail.
+a.sfattr.list[2].name = sub: offline scrub didn't fail.
 Done fuzzing inline-format attr inode
diff --git a/tests/xfs/400.out b/tests/xfs/400.out
index 6ac33ef2c5..9a0555448e 100644
--- a/tests/xfs/400.out
+++ b/tests/xfs/400.out
@@ -2,4 +2,30 @@ QA output created by 400
 Format and populate
 Find leaf-format attr block
 Fuzz leaf-format attr block
+hdr.info.crc = zeroes: offline scrub didn't fail.
+hdr.info.crc = ones: offline scrub didn't fail.
+hdr.info.crc = firstbit: offline scrub didn't fail.
+hdr.info.crc = middlebit: offline scrub didn't fail.
+hdr.info.crc = lastbit: offline scrub didn't fail.
+hdr.info.crc = add: offline scrub didn't fail.
+hdr.info.crc = sub: offline scrub didn't fail.
+hdr.holes = ones: offline scrub didn't fail.
+hdr.holes = firstbit: offline scrub didn't fail.
+hdr.holes = middlebit: offline scrub didn't fail.
+hdr.holes = lastbit: offline scrub didn't fail.
+hdr.holes = add: offline scrub didn't fail.
+hdr.holes = sub: offline scrub didn't fail.
+hdr.freemap[0].base = zeroes: offline scrub didn't fail.
+hdr.freemap[0].base = zeroes: online post-mod scrub failed (1).
+hdr.freemap[0].base = middlebit: offline scrub didn't fail.
+hdr.freemap[0].base = middlebit: online post-mod scrub failed (1).
+hdr.freemap[0].size = zeroes: offline scrub didn't fail.
+hdr.freemap[0].size = middlebit: offline scrub didn't fail.
+hdr.freemap[0].size = middlebit: online post-mod scrub failed (1).
+hdr.freemap[1].base = middlebit: offline scrub didn't fail.
+hdr.freemap[1].size = middlebit: offline scrub didn't fail.
+hdr.freemap[1].size = middlebit: online post-mod scrub failed (1).
+hdr.freemap[2].base = middlebit: offline scrub didn't fail.
+hdr.freemap[2].size = middlebit: offline scrub didn't fail.
+hdr.freemap[2].size = middlebit: online post-mod scrub failed (1).
 Done fuzzing leaf-format attr block
diff --git a/tests/xfs/402.out b/tests/xfs/402.out
index 94e89f4c87..b7e36901d1 100644
--- a/tests/xfs/402.out
+++ b/tests/xfs/402.out
@@ -2,4 +2,11 @@ QA output created by 402
 Format and populate
 Find node-format attr block
 Fuzz node-format attr block
+hdr.info.crc = zeroes: offline scrub didn't fail.
+hdr.info.crc = ones: offline scrub didn't fail.
+hdr.info.crc = firstbit: offline scrub didn't fail.
+hdr.info.crc = middlebit: offline scrub didn't fail.
+hdr.info.crc = lastbit: offline scrub didn't fail.
+hdr.info.crc = add: offline scrub didn't fail.
+hdr.info.crc = sub: offline scrub didn't fail.
 Done fuzzing node-format attr block
diff --git a/tests/xfs/404.out b/tests/xfs/404.out
index 30ddbd87c8..45d47248e9 100644
--- a/tests/xfs/404.out
+++ b/tests/xfs/404.out
@@ -2,4 +2,37 @@ QA output created by 404
 Format and populate
 Find external attr block
 Fuzz external attr block
+hdr.offset = ones: offline scrub didn't fail.
+hdr.offset = ones: online post-mod scrub failed (1).
+hdr.offset = middlebit: offline scrub didn't fail.
+hdr.offset = middlebit: online post-mod scrub failed (1).
+hdr.offset = lastbit: offline scrub didn't fail.
+hdr.offset = lastbit: online post-mod scrub failed (1).
+hdr.offset = add: offline scrub didn't fail.
+hdr.offset = add: online post-mod scrub failed (1).
+hdr.offset = sub: offline scrub didn't fail.
+hdr.offset = sub: online post-mod scrub failed (1).
+hdr.bytes = zeroes: offline scrub didn't fail.
+hdr.bytes = zeroes: online post-mod scrub failed (1).
+hdr.bytes = lastbit: offline scrub didn't fail.
+hdr.bytes = lastbit: online post-mod scrub failed (1).
+hdr.bytes = sub: offline scrub didn't fail.
+hdr.bytes = sub: online post-mod scrub failed (1).
+hdr.owner = ones: offline scrub didn't fail.
+hdr.owner = ones: online post-mod scrub failed (1).
+hdr.owner = firstbit: offline scrub didn't fail.
+hdr.owner = firstbit: online post-mod scrub failed (1).
+hdr.owner = middlebit: offline scrub didn't fail.
+hdr.owner = middlebit: online post-mod scrub failed (1).
+hdr.owner = lastbit: offline scrub didn't fail.
+hdr.owner = lastbit: online post-mod scrub failed (1).
+hdr.owner = add: offline scrub didn't fail.
+hdr.owner = add: online post-mod scrub failed (1).
+hdr.owner = sub: offline scrub didn't fail.
+hdr.owner = sub: online post-mod scrub failed (1).
+data = zeroes: offline scrub didn't fail.
+data = ones: offline scrub didn't fail.
+data = firstbit: offline scrub didn't fail.
+data = middlebit: offline scrub didn't fail.
+data = lastbit: offline scrub didn't fail.
 Done fuzzing external attr block
diff --git a/tests/xfs/410.out b/tests/xfs/410.out
index c43ae75efd..47a9eab8f9 100644
--- a/tests/xfs/410.out
+++ b/tests/xfs/410.out
@@ -1,4 +1,10 @@
 QA output created by 410
 Format and populate
 Fuzz refcountbt
+numrecs = lastbit: offline scrub didn't fail.
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing refcountbt
diff --git a/tests/xfs/412.out b/tests/xfs/412.out
index b93eec2262..550ca4e85c 100644
--- a/tests/xfs/412.out
+++ b/tests/xfs/412.out
@@ -2,4 +2,25 @@ QA output created by 412
 Format and populate
 Find btree-format attr inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+a.bmbt.ptrs[1] = firstbit: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/414.out b/tests/xfs/414.out
index 3d6e4d2f5e..107c625114 100644
--- a/tests/xfs/414.out
+++ b/tests/xfs/414.out
@@ -2,4 +2,27 @@ QA output created by 414
 Format and populate
 Find blockdev inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+u3.dev = zeroes: offline scrub didn't fail.
+u3.dev = ones: offline scrub didn't fail.
+u3.dev = firstbit: offline scrub didn't fail.
+u3.dev = middlebit: offline scrub didn't fail.
+u3.dev = lastbit: offline scrub didn't fail.
+u3.dev = add: offline scrub didn't fail.
+u3.dev = sub: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/416.out b/tests/xfs/416.out
index d17d2f73a1..9abc7867da 100644
--- a/tests/xfs/416.out
+++ b/tests/xfs/416.out
@@ -2,4 +2,26 @@ QA output created by 416
 Format and populate
 Find local-format symlink inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+u3.symlink = ones: offline scrub didn't fail.
+u3.symlink = firstbit: offline scrub didn't fail.
+u3.symlink = middlebit: offline scrub didn't fail.
+u3.symlink = lastbit: offline scrub didn't fail.
+u3.symlink = add: offline scrub didn't fail.
+u3.symlink = sub: offline scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/418.out b/tests/xfs/418.out
index 9051605b9c..ae181693a1 100644
--- a/tests/xfs/418.out
+++ b/tests/xfs/418.out
@@ -1,4 +1,94 @@
 QA output created by 418
 Format and populate
 Fuzz superblock
+uuid = zeroes: offline scrub didn't fail.
+uuid = ones: offline scrub didn't fail.
+uuid = firstbit: offline scrub didn't fail.
+uuid = middlebit: offline scrub didn't fail.
+uuid = lastbit: offline scrub didn't fail.
+rootino = zeroes: offline scrub didn't fail.
+rootino = ones: offline scrub didn't fail.
+rootino = firstbit: offline scrub didn't fail.
+rootino = middlebit: offline scrub didn't fail.
+rootino = lastbit: offline scrub didn't fail.
+rootino = add: offline scrub didn't fail.
+rootino = sub: offline scrub didn't fail.
+metadirino = zeroes: offline scrub didn't fail.
+metadirino = firstbit: offline scrub didn't fail.
+metadirino = middlebit: offline scrub didn't fail.
+metadirino = lastbit: offline scrub didn't fail.
+metadirino = add: offline scrub didn't fail.
+metadirino = sub: offline scrub didn't fail.
+rgblocks = middlebit: offline scrub didn't fail.
+rgblocks = lastbit: offline scrub didn't fail.
+rgblocks = add: offline scrub didn't fail.
+rgblocks = sub: offline scrub didn't fail.
+fname = ones: offline scrub didn't fail.
+fname = firstbit: offline scrub didn't fail.
+fname = middlebit: offline scrub didn't fail.
+fname = lastbit: offline scrub didn't fail.
+inprogress = zeroes: offline scrub didn't fail.
+inprogress = ones: offline scrub didn't fail.
+inprogress = firstbit: offline scrub didn't fail.
+inprogress = middlebit: offline scrub didn't fail.
+inprogress = lastbit: offline scrub didn't fail.
+inprogress = add: offline scrub didn't fail.
+inprogress = sub: offline scrub didn't fail.
+imax_pct = zeroes: offline scrub didn't fail.
+imax_pct = middlebit: offline scrub didn't fail.
+imax_pct = lastbit: offline scrub didn't fail.
+icount = ones: offline scrub didn't fail.
+icount = firstbit: offline scrub didn't fail.
+icount = middlebit: offline scrub didn't fail.
+icount = lastbit: offline scrub didn't fail.
+icount = add: offline scrub didn't fail.
+icount = sub: offline scrub didn't fail.
+ifree = ones: offline scrub didn't fail.
+ifree = firstbit: offline scrub didn't fail.
+ifree = middlebit: offline scrub didn't fail.
+ifree = lastbit: offline scrub didn't fail.
+ifree = add: offline scrub didn't fail.
+ifree = sub: offline scrub didn't fail.
+fdblocks = zeroes: offline scrub didn't fail.
+fdblocks = ones: offline scrub didn't fail.
+fdblocks = firstbit: offline scrub didn't fail.
+fdblocks = middlebit: offline scrub didn't fail.
+fdblocks = lastbit: offline scrub didn't fail.
+fdblocks = add: offline scrub didn't fail.
+fdblocks = sub: offline scrub didn't fail.
+shared_vn = ones: offline scrub didn't fail.
+shared_vn = ones: online post-mod scrub failed (1).
+shared_vn = firstbit: offline scrub didn't fail.
+shared_vn = firstbit: online post-mod scrub failed (1).
+shared_vn = middlebit: offline scrub didn't fail.
+shared_vn = middlebit: online post-mod scrub failed (1).
+shared_vn = lastbit: offline scrub didn't fail.
+shared_vn = lastbit: online post-mod scrub failed (1).
+shared_vn = add: offline scrub didn't fail.
+shared_vn = add: online post-mod scrub failed (1).
+shared_vn = sub: offline scrub didn't fail.
+shared_vn = sub: online post-mod scrub failed (1).
+dirblklog = lastbit: offline scrub didn't fail.
+dirblklog = lastbit: online post-mod scrub failed (1).
+logsunit = zeroes: offline scrub didn't fail.
+logsunit = zeroes: online post-mod scrub failed (1).
+logsunit = lastbit: offline scrub didn't fail.
+logsunit = lastbit: online post-mod scrub failed (1).
+bad_features2 = zeroes: offline scrub didn't fail.
+bad_features2 = ones: offline scrub didn't fail.
+bad_features2 = firstbit: offline scrub didn't fail.
+bad_features2 = middlebit: offline scrub didn't fail.
+bad_features2 = lastbit: offline scrub didn't fail.
+bad_features2 = add: offline scrub didn't fail.
+bad_features2 = sub: offline scrub didn't fail.
+features_incompat = sub: offline repair failed (1).
+features_incompat = sub: offline re-scrub failed (1).
+features_incompat = sub: online post-mod scrub failed (1).
+features_incompat = sub: offline post-mod scrub failed (1).
+features_log_incompat = ones: offline scrub didn't fail.
+features_log_incompat = firstbit: offline scrub didn't fail.
+features_log_incompat = middlebit: offline scrub didn't fail.
+features_log_incompat = lastbit: offline scrub didn't fail.
+features_log_incompat = add: offline scrub didn't fail.
+features_log_incompat = sub: offline scrub didn't fail.
 Done fuzzing superblock
diff --git a/tests/xfs/425.out b/tests/xfs/425.out
index 14445b44c0..ddeb2ba6bb 100644
--- a/tests/xfs/425.out
+++ b/tests/xfs/425.out
@@ -1,4 +1,262 @@
 QA output created by 425
 Format and populate
 Fuzz user 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz user 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
+Done fuzzing dquot
+Fuzz user 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
 Done fuzzing dquot
diff --git a/tests/xfs/427.out b/tests/xfs/427.out
index 9074c64527..2a79e3e621 100644
--- a/tests/xfs/427.out
+++ b/tests/xfs/427.out
@@ -1,4 +1,262 @@
 QA output created by 427
 Format and populate
 Fuzz group 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz group 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
+Done fuzzing dquot
+Fuzz group 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
 Done fuzzing dquot
diff --git a/tests/xfs/429.out b/tests/xfs/429.out
index b5ea503b01..c212bb7fe3 100644
--- a/tests/xfs/429.out
+++ b/tests/xfs/429.out
@@ -1,4 +1,262 @@
 QA output created by 429
 Format and populate
 Fuzz project 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz project 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
+Done fuzzing dquot
+Fuzz project 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online post-mod scrub failed (1).
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online post-mod scrub failed (1).
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online post-mod scrub failed (1).
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online post-mod scrub failed (1).
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online post-mod scrub failed (1).
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online post-mod scrub failed (1).
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online post-mod scrub failed (1).
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online post-mod scrub failed (1).
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online post-mod scrub failed (1).
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online post-mod scrub failed (1).
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online post-mod scrub failed (1).
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online post-mod scrub failed (1).
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online post-mod scrub failed (1).
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online post-mod scrub failed (1).
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online post-mod scrub failed (1).
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online post-mod scrub failed (1).
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online post-mod scrub failed (1).
 Done fuzzing dquot
diff --git a/tests/xfs/496.out b/tests/xfs/496.out
index 08597a2d88..c0ed81584b 100644
--- a/tests/xfs/496.out
+++ b/tests/xfs/496.out
@@ -2,4 +2,28 @@ QA output created by 496
 Format and populate
 Find single-leafn-format dir block
 Fuzz single-leafn-format dir block
+lhdr.info.hdr.forw = ones: offline scrub didn't fail.
+lhdr.info.hdr.forw = ones: online post-mod scrub failed (1).
+lhdr.info.hdr.forw = firstbit: offline scrub didn't fail.
+lhdr.info.hdr.forw = firstbit: online post-mod scrub failed (1).
+lhdr.info.hdr.forw = middlebit: offline scrub didn't fail.
+lhdr.info.hdr.forw = middlebit: online post-mod scrub failed (1).
+lhdr.info.hdr.forw = lastbit: offline scrub didn't fail.
+lhdr.info.hdr.forw = lastbit: online post-mod scrub failed (1).
+lhdr.info.hdr.forw = add: offline scrub didn't fail.
+lhdr.info.hdr.forw = add: online post-mod scrub failed (1).
+lhdr.info.hdr.forw = sub: offline scrub didn't fail.
+lhdr.info.hdr.forw = sub: online post-mod scrub failed (1).
+lhdr.info.hdr.back = ones: offline scrub didn't fail.
+lhdr.info.hdr.back = ones: online post-mod scrub failed (1).
+lhdr.info.hdr.back = firstbit: offline scrub didn't fail.
+lhdr.info.hdr.back = firstbit: online post-mod scrub failed (1).
+lhdr.info.hdr.back = middlebit: offline scrub didn't fail.
+lhdr.info.hdr.back = middlebit: online post-mod scrub failed (1).
+lhdr.info.hdr.back = lastbit: offline scrub didn't fail.
+lhdr.info.hdr.back = lastbit: online post-mod scrub failed (1).
+lhdr.info.hdr.back = add: offline scrub didn't fail.
+lhdr.info.hdr.back = add: online post-mod scrub failed (1).
+lhdr.info.hdr.back = sub: offline scrub didn't fail.
+lhdr.info.hdr.back = sub: online post-mod scrub failed (1).
 Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/734.out b/tests/xfs/734.out
index 80b91b6a9b..68b6b7dd8a 100644
--- a/tests/xfs/734.out
+++ b/tests/xfs/734.out
@@ -3,8 +3,17 @@ Format and populate
 Fuzz block map for BLOCK
 Done fuzzing dir map BLOCK
 Fuzz block map for LEAF
+u3.bmx[0].startblock = add: offline repair failed (1).
+u3.bmx[0].startblock = add: offline re-scrub failed (1).
+u3.bmx[0].startblock = add: pre-mod mount failed (32).
+u3.bmx[1].startblock = add: offline repair failed (1).
+u3.bmx[1].startblock = add: offline re-scrub failed (1).
+u3.bmx[1].startblock = add: pre-mod mount failed (32).
 Done fuzzing dir map LEAF
 Fuzz block map for LEAFN
+u3.bmx[0].startblock = add: offline re-scrub failed (1).
+u3.bmx[0].startblock = add: online post-mod scrub failed (1).
+u3.bmx[0].startblock = add: offline post-mod scrub failed (1).
 Done fuzzing dir map LEAFN
 Fuzz block map for NODE
 Done fuzzing dir map NODE
diff --git a/tests/xfs/737.out b/tests/xfs/737.out
index 7ee0f0c625..ba2105d891 100644
--- a/tests/xfs/737.out
+++ b/tests/xfs/737.out
@@ -1,10 +1,24 @@
 QA output created by 737
 Format and populate
 Fuzz block map for EXTENTS_REMOTE3K
+a.bmx[0].blockcount = middlebit: online post-mod scrub failed (1).
+a.bmx[0].blockcount = lastbit: online post-mod scrub failed (1).
 Done fuzzing attr map EXTENTS_REMOTE3K
 Fuzz block map for EXTENTS_REMOTE4K
+a.bmx[0].blockcount = middlebit: offline repair failed (1).
+a.bmx[0].blockcount = middlebit: offline re-scrub failed (1).
+a.bmx[0].blockcount = middlebit: online post-mod scrub failed (1).
+a.bmx[0].blockcount = middlebit: offline post-mod scrub failed (1).
 Done fuzzing attr map EXTENTS_REMOTE4K
 Fuzz block map for LEAF
+a.bmx[0].blockcount = middlebit: offline repair failed (1).
+a.bmx[0].blockcount = middlebit: offline re-scrub failed (1).
+a.bmx[0].blockcount = middlebit: online post-mod scrub failed (1).
+a.bmx[0].blockcount = middlebit: offline post-mod scrub failed (1).
 Done fuzzing attr map LEAF
 Fuzz block map for NODE
+a.bmx[0].blockcount = middlebit: offline repair failed (1).
+a.bmx[0].blockcount = middlebit: offline re-scrub failed (1).
+a.bmx[0].blockcount = middlebit: online post-mod scrub failed (1).
+a.bmx[0].blockcount = middlebit: offline post-mod scrub failed (1).
 Done fuzzing attr map NODE
diff --git a/tests/xfs/754.out b/tests/xfs/754.out
index 0b8eef9ced..174c4300d8 100644
--- a/tests/xfs/754.out
+++ b/tests/xfs/754.out
@@ -1,4 +1,27 @@
 QA output created by 754
 Format and populate
 Fuzz inobt
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startino = zeroes: offline scrub didn't fail.
+keys[1].startino = ones: offline scrub didn't fail.
+keys[1].startino = firstbit: offline scrub didn't fail.
+keys[1].startino = middlebit: offline scrub didn't fail.
+keys[1].startino = lastbit: offline scrub didn't fail.
+keys[1].startino = add: offline scrub didn't fail.
+keys[1].startino = sub: offline scrub didn't fail.
+keys[2].startino = zeroes: offline scrub didn't fail.
+keys[2].startino = ones: offline scrub didn't fail.
+keys[2].startino = firstbit: offline scrub didn't fail.
+keys[2].startino = middlebit: offline scrub didn't fail.
+keys[2].startino = lastbit: offline scrub didn't fail.
+keys[2].startino = add: offline scrub didn't fail.
+keys[2].startino = sub: offline scrub didn't fail.
+keys[3].startino = zeroes: offline scrub didn't fail.
+keys[3].startino = ones: offline scrub didn't fail.
+keys[3].startino = firstbit: offline scrub didn't fail.
+keys[3].startino = middlebit: offline scrub didn't fail.
+keys[3].startino = lastbit: offline scrub didn't fail.
+keys[3].startino = add: offline scrub didn't fail.
+keys[3].startino = sub: offline scrub didn't fail.
 Done fuzzing inobt
diff --git a/tests/xfs/785.out b/tests/xfs/785.out
index f5cdc6b73d..062b80f967 100644
--- a/tests/xfs/785.out
+++ b/tests/xfs/785.out
@@ -1,4 +1,27 @@
 QA output created by 785
 Format and populate
 Fuzz inobt
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startino = zeroes: offline scrub didn't fail.
+keys[1].startino = ones: offline scrub didn't fail.
+keys[1].startino = firstbit: offline scrub didn't fail.
+keys[1].startino = middlebit: offline scrub didn't fail.
+keys[1].startino = lastbit: offline scrub didn't fail.
+keys[1].startino = add: offline scrub didn't fail.
+keys[1].startino = sub: offline scrub didn't fail.
+keys[2].startino = zeroes: offline scrub didn't fail.
+keys[2].startino = ones: offline scrub didn't fail.
+keys[2].startino = firstbit: offline scrub didn't fail.
+keys[2].startino = middlebit: offline scrub didn't fail.
+keys[2].startino = lastbit: offline scrub didn't fail.
+keys[2].startino = add: offline scrub didn't fail.
+keys[2].startino = sub: offline scrub didn't fail.
+keys[3].startino = zeroes: offline scrub didn't fail.
+keys[3].startino = ones: offline scrub didn't fail.
+keys[3].startino = firstbit: offline scrub didn't fail.
+keys[3].startino = middlebit: offline scrub didn't fail.
+keys[3].startino = lastbit: offline scrub didn't fail.
+keys[3].startino = add: offline scrub didn't fail.
+keys[3].startino = sub: offline scrub didn't fail.
 Done fuzzing inobt

