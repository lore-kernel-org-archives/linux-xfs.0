Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9184D26B2DA
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 07:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773212586; cv=none; b=l9gEOk7kXNCwloqJ1eSe4zeGIoZ5Pk58sUDmBhLm8joHc0TS2fI2DWPAZK0MbF8zbfFLgyamkxW6P+gnGxq2jdZqJy//Yquhm3aAm/P+urw01KMTserQk2+OXM38HdMTNZYAHOZL7SPGgaB18ApXrXXVGgYFxffHwQn+B9GC5O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773212586; c=relaxed/simple;
	bh=7H8CuLha7tJlzcNJoGv7HUY9pqP91TJxVnDY5/wB848=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rj3Ka28+6zVi2MzbGqcOGPlQ/kG4xw5QzZuwRL3d4QHTo3Ppy2MD1nMHRDscAxeJOKNm6tWxQWVLk+ahi/kMYhiGaRxvGe4G+Wd2tUOLyp+YpEabxyAL5Cun6KjZ5amRn51ydDDJ+lNV/ImNgdwPr0AOAoqqwB26E0QnBjMkSm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTTNtFcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTTNtFcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93634C4CEF7;
	Wed, 11 Mar 2026 07:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773212586;
	bh=7H8CuLha7tJlzcNJoGv7HUY9pqP91TJxVnDY5/wB848=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nTTNtFcCYTYjpIiOLpWEjQ8OqSxthOZIAzdU6mxRv3i/vubvJ62SPazOIoXYPTVOi
	 VUzgf4B7F4NnsBNvhk/a/DC8BrYl7h5qBESbG6qE10Fpy1wbVaQDgdyqSXyNr5xtsY
	 mtg0Jtw6qEnomJT2iMWTI1jUjtgJojhoZLh6Js+pp9cLCNJqIFffHxoUWtvEYEf0Je
	 9iL2TEREU0SrS5u77Gfh/vbvPg7Vp0agtsF1SWvDGjuPtkDLWCzhw+503EmRWyTxfg
	 q+bQ65+sLYTu7CW6vWwrP/ULCOppmndoQiabgs39Prryd7FKrOaZUdCavDnaFI+tS8
	 unWNpBEt/+2Gw==
Message-ID: <5160ca82-3562-47c9-9848-70875bfed50d@kernel.org>
Date: Wed, 11 Mar 2026 08:03:04 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] xfs: factor out isize updates from
 xfs_dio_write_end_io
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: hch@lst.de
References: <20260310173709.457047-1-cem@kernel.org>
 <20260310173709.457047-2-cem@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260310173709.457047-2-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/10 18:36, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This is the only code needed for zoned inodes, so factor it out so
> we can move zoned inodes ioend to its own callback.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
