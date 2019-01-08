Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32333 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727290AbfAHE6t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 23:58:49 -0500
From: "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] xfs: correct statx's result_mask value
References: <1546854790-5233-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190107175229.GJ12689@magnolia>
 <2b27e2ec-368b-d24c-8443-e265f87e417c@sandeen.net>
Message-ID: <67e03af1-6e11-4236-76e6-6127b6cfb9b9@cn.fujitsu.com>
Date: Tue, 8 Jan 2019 12:58:43 +0800
MIME-Version: 1.0
In-Reply-To: <2b27e2ec-368b-d24c-8443-e265f87e417c@sandeen.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, suyanjun218@gmail.com



On 1/8/2019 2:04 AM, Eric Sandeen wrote:
> On 1/7/19 11:52 AM, Darrick J. Wong wrote:
>> On Mon, Jan 07, 2019 at 04:53:10AM -0500, Su Yanjun wrote:
>>> For statx syscall, xfs return the wrong result_mask.
>>>
>>> Signed-off-by: Su Yanjun<suyj.fnst@cn.fujitsu.com>
>>> ---
>>>   fs/xfs/xfs_iops.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>> index f48ffd7..3811457 100644
>>> --- a/fs/xfs/xfs_iops.c
>>> +++ b/fs/xfs/xfs_iops.c
>>> @@ -521,6 +521,9 @@ xfs_vn_getattr(
>>>   			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
>>>   		}
>>>   	}
>>> +	
>>> +	/* Only return mask that we care */
>>> +	stat->result_mask &= request_mask;
>> Why not just:
>>
>> 	stat->result_mask = STATX_BASIC_STATS;
>>
>> at the top of the function?
>>
>> I don't see the need to mask off result_mask at all, since we could some
>> day elect to return more than what's in request_mask...
When we run xfstests with nfs, the generic/423 case runs failed. So i 
review the nfs'
nfs_getattr code it does validate the request_mask.

Then i review the xfs' getattr code, it has no such check. Whatever 
request_mask
  is set, the stat's result_mask always the 0x7ff.

Maybe it has Unclear semantics about statx's result_mask.
>> ...waitaminute, are you seeing garbage in the result_mask that's
>> returned to userspace?  I also noticed the vfs stat functions declare
>> "struct kstat stat;" without explicitly zeroing the structure fields,
>> which means (I think) that we can leak stack information if the kernel
>> isn't built with the stackleak plugin?
No such problem.
> A clear problem statement and reproducer steps would be hugely useful
> here.
>
> -Eric
Thanks,
Su
