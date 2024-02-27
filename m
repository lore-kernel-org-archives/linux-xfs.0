Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A12748A;
	Tue, 27 Feb 2024 02:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999264; cv=none; b=MWD+G09ZMCU7GB8uARsC/hC3n2uk/URkYag9HFKrlLA4ocjqd9SKgODPDJEOSNM5Guu2WkCONtULjXr8U8L+skpbuHBbOWLNy/tRRhbIyI6HGVIsmkYU0yQsX5xj5/dSKZXezSCFvt4YjJHurJOJ1Sp+rUJoMaQDYkP12PcZbB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999264; c=relaxed/simple;
	bh=Qwrrj296wCF8LsYJGMm83wU+JXfefljQJO69a+BbtMs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N9DzQ83kcaN4cyHg9wtu9xaZqJzoxgrRmj8X9vbTQ6VB1EAIfdpNw3fNPWzqcLBKDG4Irh4+/mIFeq37BUpOsAs8lyw8+lHE1wzEqvn6d7dR5tOYJY6jUoYKWjhfzgr2tQiAz8/eqcOnNMGBVG7xWBsOfJXy1eaOcLUqgICeFcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=StPe0xgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="StPe0xgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81DFC433F1;
	Tue, 27 Feb 2024 02:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708999263;
	bh=Qwrrj296wCF8LsYJGMm83wU+JXfefljQJO69a+BbtMs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=StPe0xgBgC3w+WRT5XKj3ao96KXWpifZEdvpcf2pzIVr1EOlND+yMncse59SERRyg
	 BgNaUcR7h8piajjZjUx9Z4BOzPeUlaENHJyxjkBrAA9WW+I2b3FSZCsOVb/ebVTHIs
	 QPr8QXGNlfR8g1duHHRMfLKBIr36Uwoe4QkTOyLXfj0uzVqlT5Ir9BsxSKLsBaFtwl
	 eLHZ0e+W2uUJj8FrolaWgdwIis+TFQgHxAkT0fz4IiGkqeirSWlqgUivpWAhmyc+UU
	 t349JDJBs3FWDr+2PNEpOjyy25rVqyUlNW3KZir4QN2MNKoT7U91GQhiCsMc6T5sMh
	 ZyB7VKahKaMZA==
Date: Mon, 26 Feb 2024 18:01:03 -0800
Subject: [PATCH 2/8] xfs/155: fail the test if xfs_repair hangs for too long
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Message-ID: <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>
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

There are a few hard to reproduce bugs in xfs_repair where it can
deadlock trying to lock a buffer that it already owns.  These stalls
cause fstests never to finish, which is annoying!  To fix this, set up
the xfs_repair run to abort after 10 minutes, which will affect the
golden output and capture a core file.

This doesn't fix xfs_repair, obviously.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/155 |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/tests/xfs/155 b/tests/xfs/155
index 302607b510..fba557bff6 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -27,6 +27,10 @@ _require_scratch_xfs_crc		# needsrepair only exists for v5
 _require_populate_commands
 _require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
 
+# Inject a 10 minute abortive timeout on the repair program so that deadlocks
+# in the program do not cause fstests to hang indefinitely.
+XFS_REPAIR_PROG="timeout -s ABRT 10m $XFS_REPAIR_PROG"
+
 # Populate the filesystem
 _scratch_populate_cached nofill >> $seqres.full 2>&1
 

