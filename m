Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53287347FEE
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 08:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781166342; cv=none; b=ECUJFwdFE7F/MacYcabwYdxi65JOS8HmtfvYNRj+nVi5Fa0A0YKtTUDHgmqD0uUTJaLo1v2f2QZ/KqbbicYyuV5ObgOZR2JkqMrZ7pXGO7QzVwDtZ69IsK0o574MXp2t+ZZ4ueXoVa+OjPIuiq02dTIqTTFiwCGqTGGUzbjZ8oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781166342; c=relaxed/simple;
	bh=lfFV/uj9Wm2jnH4iXZfONmZME1DFknFiQfBqXUj9gik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=shNUE8Im5EkmDrwynDJkh9mlvD6arEv5YFrY4WbHUy9zyvd5DmvJZ1oY1EqpYxKxv5VE0lqpKW8hL0g+tMbFPNAlug6Q2VkYfcldfAo8VyYzSDr30PsblgiVNHuSOBcTi0An1i+aOiIpktexbuaZ3ffMzRXEnP2jd3HEfQS0Frg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqfLEtp/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqfLEtp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABFC1F00893;
	Thu, 11 Jun 2026 08:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781166341;
	bh=lV0/A89wjCRfwNks57dr+kWhXEJWgfavPBYh00pFbjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nqfLEtp/Uw4bU+Ayn+Uq2z2bEoaByNI9JvaG57VPsLHyfm8zEZkKJ8vslLhzJxrd3
	 Wo2isvsVZcLDH+P3j0C464CUnJuNd30+xjCHRaa1MOlSyVSZGFxFHv6SKFdnRKg9WF
	 MzAzYaVdK1uEy6r8g9x6tYgxblZgsIcOFBp5psq8Ri1H6qRBkAUDXFlJLsP6dkIhkm
	 wkQjjTWSmVGmWJDzLgC8VF+Yl7meDQrKAb+JuGMVxYhtPxLjaC35NicBHtstgiHGM+
	 CAytwmRTRsibUAewRdguSKHbSZkEpOfzbGThdF3H2G574YP/nNpLYZ1h+Tw8OGeZ/U
	 ihF54G3/A+duQ==
Date: Thu, 11 Jun 2026 10:25:37 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/21] xfs_scrub: don't count internal log space in the
 data device used count
Message-ID: <aipw50Gj8c9e8-Fv@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303238.2608728.8986838126430623871.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303238.2608728.8986838126430623871.stgit@frogsfrogsfrogs>

On 2026-06-03 23:06:09, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Internal logs are not considered free space, so for the data device
> they've already been subtracted from xfs_fsop_counts::freedata by
> XFS_IOC_FSCOUNTS.  This causes overcounting in the phase 7 reporting.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: 95a92c5cecb2e1 ("xfs_scrub: perform media scanning of the log region")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
