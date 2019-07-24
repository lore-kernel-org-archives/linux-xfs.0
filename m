Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43890 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387897AbfGXU1S (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Jul 2019 16:27:18 -0400
Subject: Re: [PATCH] xfs: fix stack contents leakage in the v1
 bulkstat/inumbers ioctls
From: Eric Sandeen <sandeen@sandeen.net>
References: <20190724153545.GC1561054@magnolia>
 <5158a525-6153-b27f-2d19-c6eb3fbf609e@sandeen.net>
Message-ID: <630545c3-711f-f5e5-e644-88a1ec777397@sandeen.net>
Date: Wed, 24 Jul 2019 15:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <5158a525-6153-b27f-2d19-c6eb3fbf609e@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>

On 7/24/19 3:19 PM, Eric Sandeen wrote:
> On 7/24/19 10:35 AM, Darrick J. Wong wrote:
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Explicitly initialize the onstack structures to zero so we don't leak
>> kernel memory into userspace when converting the in-core structure to
>> the v1 ioctl structure.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
>> ---
>>  fs/xfs/xfs_ioctl.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index f193f7b288ca..44e1a290f053 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
>>  	struct xfs_ibulk		*breq,
>>  	const struct xfs_bulkstat	*bstat)
>>  {
>> -	struct xfs_bstat		bs1;
>> +	struct xfs_bstat		bs1 = { 0 };
>>  
>>  	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
> 
> Confused.  the first thing xfs_bulkstat_to_bstat does is...
> 
> void
> xfs_bulkstat_to_bstat(
>         struct xfs_mount                *mp,
>         struct xfs_bstat                *bs1,
>         const struct xfs_bulkstat       *bstat)
> {
>         memset(bs1, 0, sizeof(struct xfs_bstat));
> 
> so what's leaking here?
> 
>>  	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
>> @@ -732,7 +732,7 @@ xfs_fsinumbers_fmt(
>>  	struct xfs_ibulk		*breq,
>>  	const struct xfs_inumbers	*igrp)
>>  {
>> -	struct xfs_inogrp		ig1;
>> +	struct xfs_inogrp		ig1 = { 0 };
>>  
>>  	xfs_inumbers_to_inogrp(&ig1, igrp);
> 
> ... and this function initializes all elements of xfs_inogrp ig1 AFAICT.
> 
> Maybe I need more coffee?

or I need to read mail in order.  o_O  Ok, struct packing/ hole issues.

But let's be consistent, do we zero it out in the conversion function or
rely on the caller?  (I prefer the former, as is done in xfs_bulkstat_to_bstat,
but we surely don't need to do both).

Also, Fixes: tag please?

-Eric
