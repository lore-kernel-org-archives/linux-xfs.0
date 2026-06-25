Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7E3DEACB
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389167; cv=none; b=YKR6H6WMnGmgwMc1WQ1GZNcf1swEHfQOe9ir3QTCe4Iid769y4QZLEt970V8PvHevn0GuxxZKSZBZAAMIcr73u61ureX7xBDwNO7CtXFUCD7S1pEM7s7gpS12HcPVLlbShmdMoXJhLg+OiHX4jzzhd54qjjNTipifYqFyQsBR6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389167; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNAI/Q+ISeLyIbtIojYkB3uvIUr7p9z6cAVT4RL97QT1c0cb4rLsZUpS88tZuRM4hWjs3td4n2LyqBffW03p+/IMGqe1T5ZVRwoyNBgeblrTlftmW1zaQaIS5UFWD+BcnSumbxiaJjCYmKFedKWWD/txrD5k1yg193kaUdm5bKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0F9BD68B05; Thu, 25 Jun 2026 14:06:04 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:06:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] xfs_scrub: account for reflinked realtime file
 data
Message-ID: <20260625120603.GJ18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484605.915780.11173864238259682348.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484605.915780.11173864238259682348.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

