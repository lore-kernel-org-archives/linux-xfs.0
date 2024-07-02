Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECE5BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903498; cv=none; b=KG6m5cHxMgcLIovKzWd5Dz2Gdzwe34RSgSaRc8IX6TKTzcrBS2MpHCIbIGDCnOfS4VQX2xPFdo1SxZ1O1s9tJUFZjiVapaS0a+6jYYUQWC0IO1HFoXUxosNjzqChlKE9ROiMZYad+Vu+UdjbABmgQ4DSP812QkGyKt7Wc/ZKItw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903498; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWa5xnP47YKh+u+Hb6h3LlGfzuhWb7F7eDBRjptKgMnGrBdH8WF0ztvLM926A8jb2XqPrwq7YzrZttd7HuexBkfU+mDE0w2NvvsBVQbB2wp/jHE5DYXE9xfqeTQyJ1gMnHRQ+WaHzhQpB4IrYE3565GYY8UXXhr0HsaZMX/nwHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BE91668B05; Tue,  2 Jul 2024 08:58:14 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:58:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/10] xfs_scrub: vectorize scrub calls
Message-ID: <20240702065814.GG26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123242.2012546.539108529178024852.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123242.2012546.539108529178024852.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

