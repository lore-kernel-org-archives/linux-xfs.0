Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660865A110
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898385; cv=none; b=FOPhOMVt+/glbGtRY8CpdAk9b/q2r3s85N0PIO6VVOuy2bkSN3V0yVUVobsfbiVgdvRtIbSIdxIZe1Q8JA7sbxRbuATm1jTdZwIPmzKPwJaZAJTama2gQt/YdTzCioSbf11jEMEvUfIFOl5LH+4JGzsE3CEFqqf8Uz/6TOaSIbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898385; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hKe5g6L3rZAVlgXc81QmGmTqup2OfkWwi03snoCpWf4M5Xc75Nn/PEIOIu0sMJSPBii2Mfc/DWJdbf1LAp61GR0nAkXc/mDInJ5GNU58+baWMVeQrjMeIAxuqREnzwFAU9FAQh4Pj2WrIYpeR3/NjADix/xF9YAkKGAj7IBBYx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8390668B05; Tue,  2 Jul 2024 07:33:01 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:33:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/7] libfrog: print wider columns for free space
 histogram
Message-ID: <20240702053301.GI22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118610.2007921.16808669892190727395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118610.2007921.16808669892190727395.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

