Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71ED136672;
	Wed,  1 Apr 2026 06:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025110; cv=none; b=j7wIwmPzlherF1GjZc6MhrdpseAgozzOLjq/AcHD0dUGG1IvvwxCjiet02YPldhmiK78pIE4J1hMW6CGsTV9cX6/tiABxgrFwpvzpFj7Lbg1Uc59nrDi79gWL1VYkZUhY0JNayqaHIGlVmPFH6/B2dozh51Zq5m5OSi7OehtDic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025110; c=relaxed/simple;
	bh=FmG9+oEc3u0Io3xHytit6dYoUo70py6nf+qvoLgQLuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/aeauuwy4Ce0BIjXeyhPkPnSVsDFRy55DX3CZIZ5K6qG4l3HWjiqavgsUk3FAnGNAgI/nEpFmUhl9o2lHEM7CpG1oGh4GuAkQfQIC6JlwAS8bjHS/9rybjibuTyMk5Vn4Mgyi1vcfwBNlTOSv3kXA7ZBHpRqk+dYjdQR+WjvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 56EA368AFE; Wed,  1 Apr 2026 08:31:47 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:31:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 21/22] xfs: add fsverity traces
Message-ID: <20260401063146.GD24459@lst.de>
References: <20260331212827.2631020-1-aalbersh@kernel.org> <20260331212827.2631020-22-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331212827.2631020-22-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Wouldn't most of these trace points make more sense in the core
fsverity code before calling into the file system?

Otherwise they look good to me.
