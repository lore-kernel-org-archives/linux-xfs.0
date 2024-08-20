Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC364962C
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 16:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724171759; cv=none; b=NX95KZ6IZrOEozrMssvkDrlL6vvXyRepPaoaiRh+kJVhrvMsJ2yyaSbwYfXSnPi9Y8y1uZeEqHYvYIKpBOOA2H1EXI3ezN8IL6vQzTSEtZz9JTG5yObqJ/b5GI71A3Zfyb7c5qDiCMAHRg1QLNDF8O6F2f7rLlulO3CZUisFZv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724171759; c=relaxed/simple;
	bh=I2m2dR9bY4ruh8x7UteD7fXqAJRIcwUQlvadza28Jxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m15ICYqNVOSfWjBq5wzO+HbaDFTFS8cNQ06wLwvb+Byb4QBSjCLSMuaz074d5mlWSJVp31G1tJLnH2AeSSIblMMjofVVKvnq+npxNlgOogTZX5uBRhT0+HGMmQ5NxjejCqYoDJ21J/9CTmKiQnabzuQMToT31+45sMxYbdShV0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3ED5B227AA8; Tue, 20 Aug 2024 18:35:46 +0200 (CEST)
Date: Tue, 20 Aug 2024 18:35:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt
 device does not support discard
Message-ID: <20240820163544.GA3017@lst.de>
References: <20240816081908.467810-1-hch@lst.de> <20240816081908.467810-3-hch@lst.de> <20240816215017.GK865349@frogsfrogsfrogs> <20240819124407.GA6610@lst.de> <20240819150030.GO865349@frogsfrogsfrogs> <20240819150804.GA17283@lst.de> <20240820161955.GF6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820161955.GF6082@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 20, 2024 at 09:19:55AM -0700, Darrick J. Wong wrote:
> It seems to have survived testing on TOT overnight, so I'll bake it into
> djwong-dev

Note that this a fix for the new RT discard code in 6.11 and it would
be kinda nice to get the fix into the 6.11 tree so that we don't have
a release with the current state.

