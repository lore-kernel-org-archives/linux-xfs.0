Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36854348C66
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381993; cv=none; b=ib8F63T+cgPIppFRdA8R48olU5aPuVysArVPhlQdyN/BACCP1YO+hIi0bS/VrXmEEp2BuQu3u9MHyGJK8ZRfJQMN6FLoYRW5pcSUb8AzjhoXJ8LlWxB2wXS1jfiTydEd8U+0xLsYDkAgeQ5zXM4CuFfgRKrKB9AgCdXOz3wPBig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381993; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPQQO1Z6jZnOu8Flf3e+RVLah6b7+FbKPKcjZTJQSiF0jXcLWb9FpSfXKYXlIpNHcWh2tAkUYGRpFNDvDs8ZSOeZxppuMEGugoPHaCftW1jRJWcS6D63zVgBcuj8Wqhr8IPTaGv18UuNsvZw7t8fRWUXWdevkn9CS4vtontUvmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C3D9068BEB; Tue,  2 Jun 2026 08:33:09 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:33:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/7] xfs_healer: don't leak wh->mntpoint if
 fd_to_handle fails
Message-ID: <20260602063309.GF2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627154.588879.16839468479313253315.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627154.588879.16839468479313253315.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

