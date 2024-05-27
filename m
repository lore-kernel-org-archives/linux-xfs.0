Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691ABC152
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 04:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716784644; cv=none; b=Pibl4ehIYfPLsUaEx2Ka2qLf1PD4W6j0UoCOBpHvbZSoYsWdVGxHRHXdW14H2pEL3KCvQiYB1i4oTePXA0Cz48oYaDnsIBHo5rTYyeVOH0C2tC5Yelw4yAABn7rCwz9/uJHcGN1MR57xc9DlfHNFGCZQyY1gws1YfB8pz/ltGeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716784644; c=relaxed/simple;
	bh=P2NYbfTSM8OF4dMxCwip690VrsM9UR2s3yvUraqpyqQ=;
	h=References:From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Type; b=GTAJF4+ur+bCpNM0FAVi4Xp2XNKelD2QXKtk58CfAoLJ4mmDzMGmog3EKqP8cPTfVYqnHZ6MLU7M2gTEmSpG4ECITfis8YTIjsLyIIsXTtkak6v9By0L6k0xlEqgYVzXKSHK6Xjf17qRLAi3QL3qxOviuUb/e7Gda8FODAtXf/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hq3P6YPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hq3P6YPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77353C2BBFC;
	Mon, 27 May 2024 04:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716784644;
	bh=P2NYbfTSM8OF4dMxCwip690VrsM9UR2s3yvUraqpyqQ=;
	h=References:From:To:Cc:Subject:Date:From;
	b=hq3P6YPgaJKabR+gZYHOLcXQKoM/C7wg0gTjDhaQKpDHh1P1rOmzSXiGTqphHAxuE
	 hfj64PiWxiBBcAmONkgF40mXqPCeMKR6bBjTqqAyLwRDGXqwMZ4kagG0sc3tEWfQ9x
	 92r1/dNw/AUGKGLC4pzS3oSbHS8yze/GDYe5kThJUifmht5gBMVP8UDMKZKPNT9uH5
	 AUwtcLZZkBntLjkCuZ23MpP/eIBshF351S2lhM+RC3G+v66Hj6P+EER8fnzoX6tkRX
	 F9yyZmR4p3oepLIfSXu623M5v1tnTz+9AlMlOepGv2jU1LAwiR6pV4hWgu/2F0cjmb
	 Z8Jx080VU0ODw==
References: <20240524164119.5943-1-llfamsec@gmail.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Chandan Babu R <chandanbabu@kernel.org>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: djwong@kernel.org, lei lu <llfamsec@gmail.com>
Subject: Fwd: [PATCH] xfs: don't walk off the end of a directory data block
Date: Mon, 27 May 2024 10:05:17 +0530
Message-ID: <87ikyz7tvj.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


[CC-ing linux-xfs mailing list]

On Sat, May 25, 2024 at 12:41:19 AM +0800, lei lu wrote:
> Add a check to make sure xfs_dir2_data_unused and xfs_dir2_data_entry
> don't stray beyond valid memory region.
>
> Tested-by: lei lu <llfamsec@gmail.com>
> Signed-off-by: lei lu <llfamsec@gmail.com>

Also adding the missing RVB from Darrick,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index dbcf58979a59..08c18e0c1baa 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -178,6 +178,9 @@ __xfs_dir3_data_check(
>  		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
>  		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
>  
> +		if (offset + sizeof(*dup) > end)
> +			return __this_address;
> +
>  		/*
>  		 * If it's unused, look for the space in the bestfree table.
>  		 * If we find it, account for that, else make sure it
> @@ -210,6 +213,10 @@ __xfs_dir3_data_check(
>  			lastfree = 1;
>  			continue;
>  		}
> +
> +		if (offset + sizeof(*dep) > end)
> +			return __this_address;
> +
>  		/*
>  		 * It's a real entry.  Validate the fields.
>  		 * If this is a block directory then make sure it's

-- 
Chandan
