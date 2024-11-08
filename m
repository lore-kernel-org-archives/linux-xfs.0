Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC231401C
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075404; cv=none; b=W6na/m6K/ZBcVXx1FsKLXgyF7Ymh92WAwMwo5x+rvClbWMFEu69WfQRSFAynb2LPR/OjWGXjW7NU/BcP0F+DR3hJKwxPuErgZmc4S/2GlpJTwFfMt5CYQsklp4/8BXYIpqurLg49ZzVVDeo7b48kgXRO6ChorOEkr/yvuvZXhTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075404; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GObj6Bv2jE65kOEtxxurttz/hD6BTEEUu+S1i5MwhRtAfa7Y3MT7rzKUgHWtELHhaPocKWC5Idk7SPE7yX06x3w4nNVucYE1imt4skFZgWu4Ofxu9dir6Ohu8Zp1x2x4/Y3/nTSuYLem0DkBYLww/5phGOKa9GGQAFpUS1htrak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C742C68AA6; Fri,  8 Nov 2024 15:16:38 +0100 (CET)
Date: Fri, 8 Nov 2024 15:16:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] design: document the actual ondisk superblock
Message-ID: <20241108141638.GB6392@lst.de>
References: <173102187468.4143835.2187727613598371946.stgit@frogsfrogsfrogs> <173102187499.4143835.3167579348779056213.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173102187499.4143835.3167579348779056213.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

