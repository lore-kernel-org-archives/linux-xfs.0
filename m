Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B84C81
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640143; cv=none; b=GRxyzpbZYvsPuMi3CCs3wXy5z0YLPcBNQqkcLgWh3gmw4P24St413KKACbRLabyIRFUQODcVxChXzH0smn7ERhMuawyI6QzRJFTFiJX52TeeDa9+2f5u617d2/S5jxIehSTd7+tVKclYmQe3mLmlFUvcInb9YfWJFtPaoF6pc2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640143; c=relaxed/simple;
	bh=RAYd7ln/DizxAfW9dLZPocS6YKj7EUKkRcJWRmIoDto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfS2BdbDyBZub/89CUeheZEO+82QvG7AVt4pmuU0R+3xsmor9YFpZqPfA4g1Sf92zE6nLh+5kHvcHvkUKS5GYobbFz+3QhSRhnKqJjxmj+c3d0p3C2iCM9NVgWabST23MF7vxW/GbxlTpXHIwS10WY3auEr3mCvUdsfAg4QiHtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0CD38227A88; Wed, 18 Sep 2024 08:15:38 +0200 (CEST)
Date: Wed, 18 Sep 2024 08:15:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <20240918061537.GA32028@lst.de>
References: <20240910042855.3480387-1-hch@lst.de> <20240910042855.3480387-2-hch@lst.de> <20240917185054.GK182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917185054.GK182194@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 17, 2024 at 11:50:54AM -0700, Darrick J. Wong wrote:
> Might want to rename this new_agcount for clarity?

Sure.

