Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB087273FD
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PprvJy5s"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-53fa455cd94so16781a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 13:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702588426; x=1703193226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=czEMI1Lb1Sq4sZaV1f9tpzIFBmJgBmquel5qYNZs5j4=;
        b=PprvJy5sNPTxb+LHO34dP3fRFD9xbZXVsxTD29/sPy0ev8gdAcxrrFbQHI7rd+/ROc
         OyncGIhcq2lCWq6c9/r1G3p7tZcjzq/AmvTjf504TWpMdqbFt1LjPhWmlQPyc2NJGyuH
         j/KFoMFjo6DuuspjNWBAa55LTGeVYHQ1mDCK2+Kn2X1kY7e7PfXLzhgcTcdpBrS8DzXz
         LG16SrxxqqJwjo6LXIaePbx9xKsO5My9tpAWO4u/nll8X16ndxXj+juQXBBQJLAt8E/Y
         6Dv/atUDLM+kcOSZ+gBeRPg8J+ksfM2pz4rdVkwzWwvsoE72/fn+L/1zxVLIorUbqhu/
         uywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702588426; x=1703193226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=czEMI1Lb1Sq4sZaV1f9tpzIFBmJgBmquel5qYNZs5j4=;
        b=pBP+0Dt+OWRZx8X0bR28iP6k8BCY0yUi0DtHZVCxWpcFsTTfSvDtMuKxSI9wrpc/E8
         tQf/hehcEBJrg1XA4fvgsiESR4TP/LdJtSHrSBWcND3qkejtsIjFvMmPCXH5fxHOmeZL
         xTWq/AnqRkX1yESQdmvAONmNLmMS5d/e0Fc+SFuYdJC9BZTZukoS3i+rTPSJtI32MwGV
         oJzxs17vuMacsC1ndDVXMVvG/XmJsTGa3kot55pTTh7S7vs7WCRI0F1ovGudVXccC0zk
         Nh8LYY84GtaJ+b7yArpPWGywRyIY9tNm+Rjc6LnMlMV7XIVVBKx71cfGl87G/U8JckA0
         2CeA==
X-Gm-Message-State: AOJu0Ywv+UrRWtQr+ZGn3kZXr7VZjkmGBVsxyDfjQGsc+iFZH4XROEVP
	Q+pq8xYid1P9Zuoffmsj+e04YA==
X-Google-Smtp-Source: AGHT+IHSQjHa27Z0+ndJsc8oShzjZ3QkBkKRbR7YVZ9BplTxyjs41eOiQhFRQaEFnsT6hkCFpBbfRQ==
X-Received: by 2002:a17:902:778d:b0:1cf:cc23:eff with SMTP id o13-20020a170902778d00b001cfcc230effmr5814518pll.52.1702588426110;
        Thu, 14 Dec 2023 13:13:46 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902748900b001d33e6521c1sm5344845pll.102.2023.12.14.13.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 13:13:45 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rDt1a-008MNL-2K;
	Fri, 15 Dec 2023 08:13:42 +1100
Date: Fri, 15 Dec 2023 08:13:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org,
	Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: improve handling of prjquot ENOSPC
Message-ID: <ZXtwBg3GUJLDydlW@dread.disaster.area>
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
> +			xfs_iunlock(ip, iolock);
> +			icw.icw_prid = pdqp->q_id;
> +			icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
> +			xfs_blockgc_free_space(ip->i_mount, &icw);
> +			goto write_retry;
> +		}

This is just duplicating the EDQUOT error handling path for the
specific case that project quota exhaustion returns ENOSPC instead
of EDQUOT.  i.e. the root cause of the problem is that project
quotas are returning ENOSPC rather than EDQUOT, right?

Perhaps we should look at having project quotas return EDQUOT like
the other quotas so we get the project quota block scan done in the
correct places, then convert the error to ENOSPC if we get a second
EDQUOT from the project quota on retry?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
