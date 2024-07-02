Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E4474047
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901509; cv=none; b=IcgI2Q+qIbqQyak0DOdvtCnm01DMvjGFeZtxaz05EZlLxJMPkIA9bpV0G5w99IHAr1rImFlB9QcgDCrioj/reVR/hIlXfza/FWIXwQWYKxJi3nrJ6fXXEuYzS1KjZ9sP0a6w+ZWHSArHpyRgX5uzhn+LJO7hKg6La6D5U2thjwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901509; c=relaxed/simple;
	bh=7RuP6lQtmdiO5XQgES/xAamUpzc7vVuFOeWWWx8wyPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N09HLglJGbsEJZZHPrmssO+CTpfLv4LO+1guECflYB7zRw+deJoWRlYwXmpQXG8uaSKVSGn/ivzKAgca4nMx+kgLl5S27+gRaNinFX5HME07PN/3EJwfklJGI0OUAhq9SmknifJtRAzimaQLRkAeDfHHs/pRWeiNPkH4p8LXmAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F396868D0A; Tue,  2 Jul 2024 08:25:03 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:25:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/24] xfs_logprint: dump new attr log item fields
Message-ID: <20240702062503.GC24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121108.2009260.6026012075133524751.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121108.2009260.6026012075133524751.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +extern int xlog_print_trans_attri_name(char **ptr, uint src_len,
> +		const char *tag);
> +extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len,
> +		const char *tag);

Maybe drop the pointless externs?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

