Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A31D88A6;
	Wed, 12 Mar 2025 20:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810646; cv=none; b=L+1ZVct83b/SvWnhkpuAHp73WotWuvMyzawAu5I38MGsK1boSlRO3IhWx/BWOOusNWZaojObemRk9BTt4da5NGosoKRxhRamsMJId7Zrj4SaUMjnGSF6NO5eth1rCzd/IDVEHhVHXbIb+fm53GH/hex1fgp9rWcnmNJoypiNuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810646; c=relaxed/simple;
	bh=BsjIJVIBzHVdQOskr+UvxCOPS1JkptzjtLHXS1rhmYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ICMp1iErL9NtjYrje7EfCBwa7+tddSn6VFE//hHobn5a2fjxwTcW9x+h7+PflFUfG5QFd2Ql+FLyaw6z/h+bxDG7eNRjyJfhww671P80yVuI+yZY7svYw9n+VTx++OBl83mBOALwOMUJ0XZ43DrtGmU/GH6jGggzGCSMDJvhypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/7DF+NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/7DF+NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7933CC4CEEA;
	Wed, 12 Mar 2025 20:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810646;
	bh=BsjIJVIBzHVdQOskr+UvxCOPS1JkptzjtLHXS1rhmYg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W/7DF+NGJBhvoi57ndp7pys1KVW8qiXiM0IXXnP2NiDYYOFBJ8tNdw5IdVrsuqU4f
	 GSMt82jgX8HQGwGL0WC1qd+HfGszZ6u8cCDFGsGGtR6yAlTKYrlGGoeRnpm8pOq66a
	 meYwbD+9Flp4ooaIb+B3d4CuTzwP+rJHwnacTdrez/sACPg/rjf1PKovE2ak+3iiTN
	 LakPAo5dttUgJaCAoZLYsoi9NNTQCE1NiN7QVsTzNI4xeF80sCHYGNAGsiUlw/3+H7
	 J07plPO0Sj9JtGmOZfWfk1iX8F/a/JIcDufJI9Gra+orcqJASNJ862JK2MaeKJ6WFY
	 atrO3cn/+5rfA==
Date: Wed, 12 Mar 2025 13:17:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/17] xfs: check for zoned-specific errors in
 _try_scratch_mkfs_xfs
Message-ID: <20250312201725.GH2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-9-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:00AM +0100, Christoph Hellwig wrote:
> Check for a few errors issued for unsupported zoned configurations in
> _try_scratch_mkfs_xfs so that the test is not run instead of failed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 93260fdb4599..807454d3e03b 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -160,6 +160,11 @@ _try_scratch_mkfs_xfs()
>  
>  	grep -q crc=0 $tmp.mkfsstd && _force_xfsv4_mount_options
>  
> +	grep -q "zoned file systems do not support" $tmp.mkfserr && \
> +		_notrun "Not supported on zoned file systems"
> +	grep -q "must be greater than the minimum" $tmp.mkfserr && \

Hmmm... this doesn't mention the word "zone" at all.

Maybe that error message in calculate_zone_geometry should read:

"realtime group count (%llu) must be greater than the minimum (%u) zone count" ?

and I think you should post the xfsprogs zoned patches.

--D

> +		_notrun "Zone count too small"
> +
>  	if [ $mkfs_status -eq 0 -a "$LARGE_SCRATCH_DEV" = yes ]; then
>  		# manually parse the mkfs output to get the fs size in bytes
>  		local fs_size
> -- 
> 2.45.2
> 
> 
