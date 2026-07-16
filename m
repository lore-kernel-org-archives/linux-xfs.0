Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9777A30C14A;
	Thu, 16 Jul 2026 06:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182015; cv=none; b=VmlDdpCP9CkqZnRT75S80WxV0+b1hwU+J5Toa9O/+sN7XFYxKkDVEepm4EiDSR8x72fUro+sItBD5SEHuci9p+l+NJmzQJfSIN/Pv8oXNajjttSkPcdydJDz3RSxYW1o5thuY/Qkjt4XDEIOAnLeqK/L5h+V4XM4H01fHRRm9mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182015; c=relaxed/simple;
	bh=hJBd36xA96S3LkddiAi8X8zfjEfC+HV7/A+IvdGuz1c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdccQzIC82jz3Rhd4rHRWL2vomraW244QoggsldmuNrM3oEO+ZgkYpF6UI8OLHfduv4nvi/4liL80zcJZfExrLNdXVDlFmn0zkhEJcr7i4BSEO6EEX1M5w9d6ry/8sagU//4q5GwuiVoAeOkWtmJ5bpuN0c+XAlsUoIE8X7hnuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gPYK7xwJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gPYK7xwJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 41E411F000E9;
	Thu, 16 Jul 2026 06:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784182014;
	bh=tg7A15mVWbQKdVrybtp71DQ/EPeIPW4DevXVcp4INu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gPYK7xwJLUnHk48Uf10iDhTtfrt6JPuJeG3/2TANG84nnaMc+lVk6iDJMivLR6bi8
	 OSY1VmcdaHRyhEnFxWw/nstOAQ5Gev4VyMSeqOsm+qFiL+BSU/0JPXoeScsO3hqlxH
	 JCIjVEeH15PyPvFf4kpXp4CPYwCZodvRaeHti4Iy7CHrqId/qQ1RAmJ9bji4NW+EQ0
	 ygo2orqkJDm46rMfr1oSjWQp10OtS6P42KuZqOEGXnDT1cjq4bGXC6luhvjUSF0nPM
	 MRgNmsjualw1Yvub+rtFabh8qikecOCJf5tWoTc6bgUax4HAnjsGbcn74HzKYisUFi
	 LtxwsWGLuiIkQ==
Date: Wed, 15 Jul 2026 23:06:53 -0700
Subject: [PATCH 3/6] xfs: rtsummary scrub should treat rtbitmap corruption
 errors as an xref error
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178416797424.2008054.49983972584839221.stgit@frogsfrogsfrogs>
In-Reply-To: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notes the discrepancy between the comment saying that this is an
xref error and the code, which marks a (non-xref) corruption error.
This appears to be a regression.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/rtsummary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 78f72a0468870e..546b335ade1354 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -358,7 +358,7 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ip_set_corrupt(sc, rbmip);
+		xchk_ip_xref_set_corrupt(sc, rbmip);
 		return 0;
 	}
 	if (error)

