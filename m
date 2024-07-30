Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C4633C8
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301924; cv=none; b=mV9MmjmIhRXRCjIjHcMEQsmYMdTuMH/EzPdK4rDlbY0GDGPHB6Vc/g1nxCcM940NVhnnfocvbnxcb6Kap97XfDSUI5/SdG0CYGdAqSa7TixWiJa2RlDD0hkep2mPAi48JGzdLB9mf16ux5rNQTlmUGgDotLZ9GYZHvZoTSUIRw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301924; c=relaxed/simple;
	bh=lJMYY0Ee1/TMlpaD42cPRi4zx0yFLpf/Yf5kdbVfJZ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVC57LX8fz6+uGDe8glBJNiPIW0py88XZqWOuwWcZCzdQh8Poe3Fvfq9YlVnFx0CrCc8iqPs84neP9N8YTbzqy/YCRcFqLOE6X79FpLEb6YGl/zdlVCma6focbXOMcRjvqPUHttEEN/xaNFr+dE8bWsY82lOVWRHNSCULgeEjdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QiLqm/iL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QiLqm/iL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E520C32786;
	Tue, 30 Jul 2024 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301924;
	bh=lJMYY0Ee1/TMlpaD42cPRi4zx0yFLpf/Yf5kdbVfJZ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QiLqm/iLK741oPj2sYDzIeeooe+fuA38gTSYHyM/0FqIFS4hWLY6vQHRGlkBt5Luf
	 x5P4KOE0gDtvGWWa+PbK2GkF6ma9rOumCSYj6L2orijKGICXuSdh75YYMArhJquGcW
	 CA/JcbAVvAY48CN7/Eo4EnDsTh6zobycjVBcbiWqa7oWzcCC1vjxKZjDVrt9ozFg5N
	 ZIaCbKyznyllsnx1+kwp7O7Jl2B1mA2IHfSPUMMtpLLci4Zoibr6+jk87byMFLy3Gw
	 IfHcqENYnxkIkQmToNu2jp4KCSQyATJohDL9hQO51ouiVcuVGdQ3FUABS5s+9RecMj
	 ctmvt4PXFJx8Q==
Date: Mon, 29 Jul 2024 18:12:03 -0700
Subject: [PATCH 4/7] xfs_scrub: don't close stdout when closing the progress
 bar
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229848507.1349623.8852952476556545533.stgit@frogsfrogsfrogs>
In-Reply-To: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
References: <172229848439.1349623.8570132525895775451.stgit@frogsfrogsfrogs>
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
index edf58d07b..adf9d13e5 100644
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

