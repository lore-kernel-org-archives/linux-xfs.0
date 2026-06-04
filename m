Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26A5385D77
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553357; cv=none; b=IrSbGGSXOuV2nHOh5CHnr0RU3mcKvxJFj2o5G6n6HA9eHLfH9i6uRJ59yiI9heD6aBZdwvRfpnbERKzMPPk70DM9GYFXhMHGGSIhi19O6H5qfDOFFeakl4ozs/DrK5PsM79gVk3IZTUNj6pQvJM86jQ4cb5HcLI/4LWSKfD6hkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553357; c=relaxed/simple;
	bh=sXduQpgE1GXES8htGn9O9YMC4m5589u4Rb05BftNEMU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIF3Ur3x0vVCqgMkAIU61EglqvGh3F6ltSRbBsmjWua8uP1zzfrZSS0UMSZvCBpSKm9xIrqpw01LC+vCp6izugaTHg/hjduAA3au7Lb+xSYpAz6U2xMZ+mJMGlYcDQD0utEYGzLCmwXd2CZlEq2mQSBVT8KoAdUYvP9OhaxYtNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQXbTnmU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQXbTnmU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BFA91F00893;
	Thu,  4 Jun 2026 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553356;
	bh=g9TbfWqGT79eXWcZKibm/7+36qYd7o8JiVku/XVjJ8I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VQXbTnmUOLyLkU1PWOkKGAbbsYo9A+ViPRVDxF2QPymbn2SX4k+Uq9HFd+kHZqpqs
	 k2Uw0bl7jwRPypLTFGw+Qkp8NoLmHm3DR5XBM/uUCQg7HydVuRe8LuxTCa84OE2D2P
	 u3JuMECjyJ6YQy9iUsL0CvnJEC6+Gw96rIm5nG8KalQlY5eH/ezVNetXmKejA5IUCb
	 PKR/UWIcXDZk+f4oKmml2zU6vB9v7xIuk+8v38GHKxU0RnY+FI6nursa+vTVQqPMlQ
	 H5ReM0btxgQIM2G9DzqN+2n0KPilA6CawHhK3n2xnZDOcf3rv4i38DRH4+R0KvKPtx
	 Gxr3LLnpEerEw==
Date: Wed, 03 Jun 2026 23:09:16 -0700
Subject: [PATCH 19/21] xfs_scrub: don't obscure repair failures in
 repair_list_schedule
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303457.2608728.14097578913048293124.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that if we bail out of the loop in repair_everything
due to an operational error, the workqueue cleanup blows away the error
code and we return as if nothing went wrong.  Let's fix that so that
operational errors cause the program to exit with failure.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: 71296cf87ff589 ("libfrog: split workqueue destroy functions")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase4.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)


diff --git a/scrub/phase4.c b/scrub/phase4.c
index 88cb53aeac9076..6bd16c23939eb4 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -181,7 +181,7 @@ repair_everything(
 {
 	struct workqueue		wq;
 	int				fixed_anything;
-	int				ret;
+	int				ret, ret2;
 
 	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
@@ -211,9 +211,12 @@ repair_everything(
 			fixed_anything++;
 	} while (fixed_anything > 0);
 
-	ret = -workqueue_terminate(&wq);
-	if (ret)
-		str_liberror(ctx, ret, _("finishing repair work"));
+	ret2 = -workqueue_terminate(&wq);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("finishing repair work"));
+		if (ret >= 0)
+			ret = ret2;
+	}
 	workqueue_destroy(&wq);
 
 	if (ret < 0)

