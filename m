Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA141DE2A0
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 17:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733938573; cv=none; b=Fadg/O0DI7LxO6qKiaTFV6z8sOASZWpnqtpIHqgWjuHVY3QGHQ2aKZSSy4uB11FqK6EAw1O7fF2pPMgk7ZyOx20y/vHOMfH6VLztUOsbM/6sgk3BG3Oepc2zGp1V9kp+TwIdDi+UII+iNuvw2WhB7nqkq9DS09dXJ6D1HQecIl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733938573; c=relaxed/simple;
	bh=JEk/4ff4ytmlKU+JWXAFr8PMRsg3+qaWQiG8Ifx70hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jgv05SwaBe3K8U4LuRJJaFy9ISk1b9YUQxsxf+j7vWqbSF0uR5ZPFJRmjMCzoZnvVPNac+4IuCZCAkhknBQsDI2FT9EDZfbus6Vs2rC2KmubXRVPMROD3KhvpdjrUdpdaBm6RbpaIgDl2UMpqsdDuA9V2CtHzBISE+iqLi/scCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A432368D0E; Wed, 11 Dec 2024 18:36:01 +0100 (CET)
Date: Wed, 11 Dec 2024 18:36:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] xfs: fix !quota build
Message-ID: <20241211173601.GA19633@lst.de>
References: <20241211035433.1321051-1-hch@lst.de> <20241211173318.GB6698@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211173318.GB6698@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 11, 2024 at 09:33:18AM -0800, Darrick J. Wong wrote:
> Also, can we get rid of CONFIG_XFS_{QUOTA,POSIX_ACL}?  Maintaining all
> these dummy macros is ... irritating.

I have a slightly older branch that looked into the config options
including module size comparisms.  Quota is surprisingly big, RT less so,
but ACL should be a no-brainer:

http://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-config-options
