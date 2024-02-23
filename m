Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23F12FB22
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709414; cv=none; b=qXL5weKBa8xxBRiSVpq8lPpmLjyqMGn7EootxNSn0KM7QVvZBO+GeSJ8I414CqN/xcb98gA9z4H52eO/hIKJxS1F/XeBqXUa7iDsjX92bSvvb/o4RnSz/XGTsfM7qMpjLYsUfC+DAzPewHCMfBzc2agcz9QHHOHiBk+Akhjm0zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709414; c=relaxed/simple;
	bh=MkHlQpLlqfP0xfQD2zvPB2fo9ynczCE3Du0wxKixgJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9nO4Pc+Ww2e/1PzruSnnb47Pu/cInfn/tS3LuLVoUKiqoECbStKRSs2xczFlmg7/z0HkPoHH6Ub3izqjx34P/YdxF0uaKnSRE/dxS76T81Q2e7edCiloHkQ3Rmq/xFOst3TzjTuvV5tzVt6925J89qaJFl+NaSn44P9tLQw6nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CA8F668BEB; Fri, 23 Feb 2024 18:30:06 +0100 (CET)
Date: Fri, 23 Feb 2024 18:30:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240223173005.GA5275@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-8-hch@lst.de> <20240223172028.GT616564@frogsfrogsfrogs> <20240223172220.GA5004@lst.de> <20240223172931.GY616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223172931.GY616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 09:29:31AM -0800, Darrick J. Wong wrote:
> I prefer that all the rt space counters have the same measurement
> unit to avoid confusion later after we've all forgotten rt again. :)

Heh.  I'll switch it.
