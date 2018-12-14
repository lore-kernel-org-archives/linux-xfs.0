Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39970 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729699AbeLNOKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 09:10:20 -0500
Subject: Re: [PATCH 3/3] iomap: optimize iomap_is_partially_uptodate for full
 page range
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-4-git-send-email-sandeen@sandeen.net>
 <20181214030528.GK6311@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <568c811c-bfd5-216e-30a0-c54ebc2989a0@sandeen.net>
Date: Fri, 14 Dec 2018 08:10:19 -0600
MIME-Version: 1.0
In-Reply-To: <20181214030528.GK6311@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de

On 12/13/18 9:05 PM, Dave Chinner wrote:
> On Thu, Dec 13, 2018 at 04:25:29PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> We only call ->is_partially_uptodate to look for an uptodate range
>> within a not-uptodate page.
>>
>> If the range covers all blocks in the page, there is no point to checking
>> each block individually - if the whole range (i.e. the whole page) were
>> uptodate, the page would be uptodate as well.  Hence in this case, we
>> can return early and skip the loop.
>>
>> This is similar to what is done in block_is_partially_uptodate().
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>  fs/iomap.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/fs/iomap.c b/fs/iomap.c
>> index ce837d9..7d7d985 100644
>> --- a/fs/iomap.c
>> +++ b/fs/iomap.c
>> @@ -515,6 +515,10 @@ struct iomap_readpage_ctx {
>>  	first = from >> inode->i_blkbits;
>>  	last = (from + len - 1) >> inode->i_blkbits;
>>  
>> +	/* If page wasn't uptodate and range covers all blocks: no partial */
>> +	if (first == 0 && last == (PAGE_SIZE - 1) >> inode->i_blkbits)
>> +		return 0;
>> +
> 
> Even if the range covers the entire page, we still have to check
> that all the individual blocks in the page are up to date or not.
> Hence I think this is wrong....

Didn't PageUptodate(page) answer that question already in the caller?

The caller does:

                        if (PageUptodate(page))
                                goto page_ok;
...
                        if (!mapping->a_ops->is_partially_uptodate(page,
                                                        offset, iter->count))
                                goto page_not_up_to_date_locked;


So if it was found to be uptodate, we never called this op.  If we /were/
called (page was not uptodate) that can only be because at least one block in
the page is not uptodate.  So what's the need for checking them all again?

(unless it's because we're now doing it under the page lock?)

block_is_partially_uptodate does the same thing:

        if (from < blocksize && to > PAGE_SIZE - blocksize)
                return 0;

Still, this also seems like maybe something the caller should do instead.

-Eric
