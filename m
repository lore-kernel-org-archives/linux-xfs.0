Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209B321F5E
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784905088; cv=none; b=uIIA1T74Q9dR3En5XqkAupOTQ2VGqzJVzEUMv2xqgMXR/93wFNDbYpKK/eT6uXYwovDIo2sXnvbzHAsSoRoOTjIaErI+ysaxQCJINfRb5CUCbaWsTd/CPXwS3E+FrOr1AOp/Y7oRcUZhRji81kmJ9GJxPx1/EPiqyw4+wgWVtSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784905088; c=relaxed/simple;
	bh=G2o9I89S5wuacRZuT0aUp53MkHxSYgNvKch1jD0dbh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=s8lntOja6zUwwViqcQvAaHTGnSPdeNbVok6aL1sthiuDkD+Ak9tNRxTTuhkliO+I1Gm7k3LTdVW1PxqOr1D8i7UDfaZDNoQLycPi8vRX9GMccabssXjp0hMKDH4XI23TNXjirr1EM36FQAOPyWSj0PviQDR/UWqmkoRVNgxb2kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IU93YA0B; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IU93YA0B"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260724145803epoutp04d82d648267713a4fa952b1fccfb1b8bc~FQbde2isW0735007350epoutp04t
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 14:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260724145803epoutp04d82d648267713a4fa952b1fccfb1b8bc~FQbde2isW0735007350epoutp04t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784905083;
	bh=RlDKF1N50HsiEmVfMhX9vE9WiGz6JSadAcE/1zQN2vU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=IU93YA0BiP5WQtgNQgym4F8uAreIvPDz42vjbPmA1npv18f391gVfYi+Qisyb0sot
	 tYUrcc89/geiGqYo5v6rYNYi4QfMXX5d9WCDqHTe6G5EPp0UBRSJvHraMp4Luxlbjn
	 Cbo9nJYEa2Bk3alBb6IM1u1tF/b/1MnCEy83A08s=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260724145802epcas5p23e58de35e56bf362815d3a34e69a4e8a~FQbdEymDx1115411154epcas5p2B;
	Fri, 24 Jul 2026 14:58:02 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4h6B1j4Z68z3hhT3; Fri, 24 Jul
	2026 14:58:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260724145800epcas5p41d7adc13127a557af92554114e6d33e7~FQbbO4yg-2731027310epcas5p4I;
	Fri, 24 Jul 2026 14:58:00 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260724145758epsmtip1d5c833758f471a46d1b8c43cf355ac04~FQbZZjji50280002800epsmtip11;
	Fri, 24 Jul 2026 14:57:58 +0000 (GMT)
Message-ID: <3eb1b5dc-449c-4d13-ae38-b48e60de8705@samsung.com>
Date: Fri, 24 Jul 2026 20:27:57 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] xfs: generic AG set based steering
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: brauner@kernel.org, hch@lst.de, dgc@kernel.org, jack@suse.cz,
	cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org, ritesh.list@gmail.com,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org, gost.dev@samsung.com, Anuj Gupta
	<anuj20.g@samsung.com>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260721032027.GW7380@frogsfrogsfrogs>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260724145800epcas5p41d7adc13127a557af92554114e6d33e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df
References: <20260717125538.508925-1-joshi.k@samsung.com>
	<CGME20260717125636epcas5p2b68dd498717813e0b395b9d57d9d97df@epcas5p2.samsung.com>
	<20260717125538.508925-5-joshi.k@samsung.com>
	<20260721032027.GW7380@frogsfrogsfrogs>

On 7/21/2026 8:50 AM, Darrick J. Wong wrote:
> On Fri, Jul 17, 2026 at 06:25:36PM +0530, Kanchan Joshi wrote:
>> Improve allocator concurrency and reduce interleaving by introducing
>> fixed sized AG set.
>> Use low bits of the inode as a hash to select AG within the AG set.
>> Overall, a file will try to use the same AG (and contiguity is maintained),
>> but multiple files will be spread across all AGs in the target AG set.
>>
>> Suggested-by: Dave Chinner<dgc@kernel.org>
>> Signed-off-by: Kanchan Joshi<joshi.k@samsung.com>
>> Signed-off-by: Anuj Gupta<anuj20.g@samsung.com>
>> ---
>>   fs/xfs/libxfs/xfs_bmap.c | 38 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index d64defeda645..fd1a3aa4ad3f 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -3192,6 +3192,36 @@ xfs_bmap_select_minlen(
>>   	return args->maxlen;
>>   }
>>   
>> +#define	GENERIC_AG_SET_SZ	(2)
> What does this define?

We need more than 1 AG to do inode-based fanning of files and improve 
concurrency (AGF lock). This is the minimum required to do any 
improvement, in the default allocator.
This 'minimum fan-out' is what Dave suggested to extract out of 
write-stream and apply to two other allocators- default (which is what 
you see now), and filestream (future work).

And this can be reviewed as an independent patch as it does not require 
any other work done in the series. No application input is required, 
this is automatic optimization.

The write-stream allocator (next patch), uses a different AG-set of size 
NR_AGs/NR_WRITE_STREAMs. And that is an explicit (application input 
based) allocator.

  >> +
>> +static inline xfs_agnumber_t
>> +xfs_default_ag_set_size(
>> +	struct xfs_inode	*ip)
>> +{
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +
>> +	return min_t(xfs_agnumber_t, GENERIC_AG_SET_SZ, mp->m_sb.sb_agcount);
> Because I'm not sure what it means on a single-AG filesystem.

On a single-AG filesystem, this will do nothing. The base-AG input given 
by the default allocator will not get changed.

But we get improvements on multi-AG filsystem; not sure if you saw the 
numbers in the cover letter. Corresponding to the 'generic AG-set' below:

1. On regular NVMe

a. Inter-stream concurrency
---------------------------
fio: 4k write, direct IO, 16 jobs, 1 directory, 16 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams

base: 41 KIOPS
generic AG-set: 93 KIOPS (+126%)
write-stream AG-set: 227 KIOPS (+453%)
here, 16 files are assigned 4 unique write-streams (4 files/stream)

b. Intra-stream concurrency
----------------------------
fio: 4k write, direct IO, 4 jobs, 1 directory, 4 files * 8GiB, iodepth 32
xfs: 16 AGs, 4 write-streams, generic AG-set size = 2, write-stream 
AG-set size = 4

base: 59 KIOPS
generic AG-set: 94 KIOPS (+59%)
write-stream AG-set: 112 KIOPS (+89%)
here, 4 files are assigned single write-stream


>> +}
>> +
>> +static xfs_agnumber_t
>> +xfs_ag_to_ag_set(
>> +	struct xfs_bmalloca	*ap,
>> +	xfs_agnumber_t		base_agno)
>> +{
>> +	struct xfs_inode	*ip = ap->ip;
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	xfs_agnumber_t		set_size;
>> +
>> +	/* Apply fanning only for regular file data */
>> +	if (!(ap->datatype & XFS_ALLOC_USERDATA))
>> +		return base_agno;
>> +
>> +	set_size = xfs_default_ag_set_size(ip);
>> +	/* Fan out within the AG set using low bits of the inode */
>> +	return (base_agno + (XFS_INO_TO_AGINO(mp, I_INO(ip)) % set_size)) %
>> +		mp->m_sb.sb_agcount;
>> +}
>> +
>>   static int
>>   xfs_bmap_btalloc_select_lengths(
>>   	struct xfs_bmalloca	*ap,
>> @@ -3587,8 +3617,16 @@ xfs_bmap_btalloc_best_length(
>>   {
>>   	xfs_extlen_t		blen = 0;
>>   	int			error;
>> +	xfs_agnumber_t		target_ag, start_ag;
>>   
>>   	ap->blkno = XFS_INODE_TO_FSB(ap->ip);
>> +
>> +	/* fan out initial AG across the generic AG set */
>> +	start_ag = XFS_FSB_TO_AGNO(args->mp, ap->blkno);
>> +	target_ag = xfs_ag_to_ag_set(ap, start_ag);
>> +	if (target_ag != start_ag)
>> +		ap->blkno = XFS_AGB_TO_FSB(args->mp, target_ag, 0);
> /me wonders, if xfs_bmap_rtalloc looked at ap->blkno for a hint the way
> that the data device allocator does, then would it be trivial to have
> write streams on the rt device too?
Trying to understand if this kind of fanning out (this patch) or the 
logical placement (patch 5 with write-stream based AG placement) help us 
solve anything for rt device?
For regular RT device, the round-robin rotor will distribute files into 
multiple RTGs. So we don't have AGF like contention.
And using write-stream to explicitly send multiple files to a single RTG 
will do more harm than good?

And for zoned RT device, the placement is happening via write-hint.

Am I missing something that you have in mind?

All the above is for logical isolation. For physical isolation, your 
comments already help to establish that write-stream can be made to 
work. For the regular RT device sitting on top of NVMe (FDP-enabled). 
That needs few changes, but in previous patch (#3).


> I guess the tricky part would be figuring out what to do if you ever
> want to switch a file between rt and data devices -- presumably you'd
> just reset the write stream id to the default, but I guess you could
> reject such a switch if the id had been set explicitly.

Yes, we do such checks in patch 3 now also.
