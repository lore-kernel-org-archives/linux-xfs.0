Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B31314D2E
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 08:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922439; cv=none; b=LQCPTVhjQMxXhdvv7ODK70s5MquA1G69WkfC26NzDJute8pZJNKFYmaYkNKL7gPsM5wLyvM3+g3biV73VYYlz1gmYsnMGrGq+FL+RR2I83W+3FLV0k0ApdPghR8bd6zfP/hpsH5m0Bh6ADq3LYzUQItalMUIEodxFHOBISQdlSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922439; c=relaxed/simple;
	bh=hSn5p236LlfpCmij9sZw6xjNdsrI7ZxmPWHUk4bW+i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IwP2zue8lcc5YeV71QSocC3fZ90H/n7Q2BPQTWDQE0cghJd53ZU2yOH2h3mRHhEPMTOTvKtWeUJrksJaj5YRETxNhqHltKrCFVnWVh6l1SevTvpfFdoJi4v0GbAzS5fOVaNrLEXkE7ntyOoRc2rU8HDQhbwHldhj6Sml43Dye7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A76F67373; Fri,  5 Dec 2025 09:13:37 +0100 (CET)
Date: Fri, 5 Dec 2025 09:13:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] repair: add canonical names for the XR_INO_
 constants
Message-ID: <20251205081337.GA21400@lst.de>
References: <20251128063719.1495736-1-hch@lst.de> <20251128063719.1495736-3-hch@lst.de> <20251201224716.GC89472@frogsfrogsfrogs> <20251202073307.GE18046@lst.de> <20251202175919.GH89472@frogsfrogsfrogs> <20251203060942.GA16509@lst.de> <20251204171811.GE89492@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204171811.GE89492@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 04, 2025 at 09:18:11AM -0800, Darrick J. Wong wrote:
> > And that's what I'd expect.  But there are no direct gettext calls
> > anywhere in xfsprogs, despite quite a bit of N_() usage.  What am I
> > missing?
> 
> #define _(x)		gettext(x)
> 
> in platform_defs.h.
> 
> (and no, I don't get anything meaningful out of "N_()" for magic
> tagging and "_()" to mean lookup, but according to Debian codesearch
> it's a common practice in things like binutils and git and vim)

Yeah, the caller has the _() anyway for the format string, even in the
current version of the patch.  No idea how that leads to inserting the
translations passed in through %s, but I'll just stick to what we do
for other such cases in xfsprogs (e.g. the .oneline field in xfs_io).

