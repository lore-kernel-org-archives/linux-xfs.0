Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4E13D50C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818512; cv=none; b=UwS8WcxbomrXk04MxGvh4dX13oT2zJQv4v3YwE4o8YcddAaOhtNurlNsDqlcrofLTwZZqo8NI4H7JBJbgH5WYMXlH2i8Yc8eBTOFqMjhguDJh2qUrEfM3HedE9XgwnaUTkYKaeVY6NH+30AqMVsacABuaBpSclCeAxjQ5G9qlc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818512; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SrioisPTtI54QuhkMyRFApDBDaW1QQa/YuGBBHcy9W8JGCm1JdSWMtoneuA0xfUwbGdjXOpR0m3Mwnhik/P7wIVRfhWMT34XgTzi4TW6aBR4ZnydgfRRGSYQDiGCqpA1VpHOxfN/2aEkJ0J5Rvh6cLrTahEls5v1b08S/7/l7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1BCE768B05; Wed, 28 Aug 2024 06:15:08 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:15:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/10] xfs: refactor the allocation and freeing of
 incore inode fork btree roots
Message-ID: <20240828041507.GF30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131609.2291268.5922161016077004451.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

