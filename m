Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81ABA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902708; cv=none; b=gLmLVY39sOZuE9fOYcLx3YSm+850mE05z9AVVYmKOlhpvRnKrW7VarMso8LcFsN6Q3oCgQTXHQSZZ+/xIxRvtoIxaSQTne00hBARxaHMSNHZ0nqlvbMv9xmDDOHrv2VRZesQJn3H40tDaSKLpCI5b9OVFBJD94gUR4H4ezg/qsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902708; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhf4wyaq6PkXBUlSHD/1nnvIu44M3kzcNHS0wJsGpQTaOWrkqNfW4jZdB1DmvEuZCEmrxjQmuk5WK1AmDn93H7ltDpRmRrwYE54tCDbIAfhkKIV6pwDl3nkvrTMDOTHqnABQSXfyL37OryHueJEzIZi6vYqKi9pjlZTwJ3QE5Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70CA368B05; Tue,  2 Jul 2024 08:45:04 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:45:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 06/12] xfs_repair: build a parent pointer index
Message-ID: <20240702064503.GA25370@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122258.2010218.748165248811754209.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122258.2010218.748165248811754209.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
