Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49206 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753353AbcKGQqB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Nov 2016 11:46:01 -0500
Subject: Re: [PATCH 2/2] xfs: provide helper for counting extents from
 if_bytes
References: <d279d52e-49f6-6fc2-c78b-0054d7ee0a1e@redhat.com>
 <6191b8d6-4a89-0191-728a-18ebdf9254c6@sandeen.net>
 <20161106220258.GM14023@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f7034819-569a-59e1-5e98-8ee9f25d65bc@sandeen.net>
Date: Mon, 7 Nov 2016 10:45:59 -0600
MIME-Version: 1.0
In-Reply-To: <20161106220258.GM14023@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 11/6/16 4:02 PM, Dave Chinner wrote:
> On Fri, Nov 04, 2016 at 09:27:18PM -0500, Eric Sandeen wrote:
>> The open-coded pattern:
>>
>> ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t)
>>
>> is all over the xfs code; provide a new helper
>> xfs_iext_count(ifp) to count the number of inline extents
>> in an inode fork.
> ....
>> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
>> index 5dd56d3..a9e4904 100644
>> --- a/fs/xfs/libxfs/xfs_inode_fork.c
>> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
>> @@ -775,6 +775,16 @@
>>  	}
>>  }
>>  
>> +/* Count number of inline extents based on if_bytes */
>> +xfs_extnum_t
>> +xfs_iext_count(struct xfs_ifork *ifp)
>> +{
>> +	xfs_extnum_t	nextents;
>> +
>> +	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
>> +	return nextents;
>> +}
> 
> Why not just "return ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);"?

No real reason -I started that way and for some reason it seemed more
cryptic and less self-documenting, but can't put my finger on why.  ;)

Happy to send V2 if that's what's preferred.

-Eric

> Otherwise looks good - a needed cleanup.
> 
> Cheers,
> 
> Dave.
> 
