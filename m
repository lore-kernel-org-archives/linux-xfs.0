Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E444342124E
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786468160; cv=none; b=od9KjV6iViuyneNQGgiTKqWdvXcTIJAzx1DYb0ZPCDYh8fa3EQrBE/eHkH45A+eJdNxK2w+5ysJjTr9tANBbg1XtEBjGr0ZWv1Lh/lnIQzwI04+DCSsLR1dfMRW8rNaoc+5AtHhJj4Ms06Rm/qXmOQj+R2YdhdwA9Mvgfhi1eZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786468160; c=relaxed/simple;
	bh=Nb33ynv0GgVl2ML9YgkNv/4oIET0ArVZJf0FqAzhxBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iexazULigWbB0trXRhImiyizJYzxc7BO7p5gP0id2UD52b1GlvgW/dGKzQDKxoyEzEE2Vn/URQY6ur5hr01jVcb79fgumzNDEuGIDGzobu+z5Zt2vrgvBy1QY5K2GcfizTEOQIZzy3IcwHe+x/hUkdPOXUPHyBoHHEz3EOqqoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAuWwAoW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAuWwAoW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3F41F000E9;
	Tue, 11 Aug 2026 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786468159;
	bh=l3k/x+mq+4Lo+hPoF4pluLJ8JL01Ilve4pBNwJSGE3Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nAuWwAoWqQ5MoI/0wyiZ6jDau/LnGjokog1mwlE0+yz0BudVGVjhJSJQUaAP29uSm
	 EwnODuRLVFaeOU4NB1tmu3ykhLeHfM70hdY/wMDXZpUz8G9xDE1YntjI6AxKcCSN5i
	 i929VMGMfWyS3Lzz5dZCkeplBCEQcTEjOr3DVpnFjuScoTd4HjVYccftYN/JCrP4bL
	 3CcJJWjUc1R3QjvyjJMYiu52M7EbG4Lyx7RcHpAD74j4aST6WsHpp9NerxpyD2ntvz
	 E8stgR9xuGsrYQokWoEYCNE4QdhoEAAHYjfyBRfMu2aCqeA7Hc6xzToM1fyGgwYqj+
	 3BkNR9lMef4Hw==
Message-ID: <f1936ee8-f212-499a-8287-0876f1d6a824@kernel.org>
Date: Tue, 11 Aug 2026 10:09:17 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] xfs: split ioend handling into a separate source file
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
 Hans Holmberg <hans.holmberg@wdc.com>,
 Andrey Albershteyn <aalbersh@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, linux-xfs@vger.kernel.org
References: <20260811164912.124416-1-hch@lst.de>
 <20260811164912.124416-6-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260811164912.124416-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/08/11 9:48, Christoph Hellwig wrote:
> The ioend handling used to be only for buffered writeback, but has been
> extended to direct I/O and reads.  Split it into a new source file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
