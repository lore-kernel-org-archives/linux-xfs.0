Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A4E5C5F3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902983; cv=none; b=f9e3L6dVzHFnS8hMNqZI7g66vluOt3NufQOlAre7lsD6C/TMGWBifBqzydcWZJfSp4XzycJBAUnHv9VpmguC1gfQiXDdMAorvK2V+rlLn8oSIe84UkpqRF+iYB1wHJgQQuSNYtn97O2w2DIq5wMSH58RraSqn/Z7laaH2hk9QOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902983; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7349UzRNppXRf++Tsv8T24CC/bS+mEnr7atsYjUl2C8am7XHgjYKVmcUsrvD4sf8A+q0YnZUpcBTWOHSdKF2xRUFsmGnH1OPGVggXrnxqN/Sx6CYfhHWHUlqut+4xcEzv7/xXkogT/TjaPrcufseu3W0kTpq0DQvckVtHBpU3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A42F268B05; Tue,  2 Jul 2024 08:49:39 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:49:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/5] xfs_scrub: defer phase5 file scans if dirloop fails
Message-ID: <20240702064939.GE25817@lst.de>
References: <171988122691.2012320.13207835630113271818.stgit@frogsfrogsfrogs> <171988122772.2012320.15047134515177396515.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122772.2012320.15047134515177396515.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
