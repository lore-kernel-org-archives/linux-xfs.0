Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D524562BF
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786468005; cv=none; b=W9F1lnFK2XDQCkAFbbD1R77htfmasv3MSMU9kPy2FpiyuRkyI8s3sA9JZSnQabcEiL1h4lepD3GQIIDBVX0qNSbaZsE0Z76OxaiqC2pLIM+CU0SR0cKYsJgU+Ex/Ggdt6xkgqZDP7DZmk3aAz6Kl/X0Exl6GulibM529JDfd/Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786468005; c=relaxed/simple;
	bh=KStGAcEIcPNFuDkkKv6R4BimGq44R7EoqDgmmStc+fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Szd1BAOu6mHqZyuhrqhtqbpMdgutUH5xryqRAIg7dRBsx9I8u3+nRzZY0t2rbzk3072t33/PFj5MMWNg4V3nxacgf9854G6vHfEvFBd3nHOBnLJkIiO6DjNLhj2uql9V1eoxxEP1AuMTH2IlKibb2iNyAluaijfL23wmTL9dujk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bxIzgGqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bxIzgGqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10BC1F000E9;
	Tue, 11 Aug 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468004;
	bh=FjrhbFKd9TPOzUUe1jqMHt8uXvsqBBMI1nEvPJF3GzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bxIzgGqfiNG6vGXTWjA7Kf3RhTgI5WzG2yjPh2XvY43aU3fsxnKBWecEX+0ILcnd5
	 jyEZIH6B2Zhw2Y8SohAzlHJXQLbufIkauiQRBs31Y/XatuexzhzHy7+W0qLbSBay2L
	 P23i6ao+s7a2YMFHY8Mwustkz2n+HB7VfiJHnLmp+diMlu8lR/fsEDDJ7jvWZTDZ/p
	 wNdw+oxth6KFaz/Vs64Ky8CaO3B8FLdvwxBxWK3xThaAjcaQg8VccDiRJD0aOxF8Ml
	 eKs6QOyJLykl616OIb3PAa7r6e2bWLi+BoOaDudEFg6HBEziXsEHQKAP9Qfe/RjobA
	 KUJQAgK7G5A9A==
Message-ID: <fc6d5ce8-eae8-4737-af95-c04d3a1a2b81@kernel.org>
Date: Tue, 11 Aug 2026 10:06:42 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] xfs: factor out a xfs_iomap_set_anon_write helper
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260811164912.124416-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/11 9:48, Christoph Hellwig wrote:
> De-duplicate the iomap setup for zoned writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
