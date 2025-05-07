Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630BA230272;
	Wed,  7 May 2025 21:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746654864; cv=none; b=LnDq++tplUrX8Bpe6ube+XQZqUD4E6ekrIC+xFqV/YzQGU+qjPyCt7sDv8beM4LlLzkJWx8bcjhObx2jULeZFKiHmxpxJNqz9AVARW77uywDCekbRwMEsrhVlnlcFgd8KTEieP9iI70J16JMCUmmz2QotAg8Fyg9itZVq5k/AIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746654864; c=relaxed/simple;
	bh=5sE2l/4MbXmsGI0lx5ensgoQf778s1MpFnfEndtg3ek=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVLY2Y9C7S+bkRH77e1q5zjASG5TveP7dTLuXWdFrIZ1Dn9nvX9bRWgIywYO7qrPlKQ8kfAXaKXnKPYZkSsfDJu8jfnzYPrLsMgk0hqBhoHj4K8zwc6gdjTtPdvweFjjj8YUjW+ajwYEakAzMWlHZ5uDO6vUCjNvsQR9JvDwUk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KEBZ/d2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KEBZ/d2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB68C4CEE2;
	Wed,  7 May 2025 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746654863;
	bh=5sE2l/4MbXmsGI0lx5ensgoQf778s1MpFnfEndtg3ek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KEBZ/d2ufP3dyGZzGF9Wcb7dt4e/Vl1eGOhv5cKNVwTulRqJ6YUvF9Il/OM4LVh7D
	 lRglC5jCFMxS5B0ijwS9uOn6PA7N2fD25GHF9lm4F8I/89ZXnpZSsanOJ50zUkonbo
	 pG60l2AChYj1+loeGIcVlLHl5+WwP4OordvijVp4MROQk7SkQLDAKQDq34IV7J5OaB
	 /+2Tjvn1VDvFNEpyQZHKmfI4Bb/Nau9ClJvB/Jc3iXPEnjf5QGW0Xe/KsGELHdghgH
	 5h/hjDsCW/EmtVD1f4F3Ma/4bQ+e6Ik5K9xQUYh5oL4qQNmruKBdoC6Up6i1qzAko8
	 11Jijizl2i/QQ==
Date: Wed, 07 May 2025 14:54:23 -0700
Subject: [PATCH 2/2] xfs/349: don't run on kernels that don't support scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <174665480844.2706436.14436465458967400507.stgit@frogsfrogsfrogs>
In-Reply-To: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
References: <174665480800.2706436.6161696852401894870.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't run this scrub test if the kernel doesn't support scrub.

Fixes: f5f0c11a67a8f5 ("xfs: fuzz every field of every structure")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/349 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/349 b/tests/xfs/349
index a68bfee579ac41..a03ab812dc9ec6 100755
--- a/tests/xfs/349
+++ b/tests/xfs/349
@@ -16,9 +16,9 @@ _register_cleanup "_cleanup" BUS
 . ./common/populate
 . ./common/fuzzy
 
-
 _require_scratch
 _require_scrub
+_require_xfs_stress_scrub
 _require_populate_commands
 
 echo "Format and populate"

