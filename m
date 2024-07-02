Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556A02A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897460; cv=none; b=R4MnE2stIpjgyZgKppOfTFlocPbA/V5hYICoQ7bSzV4tO2ERRD3Q8NcLCoju7NrtUmCzmLwSQimNAni9bdAvi0mYtfHdrEOsFinkLXzflBMxt2MUKDLYZAvKNqzJj45M8CT020Zx1bgU68/KnnZXX0dNZRN9w3PaXg9hxEG3VYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897460; c=relaxed/simple;
	bh=M8EJeG/HeLojUwyRtVsX/iPtQs1KJHPYjA/PlpeDwD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4beQVNDRPgC7+RuHqJH5aEEAGURJiUxjdAjp8CsNhPP/yrkCTElY6XsRI12QHuHd1AOv6XiAYH94CyiAGVInlAnGEUp8aCUyNCYC9h/w495OtQVpZNE5yq3WkA3u/1s60GY31SCmeEcCcxJ8V8Gspgjwq+qHw+wqIacfRw1w1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A873968B05; Tue,  2 Jul 2024 07:17:35 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:17:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] mkfs/repair: pin inodes that would otherwise
 overflow link count
Message-ID: <20240702051735.GC22536@lst.de>
References: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs> <171988117270.2006964.11531106267384216498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117270.2006964.11531106267384216498.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 05:57:23PM -0700, Darrick J. Wong wrote:
>  	case sizeof(uint32_t):
> -		irec->ino_un.ex_data->counted_nlinks.un32[ino_offset]++;
> +		if (irec->ino_un.ex_data->counted_nlinks.un32[ino_offset] != XFS_NLINK_PINNED)

Avoid the long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

