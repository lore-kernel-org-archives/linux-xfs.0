Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7B382D68
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902304; cv=none; b=PKzgCva5FoxqWDGNC5C4biMKnO1uF53qD/wqg5st3d+flD4h11eiTLMRq+QN+4uNVZQyJQHpFl0zAfP33nP0IzAwvvZdawRVRjqhpHKkhJWke2rs0uaheia1Y+Rjx6Visq5HTH7Gd8pHrUZCvcohVSoCxHlo6Qtr6SgpZ2sZmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902304; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQjhxXisRlHiyrE161Joa9qZ/PlGk14TpW5o9WeHDP6Wtu0SgmVgeViBVShacLlV7i7/ykTFUwFlo/R3zlA8in5eEyoMYLxHZqRkKCDaS2+v8cbXqjEszgKrRYxzAQjo0snSc8L/hGEBDRB3kJvUvFlMPHd2aNtHPf+bmhUV0tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7825068B05; Tue,  2 Jul 2024 08:38:20 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:38:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 24/24] mkfs: enable formatting with parent pointers
Message-ID: <20240702063820.GH24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121434.2009260.2474734396646436248.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121434.2009260.2474734396646436248.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
