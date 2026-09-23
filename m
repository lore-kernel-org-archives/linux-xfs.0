Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA60390C8C;
	Wed, 23 Sep 2026 06:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143262; cv=none; b=pCK3cTAcBS+RJL5AoggmcfbrpGd4Nuc+6lwojMeHfO28DKin2lRisFTgpPiUqtzpYkUMwZgU4nPTkzeN/ksH39KvmPzLupjdCpswtFDAhzmZLcPX64AFq6QVDucc5MksuckEIqClf+C5LsVNyt8Oy42gx2iN+CLmoX7ESmKmHkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143262; c=relaxed/simple;
	bh=gZhCDgtClP6xjm9NVbJd9U5xzXiA2rNhf0hXuj4WFV0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJ2u7FasD/3p/aSZrzh7vw8ul8R+EsPj96KZ2TUCE04E3YqU7qKOA5oBMq5RfKsscJofV59Keb4LO6QwOF8/URrXK14zqG2OXMSjPp2IGCQSAlNKWIA6LLNsl3pbu1OJf9seaDxk7+I1WXgK0yHAvi+kDEoezI8l8np6IDZFkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsaWv2Xb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsaWv2Xb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D9A9C1F00893;
	Wed, 23 Sep 2026 06:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143260;
	bh=WEc4XdOwHZRZA+WBChU0HMikYyOP+lv4qNGdGV+pJwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=CsaWv2XbXhgMB8ZC4Q82tes23QVrwQiEUwx8zFYqZcro0Ff4XTeCqNKxWVK4zyAkE
	 gjK5OBNZvCQE5+Z1DhSMMzqpdIMdNa0Eyss5GYMSLgOMnMNBUoQ2jQYDlk68bqm1NH
	 yk+dfgdZBW1za4N7eWazqouhFWZLAuG4gMAAGPO99qjptrxrC1+OBpvK8mq/sAW/em
	 rLo9TOx62h5VoDRVcMTYDeo7Usz1W59wtr7Jcq9FwGWiCzyznIrEdM9QFWcqlLa90f
	 iW9dgUarSzAfwUsEFdJ8adhYh5RIOkryY87LJkrv8oQdkZTE/58zqYkcAtby1Li9i9
	 pHWxZHI1tx4gQ==
Date: Tue, 22 Sep 2026 23:01:00 -0700
Subject: [PATCH 01/12] xfs: compute the correct fdblocks/frextents for repair
 when they're negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014159565.1875436.6766402511927424553.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM observed that if either fdblocks or frextents are negative, we'll
set the CORRUPT flag and exit immediately.  This doesn't work for a
repair because we still have to walk the filesystem metadata to compute
the correct summary counters so that we can install the new values.
Currently we just write zeroes into the summary counters, which isn't
right.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 4ed080cd7cb077 ("xfs: repair summary counters")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/fscounters.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 916699f3da7b1f..cd96393a9e6fcf 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -541,7 +541,10 @@ xchk_fscounters(
 			return -EDEADLOCK;
 
 		xchk_set_corrupt(sc);
-		return 0;
+
+		/* Need to compute all the fields in fsc for a repair */
+		if (!xchk_could_repair(sc))
+			return 0;
 	}
 
 	/* See if icount is obviously wrong. */

