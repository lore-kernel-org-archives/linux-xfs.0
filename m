Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEDD142E83
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 16:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764952186; cv=none; b=Fmh9g+gTiq8ooyQNEc3jJv/eMJqNUpyNdxv7GzMdOmACJtMZ78CoZoWmpaYXzNREAfK9Gbsymz39fuE9g6was2Adw6eu7B4xX97JXtatPcACwke7QGZtTzUZp92k4gO4p48q3S9bHdp7ScfnLZchWKFWfXIJEqbET3T2mCLcy5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764952186; c=relaxed/simple;
	bh=gVziUpeUJURWv+gdKbhZwj/XcL3URwTe2S2j02T39Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lO1O224LgvXk2WsBjES6/aomWv7FKnCRSz3llh1gkW8rvP/ozjZyctZH2V0hLHuZiSGyweNXBJsydioXxZEirIXdCsAnzyGg9jV4aVxWLHt21O40iWR/1Lb8ValeuWoz+3ONrZroT9kGQDe6gCCFoeHefuzTg1okAunycgYCGFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYcAfuFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYcAfuFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8A2C4CEF1;
	Fri,  5 Dec 2025 16:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764952186;
	bh=gVziUpeUJURWv+gdKbhZwj/XcL3URwTe2S2j02T39Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYcAfuFES1n4J/2aZuPvYKGk7/QobePqB4hVxvvaRc57tAkqpx0tYow1IC1yCLjf8
	 RUHunOQvsSiiygBi+eY80GgsPzzbYmbxLac534dYqhrzXZIErJfpP4aeFyZLxsiL7u
	 rhrJx+ZOEXtV/WO0NeAnao5mVRZUagihb1iku1syK2mMOOo3XOjPD0l1NftozHctW7
	 oeJeOzO5wVfppfnROcolFfP8DdyD2K+GeRFFnaeRXTYTBPYG/QNR0EWUbeZl+AhAmL
	 9b8Q1v07WECW40HvGeveCr1sRvvKi3BOmbBOTWE12x6WBfVlFrCbZOr+huHB8Sq0h3
	 pQGtLpHrVicTg==
Date: Fri, 5 Dec 2025 08:29:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <20251205162945.GQ89472@frogsfrogsfrogs>
References: <20251202133723.1928059-1-hch@lst.de>
 <aTFOsmgaPOhtaDeL@dread.disaster.area>
 <20251204092340.GA19866@lst.de>
 <20251204172158.GJ89472@frogsfrogsfrogs>
 <20251205081224.GA21377@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205081224.GA21377@lst.de>

On Fri, Dec 05, 2025 at 09:12:24AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 09:21:58AM -0800, Darrick J. Wong wrote:
> > > Fine with me if that name is ok for shared code.
> > 
> > Why not merge the xfs_linux.h stuff into xfs_priv.h?  It's not like xfs
> > supports any other operating systems now.
> 
> We should merge them anyway, but I understood Dave in that he preferred
> the xfs_linux.h name over xfs_priv.h one.  I don't really care either
> way, I just don't want to redo the patch too many times.

I don't care strongly what the resulting filename is. :)

--D
