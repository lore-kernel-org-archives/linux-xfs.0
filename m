Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AEDDF4D
	for <linux-xfs@vger.kernel.org>; Wed,  6 Mar 2024 04:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709700877; cv=none; b=gWi1ljDI6uN8nV2YXyjudT2u9C9jt1akdCCDx67RaFxyE4Nr1Z4Qp+AUaXn1XM5aMlSeVTcnxUpxQAf+ZTGHnZwS+2Hec19mce1Vytc78Dkh1tk78L5oa2WuWToKUneT236cBcL8By5BqRkAzAqy3Y6Zl5LeJA4X1BovoPzLGLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709700877; c=relaxed/simple;
	bh=TSx4a/5G8isXOpjofElD1HnRFkIeY3Utv3A/FcRTUkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IDSFR0hnuX3F0RTcS6UWMkOYjy6o+ukJaarU9wnq3ilmPOz70t8iyKg/bPJsgJ7zuJOLMiKoVsKaEjO9/a2JwHE1u6K8mxDeXTb798ZA2mTL48mt1M+QKko0NcDRPnj3PVS6c8qIRkn80/kjSsqai3Ijf4agpgfWjypdA/Qbxj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JaaDCktZ; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JaaDCktZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709700865; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jPMD6zzUml8QK6+MmcGo3S/y8dAJxEQfXohnfyNHFlM=;
	b=JaaDCktZOlYqvWcNpXqTZfGbcwTnuR/wCZG2H/XNquq3CzK2jhaMoG5Rw0I79NiKMIO94hVjbUmIHDooOxhwK0PmryNGEZ8DW7qMWn9aMjdf77O3k3xzzq2mZHmSJOrA+wblYpxepC2pl8VLcsiJ9qIRYDBv8dADfkMPNL147M0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0W1wFcTn_1709700863;
Received: from 30.97.48.227(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W1wFcTn_1709700863)
          by smtp.aliyun-inc.com;
          Wed, 06 Mar 2024 12:54:25 +0800
Message-ID: <ddf7d130-fb41-4fa6-b4e4-41585aef9204@linux.alibaba.com>
Date: Wed, 6 Mar 2024 12:54:23 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: shrink failure needs to hold AGI buffer
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: chandanbabu@kernel.org
References: <20240306011246.1631906-1-david@fromorbit.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20240306011246.1631906-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024/3/6 09:12, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Chandan reported a AGI/AGF lock order hang on xfs/168 during recent
> testing. The cause of the problem was the task running xfs_growfs
> to shrink the filesystem. A failure occurred trying to remove the
> free space from the btrees that the shrink would make disappear,
> and that meant it ran the error handling for a partial failure.
> 
> This error path involves restoring the per-ag block reservations,
> and that requires calculating the amount of space needed to be
> reserved for the free inode btree. The growfs operation hung here:
> 
> [18679.536829]  down+0x71/0xa0
> [18679.537657]  xfs_buf_lock+0xa4/0x290 [xfs]
> [18679.538731]  xfs_buf_find_lock+0xf7/0x4d0 [xfs]
> [18679.539920]  xfs_buf_lookup.constprop.0+0x289/0x500 [xfs]
> [18679.542628]  xfs_buf_get_map+0x2b3/0xe40 [xfs]
> [18679.547076]  xfs_buf_read_map+0xbb/0x900 [xfs]
> [18679.562616]  xfs_trans_read_buf_map+0x449/0xb10 [xfs]
> [18679.569778]  xfs_read_agi+0x1cd/0x500 [xfs]
> [18679.573126]  xfs_ialloc_read_agi+0xc2/0x5b0 [xfs]
> [18679.578708]  xfs_finobt_calc_reserves+0xe7/0x4d0 [xfs]
> [18679.582480]  xfs_ag_resv_init+0x2c5/0x490 [xfs]
> [18679.586023]  xfs_ag_shrink_space+0x736/0xd30 [xfs]
> [18679.590730]  xfs_growfs_data_private.isra.0+0x55e/0x990 [xfs]
> [18679.599764]  xfs_growfs_data+0x2f1/0x410 [xfs]
> [18679.602212]  xfs_file_ioctl+0xd1e/0x1370 [xfs]
> 
> trying to get the AGI lock. The AGI lock was held by a fstress task
> trying to do an inode allocation, and it was waiting on the AGF
> lock to allocate a new inode chunk on disk. Hence deadlock.
> 
> The fix for this is for the growfs code to hold the AGI over the
> transaction roll it does in the error path. It already holds the AGF
> locked across this, and that is what causes the lock order inversion
> in the xfs_ag_resv_init() call.
> 
> Reported-by: Chandan Babu R <chandanbabu@kernel.org>
> Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Thanks,
Gao Xiang
