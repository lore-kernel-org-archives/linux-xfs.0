Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0BA2AD17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901683; cv=none; b=jVviWZ4CpSyB6poikR+xIs6XVE2LHENob0sLL4UHcys9KAFjV5HrIf+V4f7OkL6U+xh2hG78KOq3KPCJjMzSg7KBEB2FZt/XpWacaBbFyrSZblOasr5avVmY/ZyWbagpoziSe5tgCp4IIxI8/M5jffLM3C1DQMEDHKO6JBExT1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901683; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXMXyc429thi2StDmOP6HQu4K7afT4jXT4YoeweY0p0ln4U73tKkTKP2QUJr/s9ZF5Vf44iD4f1hvZetp9j76xdpE0BwysQ4ujzFBKPsbogmfspuD0XbVeixE25eNLlzvXG28a8VvxU31IsPgdoLk2v2V5dfv6I98A9QUBHSQgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 87C7B68BEB; Tue,  2 Jul 2024 08:27:59 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:27:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 11/24] xfs_scrub: use parent pointers when possible to
 report file operations
Message-ID: <20240702062759.GK24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121232.2009260.944702210373077283.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121232.2009260.944702210373077283.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
