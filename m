Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77F1A317A;
	Wed, 21 May 2025 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867375; cv=none; b=RapnRN9H/WiXkZ9KidhAU1wWZhl9BEP+xaeWvLpDmkv/Di9w3SUtwoMSEoMHP9uYSPA4jdfFJf9ENXJKxvgRnDIR3v37kCRDz2LvBWm6Y5lD7KjpupDGjOkWxfdCsfzyLhZeehrwJ2YF2jFGTTPGK63ywL3DepNjfOIu/cLfnPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867375; c=relaxed/simple;
	bh=HcPponYH94jEwm0Ptm/amqoYVg9GJe8kWxdsay/eVyQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V349KiybBpN0ZQeLj/sulSplPpgCj5QtPIGMuydqRU0qTBJQ1Vf65EnAGitG6Q9sCEMNzqeRQcM0o7L2g2RBJqF9QQuFX/rAT0ROgs5ZP/N9sFHoh4O0kAZRYd9pXj8MMUFaQyF3eqXS652HS40QATYp8/tVcSaRBlSNVur5Lu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d2IzCKGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d2IzCKGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12288C4CEE4;
	Wed, 21 May 2025 22:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867375;
	bh=HcPponYH94jEwm0Ptm/amqoYVg9GJe8kWxdsay/eVyQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d2IzCKGqUKQ9poio9YDWJf9nZrPa0AGsY1sl6q4z5C3a/nvBOUmEWDsgbtXmRS9yq
	 NAaK2YrPV8o+OE9kCi+i+QKJ6ZqJddOElM9/DDTx10e2kvL03y8RSQMdFeTQoWnf/f
	 7b91hd8bh4WmylC//WdILv3wmvxqDX3InwfXRC6qJ2WuUhdghCB+XMxEh87PMzpY5d
	 2zVJufKaL6l5pX46CKxo7xWKOAdDoGimfskCsmj0b/o9A88gZQ5lqa0OahnZBbfXnS
	 R7zzCS8bE0+csnCMvXvIQWrtGb7PKULYSfastJlLLi2VNtAmwOt4uNcQPwb984F71O
	 yX1c68qbxqaTA==
Date: Wed, 21 May 2025 15:42:54 -0700
Subject: [PATCH 4/4] check: check and fix the test filesystem after failed
 tests
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <174786719769.1398933.12370766699740321314.stgit@frogsfrogsfrogs>
In-Reply-To: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
References: <174786719678.1398933.16005683028409620583.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, ./check calls _check_filesystems after a test passes to make
sure that the test and scratch filesystems are ok, and repairs the test
filesystem if it's not ok.

However, we don't do this for failed tests.  If a test fails /and/
corrupts the test filesystem, every subsequent passing test will be
marked as a failure because of latent corruptions on the test
filesystem.

This is a little silly, so let's call _check_filesystems on the test
filesystem after a test fail so that the badness doesn't spread.

Cc: <fstests@vger.kernel.org> # v2023.05.01
Fixes: 4a444bc19a836f ("check: _check_filesystems for errors even if test failed")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/check b/check
index 826641268f8b52..818ce44da28f65 100755
--- a/check
+++ b/check
@@ -986,8 +986,13 @@ function run_section()
 			_dump_err_cont "[failed, exit status $sts]"
 			_test_unmount 2> /dev/null
 			_scratch_unmount 2> /dev/null
-			rm -f ${RESULT_DIR}/require_test*
 			rm -f ${RESULT_DIR}/require_scratch*
+
+			# Make sure the test filesystem is ready to go since
+			# we don't call _check_filesystems for failed tests
+			(_adjust_oom_score 250; _check_filesystems) || tc_status="fail"
+
+			rm -f ${RESULT_DIR}/require_test*
 			# Even though we failed, there may be something interesting in
 			# dmesg which can help debugging.
 			_check_dmesg

