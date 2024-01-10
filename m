Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F054F1E4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 21:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="zkhI5Tuw"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-28cec7ae594so3917188a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 13:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1704922733; x=1705527533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XrbTN8KzMvyOTukZ4HfVaVUTsChhcbfTU65FYYMgGLo=;
        b=zkhI5TuwI2bRxaAM2k32ILxsfEbtJHpMiUw8LrKJnmvuCFaETB3Rr1ZD+7UTFeQ99f
         JiEoojZi+7A4MwQXQA7jx2TxPOQpLTjyBnwqoHiPRt0sS+3zDTEDbfcP4Wjj/ytEQ+K9
         0/apB9BHPE9yPiN7WkJ3qJw+QZsQE5QK5Qd6bG/yp2RL/efPaGyh3boY5I3PSAICSaYq
         0v7LNhwg/4UiBMTRKtV199XBeEwU6zPXwiFcaEfYCRgNSteUPKEEPtdimdDrcLZpA2dK
         jsQFz6UwD2vb26Yd4BULXH4pQ00Zpx5zcQN9JRa8qL+14HQGetXY2WibNUzl9wM84OBP
         OZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704922733; x=1705527533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XrbTN8KzMvyOTukZ4HfVaVUTsChhcbfTU65FYYMgGLo=;
        b=Wxqb+hc/P7niORnzo4+8dZQKgnfl4g+iQAWbp3zZVenjm1tWiMioMLXSv+Jmu0dRlD
         932AtuFpcaCOxhnHrjm7L6BKNlkAksgRxNHjxsHqlLR0IxCi6exmXUXzKX+wjnrMq8Kj
         YHQQqmXJL6kZ8QkE8l5oMo2JQoCNzOUOEywYhnn1i8dgNmeiH894oHFt2RhdMLf3Cd/I
         bAC/WkPJ8Z2l7MNZIPlCMVED3NljMWQKmnej+R4rWTk5dj6xkDmekgAoHRGAO4NOA6d3
         pF0h3gTBHixRkYQPy7UIdzL6ziYoJjwStk/hO2wmkuazkD1TGY6KIgvPA0JKdZ8V/JL/
         rYyg==
X-Gm-Message-State: AOJu0YwPTNAcaDafe0+e+R3TJ71MhRXoj5HJd+0a0KdZ0VE1iPJoLO1K
	7sNII+wzDPMNL/w57dFWD7sUqd+Ewxa6hQ==
X-Google-Smtp-Source: AGHT+IFI5g+Etj1yDnVlqd/4IBxEmU7znIWrtaFA3eG4dgekoYsCNC1SBOkvQBXe52K+vwz+GRe0dA==
X-Received: by 2002:a17:90a:6289:b0:28c:fa4f:2624 with SMTP id d9-20020a17090a628900b0028cfa4f2624mr158778pjj.60.1704922733222;
        Wed, 10 Jan 2024 13:38:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id qj7-20020a17090b28c700b0028bcc2a47e9sm2097208pjb.38.2024.01.10.13.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jan 2024 13:38:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rNgHg-008g5F-3A;
	Thu, 11 Jan 2024 08:38:49 +1100
Date: Thu, 11 Jan 2024 08:38:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH] xfs: explicitly call cond_resched in
 xfs_itruncate_extents_flags
Message-ID: <ZZ8OaNnp6b/PJzsb@dread.disaster.area>
References: <20240110071347.3711925-1-wenjian1@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110071347.3711925-1-wenjian1@xiaomi.com>

On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> From: Jian Wen <wenjianhn@gmail.com>
> 
> Deleting a file with lots of extents may cause a soft lockup if the
> preemption model is none(CONFIG_PREEMPT_NONE=y or preempt=none is set
> in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=y.

Time for them to move to CONFIG_PREEMPT_DYNAMIC?

Also there has been recent action towards removing
CONFIG_PREEMPT_NONE/VOLUNTARY and cond_resched() altogether because
the lazy preemption model coming present in the RTPREEMPT patchset
solves the performance issues with full preemption that PREEMPT_NONE
works around...

https://lwn.net/Articles/944686/
https://lwn.net/Articles/945422/

Further, Thomas Gleixner has stated in those discussions that:

	"Though definitely I'm putting a permanent NAK in place for
	 any attempts to duct tape the preempt=NONE model any
	 further by sprinkling more cond*() and whatever warts
	 around."

https://lwn.net/ml/linux-kernel/87jzshhexi.ffs@tglx/

> Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> the below softlockup warning.

IOWs, this is no longer considered an acceptible solution by core
kernel maintainers.

Regardless of these policy issues, the code change:

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c0f1c89786c2..194381e10472 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -4,6 +4,7 @@
>   * All Rights Reserved.
>   */
>  #include <linux/iversion.h>
> +#include <linux/sched.h>

Global includes like this go in fs/xfs/xfs_linux.h, but I don't
think that's even necessary because we have cond_resched() calls
elsewhere in XFS with the same include list as xfs_inode.c...

>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
>  		error = xfs_defer_finish(&tp);
>  		if (error)
>  			goto out;
> +
> +		cond_resched();
>  	}

Shouldn't this go in xfs_defer_finish() so that we capture all the
cases where we loop indefinitely over a range continually rolling a
permanent transaction via xfs_defer_finish()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
