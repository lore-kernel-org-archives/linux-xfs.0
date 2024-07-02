Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E462A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897926; cv=none; b=Sbch3R+gGgREgjD2b72xdQ0xAcvCt6jVpVfmayKWcNaqpKucZWAgiR+83hHsQXStowUk28H3LjTQhGI7pA7LQxDW9eNlkhiPutFvm6S2sxURbOUq5Og/90FgdXc7yMGyL97ukD0BwVEjzGmc3+xd465jDYHznkbthBxPaBFTrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897926; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hbWpqlNeDzx/B0pWCooIeojDfl/VLuKSGZYDEjRhCP+MqDU8N6dKdp78fN5vDp+29ADR1s/piYniwxAdmHPtsi1W1rQgNcu0FkjDhLUxNwHhDR57HRqNaqQL/oSznrrWM48foarY3Vm0c6XeOTWWFFx6YeteSNYfs61d7JUIdEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A8E2468B05; Tue,  2 Jul 2024 07:25:22 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:25:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/13] xfs_scrub: report deceptive file extensions
Message-ID: <20240702052522.GO22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117794.2007123.11468032897655925875.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117794.2007123.11468032897655925875.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

