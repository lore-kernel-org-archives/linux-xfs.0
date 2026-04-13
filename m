Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3FF303CAB
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 15:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776092834; cv=none; b=OmwYtLk6nw/PNpcHJ//fDDRPKAuxSa0pyoPgsHvMHvxz0OGjTQmgr9J2HIHCyVQGn1m7vmHAaTHqXn6W6FDexyX68Yf+gYValMCXJ4INs7ZFMZST1NkCIf128lCc+J5IQRMrULCqEYutmEoprzeOzt7P1j9h8U1J9Wt295V439w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776092834; c=relaxed/simple;
	bh=EnnjG/JV6RL8cDYd1WfVS8KbqcSxFr01DlwQZdx1FW8=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=HO4Hxlvkkd2ptt50qCKmdnsbITS+v19C51e8k+XylJ42/zXaSJs5UR3/8HSswcrVPgPxvnxD6P//GD0XHpMS3YIQmpQqovdXZKZzoCqOpsibfDdl1IBYsK1BvHj+jpX4jEXTudZUd8KPh4HZ+Xnip5LPKJyqx+Kia0b778ySZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id EB67A180F2E0;
	Mon, 13 Apr 2026 17:07:05 +0200 (CEST)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id XvLiOJkG3WmUdgYAKEJqOA
	(envelope-from <lukas@herbolt.com>); Mon, 13 Apr 2026 17:07:05 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 13 Apr 2026 17:07:05 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, "Darrick J . Wong"
 <djwong@kernel.org>, dgc@kernel.org, gost.dev@samsung.com,
 pankaj.raghav@linux.dev, kundan.kumar@samsung.com, cem@kernel.org,
 hch@infradead.org
Subject: Re: [PATCH v2 0/2] add FALLOC_FL_WRITE_ZEROES support to xfs
In-Reply-To: <20260413133256.3378243-1-p.raghav@samsung.com>
References: <20260413133256.3378243-1-p.raghav@samsung.com>
Message-ID: <3c2e979b144ecc02a5c6ea5eaa004bfd@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2026-04-13 15:32, Pankaj Raghav wrote:
> The benefits of FALLOC_FL_WRITE_ZEROES was already discussed as a part
> of Zhang Yi's initial patches[1]. Postgres developer Andres also
> mentioned they would like to use this feature in Postgres [2].
> 
> This series has the changes proposed by Dave [3].
> 
> I tested the changes with fsstress and fsx based on the xfstests patch 
> I
> sent recently to test this flag[4]. generic/363 helped me debug the
> crash I noticed when I did the initial implementation[3].
> 
> Note: The previous version of Lukas's patches got mixed with version
> numbers. The first patch is v1 while the second patch is v12. I am
> sending it as v2 to make it uniform.
> 
> @Lukas: I didn't notice any activity from you regarding this series
> since last month, so I decided to send it after spending some time on
> Dave's feedback. I hope it is ok with you.
> 
> Changes since v1 [5.1 5.2]:
> - Added a new function xfs_bmap_alloc_or_convert_range() based on 
> Dave's
>   feedback.
> - Changed the xfs_falloc_write_zeroes to use
>   xfs_bmap_alloc_or_convert_range() instead of doing prealloc and
>   convert approach.
> 
> [1] 
> https://lore.kernel.org/linux-fsdevel/20250619111806.3546162-1-yi.zhang@huaweicloud.com/
> [2] 
> https://lore.kernel.org/linux-fsdevel/20260217055103.GA6174@lst.de/T/#m7935b9bab32bb5ff372507f84803b8753ad1c814
> [3] 
> https://lore.kernel.org/linux-xfs/6i2jvzn3lyugjlbgmjzpped3gogzyqv5mpe2uqaifz4vjpaega@pomzoq7ley77/
> [4] 
> https://lore.kernel.org/linux-xfs/20260312195308.738189-1-p.raghav@samsung.com/
> [5.1] 
> https://lore.kernel.org/linux-xfs/20260309180708.427553-2-lukas@herbolt.com/
> [5.2] https://lore.kernel.org/linux-xfs/abC1LvRElctaHPe5@dread/
> 
> Pankaj Raghav (2):
>   xfs: add xfs_bmap_alloc_or_convert_range function
>   xfs: add support for FALLOC_FL_WRITE_ZEROES
> 
>  fs/xfs/xfs_bmap_util.c | 165 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_util.h |   3 +
>  fs/xfs/xfs_file.c      |  56 +++++++++++++-
>  fs/xfs/xfs_iomap.c     | 113 +---------------------------
>  fs/xfs/xfs_iomap.h     |   1 +
>  5 files changed, 227 insertions(+), 111 deletions(-)
> 
> 
> base-commit: e0dc9e0f8da83cb70e2a7e9a10fd3541c2bd9a06

> @Lukas: I didn't notice any activity from you regarding this series
> since last month, so I decided to send it after spending some time on
> Dave's feedback. I hope it is ok with you.

No worries. I have actually very similar patch ready but run into some 
issue
with fsx that i wanted to check first.
-- 
-lhe
