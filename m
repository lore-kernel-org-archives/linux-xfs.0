Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B732B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898945; cv=none; b=BYhacyDnmW4cTXzcp4uBVoVZMNgk3CsEyLCHhy7btZIOlfpPzLz+qi1BaLrYou2p3rBWllQCvr5Y3A03xU5J/lUFNduyMKgfrImKdKwEbPxKP4zKKpZV6A0N9eCSki3pf8Qxue7cMDWJkSBrTmGR26R+i6THk2sdAf0Hs5pbfkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898945; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KuUje+bzOeG+gtcCpyOXaIrEhvvVre/l5MR0Qj/sn5XncSeNLach2isWp6adl6bjVboklaBvpIoS0xVgEq4cT8EIUs1w2YQoEcFSlgFAtZ7Q39DpxeNBzov6Ysl67uz+CYOv8ljINS7HsnOA0it4QEjwtKrglXhdgugw6KHHXk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7A48768B05; Tue,  2 Jul 2024 07:42:21 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:42:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] xfs_scrub_all: convert systemctl calls to dbus
Message-ID: <20240702054221.GD23338@lst.de>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs> <171988119875.2008718.8969308689929459520.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119875.2008718.8969308689929459520.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
