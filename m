Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ECABA32;
	Mon,  1 Jan 2024 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AI9tRzED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA09C433C8;
	Mon,  1 Jan 2024 00:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069865;
	bh=zgdsCVrSNyY99tmTP3DdmIlUQ9eQQQQ3PIDnPyCGxxA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AI9tRzEDaAosxICeiOL1mg2J1FzFhKssbWWjAw5hnMThovAJEHAufm+SyxJKDJGnq
	 iDLuFcXbc7Ho70i7zdQbq2XoJfLGeVRTvibjOten/yU4u25X0PqI+qpXyybcYLbgOi
	 398ZynmP3kWfsYcKqFlZZePggxZV5gS8OUYL1AJMjvo/V2Ax9ZVSa5ZDYodulxYMTr
	 C0JRiAbXINJxVbbvYjHgdhH0smV2GyQKZpR8B2MhakXmzBxWUi3CseAnc2MRVn6KhH
	 0SrcZncPuWAfl9guctaywIO9fxwtLqaDaltRlmXmx1TpToZIBKiFjqVT/FOWMWkdNB
	 bRNDWpBT1Mk4w==
Date: Sun, 31 Dec 2023 16:44:25 +9900
Subject: [PATCH 3/4] xfs: norepair fuzz test known output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026269.1823639.15978016282575129460.stgit@frogsfrogsfrogs>
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

Record all the currently known failures of the kernel verifier code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/453.out |  152 +++++++++++++++
 tests/xfs/454.out |   96 ++++++++++
 tests/xfs/455.out |  134 ++++++++++++++
 tests/xfs/456.out |  129 +++++++++++++
 tests/xfs/457.out |    5 +
 tests/xfs/458.out |   44 ++++
 tests/xfs/459.out |    5 +
 tests/xfs/460.out |    6 +
 tests/xfs/461.out |    6 +
 tests/xfs/462.out |    8 +
 tests/xfs/463.out |  525 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/464.out |    5 +
 tests/xfs/465.out |   71 +++++++
 tests/xfs/466.out |   51 +++++
 tests/xfs/467.out |   47 +++++
 tests/xfs/469.out |    8 +
 tests/xfs/470.out |   79 ++++++++
 tests/xfs/471.out |    7 +
 tests/xfs/472.out |    7 +
 tests/xfs/474.out |    7 +
 tests/xfs/475.out |    6 +
 tests/xfs/477.out |   79 ++++++++
 tests/xfs/478.out |   91 +++++++++
 tests/xfs/479.out |    7 +
 tests/xfs/480.out |   24 ++
 tests/xfs/483.out |    6 +
 tests/xfs/484.out |   45 +++++
 tests/xfs/485.out |   51 +++++
 tests/xfs/486.out |   46 +++++
 tests/xfs/487.out |  242 ++++++++++++++++++++++++
 tests/xfs/488.out |  242 ++++++++++++++++++++++++
 tests/xfs/489.out |  242 ++++++++++++++++++++++++
 tests/xfs/498.out |   12 +
 tests/xfs/788.out |   23 ++
 34 files changed, 2508 insertions(+)


diff --git a/tests/xfs/453.out b/tests/xfs/453.out
index 4b89bb01d8..15626b9caa 100644
--- a/tests/xfs/453.out
+++ b/tests/xfs/453.out
@@ -1,4 +1,156 @@
 QA output created by 453
 Format and populate
 Fuzz superblock
+uuid = zeroes: offline scrub didn't fail.
+uuid = zeroes: online scrub didn't fail.
+uuid = ones: offline scrub didn't fail.
+uuid = ones: online scrub didn't fail.
+uuid = firstbit: offline scrub didn't fail.
+uuid = firstbit: online scrub didn't fail.
+uuid = middlebit: offline scrub didn't fail.
+uuid = middlebit: online scrub didn't fail.
+uuid = lastbit: offline scrub didn't fail.
+uuid = lastbit: online scrub didn't fail.
+rootino = zeroes: offline scrub didn't fail.
+rootino = zeroes: online scrub didn't fail.
+rootino = ones: offline scrub didn't fail.
+rootino = ones: online scrub didn't fail.
+rootino = firstbit: offline scrub didn't fail.
+rootino = firstbit: online scrub didn't fail.
+rootino = middlebit: offline scrub didn't fail.
+rootino = middlebit: online scrub didn't fail.
+rootino = lastbit: offline scrub didn't fail.
+rootino = lastbit: online scrub didn't fail.
+rootino = add: offline scrub didn't fail.
+rootino = add: online scrub didn't fail.
+rootino = sub: offline scrub didn't fail.
+rootino = sub: online scrub didn't fail.
+metadirino = zeroes: offline scrub didn't fail.
+metadirino = zeroes: online scrub didn't fail.
+metadirino = firstbit: offline scrub didn't fail.
+metadirino = firstbit: online scrub didn't fail.
+metadirino = middlebit: offline scrub didn't fail.
+metadirino = middlebit: online scrub didn't fail.
+metadirino = lastbit: offline scrub didn't fail.
+metadirino = lastbit: online scrub didn't fail.
+metadirino = add: offline scrub didn't fail.
+metadirino = add: online scrub didn't fail.
+metadirino = sub: offline scrub didn't fail.
+metadirino = sub: online scrub didn't fail.
+rgblocks = middlebit: offline scrub didn't fail.
+rgblocks = middlebit: online scrub didn't fail.
+rgblocks = lastbit: offline scrub didn't fail.
+rgblocks = lastbit: online scrub didn't fail.
+rgblocks = add: offline scrub didn't fail.
+rgblocks = add: online scrub didn't fail.
+rgblocks = sub: offline scrub didn't fail.
+rgblocks = sub: online scrub didn't fail.
+fname = ones: offline scrub didn't fail.
+fname = ones: online scrub didn't fail.
+fname = firstbit: offline scrub didn't fail.
+fname = firstbit: online scrub didn't fail.
+fname = middlebit: offline scrub didn't fail.
+fname = middlebit: online scrub didn't fail.
+fname = lastbit: offline scrub didn't fail.
+fname = lastbit: online scrub didn't fail.
+inprogress = zeroes: offline scrub didn't fail.
+inprogress = zeroes: online scrub didn't fail.
+inprogress = ones: offline scrub didn't fail.
+inprogress = ones: online scrub didn't fail.
+inprogress = firstbit: offline scrub didn't fail.
+inprogress = firstbit: online scrub didn't fail.
+inprogress = middlebit: offline scrub didn't fail.
+inprogress = middlebit: online scrub didn't fail.
+inprogress = lastbit: offline scrub didn't fail.
+inprogress = lastbit: online scrub didn't fail.
+inprogress = add: offline scrub didn't fail.
+inprogress = add: online scrub didn't fail.
+inprogress = sub: offline scrub didn't fail.
+inprogress = sub: online scrub didn't fail.
+imax_pct = zeroes: offline scrub didn't fail.
+imax_pct = zeroes: online scrub didn't fail.
+imax_pct = middlebit: offline scrub didn't fail.
+imax_pct = middlebit: online scrub didn't fail.
+imax_pct = lastbit: offline scrub didn't fail.
+imax_pct = lastbit: online scrub didn't fail.
+icount = ones: offline scrub didn't fail.
+icount = ones: online scrub didn't fail.
+icount = firstbit: offline scrub didn't fail.
+icount = firstbit: online scrub didn't fail.
+icount = middlebit: offline scrub didn't fail.
+icount = middlebit: online scrub didn't fail.
+icount = lastbit: offline scrub didn't fail.
+icount = lastbit: online scrub didn't fail.
+icount = add: offline scrub didn't fail.
+icount = add: online scrub didn't fail.
+icount = sub: offline scrub didn't fail.
+icount = sub: online scrub didn't fail.
+ifree = ones: offline scrub didn't fail.
+ifree = ones: online scrub didn't fail.
+ifree = firstbit: offline scrub didn't fail.
+ifree = firstbit: online scrub didn't fail.
+ifree = middlebit: offline scrub didn't fail.
+ifree = middlebit: online scrub didn't fail.
+ifree = lastbit: offline scrub didn't fail.
+ifree = lastbit: online scrub didn't fail.
+ifree = add: offline scrub didn't fail.
+ifree = add: online scrub didn't fail.
+ifree = sub: offline scrub didn't fail.
+ifree = sub: online scrub didn't fail.
+fdblocks = zeroes: offline scrub didn't fail.
+fdblocks = zeroes: online scrub didn't fail.
+fdblocks = ones: offline scrub didn't fail.
+fdblocks = ones: online scrub didn't fail.
+fdblocks = firstbit: offline scrub didn't fail.
+fdblocks = firstbit: online scrub didn't fail.
+fdblocks = middlebit: offline scrub didn't fail.
+fdblocks = middlebit: online scrub didn't fail.
+fdblocks = lastbit: offline scrub didn't fail.
+fdblocks = lastbit: online scrub didn't fail.
+fdblocks = add: offline scrub didn't fail.
+fdblocks = add: online scrub didn't fail.
+fdblocks = sub: offline scrub didn't fail.
+fdblocks = sub: online scrub didn't fail.
+qflags = firstbit: online scrub didn't fail.
+qflags = middlebit: online scrub didn't fail.
+qflags = lastbit: online scrub didn't fail.
+shared_vn = ones: offline scrub didn't fail.
+shared_vn = firstbit: offline scrub didn't fail.
+shared_vn = middlebit: offline scrub didn't fail.
+shared_vn = lastbit: offline scrub didn't fail.
+shared_vn = add: offline scrub didn't fail.
+shared_vn = sub: offline scrub didn't fail.
+dirblklog = lastbit: offline scrub didn't fail.
+logsunit = zeroes: offline scrub didn't fail.
+logsunit = lastbit: offline scrub didn't fail.
+bad_features2 = zeroes: offline scrub didn't fail.
+bad_features2 = zeroes: online scrub didn't fail.
+bad_features2 = ones: offline scrub didn't fail.
+bad_features2 = ones: online scrub didn't fail.
+bad_features2 = firstbit: offline scrub didn't fail.
+bad_features2 = firstbit: online scrub didn't fail.
+bad_features2 = middlebit: offline scrub didn't fail.
+bad_features2 = middlebit: online scrub didn't fail.
+bad_features2 = lastbit: offline scrub didn't fail.
+bad_features2 = lastbit: online scrub didn't fail.
+bad_features2 = add: offline scrub didn't fail.
+bad_features2 = add: online scrub didn't fail.
+bad_features2 = sub: offline scrub didn't fail.
+bad_features2 = sub: online scrub didn't fail.
+features_log_incompat = ones: offline scrub didn't fail.
+features_log_incompat = ones: online scrub didn't fail.
+features_log_incompat = firstbit: offline scrub didn't fail.
+features_log_incompat = firstbit: online scrub didn't fail.
+features_log_incompat = middlebit: offline scrub didn't fail.
+features_log_incompat = middlebit: online scrub didn't fail.
+features_log_incompat = lastbit: offline scrub didn't fail.
+features_log_incompat = lastbit: online scrub didn't fail.
+features_log_incompat = add: offline scrub didn't fail.
+features_log_incompat = add: online scrub didn't fail.
+features_log_incompat = sub: offline scrub didn't fail.
+features_log_incompat = sub: online scrub didn't fail.
+meta_uuid = ones: online scrub didn't fail.
+meta_uuid = firstbit: online scrub didn't fail.
+meta_uuid = middlebit: online scrub didn't fail.
+meta_uuid = lastbit: online scrub didn't fail.
 Done fuzzing superblock
diff --git a/tests/xfs/454.out b/tests/xfs/454.out
index ba7a8c24ba..dc89b2a488 100644
--- a/tests/xfs/454.out
+++ b/tests/xfs/454.out
@@ -1,4 +1,100 @@
 QA output created by 454
 Format and populate
 Fuzz AGF
+magicnum = zeroes: mount failed (32).
+magicnum = ones: mount failed (32).
+magicnum = firstbit: mount failed (32).
+magicnum = middlebit: mount failed (32).
+magicnum = lastbit: mount failed (32).
+magicnum = add: mount failed (32).
+magicnum = sub: mount failed (32).
+versionnum = zeroes: mount failed (32).
+versionnum = ones: mount failed (32).
+versionnum = firstbit: mount failed (32).
+versionnum = middlebit: mount failed (32).
+versionnum = lastbit: mount failed (32).
+versionnum = add: mount failed (32).
+versionnum = sub: mount failed (32).
+seqno = ones: mount failed (32).
+seqno = firstbit: mount failed (32).
+seqno = middlebit: mount failed (32).
+seqno = lastbit: mount failed (32).
+seqno = add: mount failed (32).
+seqno = sub: mount failed (32).
+length = zeroes: mount failed (32).
+length = ones: mount failed (32).
+length = firstbit: mount failed (32).
+length = middlebit: mount failed (32).
+length = lastbit: mount failed (32).
+length = add: mount failed (32).
+length = sub: mount failed (32).
+bnolevel = zeroes: mount failed (32).
+bnolevel = ones: mount failed (32).
+bnolevel = firstbit: mount failed (32).
+bnolevel = middlebit: mount failed (32).
+bnolevel = add: mount failed (32).
+bnolevel = sub: mount failed (32).
+cntlevel = zeroes: mount failed (32).
+cntlevel = ones: mount failed (32).
+cntlevel = firstbit: mount failed (32).
+cntlevel = middlebit: mount failed (32).
+cntlevel = add: mount failed (32).
+cntlevel = sub: mount failed (32).
+rmaplevel = zeroes: mount failed (32).
+rmaplevel = ones: mount failed (32).
+rmaplevel = firstbit: mount failed (32).
+rmaplevel = middlebit: mount failed (32).
+rmaplevel = add: mount failed (32).
+rmaplevel = sub: mount failed (32).
+refcntlevel = zeroes: mount failed (32).
+refcntlevel = ones: mount failed (32).
+refcntlevel = firstbit: mount failed (32).
+refcntlevel = middlebit: mount failed (32).
+refcntlevel = add: mount failed (32).
+refcntlevel = sub: mount failed (32).
+rmapblocks = ones: mount failed (32).
+rmapblocks = firstbit: mount failed (32).
+rmapblocks = sub: mount failed (32).
+refcntblocks = ones: mount failed (32).
+refcntblocks = firstbit: mount failed (32).
+refcntblocks = sub: mount failed (32).
+flfirst = ones: mount failed (32).
+flfirst = firstbit: mount failed (32).
+flfirst = middlebit: mount failed (32).
+flfirst = add: mount failed (32).
+flfirst = sub: mount failed (32).
+fllast = ones: mount failed (32).
+fllast = firstbit: mount failed (32).
+fllast = middlebit: mount failed (32).
+fllast = add: mount failed (32).
+fllast = sub: mount failed (32).
+flcount = ones: mount failed (32).
+flcount = firstbit: mount failed (32).
+flcount = middlebit: mount failed (32).
+flcount = add: mount failed (32).
+flcount = sub: mount failed (32).
+freeblks = zeroes: mount failed (32).
+freeblks = ones: mount failed (32).
+freeblks = firstbit: mount failed (32).
+freeblks = middlebit: mount failed (32).
+freeblks = add: mount failed (32).
+freeblks = sub: mount failed (32).
+longest = ones: mount failed (32).
+longest = firstbit: mount failed (32).
+longest = add: mount failed (32).
+btreeblks = ones: mount failed (32).
+btreeblks = firstbit: mount failed (32).
+btreeblks = sub: mount failed (32).
+uuid = zeroes: mount failed (32).
+uuid = ones: mount failed (32).
+uuid = firstbit: mount failed (32).
+uuid = middlebit: mount failed (32).
+uuid = lastbit: mount failed (32).
+crc = zeroes: mount failed (32).
+crc = ones: mount failed (32).
+crc = firstbit: mount failed (32).
+crc = middlebit: mount failed (32).
+crc = lastbit: mount failed (32).
+crc = add: mount failed (32).
+crc = sub: mount failed (32).
 Done fuzzing AGF
diff --git a/tests/xfs/455.out b/tests/xfs/455.out
index ff68505f92..ffe9c557a1 100644
--- a/tests/xfs/455.out
+++ b/tests/xfs/455.out
@@ -1,6 +1,140 @@
 QA output created by 455
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
+bno[0] = zeroes: online scrub didn't fail.
+bno[0] = firstbit: offline scrub didn't fail.
+bno[0] = middlebit: offline scrub didn't fail.
+bno[0] = lastbit: offline scrub didn't fail.
+bno[0] = add: offline scrub didn't fail.
+bno[0] = add: online scrub didn't fail.
+bno[0] = sub: offline scrub didn't fail.
+bno[1] = zeroes: offline scrub didn't fail.
+bno[1] = zeroes: online scrub didn't fail.
+bno[1] = ones: offline scrub didn't fail.
+bno[1] = ones: online scrub didn't fail.
+bno[1] = firstbit: offline scrub didn't fail.
+bno[1] = middlebit: offline scrub didn't fail.
+bno[1] = middlebit: online scrub didn't fail.
+bno[1] = lastbit: offline scrub didn't fail.
+bno[1] = lastbit: online scrub didn't fail.
+bno[1] = add: offline scrub didn't fail.
+bno[1] = add: online scrub didn't fail.
+bno[1] = sub: offline scrub didn't fail.
+bno[2] = zeroes: offline scrub didn't fail.
+bno[2] = zeroes: online scrub didn't fail.
+bno[2] = ones: offline scrub didn't fail.
+bno[2] = ones: online scrub didn't fail.
+bno[2] = firstbit: offline scrub didn't fail.
+bno[2] = middlebit: offline scrub didn't fail.
+bno[2] = middlebit: online scrub didn't fail.
+bno[2] = lastbit: offline scrub didn't fail.
+bno[2] = lastbit: online scrub didn't fail.
+bno[2] = add: offline scrub didn't fail.
+bno[2] = add: online scrub didn't fail.
+bno[2] = sub: offline scrub didn't fail.
+bno[3] = zeroes: offline scrub didn't fail.
+bno[3] = zeroes: online scrub didn't fail.
+bno[3] = ones: offline scrub didn't fail.
+bno[3] = ones: online scrub didn't fail.
+bno[3] = firstbit: offline scrub didn't fail.
+bno[3] = middlebit: offline scrub didn't fail.
+bno[3] = middlebit: online scrub didn't fail.
+bno[3] = lastbit: offline scrub didn't fail.
+bno[3] = lastbit: online scrub didn't fail.
+bno[3] = add: offline scrub didn't fail.
+bno[3] = add: online scrub didn't fail.
+bno[3] = sub: offline scrub didn't fail.
+bno[4] = zeroes: offline scrub didn't fail.
+bno[4] = zeroes: online scrub didn't fail.
+bno[4] = ones: offline scrub didn't fail.
+bno[4] = ones: online scrub didn't fail.
+bno[4] = firstbit: offline scrub didn't fail.
+bno[4] = middlebit: offline scrub didn't fail.
+bno[4] = middlebit: online scrub didn't fail.
+bno[4] = lastbit: offline scrub didn't fail.
+bno[4] = lastbit: online scrub didn't fail.
+bno[4] = add: offline scrub didn't fail.
+bno[4] = add: online scrub didn't fail.
+bno[4] = sub: offline scrub didn't fail.
+bno[5] = zeroes: offline scrub didn't fail.
+bno[5] = zeroes: online scrub didn't fail.
+bno[5] = ones: offline scrub didn't fail.
+bno[5] = ones: online scrub didn't fail.
+bno[5] = firstbit: offline scrub didn't fail.
+bno[5] = middlebit: offline scrub didn't fail.
+bno[5] = middlebit: online scrub didn't fail.
+bno[5] = lastbit: offline scrub didn't fail.
+bno[5] = lastbit: online scrub didn't fail.
+bno[5] = add: offline scrub didn't fail.
+bno[5] = add: online scrub didn't fail.
+bno[5] = sub: offline scrub didn't fail.
+bno[6] = zeroes: offline scrub didn't fail.
+bno[6] = zeroes: online scrub didn't fail.
+bno[6] = ones: offline scrub didn't fail.
+bno[6] = ones: online scrub didn't fail.
+bno[6] = firstbit: offline scrub didn't fail.
+bno[6] = middlebit: offline scrub didn't fail.
+bno[6] = middlebit: online scrub didn't fail.
+bno[6] = lastbit: offline scrub didn't fail.
+bno[6] = lastbit: online scrub didn't fail.
+bno[6] = add: offline scrub didn't fail.
+bno[6] = add: online scrub didn't fail.
+bno[6] = sub: offline scrub didn't fail.
+bno[7] = zeroes: offline scrub didn't fail.
+bno[7] = zeroes: online scrub didn't fail.
+bno[7] = ones: offline scrub didn't fail.
+bno[7] = ones: online scrub didn't fail.
+bno[7] = firstbit: offline scrub didn't fail.
+bno[7] = middlebit: offline scrub didn't fail.
+bno[7] = middlebit: online scrub didn't fail.
+bno[7] = lastbit: offline scrub didn't fail.
+bno[7] = lastbit: online scrub didn't fail.
+bno[7] = add: offline scrub didn't fail.
+bno[7] = add: online scrub didn't fail.
+bno[7] = sub: offline scrub didn't fail.
+bno[8] = zeroes: offline scrub didn't fail.
+bno[8] = zeroes: online scrub didn't fail.
+bno[8] = ones: offline scrub didn't fail.
+bno[8] = ones: online scrub didn't fail.
+bno[8] = firstbit: offline scrub didn't fail.
+bno[8] = middlebit: offline scrub didn't fail.
+bno[8] = middlebit: online scrub didn't fail.
+bno[8] = lastbit: offline scrub didn't fail.
+bno[8] = lastbit: online scrub didn't fail.
+bno[8] = add: offline scrub didn't fail.
+bno[8] = add: online scrub didn't fail.
+bno[8] = sub: offline scrub didn't fail.
+bno[9] = zeroes: offline scrub didn't fail.
+bno[9] = zeroes: online scrub didn't fail.
+bno[9] = ones: offline scrub didn't fail.
+bno[9] = ones: online scrub didn't fail.
+bno[9] = firstbit: offline scrub didn't fail.
+bno[9] = middlebit: offline scrub didn't fail.
+bno[9] = middlebit: online scrub didn't fail.
+bno[9] = lastbit: offline scrub didn't fail.
+bno[9] = lastbit: online scrub didn't fail.
+bno[9] = add: offline scrub didn't fail.
+bno[9] = add: online scrub didn't fail.
+bno[9] = sub: offline scrub didn't fail.
 Done fuzzing AGFL
 Fuzz AGFL flfirst
 Done fuzzing AGFL flfirst
diff --git a/tests/xfs/456.out b/tests/xfs/456.out
index 75c6ef160c..a896b754ed 100644
--- a/tests/xfs/456.out
+++ b/tests/xfs/456.out
@@ -1,4 +1,133 @@
 QA output created by 456
 Format and populate
 Fuzz AGI
+magicnum = zeroes: mount failed (32).
+magicnum = ones: mount failed (32).
+magicnum = firstbit: mount failed (32).
+magicnum = middlebit: mount failed (32).
+magicnum = lastbit: mount failed (32).
+magicnum = add: mount failed (32).
+magicnum = sub: mount failed (32).
+versionnum = zeroes: mount failed (32).
+versionnum = ones: mount failed (32).
+versionnum = firstbit: mount failed (32).
+versionnum = middlebit: mount failed (32).
+versionnum = lastbit: mount failed (32).
+versionnum = add: mount failed (32).
+versionnum = sub: mount failed (32).
+seqno = ones: mount failed (32).
+seqno = firstbit: mount failed (32).
+seqno = middlebit: mount failed (32).
+seqno = lastbit: mount failed (32).
+seqno = add: mount failed (32).
+seqno = sub: mount failed (32).
+length = zeroes: mount failed (32).
+length = ones: mount failed (32).
+length = firstbit: mount failed (32).
+length = middlebit: mount failed (32).
+length = lastbit: mount failed (32).
+length = add: mount failed (32).
+length = sub: mount failed (32).
+root = zeroes: mount failed (32).
+root = ones: mount failed (32).
+root = firstbit: mount failed (32).
+root = middlebit: mount failed (32).
+root = lastbit: mount failed (32).
+root = add: mount failed (32).
+root = sub: mount failed (32).
+level = zeroes: mount failed (32).
+level = ones: mount failed (32).
+level = firstbit: mount failed (32).
+level = middlebit: mount failed (32).
+level = lastbit: mount failed (32).
+level = add: mount failed (32).
+level = sub: mount failed (32).
+newino = zeroes: offline scrub didn't fail.
+newino = ones: offline scrub didn't fail.
+newino = ones: online scrub didn't fail.
+newino = firstbit: offline scrub didn't fail.
+newino = middlebit: offline scrub didn't fail.
+newino = middlebit: online scrub didn't fail.
+newino = lastbit: offline scrub didn't fail.
+newino = lastbit: online scrub didn't fail.
+newino = add: offline scrub didn't fail.
+newino = add: online scrub didn't fail.
+newino = sub: offline scrub didn't fail.
+newino = sub: online scrub didn't fail.
+dirino = zeroes: offline scrub didn't fail.
+dirino = firstbit: offline scrub didn't fail.
+dirino = middlebit: offline scrub didn't fail.
+dirino = lastbit: offline scrub didn't fail.
+dirino = add: offline scrub didn't fail.
+dirino = add: online scrub didn't fail.
+dirino = sub: offline scrub didn't fail.
+unlinked[0] = zeroes: mount failed (32).
+unlinked[0] = firstbit: mount failed (32).
+unlinked[0] = middlebit: mount failed (32).
+unlinked[0] = lastbit: mount failed (32).
+unlinked[0] = sub: mount failed (32).
+unlinked[1] = zeroes: mount failed (32).
+unlinked[1] = firstbit: mount failed (32).
+unlinked[1] = middlebit: mount failed (32).
+unlinked[1] = lastbit: mount failed (32).
+unlinked[1] = sub: mount failed (32).
+unlinked[2] = zeroes: mount failed (32).
+unlinked[2] = firstbit: mount failed (32).
+unlinked[2] = middlebit: mount failed (32).
+unlinked[2] = lastbit: mount failed (32).
+unlinked[2] = sub: mount failed (32).
+unlinked[3] = zeroes: mount failed (32).
+unlinked[3] = firstbit: mount failed (32).
+unlinked[3] = middlebit: mount failed (32).
+unlinked[3] = lastbit: mount failed (32).
+unlinked[3] = sub: mount failed (32).
+unlinked[4] = zeroes: mount failed (32).
+unlinked[4] = firstbit: mount failed (32).
+unlinked[4] = middlebit: mount failed (32).
+unlinked[4] = lastbit: mount failed (32).
+unlinked[4] = sub: mount failed (32).
+unlinked[5] = zeroes: mount failed (32).
+unlinked[5] = firstbit: mount failed (32).
+unlinked[5] = middlebit: mount failed (32).
+unlinked[5] = lastbit: mount failed (32).
+unlinked[5] = sub: mount failed (32).
+unlinked[6] = zeroes: mount failed (32).
+unlinked[6] = firstbit: mount failed (32).
+unlinked[6] = middlebit: mount failed (32).
+unlinked[6] = lastbit: mount failed (32).
+unlinked[6] = sub: mount failed (32).
+unlinked[7] = zeroes: mount failed (32).
+unlinked[7] = firstbit: mount failed (32).
+unlinked[7] = middlebit: mount failed (32).
+unlinked[7] = lastbit: mount failed (32).
+unlinked[7] = sub: mount failed (32).
+unlinked[8] = zeroes: mount failed (32).
+unlinked[8] = firstbit: mount failed (32).
+unlinked[8] = middlebit: mount failed (32).
+unlinked[8] = lastbit: mount failed (32).
+unlinked[8] = sub: mount failed (32).
+unlinked[9] = zeroes: mount failed (32).
+unlinked[9] = firstbit: mount failed (32).
+unlinked[9] = middlebit: mount failed (32).
+unlinked[9] = lastbit: mount failed (32).
+unlinked[9] = sub: mount failed (32).
+uuid = zeroes: mount failed (32).
+uuid = ones: mount failed (32).
+uuid = firstbit: mount failed (32).
+uuid = middlebit: mount failed (32).
+uuid = lastbit: mount failed (32).
+crc = zeroes: mount failed (32).
+crc = ones: mount failed (32).
+crc = firstbit: mount failed (32).
+crc = middlebit: mount failed (32).
+crc = lastbit: mount failed (32).
+crc = add: mount failed (32).
+crc = sub: mount failed (32).
+free_level = zeroes: mount failed (32).
+free_level = ones: mount failed (32).
+free_level = firstbit: mount failed (32).
+free_level = middlebit: mount failed (32).
+free_level = lastbit: mount failed (32).
+free_level = add: mount failed (32).
+free_level = sub: mount failed (32).
 Done fuzzing AGI
diff --git a/tests/xfs/457.out b/tests/xfs/457.out
index 9d5c40150c..414fd7096e 100644
--- a/tests/xfs/457.out
+++ b/tests/xfs/457.out
@@ -1,4 +1,9 @@
 QA output created by 457
 Format and populate
 Fuzz bnobt recs
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing bnobt recs
diff --git a/tests/xfs/458.out b/tests/xfs/458.out
index a6ab9879c2..ba9de90280 100644
--- a/tests/xfs/458.out
+++ b/tests/xfs/458.out
@@ -1,4 +1,48 @@
 QA output created by 458
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
+keys[1].blockcount = zeroes: online scrub didn't fail.
+keys[1].blockcount = ones: offline scrub didn't fail.
+keys[1].blockcount = ones: online scrub didn't fail.
+keys[1].blockcount = firstbit: offline scrub didn't fail.
+keys[1].blockcount = firstbit: online scrub didn't fail.
+keys[1].blockcount = middlebit: offline scrub didn't fail.
+keys[1].blockcount = middlebit: online scrub didn't fail.
+keys[1].blockcount = lastbit: offline scrub didn't fail.
+keys[1].blockcount = lastbit: online scrub didn't fail.
+keys[1].blockcount = add: offline scrub didn't fail.
+keys[1].blockcount = add: online scrub didn't fail.
+keys[1].blockcount = sub: offline scrub didn't fail.
+keys[1].blockcount = sub: online scrub didn't fail.
+keys[2].startblock = zeroes: offline scrub didn't fail.
+keys[2].startblock = ones: offline scrub didn't fail.
+keys[2].startblock = firstbit: offline scrub didn't fail.
+keys[2].startblock = middlebit: offline scrub didn't fail.
+keys[2].startblock = lastbit: offline scrub didn't fail.
+keys[2].startblock = add: offline scrub didn't fail.
+keys[2].startblock = sub: offline scrub didn't fail.
+keys[2].blockcount = zeroes: offline scrub didn't fail.
+keys[2].blockcount = zeroes: online scrub didn't fail.
+keys[2].blockcount = ones: offline scrub didn't fail.
+keys[2].blockcount = ones: online scrub didn't fail.
+keys[2].blockcount = firstbit: offline scrub didn't fail.
+keys[2].blockcount = firstbit: online scrub didn't fail.
+keys[2].blockcount = middlebit: offline scrub didn't fail.
+keys[2].blockcount = middlebit: online scrub didn't fail.
+keys[2].blockcount = lastbit: offline scrub didn't fail.
+keys[2].blockcount = lastbit: online scrub didn't fail.
+keys[2].blockcount = add: offline scrub didn't fail.
+keys[2].blockcount = add: online scrub didn't fail.
+keys[2].blockcount = sub: offline scrub didn't fail.
+keys[2].blockcount = sub: online scrub didn't fail.
 Done fuzzing bnobt keyptr
diff --git a/tests/xfs/459.out b/tests/xfs/459.out
index 3100f78360..9b39b14e97 100644
--- a/tests/xfs/459.out
+++ b/tests/xfs/459.out
@@ -1,4 +1,9 @@
 QA output created by 459
 Format and populate
 Fuzz cntbt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing cntbt
diff --git a/tests/xfs/460.out b/tests/xfs/460.out
index 3ca46b4c4c..e8bb9625ab 100644
--- a/tests/xfs/460.out
+++ b/tests/xfs/460.out
@@ -1,4 +1,10 @@
 QA output created by 460
 Format and populate
 Fuzz inobt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+rightsib = sub: offline scrub didn't fail.
 Done fuzzing inobt
diff --git a/tests/xfs/461.out b/tests/xfs/461.out
index 8d616bf2fd..429b1711d1 100644
--- a/tests/xfs/461.out
+++ b/tests/xfs/461.out
@@ -1,4 +1,10 @@
 QA output created by 461
 Format and populate
 Fuzz finobt
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+rightsib = sub: offline scrub didn't fail.
 Done fuzzing finobt
diff --git a/tests/xfs/462.out b/tests/xfs/462.out
index 4ff2d33b7c..842095dc9b 100644
--- a/tests/xfs/462.out
+++ b/tests/xfs/462.out
@@ -1,4 +1,12 @@
 QA output created by 462
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
diff --git a/tests/xfs/463.out b/tests/xfs/463.out
index 87d2eef540..a7482abdb9 100644
--- a/tests/xfs/463.out
+++ b/tests/xfs/463.out
@@ -1,4 +1,529 @@
 QA output created by 463
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
+keys[1].extentflag = ones: online scrub didn't fail.
+keys[1].extentflag = firstbit: offline scrub didn't fail.
+keys[1].extentflag = firstbit: online scrub didn't fail.
+keys[1].extentflag = middlebit: offline scrub didn't fail.
+keys[1].extentflag = middlebit: online scrub didn't fail.
+keys[1].extentflag = lastbit: offline scrub didn't fail.
+keys[1].extentflag = lastbit: online scrub didn't fail.
+keys[1].extentflag = add: offline scrub didn't fail.
+keys[1].extentflag = add: online scrub didn't fail.
+keys[1].extentflag = sub: offline scrub didn't fail.
+keys[1].extentflag = sub: online scrub didn't fail.
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
+keys[1].extentflag_hi = ones: online scrub didn't fail.
+keys[1].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[1].extentflag_hi = firstbit: online scrub didn't fail.
+keys[1].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[1].extentflag_hi = middlebit: online scrub didn't fail.
+keys[1].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[1].extentflag_hi = lastbit: online scrub didn't fail.
+keys[1].extentflag_hi = add: offline scrub didn't fail.
+keys[1].extentflag_hi = add: online scrub didn't fail.
+keys[1].extentflag_hi = sub: offline scrub didn't fail.
+keys[1].extentflag_hi = sub: online scrub didn't fail.
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
+keys[2].extentflag = ones: online scrub didn't fail.
+keys[2].extentflag = firstbit: offline scrub didn't fail.
+keys[2].extentflag = firstbit: online scrub didn't fail.
+keys[2].extentflag = middlebit: offline scrub didn't fail.
+keys[2].extentflag = middlebit: online scrub didn't fail.
+keys[2].extentflag = lastbit: offline scrub didn't fail.
+keys[2].extentflag = lastbit: online scrub didn't fail.
+keys[2].extentflag = add: offline scrub didn't fail.
+keys[2].extentflag = add: online scrub didn't fail.
+keys[2].extentflag = sub: offline scrub didn't fail.
+keys[2].extentflag = sub: online scrub didn't fail.
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
+keys[2].extentflag_hi = ones: online scrub didn't fail.
+keys[2].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[2].extentflag_hi = firstbit: online scrub didn't fail.
+keys[2].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[2].extentflag_hi = middlebit: online scrub didn't fail.
+keys[2].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[2].extentflag_hi = lastbit: online scrub didn't fail.
+keys[2].extentflag_hi = add: offline scrub didn't fail.
+keys[2].extentflag_hi = add: online scrub didn't fail.
+keys[2].extentflag_hi = sub: offline scrub didn't fail.
+keys[2].extentflag_hi = sub: online scrub didn't fail.
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
+keys[3].extentflag = ones: online scrub didn't fail.
+keys[3].extentflag = firstbit: offline scrub didn't fail.
+keys[3].extentflag = firstbit: online scrub didn't fail.
+keys[3].extentflag = middlebit: offline scrub didn't fail.
+keys[3].extentflag = middlebit: online scrub didn't fail.
+keys[3].extentflag = lastbit: offline scrub didn't fail.
+keys[3].extentflag = lastbit: online scrub didn't fail.
+keys[3].extentflag = add: offline scrub didn't fail.
+keys[3].extentflag = add: online scrub didn't fail.
+keys[3].extentflag = sub: offline scrub didn't fail.
+keys[3].extentflag = sub: online scrub didn't fail.
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
+keys[3].extentflag_hi = ones: online scrub didn't fail.
+keys[3].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[3].extentflag_hi = firstbit: online scrub didn't fail.
+keys[3].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[3].extentflag_hi = middlebit: online scrub didn't fail.
+keys[3].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[3].extentflag_hi = lastbit: online scrub didn't fail.
+keys[3].extentflag_hi = add: offline scrub didn't fail.
+keys[3].extentflag_hi = add: online scrub didn't fail.
+keys[3].extentflag_hi = sub: offline scrub didn't fail.
+keys[3].extentflag_hi = sub: online scrub didn't fail.
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
+keys[4].extentflag = ones: online scrub didn't fail.
+keys[4].extentflag = firstbit: offline scrub didn't fail.
+keys[4].extentflag = firstbit: online scrub didn't fail.
+keys[4].extentflag = middlebit: offline scrub didn't fail.
+keys[4].extentflag = middlebit: online scrub didn't fail.
+keys[4].extentflag = lastbit: offline scrub didn't fail.
+keys[4].extentflag = lastbit: online scrub didn't fail.
+keys[4].extentflag = add: offline scrub didn't fail.
+keys[4].extentflag = add: online scrub didn't fail.
+keys[4].extentflag = sub: offline scrub didn't fail.
+keys[4].extentflag = sub: online scrub didn't fail.
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
+keys[4].extentflag_hi = ones: online scrub didn't fail.
+keys[4].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[4].extentflag_hi = firstbit: online scrub didn't fail.
+keys[4].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[4].extentflag_hi = middlebit: online scrub didn't fail.
+keys[4].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[4].extentflag_hi = lastbit: online scrub didn't fail.
+keys[4].extentflag_hi = add: offline scrub didn't fail.
+keys[4].extentflag_hi = add: online scrub didn't fail.
+keys[4].extentflag_hi = sub: offline scrub didn't fail.
+keys[4].extentflag_hi = sub: online scrub didn't fail.
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
+keys[5].extentflag = ones: online scrub didn't fail.
+keys[5].extentflag = firstbit: offline scrub didn't fail.
+keys[5].extentflag = firstbit: online scrub didn't fail.
+keys[5].extentflag = middlebit: offline scrub didn't fail.
+keys[5].extentflag = middlebit: online scrub didn't fail.
+keys[5].extentflag = lastbit: offline scrub didn't fail.
+keys[5].extentflag = lastbit: online scrub didn't fail.
+keys[5].extentflag = add: offline scrub didn't fail.
+keys[5].extentflag = add: online scrub didn't fail.
+keys[5].extentflag = sub: offline scrub didn't fail.
+keys[5].extentflag = sub: online scrub didn't fail.
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
+keys[5].extentflag_hi = ones: online scrub didn't fail.
+keys[5].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[5].extentflag_hi = firstbit: online scrub didn't fail.
+keys[5].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[5].extentflag_hi = middlebit: online scrub didn't fail.
+keys[5].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[5].extentflag_hi = lastbit: online scrub didn't fail.
+keys[5].extentflag_hi = add: offline scrub didn't fail.
+keys[5].extentflag_hi = add: online scrub didn't fail.
+keys[5].extentflag_hi = sub: offline scrub didn't fail.
+keys[5].extentflag_hi = sub: online scrub didn't fail.
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
+keys[6].extentflag = ones: online scrub didn't fail.
+keys[6].extentflag = firstbit: offline scrub didn't fail.
+keys[6].extentflag = firstbit: online scrub didn't fail.
+keys[6].extentflag = middlebit: offline scrub didn't fail.
+keys[6].extentflag = middlebit: online scrub didn't fail.
+keys[6].extentflag = lastbit: offline scrub didn't fail.
+keys[6].extentflag = lastbit: online scrub didn't fail.
+keys[6].extentflag = add: offline scrub didn't fail.
+keys[6].extentflag = add: online scrub didn't fail.
+keys[6].extentflag = sub: offline scrub didn't fail.
+keys[6].extentflag = sub: online scrub didn't fail.
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
+keys[6].extentflag_hi = ones: online scrub didn't fail.
+keys[6].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[6].extentflag_hi = firstbit: online scrub didn't fail.
+keys[6].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[6].extentflag_hi = middlebit: online scrub didn't fail.
+keys[6].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[6].extentflag_hi = lastbit: online scrub didn't fail.
+keys[6].extentflag_hi = add: offline scrub didn't fail.
+keys[6].extentflag_hi = add: online scrub didn't fail.
+keys[6].extentflag_hi = sub: offline scrub didn't fail.
+keys[6].extentflag_hi = sub: online scrub didn't fail.
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
+keys[7].extentflag = ones: online scrub didn't fail.
+keys[7].extentflag = firstbit: offline scrub didn't fail.
+keys[7].extentflag = firstbit: online scrub didn't fail.
+keys[7].extentflag = middlebit: offline scrub didn't fail.
+keys[7].extentflag = middlebit: online scrub didn't fail.
+keys[7].extentflag = lastbit: offline scrub didn't fail.
+keys[7].extentflag = lastbit: online scrub didn't fail.
+keys[7].extentflag = add: offline scrub didn't fail.
+keys[7].extentflag = add: online scrub didn't fail.
+keys[7].extentflag = sub: offline scrub didn't fail.
+keys[7].extentflag = sub: online scrub didn't fail.
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
+keys[7].extentflag_hi = ones: online scrub didn't fail.
+keys[7].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[7].extentflag_hi = firstbit: online scrub didn't fail.
+keys[7].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[7].extentflag_hi = middlebit: online scrub didn't fail.
+keys[7].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[7].extentflag_hi = lastbit: online scrub didn't fail.
+keys[7].extentflag_hi = add: offline scrub didn't fail.
+keys[7].extentflag_hi = add: online scrub didn't fail.
+keys[7].extentflag_hi = sub: offline scrub didn't fail.
+keys[7].extentflag_hi = sub: online scrub didn't fail.
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
+keys[8].extentflag = ones: online scrub didn't fail.
+keys[8].extentflag = firstbit: offline scrub didn't fail.
+keys[8].extentflag = firstbit: online scrub didn't fail.
+keys[8].extentflag = middlebit: offline scrub didn't fail.
+keys[8].extentflag = middlebit: online scrub didn't fail.
+keys[8].extentflag = lastbit: offline scrub didn't fail.
+keys[8].extentflag = lastbit: online scrub didn't fail.
+keys[8].extentflag = add: offline scrub didn't fail.
+keys[8].extentflag = add: online scrub didn't fail.
+keys[8].extentflag = sub: offline scrub didn't fail.
+keys[8].extentflag = sub: online scrub didn't fail.
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
+keys[8].extentflag_hi = ones: online scrub didn't fail.
+keys[8].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[8].extentflag_hi = firstbit: online scrub didn't fail.
+keys[8].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[8].extentflag_hi = middlebit: online scrub didn't fail.
+keys[8].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[8].extentflag_hi = lastbit: online scrub didn't fail.
+keys[8].extentflag_hi = add: offline scrub didn't fail.
+keys[8].extentflag_hi = add: online scrub didn't fail.
+keys[8].extentflag_hi = sub: offline scrub didn't fail.
+keys[8].extentflag_hi = sub: online scrub didn't fail.
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
+keys[9].extentflag = ones: online scrub didn't fail.
+keys[9].extentflag = firstbit: offline scrub didn't fail.
+keys[9].extentflag = firstbit: online scrub didn't fail.
+keys[9].extentflag = middlebit: offline scrub didn't fail.
+keys[9].extentflag = middlebit: online scrub didn't fail.
+keys[9].extentflag = lastbit: offline scrub didn't fail.
+keys[9].extentflag = lastbit: online scrub didn't fail.
+keys[9].extentflag = add: offline scrub didn't fail.
+keys[9].extentflag = add: online scrub didn't fail.
+keys[9].extentflag = sub: offline scrub didn't fail.
+keys[9].extentflag = sub: online scrub didn't fail.
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
+keys[9].extentflag_hi = ones: online scrub didn't fail.
+keys[9].extentflag_hi = firstbit: offline scrub didn't fail.
+keys[9].extentflag_hi = firstbit: online scrub didn't fail.
+keys[9].extentflag_hi = middlebit: offline scrub didn't fail.
+keys[9].extentflag_hi = middlebit: online scrub didn't fail.
+keys[9].extentflag_hi = lastbit: offline scrub didn't fail.
+keys[9].extentflag_hi = lastbit: online scrub didn't fail.
+keys[9].extentflag_hi = add: offline scrub didn't fail.
+keys[9].extentflag_hi = add: online scrub didn't fail.
+keys[9].extentflag_hi = sub: offline scrub didn't fail.
+keys[9].extentflag_hi = sub: online scrub didn't fail.
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
diff --git a/tests/xfs/464.out b/tests/xfs/464.out
index fd949298f5..a949fa0875 100644
--- a/tests/xfs/464.out
+++ b/tests/xfs/464.out
@@ -1,4 +1,9 @@
 QA output created by 464
 Format and populate
 Fuzz refcountbt
+leftsib = add: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
+keys[1].startblock = zeroes: offline scrub didn't fail.
+keys[1].startblock = lastbit: offline scrub didn't fail.
+keys[1].startblock = sub: offline scrub didn't fail.
 Done fuzzing refcountbt
diff --git a/tests/xfs/465.out b/tests/xfs/465.out
index bb560881ae..5d8e6818fb 100644
--- a/tests/xfs/465.out
+++ b/tests/xfs/465.out
@@ -2,4 +2,75 @@ QA output created by 465
 Format and populate
 Find btree-format dir inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online health check failed (0).
+core.size = lastbit: offline scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+core.rtinherit = ones: offline scrub didn't fail.
+core.rtinherit = ones: online scrub didn't fail.
+core.rtinherit = firstbit: offline scrub didn't fail.
+core.rtinherit = firstbit: online scrub didn't fail.
+core.rtinherit = middlebit: offline scrub didn't fail.
+core.rtinherit = middlebit: online scrub didn't fail.
+core.rtinherit = lastbit: offline scrub didn't fail.
+core.rtinherit = lastbit: online scrub didn't fail.
+core.rtinherit = add: offline scrub didn't fail.
+core.rtinherit = add: online scrub didn't fail.
+core.rtinherit = sub: offline scrub didn't fail.
+core.rtinherit = sub: online scrub didn't fail.
+core.projinherit = ones: offline scrub didn't fail.
+core.projinherit = ones: online scrub didn't fail.
+core.projinherit = firstbit: offline scrub didn't fail.
+core.projinherit = firstbit: online scrub didn't fail.
+core.projinherit = middlebit: offline scrub didn't fail.
+core.projinherit = middlebit: online scrub didn't fail.
+core.projinherit = lastbit: offline scrub didn't fail.
+core.projinherit = lastbit: online scrub didn't fail.
+core.projinherit = add: offline scrub didn't fail.
+core.projinherit = add: online scrub didn't fail.
+core.projinherit = sub: offline scrub didn't fail.
+core.projinherit = sub: online scrub didn't fail.
+core.nosymlinks = ones: offline scrub didn't fail.
+core.nosymlinks = ones: online scrub didn't fail.
+core.nosymlinks = firstbit: offline scrub didn't fail.
+core.nosymlinks = firstbit: online scrub didn't fail.
+core.nosymlinks = middlebit: offline scrub didn't fail.
+core.nosymlinks = middlebit: online scrub didn't fail.
+core.nosymlinks = lastbit: offline scrub didn't fail.
+core.nosymlinks = lastbit: online scrub didn't fail.
+core.nosymlinks = add: offline scrub didn't fail.
+core.nosymlinks = add: online scrub didn't fail.
+core.nosymlinks = sub: offline scrub didn't fail.
+core.nosymlinks = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+u3.bmbt.ptrs[1] = firstbit: offline scrub didn't fail.
+u3.bmbt.ptrs[1] = firstbit: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/466.out b/tests/xfs/466.out
index b1762f2478..b2d84cd0fa 100644
--- a/tests/xfs/466.out
+++ b/tests/xfs/466.out
@@ -2,4 +2,55 @@ QA output created by 466
 Format and populate
 Find extents-format file inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = zeroes: offline scrub didn't fail.
+core.size = zeroes: online scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+u3.bmx[0].startoff = lastbit: pre-mod mount failed (32).
+u3.bmx[0].blockcount = middlebit: pre-mod mount failed (32).
+u3.bmx[0].blockcount = add: pre-mod mount failed (32).
+a.sfattr.list[0].parent_ino = lastbit: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/467.out b/tests/xfs/467.out
index 1ca0e21d40..f68fab8444 100644
--- a/tests/xfs/467.out
+++ b/tests/xfs/467.out
@@ -2,4 +2,51 @@ QA output created by 467
 Format and populate
 Find btree-format file inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = zeroes: offline scrub didn't fail.
+core.size = zeroes: online scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: offline scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/469.out b/tests/xfs/469.out
index 1f514019b8..641a63fee7 100644
--- a/tests/xfs/469.out
+++ b/tests/xfs/469.out
@@ -2,4 +2,12 @@ QA output created by 469
 Format and populate
 Find symlink remote block
 Fuzz symlink remote block
+data = ones: offline scrub didn't fail.
+data = ones: online scrub didn't fail.
+data = firstbit: offline scrub didn't fail.
+data = firstbit: online scrub didn't fail.
+data = middlebit: offline scrub didn't fail.
+data = middlebit: online scrub didn't fail.
+data = lastbit: offline scrub didn't fail.
+data = lastbit: online scrub didn't fail.
 Done fuzzing symlink remote block
diff --git a/tests/xfs/470.out b/tests/xfs/470.out
index 88abc0bc6a..41b0739d9d 100644
--- a/tests/xfs/470.out
+++ b/tests/xfs/470.out
@@ -2,4 +2,83 @@ QA output created by 470
 Format and populate
 Find inline-format dir inode
 Fuzz inline-format dir inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.rtinherit = ones: offline scrub didn't fail.
+core.rtinherit = ones: online scrub didn't fail.
+core.rtinherit = firstbit: offline scrub didn't fail.
+core.rtinherit = firstbit: online scrub didn't fail.
+core.rtinherit = middlebit: offline scrub didn't fail.
+core.rtinherit = middlebit: online scrub didn't fail.
+core.rtinherit = lastbit: offline scrub didn't fail.
+core.rtinherit = lastbit: online scrub didn't fail.
+core.rtinherit = add: offline scrub didn't fail.
+core.rtinherit = add: online scrub didn't fail.
+core.rtinherit = sub: offline scrub didn't fail.
+core.rtinherit = sub: online scrub didn't fail.
+core.projinherit = ones: offline scrub didn't fail.
+core.projinherit = ones: online scrub didn't fail.
+core.projinherit = firstbit: offline scrub didn't fail.
+core.projinherit = firstbit: online scrub didn't fail.
+core.projinherit = middlebit: offline scrub didn't fail.
+core.projinherit = middlebit: online scrub didn't fail.
+core.projinherit = lastbit: offline scrub didn't fail.
+core.projinherit = lastbit: online scrub didn't fail.
+core.projinherit = add: offline scrub didn't fail.
+core.projinherit = add: online scrub didn't fail.
+core.projinherit = sub: offline scrub didn't fail.
+core.projinherit = sub: online scrub didn't fail.
+core.nosymlinks = ones: offline scrub didn't fail.
+core.nosymlinks = ones: online scrub didn't fail.
+core.nosymlinks = firstbit: offline scrub didn't fail.
+core.nosymlinks = firstbit: online scrub didn't fail.
+core.nosymlinks = middlebit: offline scrub didn't fail.
+core.nosymlinks = middlebit: online scrub didn't fail.
+core.nosymlinks = lastbit: offline scrub didn't fail.
+core.nosymlinks = lastbit: online scrub didn't fail.
+core.nosymlinks = add: offline scrub didn't fail.
+core.nosymlinks = add: online scrub didn't fail.
+core.nosymlinks = sub: offline scrub didn't fail.
+core.nosymlinks = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.sfdir3.list[1].offset = middlebit: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = middlebit: online scrub didn't fail.
+u3.sfdir3.list[1].offset = lastbit: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = lastbit: online scrub didn't fail.
+u3.sfdir3.list[1].offset = add: offline scrub didn't fail.
+u3.sfdir3.list[1].offset = add: online scrub didn't fail.
 Done fuzzing inline-format dir inode
diff --git a/tests/xfs/471.out b/tests/xfs/471.out
index 25e55ff03b..cbc61d9491 100644
--- a/tests/xfs/471.out
+++ b/tests/xfs/471.out
@@ -2,4 +2,11 @@ QA output created by 471
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
 Done fuzzing data-format dir block
diff --git a/tests/xfs/472.out b/tests/xfs/472.out
index 3f4d23acce..a2eead205e 100644
--- a/tests/xfs/472.out
+++ b/tests/xfs/472.out
@@ -2,4 +2,11 @@ QA output created by 472
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
 Done fuzzing data-format dir block
diff --git a/tests/xfs/474.out b/tests/xfs/474.out
index bba106d249..93e1147d3f 100644
--- a/tests/xfs/474.out
+++ b/tests/xfs/474.out
@@ -2,4 +2,11 @@ QA output created by 474
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
diff --git a/tests/xfs/475.out b/tests/xfs/475.out
index 5e64381922..d4d8b9ec9d 100644
--- a/tests/xfs/475.out
+++ b/tests/xfs/475.out
@@ -2,4 +2,10 @@ QA output created by 475
 Format and populate
 Find node-format dir block
 Fuzz node-format dir block
+nhdr.info.hdr.back = ones: offline scrub didn't fail.
+nhdr.info.hdr.back = firstbit: offline scrub didn't fail.
+nhdr.info.hdr.back = middlebit: offline scrub didn't fail.
+nhdr.info.hdr.back = lastbit: offline scrub didn't fail.
+nhdr.info.hdr.back = add: offline scrub didn't fail.
+nhdr.info.hdr.back = sub: offline scrub didn't fail.
 Done fuzzing node-format dir block
diff --git a/tests/xfs/477.out b/tests/xfs/477.out
index f3dd00ea51..c6f06d5efc 100644
--- a/tests/xfs/477.out
+++ b/tests/xfs/477.out
@@ -2,4 +2,83 @@ QA output created by 477
 Format and populate
 Find inline-format attr inode
 Fuzz inline-format attr inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+a.sfattr.list[1].name = ones: offline scrub didn't fail.
+a.sfattr.list[1].name = ones: online scrub didn't fail.
+a.sfattr.list[1].name = firstbit: offline scrub didn't fail.
+a.sfattr.list[1].name = firstbit: online scrub didn't fail.
+a.sfattr.list[1].name = middlebit: offline scrub didn't fail.
+a.sfattr.list[1].name = middlebit: online scrub didn't fail.
+a.sfattr.list[1].name = lastbit: offline scrub didn't fail.
+a.sfattr.list[1].name = lastbit: online scrub didn't fail.
+a.sfattr.list[1].name = add: offline scrub didn't fail.
+a.sfattr.list[1].name = add: online scrub didn't fail.
+a.sfattr.list[1].name = sub: offline scrub didn't fail.
+a.sfattr.list[1].name = sub: online scrub didn't fail.
+a.sfattr.list[2].name = ones: offline scrub didn't fail.
+a.sfattr.list[2].name = ones: online scrub didn't fail.
+a.sfattr.list[2].name = firstbit: offline scrub didn't fail.
+a.sfattr.list[2].name = firstbit: online scrub didn't fail.
+a.sfattr.list[2].name = middlebit: offline scrub didn't fail.
+a.sfattr.list[2].name = middlebit: online scrub didn't fail.
+a.sfattr.list[2].name = lastbit: offline scrub didn't fail.
+a.sfattr.list[2].name = lastbit: online scrub didn't fail.
+a.sfattr.list[2].name = add: offline scrub didn't fail.
+a.sfattr.list[2].name = add: online scrub didn't fail.
+a.sfattr.list[2].name = sub: offline scrub didn't fail.
+a.sfattr.list[2].name = sub: online scrub didn't fail.
 Done fuzzing inline-format attr inode
diff --git a/tests/xfs/478.out b/tests/xfs/478.out
index ff2067f09f..961be25626 100644
--- a/tests/xfs/478.out
+++ b/tests/xfs/478.out
@@ -2,4 +2,95 @@ QA output created by 478
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
+hdr.firstused = middlebit: online scrub didn't fail.
+hdr.holes = ones: offline scrub didn't fail.
+hdr.holes = ones: online scrub didn't fail.
+hdr.holes = firstbit: offline scrub didn't fail.
+hdr.holes = firstbit: online scrub didn't fail.
+hdr.holes = middlebit: offline scrub didn't fail.
+hdr.holes = middlebit: online scrub didn't fail.
+hdr.holes = lastbit: offline scrub didn't fail.
+hdr.holes = lastbit: online scrub didn't fail.
+hdr.holes = add: offline scrub didn't fail.
+hdr.holes = add: online scrub didn't fail.
+hdr.holes = sub: offline scrub didn't fail.
+hdr.holes = sub: online scrub didn't fail.
+hdr.freemap[0].base = zeroes: offline scrub didn't fail.
+hdr.freemap[0].base = middlebit: offline scrub didn't fail.
+hdr.freemap[0].size = zeroes: offline scrub didn't fail.
+hdr.freemap[0].size = zeroes: online scrub didn't fail.
+hdr.freemap[0].size = middlebit: offline scrub didn't fail.
+hdr.freemap[1].base = middlebit: offline scrub didn't fail.
+hdr.freemap[1].base = middlebit: online scrub didn't fail.
+hdr.freemap[1].size = middlebit: offline scrub didn't fail.
+hdr.freemap[2].base = middlebit: offline scrub didn't fail.
+hdr.freemap[2].base = middlebit: online scrub didn't fail.
+hdr.freemap[2].size = middlebit: offline scrub didn't fail.
+entries[0].incomplete = ones: online scrub didn't fail.
+entries[0].incomplete = firstbit: online scrub didn't fail.
+entries[0].incomplete = middlebit: online scrub didn't fail.
+entries[0].incomplete = lastbit: online scrub didn't fail.
+entries[0].incomplete = add: online scrub didn't fail.
+entries[0].incomplete = sub: online scrub didn't fail.
+entries[1].incomplete = ones: online scrub didn't fail.
+entries[1].incomplete = firstbit: online scrub didn't fail.
+entries[1].incomplete = middlebit: online scrub didn't fail.
+entries[1].incomplete = lastbit: online scrub didn't fail.
+entries[1].incomplete = add: online scrub didn't fail.
+entries[1].incomplete = sub: online scrub didn't fail.
+entries[2].incomplete = ones: online scrub didn't fail.
+entries[2].incomplete = firstbit: online scrub didn't fail.
+entries[2].incomplete = middlebit: online scrub didn't fail.
+entries[2].incomplete = lastbit: online scrub didn't fail.
+entries[2].incomplete = add: online scrub didn't fail.
+entries[2].incomplete = sub: online scrub didn't fail.
+entries[3].incomplete = ones: online scrub didn't fail.
+entries[3].incomplete = firstbit: online scrub didn't fail.
+entries[3].incomplete = middlebit: online scrub didn't fail.
+entries[3].incomplete = lastbit: online scrub didn't fail.
+entries[3].incomplete = add: online scrub didn't fail.
+entries[3].incomplete = sub: online scrub didn't fail.
+entries[4].incomplete = ones: online scrub didn't fail.
+entries[4].incomplete = firstbit: online scrub didn't fail.
+entries[4].incomplete = middlebit: online scrub didn't fail.
+entries[4].incomplete = lastbit: online scrub didn't fail.
+entries[4].incomplete = add: online scrub didn't fail.
+entries[4].incomplete = sub: online scrub didn't fail.
+entries[5].incomplete = ones: online scrub didn't fail.
+entries[5].incomplete = firstbit: online scrub didn't fail.
+entries[5].incomplete = middlebit: online scrub didn't fail.
+entries[5].incomplete = lastbit: online scrub didn't fail.
+entries[5].incomplete = add: online scrub didn't fail.
+entries[5].incomplete = sub: online scrub didn't fail.
+entries[6].incomplete = ones: online scrub didn't fail.
+entries[6].incomplete = firstbit: online scrub didn't fail.
+entries[6].incomplete = middlebit: online scrub didn't fail.
+entries[6].incomplete = lastbit: online scrub didn't fail.
+entries[6].incomplete = add: online scrub didn't fail.
+entries[6].incomplete = sub: online scrub didn't fail.
+entries[7].incomplete = ones: online scrub didn't fail.
+entries[7].incomplete = firstbit: online scrub didn't fail.
+entries[7].incomplete = middlebit: online scrub didn't fail.
+entries[7].incomplete = lastbit: online scrub didn't fail.
+entries[7].incomplete = add: online scrub didn't fail.
+entries[7].incomplete = sub: online scrub didn't fail.
+entries[8].incomplete = ones: online scrub didn't fail.
+entries[8].incomplete = firstbit: online scrub didn't fail.
+entries[8].incomplete = middlebit: online scrub didn't fail.
+entries[8].incomplete = lastbit: online scrub didn't fail.
+entries[8].incomplete = add: online scrub didn't fail.
+entries[8].incomplete = sub: online scrub didn't fail.
+entries[9].incomplete = ones: online scrub didn't fail.
+entries[9].incomplete = firstbit: online scrub didn't fail.
+entries[9].incomplete = middlebit: online scrub didn't fail.
+entries[9].incomplete = lastbit: online scrub didn't fail.
+entries[9].incomplete = add: online scrub didn't fail.
+entries[9].incomplete = sub: online scrub didn't fail.
 Done fuzzing leaf-format attr block
diff --git a/tests/xfs/479.out b/tests/xfs/479.out
index 320a82ac39..ca8ff9f71f 100644
--- a/tests/xfs/479.out
+++ b/tests/xfs/479.out
@@ -2,4 +2,11 @@ QA output created by 479
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
diff --git a/tests/xfs/480.out b/tests/xfs/480.out
index 6225f4daad..d4628171ba 100644
--- a/tests/xfs/480.out
+++ b/tests/xfs/480.out
@@ -2,4 +2,28 @@ QA output created by 480
 Format and populate
 Find external attr block
 Fuzz external attr block
+hdr.offset = ones: offline scrub didn't fail.
+hdr.offset = middlebit: offline scrub didn't fail.
+hdr.offset = lastbit: offline scrub didn't fail.
+hdr.offset = add: offline scrub didn't fail.
+hdr.offset = sub: offline scrub didn't fail.
+hdr.bytes = zeroes: offline scrub didn't fail.
+hdr.bytes = lastbit: offline scrub didn't fail.
+hdr.bytes = sub: offline scrub didn't fail.
+hdr.owner = ones: offline scrub didn't fail.
+hdr.owner = firstbit: offline scrub didn't fail.
+hdr.owner = middlebit: offline scrub didn't fail.
+hdr.owner = lastbit: offline scrub didn't fail.
+hdr.owner = add: offline scrub didn't fail.
+hdr.owner = sub: offline scrub didn't fail.
+data = zeroes: offline scrub didn't fail.
+data = zeroes: online scrub didn't fail.
+data = ones: offline scrub didn't fail.
+data = ones: online scrub didn't fail.
+data = firstbit: offline scrub didn't fail.
+data = firstbit: online scrub didn't fail.
+data = middlebit: offline scrub didn't fail.
+data = middlebit: online scrub didn't fail.
+data = lastbit: offline scrub didn't fail.
+data = lastbit: online scrub didn't fail.
 Done fuzzing external attr block
diff --git a/tests/xfs/483.out b/tests/xfs/483.out
index 07b75b3655..01c95a3bac 100644
--- a/tests/xfs/483.out
+++ b/tests/xfs/483.out
@@ -1,4 +1,10 @@
 QA output created by 483
 Format and populate
 Fuzz refcountbt
+numrecs = lastbit: offline scrub didn't fail.
+leftsib = add: offline scrub didn't fail.
+rightsib = ones: offline scrub didn't fail.
+rightsib = middlebit: offline scrub didn't fail.
+rightsib = lastbit: offline scrub didn't fail.
+rightsib = add: offline scrub didn't fail.
 Done fuzzing refcountbt
diff --git a/tests/xfs/484.out b/tests/xfs/484.out
index 1295aaad34..89ee83772d 100644
--- a/tests/xfs/484.out
+++ b/tests/xfs/484.out
@@ -2,4 +2,49 @@ QA output created by 484
 Format and populate
 Find btree-format attr inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = middlebit: offline scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: offline scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: offline scrub didn't fail.
+core.size = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = lastbit: offline scrub didn't fail.
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.reflink = ones: offline scrub didn't fail.
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: offline scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: offline scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: offline scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: offline scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: offline scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+a.bmbt.ptrs[1] = firstbit: offline scrub didn't fail.
+a.bmbt.ptrs[1] = firstbit: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/485.out b/tests/xfs/485.out
index c89c0e5a37..dfd131d4f3 100644
--- a/tests/xfs/485.out
+++ b/tests/xfs/485.out
@@ -2,4 +2,55 @@ QA output created by 485
 Format and populate
 Find blockdev inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.dev = zeroes: offline scrub didn't fail.
+u3.dev = zeroes: online scrub didn't fail.
+u3.dev = ones: offline scrub didn't fail.
+u3.dev = ones: online scrub didn't fail.
+u3.dev = firstbit: offline scrub didn't fail.
+u3.dev = firstbit: online scrub didn't fail.
+u3.dev = middlebit: offline scrub didn't fail.
+u3.dev = middlebit: online scrub didn't fail.
+u3.dev = lastbit: offline scrub didn't fail.
+u3.dev = lastbit: online scrub didn't fail.
+u3.dev = add: offline scrub didn't fail.
+u3.dev = add: online scrub didn't fail.
+u3.dev = sub: offline scrub didn't fail.
+u3.dev = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/486.out b/tests/xfs/486.out
index 26f1a362d9..1e4f7102a3 100644
--- a/tests/xfs/486.out
+++ b/tests/xfs/486.out
@@ -2,4 +2,50 @@ QA output created by 486
 Format and populate
 Find local-format symlink inode
 Fuzz inode
+core.mode = middlebit: offline scrub didn't fail.
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: offline scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: offline scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+v3.change_count = zeroes: offline scrub didn't fail.
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: offline scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: offline scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: offline scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: offline scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: offline scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: offline scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.nrext64 = zeroes: offline scrub didn't fail.
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: offline scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: offline scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: offline scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: offline scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: offline scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.symlink = ones: offline scrub didn't fail.
+u3.symlink = ones: online scrub didn't fail.
+u3.symlink = firstbit: offline scrub didn't fail.
+u3.symlink = firstbit: online scrub didn't fail.
+u3.symlink = middlebit: offline scrub didn't fail.
+u3.symlink = middlebit: online scrub didn't fail.
+u3.symlink = lastbit: offline scrub didn't fail.
+u3.symlink = lastbit: online scrub didn't fail.
+u3.symlink = add: offline scrub didn't fail.
+u3.symlink = add: online scrub didn't fail.
+u3.symlink = sub: offline scrub didn't fail.
+u3.symlink = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/487.out b/tests/xfs/487.out
index a7d2926ce5..4e036a7d6b 100644
--- a/tests/xfs/487.out
+++ b/tests/xfs/487.out
@@ -1,4 +1,246 @@
 QA output created by 487
 Format and populate
 Fuzz user 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz user 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz user 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/488.out b/tests/xfs/488.out
index 2fc75d163e..738a7297a3 100644
--- a/tests/xfs/488.out
+++ b/tests/xfs/488.out
@@ -1,4 +1,246 @@
 QA output created by 488
 Format and populate
 Fuzz group 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz group 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz group 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/489.out b/tests/xfs/489.out
index 7483e6420c..15aa6efefc 100644
--- a/tests/xfs/489.out
+++ b/tests/xfs/489.out
@@ -1,4 +1,246 @@
 QA output created by 489
 Format and populate
 Fuzz project 0 dquot
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
+diskdq.itimer = ones: offline scrub didn't fail.
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: offline scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: offline scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: offline scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: offline scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: offline scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: offline scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: offline scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: offline scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: offline scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: offline scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: offline scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: offline scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz project 4242 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
+Done fuzzing dquot
+Fuzz project 8484 dquot
+diskdq.type = firstbit: offline scrub didn't fail.
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: offline scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: offline scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: offline scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: offline scrub didn't fail.
+diskdq.blk_softlimit = firstbit: offline scrub didn't fail.
+diskdq.blk_softlimit = middlebit: offline scrub didn't fail.
+diskdq.blk_softlimit = lastbit: offline scrub didn't fail.
+diskdq.blk_softlimit = add: offline scrub didn't fail.
+diskdq.blk_softlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: offline scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: offline scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: offline scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: offline scrub didn't fail.
+diskdq.ino_softlimit = firstbit: offline scrub didn't fail.
+diskdq.ino_softlimit = middlebit: offline scrub didn't fail.
+diskdq.ino_softlimit = lastbit: offline scrub didn't fail.
+diskdq.ino_softlimit = add: offline scrub didn't fail.
+diskdq.ino_softlimit = sub: offline scrub didn't fail.
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
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: offline scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: offline scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: offline scrub didn't fail.
+diskdq.rtb_softlimit = firstbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = middlebit: offline scrub didn't fail.
+diskdq.rtb_softlimit = lastbit: offline scrub didn't fail.
+diskdq.rtb_softlimit = add: offline scrub didn't fail.
+diskdq.rtb_softlimit = sub: offline scrub didn't fail.
+diskdq.rtbtimer = ones: offline scrub didn't fail.
+diskdq.rtbtimer = firstbit: offline scrub didn't fail.
+diskdq.rtbtimer = middlebit: offline scrub didn't fail.
+diskdq.rtbtimer = lastbit: offline scrub didn't fail.
+diskdq.rtbtimer = add: offline scrub didn't fail.
+diskdq.rtbtimer = sub: offline scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/498.out b/tests/xfs/498.out
index 5c5ef5917c..5295aeb3e5 100644
--- a/tests/xfs/498.out
+++ b/tests/xfs/498.out
@@ -2,4 +2,16 @@ QA output created by 498
 Format and populate
 Find single-leafn-format dir block
 Fuzz single-leafn-format dir block
+lhdr.info.hdr.forw = ones: offline scrub didn't fail.
+lhdr.info.hdr.forw = firstbit: offline scrub didn't fail.
+lhdr.info.hdr.forw = middlebit: offline scrub didn't fail.
+lhdr.info.hdr.forw = lastbit: offline scrub didn't fail.
+lhdr.info.hdr.forw = add: offline scrub didn't fail.
+lhdr.info.hdr.forw = sub: offline scrub didn't fail.
+lhdr.info.hdr.back = ones: offline scrub didn't fail.
+lhdr.info.hdr.back = firstbit: offline scrub didn't fail.
+lhdr.info.hdr.back = middlebit: offline scrub didn't fail.
+lhdr.info.hdr.back = lastbit: offline scrub didn't fail.
+lhdr.info.hdr.back = add: offline scrub didn't fail.
+lhdr.info.hdr.back = sub: offline scrub didn't fail.
 Done fuzzing single-leafn-format dir block
diff --git a/tests/xfs/788.out b/tests/xfs/788.out
index 5f6414d0f1..525d385160 100644
--- a/tests/xfs/788.out
+++ b/tests/xfs/788.out
@@ -1,4 +1,27 @@
 QA output created by 788
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

