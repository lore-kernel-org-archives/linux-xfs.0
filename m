Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A14B62572
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726640158; cv=none; b=Jc6Tz6JUh4smgZJQH/PGIZ/ifWDadJ2aknBfAusVw/4G6chvX/eTpTbGeUTUndC08M+H4my2X9g6V9E7iKcDlnRnmNZMvefxDKWcqUpjS6Gl104xbXor4NT/+a8BWyq4LB3MKf1Hwqi3Xus5gzfkKDBeKTLgP12vMD9jEI+WusM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726640158; c=relaxed/simple;
	bh=3OsAvdbxfn9CQX/zMZi7yyOvBbBgoFles8NsE0PNREQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hExriJJp9MxlPGeu3LBXjqkV6K3alZKyiMswE4kWiktgmapXFBabTPtWsPUn/03X2V9hglGhl1MMo/wT5W5CFEc+YmkzDEinn7luVnuwF3d09HXHJoceXu0aoZMjUlnxMKAU317Df1/1JBcgtdnT7MUWytjrdy2Q32yhu6ND5/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E9F7E227A88; Wed, 18 Sep 2024 08:15:53 +0200 (CEST)
Date: Wed, 18 Sep 2024 08:15:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: merge the perag freeing helpers
Message-ID: <20240918061553.GB32028@lst.de>
References: <20240910042855.3480387-1-hch@lst.de> <20240910042855.3480387-3-hch@lst.de> <20240917185556.GL182194@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917185556.GL182194@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 17, 2024 at 11:55:56AM -0700, Darrick J. Wong wrote:
> And I guess the extra xfs_perag_rele is ok because xfs_initialize_perag
> sets it to 1 and the _unused free function didn't care what the active
> refcount was?

Yes.
