Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0C879DF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898465; cv=none; b=TEegKlbIqWdv79lxJ4Wk9of91Y6XxbEFphfm4PTPG4eGHmExe0SfnL4XP08AQ0Ri5DF92sAZdencqYHZrKkKCp/79aag2AOTO+9Wpiq5U62tl9158pQZC2RMODqP5BF224fetkv2kAo53PE3wpAyArh64KnorEm5YkBUacB+xIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898465; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDzmLCem4nA84zVBXhh6pFE6A3zewZL/Bs/QdTzyK8RRT2s8mwdHCA/f9djzaLYHZKZBHpK7AwhJY6lAsZ4tBMdameD8Wj/8AaKG+C3l9elSPVjZ1fxOaR/xpgQSymO9cVNhn0sI2LQaEVpDFYWPBia9tPhOrFMOuMH6hM2VKlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0994168B05; Tue,  2 Jul 2024 07:34:21 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:34:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/7] xfs_scrub: collect free space histograms during
 phase 7
Message-ID: <20240702053420.GM22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118672.2007921.6461553875020192436.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118672.2007921.6461553875020192436.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

