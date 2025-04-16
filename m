Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E983212B0B
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744819858; cv=none; b=jGKkobi86nptAYoLqmvhP7/TaeLw9tlm3rqOTHUFo8qAs3FXPG1Rvl+Q4LVWGUGMsJHlVEMquconTzZyeuW5rtdnKKftLvTdP5psdAFOuFPtlTVVHtu5aw5y5cLnYq7kdri04qlAoJgT33GVHKe147SW2FCTXIfiUhehSOly0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744819858; c=relaxed/simple;
	bh=DHIQarRPq6JVYrTzPGDFCddpspUMAfXyShY8JZ1samY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=molNxsGKwPtZ+/G7ap7n8Ch8efSMnFWBvVmf+a40cF+gAxdc1Em9+pp7KAa0VrkwPdCuHshe+0sqae4AOU6rnwtjUyzlJIvIDtiv0Uln1l6uAQ2QuY6cpt8bIGlV3oWdtYZVNrPqYciAL3eoBWYcYCxcOty+HnGtTaUfq2kcepU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hs0ciInZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hs0ciInZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D700C4CEE2;
	Wed, 16 Apr 2025 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744819858;
	bh=DHIQarRPq6JVYrTzPGDFCddpspUMAfXyShY8JZ1samY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hs0ciInZCgSB4bYqe+YEJPDzGVUAQbZ5YsZcsf4lVvtbQWqAbvFL3gSd5nhFeZgyB
	 waV+iosH/7nbg2BpXkhKjDOacjKkmZfefxo0Gl84IYu9WaeGcIY/xgvVQ7BnMJ1Gr7
	 xF6aq2bZZF1WCj853KDNunJ4+/oLUI7gVplWFiTX/hyHIJdIZBxMzqE7GqfFZnZDqJ
	 JU4PV77KLdorEZ42gvZgSItJDEzOFf6RSm3gTNgwhQ58cwvTM+YQR2eNGK4Uc9cqcH
	 APUt6uiwFP0KG4STzFReJlrsb71/1Sramcbnw0bKKS6qUiYpr5D4Z2QMOdVQzPzOsH
	 TwhBnOj1DnH7w==
Date: Wed, 16 Apr 2025 09:10:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix fsmap for internal zoned devices
Message-ID: <20250416161057.GI25675@frogsfrogsfrogs>
References: <20250415003345.GF25675@frogsfrogsfrogs>
 <Z_8zvnmHAYewIP_l@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_8zvnmHAYewIP_l@infradead.org>

On Tue, Apr 15, 2025 at 09:36:14PM -0700, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Hey Carlos,

Can you pick up this bugfix for 6.15-fixes, please?

--D
