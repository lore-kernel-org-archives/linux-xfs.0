Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A38550DDA
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 13:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959754; cv=none; b=nI1Xm0XwkUnQPd7iu8L3jYJl/uctiTunUvdE/MiYE9XjEecQWHU6iOPBikxhY+ivBKVtJtgOcngBVa4lGFJTjjoiGep6JefcNcQG90W/V32bQp3lf7DasIunLyMO5VFhnsNmKjBHMXYUhS+6SUWSc228l6Nhm/FVLi2uQWMMXtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959754; c=relaxed/simple;
	bh=VWJ6O06xV8WxX1oRiiVvwkBMHwbensOKoTz+TGfxAPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1/7HApZ+KWEOxu+R4r7/v4rgxU/CB0a0jsjc9VnAPNm0gCdBIgXQi3oiwtOZh8RjP+/tJeA2ej6jK2BjrEpB5ZIZG22UP09muhgMqMNcLjKTDLEL9tJX53uKNgO82BMbBs6wpy7Jj8HZmVSbry49nuQnShPcSXivhr5QpKsRYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SW4iwIBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SW4iwIBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B751F00A3D;
	Wed,  9 Sep 2026 13:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959752;
	bh=IYJ1HCNdFGc8vOKgU97tjcToozxCApdrse73edJCtbY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SW4iwIBqZTIdFjOZKk8IrferlHYG448m+pK6HKLbOkrzmg5Qs7/26QVEICCXEJ93E
	 tyBhaJCM24vCtNN8OZFxFEjnVErT/maBpc+Iu9xso3ghJNEGaw2E+D+LQ0zsbK8viP
	 +reQ5g1blKuybIZ1HrLYoxGYsQK8E01bEA9syOwOTxaADjzHXuZvvbDTiExxevoibP
	 MNWttfydleSsjJozxpahC5eLmletL06I7rK8LWT3RG8Ulo0LnffOb/nR9IVaZiV3bt
	 BioIo7G8Z/O583CXHqxwd/p81FlsuEy74jCoinhNZ8zjaLoPlk+QUYJNxKQ/Dhwsjj
	 eKWgpN4a2X+eg==
Date: Wed, 9 Sep 2026 15:15:50 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] makecfg: handle old V4 options that are almost
 always on by default
Message-ID: <aqFb8x2qQ6rrTYfP@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
 <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892910641.4047311.14095703802962095779.stgit@frogsfrogsfrogs>

On 2026-09-08 23:01:48, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The same alternate LOLLM also observed that there are a couple of V4
> options that are always enabled on a V5 filesystem.  Since we support V4
> for another 4 years, add these two options but only for the weird case
> where someone wants to turn them off.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
