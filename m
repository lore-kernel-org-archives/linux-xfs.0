Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122C135838A
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403477; cv=none; b=C3E7lB83LzaLk8t6ubVgOHHKUyxkBRtiukcBemiV+GM7kdNnwMt6xVEQL6PDQhwCoKk8DjIOubd9o/byr1MFWRy/t4PE5nbRHnPFhnoA8wDCuSdeczLn2+mwu8yr4ysxTjFsOYkkLhy6DtExb8JWmk/n/9FrsEgqFcZkjd4qyvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403477; c=relaxed/simple;
	bh=CIbQIra6KopMf+Lxah6AH6r79Oc/RAciynGN5+LJTsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZoJ/DffUMhdgwoGkBsiuH6JzE08huqFbHNM1AKP9ZMBrhiHkiEz9A7T/PG2UwerE16kQikcleMOZtidBaCSZjffC7hLE9CLMH3u1wJk/V6bgmGqMNXYfyMB4MEU76IjlCgNJk/C4+Qov4djSJNPpex8T0+hlnzU34UqUOpBWXgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C3CDF68C4E; Sat, 26 Sep 2026 08:17:52 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:17:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/32] man: document the rtcsum geom fields
Message-ID: <20260926061752.GI20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-27-hch@lst.de> <20260925233156.GL2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925233156.GL2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:31:56PM -0700, Darrick J. Wong wrote:
> > +.TP
> > +.B XFS_CSUM_TYPE_CRC32C
> > +CRC32c as per NVMe.
> 
> Just for my education -- crc32c as per nvme is the same as crc32c
> everywhere else right?

Where everyone else is xfs meta csums, btrfs, nvme and the recommendation
in the kernel implementation of crc32c - yes.

