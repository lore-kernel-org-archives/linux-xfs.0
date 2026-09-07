Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A055B3AE188;
	Mon,  7 Sep 2026 06:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762534; cv=none; b=nVs2SDH/NfXFaDq41Z2bj0qtcYThcDPbnCUQn4mk9mxG0iqfwxDFfAaUzFig+C7cbbshusdWzPy8gc7yx9pJjNkCGsyKldB/7RALuWIRBcj0pvafvyjMxa7G1D6xB0ybUsperd65yI4E8YbemjBgFDC3xDjy2AxHkqlmvpRRa9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762534; c=relaxed/simple;
	bh=f1hcbE9a2jxxSIFs58bjmaW08hGawaRxjJkzy/Ooc1o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=i5qJLmwDH///wamUiYLDZLQnmm5VuC5vnS4RDn9n7Dt1a6XVth571oWL3IfE9b1OoHeDJwo/2mUIDBWAH2b+MDZiJc104Ly4QMoARDehYFLcsvWCyNY4u7za7yE0TFmazedi3X7+Sqi43M4NkMTUNG12lts3SqC9hYb/WLiexGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vu9TQ97Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vu9TQ97Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611B91F00A3A;
	Mon,  7 Sep 2026 06:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762528;
	bh=3jvQKu1SSzuIVmZXYe2UHlCg4tCc9smIPH2Z9kYWzEE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Vu9TQ97QxZM3y8D3oX0TELnjf4jJga2Qx+fcIo6rYG/Tsfv7bpCYzcvFLQbigVkmT
	 byKFCPxkKUkU/Lh15vpWXD1/9oWLoXCFmmwCREi9vC6wJh4cRsKC7rEBo3r9rHcZUj
	 V9AsGFKF/Ya4Uk8P3ubfkP0EQO9RvYljvJDi+hnq2WpdKttGwfc4/xGTeaDMX00slR
	 kA7PDluqdll2JUw6OZhiF/ccgpIDW3FAz5JpY5OpSKSlU0vZDh5N/11So6/bApQiL7
	 1u+i9yvPotRQ20HFl4PPEUCKv9W9TiZHTr0RQcgTM/NPEQXyne+qySTrQHDu7rRbMW
	 y2sVH7xo+lXIQ==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <20260904161302.GC1933798@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
 <20260904161302.GC1933798@frogsfrogsfrogs>
Subject: Re: [PATCH v1.1 6/6] xfs: bail out on bitmap errors in
 xrep_agfl_fill
Message-Id: <178876252708.14075.469925625360656630.b4-ty@kernel.org>
Date: Mon, 07 Sep 2026 08:28:47 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Fri, 04 Sep 2026 09:13:02 -0700, Darrick J. Wong wrote:
> LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
> can fail, but we don't check the result of xagb_bitmap_walk, so we
> silently drop the error and proceed with inconsistent incore data.
> That shouldn't be allowed.
> 
> --
> 
> [...]

Applied to for-next, thanks!

[6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
      (no commit info)

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

