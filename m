Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE8912E61;
	Thu, 11 Jul 2024 02:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720666501; cv=none; b=HBSv2WDNFE9+yUBE7b3UPYp0bCUCwQvst1XYeqHWV4QSRf0djK7H3wr8paHY9KS+9o0sgYOH/9bZLFk2h0c7ppjIPRkQ7bSiOQZ3H2EsVYdaJ0LeA/TdQaTgKK8A2bkoDH9tXpXYbN/NJW09Ue1x4QfH8kKtpsNcwGJiRdtV+jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720666501; c=relaxed/simple;
	bh=nViiivsyjPZ+ZIs8S01p3tG1NBeqW2MnvOAf6w22IP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDzLDpm0gm6pk183h1E9MLd/d5EyxVhi0FGUUcOzzDkcuPs3nb4izKtJF+MDK77v6P8I589vEsNv2rNDnxpyx6FQ/pas/J3mxp8AvOLJNjWlUxmfXIooAxsw1NFznPOlmriK3t8H/Xyi5td1VxvezgQy50wtgScIxaMl8gme55Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJIobgSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJIobgSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC93C32782;
	Thu, 11 Jul 2024 02:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720666500;
	bh=nViiivsyjPZ+ZIs8S01p3tG1NBeqW2MnvOAf6w22IP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJIobgSIRPp1jNl4EXiJ4qdQs5LiZ279JVex5fXIyWAH99Tf4tzcVJYVv0Wmgynmm
	 JxIdaNmM8UUKHFaC7uOjWbc/L5cCDwFCQ+AWxjSSXgSmz00/9N3iMK+Hv1VABRKp5v
	 fpsh7oPLz4yChbFiSsQevF2wIPxUCvDdoC5sXgQHRV3panNyxvp8/UWkUK1tXf7Cw8
	 ufgvQbk1rIkosFNjKEpc5coMQFLKZayEp5nbU0/MH/j2Y48wy/9HYrXsU/mU4r7kbC
	 v39sMmgjCT7jcsOI4NDJDS/S9vlGxUWisrrxDoxeRriAblMCrr+8bXf6Z7JA93APQl
	 +f8AlWE+mwqCQ==
Date: Wed, 10 Jul 2024 19:55:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] xfs: Remove duplicate xfs_trans_priv.h header
Message-ID: <20240711025500.GI612460@frogsfrogsfrogs>
References: <20240710024514.49176-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710024514.49176-1-jiapeng.chong@linux.alibaba.com>

On Wed, Jul 10, 2024 at 10:45:14AM +0800, Jiapeng Chong wrote:
> ./fs/xfs/libxfs/xfs_defer.c: xfs_trans_priv.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9491
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 40021849b42f..2cd212ad2c1d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -28,7 +28,6 @@
>  #include "xfs_da_format.h"
>  #include "xfs_da_btree.h"
>  #include "xfs_attr.h"
> -#include "xfs_trans_priv.h"
>  #include "xfs_exchmaps.h"
>  
>  static struct kmem_cache	*xfs_defer_pending_cache;
> -- 
> 2.20.1.7.g153144c
> 
> 
