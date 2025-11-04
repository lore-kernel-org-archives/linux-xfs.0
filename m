Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DA52D0602
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762295118; cv=none; b=NfGej1+2uVWyl7PiKwHxekTd8eaCkR3tUsjxncEEXfMsvf+UM6XnqiH7ldHbYae5F47v0+emQ+2oytH5We5DKgfkBWasvc+lJ5zdvAdknECMnGBDKrL4G5dUVg0K1E44TyjlLHUlh6a9uy2nWpFnMt8VXk05SRkTSdQF04p6A7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762295118; c=relaxed/simple;
	bh=p5l80dcXkcCAE0vnEVTmS/nMycqEBzI3Y9/zXt56fYo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nwjHjgbHmCYDBRTQn2A9+5E+lLJzu2f80ikPtVPDREbd9XbLYjuOcz8gfoJiZ/pvS9fgxddJ6xapiF3eB6GMqKr2fOFm1UzFqAurp9OAnm5eBxeWsg4kZL12GIqkB5thXzcpZGqcT30DnUx3GB5p4uC1ssKUnZ6rXWFgNYBE+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=EpFKCUaC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="EpFKCUaC"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f67ba775aso7432870b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 14:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762295116; x=1762899916; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfVo0ghaSwYUhQpSVBTKd6jfQxJ/5xLzr1dNo6E0CE0=;
        b=EpFKCUaCnKiRcmcZ8qYLl7rU4LAcph0TdGfcoER+Z0CRLMCZUqoU6GwW83va5mp23Y
         dUlqjN4U1SaG9IS/S/VzFGRSaeUwmIv4HC1Hu1RwcMMEDG7vv5MxLY4buTzZVuXf94PI
         4o93CsIzYh12mYWBdWeS/WK1LNh0/+LLq68AkGl2FnUdZWzn1f/aNaMM41pklX+TDfkW
         5y8Fh8i8soyHvWxVJFqmJ94WHLc/DW2sQyULidyds/ekrMC5TnMcJVTmWTIdGepxEfs4
         +vDWeKaa63ITCl0yKAYQlqyYF4t3z4Cuz8kOdENGqneCyzZXZ7Kpd7iAUYlKh7DQ5Dap
         gqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762295116; x=1762899916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mfVo0ghaSwYUhQpSVBTKd6jfQxJ/5xLzr1dNo6E0CE0=;
        b=K+A8GGn9isjMRsOgTAGjAqEc2dRxEBGHO9wkbnIlVIUb+vQw1GCAQsP1HKTJycKOKe
         tHHwwwnLvDiWG0utKQxX0wee/sWrQ4IlFW2LzmWdavEVTx+x9foIUjEZZqm94WWwOaWI
         pvM9LT5AW5SlUEVvbveSHKanqmd8EwUJOT24pGxjfsYWU2dfWrBV94ZP8R0J+LqI0RvD
         dG0iEonUqcUzBeWHD8PvPG48CgWSwqU7P9frZxWVs77UcPAldh0qu7gPnIU/neciq7NL
         iFGBtaNzZxdlrok9D1S87bk7/Hm0WE2FMYtLZH5bKu8I/GaYcUjQndoNgzIIPDwB6QnE
         HQrQ==
X-Gm-Message-State: AOJu0YxIJRNSjGNCfLG3NLqDX7llWICdMMZiaosQzqnaL6F0YZkw4/+P
	d0OY5VE4okZbpdignIipfUxBuz67hUbiTMLF4/UcOx2GTG2rSCc/pbtP8ZOAxQhxjYM=
X-Gm-Gg: ASbGncvMpwK1Cok0O/MS5AlwCqHe6v84qg2xPnxRNQLbhaHfrTISijJgZTgV7/zjUZU
	yA2j9DIsttjjKeYrdRLWAQ6TwgssLQQaq8gDTCI9X1/cuxqmMvaLNjUpDDZ1QTWgNS9U7qKBxMN
	usS+RRGatSBoXTlXAVdnpOhqZkXupR+H6ZOQKTMPMLm2soDHTh/W7rOq08eli19fhKRcVvmvf4b
	whWo8lZIfnjUE78YnyZcfwsrxgQSErjJVoRGSP2QXRYqsOrPS+UW+QxirJnbs8lngv/2/h+3fik
	MMPk/TRcyPvI7/ZeZEYbziCwLAsJMrVuKcIguHRICIsWzUDyUotonU253iypuM3Psqktw31EsfC
	z1gYL9Woe2NvykMyeNMomYFIkfVqfbDh54Vj9qDu5WhcBzC6OtBIVntcccyyNaKPFFaiF7eRBDl
	Gy73A7k1Lge37GwskxZAsxg+QqK5OqVzA3CVybBk0YE6tCH3ECR3nhTSvOOb/WmA==
X-Google-Smtp-Source: AGHT+IEMSn9BWbkIBOxsYUwxKzHgUsv59VV4FRGeVBsOTu/YzTxRUlpu9CVpwX1UWfniKOU5MASN3w==
X-Received: by 2002:a05:6a00:ccf:b0:7ab:8583:9cc7 with SMTP id d2e1a72fcca58-7ae1ed9fadamr1142095b3a.16.1762295116134;
        Tue, 04 Nov 2025 14:25:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd382ad96sm4113517b3a.22.2025.11.04.14.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:25:15 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vGPSi-00000006TiP-37Uf;
	Wed, 05 Nov 2025 09:25:12 +1100
Date: Wed, 5 Nov 2025 09:25:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: transaction assertion failure in next-20251103
Message-ID: <aQp9SM38XmXBEipd@dread.disaster.area>
References: <aQohjfEFmU8lef6M@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQohjfEFmU8lef6M@casper.infradead.org>

On Tue, Nov 04, 2025 at 03:53:49PM +0000, Matthew Wilcox wrote:
> Two runs of xfstests, two assertion failures.  One while running
> generic/083, one while running generic/561.
> 
> Here's the g/561 failure:
> 
> generic/561       run fstests generic/561 at 2025-11-03 22:20:18
.....
> XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_trans_mod_sb+0x2a4/0x310 (fs/xfs/xfs_trans.c:353).  Shutting down filesystem.
> XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> XFS: Assertion failed: tp->t_blk_res >= tp->t_blk_res_used, file: fs/xfs/xfs_trans.c, line: 120
....
>  xfs_trans_dup+0x258/0x270
>  xfs_trans_roll+0x48/0x120
>  xfs_defer_trans_roll+0x5f/0x1a0
>  xfs_defer_finish_noroll+0x3d5/0x5d0
>  xfs_trans_commit+0x4e/0x70
>  xfs_iomap_write_unwritten+0xe5/0x350

So we have a block reservation for a double split of the BMBT
(which technically cannot happen for a double adjacent record
insert) yet we apparently exhausted the entire block allocation.

Thing is, modifications to tp->t_blk_res_used can only be done
through xfs_trans_mod_sb() during the transaction, which
does:

        case XFS_TRANS_SB_FDBLOCKS:
                /*
                 * Track the number of blocks allocated in the transaction.
                 * Make sure it does not exceed the number reserved. If so,
                 * shutdown as this can lead to accounting inconsistency.
                 */
                if (delta < 0) {
                        tp->t_blk_res_used += (uint)-delta;
                        if (tp->t_blk_res_used > tp->t_blk_res)
                                xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE); 

Which will shut down the filesystem the moment a block allocation
overrun occurs. This should happen long before we get to the
transaction commit code...

IOWs, the internal runtime transaction accounting check whenever
tp->t_blk_res_used is updated passed just fine, but it was then
detected as broken a short time later at transaction commit time.

This implies something external modified either tp->t_blk_res or
tp->t_blk_res_used between the last time it was modified by the
filesystem and when it bounds checked and when the transaction was
committed and rolled.

This, to me, smells of external memory corruption, not an XFS bug...

> CPU: 3 UID: 0 PID: 338999 Comm: kworker/3:12 Not tainted 6.18.0-rc4-next-2025110

... and you are testing on a -next kernel, so it's entirely possible
that there is newly introduced memory corruption bug somewhere
outside of XFS.

Can you reproduce this on a vanilla v6.18-rc4 kernel?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
