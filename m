Received: from mta0.migadu.com (out-2.mta0.migadu.com [91.218.175.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED8138DC5C
	for <linux-xfs@vger.kernel.org>; Sun, 11 Oct 2026 12:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791721581; cv=none; b=J/kfbVOG0BRlvuOADlB1HtKeDkLzLr/ZTg4uJ0B/yrqa7nXL0umFTbAqr6/kZlX6jd6evYobOmEpAMSsd2/wICcGqydrOjcB5b8jEqRVGCpR1avxZVk/EyUrjQyhj5Ik5toZ+CjhflqLn7RniLFJx+cuXSt15ZNjmTAD+1wLbFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791721581; c=relaxed/simple;
	bh=pU9mn/Zw8O1qrc9J/Qb1vLlvyaHtw1kPAZ1ECq1t0q4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2lui8AZ3UMpFUYB1B+92Np+fZBU4e3LJYEcwSbTSlaAIf45q9UPvgHhSKj8uTQBYYn7Cjt7j34YcYTpCGGRQyh9W6VBPwHevOUr8BmQ+E+BiIeeqia9w+ajxlZCO1IIuFLP3GmBgrr4DglvV9PUInDPbms0ukNe8J/DAYp4KFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WaDpzOQS; arc=none smtp.client-ip=91.218.175.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WaDpzOQS"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pU9mn/Zw8O1qrc9J/Qb1vLlvyaHtw1kPAZ1ECq1t0q4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791721573; v=1; x=1792326373;
 b=WaDpzOQSsMAEZY32Z3gWDtz6mP2Hfdf4yA/rz5Ea9FqVQ/RxMnVQCKHs4Qw1NU+JNjZY3qlR
 3nGa7K+++W6cXYZr/QIr8PzW+WoFCGaHDaN1PmtIF9KXCKXX8azWutN5m1bf/CJzNlqYFNo7iAG
 1f7PbuFrs+IFy9d/etbI89m4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 9147d5ef9226e31b;
	Sun, 11 Oct 2026 12:26:13 +0000
X-Mizu-Trace-ID: 9147d5ef9226e31b
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb0882c6-a10b-4ee0-b3b7-46c2e6c1a518@linux.dev>
Date: Sun, 11 Oct 2026 13:26:12 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] xfs: don't limit software atomic writes by the group
 alignment
To: Pankaj Raghav <p.raghav@samsung.com>, cem@kernel.org,
 linux-xfs@vger.kernel.org
Cc: pankaj.raghav@linux.dev, "Darrick J . Wong" <djwong@kernel.org>,
 gost.dev@samsung.com
References: <20261008111147.3906817-1-p.raghav@samsung.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20261008111147.3906817-1-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/26 12:11, Pankaj Raghav wrote:
> xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
> greatest power-of-two factor of the group size when the device advertises
> atomic writes, so that allocations can be made naturally aligned for
> REQ_ATOMIC. But that value is the software limit: it is only used when
> reflink is enabled, and out of place writes through the COW fork have no
> alignment requirement.
> 
> Compute the software limit from the group size alone, and apply the
> alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
> what reports the size that can be offloaded to the hardware.
> 
> Results on a 14TB device with 16k hardware atomic support with 16k
> blocksize:
> 
> Without patches:
> [nix-shell:~]# trace-cmd report
> cpus=16
> mount-617   [009]  1184.719159: xfs_calc_atomic_write_unit_max: dev 259:2 ag
> max_write 131072 max_ioend 4096 max_gsize 2 awu_max 2
> 
> [nix-shell:~]# ./statx /media/test/hello.txt
> /media/test/hello.txt:
>     stx_atomic_write_unit_min:            16384
>     stx_atomic_write_unit_max:            32768
>     stx_atomic_write_unit_max_opt:        16384
>     stx_atomic_write_segments_max:        1
> 
> With patches:
> [nix-shell:~]# trace-cmd report
> cpus=16
> mount-598   [005]   319.692000: xfs_calc_atomic_write_unit_max: dev 259:2 ag
> max_write 131072 max_ioend 4096 max_gsize 33554432 awu_max 4096
> 
> [nix-shell:~]# ./statx /media/test/hello.txt
> /media/test/hello.txt:
>     stx_atomic_write_unit_min:            16384
>     stx_atomic_write_unit_max:            67108864

We were having problems with xfs test 774 for CoW-based atomics, so can 
you ensure that you rerun this test? Note that I don't think that this 
issue has a resolution yet...

See:
https://lore.kernel.org/linux-xfs/aqxZhKvsHFAyUM5k@dread/

>     stx_atomic_write_unit_max_opt:        16384
>     stx_atomic_write_segments_max:        1
> 
> Fixes: 0c438dcc3150 ("xfs: add xfs_calc_atomic_write_unit_max()")
> Assisted-by: LLM
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
> Note: I cannot use min3 in xfs_get_atomic_write_max_opt because
> xfs_get_atomic_hw_write_align returns xfs_fsize_t.
> 
> Changes since v3:
> - Add xfs_get_atomic_hw_write_align wrapper.
> 
>   fs/xfs/xfs_inode.h |  9 +++++++++
>   fs/xfs/xfs_iops.c  | 30 ++++++++++++++++++++++++------
>   fs/xfs/xfs_mount.c | 35 ++++++++++++++++++++++++-----------
>   fs/xfs/xfs_mount.h |  2 ++
>   4 files changed, 59 insertions(+), 17 deletions(-)
> 

...

>   /*
>    * Return the buftarg used for data allocations on a given inode.
>    */
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index f67a541ef35a..d307ec97fac8 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -642,19 +642,30 @@ xfs_get_atomic_write_max(
>   	 * then advertise a maximum size of whatever we can complete through
>   	 * that means.  Hardware support is reported via max_opt, not here.
>   	 */
> -	if (XFS_IS_REALTIME_INODE(ip))
> -		return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_RTG].awu_max);
> -	return XFS_FSB_TO_B(mp, mp->m_groups[XG_TYPE_AG].awu_max);
> +	return XFS_FSB_TO_B(mp, mp->m_groups[xfs_inode_group_type(ip)].awu_max);
> +}
> +
> +static inline  xfs_fsize_t xfs_get_atomic_hw_write_align(
> +		const struct xfs_inode *ip)
> +{
> +	struct xfs_mount *mp = ip->i_mount;
> +
> +	return XFS_FSB_TO_B(
> +		mp, xfs_calc_group_awu_align_max(mp, xfs_inode_group_type(ip)));

nit: Splitting lines like this is not the nicest codest style, and maybe 
using or or more intermediate variables could be better.

