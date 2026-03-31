Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33E351C22
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 09:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774949452; cv=none; b=PsDEW6iunR6j8zgrLgrLmsNOVrba8b2VRRZ+kpfrUJ9gxJyXLyKvrL2j3M+LvZtiC3rCSCTG+jmw8FuLBD+wCTeeFSiTMeR/WEskqwHz9nqsd95SM82mGau904yjyp2pAw+2ALAUfoPo0WYKGPB+3AcLjZzRGFwlJKJdv5PE/vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774949452; c=relaxed/simple;
	bh=TdcAAJxv+QHvuBHX1ugnc5Jomd1ltzy79f5dpml7VKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XS2XBTKXk4/JAjhUBkZUG7i8v5v0OjMvVO2xn9zg2E6zziJfdsilrUJ57eSChhkeX5vLMqcGce2snrtKCOcEq28bM2jnvtDNQ6HRbgHXecoN2u7iWQ7xeb4cuLf2k0WDnCBUkMVSO/kiauXlxNC6zghdpIrcwv+msllAl7XhCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1V61Y4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1V61Y4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25FBC19423;
	Tue, 31 Mar 2026 09:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949451;
	bh=TdcAAJxv+QHvuBHX1ugnc5Jomd1ltzy79f5dpml7VKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=T1V61Y4LGoSmXzi2Hn9aMK5qpN5cLMZeTxsuHd58e9VEQvNkPENHxXFT0B7P2u/Dd
	 INNQWaDET0peUWknKkQAZUuZrzvo+GWtz8nB94++wzTkNAo2a3FxtpNHOAUt5IZgYD
	 EBvTcLoatxMi47PcA3ZGO8dGsA/EJEgStcigsuWlA3u0rYWC+KDuokc4phdhhQENe8
	 UgBhCjpSYGrIh8u3gC5UUksJYA7NURV9juBqqjGg2rehH+4+ctBkxDE8IYNVEpHswX
	 dmcoRX3mj+v8qK22Kd5mRudqsBkUDxDolsoW44ZGqUtiv8quT8oHfEBdd97Nh1reKO
	 rvcwFEDSamaWg==
Message-ID: <b3356808-d483-4efb-8eba-d7f57b24c965@kernel.org>
Date: Tue, 31 Mar 2026 18:30:49 +0900
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] xfs: handle too many open zones when mounting
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
References: <20260330054111.3855818-1-hch@lst.de>
 <20260330054111.3855818-3-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260330054111.3855818-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/30/26 14:40, Christoph Hellwig wrote:
> When running on conventional zones or devices, the zoned allocator does
> not have a real write pointer, but instead fakes it up at mount time
> based on the last block recorded in the rmap.  This can create spurious
> "open" zones when the last written blocks in a conventional zone are
> invalidated.  Add a loop to the mount code to find the conventional zones
> with the most used space and "finish" them.
> 
> While we're at it, also error out if there are too many open sequential
> zones, which can only happen when the user overrode the max open zones
> limit (or with really buggy hardware reducing the limit, but not much
> we can do about that).
> 
> Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> +/*
> + * Find the fullest conventional zones and remove them from the open zone pool
> + * until we are at the open zone limit.
> + *
> + * We can end up with spurious "open" zones when the last blocks in a fully
> + * written zone were invalidate as there is no write pointer for conventional
> + * zone.

s/zone./zones.

> + *
> + * If we are still over the limit when there is no conventional open zone left,
> + * the user manually overrode the max open zones limit and we should fail.
> + */

"manually overrode the max open zones limit" sound a little odd and not clear,
since the maximum open zone limit is a read-only hardware limit. What can lead
to this is that someone wrote directly to the drive to some empty zones with the
FS unmounted, no ? (same comment for the commit message)

Other that the above 2 nits, this looks OK to me.


-- 
Damien Le Moal
Western Digital Research
