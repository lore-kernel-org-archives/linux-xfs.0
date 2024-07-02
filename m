Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5612FB1B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719903402; cv=none; b=Oshx3VxcFUoe9azlYTeCS7otOUY9RvaBsyMMIJ60s62Bn0EHra5zJUYshrMZuO6d6Tb+qDK+bTzNmyuzQJv3Ei/heUK3F2jPRcfLee829Y/o2/NwNJvhp7U2VQpi3X4JaWEjT1BZy5AldAhATut16MCMRRMYM4dEg1+Sc2X82mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719903402; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZKnCg79FydcLQG0zpnLuZXkZvBVFIbpTrOvO2S/6fnh48ucfivH05Qe+Cr4VGtw7UVMqVDhvR0QIJkVuFHovU4QRDr3kkO9E9hY/Rhq0pKWCgAhQd4rIjA80DH8mEDbPOD+0YeC+4ktbbGSmwdYBA+Z9aq7PCrsaTHISFUaD/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF19668B05; Tue,  2 Jul 2024 08:56:36 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:56:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/10] man: document vectored scrub mode
Message-ID: <20240702065636.GA26384@lst.de>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs> <171988123150.2012546.15521264443878817076.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988123150.2012546.15521264443878817076.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
