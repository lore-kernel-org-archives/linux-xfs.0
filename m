Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B16529CB57;
	Wed, 20 Aug 2025 05:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755668358; cv=none; b=sPk7SHHq+m+LIL9q6Ba5mOz1aAnuhKmls8jQ3+kBVcPw7mkKZIyI3rmRTzJdFMyJCLpuZByPx35GvvpXicpdUIf8I4d5IS7LiIQ/Sf6QIjBTJUrPj8YmSkx0e5W22AvQek5USlQwTBLDfITTUq5y2IpyI0vHChS1NJLaWRRDZl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755668358; c=relaxed/simple;
	bh=4IJNNQvHmIai+vwBaIMnwAYZOAoRABq3XY2Na4P61Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDQUJpfXhi40/EGs3m70SEyhg/R3NIoYc8QNgA74h0c3FSVkPMSXbrD8DsPmMYX9KnFGa9T54tjY9HZwDi66Fi9vJ4GZ2V3lgAK6WKL1buGvgdfgPwC891NDAf2ROXz8iBqXaT9INBGBNcud7+UBJy4BfTORMm6zILOV1RA7U00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=srvRg8bY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srvRg8bY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7580AC4CEEB;
	Wed, 20 Aug 2025 05:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755668357;
	bh=4IJNNQvHmIai+vwBaIMnwAYZOAoRABq3XY2Na4P61Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=srvRg8bY/SpWTZertXcypNtmAaooFTDfM88RqYfyxTMEASfgo/LKGAkD9qSIj0yvO
	 mDI7Lpw9mbmYA6yZxKEnWYbO5zYCA9pF+qPMccrN0FhmcAGHbxwZJC8TF9onyy8iXZ
	 czuBhdHjoIjaCgXI/zxgXgd29GVt8eByzMLuVUfgRSJ/yALA9rCqUMoYyWMXk+EJ73
	 wKjAqlkeI3u+9/d92eyCPc20XArC7v9Inrew2RqsStZ8IRgxvx9Qltm50qKzuc3Lbm
	 385LYgI+TX0Qf1DeOKmleG2YWnU5hn9Z/DW+lOYu5hsACupzsOmg1VOHrvT6X5vr5y
	 570NnML/rJAcA==
Date: Tue, 19 Aug 2025 22:39:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Liao Yuanhong <liaoyuanhong@vivo.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Remove redundant header files
Message-ID: <20250820053916.GC7965@frogsfrogsfrogs>
References: <20250819131440.153791-1-liaoyuanhong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819131440.153791-1-liaoyuanhong@vivo.com>

On Tue, Aug 19, 2025 at 09:14:38PM +0800, Liao Yuanhong wrote:
> The header file "xfs_rtbitmap.h" is already included on line 24. Remove the
> redundant include.
> 
> Fixes: f1a6d9b4c3177 ("xfs: online repair of realtime file bmaps")
> Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>

https://lore.kernel.org/linux-xfs/20250319034806.3812673-1-nichen@iscas.ac.cn/
?

--D

> ---
>  fs/xfs/scrub/repair.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index d00c18954a26..e35a1c56d706 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -38,7 +38,6 @@
>  #include "xfs_attr.h"
>  #include "xfs_dir2.h"
>  #include "xfs_rtrmap_btree.h"
> -#include "xfs_rtbitmap.h"
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtalloc.h"
>  #include "xfs_metafile.h"
> -- 
> 2.34.1
> 
> 
