Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAE2FE042
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 12:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773147342; cv=none; b=h4WSopvG2ZKxcqEqIX07UsaxzS+aH/cXvi800/x3iTclyikqUIFNOAYikXho8zHCo1C/WGdZP348Jhg33GkorL/oEmu6Ft63p5RQCRPzxEWawG9yYy4lFt39VwFPyRe8B7tvm5VQtPQb3/oTsGmMFSjf1SuQh0uM2abwUYTEXOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773147342; c=relaxed/simple;
	bh=azZwVQb/XRR/H8DJ7L/a+wu8eQz4wI/gcb6tJQbVgc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MbWXIq+6X9tqawXmVA3o8EIPYISe2SGI9x/HNdn/wmDQqhIx0zqqgw4Y4Au6qneLuB8D7c6fqtyVdMPGlygH33LYo9xCRoQv0zasF3P6qNRVZli+QD3FnMAtpUXbEwme/YdpBoFmj/8xK5HLQyc9rSD98PLZ2yOolnE74L+xW4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDSHdkuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDSHdkuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B106C19423;
	Tue, 10 Mar 2026 12:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773147341;
	bh=azZwVQb/XRR/H8DJ7L/a+wu8eQz4wI/gcb6tJQbVgc8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hDSHdkuY+JBAgGo1YNxInQaWbblodYxgYermmn86AUXkN3u1CI6cPmW5zMv89IGL/
	 s+ImkNPSnl/zRHY9ht4RzCrdIZXjwrV93xeVPGEgtFL/1dn7CyGtQU9RWHXryC1p0y
	 y9FXt1gfUO4vOiPb27pO4YPJBGrCsofFtW0mlfvMU7siPDP3kQyPOqXR6pBLLJL8Xo
	 UInnee9n8fRNAqsmQvoZhk1lOeOnKBzOpAjDzrwHnIsjurz2sXeEp5v4OtjcSAlbdn
	 6ZCE/4By3t595h9acONEGco8lFVi43fN0JPa4wpljGV/cuAb/bkRgQp7neaAdhKCe4
	 hBP9ARgjuZWYA==
Message-ID: <86b84485-4cba-4d33-b85a-3d4008d724aa@kernel.org>
Date: Tue, 10 Mar 2026 13:55:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] xfs: factor out xfs_zone_inc_written
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310115555.114197-1-cem@kernel.org>
 <20260310115555.114197-4-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310115555.114197-4-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 12:55, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Move the written blocks increment and full zone check into a new helper.
> Also add an assert to ensure rmap lock is held here.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
