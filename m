Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7984332EA8;
	Fri, 21 Nov 2025 06:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763707877; cv=none; b=XC0UBjS4SdGzaSL6LbWQwha9Y3+AYMGaNFw46oklgQS1aOhTsv2a4bFTVD9IGUpsRA7rXqzv8nJCbqEdduuJ5rDX7QG94xuEFHTMQIQKjGG7Enmo9ItqDKlY86bVGGgbtMpiAGrUCLK6+ecp9H1M2Oa903KOXuoxbUbwEoQEA80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763707877; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+K1akCWM0Qyy5vI29hpFjlxsEMpA9+/HBXY2jC0X+EXWx5WJOeSalCUvTwE+oTLsrm3AJMCl3eBaoXfgEGWMhpcOiGnj5VjN2Wgbw05ooRZUhU4LpEDE5ClJ6K5SBl6Ky2SCkSmLZ1+bRO2p9apeVXRzlPT88f1SBnJhqfjxFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5DCD667373; Fri, 21 Nov 2025 07:50:59 +0100 (CET)
Date: Fri, 21 Nov 2025 07:50:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: zlang@kernel.org, hch@lst.de, hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/zoned: enable passing a custom capacity
Message-ID: <20251121065058.GA29613@lst.de>
References: <20251120160901.63810-1-cem@kernel.org> <20251120160901.63810-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120160901.63810-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

