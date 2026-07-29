Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5438E31328E
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 04:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298077; cv=none; b=JnSGe59a9iievRuArn4AWG6C41X3b4L/o616RVOJKzl0bKSlcfxlO68jE6t4JXUuKDyzSlxX8b/rnTErbbQBJzSjLG8Xvd53TCjSQiicHfFVjHlTMubtmI1Jg0JXasjnvXC4oKR979ndSLMXLwY80OfNgGFqvX2k3iydCTbThiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298077; c=relaxed/simple;
	bh=okpaBx8yHCfGJqCvJLWQPsSQn+t88jk5t0UJ8jOEHsk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLrdZYz+wniJEJJXTS4SS1JR1j25JovErotQW6Cay8zfB8ahqn4+OJLTbismyXAanATABysTfKXTBMOPesOxSX0OK78SrB2lVBBpnjKgt4qdaEKW5SK+cnnGS6FPFvikiR4TWSu4ol5/iytETTBjvhA7jpbLJm5AudgOLZBvyeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sv0v7l/Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sv0v7l/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEB41F000E9;
	Wed, 29 Jul 2026 04:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785298076;
	bh=bCtupAXY+R+ai2iCaW4heX1Ihr/iGkuc4iqNhbnF4SQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Sv0v7l/QsG3l+E0D0yTxJI8b7nzNW7Ly8YyX43Nq6APd3YMmS4ypkyik+wlHkNnrz
	 1JMtKam31os6hfuH1vlJted6YfSrcd07f4uD/Gh6otL/phH1YjKIDPXQ7P60BydPIK
	 04oYktPtsAOgg0zxWJtxFE8iOUuftHsLKq9gKWVTz/2wxDJLT0YJDw3dvp9Iq3EXXR
	 gD8x595sv6IbjPlg+9HUiEqQT8wBrHz2KELNE1dO7Y57fooA2PxasZeFdkiJ4tC0Wr
	 ds+R9YlQg/ykcY+8WMSB30Vj2+Gj7GhXyCr4G+Oc6cfpOhIZLG2CAQW8QGnT/uuxkf
	 n6+wTNnexh4Uw==
Message-ID: <cf06355e-0974-480f-8649-64abd2cbf433@kernel.org>
Date: Wed, 29 Jul 2026 13:07:44 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: add a separate bio_set for spliting GC writes
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260728080650.1777545-1-hch@lst.de>
 <20260728080650.1777545-2-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260728080650.1777545-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/26 17:06, Christoph Hellwig wrote:
> Allocating the new bio for a split from the same pool as the original
> one can deadlock under memory pressure.  Add a separate pool for
> splitting GC write bios to avoid this.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me, but the commit message would be better with an explanation of
how the deadlock can happen, as I do not think it is that obvious.

Regardless,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
