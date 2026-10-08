Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A943B19B6;
	Thu,  8 Oct 2026 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791480007; cv=none; b=k3seV6fYJLZWrcwPQJjCsTJVJDl+/uzCrHaAKzxwY6sTYtse+s9h4pHQ9MhBuuB5bYR3UV+pIKRz8L+IJvWmoeo1ty5CuxYrq2ngzPTmke9RGN+AyN5zb/k8FqxHmOSapNgnWVpKmI54dmwQCknFZs552RpxoFa5uwrK/1G0nVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791480007; c=relaxed/simple;
	bh=0c4tRmzrQcnILYxO08Bqq+eZvQYP3k2m8RKpHZdRrcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tbq8Ah5iVFoSf283W94Df0nWxfM5aD8yk9+o3e+/zTh3zbhRuHudICc9l+6H2EiVq3acZcJ0zTbB2u5cPz7kyppT5gBZdKENIpCltHc09D4iNAV9yLSjRMWH9BTXzBGS8mohxpS/2oS/Iq2OuXscFoad457AJvC05fxKrKBw6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L56qRQ5P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L56qRQ5P"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 357111F000FF;
	Thu,  8 Oct 2026 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791480005;
	bh=4/+xMOENnVRhEAEZuBanU7rdPV2PMrCIt5k0j3QWQmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L56qRQ5P4EBTJWX7rY6Dl5QOcdxTNY7BgM4FkJY2fOZ9FyVcXcT6Bi38mzCLn6/Rk
	 SAdlpd7kzxQNlN4ARMmS2SAqu2nCpJO1yOM/3czB5BztTo0ZnAbsxOYH3U75fvsc6g
	 5XD7XnLt36KQeCmJWRWTevHgOpEtQ/UaMmz+B+Xz4u1zYnPhbPtZUyQgxEuu4h6yee
	 AU8VgHAXW6ot0NdqzCmGxldp1sqJrUioClJsscA0vr2ZhYBpzV7vRAnMBKgC4wMIe6
	 v9CHgLRjbDFXvWq/dLZxwwHdtypLt/Da0M0gVFVlLvis+IXu6DgpU1YljHF9q7PESM
	 1yEhyzefOYgAQ==
Date: Thu, 8 Oct 2026 10:20:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: reattach dquots after changing inode ids
Message-ID: <20261008172004.GT2705364@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521342.2728617.2833089550706486434.stgit@frogsfrogsfrogs>
 <aseFDykX3OaCKSC1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aseFDykX3OaCKSC1@infradead.org>

On Thu, Oct 08, 2026 at 04:57:03AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 07, 2026 at 10:55:52PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM noticed that xrep_inode_ids can change the user, group, or project
> > id of any given file.  When this happens, we need to detach any existing
> > incore dquot and attach the correct ones.
> 
> Sashiko complains about changing the dquot while attached to the
> inode and I think it is right, or rather the issue goes even deeper.
> We should not have the dquot attached while changing these identifier
> as otherwise things will get really nasty.  I'm not really sure how
> to do better here, though.

Yeah.... as Sashiko points out, the dquots might be attached to the
transaction, so dqdetaching them with a transaction held is baaaad.
The dquot detach and reattach have to get done at the end, after we've
committed all the inode updates.  Will update this patch and resend it.

--D
