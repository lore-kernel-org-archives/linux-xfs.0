Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34294 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751791AbdDASOH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 1 Apr 2017 14:14:07 -0400
Subject: Re: [PATCH] xfs: fix memory exposure problems
References: <20170401012934.GI4864@birch.djwong.org>
 <20170401070406.GA6051@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3dc02d1c-9aa4-0682-1c94-ae65233db40f@sandeen.net>
Date: Sat, 1 Apr 2017 13:14:06 -0500
MIME-Version: 1.0
In-Reply-To: <20170401070406.GA6051@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 4/1/17 2:04 AM, Christoph Hellwig wrote:
> On Fri, Mar 31, 2017 at 06:29:34PM -0700, Darrick J. Wong wrote:
>> Fix a couple of memory exposure problems in the getbmap implementation
>> where we copy too much header data from userspace, and a second problem
>> in inumbers where we allocate an array of structures with holes, fail to
>> zero the holes, then blindly copy the kernel memory contents into
>> userspace.
> 
> This should be two different patches.
> 
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1547,10 +1547,10 @@ xfs_ioc_getbmap(
>>  	unsigned int		cmd,
>>  	void			__user *arg)
>>  {
>> -	struct getbmapx		bmx;
>> +	struct getbmapx		bmx = {0};
> 
> missing spaces around the zero.
> 
>>  	int			error;
>>  
>> -	if (copy_from_user(&bmx, arg, sizeof(struct getbmapx)))
>> +	if (copy_from_user(&bmx, arg, sizeof(struct getbmap)))
>>  		return -EFAULT;
> 
> This really needs a comment on how struct getbmap is a strict subset
> of struct getbmapx.  Or even better don't use getbmap at all
> and use offsetoff on struct getbmapx.  

Agreed, was going to make the same observation.

-Eric

>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index e775f78..55642cd 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -584,7 +584,7 @@ xfs_inumbers(
>>  		return error;
>>  
>>  	bcount = MIN(left, (int)(PAGE_SIZE / sizeof(*buffer)));
>> -	buffer = kmem_alloc(bcount * sizeof(*buffer), KM_SLEEP);
>> +	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
> 
> This looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
