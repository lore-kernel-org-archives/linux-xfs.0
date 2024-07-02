Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBA626ACC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902619; cv=none; b=dvkIFhycPserfPNCPrhDSBqxnSx1zb05+rxPykmbXmTV2OiHjUtlICQ/9iPHjQqgKKk3YmT/rvcdHk+7A7BZY8V78lHMHV+odOyNbL5ArUeqRNOvfCDZg4plihI4ZqabVHZtPtOux/64vpfAvdz8bWMo2xQUJeoOh8H2F6jVcCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902619; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KeMaGR15eksE0PKm2Gul0kUxE/rEUlUarw/jq1igVnh+K30a8nHDnbx2QKIU39VTJggGbxbCeuRQJgfDuL1mKoTeQY1nG1qi4GREQIv4ik+xhDsapFd2+Td1fqpQXWkFRFW+VIK5odR5161DU3RA5UVOzzkpz37aKKEDECyArRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D8C9368B05; Tue,  2 Jul 2024 08:43:34 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:43:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 05/12] xfs_repair: junk duplicate hashtab entries when
 processing sf dirents
Message-ID: <20240702064334.GE25104@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122243.2010218.604571260560807315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122243.2010218.604571260560807315.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
