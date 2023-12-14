Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18226A34D
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NxpDuLR4"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5c68da9d639so44835a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 13:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702590103; x=1703194903; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXKmpukpLkiJFuAifFrfa8WF8QvPINlxlskeOtQPtqg=;
        b=NxpDuLR4d29shXzXVF8v1soboumSMdWn87sci5i9RFA2pVrsAgbghDz66p3Hl3H76l
         gCNdzWC5XxomMhQrFfQTGxGZYzCYw4ABecTOfzXW3mPRJUWQrNqyUnlu9MiPIyUSZdp9
         kXSlwp1EwBuWdEzIe87n0orHVBqU0ilCKnFCHLXQLR1GJ7lIGZjH0yIBJmj61N2u+a+y
         ZrwSP30uQTgOdkZC245nneeQfnLKbF51ZZpcG7e/sXYC1UNGZnYmZu2wxuYDXPdwb4oU
         eL3453POY0LONKq0/nX2W+1/tFhurWJwVlWCm7nZBL9+drEXx5C2Fvh4WFnVTe+9q8A/
         vKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702590103; x=1703194903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mXKmpukpLkiJFuAifFrfa8WF8QvPINlxlskeOtQPtqg=;
        b=a8yDtG40IdROIvYXG6s5n0Ga7Exe88GSuyI/47cnu4vxmgwxQ0SjB4UICCYY2cNACQ
         3759eNjirvit+xFw4Ig9+ai+eo9sx/pa4XLHNa+FPDh4+K7U1zn9QxCwV+iE048jtY3b
         1Fn/YmFL7qoFMj0sKhWIWlHp0Jr+ME4e8G/zdP0REvSunuLhe+ValiLshhkCcwYOwzVI
         n/uGzGikrEq6ybCc/zjjka5VJ5pXq+6t+B2kBYlVvZnyAIP0OrAxgurrEDWQ498g/LNz
         bfC1+unGZG22WML8fwsbIjSYpG9BjhVImuDJF0E4kEI+ea+S5K6IkIrU3hEktbXD6Eyt
         /xgw==
X-Gm-Message-State: AOJu0YwYnRu8EPp8qx2T4sqXKtmDCkbIRkkGAKVnRzrOlOg1dNy17JoG
	TxTGo2fTnYUo1YFZvPtaMj4xCQ==
X-Google-Smtp-Source: AGHT+IFsO7JU1bfxleA6CAtL3i1M3Us6vdjq7z/Gj2nxNRvVA/E9rgJ6QAs6wSAj2FnCjabtkDbIhQ==
X-Received: by 2002:a17:903:230d:b0:1d0:6ffd:cea4 with SMTP id d13-20020a170903230d00b001d06ffdcea4mr6429610plh.93.1702590102939;
        Thu, 14 Dec 2023 13:41:42 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id y12-20020a170902700c00b001bbb8d5166bsm12771224plk.123.2023.12.14.13.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 13:41:42 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rDtSd-008MwP-1x;
	Fri, 15 Dec 2023 08:41:39 +1100
Date: Fri, 15 Dec 2023 08:41:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix an off-by-one error in xreap_agextent_binval
Message-ID: <ZXt2k//lCpW8koWj@dread.disaster.area>
References: <20231214213845.GK361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214213845.GK361584@frogsfrogsfrogs>

On Thu, Dec 14, 2023 at 01:38:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Overall, this function tries to find and invalidate all buffers for a
> given extent of space on the data device.  The inner for loop in this
> function tries to find all xfs_bufs for a given daddr.  The lengths of
> all possible cached buffers range from 1 fsblock to the largest needed
> to contain a 64k xattr value (~17fsb).  The scan is capped to avoid
> looking at anything buffer going past the given extent.
> 
> Unfortunately, the loop continuation test is wrong -- max_fsbs is the
> largest size we want to scan, not one past that.  Put another way, this
> loop is actually 1-indexed, not 0-indexed.  Therefore, the continuation
> test should use <=, not <.
> 
> As a result, online repairs of btree blocks fails to stale any buffers
> for btrees that are being torn down, which causes later assertions in
> the buffer cache when another thread creates a different-sized buffer.
> This happens in xfs/709 when allocating an inode cluster buffer:
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 0 PID: 3346128 at fs/xfs/xfs_message.c:104 assfail+0x3a/0x40 [xfs]
>  CPU: 0 PID: 3346128 Comm: fsstress Not tainted 6.7.0-rc4-djwx #rc4
>  RIP: 0010:assfail+0x3a/0x40 [xfs]
>  Call Trace:
>   <TASK>
>   _xfs_buf_obj_cmp+0x4a/0x50
>   xfs_buf_get_map+0x191/0xba0
>   xfs_trans_get_buf_map+0x136/0x280
>   xfs_ialloc_inode_init+0x186/0x340
>   xfs_ialloc_ag_alloc+0x254/0x720
>   xfs_dialloc+0x21f/0x870
>   xfs_create_tmpfile+0x1a9/0x2f0
>   xfs_rename+0x369/0xfd0
>   xfs_vn_rename+0xfa/0x170
>   vfs_rename+0x5fb/0xc30
>   do_renameat2+0x52d/0x6e0
>   __x64_sys_renameat2+0x4b/0x60
>   do_syscall_64+0x3b/0xe0
>   entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> A later refactoring patch in the online repair series fixed this by
> accident, which is why I didn't notice this until I started testing only
> the patches that are likely to end up in 6.8.
> 
> Fixes: 1c7ce115e521 ("xfs: reap large AG metadata extents when possible")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/reap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
> index 9b6c919db522..f99eca799809 100644
> --- a/fs/xfs/scrub/reap.c
> +++ b/fs/xfs/scrub/reap.c
> @@ -251,7 +251,7 @@ xreap_agextent_binval(
>  		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
>  				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
>  
> -		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
> +		for (fsbcount = 1; fsbcount <= max_fsbs; fsbcount++) {
>  			struct xfs_buf	*bp = NULL;
>  			xfs_daddr_t	daddr;
>  			int		error;

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
