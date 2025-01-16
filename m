Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E366158520;
	Thu, 16 Jan 2025 23:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737070115; cv=none; b=Utw25cBXrKC5E1CpMy+9+aQpTv40B2bzHkc6aB4q11BPiZh0eAJjysPRNO59mXCwZdLAozuTllWt7xyLsAP05gVO7MqwJsCn6q8QxGN1O5MBKzhGSZhcGqVmcOmqu73KImrr8cICqpEAAKXr34jH+eUshF7Co69PwApUPYs6bLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737070115; c=relaxed/simple;
	bh=Xbmso0VYrBw0g9dqlVTyOuZX6fvejTrIpqlmeccAthc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KeoLISKvrssW7cQSVz8etH8hbE5+YNgTpt53njEyluBdrmZANmCMwoDDQLDmW/YrhHkPyKFeAGXAQAN9XbiFPbz/efiG+wILPGNpK8Av4QTPovi4VyAyzVHHuFw8cRLNAgdn21RktdfjGE15y7r5p2fLlbvcWcHt7DT+44am5jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hb75bkep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hb75bkep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1394CC4CED6;
	Thu, 16 Jan 2025 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737070114;
	bh=Xbmso0VYrBw0g9dqlVTyOuZX6fvejTrIpqlmeccAthc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hb75bkepRL9hJFczK6tfjJ4C5gXloySQ2pWAXU/olu//73shiGOGGAxsQa4763hke
	 7XAoyd1mPCd9wjPJGvyP8ov7XTfWljWJz5vLfpeYiCMHYUo+vCjKTe8JM5AHVIHe73
	 9ffz4BseXt0jAxGBHfjpiOcr/xBUsoiLgMqAuBjxgtWH0jOm2vEoPjLf/xC8MUoo/E
	 bIy9NgJXIhq0q5F33xrAef5+NMamjEILv31QRQPDSNTTwEJzSRZf9Zq/qgtKFYqaR3
	 jPsYjzu5dLmRAJaAtZw64RsRaAxvfpkwqRfVtLjvCz7d8jXpahDYi38YRer72Cud/7
	 D+ZdqkZTNXFIg==
Date: Thu, 16 Jan 2025 15:28:33 -0800
Subject: [PATCH 13/23] generic/650: revert SOAK DURATION changes
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173706974273.1927324.11899201065662863518.stgit@frogsfrogsfrogs>
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

Prior to commit 8973af00ec21, in the absence of an explicit
SOAK_DURATION, this test would run 2500 fsstress operations each of ten
times through the loop body.  On the author's machines, this kept the
runtime to about 30s total.  Oddly, this was changed to 30s per loop
body with no specific justification in the middle of an fsstress process
management change.

On the author's machine, this explodes the runtime from ~30s to 420s.
Put things back the way they were.

Cc: <fstests@vger.kernel.org> # v2024.12.08
Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/650 |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)


diff --git a/tests/generic/650 b/tests/generic/650
index 60f86fdf518961..d376488f2fedeb 100755
--- a/tests/generic/650
+++ b/tests/generic/650
@@ -68,11 +68,8 @@ test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
 fsstress_args+=(-p $nr_cpus)
 if [ -n "$SOAK_DURATION" ]; then
 	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
-else
-	# run for 30s per iteration max
-	SOAK_DURATION=300
+	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
 fi
-fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
 
 nr_ops=$((2500 * TIME_FACTOR))
 fsstress_args+=(-n $nr_ops)

