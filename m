Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271913A1B5
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 10:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768300407; cv=none; b=HCSLAkjF+y/I5Rmfg2BPSTzLXEU94KbobTqOKdRWDMet9AsfJYUEj/Ly3ZmTVBDsIdGKMpWaQ+X3rqV5OPJROAqXT+1Cf76tpbJbJ3HTabJ7REYu2EwlJQKKeGseWh38JrItEMA4zaCRg6VGqEP8YyBbpL63AlV1HA0NeArh0Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768300407; c=relaxed/simple;
	bh=WWuCrxakoWgvo1ivtVerjnTYzIGO4xK2nXXNQoOO6Zk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WSdICvQCmty8/5Dx8m1r1/bS5wASMUOs587EtNKEGeilN9gBVOAylSU4d1azdg92+z50dC61MnkQASGR9rYr3FuYSddGD4Sisld0JORQgymse4Xi1ZnzRX70NA+gdWWPoFYvd74+Iv0ueAwoBTKCWasSH/HS4B6nx3Q/BtvGs+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDNK1Zgc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDNK1Zgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9011C116C6;
	Tue, 13 Jan 2026 10:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768300406;
	bh=WWuCrxakoWgvo1ivtVerjnTYzIGO4xK2nXXNQoOO6Zk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QDNK1ZgcpP3JH9haUmTPIKg2uFEaPdwmZzXg+Z+uRNfcVjaFi7p7oIxGDFngy4WTX
	 tD3pEPI3CoeeOE0AVtbncrlydbh5tk7vqw+OW8rVcwv19jJhy+tTXkqymQEeOHjoYR
	 KjbwdE7stru7hyFgNQmxzpAW0BjgIUc+E65a2Nzzeie8FuNxp3EpiuwHjWBIkm0NbE
	 lj236rE90GQkoJjGUmh1CAA4U4hdmMbSkv4pBtS0p/GFkm7i/HmpXTxkgbSG/n0D4t
	 cotAkPV3FvKXbNI8HW+O2dUjMIdyL6dCYbbgK9uxx6uEsccLB1bA2l6Tp5Gsg+EX7q
	 p1sYc9PuyLWtQ==
Message-ID: <06738d57-9cac-4a94-9cbe-ab99819e9a68@kernel.org>
Date: Tue, 13 Jan 2026 11:33:23 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] xfs: use blkdev_get_zone_info to simply zone
 reporting
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
References: <20260109172139.2410399-1-hch@lst.de>
 <20260109172139.2410399-7-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260109172139.2410399-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 18:20, Christoph Hellwig wrote:
> Unwind the callback based programming model by querying the cached
> zone information using blkdev_get_zone_info.

In the title: s/simply/simplify


-- 
Damien Le Moal
Western Digital Research
