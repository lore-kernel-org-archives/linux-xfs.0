Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48380 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbeGFEPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 00:15:45 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6649IZu017398
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:15:45 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2k0dnjg331-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jul 2018 04:15:45 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w664Fhbq016235
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:15:44 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w664Fh1v017752
        for <linux-xfs@vger.kernel.org>; Fri, 6 Jul 2018 04:15:43 GMT
Subject: Re: [PATCH RFC 2/8] xfs: introduce extents to local conversion helper
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-3-git-send-email-shan.hai@oracle.com>
 <20180706034537.GQ32415@magnolia>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <95380d1e-acb6-2c54-fd78-a316e459c740@oracle.com>
Date: Fri, 6 Jul 2018 12:15:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180706034537.GQ32415@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org



On 2018年07月06日 11:45, Darrick J. Wong wrote:
> On Fri, Jul 06, 2018 at 11:12:23AM +0800, Shan Hai wrote:
>> Delete the extents from xfs inode, copy the data into the data fork,
>> convert the inode from extents to local format and specify log the
>> core and data fork of the inode.
>>
>> Signed-off-by: Shan Hai <shan.hai@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_bmap.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++-
>>   fs/xfs/libxfs/xfs_bmap.h |  4 ++++
>>   2 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
>> index 7205268b30bc..bea6dc254a7d 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.c
>> +++ b/fs/xfs/libxfs/xfs_bmap.c
>> @@ -1,6 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   /*
>>    * Copyright (c) 2000-2006 Silicon Graphics, Inc.
>> + * Copyright (c) 2018 Oracle.
>>    * All Rights Reserved.
>>    */
>>   #include "xfs.h"
>> @@ -213,7 +214,7 @@ xfs_default_attroffset(
>>    * attribute fork from local to extent format - we reset it where
>>    * possible to make space available for inline data fork extents.
>>    */
>> -STATIC void
>> +void
>>   xfs_bmap_forkoff_reset(
> Unrelated change in this patch?

Need this in the 3rd patch to convert the inode from extents to local, 
so export it,
because I thought that the conversion function should reside in the 
xfs_file.c instead
of xfs_bmap.c.

> Also, is it safe to reset forkoff when converting the data fork to
> extents?  Does doing so mes up the attr fork?
>

The attr fork should be aware the forkoff changes, I will double check 
this anyway.

Thanks
Shan Hai
>>   	xfs_inode_t	*ip,
>>   	int		whichfork)
>> @@ -5141,6 +5142,63 @@ xfs_bmap_del_extent_real(
>>   }
>>   
>>   /*
>> + * Convert an inode from extents to the local format.
>> + * Free all the extents of the inode and reset it to the local
>> + * format. Copy the contents of the inode's blocks to the inode's
>> + * literal area.
>> + */
>> +int
>> +xfs_bmap_extents_to_local(
>> +	xfs_trans_t		*tp,
>> +	xfs_inode_t		*ip,
> No typedefs, please.
>
> 	struct xfs_inode	*ip,

OK, I will fix it.

Thanks
Shan Hai
>> +	struct xfs_defer_ops	*dfops,
>> +	int			*logflagsp,
>> +	int			whichfork,
>> +	struct page		*page)
>> +{
>> +	xfs_ifork_t		*ifp = XFS_IFORK_PTR(ip, whichfork);
>> +	xfs_fileoff_t		isize = i_size_read(VFS_I(ip));
>> +	struct xfs_bmbt_irec	got, del;
>> +	struct xfs_iext_cursor	icur;
>> +	int			error = 0;
>> +	int			tmp_logflags;
>> +	char			*kaddr = NULL;
>> +
>> +	ASSERT(whichfork != XFS_COW_FORK);
>> +	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
>> +
>> +	if (xfs_iext_count(ifp) == 0)
>> +		goto init_local_fork;
>> +
>> +	for_each_xfs_iext(ifp, &icur, &got) {
>> +		del = got;
>> +		if (isnullstartblock(got.br_startblock)) {
>> +			error = xfs_bmap_del_extent_delay(ip,
>> +					whichfork, &icur, &got, &del);
>> +			if (error)
>> +				goto out;
>> +		} else {
>> +			error = xfs_bmap_del_extent_real(ip, tp, &icur, dfops,
>> +					NULL, &del, &tmp_logflags, whichfork, 0);
>> +			if (error)
>> +				goto out;
>> +			*logflagsp |= tmp_logflags;
>> +		}
>> +	}
>> +init_local_fork:
>> +	kaddr = kmap_atomic(page);
>> +	xfs_init_local_fork(ip, whichfork, kaddr, isize);
>> +	kunmap_atomic(kaddr);
>> +	ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
>> +	XFS_IFORK_NEXT_SET(ip, whichfork, 0);
>> +	ip->i_d.di_size = isize;
>> +	*logflagsp |= (XFS_ILOG_DDATA | XFS_ILOG_CORE);
>> +out:
>> +	return error;
>> +}
>> +
>> +
>> +/*
>>    * Unmap (remove) blocks from a file.
>>    * If nexts is nonzero then the number of extents to remove is limited to
>>    * that value.  If not all extents in the block range can be removed then
>> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
>> index 9b49ddf99c41..22cd2642f1cd 100644
>> --- a/fs/xfs/libxfs/xfs_bmap.h
>> +++ b/fs/xfs/libxfs/xfs_bmap.h
>> @@ -271,6 +271,10 @@ int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>>   		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
>>   int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>>   		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
>> +int	xfs_bmap_extents_to_local(struct xfs_trans *tp, struct xfs_inode *ip,
>> +		struct xfs_defer_ops *dfops, int *flags, int whichfork,
>> +		struct page *page);
>> +void	xfs_bmap_forkoff_reset(struct xfs_inode *ip, int whichfork);
>>   
>>   static inline int xfs_bmap_fork_to_state(int whichfork)
>>   {
>> -- 
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

