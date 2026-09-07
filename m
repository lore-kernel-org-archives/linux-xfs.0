Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47216211A09;
	Mon,  7 Sep 2026 06:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762905; cv=none; b=GTbfsdXoml3zm+jRlRzdYE8US/LaLlsoDxYq6zTtw5r2VSfd2UEfVdGBlTq7OlAAB1TB6GKErPLBMRPZ9yLbdadUTbvA6U8ZAOlgWKhAtmQ0WbjcuKQ0LwAVMMGt3jQNqMLS0n15vruIaxaCmKNUH+oSYGBcuDShLb1gvXuJDn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762905; c=relaxed/simple;
	bh=CuuUffgAxhg23m+jLdmoxCc0X9W8NAjOnck28PrZJWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJjKCQeMimgnTttCT9ZNlEt684M0SVjCR4EbUE7Q70BznzVgicEAE81ElzlwnnIJ8yNpYPZ8EXKh8FmHUwPxkXjuMVeWgjKoQ/yMryIkgbW9oZsBZp1DN0m265djAnoscv5ndHyefCVMLDYL8GMAizWuyDOV1OpRTgsEWkDMYHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwy2aBkS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwy2aBkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71A31F00A3A;
	Mon,  7 Sep 2026 06:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762903;
	bh=EIK7FFDFxpzYxKxWUpP/7XGctoO5Qlr/79qmf/rK6m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bwy2aBkSIZLgN3Nf4qa67R70q2Btb1dXY3S8klk2TkDn2rgYTxFtzhwtPLo3eDhdQ
	 ozhzood9uF9F94OUeDf1UKcWyhmr2j1P3VBPwoLubPsQHT5VXr6wDpD8zV3y1TUvzh
	 FrZbeerIq5sJv06HtFRqdS9x13tDhI2QawGdktpkILpGEaOAC1GV45clsjOBVKDf87
	 xiI4TSASJP9271QI9i16SEhAIjBEsKrvjMjB5fPDRt2Vx23nwuHZm/Sh4sIg91gomT
	 35sYrCQWWEz6M3cUw9x9M/pAp+XY5qlieLLLLAHCKhJ/tZYM6fCeatgyNZKoWjfBWf
	 bP+RfYm6SSAIQ==
Date: Mon, 7 Sep 2026 08:34:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
Message-ID: <ap5bBOVdR7wEYCDi@andromeda.toxiclabs.cc>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs>
 <20260904161302.GC1933798@frogsfrogsfrogs>
 <178876252708.14075.469925625360656630.b4-ty@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178876252708.14075.469925625360656630.b4-ty@kernel.org>

On Mon, Sep 07, 2026 at 08:28:47AM +0200, Carlos Maiolino wrote:
> On Fri, 04 Sep 2026 09:13:02 -0700, Darrick J. Wong wrote:
> > LOLLM also points out that the xagb_bitmap_set call in xrep_agfl_fill
> > can fail, but we don't check the result of xagb_bitmap_walk, so we
> > silently drop the error and proceed with inconsistent incore data.
> > That shouldn't be allowed.
> > 
> > --
> > 
> > [...]
> 
> Applied to for-next, thanks!
> 
> [6/6] xfs: bail out on bitmap errors in xrep_agfl_fill
>       (no commit info)
> 
> Best regards,

This was a mistake, sorry. This patch ain't included yet

> -- 
> Carlos Maiolino <cem@kernel.org>
> 
> 
