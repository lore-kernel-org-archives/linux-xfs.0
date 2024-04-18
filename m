Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2486FB0;
	Thu, 18 Apr 2024 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452130; cv=none; b=UFy3X2JNe56RLx5GsIHG22pEjtaaK2UjUHxB5kNYm2wJ6QGMC7lARladkcfZMdVJid7tGS3Bzw9+1SemV9KK7rSG6j2+9sMLbZ/iK4TnGAHUuXMAWkpqrkDxYH+vcPSjcUzbEPIR2kCvpLrDs8m9zcCHHu0qxgz19u75nyfd+EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452130; c=relaxed/simple;
	bh=MI8FCYNJH7OXjAKGbBUKWDzreEpPaSlHc+JauHi2tRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=js5Ju5c9gFJ7Y2XXi2zRbSb1neD3d3byNlIGGa17lMfSADdO8on+Ajtx8MrpRnqqAM8KbtLryuDjI8mo2gJyg8yF6cOXB0WjFGmgYsc3b2XJUqVMTZZO4DdZT0sftngDUCPjJQOyWyBDDkwYDwzZWWF38wouwBko86jf0N0rO6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7xPBzAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7xPBzAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1680C113CC;
	Thu, 18 Apr 2024 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713452129;
	bh=MI8FCYNJH7OXjAKGbBUKWDzreEpPaSlHc+JauHi2tRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7xPBzAJeN00L3hVE4xsSbsla7K9dIrSubjQk+vkDL8lKiS7ywCDoAwBGk7+Cr7Lh
	 RMh4BWuG04ptuX8xT5p8NFjA6E+qykuY7Ml54aAkgu4awrcXlClE7e2dm7Z3wZazra
	 hW2QwfQYsct2y/KCI6QJ1Y34jZFb8HC2/139MI1+IEzwMOD7u8YnVTeNu/E5atIhBk
	 TohfR97KVWQw8tW1urEtsaM0JYyseqTqDwRCHNSqdv708aaGpVcqss46YMUx7QpsjA
	 Sfcgk3/UZLNE0NrrzpJZhd1nR+HoXvx9zdOAnB7rGDqgdqsx28+/0Ouli3/euGsgEu
	 0vHiuZewNuURQ==
Date: Thu, 18 Apr 2024 07:55:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs/045: don't force v4 file systems
Message-ID: <20240418145529.GF11948@frogsfrogsfrogs>
References: <20240418074046.2326450-1-hch@lst.de>
 <20240418074046.2326450-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418074046.2326450-2-hch@lst.de>

On Thu, Apr 18, 2024 at 09:40:42AM +0200, Christoph Hellwig wrote:
> xfs_db can change UUIDs on v5 filesystems now, so we don't need the
> -mcrc=0 in this test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/045 | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index d8cc9ac29..a596635ec 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -26,10 +26,8 @@ _require_scratch_nocheck
>  echo "*** get uuid"
>  uuid=`_get_existing_uuid`
>  
> -# We can only change the UUID on a v4 filesystem. Revist this when/if UUIDs
> -# canbe changed on v5 filesystems.
>  echo "*** mkfs"
> -if ! _scratch_mkfs_xfs -m crc=0 >$tmp.out 2>&1
> +if ! _scratch_mkfs_xfs >$tmp.out 2>&1
>  then
>      cat $tmp.out
>      echo "!!! failed to mkfs on $SCRATCH_DEV"
> -- 
> 2.39.2
> 
> 
