Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfBSB1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 20:27:03 -0500
Subject: Re: [RFC PATCH v2 0/9] Block/XFS: Support alternative mirror device
 retry
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <c2b6ec5c-ad8a-6f69-c8b9-8e264cc6aa0d@oracle.com>
From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Message-ID: <5053beac-658e-d6a7-bcf8-050e0590f18d@oracle.com>
Date: Tue, 19 Feb 2019 09:29:16 +0800
MIME-Version: 1.0
In-Reply-To: <c2b6ec5c-ad8a-6f69-c8b9-8e264cc6aa0d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca



On 2/18/19 4:08 PM, jianchao.wang wrote:
> Hi Bob
> 
> On 2/13/19 5:50 PM, Bob Liu wrote:
>> Motivation:
>> When fs data/metadata checksum mismatch, lower block devices may have other
>> correct copies. e.g. If XFS successfully reads a metadata buffer off a raid1 but
>> decides that the metadata is garbage, today it will shut down the entire
>> filesystem without trying any of the other mirrors.  This is a severe
>> loss of service, and we propose these patches to have XFS try harder to
>> avoid failure.
>>
>> This patch prototype this mirror retry idea by:
>> * Adding @nr_mirrors to struct request_queue which is similar as
>>   blk_queue_nonrot(), filesystem can grab device request queue and check max
>>   mirrors this block device has.
>>   Helper functions were also added to get/set the nr_mirrors.
>>
>> * Introducing bi_rd_hint just like bi_write_hint, but bi_rd_hint is a long bitmap
>> in order to support stacked layer case.
> 
> Why does we need a bitmap to know which underlying device has been tried ?
> For example, the following scenario,
> 
>                     md8
>                    / | \
>                sda sdb sdc
> 
> If the the raid read the data from sda and fs check and find the data is corrupted.
> Then we may just need to let raid1 know that the data is from sda. Then based on this
> hint, raid1 could handle it with handle_read_error to try other replica and fix the
> error.

This doesn't work.
The md raid1 can only see IO success or failure, so fix_read_error won't fix this.
Sorry for the noise.

Thanks
Jianchao

> 
> If this is feasible, we just need to modify the bio as following and needn't add any
> bytes in it.
> 
> struct bio {
>     ...
>     union {
>         unsigned short bi_write_hint;
>         unsigned short bi_read_hint;
>     }
>     ...
> }
> 
> Thanks
> Jianchao
>>
>> * Modify md/raid1 to support this retry feature.
>>
>> * Adapter xfs to use this feature.
>>   If the read verify fails, we loop over the available mirrors and retry the read.
>>
>> * Rewrite retried read
>>   When the read verification fails, but the retry succeedes
>>   write the buffer back to correct the bad mirror
>>
>> * Add tracepoints and logging to alternate device retry.
>>   This patch adds new log entries and trace points to the alternate device retry
>>   error path.
>>
>> Changes v2:
>> - No more reuse bi_write_hint
>> - Stacked layer support(see patch 4/9)
>> - Other feedback fix
>>
>> Allison Henderson (5):
>>   Add b_alt_retry to xfs_buf
>>   xfs: Add b_rd_hint to xfs_buf
>>   xfs: Add device retry
>>   xfs: Rewrite retried read
>>   xfs: Add tracepoints and logging to alternate device retry
>>
>> Bob Liu (4):
>>   block: add nr_mirrors to request_queue
>>   block: add rd_hint to bio and request
>>   md:raid1: set mirrors correctly
>>   md:raid1: rd_hint support and consider stacked layer case
>>
>>  Documentation/block/biodoc.txt |   3 +
>>  block/bio.c                    |   1 +
>>  block/blk-core.c               |   4 ++
>>  block/blk-merge.c              |   6 ++
>>  block/blk-settings.c           |  24 +++++++
>>  block/bounce.c                 |   1 +
>>  drivers/md/raid1.c             | 123 ++++++++++++++++++++++++++++++++-
>>  fs/xfs/xfs_buf.c               |  58 +++++++++++++++-
>>  fs/xfs/xfs_buf.h               |  14 ++++
>>  fs/xfs/xfs_trace.h             |   6 +-
>>  include/linux/blk_types.h      |   1 +
>>  include/linux/blkdev.h         |   4 ++
>>  include/linux/types.h          |   3 +
>>  13 files changed, 244 insertions(+), 4 deletions(-)
>>
> 
