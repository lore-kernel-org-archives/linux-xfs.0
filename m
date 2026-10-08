Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FD038C2D0;
	Thu,  8 Oct 2026 05:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438970; cv=none; b=kHtGAthHMsnHoUS3ImnHqI8Z1NOYJr6mULSWNBRjtYOQ5JWh+/t1W4Ncptv26Dm+8JbO730KAEPGvvNloLfSNy+3WbUggIlCM7It2OvIY6ED9GyXibGrJBYnO1jyB4Nf9KC2xMpHUHgi+cn5T1iqptrqdcBOVUMP6hlDoQ9o6/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438970; c=relaxed/simple;
	bh=liWiFwrMzmwqHYVxepg7CsRsg4v3IkANBa9xcslB7QE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+2KJInInubEU1sTol+LJ43GwJK8D30dJB6CfNK9eeA0y0JNwnxhR//7qHxaKj32ComLcHADFhCI7rqiXgAhEds4KTgSXietfGV+kIVCt9uBh1L6dZcFwcolIqS5oAk5OQyCbJKso0CHk96smSFFBVvLN5Y0kdQ70IU14KBpoRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epAWmXrA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epAWmXrA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D53661F000FF;
	Thu,  8 Oct 2026 05:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438968;
	bh=Rrkf5NTUAH4/Zo8hZqk6HMItvL+PhHT1AGNwk6tqwaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=epAWmXrAt51RLB+yap0FPoUmQCzEocdagRhZcRcDKjUzMGPbd9Ukh2lxLFPtsJ+gX
	 fPbqDEMRf1wVQLW3JmO1vG2rnwjc5qXmmRKjTpYIiRIGFhNMEw+CfSxOGDBjALQNk0
	 X6QIlOX35dwaDAz5+ZN0ZT40hoo6UWcBCxdflnbIlBrdr9Wjzs0YmtkTwi8nT2Dl+5
	 5Yw5x+QJR79lcYQILGdXAJNQYTnF9/TAacATgFAzIXD2t0wbu8wU122MRUCHD9g2Y/
	 YMgLpX2sfXXkRxYeq/hsAHbnQqQMIBeHZUFlR3JLWuyKyqNZU/mz65dO2NrxAYSSWj
	 q/AlyBCVU9kzg==
Date: Wed, 07 Oct 2026 22:56:08 -0700
Subject: [PATCH 05/12] xfs: never reset the default quota timer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521363.2728617.14276632684472536968.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
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
 

