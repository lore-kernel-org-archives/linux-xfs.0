Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0183D331E
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389209; cv=none; b=PqgQNT3zRmDbdVR090OOe7ZUUwN2j650OcfGV/wqb/+1SvBqzdLy0vSRv9O7o5YDe6c0mp7kDqcj01718gTIalID+3g6riijC8V+r5SEjtWTwoVprhln41QhaLilzcAZ9u2KyUMBnaACYBd2Y2hfZiNJR4DmICzsLHjiUvhYcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389209; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mg8fQB3Vlhh8RYhhPfce8Ij4sC2Qy33VLm5bcOLTmwemFNaHncnscXsneobcRMBG90l7Q7tutscJaPRtZfPhVROuTPqJJtDxXqMYsceUo9HK+Nz8tXxGNtGVGu0Nk21vAU4VHeiEPL28suHZZDRbThtnqYtm/3z3OLHD3QsurJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0679168B05; Thu, 25 Jun 2026 14:06:41 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:06:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 11/11] xfs_scrub: warn about difficult rtgroup repairs
Message-ID: <20260625120640.GL18766@lst.de>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs> <178232484642.915780.8781362549550547648.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178232484642.915780.8781362549550547648.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

