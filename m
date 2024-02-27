Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FF217FF;
	Tue, 27 Feb 2024 04:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008861; cv=none; b=W/gXAMU6qS8rWdlUcUUaGnfipgVymFLtJbvQU+GPpSUNnYMLEaycYORb1/16g/4OypLzFNoUYFL82T5bguWpfxO6i2rRsQPewof7NTW3JhNtcBbGIsqLrT4QsK4KsV0i1KT+7VNVAPg5VhTLGvoRDUZYhnjJRTnxz6lr3WOnfnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008861; c=relaxed/simple;
	bh=ODQW4oNbiGwkuTVK0GRqZAClbVqMY/WL+zq7TCXW8JQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9wGV4USQYrARJ9fVqG590iQ9sIzAA1bkQvinahNKfS0NLHwOICbws6YAqm1OefHS1uEPlac/iDt9bl9YQWqAtFSkMg1+2YDzy4/Jei0enj9b9ZBM+Os2Z6pQVW4hcBS9c5gqY5jGdr9VaAGzwYt0ilMw3Rem4T4et5VHN2ycGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx90GqWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx90GqWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBC2C433C7;
	Tue, 27 Feb 2024 04:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709008861;
	bh=ODQW4oNbiGwkuTVK0GRqZAClbVqMY/WL+zq7TCXW8JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Sx90GqWMK/9AyUjvaTEC9cBOoC6Or3uij650324QYtXD7v6hPG0QPUgyOzwYS68DI
	 fXA0JkKBggJ98ZGg5hKkqvClyrBbE+SJvuNCLphJv+IR0N9ye9vfqxVu1VEd4dKAiL
	 p7y4zVe1+GgC/fPf4CUL1tfIuVjtGnawOAyWTAuV+RyqAtDtRtwvKFq6gMaKeoe/wH
	 YAkEJw/w9Ll2sfIfBe3VR1q1hF8CYnPypa20yaS2xVl1cB7TuUNaK2GNQmjo0OMp4l
	 oTgVGEHcbG1k4lki8TmP2Vc7F1vWEeDSCcrd+GPJ5qwMbsLFSUmvsUNu8lgcacyfXv
	 4xtywvJSmFSRg==
Date: Mon, 26 Feb 2024 20:41:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Subject: [PATCH v1.1 2/8] xfs/155: fail the test if xfs_repair hangs for too
 long
Message-ID: <20240227044100.GU616564@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170899915247.896550.12193016117687961302.stgit@frogsfrogsfrogs>

There are a few hard to reproduce bugs in xfs_repair where it can
deadlock trying to lock a buffer that it already owns.  These stalls
cause fstests never to finish, which is annoying!  To fix this, set up
the xfs_repair run to abort after 10 minutes, which will affect the
golden output and capture a core file.

This doesn't fix xfs_repair, obviously.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: require timeout command
---
 tests/xfs/155 |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tests/xfs/155 b/tests/xfs/155
index 302607b510..3181bfaf6f 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -26,6 +26,11 @@ _require_scratch_nocheck
 _require_scratch_xfs_crc		# needsrepair only exists for v5
 _require_populate_commands
 _require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
+_require_command "$TIMEOUT_PROG" timeout
+
+# Inject a 10 minute abortive timeout on the repair program so that deadlocks
+# in the program do not cause fstests to hang indefinitely.
+XFS_REPAIR_PROG="timeout -s ABRT 10m $XFS_REPAIR_PROG"
 
 # Populate the filesystem
 _scratch_populate_cached nofill >> $seqres.full 2>&1
