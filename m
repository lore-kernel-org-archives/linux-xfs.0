Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30195D477;
	Fri, 22 Nov 2024 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732294448; cv=none; b=jxJfn5xpbzid5jkxb3qh0HlHUKK+UjyHpVcmyDr5qLBFShmj+3He+Du62XBd1oE499QsBABlH+9/B88YcTBzLXBnQvNfjsIMT34j+4VoOx6YXBGuBYYHYziUYE0gWN61sB2u4zHPSE9ZwJwwozOI1O9meClsRsTK7w8RNOyzsK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732294448; c=relaxed/simple;
	bh=UQN4iBjjS9X0X0vwLd34ITFdSrcN8+d5IPfqQNonASI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPMnk9ygnVJ08wQHYkgADhx/h6mq80x6xtbVcPzpmp8rWdIB7HP97SqLaUlfAYe9OQ2dfRFE8vA6Kaf9mU7kKnw5rmX4Vz03jbPeahp824GcwE9R/ilJgf7yto8FH1vof3aGC9sTMV/UMH1IVSb9EMw78Sigwz4fpDwFdK3bE2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWBU7reF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWBU7reF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AC7C4CECE;
	Fri, 22 Nov 2024 16:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732294446;
	bh=UQN4iBjjS9X0X0vwLd34ITFdSrcN8+d5IPfqQNonASI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XWBU7reF/UxQpVBuzpxIYpL7vw5x+ytQjH5rBu2iHUNH35A/V4qDaT8+JjdwaGS1P
	 cT+dFMuCx7yAYhiRznXTDqASjzPwBxwFe72/U3wV92eQaXhSt4/8v3v2EP2gFZIIrU
	 zeSnGUv6JeffqVkBrXjoTEyQuK15Dq/eMgB3oIq5a7M12PSQl8UIYxQnsBdvERdIQx
	 JldT7hXAvCAESDUoNUGesTSOeHkUsG3g+nIZR8TsHNCMmm7T2AstqhuRIOPUyNi1uT
	 4rEaW8sE3l6gHx3s8jACvhd3BtA0zRFX1Zhnp71ak7AHuWuaS7F5i9PSAt3d5HWO3+
	 1wEMIKqU4JHTQ==
Date: Fri, 22 Nov 2024 08:54:06 -0800
Subject: [PATCH 14/17] generic/251: don't copy the fsstress source code
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173229420224.358248.12570640675092195188.stgit@frogsfrogsfrogs>
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

Run fsstress for a short time to generate test data to replicate on the
scratch device so that we don't blow out the test runtimes on
unintentionally copying .git directories or large corefiles from the
developer's systems, etc.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/251 |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/tests/generic/251 b/tests/generic/251
index b4ddda10cef403..ec486c277c6828 100755
--- a/tests/generic/251
+++ b/tests/generic/251
@@ -173,13 +173,11 @@ function run_process() {
 
 nproc=$((4 * LOAD_FACTOR))
 
-# Copy $here to the scratch fs and make coipes of the replica.  The fstests
-# output (and hence $seqres.full) could be in $here, so we need to snapshot
-# $here before computing file checksums.
+# Use fsstress to create a directory tree with some variability
 content=$SCRATCH_MNT/orig
 mkdir -p $content
-cp -axT $here/ $content/
-
+FSSTRESS_ARGS=$(_scale_fsstress_args -p 4 -d $content -n 1000 $FSSTRESS_AVOID)
+$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full
 mkdir -p $tmp
 
 (

