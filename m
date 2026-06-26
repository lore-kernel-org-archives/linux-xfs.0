Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97136279329
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 05:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450306; cv=none; b=WkXzlGQXb60QpLEQFrjXCgYjWirtsiEMh4+AVlZojRBfwTr5Sht+wd64qPUvt36lHsufk/KRmKP6gORS+hEksHj6jLrBBe4RCxpd4p6SEUIEu/wV1lpniCI+57kyeuX3//FJG1L7Udz+Bk9IjpeQT1LtdfDyObGaq2f39254uLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450306; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IB3y0fvMLZ+mm6HA44hDotwr0BJQv3GTkGqY7AovOkRun20UR9egsSXBfdk4AeekmBxkScQoeL4rbWl3f33T1J5O/G5sbCrTs3+S1fh88cyBXpu7XFgrfXZYCUaNXRifNKnxAx8QGUKRqamyhY96IjDBsJoEEe2USCzCuSbtwxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 254B568B05; Fri, 26 Jun 2026 07:05:03 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:05:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/8] xfs_scrub: fix phase 8 debug reporting
Message-ID: <20260626050502.GG8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801433.1981574.13587205107962897238.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801433.1981574.13587205107962897238.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

