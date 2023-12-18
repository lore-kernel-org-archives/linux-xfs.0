Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAB673460
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 22:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oOPsxKQ9"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1d3c1a0d91eso7826815ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 14:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702936843; x=1703541643; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rse6RYEQBv8JkYbhhfqyNwmdyvC2xiwStXj7Gm0NxYU=;
        b=oOPsxKQ9JckhukUVfS0wDrJ6fClr3Cq6jKyEBD4HuTElMBrYzkO6tZYR9KjorRU5sH
         z64zsbVTjsWs+4xL5Kbm17Y+57XnHq2RVeAT0PNcSbygDcqmAjm7sgla4WU2AY6nVBaw
         dHIVc8aMiHU0GB7xPyy+iEp870AFZY54AM8oXA4p/1pL+AlBif92go+Pt6G/Q4KPbWdu
         2tmbn/35/kH3cAFP03zu+4WUZ2kJkGY4l39INxxuqZk5iZOPN96KlCIJaz/3mmtC1Jb1
         qB8MegU2LWnoxfl9zNTR3+uSqnboV0if7CYGTUwee8GsCpW1YzZeAZRqjgCGYcPQeWNI
         Ufeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702936843; x=1703541643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rse6RYEQBv8JkYbhhfqyNwmdyvC2xiwStXj7Gm0NxYU=;
        b=MDY3fXlfH1GaILhLyThiVs4UbrTYxO+LFshaQwPCIoiwzrgJt7WNwdjJpbbrodtATl
         WRmJ2o4Nd3bL+oQjJCJiGHPiahs6YUgfuoTsC/6KNmiM0LR5///BHEgveez7ymCuuZp2
         0/OivaYpHleqFCCWRagb4SBEAZAwI4B9H9NcSKM6qlR0Ah5Spx+okmZLfb3CPdZibCgJ
         rIsdFWSBwHlFqEokgtVjNuDM/KnqpcRxNZqdy39WmzHXNm5bvoxTBKjVfHFs5KuCEwOB
         d8B93Cjotro6a4iMQ6OQHvEG+u+37+PVxhT9C15g9aPc1jtqPhO23JgFRnxvODFntgzf
         mykQ==
X-Gm-Message-State: AOJu0YwwVMvjHex1SZf8Za2P6BuiWXOqAhaYFriYtcJ0qyEJZu61F/nH
	FN7rxAErYlOdfzlgKI+AmYvirQ==
X-Google-Smtp-Source: AGHT+IHm3A/0HfTg5ggEmMv191ULdIepiuMNOP+yVds9kgHVo/zQgxl1VVRfQ3rM/KrouhsKmpQK7g==
X-Received: by 2002:a17:903:110e:b0:1d3:3693:bb98 with SMTP id n14-20020a170903110e00b001d33693bb98mr6397612plh.20.1702936842927;
        Mon, 18 Dec 2023 14:00:42 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902d2c200b001bf044dc1a6sm19470736plc.39.2023.12.18.14.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Dec 2023 14:00:41 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rFLfC-00AA01-2E;
	Tue, 19 Dec 2023 09:00:38 +1100
Date: Tue, 19 Dec 2023 09:00:38 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v2] xfs: improve handling of prjquot ENOSPC
Message-ID: <ZYDBBmZWabnbd3zq@dread.disaster.area>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
 <20231216153522.52767-1-wenjianhn@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231216153522.52767-1-wenjianhn@gmail.com>

On Sat, Dec 16, 2023 at 11:35:22PM +0800, Jian Wen wrote:
> Don't clear space of the whole fs when the project quota limit is
> reached, since it affects the writing performance of files of
> the directories that are under quota.
> 
> Changes since v1:
> - use the want_blockgc_free_quota helper that written by Darrick

I'm not convinced this is correct behaviour.

That is, we can get a real full filesystem ENOSPC even when project
quotas are on and the the project quota space is low. With this
change we will only flush project quotas rather than the whole
filesystem.

That seems like scope for real world ENOSPC regressions when project
quotas are enabled.

Hence my suggestion that we should be returning -EDQUOT from project
quotas and only converting it to -ENOSPC once the project quota has
been flushed and failed with EDQUOT a second time.

Keep in mind that I'm not interested in changing this code to
simplify it - this EDQUOT/ENOSPC flushing is replicated across
multiple fuinctions and so -all- of them need to change, not just
the buffered write path.

IOWs, I'm interested in having the code behave correctly in these
situations. If correctness means the code has to become more
complex, then so be it. However, with some simple refactoring, we
can isolate the complexity and make the code simpler.

> Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> ---
>  fs/xfs/xfs_file.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e33e5e13b95f..7764697e7822 100644
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
> @@ -761,6 +764,20 @@ xfs_file_dax_write(
>  	return ret;
>  }
>  
> +static inline bool want_blockgc_free_quota(struct xfs_inode *ip, int ret)
> +{
> +	if (ret == -EDQUOT)
> +		return true;
> +	if (ret != -ENOSPC)
> +		return false;
> +
> +	if (XFS_IS_PQUOTA_ENFORCED(ip->i_mount) &&
> +	    ip->i_pdquot && xfs_dquot_lowsp(ip->i_pdquot))
> +		return true;
> +
> +	return false;
> +}

>  STATIC ssize_t
>  xfs_file_buffered_write(
>  	struct kiocb		*iocb,
> @@ -796,7 +813,7 @@ xfs_file_buffered_write(
>  	 * running at the same time.  Use a synchronous scan to increase the
>  	 * effectiveness of the scan.
>  	 */
> -	if (ret == -EDQUOT && !cleared_space) {
> +	if (want_blockgc_free_quota(ip, ret) && !cleared_space) {
>  		xfs_iunlock(ip, iolock);
>  		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
>  		cleared_space = true;

IMO, this makes messy code even more messy, and makes it even more
inconsistent with all the EDQUOT/ENOSPC flushing that is done in the
xfs_trans_alloc_*() inode transaction setup helpers.

So, with the assumption that project quotas return EDQUOT and not
ENOSPC, we add this helper to fs/xfs/xfs_dquot.h:

static inline bool
xfs_dquot_is_enospc(
	struct xfs_dquot	*dqp)
{
	if (!dqp)
		return false;
	if (!xfs_dquot_is_enforced(dqp)
		return false;
	if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
		return false;
	return true;
}

And this helper to fs/xfs/xfs_icache.c:

static void
xfs_blockgc_nospace_flush(
	struct xfs_inode	*ip,
	int			what)
{
	if (what == -EDQUOT) {
		xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
		return;
	}
	ASSERT(what == -ENOSPC);

	xfs_flush_inodes(ip->i_mount);
	icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
	xfs_blockgc_free_space(ip->i_mount, &icw);
}

The buffered write code ends up as:

	.....
	do {
		iolock = XFS_IOLOCK_EXCL;
		ret = xfs_ilock_iocb(iocb, iolock);
		if (ret)
			return ret;

		ret = xfs_file_write_checks(iocb, from, &iolock);
		if (ret)
			goto out;

		trace_xfs_file_buffered_write(iocb, from);
		ret = iomap_file_buffered_write(iocb, from,
				&xfs_buffered_write_iomap_ops);
		if (!(ret == -EDQUOT || ret = -ENOSPC))
			break;

		xfs_iunlock(ip, iolock);
		xfs_blockgc_nospace_flush(ip, ret);
	} while (retries++ == 0);

	if (ret == -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
		ret = -ENOSPC;
	.....

This factors out the actual flushing behaviour when an error occurs
from the write code, and removes the clunky goto from the code. It
now clearly loops on a single retry after a ENOSPC/EDQUOT error,
and the high level code transforms the EDQUOT project quota error
once the loop errors out completely.

We can then do the same transformation to xfs_trans_alloc_icreate(),
xfs_trans_alloc_inode(), xfs_trans_alloc_ichange() and
xfs_trans_alloc_dir() using xfs_blockgc_nospace_flush() and
xfs_dquot_is_enospc().

This will then give us consistent project quota only flushing on
project quota failure, as well as consistent full filesystem ENOSPC
flushing behaviour across all types of inode operations.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
