Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D023B4EAC;
	Thu, 10 Sep 2026 04:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016227; cv=none; b=XfKgUsh0xERCMcoHpH1ALaJvdeM+UyAAIBCpVxP8SqEoPqrVhu4vhBuVpUwTivOVIp7jDqKrzzeNsEOAaPZGgq1a1UE3LdTjRxlvkxFPMpZjs0NrsFYdnvOT2kGMBx+4SOJ0rrNe3OXhW/Nm9JaZ1sV/IHH3zqZZlRvg7Oxh8S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016227; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XrhrfopwySgypIb+/DxbKK1frJq05DB21Odr2qCg7wERAe78lTIwRyrlPV1wK4zCagtj6IvCa5TJY6k3K87akmVww1A8KdaPma6ZoemS2XcRFvoa+bhQPUgVrQ6XVhsYQ9t/vHOsW62vAecXYyXEv2eo7wUn/ZYYfGOfk9dfWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2631568BFE; Thu, 10 Sep 2026 06:57:00 +0200 (CEST)
Date: Thu, 10 Sep 2026 06:56:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
Message-ID: <20260910045659.GA26687@lst.de>
References: <178892936145.4057682.2272084577851638021.stgit@frogsfrogsfrogs> <178892936205.4057682.11929830543923107453.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936205.4057682.11929830543923107453.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
