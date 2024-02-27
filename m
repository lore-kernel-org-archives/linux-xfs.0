Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EDEEAD7;
	Tue, 27 Feb 2024 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999311; cv=none; b=qZ9JAYAIYYwKKA//XT4uXX9p0Kc4fWagUyemvsQTpPVCZnj3SJY5CSjF3GyMa1MNUrkPx61aFqh7ot7Vxh3Wuduv7r7eZY3a8I9FsZ3frYjwxUyHOUuSMHkPhNcWwon5+cAg6T2YpJMorotko2Y71oE+TxqcPkCWBksPL1nQwjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999311; c=relaxed/simple;
	bh=dvT9c7kBr+tIQMAf5U4o59zot8fG3gA560mRjYbu2d0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aeo7PMGctFvw1/BEZ2U1tigPxBbAW7+6+frEmDftIb9EglMuh/pYhuEMeY3GYv1Q3EBaymE0ZxUz/jCwodbBWjZ9f+vbUgSSJRoPt8IJiWQs67LFq0THKYNXogRCV7Dq8Y1FDSndaj8qr3m8DzK7tipStFEOf+uiYa4xPIwOtqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsAiRZcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsAiRZcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B1CC433C7;
	Tue, 27 Feb 2024 02:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999310;
	bh=dvT9c7kBr+tIQMAf5U4o59zot8fG3gA560mRjYbu2d0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GsAiRZcDqwUJpxXTU2+jT9hMe3dAsAwWmqBFL5ZbtAk/cIxgxDnWPTqvCAlQW5YKm
	 C8Ooi6wZNGa4lyHUmlcZyom/XJlYtUyyghEpiaqw5AW5L8pyBjq8w7Vxl0Fsv5nVP1
	 1ZtIRQ1+WGDHfiSiJjeaetvprARoppr8C0iY+zH9U0CVQ7xPBdYcarisMefgyTdkzK
	 4xg75JeLJWAJMWOi+xEEl96uCFYLKmuavEGPG2ZFOVBpI22Iz6uI0S8sxD9feXJKDb
	 zwsU3GbU70lS+nAPD29mD52sshqtVrcF8mRaG+xM+71FX1qjQ8YarUCW0cqb9ce+vZ
	 mmbI45w83hxng==
Date: Mon, 26 Feb 2024 18:01:50 -0800
Subject: [PATCH 5/8] xfs/599: reduce the amount of attrs created here
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: Luis Chamberlain <mcgrof@kernel.org>, linux-xfs@vger.kernel.org,
 guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915290.896550.10775908547486721272.stgit@frogsfrogsfrogs>
In-Reply-To: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
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

Luis Chamberlain reported insane runtimes in this test:

"xfs/599 takes a long time on LBS, but it passes. The amount of time it
takes, however, begs the question if the test is could be trimmed to do
less work because the larger the block size the larger the number of
dirents and xattrs are used to create. The large dirents are not a
problem. The amount of time it takes to create xattrs with hashcol
however grows exponentially in time.

"n=16k   takes 5   seconds
"n=32k   takes 30  seconds
"n=64k     takes 6-7 minutes
"n=1048576 takes 30 hours

"n=1048576 is what we use for block size 32k.

"Do we really need so many xattrs for larger block sizes for this test?"

No, we don't.  The goal of this test is to create a two-level dabtree of
xattrs having identical hashes.  However, the test author (me)
apparently forgot that if a dabtree is created in the attr fork, there
will be a dabtree entry for each extended attribute, not each attr leaf
block.  Hence it's a waste of time to multiply da_records_per_block by
attr_records_per_block.

Reported-by: Luis Chamberlain <mcgrof@kernel.org>
Fixes: 1cd6b61299 ("xfs: add a couple more tests for ascii-ci problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/599 |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)


diff --git a/tests/xfs/599 b/tests/xfs/599
index b55b62d7f5..57a797f0f5 100755
--- a/tests/xfs/599
+++ b/tests/xfs/599
@@ -43,14 +43,13 @@ longname="$(mktemp --dry-run "$(perl -e 'print "X" x 255;')" | tr ' ' 'X')"
 echo "creating $nr_dirents dirents from '$longname'" >> $seqres.full
 _scratch_xfs_db -r -c "hashcoll -n $nr_dirents -p $crash_dir $longname"
 
-# Create enough xattrs to fill two dabtree nodes.  Each attribute leaf block
-# gets its own record in the dabtree, so we have to create enough attr blocks
-# (each full of attrs) to get a dabtree of at least height 2.
+# Create enough xattrs to fill two dabtree nodes.  Each attribute entry gets
+# its own record in the dabtree, so we have to create enough attributes to get
+# a dabtree of at least height 2.
 blksz=$(_get_block_size "$SCRATCH_MNT")
 
-attr_records_per_block=$((blksz / 255))
 da_records_per_block=$((blksz / 8))	# 32-bit hash and 32-bit before
-nr_attrs=$((da_records_per_block * attr_records_per_block * 2))
+nr_attrs=$((da_records_per_block * 2))
 
 longname="$(mktemp --dry-run "$(perl -e 'print "X" x 249;')" | tr ' ' 'X')"
 echo "creating $nr_attrs attrs from '$longname'" >> $seqres.full

