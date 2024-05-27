Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCA415ECEC
	for <linux-xfs@vger.kernel.org>; Mon, 27 May 2024 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716817505; cv=none; b=sTJXYOfujl740z2JJ8MnGmaMk8Hq3ZxFYl9C8W+cit0hoLalJqvgQ7WJTBSCcChW/Te+sA3uonmvXqB14yOoYnJGHIunMH39u0LiIkgKW6fnT9Y/B44aLOnT/3HlTJzK/+TwEIhADyjYdM7n5r4HK6s9P75f81puUoJCqEWXuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716817505; c=relaxed/simple;
	bh=4IXm3Yl7oDe1+t/7xS2Awgu2rRYivEFLXgRHhPcdOpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ha4kmXeGPUkL9SRnREafFDmTAGDqXsjNzWzMOfJIoOTx9xPo322a8nkTJoiTt0GAguURnn1rRXlSKauldBsbIe1SJRZSBizg4PVwR57LSESSpDdSejNBcj5/1kkqFA7FbGNLmYx03I2ppApquaANEwRi1aOZJeLfGfmxKwkQMYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44RDgjxa019453;
	Mon, 27 May 2024 13:44:54 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Dibm.com;_h=3Dcc?=
 =?UTF-8?Q?:content-transfer-encoding:content-type:date:from:in-reply-to:m?=
 =?UTF-8?Q?essage-id:mime-version:references:subject:to;_s=3Dpp1;_bh=3DuSG?=
 =?UTF-8?Q?QRSnvRZfQihTEn+0Rznx9VCq9jJ2IFpz+KUe/nUo=3D;_b=3DQblVpvAGkw3nCo?=
 =?UTF-8?Q?PgR0Hz0mmC8KJBEOxLaeb6yjKXlQpM1dUYkzzvwUxa4F5PEuriXZLy_wAdFIuru?=
 =?UTF-8?Q?CY5MLZKV5JFJZ1BAhQ9qtu32vyOj0AdrMyBDki/M9hMJ89tMj65Pmuf72h8m_z9?=
 =?UTF-8?Q?13dpoBQcTSir2DTfSPauor3iXvOcdyvBa+sxgQQZXR4VOgsa5ocZ29/O7PAojcM?=
 =?UTF-8?Q?5JX_zXMvUk9Q+GymfmIsYwmBrk1j+HbXxbMAEE7cux9j+B0m5gbSIjL2Sr0hDz4?=
 =?UTF-8?Q?mBECykUiQ_kV26z0c3Kw/y/IUZrxzJz9n83/c+AhM6B/MF3SqcWdf9kLv4Baguq?=
 =?UTF-8?Q?xzEicsqrWbQNNry_+A=3D=3D_?=
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ycu9ur04d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 May 2024 13:44:53 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44RDirHw022873;
	Mon, 27 May 2024 13:44:53 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ycu9ur04a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 May 2024 13:44:53 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44RC10ik004505;
	Mon, 27 May 2024 13:44:52 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ybuans92k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 May 2024 13:44:52 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44RDimCP30278348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 May 2024 13:44:50 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5716E20043;
	Mon, 27 May 2024 13:44:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A6E020040;
	Mon, 27 May 2024 13:44:46 +0000 (GMT)
Received: from [9.43.100.127] (unknown [9.43.100.127])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 27 May 2024 13:44:46 +0000 (GMT)
Message-ID: <26730f46-ad28-47f1-bc5f-e719d192f3c5@linux.ibm.com>
Date: Mon, 27 May 2024 19:14:44 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 1/1] xfs: Add cond_resched to block unmap range and
 reflink remap path
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-xfs@vger.kernel.org
Cc: Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong"
 <djwong@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <cover.1715073983.git.ritesh.list@gmail.com>
 <3e1986b79faa3307059ce9d57ff3e44c0d85fe4f.1715073983.git.ritesh.list@gmail.com>
Content-Language: en-GB
From: Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <3e1986b79faa3307059ce9d57ff3e44c0d85fe4f.1715073983.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8pgJJon73PQ9FDL8kh_yuanA_A6CgYMc
X-Proofpoint-GUID: 0_l8VeHCOeFMriv315eqmIyIzQHLsvkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-27_03,2024-05-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1011 mlxlogscore=848
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405270112

On 07/05/24 3:06 pm, Ritesh Harjani (IBM) wrote:

> An async dio write to a sparse file can generate a lot of extents
> and when we unlink this file (using rm), the kernel can be busy in umapping
> and freeing those extents as part of transaction processing.
>
> Similarly xfs reflink remapping path can also iterate over a million
> extent entries in xfs_reflink_remap_blocks().
>
> Since we can busy loop in these two functions, so let's add cond_resched()
> to avoid softlockup messages like these.
>
> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
> CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
> Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
> NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
> LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
> Call Trace:
>    xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>    xfs_alloc_compute_aligned+0x5c/0x144
>    xfs_alloc_ag_vextent_size+0x238/0x8d4
>    xfs_alloc_fix_freelist+0x540/0x694
>    xfs_free_extent_fix_freelist+0x84/0xe0
>    __xfs_free_extent+0x74/0x1ec
>    xfs_extent_free_finish_item+0xcc/0x214
>    xfs_defer_finish_one+0x194/0x388
>    xfs_defer_finish_noroll+0x1b4/0x5c8
>    xfs_defer_finish+0x2c/0xc4
>    xfs_bunmapi_range+0xa4/0x100
>    xfs_itruncate_extents_flags+0x1b8/0x2f4
>    xfs_inactive_truncate+0xe0/0x124
>    xfs_inactive+0x30c/0x3e0
>    xfs_inodegc_worker+0x140/0x234
>    process_scheduled_works+0x240/0x57c
>    worker_thread+0x198/0x468
>    kthread+0x138/0x140
>    start_kernel_thread+0x14/0x18
>
> run fstests generic/175 at 2024-02-02 04:40:21
> [   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>   watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>   CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
>   NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
>   LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
>   Call Trace:
>    0xc000000014107c00 (unreliable)
>    __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
>    xfs_btree_update_keys+0x150/0x170 [xfs]
>    xfs_btree_lshift+0x534/0x660 [xfs]
>    xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
>    xfs_btree_insrec+0x4e4/0x630 [xfs]
>    xfs_btree_insert+0x104/0x2d0 [xfs]
>    xfs_rmap_insert+0xc4/0x260 [xfs]
>    xfs_rmap_map_shared+0x228/0x630 [xfs]
>    xfs_rmap_finish_one+0x2d4/0x350 [xfs]
>    xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
>    xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
>    __xfs_trans_commit+0x1f4/0x400 [xfs]
>    xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
>    xfs_reflink_remap_blocks+0x154/0x320 [xfs]
>    xfs_file_remap_range+0x138/0x3a0 [xfs]
>    do_clone_file_range+0x11c/0x2f0
>    vfs_clone_file_range+0x60/0x1c0
>    ioctl_file_clone+0x78/0x140
>    sys_ioctl+0x934/0x1270
>    system_call_exception+0x158/0x320
>    system_call_vectored_common+0x15c/0x2ec
>
> Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Thanks for the fix patch. I have tested it on a power machine,
and it resolves the soft lockup issue.

Tested-by: Disha Goel<disgoel@linux.ibm.com>

> ---
>   fs/xfs/libxfs/xfs_bmap.c | 1 +
>   fs/xfs/xfs_reflink.c     | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e..44d5381bc66f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
>   		error = xfs_defer_finish(tpp);
>   		if (error)
>   			goto out;
> +		cond_resched();
>   	}
>   out:
>   	return error;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d3..5f26a608bc09 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1417,6 +1417,7 @@ xfs_reflink_remap_blocks(
>   		destoff += imap.br_blockcount;
>   		len -= imap.br_blockcount;
>   		remapped_len += imap.br_blockcount;
> +		cond_resched();
>   	}
>
>   	if (error)
> --
> 2.44.0
>
>
