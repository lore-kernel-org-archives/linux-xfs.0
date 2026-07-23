Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B2B3515F0;
	Thu, 23 Jul 2026 05:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783301; cv=none; b=Mp/+Hn9kLfPHD5w/SgXxiYfwmUaXvdFolX+dHKhAg4LZLXqhy4LwB2dgNlxAOQmsvKG2r9YcseyC8h3tj9G0/oHaXKMpHjmj0PlzE80QEp3c0SPwFg+LNS4FxA7QYOpq1cpl7sC9iooSq/dQvpfDD6xWi4rFQNyjgAGlsJoyJcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783301; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6iv51/l6xm4mVX0Nz9a6J7KlzNPRNUducDYD1FR1lhNweXEh0AA2ZxX4EtREWbsAjjdrqEbIpGv6UaaZlS6t6TddcTN/+8YaNjTb0S2Z6kz2wChZOpw3KgbWh/kkkzHCQssfJVJCi3GLiDpNWynd96TmAbascOBeKyVOl4wdWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 52AB468AFE; Thu, 23 Jul 2026 07:08:17 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:08:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: fix allocated inodes that show up in the
 unlinked list
Message-ID: <20260723050817.GE7121@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419637.830862.15080147963623340285.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419637.830862.15080147963623340285.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
