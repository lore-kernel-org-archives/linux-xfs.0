Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E18A1ACEDE;
	Thu, 26 Mar 2026 00:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774486234; cv=none; b=Xz+BBIPPb079UxNR8pgVe9dduEfTJxk/Up7lTa7b6JdxWqpjOj3V/1Sy3QPImVi8wMVnwj0oFFOwG0usoTJ7DW4NHJV3LM1qzrjIIjpYRPFSeeV/iPdbsrHpAksQvF88OFbJyejrToGouRP0jL3esnPuVMOCOs6pDCv/z07QuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774486234; c=relaxed/simple;
	bh=Ht8ZWVhXe/g5CJUAlXKokY0KJFyDOB6pwC2sG/WX5Q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mW6yrbGvBrFJ0KcB9B4kQSvLEokOrrq9UvZolumeaUhZ3O1SWkqxUycyv802kO2G5wNp3YHJQUZGnN8Sic8F4g9uW9nUQVNmtNnOhkNUG9Tb5ffqoSmkrUWd/pdeZdYlFmBVH1MzNT1eKFrhNPGNQuILq+MNPJgXeInDndWIsGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7I5kjO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7I5kjO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7E4C4CEF7;
	Thu, 26 Mar 2026 00:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774486233;
	bh=Ht8ZWVhXe/g5CJUAlXKokY0KJFyDOB6pwC2sG/WX5Q0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=m7I5kjO4g6s5WNGJwwJRmj49T0+KK1lJaI6pwa4yZp6gh0/AElNfxLRlj4YK2j4NS
	 zM6PNVcCKUYoVRtCn8wQGHOWgPtOY+8Q2NXDpKV/tQOayzWY7JwcZnvgN6QgnypdNv
	 x80pilzlIAbDkjKyElKIqHV4msPHiXYL6Ieds2R2uLXqXMR1j3w5oj+0i5bBOo4cnE
	 i7DmsPM3dngOV2yCL+wqKKSQByp0iof+pXdE+8gzw3ovMRFWhyhL5hnjhvJ31XhY86
	 R9jDX3YFRlAWKP8GaIwRxa97UsyUEbmL41FAmSfBAecLHzMUtbf8Tj/H/twsp1dGKY
	 oMYXHB8ER1JAw==
Message-ID: <858663e3-def5-4cb3-b259-0ba52d830088@kernel.org>
Date: Wed, 25 Mar 2026 17:50:27 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: start gc on zonegc_low_space attribute updates
To: Hans Holmberg <hans.holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J . Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org, stable@vger.kernel.org
References: <20260325124312.26349-1-hans.holmberg@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260325124312.26349-1-hans.holmberg@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/03/25 5:43, Hans Holmberg wrote:
> Start gc if the agressiveness of zone garbage collection is changed
> by the user (if the file system is not read only).
> 
> Without this change, the new setting will not be taken into account
> until the gc thread is woken up by e.g. a write.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> Fixes: 845abeb1f06a8a ("xfs: add tunable threshold parameter for triggering zone GC")
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
