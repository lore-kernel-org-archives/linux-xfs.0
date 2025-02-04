Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CFB25A62C;
	Tue,  4 Feb 2025 21:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738704248; cv=none; b=PwL+X/luSxOuCrSOlokeciX2u28UKgru0jnykJu0tC4LsUUA+VAPqOnckAIyoq3kxXTsXQ5L5e6+eYjMGpPQaNryZAySQk0j94NhqhTKX1/336OYOGkoWcPy14K1M0k4qQHtALScKJNWJxCwc59/FjrpoKpwps5GClAptT+vX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738704248; c=relaxed/simple;
	bh=U/jyyv06WLvJmnFiBAWiu2U0Pb74Gro9PTw8xbHKoE0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iis9RO/BxerRMjlTHNZyOfUAqy9F8aJbLwgvytDFUwA0YRZGMSJV5raNPiqXGsAC2uLvcEb6IX7QjoiEAxzwYeH6io/RHSo9s3eWhfPTSxnYqXZ2eYeYtnbpILnx9ZZQ9v44DIl41b4aJVvM5rNrHNzqDXH+AfcrXvI8RBd5C1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a9A0Mw07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9A0Mw07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FFAC4CEDF;
	Tue,  4 Feb 2025 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738704247;
	bh=U/jyyv06WLvJmnFiBAWiu2U0Pb74Gro9PTw8xbHKoE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a9A0Mw0745PXZJQcSna4r5s/P9qCf/zXgc2nV9oJgEESwYcQ9Bk6Mr+4fg7wIHByz
	 bPt8Z+plUOtm7qwPXHPhcTBltBAMQVQYdhqTY2vTGX9KmUrNLE8lMeH5zpwDKRZJma
	 Hqe+xYugmlFE6Cxh3xH8Hzf8437FezMpBNv8WkIH24nZr7jOT/Xri8/VyZy36+98ZZ
	 tn/SCSXyLj/Q64qToqmi+CI8QpRIqhmXRC8UR2aYDw17LvkUtJE9qTMCwY/bLe/F5p
	 hOrW/2G5QQooja3V5n86ImvSLN31nbRPRo9ud+oQF1Q+qe11iaM2BftiShidbFVHDQ
	 mpkQ6uoYEWyqQ==
Date: Tue, 04 Feb 2025 13:24:07 -0800
Subject: [PATCH 07/34] common/dump: don't replace pids arbitrarily
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173870406214.546134.16846124942782280576.stgit@frogsfrogsfrogs>
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

In the next patch we'll run tests in a pid namespace, which means that
the test process will have a very low pid.  This low pid situation
causes problems with the dump tests because they unconditionally replace
it with the word "PID", which causes unnecessary test failures.

Initially I was going to fix it by bracketing the regexp with a
whitespace/punctuation/eol/sol detector, but then I decided to remove it
see how many sheep came barreling through.  None did, so I removed it
entirely.  The commit adding it (linked below) was not insightful at
all.

Fixes: 19beb54c96e363 ("Extra filtering as part of IRIX/Linux xfstests reconciliation for dump.")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 common/dump |    1 -
 1 file changed, 1 deletion(-)


diff --git a/common/dump b/common/dump
index 3761c16100d808..6dcd6250c33147 100644
--- a/common/dump
+++ b/common/dump
@@ -907,7 +907,6 @@ _dir_filter()
     -e "s#$SCRATCH_MNT#SCRATCH_MNT#g"       \
     -e "s#$dump_sdir#DUMP_SUBDIR#g"   \
     -e "s#$restore_sdir#RESTORE_SUBDIR#g" \
-    -e "s#$$#PID#g" \
     -e "/Only in SCRATCH_MNT: .use_space/d" \
     -e "s#$RESULT_DIR/##g" \
 

