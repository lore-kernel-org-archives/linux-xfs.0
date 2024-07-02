Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4DD4CB23
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901721; cv=none; b=nb9Yq7PHkF4cm0v0fCqrnCWakTou8JdlHSLLfYp4Q8fN4WnPPXzCJ43zvbiEKqxjI6BbvNAvOywCVn8eCvyfQ69PDKR5y+XwlwcwiAmzlFni+S0K6PRKHUTw4pJoOt4VdbPOvqgFYnPkivehc8p4dOaQV/HHGXC/ubBqVRZSEto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901721; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcimWlAJJdo0pwExgvLeEY+Tk5wDZym/1BYHHHKoFTOpjtU8r1LxOIPZCNLh2Xiq+wOONWxgN9PXmrdd/xOevRkoKZDZEGaaC6pHnnQv85KjNTMgqYA6x/MfpcGruWVQEee0aKcsiLe0mdSzdcD7j6BQo+eNgo1nfSdTNe4U0o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7184668B05; Tue,  2 Jul 2024 08:28:37 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:28:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 14/24] xfs_db: report parent bit on xattrs
Message-ID: <20240702062837.GN24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121279.2009260.4036237222136719544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121279.2009260.4036237222136719544.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
