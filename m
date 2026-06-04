Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4D331A65
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780586862; cv=none; b=Eevosp/ZcLWLy2QZHG0m0EcoDenf6GQxCC0K3G7ZOQcaen3Q+5wNqkbTESPrtmiO3Q/oE4JZmfBdSS1HIRpYuCm8jB9yKnR3LVGFYu2msX1pGCFws4IU4KTvq/qg4YsmPlKBA/GV0oxK5x6pi7u/t4H06zDz9uFaKosJWTOLWtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780586862; c=relaxed/simple;
	bh=2Nn9mU1dQfnCiuFIu4kQm3ZLd9mH5w11HBOlPrRlqQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fywUxs6fVsWccAZ1PGq0xwTXOBiajn3KZkMjMU58/V4R7h9K9e0yKLcTO0vObxphsnMS3RWrro/9x0ptfnMGuOK3Fm+FGzTagtpi174NMfLmrJwPQYxwU7Aa2kUW62IA6WPanJZHbn7KhgTeUWjgSN6LAWEtz2LtZY8sjcrSoYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAJgmjin; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAJgmjin"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBDA1F00893;
	Thu,  4 Jun 2026 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780586861;
	bh=tYFymoYeF3WyPsVzyxCUqHf7cdYawLlKoxiiR40rz0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hAJgmjinZFtUEbkwF0geOqwXq7B4lS/MorYLKMIYPtQLDNU39Z2ow/n81pQh+OS1E
	 btg2b7oOLbjLeqjUQC8/yPYWm86NwZOm9PbaYeDHXM6GNkIxYe7TLqvr89DHbtOMO9
	 oHCjKszp8c5Ps8aEEZOZpMmC/ucbRn/U0u0m2h+c4J/Cg1N4aWhM2LuTwGCIl4k10V
	 UX5EDO62ZuyYJeX+TNtJjkap+MO1ctrW3jDec6PeaY0lTDkUABf9rsGjLzLT8O6ySh
	 jz7ye78ZxVV+MOVQI/5tj7EoZ//xQxWYffDTozpq3mh9AOCM3ZWdgd2bGi5/QrpUcW
	 j31i6KMB3uU5A==
Date: Thu, 4 Jun 2026 17:27:38 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 19/21] xfs_scrub: don't obscure repair failures in
 repair_list_schedule
Message-ID: <aiGZWzoZ-5S1w-Rm@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303457.2608728.14097578913048293124.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303457.2608728.14097578913048293124.stgit@frogsfrogsfrogs>

On 2026-06-03 23:09:16, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that if we bail out of the loop in repair_everything
> due to an operational error, the workqueue cleanup blows away the error
> code and we return as if nothing went wrong.  Let's fix that so that
> operational errors cause the program to exit with failure.
> 
> Cc: <linux-xfs@vger.kernel.org> # v5.3.0
> Fixes: 71296cf87ff589 ("libfrog: split workqueue destroy functions")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
