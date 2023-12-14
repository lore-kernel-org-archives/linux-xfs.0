Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980835F1CF
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 17:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EEn2z1z+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6252CC433C7;
	Thu, 14 Dec 2023 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702573585;
	bh=BUG5csrvXuWh+6X9NndKO5vLr0qZT5vpkfjcCF7Q5Hk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EEn2z1z+P9oKosyieGOFKMj+ym3IOXjaDCTeV4HFlYxfFDD/d8H+YYdE19kBy85eb
	 6ob4ztcqb7A7bor0XcrudZrO9CxQdle9vtX1XcINEsdXGrgoygnPrqJMiaH9usVU0v
	 dXhRDEgUZ2LuDarjejbxUCg2yzYZzO2E+flGpKAC/uXL0HiA70wd68w+/Zlo7Xa4eQ
	 vY5ACOBNTJbggQqNB3ouzADKIJEEDnHQripiHVzv51kYHOZWUTK73iBMcQoIjFMXut
	 s5oxEGjhzKGtkRaQSyW4UaW9hadNr3KlIieJQHxJ7SuuL2XYRE4gxRoF8eqEui8JLU
	 Lt1KzqJU+KP2g==
Date: Thu, 14 Dec 2023 09:06:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: improve handling of prjquot ENOSPC
Message-ID: <20231214170624.GL361584@frogsfrogsfrogs>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214150708.77586-1-wenjianhn@gmail.com>

On Thu, Dec 14, 2023 at 11:07:08PM +0800, Jian Wen wrote:
> Don't clear space of the whole fs when the project quota limit is
> reached, since it affects the writing performance of files of
> the directories that are under quota.
> 
> Only run cow/eofblocks scans on the quota attached to the inode.
> 
> Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> ---
>  fs/xfs/xfs_file.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e33e5e13b95f..4fbe262d33cc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -24,6 +24,9 @@
>  #include "xfs_pnfs.h"
>  #include "xfs_iomap.h"
>  #include "xfs_reflink.h"
> +#include "xfs_quota.h"
> +#include "xfs_dquot_item.h"
> +#include "xfs_dquot.h"
>  
>  #include <linux/dax.h>
>  #include <linux/falloc.h>
> @@ -803,8 +806,18 @@ xfs_file_buffered_write(
>  		goto write_retry;
>  	} else if (ret == -ENOSPC && !cleared_space) {
>  		struct xfs_icwalk	icw = {0};
> +		struct xfs_dquot	*pdqp = ip->i_pdquot;
>  
>  		cleared_space = true;
> +		if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
> +			pdqp && xfs_dquot_lowsp(pdqp)) {

Do not align the if test code with the body.

> +			xfs_iunlock(ip, iolock);
> +			icw.icw_prid = pdqp->q_id;
> +			icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
> +			xfs_blockgc_free_space(ip->i_mount, &icw);

This is an open-coded version of the xfs_blockgc_free_quota above.
The decision-making is complex enough to warrant a helper predicate:

static inline bool want_blockgc_free_quota(struct xfs_inode *ip, int ret)
{
	if (ret == -EDQUOT)
		return true;
	if (ret != -ENOSPC)
		return false;

	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
	    ip->i_pdquot && xfs_dquot_lowsp(ip->i_pdquot))
		return true;

	return false;
}

	if (want_blockgc_free_quota(ip, ret) && !cleared_space) {
		xfs_iunlock(ip, iolock);
		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
		cleared_space = true;
		goto write_retry;
	} else if (ret == -ENOSPC && !cleared_space) {


--D

> +			goto write_retry;
> +		}
> +
>  		xfs_flush_inodes(ip->i_mount);
>  
>  		xfs_iunlock(ip, iolock);
> -- 
> 2.34.1
> 
> 
