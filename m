Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0791A12E1F9
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903446; cv=none; b=XfjhOZZQk0Otl8rnb+ZV2MvWS1Lw4EDNRm6eFi61dNb5umjIPGAuGW7MPuvHHHl06ucuJW/RtUpBRNfF8lclNk3BbXgVz7f3wRjkce1P7CrGFvW1OGhbhNrR8P38xVPLW/Xpa33ZylqwN2JB+gaZ6R7vBBp2U8TJ3DHCZdjIrIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903446; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oT5eTmuZ2mnMKBFlB+8MBaNuy0gY69qWT5XLIDHHqEaF7n2CSXRWANQuWulHiYp4u4q9GXcPX8iMZ2Fv/AeWfrcehWFIp4YJdwX7+QA056UZ546sxf98WwOCQ/wJfi+WEylA7avSYEQeIuhM/yiEiV2kIjx1r8C1BxsfzkqxnO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 271D068B05; Tue,  2 Jul 2024 08:57:22 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:57:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/10] xfs_scrub: split the scrub epilogue code into a
 separate function
Message-ID: <20240702065721.GD26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123196.2012546.11764956166230017274.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123196.2012546.11764956166230017274.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
