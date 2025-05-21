Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D371239581;
	Wed, 21 May 2025 22:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747867359; cv=none; b=YQFDIYQVZmpmJan/Jv/BrLFu32HnHpLd++yu+E9zL0rR2OzSdIoRg1zPxDFY/8ABIllQ4ukACn43swgcMWETRxQqTr/rF47MlJG38h1OzaBffmgFqGbFzhhzZC3rfdI2xPt267IZen65huts8b4yZrwpRxj6tbpSg45WDru6qWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747867359; c=relaxed/simple;
	bh=UcyUTSaH05Maz8zhD1rkr/dIOFGAgdbXLlyNOb+OBGQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MP9WllOZUXcG5pr9NQGSGWk+YjQrUzN6vax6rlRM4A9GQi3HPMIskIAwKbc3Yf67jnQ5NKK+MxF/PVFqrcpuEHI7ssQSEnbmoHlTibSpuV8fyUEjhnLlACdjqQwRNwVHKxPLsuZ5g2gNEE5LzqThsZZK15QqghsAjfoUGhZpss8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhsGy0kT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhsGy0kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2FAC4CEE4;
	Wed, 21 May 2025 22:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747867359;
	bh=UcyUTSaH05Maz8zhD1rkr/dIOFGAgdbXLlyNOb+OBGQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NhsGy0kTkUvK4ukemjSTj6ZmrueDql2ZUMyiej6wMpqMxZO0Q3BdtcwU6IzMZpz14
	 tTQWwcQu7g3AHNKZQJli2VJicf5mi9RASzcU0eDJlcfWHK6U2xXuBh+31cr564ACfk
	 74PxDUmAiCKL8uGq+iBjWrRSPVBmrW96Mt/fKnHLo6GJJleJQMLgn+G7iLbzWgIN+n
	 Zk4nGrrpYkURzcTniKfRgDgSb1M0yd8IYEmHETHQHlIKJdeq3yaU8K4KbBWnuF8D8k
	 /pOTRkuKKr8KR6/h+cSa0eryW2UxS2zCdDRX8eZh563v3R2hb9rUVR8bxfGAthBH8e
	 j+nfMGaXQwN/g==
Date: Wed, 21 May 2025 15:42:38 -0700
Subject: [PATCH 3/4] check: unbreak iam
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <174786719750.1398933.11433643731439553632.stgit@frogsfrogsfrogs>
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

I don't know why this change was made:

iam=check

to

iam=check.$$

The only users of this variable are:

check:36:iam=check
check:52:rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.report.* $tmp.arglist
common/btrfs:216:               if [ "$iam" != "check" ]; then
common/overlay:407:             if [ "$iam" != "check" ]; then
common/rc:3565: if [ "$iam" != "check" ]; then
common/xfs:1021:                if [ "$iam" != "check" ]; then
new:9:iam=new

None of them were ported to notice the pid.  Consequently,
_check_generic_filesystem (aka _check_test_fs on an ext4 filesystem)
failing will cause ./check to exit the entire test suite when the test
filesystem is corrupt.  That's not what we wanted, particularly since
Leah added a patch to repair the test filesystem between tests.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: fa0e9712283f0b ("fstests: check-parallel")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 check |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/check b/check
index ede54f6987bcc3..826641268f8b52 100755
--- a/check
+++ b/check
@@ -33,7 +33,7 @@ exclude_tests=()
 _err_msg=""
 
 # start the initialisation work now
-iam=check.$$
+iam=check
 
 # mkfs.xfs uses the presence of both of these variables to enable formerly
 # supported tiny filesystem configurations that fstests use for fuzz testing

