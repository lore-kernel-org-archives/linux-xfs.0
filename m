Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EEF28688D
	for <linux-xfs@vger.kernel.org>; Thu, 30 Oct 2025 06:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761807286; cv=none; b=A4x52rvzd7LBIl4A8R2qllQ22LI7pr5qQU7p14ZR4IbgjaR5nWp9W6dLC8ikyVigseFcD5eeVvoNe4npiaX6RNwfmo7Y7UTwSr9I6mUj/eKiIgKcj4Ew2nwktV9QvbIFzaI6fBdsaNjkPP24B5iJqekCjk3+BFQPyAa4RbNHM/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761807286; c=relaxed/simple;
	bh=ZSfxP/PopOCBp4jctYLLV9iMsALVs3smMV2tZoMbo48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cy+Krnjx7pzbB017qT4f4/X4o1iXWR/tyAYBArQCxBR9jKEFtOK7P5J0fjJKgAFmunYuNfvtoKJ2VR0L5QIme3YLuGpzlNkmJthmTe6JyAfmUxqDhj/8tzvW/qbQSJAvs6LWw0qTng8Xvux1lL1SPpyVL8qQh1mBQseypzoOAnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 217BE227AAA; Thu, 30 Oct 2025 07:54:40 +0100 (CET)
Date: Thu, 30 Oct 2025 07:54:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org, hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix overflows when converting from a count of
 groups to blocks
Message-ID: <20251030065439.GA13617@lst.de>
References: <20251027140439.812210-1-hch@lst.de> <20251027160726.GR3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027160726.GR3356773@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 27, 2025 at 09:07:26AM -0700, Darrick J. Wong wrote:
> >  
> > +static inline xfs_rfsblock_t
> > +xfs_rtgs_to_rtb(
> 
> ...especially since we're really not returning an rtblock here.

What would be a good name here?

xfs_rtgs_to_rfsb() ?
