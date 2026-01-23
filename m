Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E343F274641;
	Fri, 23 Jan 2026 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769177657; cv=none; b=sICwSIlt2ml2XQH/rmAhyWLgeeGfn9yix2GafpVRkq73kJE4rpW4LMhOcQKlXNu37rgjYpy6IfjHlll3nCaqaGk0/mSionQTq4wWNuhlqScWoNVlrGtMW09AJdL1z9LAHtth8KYXQQUnGqvR0a1qEAT4jTqLDp2bhl6sYOCsrTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769177657; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tuaLPfBmHBnVu5JXJQYgBIsg9q9QgLhgaVzeML2+D2vMza+Lp56DsR3Ar33pcAgs4kYV+IrZ1E1CZH53Mvzk6/biHjnCndvMwX4RH93mxKvL7TEcPbZqjNu6jDyRugzBzRtGtDBfGMaEp97FIFGACqzzGIghZ+3sUjFP427xtaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DB02A227AAE; Fri, 23 Jan 2026 15:14:13 +0100 (CET)
Date: Fri, 23 Jan 2026 15:14:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, r772577952@gmail.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: check return value of xchk_scrub_create_subord
Message-ID: <20260123141413.GC25834@lst.de>
References: <176915153667.1677852.8049980969235323328.stgit@frogsfrogsfrogs> <176915153761.1677852.10364914654449283291.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176915153761.1677852.10364914654449283291.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

