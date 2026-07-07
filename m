Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB649435AAC;
	Tue,  7 Jul 2026 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442171; cv=none; b=mFosU7DKAqOcLWOwdOhn1K3JpEGVL/Ajk2S/n4uZKWif3+JB6SoTjqjzgIfRMAZCahDu8ecyBoI+efmCYQRFJe/wTFcOWQ3e09Bob5DuwzgnL7Ga7MusJrqyl5sML//bQ04bZY7GjRFT828SKZ7DFTTOBQ8r9PQKL8OqhcX2phU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442171; c=relaxed/simple;
	bh=ardfAPNs7uyUKHWm4UwwSQ7IvCm/Z4e3Z4Rq93viROM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+h91h6F4gCQ6CVR/1oplxFebO0jR+SpADQKER+JTJ7AN/o/Mxp0fSLehbnFbR+A8aWikE3uP8LnLjHMkZzGyvvVI3COR2DdeTH8hQWVmq860ANH+qUM9PSZd6B62I6SKfEmKugBNik/JSNSo4QHOqw+APOiwOcJmS6TqePkiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nkC2MkU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nkC2MkU5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6863F1F000E9;
	Tue,  7 Jul 2026 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783442169;
	bh=7UZvSphkQ/LL4Wb1y/b3m3KsjuSdzo7sgsKPfHtillw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nkC2MkU5Cc1aN4yUIBR8Yr2XXVmNqgS43msEWt1EnxrnyZS8ewNHXqiqMgysZw4cF
	 PPyPAYnbQtvnikRyai1RI/XoI+OeMHaW2jI3HrSrwRpMlqTj2YYyHkHl5th7j7ZzC5
	 D6AT6Z/ayIH/30AIyhPpmyvrc1xeMHc/2nX1EsZfyAe0Ehwp1oGgUOwRJ6ysWjJLR/
	 pLgMs/hvrnthhABkVspbhLer2NTVxvJ1zhaBUdMGKREQtQnFOjK5ItV8bpaVodtdr5
	 DLD4miXUuG9bBl6ZvqndmI/2NkbOmqAh0QeUM3wtwJX8RgBuwmFjKiA3WvRaq4X8yQ
	 r9UOuVYxELdAw==
Date: Tue, 7 Jul 2026 09:36:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: reject remote xattr entries with an out-of-range
 value length
Message-ID: <20260707163609.GB9392@frogsfrogsfrogs>
References: <20260707140118.3217585-1-qwe.aldo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707140118.3217585-1-qwe.aldo@gmail.com>

On Tue, Jul 07, 2026 at 11:01:18AM -0300, Aldo Ariel Panzardo wrote:
> xfs_attr3_leaf_verify_entry() validates a remote attribute entry's name
> but never bounds its on-disk value length (xfs_attr_leaf_name_remote.
> valuelen, a __be32). A crafted leaf with valuelen = 0x80000000 passes
> the verifier and the CRC.
> 
> That length is later assigned into the signed int args->rmtvaluelen
> (xfs_attr3_leaf_getvalue), becoming negative, which slips past the signed
> -ERANGE check in xfs_attr_copy_value(); a getxattr() with a small buffer

Shouldn't you fix the signed value check in xfs_attr_copy_value, then?

> then memcpy()s a full remote block into the small kvalue buffer
> (xfs_attr_rmtval_copyout) -- a heap out-of-bounds write with
> attacker-controlled content, from an unprivileged getxattr(2) on a
> mounted crafted image.
> 
> Reject remote entries whose value length exceeds XFS_XATTR_SIZE_MAX in
> the leaf verifier, so the malicious block is rejected at read time.
> 
> Fixes: c84760659dcf ("xfs: check attribute leaf block structure")
> Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

This ought to cc stable.

> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 86c5c09a5db4..f1769289f908 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -339,6 +339,8 @@ xfs_attr3_leaf_verify_entry(
>  		if (!(ent->flags & XFS_ATTR_INCOMPLETE) &&
>  		    rentry->valueblk == 0)
>  			return __this_address;
> +		if (be32_to_cpu(rentry->valuelen) > XFS_XATTR_SIZE_MAX)
> +			return __this_address;

This looks correct though.

--D

>  	}
>  
>  	if (name_end > buf_end)
> -- 
> 2.43.0
> 
> 
