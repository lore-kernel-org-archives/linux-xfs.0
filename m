Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1A4801
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2025 05:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736918567; cv=none; b=QEZv1ajK7Ws7OYUZRLwH4cyvPVRO68bcHGXSeTbx2nHZsogQYmyl+67x+hu3LkDBnl+VsDKrP95SHO2Ps9Yw3DtuxT3Eblj2eS1CQxcI8SPPIsDtUh/K8DMsqP7QQH2K4c6da1aoSp6tGuATE+n3o5sBsdjn6d9ylrry0zsw+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736918567; c=relaxed/simple;
	bh=k7DXwJEx2+r/DCCNZoNpY0+QSBGfjzjB3EgGBPLrs1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EuhdV5MvIPMtePpym7CDKRu4YjlJABk93whaPh8DGaZuyXirugEkOxX8kO4ipkKCi7NXHK2uTAH9wOpbP6gwZjQnYMWvLxfc6ZGlQXEsWPWF6ARQWJdDAW1QYmU7n1bEEwUzJMC91lLjx8WTiZa+xJZAG+GvleUZ6p+WFuy/Jyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 02C8E68B05; Wed, 15 Jan 2025 06:22:42 +0100 (CET)
Date: Wed, 15 Jan 2025 06:22:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] mkfs: allow sizing realtime allocation groups for
 concurrency
Message-ID: <20250115052241.GE28609@lst.de>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs> <173689081956.3476119.7466311188976179968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173689081956.3476119.7466311188976179968.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 14, 2025 at 01:41:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a -r concurrency= option to mkfs so that sysadmins can configure the
> filesystem so that there are enough rtgroups that the specified number
> of threads can (in theory) can find an uncontended rtgroup from which to
> allocate space.  This has the exact same purpose as the -d concurrency
> switch that was added for the data device.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
