Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659D3BA3A;
	Mon,  1 Jan 2024 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8LUeGaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2473FC433C8;
	Mon,  1 Jan 2024 00:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069834;
	bh=an8dANnq+XoBO+jtePx5OK1KjWHI4VXW3ppjTXeXRZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r8LUeGajTG07aEOe3XPpRsTZ5vi3Rk1MdlzByN8IkpHoxOOjgI6mjEOObHOJyAB9z
	 iJ70azA4w8Tbusb7oSHWtCHTNWw02sFOToJGTZKVleZ6xKR5DxtQxWYIiJmkLlDo/6
	 m59wqmEG565YreDjLLzn52G518K3DzjIIO1T+SotAi+dUkJ3S1FhYMWD7v+1xtzX8y
	 mJRcvKRy5lyIZcmQ0C2C29zxcL2PHgfTgabIyluJTefHtcRci1zS+Mf3ngu/7d7bOt
	 aAdzjjaWYbJGu22n2GD3UkfiHvwt4JEM2ZxIVNbH/jQ5ZCix62bVOspLNwNTNeXr1I
	 2tA55QMyuwg3w==
Date: Sun, 31 Dec 2023 16:43:53 +9900
Subject: [PATCH 1/4] xfs: online fuzz test known output
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026242.1823639.14181456828807676834.stgit@frogsfrogsfrogs>
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

Record all the currently known failures of the xfs_scrub check and
repair code when parent pointers and rtgroups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/351.out |   75 ++++++++++++++++++++++++++++++
 tests/xfs/353.out |   96 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/355.out |   47 +++++++++++++++++++
 tests/xfs/357.out |  109 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/361.out |   14 ++++++
 tests/xfs/369.out |   57 +++++++++++++++++++++++
 tests/xfs/371.out |  108 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/375.out |   94 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/377.out |   62 +++++++++++++++++++++++++
 tests/xfs/379.out |   74 ++++++++++++++++++++++++++++++
 tests/xfs/381.out |    1 
 tests/xfs/383.out |    4 ++
 tests/xfs/385.out |   68 +++++++++++++++++++++++++++
 tests/xfs/399.out |   63 +++++++++++++++++++++++++
 tests/xfs/401.out |   72 +++++++++++++++++++++++++++++
 tests/xfs/405.out |    5 ++
 tests/xfs/413.out |   48 +++++++++++++++++++
 tests/xfs/415.out |   56 ++++++++++++++++++++++
 tests/xfs/417.out |   56 ++++++++++++++++++++++
 tests/xfs/426.out |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/428.out |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/430.out |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/730.out |   10 ++++
 23 files changed, 1515 insertions(+)


diff --git a/tests/xfs/351.out b/tests/xfs/351.out
index 36d7b96a11..7f8dbdfebd 100644
--- a/tests/xfs/351.out
+++ b/tests/xfs/351.out
@@ -1,4 +1,79 @@
 QA output created by 351
 Format and populate
 Fuzz superblock
+uuid = zeroes: online scrub didn't fail.
+uuid = ones: online scrub didn't fail.
+uuid = firstbit: online scrub didn't fail.
+uuid = middlebit: online scrub didn't fail.
+uuid = lastbit: online scrub didn't fail.
+rootino = zeroes: online scrub didn't fail.
+rootino = ones: online scrub didn't fail.
+rootino = firstbit: online scrub didn't fail.
+rootino = middlebit: online scrub didn't fail.
+rootino = lastbit: online scrub didn't fail.
+rootino = add: online scrub didn't fail.
+rootino = sub: online scrub didn't fail.
+metadirino = zeroes: online scrub didn't fail.
+metadirino = firstbit: online scrub didn't fail.
+metadirino = middlebit: online scrub didn't fail.
+metadirino = lastbit: online scrub didn't fail.
+metadirino = add: online scrub didn't fail.
+metadirino = sub: online scrub didn't fail.
+rgblocks = middlebit: online scrub didn't fail.
+rgblocks = lastbit: online scrub didn't fail.
+rgblocks = add: online scrub didn't fail.
+rgblocks = sub: online scrub didn't fail.
+fname = ones: online scrub didn't fail.
+fname = firstbit: online scrub didn't fail.
+fname = middlebit: online scrub didn't fail.
+fname = lastbit: online scrub didn't fail.
+inprogress = zeroes: online scrub didn't fail.
+inprogress = ones: online scrub didn't fail.
+inprogress = firstbit: online scrub didn't fail.
+inprogress = middlebit: online scrub didn't fail.
+inprogress = lastbit: online scrub didn't fail.
+inprogress = add: online scrub didn't fail.
+inprogress = sub: online scrub didn't fail.
+imax_pct = zeroes: online scrub didn't fail.
+imax_pct = middlebit: online scrub didn't fail.
+imax_pct = lastbit: online scrub didn't fail.
+icount = ones: online scrub didn't fail.
+icount = firstbit: online scrub didn't fail.
+icount = middlebit: online scrub didn't fail.
+icount = lastbit: online scrub didn't fail.
+icount = add: online scrub didn't fail.
+icount = sub: online scrub didn't fail.
+ifree = ones: online scrub didn't fail.
+ifree = firstbit: online scrub didn't fail.
+ifree = middlebit: online scrub didn't fail.
+ifree = lastbit: online scrub didn't fail.
+ifree = add: online scrub didn't fail.
+ifree = sub: online scrub didn't fail.
+fdblocks = zeroes: online scrub didn't fail.
+fdblocks = ones: online scrub didn't fail.
+fdblocks = firstbit: online scrub didn't fail.
+fdblocks = middlebit: online scrub didn't fail.
+fdblocks = lastbit: online scrub didn't fail.
+fdblocks = add: online scrub didn't fail.
+fdblocks = sub: online scrub didn't fail.
+qflags = firstbit: online scrub didn't fail.
+qflags = middlebit: online scrub didn't fail.
+qflags = lastbit: online scrub didn't fail.
+bad_features2 = zeroes: online scrub didn't fail.
+bad_features2 = ones: online scrub didn't fail.
+bad_features2 = firstbit: online scrub didn't fail.
+bad_features2 = middlebit: online scrub didn't fail.
+bad_features2 = lastbit: online scrub didn't fail.
+bad_features2 = add: online scrub didn't fail.
+bad_features2 = sub: online scrub didn't fail.
+features_log_incompat = ones: online scrub didn't fail.
+features_log_incompat = firstbit: online scrub didn't fail.
+features_log_incompat = middlebit: online scrub didn't fail.
+features_log_incompat = lastbit: online scrub didn't fail.
+features_log_incompat = add: online scrub didn't fail.
+features_log_incompat = sub: online scrub didn't fail.
+meta_uuid = ones: online scrub didn't fail.
+meta_uuid = firstbit: online scrub didn't fail.
+meta_uuid = middlebit: online scrub didn't fail.
+meta_uuid = lastbit: online scrub didn't fail.
 Done fuzzing superblock
diff --git a/tests/xfs/353.out b/tests/xfs/353.out
index 6f0ec45d6e..7c8af7b8e5 100644
--- a/tests/xfs/353.out
+++ b/tests/xfs/353.out
@@ -1,4 +1,100 @@
 QA output created by 353
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
diff --git a/tests/xfs/355.out b/tests/xfs/355.out
index d537761abf..1df816c083 100644
--- a/tests/xfs/355.out
+++ b/tests/xfs/355.out
@@ -1,6 +1,53 @@
 QA output created by 355
 Format and populate
 Fuzz AGFL
+bno[0] = zeroes: online scrub didn't fail.
+bno[0] = add: online scrub didn't fail.
+bno[1] = zeroes: online scrub didn't fail.
+bno[1] = ones: online scrub didn't fail.
+bno[1] = middlebit: online scrub didn't fail.
+bno[1] = lastbit: online scrub didn't fail.
+bno[1] = add: online scrub didn't fail.
+bno[2] = zeroes: online scrub didn't fail.
+bno[2] = ones: online scrub didn't fail.
+bno[2] = middlebit: online scrub didn't fail.
+bno[2] = lastbit: online scrub didn't fail.
+bno[2] = add: online scrub didn't fail.
+bno[3] = zeroes: online scrub didn't fail.
+bno[3] = ones: online scrub didn't fail.
+bno[3] = middlebit: online scrub didn't fail.
+bno[3] = lastbit: online scrub didn't fail.
+bno[3] = add: online scrub didn't fail.
+bno[4] = zeroes: online scrub didn't fail.
+bno[4] = ones: online scrub didn't fail.
+bno[4] = middlebit: online scrub didn't fail.
+bno[4] = lastbit: online scrub didn't fail.
+bno[4] = add: online scrub didn't fail.
+bno[5] = zeroes: online scrub didn't fail.
+bno[5] = ones: online scrub didn't fail.
+bno[5] = middlebit: online scrub didn't fail.
+bno[5] = lastbit: online scrub didn't fail.
+bno[5] = add: online scrub didn't fail.
+bno[6] = zeroes: online scrub didn't fail.
+bno[6] = ones: online scrub didn't fail.
+bno[6] = middlebit: online scrub didn't fail.
+bno[6] = lastbit: online scrub didn't fail.
+bno[6] = add: online scrub didn't fail.
+bno[7] = zeroes: online scrub didn't fail.
+bno[7] = ones: online scrub didn't fail.
+bno[7] = middlebit: online scrub didn't fail.
+bno[7] = lastbit: online scrub didn't fail.
+bno[7] = add: online scrub didn't fail.
+bno[8] = zeroes: online scrub didn't fail.
+bno[8] = ones: online scrub didn't fail.
+bno[8] = middlebit: online scrub didn't fail.
+bno[8] = lastbit: online scrub didn't fail.
+bno[8] = add: online scrub didn't fail.
+bno[9] = zeroes: online scrub didn't fail.
+bno[9] = ones: online scrub didn't fail.
+bno[9] = middlebit: online scrub didn't fail.
+bno[9] = lastbit: online scrub didn't fail.
+bno[9] = add: online scrub didn't fail.
 Done fuzzing AGFL
 Fuzz AGFL flfirst
 Done fuzzing AGFL flfirst
diff --git a/tests/xfs/357.out b/tests/xfs/357.out
index c9cf6d2681..400530ff0e 100644
--- a/tests/xfs/357.out
+++ b/tests/xfs/357.out
@@ -1,4 +1,113 @@
 QA output created by 357
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
+seqno = zeroes: mount failed (32).
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
+level = zeroes: mount failed (32).
+level = ones: mount failed (32).
+level = firstbit: mount failed (32).
+level = middlebit: mount failed (32).
+level = lastbit: mount failed (32).
+level = add: mount failed (32).
+level = sub: mount failed (32).
+newino = ones: online scrub didn't fail.
+newino = middlebit: online scrub didn't fail.
+newino = lastbit: online scrub didn't fail.
+newino = add: online scrub didn't fail.
+dirino = add: online scrub didn't fail.
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
diff --git a/tests/xfs/361.out b/tests/xfs/361.out
index d8e021bddb..95ae5f5e71 100644
--- a/tests/xfs/361.out
+++ b/tests/xfs/361.out
@@ -1,4 +1,18 @@
 QA output created by 361
 Format and populate
 Fuzz bnobt keyptr
+keys[1].blockcount = zeroes: online scrub didn't fail.
+keys[1].blockcount = ones: online scrub didn't fail.
+keys[1].blockcount = firstbit: online scrub didn't fail.
+keys[1].blockcount = middlebit: online scrub didn't fail.
+keys[1].blockcount = lastbit: online scrub didn't fail.
+keys[1].blockcount = add: online scrub didn't fail.
+keys[1].blockcount = sub: online scrub didn't fail.
+keys[2].blockcount = zeroes: online scrub didn't fail.
+keys[2].blockcount = ones: online scrub didn't fail.
+keys[2].blockcount = firstbit: online scrub didn't fail.
+keys[2].blockcount = middlebit: online scrub didn't fail.
+keys[2].blockcount = lastbit: online scrub didn't fail.
+keys[2].blockcount = add: online scrub didn't fail.
+keys[2].blockcount = sub: online scrub didn't fail.
 Done fuzzing bnobt keyptr
diff --git a/tests/xfs/369.out b/tests/xfs/369.out
index 1f97134ab4..4b399d7b47 100644
--- a/tests/xfs/369.out
+++ b/tests/xfs/369.out
@@ -1,4 +1,61 @@
 QA output created by 369
 Format and populate
 Fuzz rmapbt recs
+recs[2].owner = add: offline re-scrub failed (1).
+recs[2].owner = add: offline post-mod scrub failed (1).
+recs[3].owner = add: offline re-scrub failed (1).
+recs[3].owner = add: offline post-mod scrub failed (1).
+recs[5].owner = lastbit: online repair failed (1).
+recs[5].owner = lastbit: online re-scrub failed (5).
+recs[5].owner = lastbit: offline re-scrub failed (1).
+recs[5].owner = lastbit: online post-mod scrub failed (1).
+recs[5].owner = lastbit: offline post-mod scrub failed (1).
+recs[7].owner = lastbit: offline re-scrub failed (1).
+recs[7].owner = lastbit: offline post-mod scrub failed (1).
+recs[7].owner = add: offline re-scrub failed (1).
+recs[7].owner = add: offline post-mod scrub failed (1).
+recs[7].attrfork = ones: offline re-scrub failed (1).
+recs[7].attrfork = ones: offline post-mod scrub failed (1).
+recs[7].attrfork = firstbit: offline re-scrub failed (1).
+recs[7].attrfork = firstbit: offline post-mod scrub failed (1).
+recs[7].attrfork = middlebit: offline re-scrub failed (1).
+recs[7].attrfork = middlebit: offline post-mod scrub failed (1).
+recs[7].attrfork = lastbit: offline re-scrub failed (1).
+recs[7].attrfork = lastbit: offline post-mod scrub failed (1).
+recs[7].attrfork = add: offline re-scrub failed (1).
+recs[7].attrfork = add: offline post-mod scrub failed (1).
+recs[7].attrfork = sub: offline re-scrub failed (1).
+recs[7].attrfork = sub: offline post-mod scrub failed (1).
+recs[8].owner = lastbit: offline re-scrub failed (1).
+recs[8].owner = lastbit: offline post-mod scrub failed (1).
+recs[8].owner = add: offline re-scrub failed (1).
+recs[8].owner = add: offline post-mod scrub failed (1).
+recs[8].attrfork = ones: offline re-scrub failed (1).
+recs[8].attrfork = ones: offline post-mod scrub failed (1).
+recs[8].attrfork = firstbit: offline re-scrub failed (1).
+recs[8].attrfork = firstbit: offline post-mod scrub failed (1).
+recs[8].attrfork = middlebit: offline re-scrub failed (1).
+recs[8].attrfork = middlebit: offline post-mod scrub failed (1).
+recs[8].attrfork = lastbit: offline re-scrub failed (1).
+recs[8].attrfork = lastbit: offline post-mod scrub failed (1).
+recs[8].attrfork = add: offline re-scrub failed (1).
+recs[8].attrfork = add: offline post-mod scrub failed (1).
+recs[8].attrfork = sub: offline re-scrub failed (1).
+recs[8].attrfork = sub: offline post-mod scrub failed (1).
+recs[9].owner = lastbit: offline re-scrub failed (1).
+recs[9].owner = lastbit: offline post-mod scrub failed (1).
+recs[9].owner = add: offline re-scrub failed (1).
+recs[9].owner = add: offline post-mod scrub failed (1).
+recs[9].attrfork = ones: offline re-scrub failed (1).
+recs[9].attrfork = ones: offline post-mod scrub failed (1).
+recs[9].attrfork = firstbit: offline re-scrub failed (1).
+recs[9].attrfork = firstbit: offline post-mod scrub failed (1).
+recs[9].attrfork = middlebit: offline re-scrub failed (1).
+recs[9].attrfork = middlebit: offline post-mod scrub failed (1).
+recs[9].attrfork = lastbit: offline re-scrub failed (1).
+recs[9].attrfork = lastbit: offline post-mod scrub failed (1).
+recs[9].attrfork = add: offline re-scrub failed (1).
+recs[9].attrfork = add: offline post-mod scrub failed (1).
+recs[9].attrfork = sub: offline re-scrub failed (1).
+recs[9].attrfork = sub: offline post-mod scrub failed (1).
 Done fuzzing rmapbt recs
diff --git a/tests/xfs/371.out b/tests/xfs/371.out
index c7c943f332..477cd32e51 100644
--- a/tests/xfs/371.out
+++ b/tests/xfs/371.out
@@ -1,4 +1,112 @@
 QA output created by 371
 Format and populate
 Fuzz rmapbt keyptr
+keys[1].extentflag = ones: online scrub didn't fail.
+keys[1].extentflag = firstbit: online scrub didn't fail.
+keys[1].extentflag = middlebit: online scrub didn't fail.
+keys[1].extentflag = lastbit: online scrub didn't fail.
+keys[1].extentflag = add: online scrub didn't fail.
+keys[1].extentflag = sub: online scrub didn't fail.
+keys[1].extentflag_hi = ones: online scrub didn't fail.
+keys[1].extentflag_hi = firstbit: online scrub didn't fail.
+keys[1].extentflag_hi = middlebit: online scrub didn't fail.
+keys[1].extentflag_hi = lastbit: online scrub didn't fail.
+keys[1].extentflag_hi = add: online scrub didn't fail.
+keys[1].extentflag_hi = sub: online scrub didn't fail.
+keys[2].extentflag = ones: online scrub didn't fail.
+keys[2].extentflag = firstbit: online scrub didn't fail.
+keys[2].extentflag = middlebit: online scrub didn't fail.
+keys[2].extentflag = lastbit: online scrub didn't fail.
+keys[2].extentflag = add: online scrub didn't fail.
+keys[2].extentflag = sub: online scrub didn't fail.
+keys[2].extentflag_hi = ones: online scrub didn't fail.
+keys[2].extentflag_hi = firstbit: online scrub didn't fail.
+keys[2].extentflag_hi = middlebit: online scrub didn't fail.
+keys[2].extentflag_hi = lastbit: online scrub didn't fail.
+keys[2].extentflag_hi = add: online scrub didn't fail.
+keys[2].extentflag_hi = sub: online scrub didn't fail.
+keys[3].extentflag = ones: online scrub didn't fail.
+keys[3].extentflag = firstbit: online scrub didn't fail.
+keys[3].extentflag = middlebit: online scrub didn't fail.
+keys[3].extentflag = lastbit: online scrub didn't fail.
+keys[3].extentflag = add: online scrub didn't fail.
+keys[3].extentflag = sub: online scrub didn't fail.
+keys[3].extentflag_hi = ones: online scrub didn't fail.
+keys[3].extentflag_hi = firstbit: online scrub didn't fail.
+keys[3].extentflag_hi = middlebit: online scrub didn't fail.
+keys[3].extentflag_hi = lastbit: online scrub didn't fail.
+keys[3].extentflag_hi = add: online scrub didn't fail.
+keys[3].extentflag_hi = sub: online scrub didn't fail.
+keys[4].extentflag = ones: online scrub didn't fail.
+keys[4].extentflag = firstbit: online scrub didn't fail.
+keys[4].extentflag = middlebit: online scrub didn't fail.
+keys[4].extentflag = lastbit: online scrub didn't fail.
+keys[4].extentflag = add: online scrub didn't fail.
+keys[4].extentflag = sub: online scrub didn't fail.
+keys[4].extentflag_hi = ones: online scrub didn't fail.
+keys[4].extentflag_hi = firstbit: online scrub didn't fail.
+keys[4].extentflag_hi = middlebit: online scrub didn't fail.
+keys[4].extentflag_hi = lastbit: online scrub didn't fail.
+keys[4].extentflag_hi = add: online scrub didn't fail.
+keys[4].extentflag_hi = sub: online scrub didn't fail.
+keys[5].extentflag = ones: online scrub didn't fail.
+keys[5].extentflag = firstbit: online scrub didn't fail.
+keys[5].extentflag = middlebit: online scrub didn't fail.
+keys[5].extentflag = lastbit: online scrub didn't fail.
+keys[5].extentflag = add: online scrub didn't fail.
+keys[5].extentflag = sub: online scrub didn't fail.
+keys[5].extentflag_hi = ones: online scrub didn't fail.
+keys[5].extentflag_hi = firstbit: online scrub didn't fail.
+keys[5].extentflag_hi = middlebit: online scrub didn't fail.
+keys[5].extentflag_hi = lastbit: online scrub didn't fail.
+keys[5].extentflag_hi = add: online scrub didn't fail.
+keys[5].extentflag_hi = sub: online scrub didn't fail.
+keys[6].extentflag = ones: online scrub didn't fail.
+keys[6].extentflag = firstbit: online scrub didn't fail.
+keys[6].extentflag = middlebit: online scrub didn't fail.
+keys[6].extentflag = lastbit: online scrub didn't fail.
+keys[6].extentflag = add: online scrub didn't fail.
+keys[6].extentflag = sub: online scrub didn't fail.
+keys[6].extentflag_hi = ones: online scrub didn't fail.
+keys[6].extentflag_hi = firstbit: online scrub didn't fail.
+keys[6].extentflag_hi = middlebit: online scrub didn't fail.
+keys[6].extentflag_hi = lastbit: online scrub didn't fail.
+keys[6].extentflag_hi = add: online scrub didn't fail.
+keys[6].extentflag_hi = sub: online scrub didn't fail.
+keys[7].extentflag = ones: online scrub didn't fail.
+keys[7].extentflag = firstbit: online scrub didn't fail.
+keys[7].extentflag = middlebit: online scrub didn't fail.
+keys[7].extentflag = lastbit: online scrub didn't fail.
+keys[7].extentflag = add: online scrub didn't fail.
+keys[7].extentflag = sub: online scrub didn't fail.
+keys[7].extentflag_hi = ones: online scrub didn't fail.
+keys[7].extentflag_hi = firstbit: online scrub didn't fail.
+keys[7].extentflag_hi = middlebit: online scrub didn't fail.
+keys[7].extentflag_hi = lastbit: online scrub didn't fail.
+keys[7].extentflag_hi = add: online scrub didn't fail.
+keys[7].extentflag_hi = sub: online scrub didn't fail.
+keys[8].extentflag = ones: online scrub didn't fail.
+keys[8].extentflag = firstbit: online scrub didn't fail.
+keys[8].extentflag = middlebit: online scrub didn't fail.
+keys[8].extentflag = lastbit: online scrub didn't fail.
+keys[8].extentflag = add: online scrub didn't fail.
+keys[8].extentflag = sub: online scrub didn't fail.
+keys[8].extentflag_hi = ones: online scrub didn't fail.
+keys[8].extentflag_hi = firstbit: online scrub didn't fail.
+keys[8].extentflag_hi = middlebit: online scrub didn't fail.
+keys[8].extentflag_hi = lastbit: online scrub didn't fail.
+keys[8].extentflag_hi = add: online scrub didn't fail.
+keys[8].extentflag_hi = sub: online scrub didn't fail.
+keys[9].extentflag = ones: online scrub didn't fail.
+keys[9].extentflag = firstbit: online scrub didn't fail.
+keys[9].extentflag = middlebit: online scrub didn't fail.
+keys[9].extentflag = lastbit: online scrub didn't fail.
+keys[9].extentflag = add: online scrub didn't fail.
+keys[9].extentflag = sub: online scrub didn't fail.
+keys[9].extentflag_hi = ones: online scrub didn't fail.
+keys[9].extentflag_hi = firstbit: online scrub didn't fail.
+keys[9].extentflag_hi = middlebit: online scrub didn't fail.
+keys[9].extentflag_hi = lastbit: online scrub didn't fail.
+keys[9].extentflag_hi = add: online scrub didn't fail.
+keys[9].extentflag_hi = sub: online scrub didn't fail.
 Done fuzzing rmapbt keyptr
diff --git a/tests/xfs/375.out b/tests/xfs/375.out
index ea92d7087f..746fa31ea0 100644
--- a/tests/xfs/375.out
+++ b/tests/xfs/375.out
@@ -2,4 +2,98 @@ QA output created by 375
 Format and populate
 Find btree-format dir inode
 Fuzz inode
+core.mode = zeroes: offline re-scrub failed (1).
+core.mode = zeroes: offline post-mod scrub failed (1).
+core.mode = firstbit: online repair failed (1).
+core.mode = firstbit: online re-scrub failed (5).
+core.mode = firstbit: offline re-scrub failed (1).
+core.mode = firstbit: online post-mod scrub failed (1).
+core.mode = firstbit: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (1).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.size = zeroes: online repair failed (1).
+core.size = zeroes: online re-scrub failed (5).
+core.size = zeroes: offline re-scrub failed (1).
+core.size = zeroes: online post-mod scrub failed (1).
+core.size = zeroes: offline post-mod scrub failed (1).
+core.size = middlebit: online health check failed (0).
+core.size = middlebit: online repair failed (4).
+core.size = middlebit: online re-scrub failed (4).
+core.size = middlebit: online post-mod scrub failed (4).
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+core.naextents = lastbit: online repair failed (1).
+core.naextents = lastbit: online re-scrub failed (5).
+core.naextents = lastbit: offline re-scrub failed (1).
+core.naextents = lastbit: online post-mod scrub failed (1).
+core.naextents = lastbit: offline post-mod scrub failed (1).
+core.forkoff = ones: online repair failed (1).
+core.forkoff = ones: online re-scrub failed (5).
+core.forkoff = ones: offline re-scrub failed (1).
+core.forkoff = ones: online post-mod scrub failed (1).
+core.forkoff = ones: offline post-mod scrub failed (1).
+core.forkoff = firstbit: online repair failed (1).
+core.forkoff = firstbit: online re-scrub failed (5).
+core.forkoff = firstbit: offline re-scrub failed (1).
+core.forkoff = firstbit: online post-mod scrub failed (1).
+core.forkoff = firstbit: offline post-mod scrub failed (1).
+core.forkoff = add: online repair failed (1).
+core.forkoff = add: online re-scrub failed (5).
+core.forkoff = add: offline re-scrub failed (1).
+core.forkoff = add: online post-mod scrub failed (1).
+core.forkoff = add: offline post-mod scrub failed (1).
+core.forkoff = sub: online repair failed (1).
+core.forkoff = sub: online re-scrub failed (5).
+core.forkoff = sub: offline re-scrub failed (1).
+core.forkoff = sub: online post-mod scrub failed (1).
+core.forkoff = sub: offline post-mod scrub failed (1).
+core.rtinherit = ones: online scrub didn't fail.
+core.rtinherit = firstbit: online scrub didn't fail.
+core.rtinherit = middlebit: online scrub didn't fail.
+core.rtinherit = lastbit: online scrub didn't fail.
+core.rtinherit = add: online scrub didn't fail.
+core.rtinherit = sub: online scrub didn't fail.
+core.projinherit = ones: online scrub didn't fail.
+core.projinherit = firstbit: online scrub didn't fail.
+core.projinherit = middlebit: online scrub didn't fail.
+core.projinherit = lastbit: online scrub didn't fail.
+core.projinherit = add: online scrub didn't fail.
+core.projinherit = sub: online scrub didn't fail.
+core.nosymlinks = ones: online scrub didn't fail.
+core.nosymlinks = firstbit: online scrub didn't fail.
+core.nosymlinks = middlebit: online scrub didn't fail.
+core.nosymlinks = lastbit: online scrub didn't fail.
+core.nosymlinks = add: online scrub didn't fail.
+core.nosymlinks = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+u3.bmbt.ptrs[1] = firstbit: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/377.out b/tests/xfs/377.out
index e70a34fd17..acc01a4669 100644
--- a/tests/xfs/377.out
+++ b/tests/xfs/377.out
@@ -2,4 +2,66 @@ QA output created by 377
 Format and populate
 Find extents-format file inode
 Fuzz inode
+core.mode = zeroes: offline re-scrub failed (1).
+core.mode = zeroes: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.size = zeroes: online scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+core.forkoff = firstbit: online repair failed (1).
+core.forkoff = firstbit: online re-scrub failed (5).
+core.forkoff = firstbit: offline re-scrub failed (1).
+core.forkoff = firstbit: online post-mod scrub failed (1).
+core.forkoff = firstbit: offline post-mod scrub failed (1).
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+u3.bmx[0].blockcount = middlebit: online repair failed (4).
+u3.bmx[0].blockcount = middlebit: online re-scrub failed (4).
+u3.bmx[0].blockcount = middlebit: offline re-scrub failed (1).
+u3.bmx[0].blockcount = middlebit: pre-mod mount failed (32).
+u3.bmx[0].blockcount = add: online repair failed (4).
+u3.bmx[0].blockcount = add: online re-scrub failed (4).
+u3.bmx[0].blockcount = add: offline re-scrub failed (1).
+u3.bmx[0].blockcount = add: pre-mod mount failed (32).
 Done fuzzing inode
diff --git a/tests/xfs/379.out b/tests/xfs/379.out
index 308b193490..2b856af2f4 100644
--- a/tests/xfs/379.out
+++ b/tests/xfs/379.out
@@ -2,4 +2,78 @@ QA output created by 379
 Format and populate
 Find btree-format file inode
 Fuzz inode
+core.mode = zeroes: offline re-scrub failed (1).
+core.mode = zeroes: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.size = zeroes: online scrub didn't fail.
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+core.size = sub: online scrub didn't fail.
+core.naextents = lastbit: online repair failed (1).
+core.naextents = lastbit: online re-scrub failed (5).
+core.naextents = lastbit: offline re-scrub failed (1).
+core.naextents = lastbit: online post-mod scrub failed (1).
+core.naextents = lastbit: offline post-mod scrub failed (1).
+core.forkoff = ones: online repair failed (1).
+core.forkoff = ones: online re-scrub failed (5).
+core.forkoff = ones: offline re-scrub failed (1).
+core.forkoff = ones: online post-mod scrub failed (1).
+core.forkoff = ones: offline post-mod scrub failed (1).
+core.forkoff = firstbit: online repair failed (1).
+core.forkoff = firstbit: online re-scrub failed (5).
+core.forkoff = firstbit: offline re-scrub failed (1).
+core.forkoff = firstbit: online post-mod scrub failed (1).
+core.forkoff = firstbit: offline post-mod scrub failed (1).
+core.forkoff = add: online repair failed (1).
+core.forkoff = add: online re-scrub failed (5).
+core.forkoff = add: offline re-scrub failed (1).
+core.forkoff = add: online post-mod scrub failed (1).
+core.forkoff = add: offline post-mod scrub failed (1).
+core.forkoff = sub: online repair failed (1).
+core.forkoff = sub: online re-scrub failed (5).
+core.forkoff = sub: offline re-scrub failed (1).
+core.forkoff = sub: online post-mod scrub failed (1).
+core.forkoff = sub: offline post-mod scrub failed (1).
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/381.out b/tests/xfs/381.out
index 217b15e325..4141e66342 100644
--- a/tests/xfs/381.out
+++ b/tests/xfs/381.out
@@ -2,4 +2,5 @@ QA output created by 381
 Format and populate
 Find bmbt block
 Fuzz bmbt
+rightsib = lastbit: online re-scrub failed (5).
 Done fuzzing bmbt
diff --git a/tests/xfs/383.out b/tests/xfs/383.out
index 69e2bca491..b124a4e2a9 100644
--- a/tests/xfs/383.out
+++ b/tests/xfs/383.out
@@ -2,4 +2,8 @@ QA output created by 383
 Format and populate
 Find symlink remote block
 Fuzz symlink remote block
+data = ones: online scrub didn't fail.
+data = firstbit: online scrub didn't fail.
+data = middlebit: online scrub didn't fail.
+data = lastbit: online scrub didn't fail.
 Done fuzzing symlink remote block
diff --git a/tests/xfs/385.out b/tests/xfs/385.out
index e2b6bffd90..02dd1d5085 100644
--- a/tests/xfs/385.out
+++ b/tests/xfs/385.out
@@ -2,4 +2,72 @@ QA output created by 385
 Format and populate
 Find inline-format dir inode
 Fuzz inline-format dir inode
+core.mode = firstbit: online repair failed (1).
+core.mode = firstbit: online re-scrub failed (5).
+core.mode = firstbit: offline re-scrub failed (1).
+core.mode = firstbit: online post-mod scrub failed (1).
+core.mode = firstbit: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.forkoff = firstbit: online repair failed (1).
+core.forkoff = firstbit: online re-scrub failed (5).
+core.forkoff = firstbit: offline re-scrub failed (1).
+core.forkoff = firstbit: online post-mod scrub failed (1).
+core.forkoff = firstbit: offline post-mod scrub failed (1).
+core.rtinherit = ones: online scrub didn't fail.
+core.rtinherit = firstbit: online scrub didn't fail.
+core.rtinherit = middlebit: online scrub didn't fail.
+core.rtinherit = lastbit: online scrub didn't fail.
+core.rtinherit = add: online scrub didn't fail.
+core.rtinherit = sub: online scrub didn't fail.
+core.projinherit = ones: online scrub didn't fail.
+core.projinherit = firstbit: online scrub didn't fail.
+core.projinherit = middlebit: online scrub didn't fail.
+core.projinherit = lastbit: online scrub didn't fail.
+core.projinherit = add: online scrub didn't fail.
+core.projinherit = sub: online scrub didn't fail.
+core.nosymlinks = ones: online scrub didn't fail.
+core.nosymlinks = firstbit: online scrub didn't fail.
+core.nosymlinks = middlebit: online scrub didn't fail.
+core.nosymlinks = lastbit: online scrub didn't fail.
+core.nosymlinks = add: online scrub didn't fail.
+core.nosymlinks = sub: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.sfdir3.list[1].offset = middlebit: online scrub didn't fail.
+u3.sfdir3.list[1].offset = lastbit: online scrub didn't fail.
+u3.sfdir3.list[1].offset = add: online scrub didn't fail.
 Done fuzzing inline-format dir inode
diff --git a/tests/xfs/399.out b/tests/xfs/399.out
index 229bcc0353..8379781def 100644
--- a/tests/xfs/399.out
+++ b/tests/xfs/399.out
@@ -2,4 +2,67 @@ QA output created by 399
 Format and populate
 Find inline-format attr inode
 Fuzz inline-format attr inode
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+a.sfattr.list[1].name = ones: online scrub didn't fail.
+a.sfattr.list[1].name = firstbit: online scrub didn't fail.
+a.sfattr.list[1].name = middlebit: online scrub didn't fail.
+a.sfattr.list[1].name = lastbit: online scrub didn't fail.
+a.sfattr.list[1].name = add: online scrub didn't fail.
+a.sfattr.list[1].name = sub: online scrub didn't fail.
+a.sfattr.list[2].name = ones: online scrub didn't fail.
+a.sfattr.list[2].name = firstbit: online scrub didn't fail.
+a.sfattr.list[2].name = middlebit: online scrub didn't fail.
+a.sfattr.list[2].name = lastbit: online scrub didn't fail.
+a.sfattr.list[2].name = add: online scrub didn't fail.
+a.sfattr.list[2].name = sub: online scrub didn't fail.
 Done fuzzing inline-format attr inode
diff --git a/tests/xfs/401.out b/tests/xfs/401.out
index 2729f3eafb..3102736cff 100644
--- a/tests/xfs/401.out
+++ b/tests/xfs/401.out
@@ -2,4 +2,76 @@ QA output created by 401
 Format and populate
 Find leaf-format attr block
 Fuzz leaf-format attr block
+hdr.firstused = middlebit: online scrub didn't fail.
+hdr.firstused = middlebit: offline re-scrub failed (1).
+hdr.firstused = middlebit: offline post-mod scrub failed (1).
+hdr.holes = ones: online scrub didn't fail.
+hdr.holes = firstbit: online scrub didn't fail.
+hdr.holes = middlebit: online scrub didn't fail.
+hdr.holes = lastbit: online scrub didn't fail.
+hdr.holes = add: online scrub didn't fail.
+hdr.holes = sub: online scrub didn't fail.
+hdr.freemap[0].size = zeroes: online scrub didn't fail.
+hdr.freemap[1].base = middlebit: online scrub didn't fail.
+hdr.freemap[2].base = middlebit: online scrub didn't fail.
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
diff --git a/tests/xfs/405.out b/tests/xfs/405.out
index b7c114cf69..0f9ad76bd5 100644
--- a/tests/xfs/405.out
+++ b/tests/xfs/405.out
@@ -2,4 +2,9 @@ QA output created by 405
 Format and populate
 Find external attr block
 Fuzz external attr block
+data = zeroes: online scrub didn't fail.
+data = ones: online scrub didn't fail.
+data = firstbit: online scrub didn't fail.
+data = middlebit: online scrub didn't fail.
+data = lastbit: online scrub didn't fail.
 Done fuzzing external attr block
diff --git a/tests/xfs/413.out b/tests/xfs/413.out
index cebe104e6e..8ad1b3d239 100644
--- a/tests/xfs/413.out
+++ b/tests/xfs/413.out
@@ -2,4 +2,52 @@ QA output created by 413
 Format and populate
 Find btree-format attr inode
 Fuzz inode
+core.mode = zeroes: offline re-scrub failed (1).
+core.mode = zeroes: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.size = middlebit: online scrub didn't fail.
+core.size = lastbit: online scrub didn't fail.
+core.size = add: online scrub didn't fail.
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = lastbit: online scrub didn't fail.
+v3.flags2 = add: online scrub didn't fail.
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.reflink = ones: online scrub didn't fail.
+v3.reflink = firstbit: online scrub didn't fail.
+v3.reflink = middlebit: online scrub didn't fail.
+v3.reflink = lastbit: online scrub didn't fail.
+v3.reflink = add: online scrub didn't fail.
+v3.reflink = sub: online scrub didn't fail.
+a.bmbt.ptrs[1] = firstbit: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/415.out b/tests/xfs/415.out
index 0784c0d5d8..6ff2573796 100644
--- a/tests/xfs/415.out
+++ b/tests/xfs/415.out
@@ -2,4 +2,60 @@ QA output created by 415
 Format and populate
 Find blockdev inode
 Fuzz inode
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.size = middlebit: online scrub didn't fail.
+core.size = middlebit: offline re-scrub failed (1).
+core.size = middlebit: offline post-mod scrub failed (1).
+core.size = lastbit: online scrub didn't fail.
+core.size = lastbit: offline re-scrub failed (1).
+core.size = lastbit: offline post-mod scrub failed (1).
+core.size = add: online scrub didn't fail.
+core.size = add: offline re-scrub failed (1).
+core.size = add: offline post-mod scrub failed (1).
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.dev = zeroes: online scrub didn't fail.
+u3.dev = ones: online scrub didn't fail.
+u3.dev = firstbit: online scrub didn't fail.
+u3.dev = middlebit: online scrub didn't fail.
+u3.dev = lastbit: online scrub didn't fail.
+u3.dev = add: online scrub didn't fail.
+u3.dev = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/417.out b/tests/xfs/417.out
index 744cc2c715..cbd2b8f6e3 100644
--- a/tests/xfs/417.out
+++ b/tests/xfs/417.out
@@ -2,4 +2,60 @@ QA output created by 417
 Format and populate
 Find local-format symlink inode
 Fuzz inode
+core.mode = firstbit: online repair failed (1).
+core.mode = firstbit: online re-scrub failed (5).
+core.mode = firstbit: offline re-scrub failed (1).
+core.mode = firstbit: online post-mod scrub failed (1).
+core.mode = firstbit: offline post-mod scrub failed (1).
+core.mode = middlebit: online scrub didn't fail.
+core.mode = lastbit: online scrub didn't fail.
+core.mode = add: online scrub didn't fail.
+core.uid = ones: online re-scrub failed (1).
+core.gid = ones: online re-scrub failed (1).
+core.nlinkv2 = zeroes: online repair failed (4).
+core.nlinkv2 = zeroes: online re-scrub failed (4).
+core.nlinkv2 = zeroes: offline re-scrub failed (1).
+core.nlinkv2 = zeroes: online post-mod scrub failed (4).
+core.nlinkv2 = zeroes: offline post-mod scrub failed (1).
+core.nlinkv2 = lastbit: online repair failed (4).
+core.nlinkv2 = lastbit: online re-scrub failed (4).
+core.nlinkv2 = lastbit: offline re-scrub failed (1).
+core.nlinkv2 = lastbit: online post-mod scrub failed (4).
+core.nlinkv2 = lastbit: offline post-mod scrub failed (1).
+core.forkoff = firstbit: online repair failed (1).
+core.forkoff = firstbit: online re-scrub failed (5).
+core.forkoff = firstbit: offline re-scrub failed (1).
+core.forkoff = firstbit: online post-mod scrub failed (1).
+core.forkoff = firstbit: offline post-mod scrub failed (1).
+next_unlinked = add: online scrub didn't fail.
+next_unlinked = add: offline re-scrub failed (1).
+next_unlinked = add: offline post-mod scrub failed (1).
+v3.change_count = zeroes: online scrub didn't fail.
+v3.change_count = ones: online scrub didn't fail.
+v3.change_count = firstbit: online scrub didn't fail.
+v3.change_count = middlebit: online scrub didn't fail.
+v3.change_count = lastbit: online scrub didn't fail.
+v3.change_count = add: online scrub didn't fail.
+v3.change_count = sub: online scrub didn't fail.
+v3.flags2 = ones: offline re-scrub failed (1).
+v3.flags2 = ones: offline post-mod scrub failed (1).
+v3.flags2 = middlebit: online scrub didn't fail.
+v3.flags2 = middlebit: offline re-scrub failed (1).
+v3.flags2 = middlebit: offline post-mod scrub failed (1).
+v3.flags2 = add: offline re-scrub failed (1).
+v3.flags2 = add: offline post-mod scrub failed (1).
+v3.flags2 = sub: offline re-scrub failed (1).
+v3.flags2 = sub: offline post-mod scrub failed (1).
+v3.nrext64 = zeroes: online scrub didn't fail.
+v3.nrext64 = firstbit: online scrub didn't fail.
+v3.nrext64 = middlebit: online scrub didn't fail.
+v3.nrext64 = lastbit: online scrub didn't fail.
+v3.nrext64 = add: online scrub didn't fail.
+v3.nrext64 = sub: online scrub didn't fail.
+u3.symlink = ones: online scrub didn't fail.
+u3.symlink = firstbit: online scrub didn't fail.
+u3.symlink = middlebit: online scrub didn't fail.
+u3.symlink = lastbit: online scrub didn't fail.
+u3.symlink = add: online scrub didn't fail.
+u3.symlink = sub: online scrub didn't fail.
 Done fuzzing inode
diff --git a/tests/xfs/426.out b/tests/xfs/426.out
index daddd1f3c8..d431c3dfb9 100644
--- a/tests/xfs/426.out
+++ b/tests/xfs/426.out
@@ -1,4 +1,136 @@
 QA output created by 426
 Format and populate
 Fuzz user 0 dquot
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: online repair failed (1).
+diskdq.blk_softlimit = ones: online re-scrub failed (5).
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: online repair failed (1).
+diskdq.blk_softlimit = firstbit: online re-scrub failed (5).
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: online repair failed (1).
+diskdq.blk_softlimit = middlebit: online re-scrub failed (5).
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: online repair failed (1).
+diskdq.blk_softlimit = lastbit: online re-scrub failed (5).
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: online repair failed (1).
+diskdq.blk_softlimit = add: online re-scrub failed (5).
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: online repair failed (1).
+diskdq.blk_softlimit = sub: online re-scrub failed (5).
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: online repair failed (1).
+diskdq.ino_softlimit = ones: online re-scrub failed (5).
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: online repair failed (1).
+diskdq.ino_softlimit = firstbit: online re-scrub failed (5).
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: online repair failed (1).
+diskdq.ino_softlimit = middlebit: online re-scrub failed (5).
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: online repair failed (1).
+diskdq.ino_softlimit = lastbit: online re-scrub failed (5).
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: online repair failed (1).
+diskdq.ino_softlimit = add: online re-scrub failed (5).
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: online repair failed (1).
+diskdq.ino_softlimit = sub: online re-scrub failed (5).
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: online repair failed (1).
+diskdq.rtb_softlimit = ones: online re-scrub failed (5).
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: online repair failed (1).
+diskdq.rtb_softlimit = firstbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: online repair failed (1).
+diskdq.rtb_softlimit = middlebit: online re-scrub failed (5).
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: online repair failed (1).
+diskdq.rtb_softlimit = lastbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: online repair failed (1).
+diskdq.rtb_softlimit = add: online re-scrub failed (5).
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: online repair failed (1).
+diskdq.rtb_softlimit = sub: online re-scrub failed (5).
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz user 4242 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz user 8484 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/428.out b/tests/xfs/428.out
index f694aa03a6..b0ea71f271 100644
--- a/tests/xfs/428.out
+++ b/tests/xfs/428.out
@@ -1,4 +1,136 @@
 QA output created by 428
 Format and populate
 Fuzz group 0 dquot
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: online repair failed (1).
+diskdq.blk_softlimit = ones: online re-scrub failed (5).
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: online repair failed (1).
+diskdq.blk_softlimit = firstbit: online re-scrub failed (5).
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: online repair failed (1).
+diskdq.blk_softlimit = middlebit: online re-scrub failed (5).
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: online repair failed (1).
+diskdq.blk_softlimit = lastbit: online re-scrub failed (5).
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: online repair failed (1).
+diskdq.blk_softlimit = add: online re-scrub failed (5).
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: online repair failed (1).
+diskdq.blk_softlimit = sub: online re-scrub failed (5).
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: online repair failed (1).
+diskdq.ino_softlimit = ones: online re-scrub failed (5).
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: online repair failed (1).
+diskdq.ino_softlimit = firstbit: online re-scrub failed (5).
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: online repair failed (1).
+diskdq.ino_softlimit = middlebit: online re-scrub failed (5).
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: online repair failed (1).
+diskdq.ino_softlimit = lastbit: online re-scrub failed (5).
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: online repair failed (1).
+diskdq.ino_softlimit = add: online re-scrub failed (5).
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: online repair failed (1).
+diskdq.ino_softlimit = sub: online re-scrub failed (5).
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: online repair failed (1).
+diskdq.rtb_softlimit = ones: online re-scrub failed (5).
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: online repair failed (1).
+diskdq.rtb_softlimit = firstbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: online repair failed (1).
+diskdq.rtb_softlimit = middlebit: online re-scrub failed (5).
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: online repair failed (1).
+diskdq.rtb_softlimit = lastbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: online repair failed (1).
+diskdq.rtb_softlimit = add: online re-scrub failed (5).
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: online repair failed (1).
+diskdq.rtb_softlimit = sub: online re-scrub failed (5).
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz group 4242 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz group 8484 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/430.out b/tests/xfs/430.out
index 0e7fa85c30..5193cae57e 100644
--- a/tests/xfs/430.out
+++ b/tests/xfs/430.out
@@ -1,4 +1,136 @@
 QA output created by 430
 Format and populate
 Fuzz project 0 dquot
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.blk_softlimit = ones: online repair failed (1).
+diskdq.blk_softlimit = ones: online re-scrub failed (5).
+diskdq.blk_softlimit = ones: online post-mod scrub failed (1).
+diskdq.blk_softlimit = firstbit: online repair failed (1).
+diskdq.blk_softlimit = firstbit: online re-scrub failed (5).
+diskdq.blk_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = middlebit: online repair failed (1).
+diskdq.blk_softlimit = middlebit: online re-scrub failed (5).
+diskdq.blk_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = lastbit: online repair failed (1).
+diskdq.blk_softlimit = lastbit: online re-scrub failed (5).
+diskdq.blk_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.blk_softlimit = add: online repair failed (1).
+diskdq.blk_softlimit = add: online re-scrub failed (5).
+diskdq.blk_softlimit = add: online post-mod scrub failed (1).
+diskdq.blk_softlimit = sub: online repair failed (1).
+diskdq.blk_softlimit = sub: online re-scrub failed (5).
+diskdq.blk_softlimit = sub: online post-mod scrub failed (1).
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_softlimit = ones: online repair failed (1).
+diskdq.ino_softlimit = ones: online re-scrub failed (5).
+diskdq.ino_softlimit = ones: online post-mod scrub failed (1).
+diskdq.ino_softlimit = firstbit: online repair failed (1).
+diskdq.ino_softlimit = firstbit: online re-scrub failed (5).
+diskdq.ino_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = middlebit: online repair failed (1).
+diskdq.ino_softlimit = middlebit: online re-scrub failed (5).
+diskdq.ino_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = lastbit: online repair failed (1).
+diskdq.ino_softlimit = lastbit: online re-scrub failed (5).
+diskdq.ino_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.ino_softlimit = add: online repair failed (1).
+diskdq.ino_softlimit = add: online re-scrub failed (5).
+diskdq.ino_softlimit = add: online post-mod scrub failed (1).
+diskdq.ino_softlimit = sub: online repair failed (1).
+diskdq.ino_softlimit = sub: online re-scrub failed (5).
+diskdq.ino_softlimit = sub: online post-mod scrub failed (1).
+diskdq.itimer = ones: online scrub didn't fail.
+diskdq.itimer = firstbit: online scrub didn't fail.
+diskdq.itimer = middlebit: online scrub didn't fail.
+diskdq.itimer = lastbit: online scrub didn't fail.
+diskdq.itimer = add: online scrub didn't fail.
+diskdq.itimer = sub: online scrub didn't fail.
+diskdq.btimer = ones: online scrub didn't fail.
+diskdq.btimer = firstbit: online scrub didn't fail.
+diskdq.btimer = middlebit: online scrub didn't fail.
+diskdq.btimer = lastbit: online scrub didn't fail.
+diskdq.btimer = add: online scrub didn't fail.
+diskdq.btimer = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_softlimit = ones: online repair failed (1).
+diskdq.rtb_softlimit = ones: online re-scrub failed (5).
+diskdq.rtb_softlimit = ones: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = firstbit: online repair failed (1).
+diskdq.rtb_softlimit = firstbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = firstbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = middlebit: online repair failed (1).
+diskdq.rtb_softlimit = middlebit: online re-scrub failed (5).
+diskdq.rtb_softlimit = middlebit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = lastbit: online repair failed (1).
+diskdq.rtb_softlimit = lastbit: online re-scrub failed (5).
+diskdq.rtb_softlimit = lastbit: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = add: online repair failed (1).
+diskdq.rtb_softlimit = add: online re-scrub failed (5).
+diskdq.rtb_softlimit = add: online post-mod scrub failed (1).
+diskdq.rtb_softlimit = sub: online repair failed (1).
+diskdq.rtb_softlimit = sub: online re-scrub failed (5).
+diskdq.rtb_softlimit = sub: online post-mod scrub failed (1).
+diskdq.rtbtimer = ones: online scrub didn't fail.
+diskdq.rtbtimer = firstbit: online scrub didn't fail.
+diskdq.rtbtimer = middlebit: online scrub didn't fail.
+diskdq.rtbtimer = lastbit: online scrub didn't fail.
+diskdq.rtbtimer = add: online scrub didn't fail.
+diskdq.rtbtimer = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz project 4242 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
+Done fuzzing dquot
+Fuzz project 8484 dquot
+diskdq.type = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = ones: online scrub didn't fail.
+diskdq.blk_hardlimit = firstbit: online scrub didn't fail.
+diskdq.blk_hardlimit = middlebit: online scrub didn't fail.
+diskdq.blk_hardlimit = lastbit: online scrub didn't fail.
+diskdq.blk_hardlimit = add: online scrub didn't fail.
+diskdq.blk_hardlimit = sub: online scrub didn't fail.
+diskdq.ino_hardlimit = ones: online scrub didn't fail.
+diskdq.ino_hardlimit = firstbit: online scrub didn't fail.
+diskdq.ino_hardlimit = middlebit: online scrub didn't fail.
+diskdq.ino_hardlimit = lastbit: online scrub didn't fail.
+diskdq.ino_hardlimit = add: online scrub didn't fail.
+diskdq.ino_hardlimit = sub: online scrub didn't fail.
+diskdq.rtb_hardlimit = ones: online scrub didn't fail.
+diskdq.rtb_hardlimit = firstbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = middlebit: online scrub didn't fail.
+diskdq.rtb_hardlimit = lastbit: online scrub didn't fail.
+diskdq.rtb_hardlimit = add: online scrub didn't fail.
+diskdq.rtb_hardlimit = sub: online scrub didn't fail.
 Done fuzzing dquot
diff --git a/tests/xfs/730.out b/tests/xfs/730.out
index 28d4becad3..c35b704a11 100644
--- a/tests/xfs/730.out
+++ b/tests/xfs/730.out
@@ -1,4 +1,14 @@
 QA output created by 730
 Format and populate
 Fuzz fscounters
+icount = zeroes: online scrub didn't fail.
+icount = ones: online scrub didn't fail.
+icount = firstbit: online scrub didn't fail.
+icount = middlebit: online scrub didn't fail.
+ifree = ones: online scrub didn't fail.
+ifree = firstbit: online scrub didn't fail.
+ifree = middlebit: online scrub didn't fail.
+fdblocks = ones: online scrub didn't fail.
+fdblocks = firstbit: online scrub didn't fail.
+fdblocks = middlebit: online scrub didn't fail.
 Done fuzzing fscounters

