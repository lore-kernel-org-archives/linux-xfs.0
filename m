Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608292A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897722; cv=none; b=qkWvSRPXmw9W5iH6rdVgqZhKRA3bnwMPgMmMjkByRO8u64bTRf42FaGNHeavRxgjg2gJpnfyw4hJvROJV+HvfN/4zc5Orb9QsVncSYazM4oWIGAFAdNHP/cDScoI0ZIxOF+JWWB3A137cU7WmcEv7qDAmBnYyNp9MogLb+hqUsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897722; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiTjaNqoen72ZqXZXqqs+Pmr9A/HI9NHdArhKHD6qvXgEHFDiSY81PpzpW6qmQgesAT5ryeqliWmSeHjzBo6rrfBEti6M/vMRmiSeNfuskrcKK+l7IANiIjzF0W/N85axVJmWERm9c/CO2+mQNM/bwP15AwbsJsBFIpAP4JereU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4447368B05; Tue,  2 Jul 2024 07:21:58 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:21:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/13] xfs_scrub: hoist code that removes ignorable
 characters
Message-ID: <20240702052158.GE22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117642.2007123.7226044391521696300.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117642.2007123.7226044391521696300.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

