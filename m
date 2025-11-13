Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640731A9F90
	for <linux-xfs@vger.kernel.org>; Thu, 13 Nov 2025 14:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763045349; cv=none; b=mwamgUfC2Tc7GautWbkUrkUZ3J/PlvtK93OziEEU2Yh3nDXuD1IGo1nihVFRaKce2XpM0GNSyMExNkleBONJEwOe2qrsTb2f8h/bHvCn7RLwq+k6wr0OpAo7yDNOjz+cu0Fi5fntCGJUMUs25VUNp+abPlGBo0JnsngkM3u9pPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763045349; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgiqOFgWzOsVexZMX33i5ZLFeMsYwMaSERw/WBjXIyXWXweMt2A/OZ0Qw74rMGxNMDCeqmA1MeoWtbD2SDZ6y5OoRvvQWIT/5SeZ363xjoJf/7K0kbShEsNbir6qvo1I4rlrM8TJD9Qo3ybcqdfIzxUYrIhEtF2gylORBKREOmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BAE14227A88; Thu, 13 Nov 2025 15:49:03 +0100 (CET)
Date: Thu, 13 Nov 2025 15:49:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2] metadump: catch used extent array overflow
Message-ID: <20251113144903.GB31071@lst.de>
References: <20251113135724.757709-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113135724.757709-1-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

