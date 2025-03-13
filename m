Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723220CCDE;
	Thu, 13 Mar 2025 07:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850697; cv=none; b=QFruZeuPmlgk9ru9gApXTDcN4PnhE2mUSf8C4lZjyk5yCNFVztHhWLdnkvyIZVzCasaLrdcnAMd4W20BSbj1FDWE0QysM7SI3p5zFA8LkL6tzfN9zM/sWBFtuPR4MVPH9ITeZSBHAa03w5V2Vbo2deYfnAzy5Ee4+Iis6xNCRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850697; c=relaxed/simple;
	bh=Ww34CMs6kgB+2H7ObQv8VmtjCa4uh1qFN9lUy1TlZgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cdU4Y6mpWiHOIxjMeuYFTn/amElHA+Ga40nxAp4AiDYTPmsGwFq+p3zo//0RVF2aunBVVL5XZswZSLCdi6QrD4UY8Ao5WZZRi/nE/0pi8J6I6Bh21Bd0nu85RG7XA0vQXuoxNJX/tLHV/Vz5PKJqlnZxcwOiom8K3I/V1+nLoTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1516468D09; Thu, 13 Mar 2025 08:24:51 +0100 (CET)
Date: Thu, 13 Mar 2025 08:24:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/17] common: allow _require_non_zoned_device without
 an argument
Message-ID: <20250313072450.GB11310@lst.de>
References: <20250312064541.664334-1-hch@lst.de> <20250312064541.664334-6-hch@lst.de> <20250312201036.GE2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312201036.GE2803749@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 12, 2025 at 01:10:36PM -0700, Darrick J. Wong wrote:
> On Wed, Mar 12, 2025 at 07:44:57AM +0100, Christoph Hellwig wrote:
> > That way it can also be used for RT and log devices.
> 
> Do you mean "That way callers can pass SCRATCH_RTDEV directly without
> needing to check for zero-length themselves"?

Yes.

