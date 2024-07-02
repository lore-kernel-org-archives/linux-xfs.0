Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2162BCE3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899002; cv=none; b=DxZpDPvyhhOXefgsLpv5LxNCRiGex14nARFUYQU6yi1jfj15kKtY8SIG9O17uSRvZh1yLTKGMT3U5qf517Q2roEG1tcn9kLpVkxFNAb7/HKoUCEs1jLkEGN8NZ1rEZ8YDlf9b7J/duBWIsc8DKw71fd0vIaqgz5wvymw1YBfsao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899002; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhDFT9BzUMd37koxcuOj7Ad1doR31IgZvpj6fz+njkZlsUc9a7CbWkID5xhq61ed1Z1Yi/1jZpXCM/P+36+b330DuEPlRqj9gRw1a3UcCAoFx1bHbpirdRxVQID1zLwFaj8NUzQqd0w54kh9j1xRbjvjaU8JI7VtGtF/u+DGipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4437968B05; Tue,  2 Jul 2024 07:43:18 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:43:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/3] xfs_scrub: add an optimization-only mode
Message-ID: <20240702054318.GB23415@lst.de>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs> <171988120244.2008941.17128913512937380737.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988120244.2008941.17128913512937380737.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

