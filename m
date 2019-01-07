Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50946 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfAGSE1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jan 2019 13:04:27 -0500
Subject: Re: [PATCH] xfs: correct statx's result_mask value
References: <1546854790-5233-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190107175229.GJ12689@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2b27e2ec-368b-d24c-8443-e265f87e417c@sandeen.net>
Date: Mon, 7 Jan 2019 12:04:24 -0600
MIME-Version: 1.0
In-Reply-To: <20190107175229.GJ12689@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, suyanjun218@gmail.com



On 1/7/19 11:52 AM, Darrick J. Wong wrote:
> On Mon, Jan 07, 2019 at 04:53:10AM -0500, Su Yanjun wrote:
>> For statx syscall, xfs return the wrong result_mask.
>>
>> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
>> ---
>>  fs/xfs/xfs_iops.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index f48ffd7..3811457 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -521,6 +521,9 @@ xfs_vn_getattr(
>>  			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
>>  		}
>>  	}
>> +	
>> +	/* Only return mask that we care */
>> +	stat->result_mask &= request_mask;
> 
> Why not just:
> 
> 	stat->result_mask = STATX_BASIC_STATS;
> 
> at the top of the function?
> 
> I don't see the need to mask off result_mask at all, since we could some
> day elect to return more than what's in request_mask...
> 
> ...waitaminute, are you seeing garbage in the result_mask that's
> returned to userspace?  I also noticed the vfs stat functions declare
> "struct kstat stat;" without explicitly zeroing the structure fields,
> which means (I think) that we can leak stack information if the kernel
> isn't built with the stackleak plugin?

A clear problem statement and reproducer steps would be hugely useful
here.

-Eric
