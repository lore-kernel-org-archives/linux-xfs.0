Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F5F1A23B0
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 16:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736528267; cv=none; b=mglxpKitZEoOzKDaS5VrZgYkOpp3RxXUb8/FyGJWzdlwRzJQQTPkElAaN3YfRdn14D5zqlx39vXuQj/APJVjr9/y3Ne80yqK0Lf1STZbb3EZbkEicDQTG8d694d+1T2BCTzXVfgmOY7+3lHeFV5OTNh/NQ0cGMwUnLOYytguNuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736528267; c=relaxed/simple;
	bh=gpbfmFBeIIheLH/68sLKp7sEWPPldkGhxS9dy9hGKyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEQcxiOugWDkFeKwRocwCDq14/VcIeFMAT2yJsrfO2k8qVbkwzzylZmy92dtq/a11LvzobOXWPmN5+OeHFlC9/CnJpmimeUslIhNBw4/yCyhL8Cf6RD6yP2GLuQQos3xLSqWrG7882O1BNRw233D0Eam0CPBMxx8tOwXOkdM2es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u54ApPF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u54ApPF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA7DC4CEE5;
	Fri, 10 Jan 2025 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736528266;
	bh=gpbfmFBeIIheLH/68sLKp7sEWPPldkGhxS9dy9hGKyE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u54ApPF7jitmWsGUxkDrOEFBLt0GdCacKScbopKhD4/2DPbb4/5TLbv1BhwdodFWE
	 CvxCNeHbf5V+yW1lNL7Xui16SIAd4kzlcYDopnIq+f4rkQTvTdq1W7YZ7Rv2IoqcI1
	 XwkXqqHlicJ1O+Z1w6jqU0B5R7FtXVKe19D44JB0xkA1tFACTkFHhC0nddDcjcRD0a
	 lkFm2eSNjH2sXwcJlbCylx+Q5o2jg08NiHwPNp6ZEhWOWM/o/J3vRj7w7/Xz1Iq/G9
	 Azq535UYSVApTpUiHaqTpAyHOV8BDS0awLx7pJbLz7Wma/CNQ6a8GcDjEWRxqQUh0i
	 PtRQO4awlzsfg==
Date: Fri, 10 Jan 2025 08:57:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alistair Popple <apopple@nvidia.com>, linux-xfs@vger.kernel.org
Subject: Re: [bug report] fs/dax: create a common implementation to break DAX
 layouts
Message-ID: <20250110165745.GS1306365@frogsfrogsfrogs>
References: <accc103b-01c9-49a5-b840-43f55c91b1bb@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <accc103b-01c9-49a5-b840-43f55c91b1bb@stanley.mountain>

On Fri, Jan 10, 2025 at 10:03:18AM +0300, Dan Carpenter wrote:
> Hello Alistair Popple,
> 
> Commit 738ec092051b ("fs/dax: create a common implementation to break
> DAX layouts") from Jan 7, 2025 (linux-next), leads to the following
> Smatch static checker warning:
> 
> 	fs/xfs/xfs_inode.c:3034 xfs_break_layouts()
> 	error: uninitialized symbol 'error'.
> 
> fs/xfs/xfs_inode.c
>     3009 int
>     3010 xfs_break_layouts(
>     3011         struct inode                *inode,
>     3012         uint                        *iolock,
>     3013         enum layout_break_reason reason)
>     3014 {
>     3015         bool                        retry;
>     3016         int                        error;
>     3017 
>     3018         xfs_assert_ilocked(XFS_I(inode), XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL);
>     3019 
>     3020         do {
>     3021                 retry = false;
>     3022                 switch (reason) {
>     3023                 case BREAK_UNMAP:
>     3024                         if (xfs_break_dax_layouts(inode))
>     3025                                 break;
> 
> What about if we hit this break on the first iteration?

I think that's a bug, thanks for the wakeup, Dan. :)

--D

>     3026                         fallthrough;
>     3027                 case BREAK_WRITE:
>     3028                         error = xfs_break_leased_layouts(inode, iolock, &retry);
>     3029                         break;
>     3030                 default:
>     3031                         WARN_ON_ONCE(1);
>     3032                         error = -EINVAL;
>     3033                 }
> --> 3034         } while (error == 0 && retry);
>     3035 
>     3036         return error;
>     3037 }
> 
> regards,
> dan carpenter
> 
