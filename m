Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620F238C07
	for <linux-xfs@vger.kernel.org>; Mon, 22 Sep 2025 12:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758544921; cv=none; b=IgrDwFZxOSGw3G1OT0ANGz1oc2PulR6ttWGVzQHU8Tw6w6jDtRLIqgljeyFhl+Fc4QarEMQF+bbqGJrcW1bAvIQUU6SQvF4GpbNOwtFWhJ200Eg1Ww5iYJPKlTL9SqLsFWY+b2pla3eC/JIILnQjBDTKe9RhL5DdV51JRAtfH90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758544921; c=relaxed/simple;
	bh=MA5VgEqGKHCUzIvmVKW9ad4KSeunYGb6c2bchjDO9B4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tmKAqFPk3MJ1z/vaKke5G0kpnA4LmSDKBEF518lSjwLur2+K8O9byxRFKfBe6F5/r+zzOXR3zr7F2t6wdkCifgzeWSlk7gDrHB8L3Cf4p65muHhRH/LMJZroV2xqCUIaYgTPzllscuIF2lKnm6w8FmucBDOMw66e3j7iVa3BnJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnQOGq/x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnQOGq/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67E3C4CEF0;
	Mon, 22 Sep 2025 12:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758544921;
	bh=MA5VgEqGKHCUzIvmVKW9ad4KSeunYGb6c2bchjDO9B4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=BnQOGq/xR4I6D70cZLrWjjVdSO/ssu8MknX1SScklmsbGS//yDvFioq37L5kc8nPx
	 pKrH6HOj2wHtPNZ7hGW2jcva402gWqwSoP8Bug/VTialiKOHzz2m+4jWVA30kyyipe
	 9I/PCtm/tDDctuVbUf0abx3510zRQtCtGh58mgeReTBPBJ8HVNhEZUB05KKlinfi7p
	 PbIeOPIcGLBdO+7Sv58H7M8HH08YRyS1V9pE7V3I3U8XZs7LgWwEoJzXPRzvytm3uu
	 fm5Pefuq42Hxrq4CdHXE+4ocU7L0D6Zrvh14yrWHNCqUp6peBtFsJQpnil6AdldtdM
	 gHeF8je9GkqUw==
From: Carlos Maiolino <cem@kernel.org>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250918111403.1169904-1-dmantipov@yandex.ru>
References: <20250918111403.1169904-1-dmantipov@yandex.ru>
Subject: Re: [PATCH] xfs: scrub: use kstrdup_const() for metapath scan
 setups
Message-Id: <175854491953.13267.12296994550691267039.b4-ty@kernel.org>
Date: Mon, 22 Sep 2025 14:41:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 18 Sep 2025 14:14:03 +0300, Dmitry Antipov wrote:
> Except 'xchk_setup_metapath_rtginode()' case, 'path' argument of
> 'xchk_setup_metapath_scan()' is a compile-time constant. So it may
> be reasonable to use 'kstrdup_const()' / 'kree_const()' to manage
> 'path' field of 'struct xchk_metapath' in attempt to reuse .rodata
> instance rather than making a copy. Compile tested only.
> 
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: scrub: use kstrdup_const() for metapath scan setups
      commit: fc0d192303bd385ac24dc52eb31ceb6ca7e027d0

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

