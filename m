Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF00337F8C7
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788434469; cv=none; b=hKRKwoSANN1l2/1AqwPrFl8gzLB/ukoP3t56oqpI+49IO7AvPR1Ldy5y0AUu0D13HCcT/7zNxVm32Dvrk/OwRdixwK7RIewyHxJ/S3KlEowzqzKelxtMmKSwqkIn68YVzaAujEZwsvl3YGeEnhvoSJyshBykkmjNLxwfRq7pw9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788434469; c=relaxed/simple;
	bh=3uMPcz8dE8W1/1C1FxoC2usDThP0/YVFh1HUfCo2k8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFAJK+iHz1dpL18IdO4PUAd1kz+4XGtS7v5D9QDiEDkB7TX8Z2gQFY/Y5TN+qVVfr3M+rz95Fu1JYeJK1gdB4sD7ljVQEPKFnR90S6nyMENN8FVIk9hQ6mawQlMFCWbpf560Atech9fa46jdt1bE32giCZbrvAZXtVej5ujze3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J28h5Hus; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J28h5Hus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20381F000E9;
	Thu,  3 Sep 2026 11:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788434467;
	bh=yLnNlpFN3CU4Ci6vMgMifKQGo+WrJWNNh5KvxRC2n9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J28h5HusR7n8UU9sPcofRN8W/scuT7EhyIvfMfGnrHUlAp8w1ObiQ2UdWhSHpsBSC
	 jsaF+hOnqfaL2Xa782nVZd+ZO+T3O9y1cOmO/Jsvm/NtWJFTDne19dLw0WXrjsOfkJ
	 3dqi07Oor+sp1AhHdigRPdIdGzhg8+8B9cvnkpkKvJ26MCb93S711RHMolQ0vq5inT
	 tf+0sdh+aP51FP4ANpPxGhlnQT7cmORYWz/quqOD4GsTPYPT0Y4GdYUZdKpZlyl4TQ
	 4OMUN70f2X3vftbakOl8XqZBusq+FzRoGbt6xStYZFK9Uk4PjjU1gZ3k2hn+V/nX81
	 bWr7F+lkA7EVA==
Date: Thu, 3 Sep 2026 13:21:04 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_admin: print configuration file for mounted
 filesystems
Message-ID: <aplYDtlKjNPSD62d@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
 <178821870683.2381199.15369045052932427521.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821870683.2381199.15369045052932427521.stgit@frogsfrogsfrogs>

On 2026-08-31 16:27:51, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach xfs_admin to emit a mkfs.xfs config file for a mounted or
> unmounted filesystem.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> -
> ---
>  db/xfs_admin.sh      |   15 +++++++++++++--
>  man/man8/xfs_admin.8 |    7 +++++++
>  2 files changed, 20 insertions(+), 2 deletions(-)

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
