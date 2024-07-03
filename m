Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136AF1822F8
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 21:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720043278; cv=none; b=jNU/CjrWT3vWymaq3QDGCwXmTD3vylN63SdHKztCMV3Hppsy7a9dksPQe4gpd9bjHx10mAJ8oAK3hmbiZ/JrCrRTD2VmS//uFqrO58pFsdGp/RYfBg9rMUf6D1jI/NgJMtPfnWfMGNTMhuarQoRdpwn6jP6caq7+k1LlvY/5WzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720043278; c=relaxed/simple;
	bh=I2dop7/ryR51VbZf6FCb11xJ9P8cVtzGQcpPxT2H3FE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p9ceQjjL9fcvYaY/W/bkZVrS1mZdMlF5DRKIIHVgQG2zTa5+Wki/T+Fej7xg7qSSIJOSeabHszM82JrKsmqiCwzdizfHLH2f+lZl/CxZcoc3rZGD2LjzxSRodRO/0Mo7B5RrTsOtz+MQgS+HqvjzLl99N1yKhowCW4GfwEyfm8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0/cjP0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0/cjP0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB01C2BD10;
	Wed,  3 Jul 2024 21:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720043277;
	bh=I2dop7/ryR51VbZf6FCb11xJ9P8cVtzGQcpPxT2H3FE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N0/cjP0ZH9E0Z9VEuM2KZDr284NNKcHgy17fiy2ipfeAif3Uc80B5OmqkJO3FijrX
	 sHXrkfPDtmjiaDZ2ZkUc7zXK2uMV+24PGZ3R1dmi2mnBn4fiZn4HMr1E98Wobhk5LY
	 V1Gz32jCwb2LksoM/PhAS6Sn6VMiV9vmMN/Q8bV23lfS9E9UTdEH7u3qGlgdUt1sx1
	 uGoWDIBKQhmRgqT2uvL+h+01qHuANSn23qg5ElBSu2nhfhlFtAVrxnUE1s7mqZC7gV
	 p38f1wVARSRTI9D++ixkn0cgDfbZQNUHJZT6QBb+IM7uOugVXvfhItZo1HbJf7nEr9
	 1WqEFRfDljZPw==
Date: Wed, 03 Jul 2024 14:47:57 -0700
Subject: [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
 bar
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172004320065.3392477.4411028502281535259.stgit@frogsfrogsfrogs>
In-Reply-To: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
References: <172004320006.3392477.3715065852637381644.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're tearing down the progress bar file stream, check that it's
not an alias of stdout before closing it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index edf58d07bde2..adf9d13e5090 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -878,7 +878,7 @@ main(
 	if (ctx.runtime_errors)
 		ret |= SCRUB_RET_OPERROR;
 	phase_end(&all_pi, 0);
-	if (progress_fp)
+	if (progress_fp && fileno(progress_fp) != 1)
 		fclose(progress_fp);
 out_unicrash:
 	unicrash_unload();

