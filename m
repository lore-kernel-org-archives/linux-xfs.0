Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620CD60BBE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902928; cv=none; b=HyLEKE8pBx8felDTb3iiKzReeUrwry0biGFA6jIH6tA5NEqoPFq46fykPeRsAW2YYXuK8joTjzE72frNte6h8J5L3jJd4TV99cs57lg6PXncHlncu0vkf6R8FOYImq13KyjgRSji5Get2VI8IEPeH2JoiT8LdHO0LgBs4WsKrbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902928; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ly+tbyIKaL+uAf14BsM8NX3dwnAn/iV6Rvl3a4/L9rnh/j5C/mwP3lYqcFUTvURjb9WmQZDcd0a4UstB49Bb6FYgeG/+ikPCrlZ2adiqiRtu+LIAUyXxgKNwZf6bwcv3osqpNui+CAAqG1/FW5+COPVyGlrb/bE2QYqMkoFYiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 80E3E68B05; Tue,  2 Jul 2024 08:48:44 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:48:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/5] xfs_spaceman: report directory tree corruption in
 the health information
Message-ID: <20240702064844.GB25817@lst.de>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs> <171988122726.2012320.799724181764249157.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122726.2012320.799724181764249157.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
