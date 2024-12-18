Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1A5142624
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 17:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734544502; cv=none; b=iA1Pdd6gHam/CWbA8kBgGof1YfhKLbndWAwz0bk9dI72uTQA10BtqWTclTxazkF1Ve9QAnEgg9gjo+6On5TvnHEFXEiD0OFTxJSk7QWTquahR/t1NJKlgnCHlt7jdWDXqCzZ7i54j7zGDkCR3ZNfpvCR+UvLEpVkLW+4MGB8j9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734544502; c=relaxed/simple;
	bh=S+h3VCYAEGsBH/el9gEBeQhPokud2u/iFXO8ozYDNi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oh5/icoHhfqyoUNBexnEEDMJ3iebe0DgNHz5qGhwdCk5O0zx4eA3meF12E3wZdYmOkOAY7oUmCvSyEUy91m4vvuKJuku2SUCAUi1W3vJDdjAQAyQ5KRyHMkaHwrrzdaNQvotYlBDLdIlj27R37o9JA6LL3xp9Fal1m1LD21HT/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XlkDiTx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XlkDiTx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0168EC4CECD;
	Wed, 18 Dec 2024 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734544502;
	bh=S+h3VCYAEGsBH/el9gEBeQhPokud2u/iFXO8ozYDNi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XlkDiTx7WvqFX8mIPb2XEYDx9X3zPAXW+eB+IzM7vb9WdTuEBW02xvzJx7AqM8bO8
	 oKlPDvPfvniYyoHquXS0SXDEGCMN4C0nwE1VRuz26MiFfp06KsX6awueRMS8REYNiI
	 jIugSdsiK771JsQf+L1R4EEXkFcKKIZzGugDzBA5Ysc5VesjHFf7dzWcew7/jY+lLE
	 4KdDuszhW6NVvRtEXznh7vk91/v/rvdAAP9s191ALEZkiXC+BSF7zzk7mShTEvZ1gi
	 vUAtsFXBuMeHNm8oI+DTQrMm1LLQMBD88NnlRIUSkQ0YH6lVHjNYaEnqRNSfNioMcq
	 HOuhqMylLHhlQ==
Date: Wed, 18 Dec 2024 09:55:01 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241218175501.GD6197@frogsfrogsfrogs>
References: <Z0jbffI2A6Fn7LfO@dread.disaster.area>
 <20241129103332.4a6b452e@harpe.intellique.com>
 <Z0o8vE4MlIg-jQeR@dread.disaster.area>
 <20241212163351.58dd1305@harpe.intellique.com>
 <20241212202547.GK6678@frogsfrogsfrogs>
 <20241213164251.361f8877@harpe.intellique.com>
 <20241213171537.GL6698@frogsfrogsfrogs>
 <20241216231851.7b265e06@harpe.intellique.com>
 <20241217165042.GF6174@frogsfrogsfrogs>
 <20241218184732.4e38824f@harpe.intellique.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241218184732.4e38824f@harpe.intellique.com>

On Wed, Dec 18, 2024 at 06:47:32PM +0100, Emmanuel Florac wrote:
> Le Tue, 17 Dec 2024 08:50:42 -0800
> "Darrick J. Wong" <djwong@kernel.org> écrivait:
> 
> > > > xfs: don't over-report free space or inodes in statvfs  
> > > 
> > > I'll give it a try, but that looks like a patch for old weird RedHat
> > > kernel, I'm running plain vanilla generally, and much higher
> > > versions, I'll see how it applies :)  
> > 
> > That's from 6.13-rc3; I don't do RH kernels.
> 
> Sorry, I've seen the line 
> 
> > Cc: <stable@vger.kernel.org> # v2.6.18
> 
> And thought it was about some RH7.x kernel or something :)

Ah.  Nope, cc:stable and RHEL kernels are not related.

--D

> -- 
> ------------------------------------------------------------------------
>    Emmanuel Florac     |   Direction technique
> ------------------------------------------------------------------------
>    https://intellique.com
> ------------------------------------------------------------------------
>  


