Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCEE36DA00
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 15:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054790; cv=none; b=XO+gM8Ry1uOxrtlgDvUf9pGqjJVork0GeLfvZrcNJdGKL4NmE48XrvKYxvM58KB/SVOnGxAL+Ss+7dWVOo5I9mVit8ed8OTXFzi4FfwLh7cKHFR+8QABG562y8gerhn/bIviyWGvfcrdYnzhaiR4BKrwM+DxsgSq8+jLZ/H6qNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054790; c=relaxed/simple;
	bh=Obc70ZQ9wySIsIcsgV6inqDQ1VPyjbiYSTSHnBhNfJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4t2HFgFUwXt3DcVaTaJ48CfzE/0xLl7Pl5+3dcNm4KRfr06M31IbW10wHCmcglT58ltSqnsmRJ/hba5kFLLK9XY+FQXX3hxw27wGHdL+XOnhtcczm7n+Fn6K4NmpDU+pTJXWG5iFFdQ3sKkc8DLVIAHTSiHaukPWmzH+379IAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeYWOckg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeYWOckg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA681F000FF;
	Thu, 10 Sep 2026 15:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054789;
	bh=P1zsBtKgYXKR0tQtAXPQ7dk4aGyryHXDOT3XvKGzM+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oeYWOckgNb5N0lgKvdJEgMr3TXr7BI6fktiFaZp0G5yPTdjPql7OgAuRtyOVaBBnc
	 krs0C3qG7nJTUdk78vaWGoJbjtvca4k+bNkMEqqD87uemUdA0pTGHBWR2SEfLSCIUH
	 H2aP790DTaraew83Otq5qV2mv7oK10bpYuFBk2HIWl7Z/PdH0/wA4A6DgNysI46fdW
	 tPhakiKI72pzRVNkkHuXMzIzpO/KQCeTxo2bFDJAE511k9JbCvuRfFCd3dDS6PKfiJ
	 bOdThmFB4yNfgCk/YPIdYnMC7nGNhmn5aZ2Iezos+n1qKmgCekP6GIBsBcZ8iTZkRl
	 x09LW1vJIczLg==
Date: Thu, 10 Sep 2026 17:39:46 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: reduce libxfs divergence from the kernel
Message-ID: <aqLO83XEJy3hYWS9@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260910132840.1541283-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910132840.1541283-1-hch@lst.de>

On 2026-09-10 15:28:30, Christoph Hellwig wrote:
> Hi all,
> 
> this series tries to reduce the amount of difference the shared code has
> from the kernel version, mostly by adding more stub headers.  To ease
> maintenance of these stubs headers, it also moves them to a new
> directory.
> 
> There's probably a few more that we could add and together with small
> kernel changes we should be able to keep the files 100% in sync, but
> I'd like to test the waters before investing more effort.
> 

The series looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
