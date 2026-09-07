Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951033563D4;
	Mon,  7 Sep 2026 06:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788760921; cv=none; b=tKrD6WCjWRCatcSDu34S6OkVvbL6jsQCbDDat6agz5NTBaaR8LJSnA5c6Smmwg7Tv8ZnAgDgSYZQX0EC2hBmMDO3S2icY/WHFszrtBG5mG9uZFI4/h2YJGNrn8uk2fM6m/IOeUwLTRCpVxQPKyhYwkNGiDHJHfETuxEL3PkV8ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788760921; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UOA8Fi+p6VwPTJHZyvUJW+y0CTnGtUXQLNq22UQelvgTY6tnBlseqdZ1CL/hz9rJSCiDH0Lg5KPvDjN8F6/tk0FRzRsq+0IDOstooBOHxbhKOfPE9mxElIZ5PEDhXbZmEidDW+dvEUqdLWtLEXJFUjeZ1HqIWOF++VM2mCOLEcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C2FF68D09; Mon,  7 Sep 2026 08:01:56 +0200 (CEST)
Date: Mon, 7 Sep 2026 08:01:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1.1 6/6] xfs: bail out on bitmap errors in
 xrep_agfl_fill
Message-ID: <20260907060155.GF31753@lst.de>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs> <178850312625.1198660.12540549019476735065.stgit@frogsfrogsfrogs> <20260904161302.GC1933798@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904161302.GC1933798@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

