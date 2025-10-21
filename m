Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EE52E1F0A
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 09:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761039452; cv=none; b=MsY4A1V97Glzd7f4G6NDPW8gk4yZBO0UYXJrfbWhGdP2Hve5Ivwj9WhH0e/ZXXUgKdZtnpVaIdNFH3TONzDapGPbk9zLaw55aGOL3eniI9KBKXCPkB9InrU/G+Ym18jkwaJyk4788Is3YbhuWvwKR6+kE7IniAORlnFJSJ1FI+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761039452; c=relaxed/simple;
	bh=0VgsjM49GTFSccidIFItblo9GDipQ95FYM8j+dUkpYo=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kUzwEljdmVfsLok3KcjYX8a0qbQYE1+ksEeESqgkSi+HpbLH0iuQj3jFCf7wru/JT0H2f8bnto20pspl6vOnDoYYoF9j+9fEE6v1mRFS9MaTZD1EaFoxu3G6r2MaYiM8LlEn3Qg1SV3mX9JKelApDMdFXpiHVSQfenj4fq9W44Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ts3xNm5m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ts3xNm5m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8936FC4CEF1;
	Tue, 21 Oct 2025 09:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761039452;
	bh=0VgsjM49GTFSccidIFItblo9GDipQ95FYM8j+dUkpYo=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=Ts3xNm5mbpbXQmyjUaikrVQno70o/VwGByq1lrAcQvN8jLx0BxAzQJsBvpjQAXm15
	 H5LAJbJxmAYcVswzZIAQT0ubW4gpzCuitHS6+D24BTeACJ66foJkcpDevnHVHrZCca
	 gfz67L6/QypqRITkRNR2l5yj+RZZnk2OIdTpYyOsuDhbHQ7qc29B8hLt4Ms8qHri0j
	 QROsSPdSbU9W1I9cnuxliVFMu2hYuScCcCT0DIFnpMRvCwZLKXc3ZUxxkmgoqqVay0
	 3ntqhH5pgHasJb86Dj/BWrfMUGu3TrpAg69bZrWb/vwGBBV2bV3GoKcckKiA9qn9BT
	 N7m0eiO+G1jrg==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
In-Reply-To: <20251013030829.672060-1-dlemoal@kernel.org>
References: <20251013030829.672060-1-dlemoal@kernel.org>
Subject: Re: [PATCH] xfs: Improve CONFIG_XFS_RT Kconfig help
Message-Id: <176103945117.16579.4401439860223298102.b4-ty@kernel.org>
Date: Tue, 21 Oct 2025 11:37:31 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 13 Oct 2025 12:08:29 +0900, Damien Le Moal wrote:
> Improve the description of the XFS_RT configuration option to document
> that this option is required for zoned block devices.
> 
> 

Applied to for-next, thanks!

[1/1] xfs: Improve CONFIG_XFS_RT Kconfig help
      commit: 914f377075d646b4695a7868ba090f4c714dfd4b

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

