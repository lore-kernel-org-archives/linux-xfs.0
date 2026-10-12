Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFF49B45D;
	Mon, 12 Oct 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818500; cv=none; b=DYVw64AGUAvBKnGhurJw6jMfEOb+ehN32SVnQk4uUUbrAy14+1bi9ipqiK3a14mkGPC+J50nMgsPbcszwA/Ui53+dia7aKwHU79q4h+udB74Yv+JNwX9yOFbrxUUEAR/u8tS8QC/UP9YY33Jdi1VZnAgPT0+nsQbJmDmYqnHqI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818500; c=relaxed/simple;
	bh=wVF/KkvOmn24aNuuvGCcx4rpdhhaARzE6Uvl9Dnip7s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuNy39bD509b8+40C6/QuKZib2iEiphX/P/NKjmbaeAqNGAHAIrU3yrXCVj0EB78ZIQLJqGfUH17q5YkDMGuRAmBcALsmr7W6CapGnpTVidTAHKZx3LtJ5CpgNBlnfXvaScaRra0XURg9KRrnbAV7KmICevjogP+ZltEyLHt8NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SN1WSX/R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SN1WSX/R"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E9E381F0089C;
	Mon, 12 Oct 2026 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818499;
	bh=IHPAe+EK3SR6m688M0HXlXDeX2DGa15tDj2sxHZuB/8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SN1WSX/RvRv/cR+Fh1JluJnG6dTuWEVYI78SpyU39uiN6X0RDgSTiuTw4Q2dw7uEV
	 tM34QFPYNP6C3TiJLThOxapzzDfBRIEG++oesk1/7/cfZ9Zx7XCykrtJpTJcKkjHF8
	 flA4/ULY66XkqiJhQbBCpsEs6xLG1SdDEWe/jYNY3WF3sYOHCDlDV3GueoClM9gVJC
	 jgIVBPX79Cje3lbmSG5cbD633JdlNM0UGt60BQd05SWXjpWALZEbI+IIbAkLx7rtMg
	 HY5RKh6hNEa2rhixxsJf5LsQkKm7qEIR3sSSKp7sy79t7GAtqGU6JVjcskaZtu9AI3
	 4Wwx9bQBV0Wog==
Date: Mon, 12 Oct 2026 08:21:38 -0700
Subject: [PATCH 05/13] xfs: never reset the default quota timer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839354.1417179.16275228766052568621.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that xrep_quota_fix_timer doesn't check the dquot id,
which means that it can inadvertently reset the default quota timer when
we really meant to ensure that a (non-root) quota overage timeout has a
sane timestamp.  Fix that.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota_repair.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index a37fcd3fb6629b..2b695e5b34177c 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -272,6 +272,9 @@ xrep_quota_fix_timer(
 	time64_t		new_timer;
 	uint32_t		t;
 
+	/* never reset the default quota timer */
+	if (ddq->d_id == 0)
+		return;
 	if (!soft || count <= soft || *timer != 0)
 		return;
 

