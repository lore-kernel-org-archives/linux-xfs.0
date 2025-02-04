Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D6825A62C;
	Tue,  4 Feb 2025 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704468; cv=none; b=k2exyDV0sBhNE6WxuoUT6mSzDk/1keGpXRPg/zLcsbXyz+0ZX2JJusp1TYbAfS4C8rKQY7RMVfLtuXTwdpnEAeN6PdmclJzxMAGXYqS8UVlamzT7Ip7+zCp5v+78nnvlRU5iZAmUpmv/CNoP17h+dJ/mElbAn20OE1Aph601xlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704468; c=relaxed/simple;
	bh=mq3sMa07Noxd8Z3iThwHHbLVrhD5GaJ7XMiK/0+IeUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YF6txtEW8cf6LqY5AIzLyAijIQTZUfGwZkSihrOd8VM7X1XhqWVy/AYRKrUdZ5npqGojd8Rdf2op8PqLHBIQkCHu5EZV65gfKqxV0qZRAwxpsYLRNYY/vmuej4WnzzkjNoWJvvqblf4u8skFGOLW4BQrwNpFhZ1RUl7gkaWu71s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkwE1fks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkwE1fks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE6EC4CEDF;
	Tue,  4 Feb 2025 21:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704467;
	bh=mq3sMa07Noxd8Z3iThwHHbLVrhD5GaJ7XMiK/0+IeUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OkwE1fkscgFc57K1peIMxKjlH6//4VDIYqLTX63ggpBTqOJ0nk3tHvtbkVJHi8ObN
	 sruXket3L7j6T4wogfoQSI+m9YIM+p7LXtTPBqdj885HSKv8b2zoJ8qVVAZvJqXxNO
	 DhKj+rV7jWmSb7oSMFqHhL4Tk+/vEjN7+ZbfxiFy18J/Wu+nF0NkyLZmTeRwGl8Ikh
	 9R5OQcJkhuPzqqQAlse08V9niPteii91aAvxl5xoGse/MpAHOjgFk+z3i5bKmWhvcI
	 DMa5PUuhHL3Pnq6PjgFGFsOe4y3tvL71xw2EM4Oc2hiC0kA8KN7iWREX61h1CnLnB9
	 ug2RfJDNfa7Dg==
Date: Tue, 04 Feb 2025 13:27:47 -0800
Subject: [PATCH 21/34] preamble: fix missing _kill_fsstress
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406426.546134.16007107332827987550.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
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

