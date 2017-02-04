Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:5145 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdBDBid (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 20:38:33 -0500
Subject: Re: [PATCH] xfs: reset b_first_retry_time when clear the retry status
 of xfs_buf_t
References: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
 <20170203231700.GC3580@birch.djwong.org>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <4adb3df4-c316-6989-de1d-087fb4eb5b27@huawei.com>
Date: Sat, 4 Feb 2017 09:38:06 +0800
MIME-Version: 1.0
In-Reply-To: <20170203231700.GC3580@birch.djwong.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, cmaiolino@redhat.com, sandeen@redhat.com



On 2017/2/4 7:17, Darrick J. Wong wrote:
> On Fri, Feb 03, 2017 at 05:08:25PM +0800, Hou Tao wrote:
>> After successful IO or permanent error, b_first_retry_time also
>> needs to be cleared, else the invalid first retry time will be
>> used by the next retry check.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  fs/xfs/xfs_buf_item.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
>> index 2975cb2..0306168 100644
>> --- a/fs/xfs/xfs_buf_item.c
>> +++ b/fs/xfs/xfs_buf_item.c
>> @@ -1162,6 +1162,7 @@ xfs_buf_iodone_callbacks(
>>  	 */
>>  	bp->b_last_error = 0;
>>  	bp->b_retries = 0;
>> +	bp->b_first_retry_time = 0;
> 
> By the way, is there a testcase for this?  It looks like it shouldn't be
> hard to generate a test that sets a timeout and interleaves temporary
> failure and success.
> 
> --D

Not yet. There has been a test case (tests/xfs/264) for XFS error handler in xfstests,
and maybe I could add some interleaved failure-success test cases for both max_retries
and retry_timeout_seconds.

Regards,

Tao

