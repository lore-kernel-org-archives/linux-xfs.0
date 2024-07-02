Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DEB2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897836; cv=none; b=kkNhlYQ33jam2OKipImh9eGxVzIe4wcEOM9osI01LnMTH/eUvt0qFYO7zKKZMGTVhBNlCvrAPpOU8InOrLQLRmiZ+U4pNRhM3x1+xnDHJMw7L6BMOhNPpp6xr8aNNd/Hzm1Zr46FFbAZbm2Q98+sTHySXRwGEid1J4seO0cBhNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897836; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hYPBxF0HvpktmMXvhqgyrfi04c0x+zfvEYMdU2q1GkOJufpyfgqykFTwt/PEmVu2dTfdR38+ULyvpKV6ntNZ+HrxrKf6ru1ZTcfPLLWYQhceFJsShLlbRmCrX7QpK8E4A5VsoKpMWGvtylTJJlYv+ugJrpU3fts652annP03Xjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A47D568B05; Tue,  2 Jul 2024 07:23:52 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:23:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/13] xfs_scrub: rename UNICRASH_ZERO_WIDTH to
 UNICRASH_INVISIBLE
Message-ID: <20240702052352.GK22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117732.2007123.5575573821176131888.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117732.2007123.5575573821176131888.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

