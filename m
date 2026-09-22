Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250B118DB35;
	Tue, 22 Sep 2026 04:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052706; cv=none; b=d9Soo8r3b4zEX+yqfkLq5tVzr4mtKmlJP0tE5Oi7JBS/Q1+WhtLjf+nXk+yXehqFZpyFJxicy1W8iuIdWmKDBtZ15aAh+SHBO2RJhUOMkc3u1K0L9LTOqj8t/YsBSAPFzs/nlwoqkZLvdpLFZ47NPqfZRNKrEq84vbcdu/blODU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052706; c=relaxed/simple;
	bh=nNdjXgqdIDv2CQxxhwYxpbt1mJD3miuzREBYo4sEzmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+jf3RQMO65Z7sHIsl00Maqv+CDsplU3llK4GmcisUJTXt9dfGektOEA2CflMIVQAXRRCMB58Y9TcS+Zyn/PAxmQVCBFrI+64+76KzuevJwNbDBsOgE0NfNuFwFAQUK2AftmaMkmRhZdlJeITDv6EJ7NVRRtvTSK3kZ9GWRxho8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fp3DdgfR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fp3DdgfR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A84EE1F000FF;
	Tue, 22 Sep 2026 04:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790052704;
	bh=dvwaJCeY0gmtqMzqdDkr35DZ3sIjv+2fswWUP3+256Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fp3DdgfRyZNLyBzjGXgtZ3zhDjwjFOOQ+F/qrwrqqIdokCm2a8Ot8XN+Erjb/NJSY
	 ttFwUSrqBJ7h2c2GRbAbEZcE/ozz/rzzMiD6FGSJBiyCaYl3Vg5urEqbSR0JhIw4sS
	 HV2evyuD2vKCW04G59GAsaOkMycmaC3lPW+IS3unCHIwDm2I8HRoJqj1rABWGLNDvv
	 rDJJaWZd2FMZi/jNuQGeuO/2W2BWhfd4fkvE6SRNHsnKwe/GWMEIbnfyXU+cB2A+uO
	 bfpiT36NWsZCH0ub5KbUPkUpIexuSPGPbgFXtdC3c3LTvhqfgeXJTSNqZWwhB6hw/o
	 12w0IYlur0T5g==
Date: Mon, 21 Sep 2026 21:51:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260922045144.GP2705364@frogsfrogsfrogs>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111539.1003439-1-aalbersh@kernel.org>

On Fri, Sep 18, 2026 at 01:15:12PM +0200, Andrey Albershteyn wrote:
> Hi all,
> 
> This is next revision of fsverity for XFS.
> 
> The main change from v15 is addion of kmem cache
> xfs_fsverity_ioend_cache instead of adding work_struct to iomap's ioend
> struct.

FWIW, Sashiko found at least one or two bugs, but the reports only got
echoed to the ext4 list.  Perhaps it's time to discuss allowing it to
email linux-xfs for bugs that it claims to have found in xfs code?

--D
