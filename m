Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296602C0F76;
	Wed, 21 Jan 2026 01:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768958782; cv=none; b=jO03Lj0pUEEXQ/1CDFP+r9n3kG8IB1sxaOQwusj57f6e1vmkauaqGW7420d9PbQ9BiEbHhYUWaEfqH5JvvwiZppyzyqkNlPB7KsXPK+CNT0dyCUG/IuI2gg/x+eIFE1fk8vM95GUnjhQMjS9+ZyiZXsUw0fRI+LHI+sf5hZbWzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768958782; c=relaxed/simple;
	bh=vsZmHStQ3ai/8JmpEXJ4KpA3eXZ8n0WGtskndB4o0qc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b8mdVj7mG/S8pi6D984C2/gQiWq863xcwkOJUXxDGIpUYofSFw0ptxiA+VxxBMG9RTjSReOnsNm4C6jfeKMVwXfuem5PgrispESIkvWN/G2ycrKTpth8dbNt62NEN4KN6jMxhuJLBIU5kEl6ZCtjzfYnBLkIH5s+9ymqUDXUlFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+Ygf8KR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+Ygf8KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929CAC16AAE;
	Wed, 21 Jan 2026 01:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768958781;
	bh=vsZmHStQ3ai/8JmpEXJ4KpA3eXZ8n0WGtskndB4o0qc=;
	h=Date:From:To:Cc:Subject:From;
	b=Z+Ygf8KRvRIEJy2il7IOoYUyEZB4mkWCuO1cbzLaSNSjAcBiTUprZG09njj7Zz0HX
	 i6jw9lv9OVBte3mI572Egg+jnP/Sk4EHLON2DnzL8bHil2IrCWOeqbG38dVU64JbZ7
	 qciUNMGiDwZUbsWZLsvhm1MUIqZwx3MEyqdcIW7JkbcakJQvBxFho4fuWos8AX2dmK
	 y7+0r2rPsXNCdZcISOqp9h7ysVr0ROJ8Pz/0Ip3aNB6geDb/957Qqp0VFOB/UbVsKF
	 5cvMbDqA/6o4qcipZXv8VDVLMoqnAtzWpSuhL4r3b7MNm2u7lPYdpWml1OxMK4q8HX
	 jloZw2ACyL3Qg==
Date: Tue, 20 Jan 2026 17:26:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] misc: allow zero duration for fsstress and fsx
Message-ID: <20260121012621.GE15541@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Occasionally the common/fuzzy fuzz test helpers manage to time
something just right such that fsx or fsstress get invoked with a zero
second duration.  It's harmless to exit immediately without doing
anything, so allow this corner case.

Cc: <fstests@vger.kernel.org> # v2023.05.01
Fixes: 3e85dd4fe4236d ("misc: add duration for long soak tests")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 ltp/fsstress.c |    2 +-
 ltp/fsx.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index c17ac440414325..b51bd8ada2a3be 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -645,7 +645,7 @@ int main(int argc, char **argv)
 				exit(87);
 			}
 			duration = strtoll(optarg, NULL, 0);
-			if (duration < 1) {
+			if (duration < 0) {
 				fprintf(stderr, "%lld: invalid duration\n", duration);
 				exit(88);
 			}
diff --git a/ltp/fsx.c b/ltp/fsx.c
index 626976dd4f9f27..4f8a2d5ab1fc08 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -3375,7 +3375,7 @@ main(int argc, char **argv)
 				exit(87);
 			}
 			duration = strtoll(optarg, NULL, 0);
-			if (duration < 1) {
+			if (duration < 0) {
 				fprintf(stderr, "%lld: invalid duration\n", duration);
 				exit(88);
 			}
