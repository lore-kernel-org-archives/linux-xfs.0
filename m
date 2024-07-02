Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2160C2B9D8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898930; cv=none; b=nzJNtWRxx3wxjutV7KU66q3li7wsTN930hnGQB+6UKZSy0c4NAcpAAG7PiRfDNMEWzmEn/AhadVStYYJ7UEuVnxiwH9L8jZ0mTWqC00LNSvjp/SPK23wT/vC7SAsO6PuV38epVQzCw0jsyGVuTTLSHZgUUKPkRKlg+PfoEybjO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898930; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HoWa3yYBFGvPDbKBmFKl1L5YhwLwiDUxo3MUwX5i1Hr1WkPgVAH8ZnCTOfcizkP7wJEPdTlmel4BVQyCIw5lTzyO2HFgoY5st4rFVuluSfejBI3UWiIS9jRVKe1Ozn4fH83G9T7niovIG5eM1qVQlkPr+tdu2u6eCR08YhR7Nrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 33BBC68B05; Tue,  2 Jul 2024 07:42:06 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:42:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/5] xfs_scrub_all: add CLI option for easier debugging
Message-ID: <20240702054206.GC23338@lst.de>
References: <171988119806.2008718.11057954097670233571.stgit@frogsfrogsfrogs> <171988119860.2008718.3789689429042344225.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988119860.2008718.3789689429042344225.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

