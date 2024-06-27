Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5FA22F1C
	for <linux-xfs@vger.kernel.org>; Thu, 27 Jun 2024 06:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719470286; cv=none; b=lAQh6Jru/jZKmvdTKRahgYpjzbqbe+UnF0+kMqFPmJfm8Fqf7sOAErV33eNQV4ubV/x6zYPlacEmb6AXJXqx08057JTGvFfSn3Ln0lL0ceLuCe13A7n51cHKDLbwqvwB9zBu3zvDJ34T6g/Zg7o4c0K+fKu4JiIU/0+c0d7Vtqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719470286; c=relaxed/simple;
	bh=HIsr3p129+XVbKclUFtM2kuqB9dMwO0NKZnwVD3Ppiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vpfq7tZb+g671SuYHLyOIl9m9R7qkZG+UolYzaEx8+pDB9XUdedcx+G/Ab2sJNcFVjpXqFm//xmtpSOvmE5PnrKbxK4QUeaflC9NzUW1UBwqU8fK2YjFG5yCO+DFqU4gPnG1JoXg2NU/HDpdmgIxg90PsU3XuwyhUcFnMmOy3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 546C268AFE; Thu, 27 Jun 2024 08:38:01 +0200 (CEST)
Date: Thu, 27 Jun 2024 08:38:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Konst Mayer <cdlscpmv@gmail.com>,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 1/1] xfs: enable FITRIM on the realtime device
Message-ID: <20240627063800.GA16609@lst.de>
References: <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs> <171892420308.3185132.6252829732531290655.stgit@frogsfrogsfrogs> <20240624150421.GC3058325@frogsfrogsfrogs> <87y16qhp4a.fsf@debian-BULLSEYE-live-builder-AMD64> <20240627063538.GA16531@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627063538.GA16531@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 27, 2024 at 08:35:38AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 27, 2024 at 11:43:42AM +0530, Chandan Babu R wrote:
> > Darrick, This patch causes generic/260 to fail in configuration using a
> > realtime device as shown below,
> 
> It'll need "generic/{251,260}: compute maximum fitrim offset" from
> Darrick's xfstests stack.

Actually that one is already merged, it needs

common/xfs: FITRIM now supports realtime volumes

on top of that.
