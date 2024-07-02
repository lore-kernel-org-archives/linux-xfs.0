Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE2E5A7A0
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901465; cv=none; b=XSF0L4HGZjZbPzgESSgVO07DQvupeBxL/hKYyQTfE0fjYUXzrxpk2wXVRkbL1yfp2slnGBzEZOxjcP2lixbKFmQhq18UoV0nMwCVL6DrIbVVTkGRp/I+psW7fuLU8f20IDxw4RElvTm1l6qiQbhBTkhEa6kIm7gJbeKRFGZWSQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901465; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dv/hk5dQ99L48FzH+pgjU7/phFdZjcH0s90cHL3sFopt6PJj8vE5FKzVUrNCKGI81Ji62Nyad0kngcQc7UslbI+NpQIm4Fiw6tM3pl0LXQvIEq0j749RSJ5ilIm5NyRTQ3fTXMT4wVJwGXybqoMJRYX1hJOQkVhN5yF33CQ8szs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 37C9868B05; Tue,  2 Jul 2024 08:24:20 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:24:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 02/24] xfs_{db,repair}: implement new attr hash value
 function
Message-ID: <20240702062420.GB24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121093.2009260.4332172990916225703.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121093.2009260.4332172990916225703.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

