Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8936A12AAE0
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708560; cv=none; b=dmzfvTANnZYHYY1hCOG8uvNRHxRowJf8eDWRSeArCu3gpFASTXWF5EiRYDRDIKjF5IyKeRiq1KpmN432E32u/FdSu7QgsArZ5PIA3MKRHr29fh6wsCRVwF9U0JfoQ33UOJgfS/sbY/MUgRVZ5VAuk3CCyRZh4I14iJMWh45n66c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708560; c=relaxed/simple;
	bh=lht8w7CLmtnChedegxi4wNzbvzg8OCv825rHaDzwaGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k+Cct2GUSg96k/896UWdqkpxf/YTRNE4VfN7M7y5Pdhuw9IKCNCeMpKPBYZcUbYAlThi4phS3IXl4Zkf19b7+SjL+EKyIfIZy2dgMwXpX9ReAzrf+bFnpClZzxLt2DdAjzFo59AX46VxMeTobSOkmeakicdRBjtyY6xIlcz1oyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EB57968BEB; Fri, 23 Feb 2024 18:15:52 +0100 (CET)
Date: Fri, 23 Feb 2024 18:15:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: cleanup fdblock/frextent accounting in
 xfs_bmap_del_extent_delay
Message-ID: <20240223171552.GA4579@lst.de>
References: <20240223071506.3968029-1-hch@lst.de> <20240223071506.3968029-7-hch@lst.de> <20240223171324.GS616564@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223171324.GS616564@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 09:13:24AM -0800, Darrick J. Wong wrote:
> On Fri, Feb 23, 2024 at 08:15:02AM +0100, Christoph Hellwig wrote:
> > The code to account fdblocks and frextents in xfs_bmap_del_extent_delay
> > is a bit weird in that it accounts frextents before the iext tree
> > manipulations and fdblocks after it.  Given that the iext tree
> > manipulations can fail currently that's not really a problem, but
> 
>                 cannot?
> 
> If my correction ^^^ is correct, then:

Yes.

