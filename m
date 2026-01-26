Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95C526CE2C;
	Mon, 26 Jan 2026 06:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769408861; cv=none; b=sRO9ZIlsDtvRf/6jeI/hMPaXNYX8pJAVUxdVZvlloatcDDAg6P4tK2R02lG2cARD2Y8SKyZXHPfNG8997Nq2A+lBJElRA6cKND1VEk71ilGpYmqNySitsGCCt8hYK/nCm80i0n/f4ZvZJEjmq607QTzkLuLckEvPZ1sYBrbXiyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769408861; c=relaxed/simple;
	bh=/kf/oXd15i8L0oU03puYD2Y5rXqBCXVI/t/XGRND0Nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DxMuSfd6XsyuC2qBFbmDxiWplVXqcttVy2HyBFz4ygb4OzANAvA42iynl/pZkEd215hI+K8Jo0NAaCRjZ2y/DyJfTQbRE79vK6VDKHZ8O4r8ez33Zb5H5svq5UfaVloEvB1EzMvnZGV3/w7S1jsbZDnKe7Rsadu7l5MpVOrG8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpZTa/zB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpZTa/zB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB49C16AAE;
	Mon, 26 Jan 2026 06:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769408861;
	bh=/kf/oXd15i8L0oU03puYD2Y5rXqBCXVI/t/XGRND0Nc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MpZTa/zBaWtmyUkLA7d+P1ExGicwBaAJcTnvILY+ERkWfr/NEc7FkAdPaIEYEv9ze
	 qtKgk0wIAOX9q7PqO4hHzbAjUuncqzDn+kdc2/1NHYkbofCJXMMJDdSopxzCs/U78W
	 peZtXSuk9nmRLdV5WEMSRvhGgKq0sX47+dq9HJRP1D7cGqgdeVs6v4f3z7xqVa059t
	 l0zufJmI09xa+04xyy2+mxoWuLpxQSp2MTN1OXYIxBMDtvjFT8b5FRCH39zkxIoGBG
	 WoYoSQegVBe5j3mDEYkh93GJLTyKEG+XghaCdJFEwSl5Mebxlnkl9Uz2NxvxKu8L4O
	 HLgssgRvMXSfw==
Message-ID: <3360b495-b66d-40af-9274-bdb614455f6d@kernel.org>
Date: Mon, 26 Jan 2026 15:22:41 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/15] iomap: free the bio before completing the dio
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Qu Wenruo <wqu@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Anuj Gupta <anuj20.g@samsung.com>
References: <20260126055406.1421026-1-hch@lst.de>
 <20260126055406.1421026-12-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260126055406.1421026-12-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 2:53 PM, Christoph Hellwig wrote:
> There are good arguments for processing the user completions ASAP vs.
> freeing resources ASAP, but freeing the bio first here removes potential
> use after free hazards when checking flags, and will simplify the
> upcoming bounce buffer support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Repeated tag...

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

(which I think I already sent :))


-- 
Damien Le Moal
Western Digital Research
