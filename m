Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20C63C2D
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 05:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760379; cv=none; b=kg7sGBPBm8TUXXxLdXqg8PJSHy0y4NcQSgcNtNQ69OcnUxAlexf37ihuL7aL2KQscwfETpzjsBzSsgR2uZKYCxYktetGq/UWQnVqyp4FYhZifGdERXtF2Uulbr2O3pUriCOKpoZOS8vent5P2/eOlglDALhmtNV3mv6UySWRuFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760379; c=relaxed/simple;
	bh=IZ98QmtCbCr4VfwQzsBo3EVJG1+rOf+RWy0zwowJl6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LQHd+uQB8Q4T2NsukEXfzj+9BmvNLY/xeEgQ94cV5ilkMNqlxYZv3J8xxTbPWq+FgBrdpEDhxrX9aYFiQsT4OLsxkzoCByWL1GStCfjkotwIhdecInDb1xCe1yE4cCWpvN10XIDY+4c+vBQfPDIhoUkSh2bE41YyCtIKSW2ZA4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C75568D05; Mon,  7 Sep 2026 07:52:53 +0200 (CEST)
Date: Mon, 7 Sep 2026 07:52:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, bestswngs@gmail.com, brauner@kernel.org,
	cem@kernel.org, chuck.lever@oracle.com, cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn, djwong@kernel.org, gaoyingjie@uniontech.com,
	hch@lst.de, jiapenglin@tencent.com, roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: Re: [PATCH v2 00/23] xfsprogs: libxfs sync for v7.2
Message-ID: <20260907055252.GB31640@lst.de>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The whole resync looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

