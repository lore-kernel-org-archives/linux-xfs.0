Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6BB2F24
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 03:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712116395; cv=none; b=tim5dMKtUnkMjtKHJ66uvoL4AsEaT9gW2rUjThWB78XrbtNqbTqmYGX9AQAyf4GrqN6jmyGjtyR8SjsTbThMdKHJi1Q3H1fOJ0e/8qTfXjHy0rGr3Y4UiuSba+HRL60zlyIvNWWEvh3r3tzgiscQBR5xfE2ZPBJmDnWOdBj5vRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712116395; c=relaxed/simple;
	bh=Mq+Yty6p5zg6T1Tw8xV9HJdMeUSnCHqDZ1qLSdq1M3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vBv1vpMxJ/YBpPbRRvIUs16JrPE0faY127PGkavwLVFpQaDElEaX2ehXCQ38ONC+ELzAyPloqOsWy9hnSyiNBAh1lxzFsFO0TaDBLT7EqyBY6WKU8Uxusqa8qwdmuLQGUj9RkH5QiVUvy4t5OWtSmT2DAdpJE6DJbsvBanzvppo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mM6keJjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mM6keJjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA91C433F1;
	Wed,  3 Apr 2024 03:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712116395;
	bh=Mq+Yty6p5zg6T1Tw8xV9HJdMeUSnCHqDZ1qLSdq1M3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mM6keJjtDnJUAloUCk9SsvdOqW4obzUIdDbBK6uz5fkCbVSxDMLRhWFAjtveWx+Re
	 v1+4Jb7Woc6TygR8mMJ5PArMJfgZE/CZS7P1kOTHWQGCkDyf/76DTYyn4p2iCYwxf7
	 SCkC058Lm/rp5gTynR5denrg1d/8zQmwc90tY2Wwu1FBpjEIkbfMnYf41sn8rY8V4+
	 8vntGBSNhSyhwVm49UlcIgPl3TkvBNEeAMOkuNRg7tQFsHicANl6jHKACbxWKs5rBf
	 2T+0kU0zIgVZjrE69mX3fwSunDt+uMLf1kJbh6Ofgt2k6Q1ACU5E+pPSixFI53drSr
	 IgVffFB96uRQQ==
Date: Tue, 2 Apr 2024 20:53:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 4/4] xfs: validate block count for XFS_IOC_SET_RESBLKS
Message-ID: <20240403035314.GL6390@frogsfrogsfrogs>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-5-david@fromorbit.com>

On Wed, Apr 03, 2024 at 08:38:19AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Userspace can pass anything it wants in the reserved block count
> and we simply pass that to the reservation code. If a value that is
> far too large is passed, we can overflow the free space counter
> and df reports things like:
> 
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/loop0       14M  -27Z   27Z    - /home/dave/bugs/file0
> 
> As reserving space requires CAP_SYS_ADMIN, this is not a problem
> that will ever been seen in production systems. However, fuzzers are
> running with CAP_SYS_ADMIN, and so they able to run filesystem code
> with out-of-band free space accounting.
> 
> Stop the fuzzers ifrom being able to do this by validating that the
> count is within the bounds of the filesystem size and reject
> anything outside those bounds as invalid.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d0e2cec6210d..18a225d884dd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1892,6 +1892,9 @@ xfs_ioctl_getset_resblocks(
>  		if (copy_from_user(&fsop, arg, sizeof(fsop)))
>  			return -EFAULT;
>  
> +		if (fsop.resblks >= mp->m_sb.sb_dblocks)
> +			return -EINVAL;

Why isn't xfs_reserve_blocks catching this?  Is this due to the odd
behavior that a failed xfs_mod_fdblocks is undone and m_resblks simply
allowed to remain?

Also why wouldn't we limit m_resblks to something smaller, like 10% of
the fs or half an AG or something like that?

--D

> +
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -- 
> 2.43.0
> 
> 
