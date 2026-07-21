Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8014525B0B5;
	Tue, 21 Jul 2026 06:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784613786; cv=none; b=dJK+fVF1//zVSCUXwtb/skd5WOuQ/D/KHyDqOl5Ps5Mus6elB0JSnjZGEbba6RpoyVlGYzJVlUVwa5hAYMVuv1bozAzKGe0OhA1398ww/zO1UEs/t53sSVZns8eBD+F+3SRdhCZkDM/twuaOpmK7Erj11Q5cuai53dz4qYFeTT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784613786; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJYQTEUN3lmaSloViZjMeZf1RHSnCZjmxgHMn6rKXJwIspiTVsvJQfM3oH1gd9GR74Unoo9/HSQWmTNgONmOgVZzUxu2WnjqV6rB4TImX3CtziLicsk2uPFOtxLeV5XAoEKzaOoMqEeH61gkGNVd25fd+EOeLqrIRLzCtUvPaDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94E2168D32; Tue, 21 Jul 2026 08:03:00 +0200 (CEST)
Date: Tue, 21 Jul 2026 08:03:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: set the prev pointer when reinserting an
 inode on the unlinked list
Message-ID: <20260721060259.GA8185@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419679.830862.7131488553992668965.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419679.830862.7131488553992668965.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

