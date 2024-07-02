Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE50F2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897765; cv=none; b=lX5S4T8H99FPxYm4bzjl7ThHT00hU1MBDQ0DXWwLe/ncgYQzc4YmCn+BB3e2PrBrVi1F94q+DfWvoE/+CEOXlEpHYK9MyDCeDc0xLu6ZnM9rdu8GRJN1k5tkExjQnVtc3XeLcgZ2LmBF1yc7N1I2NP+AF+59b8Zv83n1dJ7VqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897765; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXKVpPzNA3LekUcfn2zaW0i7SP0bBICDpvU5sPGnOPGHNniDJBef4HeDMBmjLzSzfHSOgdmaJWcYPzVNIppPOZZwlJSyiRCrus8mk0v2zSSlu1UGRF30Pj8eXUMFH4bXWxnpAvJ8WlEHhPufciH54eCTvtu/BUfgeYtAZrBXyw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2409168B05; Tue,  2 Jul 2024 07:22:41 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:22:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/13] xfs_scrub: avoid potential UAF after freeing a
 duplicate name entry
Message-ID: <20240702052240.GG22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117673.2007123.15647994096603486811.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117673.2007123.15647994096603486811.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
