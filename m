Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32861 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdGRS1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2017 14:27:46 -0400
Received: by mail-wr0-f194.google.com with SMTP id y43so5461626wrd.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 11:27:46 -0700 (PDT)
Subject: Re: [PATCH, RFC] xfs: fix multi-AG deadlock in xfs_bunmapi
References: <20170718172545.18065-1-hch@lst.de>
 <20170718181535.GJ4224@magnolia>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <f53783a8-3b92-4b07-2d94-e60eb7d878bc@gmail.com>
Date: Tue, 18 Jul 2017 21:27:43 +0300
MIME-Version: 1.0
In-Reply-To: <20170718181535.GJ4224@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org



On 18.07.2017 21:15, Darrick J. Wong wrote:
> On Tue, Jul 18, 2017 at 07:25:45PM +0200, Christoph Hellwig wrote:
>> Just like in the allocator we must avoid touching multiple AGs out of
>> order when freeing blocks, as freeing still locks the AGF and can cause
>> the same AB-BA deadlocks as in the allocation path.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
> 
> Looks ok, though I wonder what the bug report looked like. :)

https://www.spinics.net/lists/linux-xfs/msg05918.html


> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
>> ---
>>  fs/xfs/libxfs/xfs_bmap.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 0a9880777c9c..935adde72a8b 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -5435,6 +5435,7 @@ __xfs_bunmapi(
>>  	xfs_fsblock_t		sum;
>>  	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
>>  	xfs_fileoff_t		max_len;
>> +	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
>>  
>>  	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
>>  
>> @@ -5534,6 +5535,17 @@ __xfs_bunmapi(
>>  		 */
>>  		del = got;
>>  		wasdel = isnullstartblock(del.br_startblock);
>> +
>> +		/*
>> +		 * Make sure we don't touch multiple AGF headers out of order
>> +		 * in a single transaction, as that could cause AB-BA deadlocks.
>> +		 */
>> +		if (!wasdel) {
>> +			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
>> +			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
>> +				break;
>> +			prev_agno = agno;
>> +		}
>>  		if (got.br_startoff < start) {
>>  			del.br_startoff = start;
>>  			del.br_blockcount -= start - got.br_startoff;
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
