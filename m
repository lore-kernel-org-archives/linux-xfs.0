Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AFE40D576
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 23:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781047089; cv=none; b=WnC8xlVfk7t3QYZAK3FBAd/NJ5F87inrMIPbKEq1M3j9UCV2WCtzuxfXJ/L89p7XuGeAtfwWXx3io2wfLaHxv7K+Ch9cWMDKEmfRu6ZvlHhE725zn/lk5qopjn+U/3joGWyeFkmQBY1kZnOm+RADAPDHLP76O6hXK1Zicp1lpVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781047089; c=relaxed/simple;
	bh=K2bzYZKyslb23jPVM1fMSCK9cKPHdMA+mYYExOaVqo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=elEPB/EzvHx3oyQ8uErUGWDpPNvbAsq1TSYPEwCdxH43TFY3H7rrFNba3wT3/t4wCoMPSEepzuUdUVN2p2hxa5gkBxLBN3SwdeLLqDKR+eblCP6j5voz2253tyyxQkEtGcYIye/q75Crwk8W6vBCNP44TC4qpCz/roaUMiPVZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCJaX2SE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCJaX2SE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AB51F00893;
	Tue,  9 Jun 2026 23:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781047087;
	bh=rj656xbJmNPjtvC69hL0e00Op/0Ig4c6JYlg5jf6k50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cCJaX2SE++TwTXLof9KB6iRswofe/tKSIkrExPo8Z65VHHLqedTLphJvEyOfW51Oa
	 DA+Pq6tqyVzT9yZz/lJdoUpGfD8r8Ws4/+vjtUa06p3N7sb/2LzI0pHEFPuh015tpG
	 jX+o6uecCjXsQQ1gylO2qofDLDaTY5yjhtXvwjV/A6gNc4UbNCTXj9plem2pwy2TYg
	 WvAouj3bcn5xtjA5ixGSOqr6UAkBYe23UVNxAi1wq63qYqDXKX+qZa6B4ixUtOdXgP
	 kh/R3mzYySTxyp5kRqMs/LSqU/IujXIJ47eSaSrO1GUb0UW/y555RxBMloTLvWZoTR
	 06i5ssOKPnirQ==
Message-ID: <22a1d379-cea7-431d-ab5f-449bae98e2bd@kernel.org>
Date: Wed, 10 Jun 2026 07:17:52 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] xfs: factor out a xfs_add_free_zone helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260609075655.1698743-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/09 15:56, Christoph Hellwig wrote:
> Add a helper for adding a zone to the free pool in preparation of adding
> another caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Same comment as Darrick: to match xfs_group_set_mark(), xfs_mark_zone_free() or
xfs_zone_mark_free() may be a better name.
Other than that,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
