Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3422C12E1C6
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902486; cv=none; b=fXadasuNQKUXQ9RIFY40XkdeLnLJwAvLkaDqXId6NQ9CQX4iKNMAAgDdsOjGQU1EuzDL1LXEMoh4ZNBp9KoYyP9cik8U0f3pUw2VLeaiCduhXpYdsO7/QhSuFb259obfwzSdNNWYy2cTrHBl1jEQycYZ1G/Z8zmVHFAQ/u3VTEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902486; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NpYWFWTZMp3rzetm/fbYtghHCMmhdka3DEWpuZUOLZtwHnWWuFcsIf8rqAuFih6UnFHmktLkQUyNG+GJx9TYuPHeUHavmKF8VWpH/oQIIvHRCpaeZ9rFBhP2AZCAnCNi/670xvQoV1n/GeoA5TNZBTdY47f2NldfVATmAmGIx/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6252E68B05; Tue,  2 Jul 2024 08:41:22 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:41:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 2/2] man2: update ioctl_xfs_scrub_metadata.2 for parent
 pointers
Message-ID: <20240702064122.GB25045@lst.de>
References: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs> <171988121805.2010091.649906778403805436.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121805.2010091.649906778403805436.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
