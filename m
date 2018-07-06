Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53820 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752941AbeGFEZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 00:25:05 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w664JjV3023850
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:25:05 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2k0dnjg3f4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 04:25:04 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w664P3hM004152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:25:04 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w664P26p006020
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:25:03 GMT
Subject: Re: [PATCH RFC 3/8] xfs: convert inode from extents to local format
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-4-git-send-email-shan.hai@oracle.com>
 <20180706034737.GR32415@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <48428b90-ff95-3a33-85ee-2e86c839b355@oracle.com>
Date: Fri, 6 Jul 2018 12:24:56 +0800
MIME-Version: 1.0
In-Reply-To: <20180706034737.GR32415@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年07月06日 11:47, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 11:12:24AM +0800, Shan Hai wrote:
>> Introduce a function to convert an inode from extents to local
>> format. The conversion happens at writeback time, this avoids
>> interfering with the delayed allocation and page cache vs
>> xfs_buf operations, the will be inlined data is directly got
>> from the page which was read and modified by the iomap write actor.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   fs/xfs/xfs_aops.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 60 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>> index 8eb3ba3d4d00..ac5a7695f363 100644
>> --- a/fs/xfs/xfs_aops.c
>> +++ b/fs/xfs/xfs_aops.c
>> @@ -9,6 +9,7 @@
>>   #include "xfs_log_format.h"
>>   #include "xfs_trans_resv.h"
>>   #include "xfs_mount.h"
>> +#include "xfs_defer.h"
>>   #include "xfs_inode.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_inode_item.h"
>> @@ -887,6 +888,55 @@ xfs_map_cow(
>>   	return 0;
>>   }
>>   
>> +static int
>> +xfs_inode_extents_to_local(
>> +	xfs_inode_t		*ip,
>> +	int			whichfork,
>> +	struct page		*page)
>> +{
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct xfs_trans	*tp;
>> +	struct xfs_defer_ops	dfops;
>> +	xfs_fsblock_t		first_block;
>> +	int			logflags;
>> +	int			error = 0;
>> +
>> +	if (i_size_read(VFS_I(ip)) > XFS_IFORK_DSIZE(ip))
>> +		return 0;
> If it's too big to fit in local format, then isn't this an error?

No, it's not, because the written data travels to writeback means that 
the inode is
still in extents format since the higher level write_iter ends the write 
process by
copying the data to the data fork when the inode is in local format, it 
never let the
local format inode to go down the writeback path.

The xfs_writepage_map will continue as if nothing happens when 
xfs_inode_extents_to_local
returns 0.

Thanks
Shan Hai
> --D
>
>> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>> +	xfs_trans_ijoin(tp, ip, 0);
>> +
>> +	xfs_defer_init(&dfops, &first_block);
>> +
>> +	logflags = 0;
>> +	error = xfs_bmap_extents_to_local(tp, ip, &dfops, &logflags,
>> +			XFS_DATA_FORK, page);
>> +	if (error)
>> +		goto trans_cancel;
>> +
>> +	xfs_trans_log_inode(tp, ip, logflags);
>> +	error = xfs_defer_finish(&tp, &dfops);
>> +	if (error)
>> +		goto trans_cancel;
>> +	error = xfs_trans_commit(tp);
>> +	if (error)
>> +		goto error0;
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +
>> +	return 0;
>> +
>> +trans_cancel:
>> +	xfs_defer_cancel(&dfops);
>> +	xfs_trans_cancel(tp);
>> +error0:
>> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>> +	return error;
>> +}
>>   /*
>>    * We implement an immediate ioend submission policy here to avoid needing to
>>    * chain multiple ioends and hence nest mempool allocations which can violate
>> @@ -920,6 +970,8 @@ xfs_writepage_map(
>>   	int			count = 0;
>>   	int			uptodate = 1;
>>   	unsigned int		new_type;
>> +	xfs_inode_t		*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>>   
>>   	bh = head = page_buffers(page);
>>   	offset = page_offset(page);
>> @@ -1044,6 +1096,14 @@ xfs_writepage_map(
>>   		end_page_writeback(page);
>>   	}
>>   
>> +	if (!error) {
>> +		if (xfs_sb_version_hasinlinedata(&mp->m_sb) &&
>> +				i_size_read(inode) <= XFS_IFORK_DSIZE(ip)) {
>> +			error = xfs_inode_extents_to_local(ip, XFS_DATA_FORK,
>> +								page);
>> +		}
>> +	}
>> +
>>   	mapping_set_error(page->mapping, error);
>>   	return error;
>>   }
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

