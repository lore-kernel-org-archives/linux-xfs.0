Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E3D1EBFE0
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 16:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744303680; cv=none; b=C24QIH9PeOAQzrmoiCo9tn4o8e5uiTVZRNLSNqbh3xI2MR1TeRNy39/oEoB5bEse9xjgYGC13vDgVib6Kcwc1UO71RHpeqpvwZHH5j8NzTBeNifnfyRzjZlfI2AxOrxVwi3Y3Kmu1TaYGEngfMYj3G2mNtmfap1qY1WiVvZKrko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744303680; c=relaxed/simple;
	bh=yl45iJTNaTrJtQcxIeP/fxSmZ2Mllcj++Qa4x8Qb7Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pV17Vv9B0y9CpoZKCFRPJDgcja8CmfbIa4YO3xgIPsWW/NsxhiMBe9kuTrGeQ/ZjB9bnturRI9A7LA5/FRlWVdy5fRJFduMOV2YyJpSTrJZ3lacDzR16ltD3ipiANexbMbWxlT41ZY2lHVNLkFZmUwNA62aipjG+s39Xez+SiD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSNLef4J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSNLef4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611B9C4CEDD;
	Thu, 10 Apr 2025 16:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744303679;
	bh=yl45iJTNaTrJtQcxIeP/fxSmZ2Mllcj++Qa4x8Qb7Bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hSNLef4JYOJUkE1ljb4iDVdeJxIKjCs3oXJFkA4xvPAmb/o6RbvMvJPPiUDR/5X9Y
	 B3JN5oDx64zOTG1hhHvlpezMq7FHJ/6td7cOXJ2QJMF5tmlkX/mY/pVSfUwbViHsup
	 EtTML5vOqx5665168T81giz80K5dalm7qwDJEPekIiWr6X3iRbeRYLYjIcrQHcsmbX
	 adqsQNsJOOsYZn2EML0p+PtbQOi9rMtJguaFVM9M3Zelpca0J2T/2Hm9AVtLKnf109
	 IO+Qwtp0mvvstOQCmFjsjvSePUBNLG5XcxL+j4spafozijoZAPgh//b7hOGEJ6BISq
	 Il2ppk8pdMM2A==
Date: Thu, 10 Apr 2025 09:47:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/45] man: document XFS_FSOP_GEOM_FLAGS_ZONED
Message-ID: <20250410164758.GD6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-37-hch@lst.de>
 <20250409191340.GL6283@frogsfrogsfrogs>
 <20250410065351.GA31858@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250410065351.GA31858@lst.de>

On Thu, Apr 10, 2025 at 08:53:51AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 09, 2025 at 12:13:40PM -0700, Darrick J. Wong wrote:
> > > +Start of the internal RT device in fsblocks.  0 if an external log device
> > 
> > external RT device?
> 
> instead of the log device?  Yes.

Yes, that was what I meant.  Sorry that was confusing. :)

--D
