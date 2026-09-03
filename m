Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF1454763;
	Thu,  3 Sep 2026 06:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415900; cv=none; b=LzTNucnZj/FGF/u0fO6NbGPM79CJwM+ktb/0Fu+/JolZb13Wg8S6AJg/ipZ3pJnV+EPjKwgBpceeqs/umrGvG/J554Kh+tDVTkeufmpvHQmKZhS5Hj/6xQY3v9OI6d9QOR695w+eggwgBZMF5v2fHdJaGAZoQcSdT+Rkocal09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415900; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7ryKkNu4vkY6Pawb/EdGjXMDJmrnr3Q+hfN26BoNUDySF/4O05iEtQoiOLCN4Z0GIWgeLVqx7OvNkjdnrV+Ik8m1VnZ/EWVaT4CGajeb4v8raBoLk6im3Grxn33yO6ZPBmSgzt3tPOMFY4bteZnba3pCzgc38dI2vzMWkeelBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 325486732A; Thu,  3 Sep 2026 08:11:36 +0200 (CEST)
Date: Thu, 3 Sep 2026 08:11:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: count escaped corruption errors in scrub stats
Message-ID: <20260903061136.GF17233@lst.de>
References: <178840969793.484660.11718284266382755759.stgit@frogsfrogsfrogs> <178840969957.484660.10087312504640007572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840969957.484660.10087312504640007572.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

