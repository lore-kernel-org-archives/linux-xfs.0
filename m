Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC9B12C475;
	Wed,  7 Aug 2024 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047137; cv=none; b=q3KQlPxU8i4Od+4NUmwRm/W3w2X+oH/gisRkBX+MpLd0tiRGTJbCiOJP3fXu7lDgR9utvmjvmzmmz0SapBfKwkgXzksDnsJEB9Nl+LP40fDGFEMa7cgMuQrt3HAgnNqu3BAATU+YGLaHqp38ZnXJxb8GCDAJ2bHK6KD2mqm5G0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047137; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdAcz9czW/97qsOb8irNGte1YYpvl/a5/C6t6mF1xZcNveE30xhjl1LQvx4NDSOHP3xmyfKWrhsXMSa7RijQ6JSWfdcxq4qP59mJgyaTeaK0oNrSgk8TD9HAwcjzmYH2SBpqkFftUZa+s5Txad6T77G5PTj38IMgFEhT/MZGXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7CEC168BFE; Wed,  7 Aug 2024 18:12:13 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:12:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, dchinner@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_scrub: allow sysadmin to control background
 scrubs
Message-ID: <20240807161213.GE9745@lst.de>
References: <172296825594.3193344.4163676649578585462.stgit@frogsfrogsfrogs> <172296825628.3193344.3037756123720880069.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825628.3193344.3037756123720880069.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
