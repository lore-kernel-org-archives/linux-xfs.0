Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA05271839;
	Wed, 12 Feb 2025 03:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739331372; cv=none; b=hHGGDs2Q0v4VHUfvRTM7Gi4KA+kXB+XMd1GgGPv/tiuYn08BnIfTWsOYaWJW5uukr5zrc9oPN8CwAu/ornLPhMZuRZQvum7I15NJ8woaD2lDEky1tdTkmnGzqJielHkncCzgI3GXeCu0qE9QZhsUXtr6/Bu1j6tQOIx/8RhfMDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739331372; c=relaxed/simple;
	bh=mq3sMa07Noxd8Z3iThwHHbLVrhD5GaJ7XMiK/0+IeUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBso/jbS6YoJLiUbXfOMYBvisGGIqmxuoiMLUOcDdm0VIujQ9mL6gSCZ6JlUKDHjxbIyxaCx6pcYKEobHlMiuOTFg2XWk5ffPMRnSxWtYuBVweUkCnscca2eVhsNDfFsqprjMrCojhOgiONf/PW2c76Fq1zsLPLvWhw5+Vwzs5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZePBg8lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZePBg8lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCBBC4CEDF;
	Wed, 12 Feb 2025 03:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739331369;
	bh=mq3sMa07Noxd8Z3iThwHHbLVrhD5GaJ7XMiK/0+IeUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZePBg8lZO/us8pWl4/YBxuhAs3BUC7srHEcWoe0LxJfpElO63XvGevGrxhYfOTpOW
	 1UiRpJXqWhRlpfzGslSDT4uah8mMWU9i0m8qk0cCVyCIJGotsKqZlcvzVhcQyWsWOw
	 5aR37a4h7ps8lkm8AJipqaH7ypayd7cPqVdCt/6QMP9BPUl+8rjuRbBoKoLuhBzI1+
	 ltxC4hc3OX+m1LFH8sMSUNtP6lgDlLKrx4L5+WJE66tmW4QZG9cmPoxTuufaTK6cW4
	 960GEeKo+B2YcQp8m1QvGfQUQc2ucTyjk/BvcwzYteQARzAJHScSmGPR87cNQPdP9I
	 gxJDZVc0VLxGg==
Date: Tue, 11 Feb 2025 19:36:09 -0800
Subject: [PATCH 21/34] preamble: fix missing _kill_fsstress
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173933094677.1758477.6193564184366662309.stgit@frogsfrogsfrogs>
In-Reply-To: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Commit 8973af00ec212f added a _kill_fsstress to the standard _cleanup
function.  However, if something breaks during test program
initialization before it gets to sourcing common/rc, then you get
failures that look like this:

 --- /tmp/fstests/tests/generic/556.out  2024-09-25 12:09:52.938797554 -0700
 +++ /var/tmp/fstests/generic/556.out.bad        2025-01-04 22:34:01.268327003 -0800
 @@ -1,16 +1,3 @@
  QA output created by 556
 -SCRATCH_MNT/basic Casefold
 -SCRATCH_MNT/basic
 -SCRATCH_MNT/casefold_flag_removal Casefold
 -SCRATCH_MNT/casefold_flag_removal Casefold
 -SCRATCH_MNT/flag_inheritance/d1/d2/d3 Casefold
 -SCRATCH_MNT/symlink/ind1/TARGET
 -mv: 'SCRATCH_MNT/rename/rename' and 'SCRATCH_MNT/rename/RENAME' are the same file
 -# file: SCRATCH_MNT/xattrs/x
 -user.foo="bar"
 -
 -# file: SCRATCH_MNT/xattrs/x/f1
 -user.foo="bar"
 -
 -touch: 'SCRATCH_MNT/strict/corac'$'\314\247\303': Invalid argument
 -touch: 'SCRATCH_MNT/strict/cora'$'\303\247\303': Invalid argument
 +./tests/generic/556: 108: common/config: Syntax error: "&" unexpected
 +./tests/generic/556: 10: _kill_fsstress: not found

It's that last line that's unnecessary.  Fix this by checking for the
presence of a _kill_fsstress before invoking it.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 common/preamble |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/preamble b/common/preamble
index 78e45d522f482c..0c9ee2e0377dd5 100644
--- a/common/preamble
+++ b/common/preamble
@@ -7,7 +7,7 @@
 # Standard cleanup function.  Individual tests can override this.
 _cleanup()
 {
-	_kill_fsstress
+	command -v _kill_fsstress &>/dev/null && _kill_fsstress
 	cd /
 	rm -r -f $tmp.*
 }

