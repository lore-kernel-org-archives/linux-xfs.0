Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFC1EB9E1
	for <linux-xfs@vger.kernel.org>; Fri,  8 Nov 2024 14:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731075378; cv=none; b=OBqTak/7lxwCUFdx375E5tTCpqMSn9dmoII1YFNVJB7lUcXiPfNhhTYJ1ImhdyQ8wdZhZvXY/zfXfpAMvBokTfUCf3b9KjiJru2skW9T2Sq4tpriX72HoIsM3lpEUvH9nwe/m+XfUFm0foDZzA8kZ3oLcKIt+Q1pVFv/P+WfOPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731075378; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJoLUQLUiOyRAlhW9FVPyhSm93eJJjwiQpFmBLF5x7YGvQ87qo43XUCBVwG2zOzcCwgY2On52JCu2mEOTn1s6hIy8qVo7DfXj/RldLJ9G52VDoOpJXP16/1PvdRGZfKin/4IpOIlOe4dhYQDahUtWdP/a0X5J7nNDgSom3Hxo/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB03B68AA6; Fri,  8 Nov 2024 15:16:11 +0100 (CET)
Date: Fri, 8 Nov 2024 15:16:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] design: move superblock documentation to a
 separate file
Message-ID: <20241108141611.GA6392@lst.de>
References: <173102187468.4143835.2187727613598371946.stgit@frogsfrogsfrogs> <173102187484.4143835.5851889384793579912.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173102187484.4143835.5851889384793579912.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

