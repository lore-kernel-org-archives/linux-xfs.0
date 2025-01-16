Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD84A158520;
	Thu, 16 Jan 2025 23:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070098; cv=none; b=NCti7dZnwXchHG3VPf7UJCQMzzD6oCPtoW4QGCOm9I+FOpgBs1tJan1u44m1IDKVq4fLSOwHHZU+VPo4ZbxJwmaD+2IUqASeH34Nff2lSbJVu2C9jNDQnPD52Fh48RxytwkbEjx9SSP6iOi7eUXfUft90grD8QgPRoVcwn7rSk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070098; c=relaxed/simple;
	bh=Wl5xP6xhB0gBa5dsBogm+FnTOOsgy8OUUTBBbUunl4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TtVOVC9RsdDqQTzj/DvkmI90c3JezN7sOlpa7Cdekrn0AtFySgwJv1fS4/MPZ8SMxbu9Ph3Go79Og6BYgDd+yx6NBSKV47T5Fjv1MoOn3BsJ4/m2LsAaTgEf4VROHZcbH8IL0ut0/YusfYkLW3NZ7bxTZgrM4pX3YNgzz/jPjic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKKZJ048; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKKZJ048"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7772DC4CED6;
	Thu, 16 Jan 2025 23:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070098;
	bh=Wl5xP6xhB0gBa5dsBogm+FnTOOsgy8OUUTBBbUunl4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GKKZJ048gMhKlvbcP7wb6a2ddRvL9RarX3Tlq9lssLkmaaQKSH+3UMG2gmXCJNfjJ
	 lFg9U3PN7kfj0y2zT2NkUs0DQhc2fIyHGoSWP1xiiAG1JxwETkosvFpRcVaSdlB49/
	 OQn1MwKCsWaiTK36l4RCKTxGEd5mbcfLaYL1k0Htgnjsq1EIhvQTqtf7toAQ+baqhj
	 VQiGlZAgQ01YzZSGG3D9k1bpDKMPrVX9kB+UtfPzAsML8sT73nnekCNQp0bxUBG0x4
	 aICMdxp7lQdopwEq/ywy5lvwa/rNTMymaCBOuMa+BvgCDYHvVlR4zGU+nny9Y+f/K0
	 181NYd0RYowZA==
Date: Thu, 16 Jan 2025 15:28:18 -0800
Subject: [PATCH 12/23] preamble: fix missing _kill_fsstress
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974258.1927324.7737993478703584623.stgit@frogsfrogsfrogs>
In-Reply-To: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
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

