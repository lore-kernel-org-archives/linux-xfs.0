Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03A3383998;
	Thu, 16 Jul 2026 08:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189978; cv=none; b=QgZ8rexwk/OoH1W6YTvv2x+cwPiLTLPZDpmPDcPUYgRfuBoOki20yf/w00Rswm6+aUsLWUaO4LoRqZLbWQ2DyCbT5QWmnZ7HxLjJPVmqKIfUTsf1bsm/mPGfoELFUrnM8PJlR0brmxGKxxessrrNRy2i8F7YiHj4426r9HRT3BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189978; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AcgFaCLVlnmWOI8yT97ao6YKUa0KllpQy7SikjANkkP5CulC7Vs8Zm90SzU3hkcRCsAmU3VnLjfbML3ZEI3BR8X/DAaljqITsk074LL69/oF9XbCLnhjRaoMq4QBVCQWjmSfbhoO0wAoevdUrCDIwsIyC5QluxNtK/XSKR8ijPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 510396732A; Thu, 16 Jul 2026 10:19:34 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:19:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: zero i_nlink before repair puts inode on
 unlinked list
Message-ID: <20260716081933.GF12330@lst.de>
References: <178416797326.2008054.12517273271060887961.stgit@frogsfrogsfrogs> <178416797445.2008054.14130559349245162334.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178416797445.2008054.14130559349245162334.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

