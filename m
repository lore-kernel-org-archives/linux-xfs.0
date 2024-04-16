Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980691C06
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713293760; cv=none; b=mVk718DQM591jN288egKx/7yS7drw29G9pwHRnlPaDQXgL/qemiU7igyzVQEWrfXVXWRmKTTFywYTG9fC2ECtxxEaTv0wrgd5RSs/8MR2t35B6uVktj8n1njpY9xu+zsBBRgSlcVqNVyWzj9hs3tqM9D2YHFTFJETruLcJl1PUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713293760; c=relaxed/simple;
	bh=nN6y+mhd9auKZ6VN0a4y0xZkoFhjQwqO7FSy3vi+vl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdmNmfwG1CQTwMHEcEI9H05VQoboAJotwzpDXA+fSq97riwaifTgxNk71R7QdAGW1TCAsAc/uieJC90GkKC+CVJAwHcZl13JT0i65VLVcnUVB63ul/0fZZGJRsJV/CWqW55zOntszaStkCMfkOZ2UqCpVbHaZZlDYRWgOKg2wWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LnT+7dzj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LnT+7dzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F1EC113CE;
	Tue, 16 Apr 2024 18:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713293760;
	bh=nN6y+mhd9auKZ6VN0a4y0xZkoFhjQwqO7FSy3vi+vl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LnT+7dzjxolQrvFgxIsk483ZdE/I+l7WsLghBwnaNsz5OpSKlXbAW1sMVTZuFYwvj
	 7nh0xQArqeYvYEqRj6V7zNvzCLkb+KN7NBNurKSA6ueudIxXXPxQfI+rLTgPvNoSv8
	 8aL5wqxIg/+MRGGgxlgahwhlIsxWOGMthac8okqWTRKjaIoPvAHkx6mk9yhtXfV6cX
	 Cbdsnc5E6w4DAHD+QUc3yppywxL9wiRhb0oR5jtG87o8BtkL286NdNlJo6/rSVNbA6
	 nYcCcXBnynqtXXnUw3V4A0B1q+ILytn/mvVWdMP0SFDb0ltZj6cA9v1wMxlruR7ter
	 dSvD5l1j0E5/A==
Date: Tue, 16 Apr 2024 11:55:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 090/111] libxfs: partition memfd files to avoid using too
 many fds
Message-ID: <20240416185559.GA11948@frogsfrogsfrogs>
References: <171322882240.211103.3776766269442402814.stgit@frogsfrogsfrogs>
 <171322883514.211103.15800307559901643828.stgit@frogsfrogsfrogs>
 <Zh4EpDiu1Egt-4ii@infradead.org>
 <20240416154932.GH11948@frogsfrogsfrogs>
 <Zh6nVRlJXXN87tho@infradead.org>
 <20240416165741.GP11948@frogsfrogsfrogs>
 <Zh7Hx2VFFn-M1uuX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh7Hx2VFFn-M1uuX@infradead.org>

On Tue, Apr 16, 2024 at 11:47:35AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 16, 2024 at 09:57:41AM -0700, Darrick J. Wong wrote:
> > cloud-init is a piece of software that cloud/container vendors install
> > in the rootfs that will, upon the first startup, growfs the minified
> > root image to cover the entire root disk.  This is why we keep getting
> > complaints about 1TB filesystems with 1,000 AGs in them.  It's "fine"
> > for ext4 because of the 128M groups, and completely terrible for XFS.
> > 
> > (More generally it will also configure networking, accounts, and the
> > mandatory vendor agents and whatnot.)
> 
> Yes, I know cloud-init, but between the misspelling and not directly
> obvious relevance I didn't get the reference.

Sorry, that was a typo on my part.

--D
