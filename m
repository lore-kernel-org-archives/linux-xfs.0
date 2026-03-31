Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A1B3822B5
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774949972; cv=none; b=NW+RjYn0HvFyOWZB3g19uWdA2m7zGZx21p2UHbL+Zqk3yvvUsnLoMIQvmnV/54eoTfwsgeaerf2cH/pVP20EytCqSCXt+A9CPRGu2R36vniTplWSEuUviUvJa7yZE4CjpWky1IFZcIAPLmxaovaveISibT+I4qxuhoi/huvgSL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774949972; c=relaxed/simple;
	bh=9LxPMVnn3+a9XFPB36BT5H0dSncOk7qlgwg8IFHVJbk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUzTf7ZrFwNxv9yf2IxP2yxI0IQailjPoq5MY4hf9Hl2BhdrgaLqXadZjGMmDMUqUu2UO6F8LGMC5Nhw4xsDc+iL9ujjSC8n7lQwANpVxj3JSF3r1EEgaiKuvUbiILKqalrrwdVFQ2qFLcxw+4k4AsPRuVFLcCLgXaI+oqSjuuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWWGr4Z7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWWGr4Z7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83CFC19423;
	Tue, 31 Mar 2026 09:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949972;
	bh=9LxPMVnn3+a9XFPB36BT5H0dSncOk7qlgwg8IFHVJbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LWWGr4Z7guTfH67fuNiXk6/iAB8xXgGhrGI8WYuONI3Z5EPro/t34RwqO16vXu7yx
	 ZHTJGPv5z43J0tIGH4cXRCt6xqjIoSt8DoUaAtu7O6iqXEcCR05dhTIsb7JE6Ixs2l
	 JPqVCqi6mCLVz2oOR3mClp7ftK1Fqix9ZyyCOximouDq9/uXiaAS9kI8sQk2ESZ2Ql
	 iNNcIAb2JZ7moxMPE55CAAL/0RtgDCxr18u8kN3L1wpoR34+Mi+CvXYlPdKts8OYwV
	 VJXxgVgMNBQnww+isFvsTAmi0KVFmazS4DZZUzSkGyBTkofLTPRu29P5bqVOx2SimU
	 v50mhl37wH0mw==
Message-ID: <714985b7-6673-4f53-b636-acdc5f41cba8@kernel.org>
Date: Tue, 31 Mar 2026 18:39:30 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] xfs: delay opening the GC zone
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054533.3856339-1-hch@lst.de>
 <20260330054533.3856339-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054533.3856339-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:44, Christoph Hellwig wrote:
> The code that selects a new GC zone when the previous one is full also

s/a new GC zone/a new GC target zone ? (maybe)

> handles a zone not being set at all.  Make use of that to simplify the
> logic in xfs_zone_gc_mount.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
