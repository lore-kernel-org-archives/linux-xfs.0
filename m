Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A45BA37
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903519; cv=none; b=o94KjxUSHBaKrbTWuI16CGMkHt2h5LdkQoh7rESbk+S+5xMZTPHp0IUZMQCPBPTfDyPcPPJ3XIZHSbAH6uX4I2bTLBcoC/rlWorYxiitUv1L/RaWfHA+aU9WXRvgpR2HS4Zi41IDYr1I6lxYNeLGOUlKUX9/0uFloqEFh8Nuu2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903519; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NxMaQctkorkX2B3Qe9lHhnX6qV+Gk5ABcxJYyUEpNty4z3kS3zQfwToD0Qx3c82zJwQGXeue7vAkTZkstuOQ4MnxPe5PhegNIiK5MD15GPB+lyW0ZqL9/EVSttY6ddjPgDvPm/7s4pECeErNnCgdrTDnspyWSTF0H1UmQqnKLcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7CC1568BEB; Tue,  2 Jul 2024 08:58:35 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:58:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/10] xfs_scrub: vectorize repair calls
Message-ID: <20240702065835.GH26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123257.2012546.6149607312591068968.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123257.2012546.6149607312591068968.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
