Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54784 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754239AbeGIB6e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 21:58:34 -0400
Subject: Re: [PATCH RFC 2/8] xfs: introduce extents to local conversion helper
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-3-git-send-email-shan.hai@oracle.com>
 <20180708154226.GA8625@infradead.org>
From: Shan Hai <shan.hai@oracle.com>
Message-ID: <734657eb-621e-7e3d-4f19-96c2e1a64625@oracle.com>
Date: Mon, 9 Jul 2018 09:58:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180708154226.GA8625@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org



On 2018年07月08日 23:42, Christoph Hellwig wrote:
>>   /*
>> + * Convert an inode from extents to the local format.
>> + * Free all the extents of the inode and reset it to the local
>> + * format. Copy the contents of the inode's blocks to the inode's
>> + * literal area.
>> + */
> Please use up all 80 chars for your comments (and code)
>
>> +int
>> +xfs_bmap_extents_to_local(
>> +	xfs_trans_t		*tp,
>> +	xfs_inode_t		*ip,
> Please use the struct types instead of the typedefs wherever possible.
>
>> +	if (xfs_iext_count(ifp) == 0)
>> +		goto init_local_fork;
>> +
>> +	for_each_xfs_iext(ifp, &icur, &got) {
> for_each_xfs_iext should do the right thing for an empty fork.
>
>> +out:
>> +	return error;
> Just return errors directly instead of going to a label that returns
> the error.
>
>> +}
>> +
>> +
>> +/*
> One blank line after a function body is enough.
>

OK, I will fix all of the above, thanks for the review.

Thanks
Shan Hai
