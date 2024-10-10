Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6155C18BBB0;
	Thu, 10 Oct 2024 06:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543028; cv=none; b=PIJeJKs6VjhTE31AMFsBm3Fe7r7p0LtexAhuzPPvKvdG6rbd6Ag/3Qk5yZWDBH17eJlZVvyWhKbjSRKo56wT8R9ii4XTI0NpbIbcoI8vS/n09x+t1vrcloDtDHzkMBdDQuV3T0gmNQHAxgMtHQoDr1pLkYNOGbetI+hmHTIE4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543028; c=relaxed/simple;
	bh=Ow6q9UGmk8YI2hPL6uXTTWmf0xqRZBJKfWT0nD8tfeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXMoA47j4NCXE66OqeCH0AdpCNOzKVeaR9QEC9aHVvpu/EgcR+UarIlbSzkE6ZSO/m6hdmO7yLA1kLmnPfWPyqJ8Q1K4mKTV8zPnT+arjyN3p46nEUxBkgelEuDOHq/wRdqNtu4e24WOcDxe4X4IONS5hfOBH+ylU0xSF0LRUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23304227A8E; Thu, 10 Oct 2024 08:50:22 +0200 (CEST)
Date: Thu, 10 Oct 2024 08:50:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <20241010065021.GA6611@lst.de>
References: <20241010063617.563365-1-ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010063617.563365-1-ojaswin@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

s/deallayed/delayed/

>  
> +static inline bool xfs_inode_has_data(struct xfs_inode *ip)
> +{
> +	return (ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0);

Nit: no need for the braces.

> +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> +	    xfs_inode_has_data(ip) &&

This can now be condensed to:

	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_data(ip) &&

Otherwise this still looks good to me.

