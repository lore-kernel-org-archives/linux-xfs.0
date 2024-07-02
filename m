Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753B2C861
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719896981; cv=none; b=EMeg8C/LqfC7mGqs3tdCwWOfg33zN9OWgmeJW+Key+c5TgfIFTR4/9g/URkkq4vi+YE670uVTgxbueBC63UfViBS1LLyqXjo+7Q2pLVNrteLpZNQWAHM5itDJWdYTjJh51qTu1s9w3ZYoPbgfzvWn3Rfg25DZ1LrodCh+viXeTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719896981; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RR0JGdnR/9S0P7LVthFhtO5z3RPY312cqor0WeZpiYm6wYura6wbmTQ/6vys42U1RYkvHIY2Q5xZSKn7/VgMiFZ07kxEk3ugx93fFkOBciMxcX61iBdsxvBTpP8QKsc/54W89pOkYIX+CfrZq/aU88X7zrKso2B09PBexETzbDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8628B68BEB; Tue,  2 Jul 2024 07:09:37 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:09:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/12] libfrog: add support for exchange range ioctl
 family
Message-ID: <20240702050937.GD22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116771.2006519.532946760546599337.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116771.2006519.532946760546599337.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

