Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167365916D
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710797684; cv=none; b=YIO1lbQoKMF0h8+7uyGfRJ5eN1iw0fYAh1l3I2d1+PDDDNTzfVCnuPuu+jnntxCM/2wFWm1Dkaq0dlMIuj51FSrC0450ykdwwVXomOTbf/P/Q8cRN3bIx4vSWrE75dah8az7DunQf+UFY5+Q95QMAiY/LY9tpKAzj2sSdsjdxXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710797684; c=relaxed/simple;
	bh=hkdTa1XTfbNi4BL5YzpvllXMeuuIAIgCEtDzvWzikRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0dzAJ243q+llOJD41EVjWSBuyEVgQsVmoQASR0lx+LbGoCW44pSq6CCJ6E2MlnNR5Jsz+p4lOCxzRhghIKi/C+ZRuf27L6yhG9gpHGEIgFSJ6apahg7gBUCfhQRZ5rInPvea1dCQNb+a59nrMk1urxUq+06KHa2nPsRXOJyAFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BOW32MHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BOW32MHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94282C43399;
	Mon, 18 Mar 2024 21:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710797683;
	bh=hkdTa1XTfbNi4BL5YzpvllXMeuuIAIgCEtDzvWzikRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOW32MHj3DiKWnIj3cJgiWuX30Y8rIaopvIda3JcMPxTXNStbdeOIQihfSSXH5C5+
	 VN1y7tAjjulMUEezEsCmmYdUR7WJn+Mnq/IaPm7ZaT4E0e3cXd7wF+vTB+3qqZ1C/a
	 ZBDcDUP0oyRPTkpFBPH7x744CCycPD0Ebn9qSW3ijx2RVEXRp/hVeF3LMA1TJW7N3o
	 wSlJBVZjBi/EkuBLPwCvAllKoketBlAQHLGln3qs/8twnaCnUzifrM0Pc4UyJCXLfY
	 jC941nyW57ytnxR+2bSso6E+MQsEkk72A1nx3Rg4utw9busKOlb8A/f5Gc0DfV/xs9
	 BlKRb6QFOYjbw==
Date: Mon, 18 Mar 2024 14:34:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Shrinking
Message-ID: <20240318213443.GM1927156@frogsfrogsfrogs>
References: <8E09083B-5A8A-4E6C-81AC-3F49A9EF266E@karlsbakk.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8E09083B-5A8A-4E6C-81AC-3F49A9EF266E@karlsbakk.net>

On Sat, Mar 09, 2024 at 06:51:30PM +0100, Roy Sigurd Karlsbakk wrote:
> Hi all
> 
> As the docs say, "currently, xfs cannot be shrunk…". It's been saying
> that for 20 years or so, but I thought I read something about works in
> progress on this. Is this right or was it something in the vicinity of
> https://xkcd.com/806/?

Shrink is partially supported -- if there's free space at the end of the
filesystem, you can reduce the filesystem by the size of that extent.

To make shrink more useful, the codebase will need to gain the ability
to offline an entire AG, move metadata structures, and perform free
space defragmentation.

Alpha-quality implementations of those last two things are in my
development tree, but the entire thing is on ice while we try to merge
the online repair code.

--D

> roy
