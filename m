Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AADE198E61;
	Thu,  6 Jun 2024 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717687374; cv=none; b=O89ijYrkNoIn/IczfPV3BembFRLb7ij+gFp95R2uAVNfNpm/5+uzanitifL62XDNoxTKDDDZefxzYQM4BnofRabfV4bV8fnYWYbQyQug9ioLLveAho5XmRTddz/j9u52DrtEYES6QQlpDdXC0ucICa7P+oNddY6pxL94O0Fo5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717687374; c=relaxed/simple;
	bh=OFB1Pq7p2M5VQwI6homNvC5ZQWi9NYTNddQjaz5fgIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HmuxuKMtjLY/2LELH3iFn2WGD5EVykr3aruu/89Gy1nP/zFAnRWf9By6HKDaMH9qZO+0yppQmxw8bhAjnSvExUyG8+l2kHaskQPhP4DCBweoFgMUT3kj7HITm09y/2zCipnexaHH/7tnCHv5soReO3/ubA+F2AlRYlIVChXIY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmsBVMLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmsBVMLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85E9C4AF0A;
	Thu,  6 Jun 2024 15:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717687373;
	bh=OFB1Pq7p2M5VQwI6homNvC5ZQWi9NYTNddQjaz5fgIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mmsBVMLsGNzthlsMKTREuwaEVtRWeD1BX8+aoLmjldIVI/1D9RHVo+zVTQ2iROyjX
	 Oj3PFquayz+J8gblY01hhr4wiT7ILnaAtM5ICa0ywkgJu7LMbjvocWKlSc8IFKUF8U
	 XfBJ5fpAP/hepHI/EoOBar6zwdUr4DKU/SlxinztYRYZy9Nd4gScyiQ129KaIPO3jV
	 AUeuJF9VbzhPpFJFWM/S2urP6f77iaxGl12RwYWMoRd2ZPBmIKmucSHdexmOGf2Sr5
	 Iu0PSodjPoWCi6rWmoNhPoaFOz/lzzEu+O6bs92ypO9jbDE7Q4I3PECSpuvfIEoUIr
	 iRxqQD8I7C6ig==
Date: Thu, 6 Jun 2024 08:22:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Remove header files which are included more than
 once
Message-ID: <20240606152253.GK52987@frogsfrogsfrogs>
References: <20240606091754.3512800-1-haowenchao22@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606091754.3512800-1-haowenchao22@gmail.com>

On Thu, Jun 06, 2024 at 05:17:54PM +0800, Wenchao Hao wrote:
> Following warning is reported, so remove these duplicated header
> including:
> 
> ./fs/xfs/libxfs/xfs_trans_resv.c: xfs_da_format.h is included more than once.
> ./fs/xfs/scrub/quota_repair.c: xfs_format.h is included more than once.
> ./fs/xfs/xfs_handle.c: xfs_da_btree.h is included more than once.
> ./fs/xfs/xfs_qm_bhv.c: xfs_mount.h is included more than once.
> ./fs/xfs/xfs_trace.c: xfs_bmap.h is included more than once.
> 
> This is just a clean code, no logic changed.
> 
> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>

Assuming this doesn't break the build, looks fine to me
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_trans_resv.c | 1 -
>  fs/xfs/scrub/quota_repair.c    | 1 -
>  fs/xfs/xfs_handle.c            | 1 -
>  fs/xfs/xfs_qm_bhv.c            | 1 -
>  fs/xfs/xfs_trace.c             | 1 -
>  5 files changed, 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 6dbe6e7251e7..3dc8f785bf29 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -22,7 +22,6 @@
>  #include "xfs_rtbitmap.h"
>  #include "xfs_attr_item.h"
>  #include "xfs_log.h"
> -#include "xfs_da_format.h"
>  
>  #define _ALLOC	true
>  #define _FREE	false
> diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
> index 90cd1512bba9..cd51f10f2920 100644
> --- a/fs/xfs/scrub/quota_repair.c
> +++ b/fs/xfs/scrub/quota_repair.c
> @@ -12,7 +12,6 @@
>  #include "xfs_defer.h"
>  #include "xfs_btree.h"
>  #include "xfs_bit.h"
> -#include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
>  #include "xfs_sb.h"
> diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
> index a3f16e9b6fe5..cf5acbd3c7ca 100644
> --- a/fs/xfs/xfs_handle.c
> +++ b/fs/xfs/xfs_handle.c
> @@ -21,7 +21,6 @@
>  #include "xfs_attr.h"
>  #include "xfs_ioctl.h"
>  #include "xfs_parent.h"
> -#include "xfs_da_btree.h"
>  #include "xfs_handle.h"
>  #include "xfs_health.h"
>  #include "xfs_icache.h"
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 271c1021c733..a11436579877 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -11,7 +11,6 @@
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
>  #include "xfs_quota.h"
> -#include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 9c7fbaae2717..e1ec56d95791 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -38,7 +38,6 @@
>  #include "xfs_iomap.h"
>  #include "xfs_buf_mem.h"
>  #include "xfs_btree_mem.h"
> -#include "xfs_bmap.h"
>  #include "xfs_exchmaps.h"
>  #include "xfs_exchrange.h"
>  #include "xfs_parent.h"
> -- 
> 2.38.1
> 
> 
