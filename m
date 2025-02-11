Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5BD1E5734
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263475; cv=none; b=YKjPx66c6kSoGvn5YIRlJTV9ftsUmVPw/npGEFLR7qZaqL60Fd0QByEB4wSuaYQzStO6EqJOA0BIgvd0NO2TUPGiFe+yBBSMnAqZvrFCGrt2Fdv0CyPzBjxU0Fkj/lbSVVyGqDJ3Lq8fVs4ACKCWqRQO5poFGE034dT5eEZ8mVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263475; c=relaxed/simple;
	bh=qFH9RDcsFM9nSnIJZ8IefXefB7BfOTiq7sFkBt6/KsY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FnfH8OyfFFJWUZ3uCDrMlkvi2fIoP/yaQtj5sD2To3n94wek+xcGowhf/N7DgDT9UogzJjV2JoyR2L7VaK5KaqnxlQ4+1OhPEDOMhY0LBJg22YvXuKm2aZkttAP57ulVGJku+suup4K/NyU9MiD8B2vWlGSi4Faz3dCjB7S/SHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SfAz9dmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SfAz9dmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7408FC4CEE6;
	Tue, 11 Feb 2025 08:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739263475;
	bh=qFH9RDcsFM9nSnIJZ8IefXefB7BfOTiq7sFkBt6/KsY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=SfAz9dmnIfosyqN0ypqTxt7RYm54XFBfabhjxD+14LEe5VGa49pf+8jgm4yCVx9SX
	 kfAXvIgQ+SECK14q+3ZDL9HSJLgCloegCH5drGfavF52Z+xE55Dy0wpV+ZECEZhC0Z
	 75BBMZPfyQa2IEV3agT1ntB22mPM0c581gnicPiHPwhSj8eR4559zkORY3Or5thaMG
	 UHfpd2WgssWHcfdeOqr0tfNf+yGZwuA38/JbRY6GpldLbU4UzalOSAGyyYLDv5o9Lo
	 t/dzFx4UU7QtAY0r7W5zcDUXyJUqgps+a4B723hCLtHUj3SSk2bQ+nHbCF2qTop3zP
	 DXxRTv1LnGfaw==
From: Carlos Maiolino <cem@kernel.org>
To: djwong@kernel.org, Lukas Herbolt <lukas@herbolt.com>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <20250203085513.79335-2-lukas@herbolt.com>
References: <20250203085513.79335-1-lukas@herbolt.com>
 <20250203085513.79335-2-lukas@herbolt.com>
Subject: Re: [PATCH 1/1] xfs: do not check NEEDSREPAIR if ro,norecovery
 mount.
Message-Id: <173926347418.43797.13489123950896413284.b4-ty@kernel.org>
Date: Tue, 11 Feb 2025 09:44:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Mon, 03 Feb 2025 09:55:13 +0100, Lukas Herbolt wrote:
> If there is corrutpion on the filesystem andxfs_repair
> fails to repair it. The last resort of getting the data
> is to use norecovery,ro mount. But if the NEEDSREPAIR is
> set the filesystem cannot be mounted. The flag must be
> cleared out manually using xfs_db, to get access to what
> left over of the corrupted fs.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: do not check NEEDSREPAIR if ro,norecovery mount.
      commit: 263b984ae26bbc320581d2872a125bc305bea0b8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

