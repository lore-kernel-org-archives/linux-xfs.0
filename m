Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007B337165
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 03:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724298027; cv=none; b=h/iFmFmoZsoAMei3UJhkyCCgC8aL4//AhSzSeo64A48SHhPQIOaHidIhTbmsxHm7IRzTRfHhr7ExtP0ZKYmZmfz3E3DGSyZZ5n+FLPEicEQK7Igne2M0vq37+KHxVSTJq6DCOQWyvMx3urCtdRfdRbNCMbV1jEFycEImQEYJILI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724298027; c=relaxed/simple;
	bh=/tPElbzHdYRmSQObJWWLLdjU0BcGCko5/xSMpAYjUkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7udoFxmDpaOuTfYHK3WtLXCOGRh4+H7E4wUqrhQ9AcO/gch2FfT9PrzkGtpefdEGw66SbkTR/LtTxLstA407m29jfnX+ZQ58ZtSYrFTzEg4CYlazo4XJLJAIDx8w86AyrHZ+FQ+rOUABG0mrdLitsEhcojzDrg/fYngUJtnG/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 05992227AAC; Thu, 22 Aug 2024 05:40:19 +0200 (CEST)
Date: Thu, 22 Aug 2024 05:40:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: distinguish extra split from real ENOSPC from
 xfs_attr3_leaf_split
Message-ID: <20240822034018.GA32681@lst.de>
References: <20240820170517.528181-1-hch@lst.de> <20240820170517.528181-4-hch@lst.de> <20240821155736.GX865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821155736.GX865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 21, 2024 at 08:57:36AM -0700, Darrick J. Wong wrote:
> > in xfs_attr3_leaf_split caused by an allocation failure.  Note that
> > the allocation failure is caused by another bug that will be fixed
> > subsequently, but this commit at least sorts out the error handling.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Nice cleanup

It's not even supposed to clean things up, just to fix the incorrect
error handling..

