Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD57038737F
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 10:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768385058; cv=none; b=W/4VTUn6Fa/tIu2xGc5FOpEOkjndt3bRr4E6Ax2gqQ11fJKwkQLXvv24DOn8Jpn5epD0tw6NU22jZZD8mKyy7xM4epCfpznLP63vj5brR3luCtkqUhWSVsqnIHWVoMmAO+MbIJGiGMDAD00g+gK7p+6q6S/mY5CspCZ9SXabHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768385058; c=relaxed/simple;
	bh=aPsOIhzgb+HR5GmDS8kAKNUK5r/zXcZsdHiBQ+jPBNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HraZh+KXbypgpaJIyK9MmXZUZIJuvlDdFHBJ58zOfQeZjBF1UsrKQkAjPpp4ZRLO1FGaP9TurFqMKXCQS0gK+rocRN5U7O72YEZKJvneDeRtGSxMTpRzLhzE+RJA8+jB5LCbr5dVp1sOqdHVdYZXAvSxQTbJqw/qtivNlNBUdfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTFIEdhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTFIEdhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E009C4CEF7;
	Wed, 14 Jan 2026 10:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768385058;
	bh=aPsOIhzgb+HR5GmDS8kAKNUK5r/zXcZsdHiBQ+jPBNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tTFIEdhDXXcDsqsimuE7iZgUhy9Uoq7evpj+PwN4UEtwjns6jjD82MTDUOfilwogb
	 C7ZPrXZcOjznwVC5Kn5iJBP1nxRw+ip504PJrTH6q1bCyN3mU116o7QNsg5FE7FHT2
	 hAxQ8A7aVLEsR5d8G2i3kIsrnS9yPdhUGakySAecdS/ZEmPic6MSzfvKRSE3Vi8MA+
	 tmyA3+NWXLvkAVe0CJmjcU8Up+/7Ny0WG6c1CUUlbJIryVZqlgB973q7OgH179t7/f
	 jYmYciNlhZYNA/dNLHC1q6iAeZPkXW2Hu+NKfxW0rRpOn9z9PgE9wGIh+0feXDWnuk
	 zXZU47efPir/g==
Message-ID: <200e6b59-753b-41fc-a6a0-60e6a095fa8a@kernel.org>
Date: Wed, 14 Jan 2026 11:04:15 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] xfs: split and refactor zone validation
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260114065339.3392929-1-hch@lst.de>
 <20260114065339.3392929-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260114065339.3392929-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 07:53, Christoph Hellwig wrote:
> Currently xfs_zone_validate mixes validating the software zone state in
> the XFS realtime group with validating the hardware state reported in
> struct blk_zone and deriving the write pointer from that.
> 
> Move all code that works on the realtime group to xfs_init_zone, and only
> keep the hardware state validation in xfs_zone_validate.  This makes the
> code more clear, and allows for better reuse in userspace.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
