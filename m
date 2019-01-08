Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45086 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbfAHOLs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jan 2019 09:11:48 -0500
Subject: Re: [PATCH] xfs: correct statx's result_mask value
References: <1546854790-5233-1-git-send-email-suyj.fnst@cn.fujitsu.com>
 <20190107175229.GJ12689@magnolia>
 <2b27e2ec-368b-d24c-8443-e265f87e417c@sandeen.net>
 <67e03af1-6e11-4236-76e6-6127b6cfb9b9@cn.fujitsu.com>
 <20190108050739.GQ12689@magnolia>
 <5c103aa0-8711-ceb3-38f8-dffe983526ff@cn.fujitsu.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3af22df1-dc37-5e51-36be-aad3fe8a8fbb@sandeen.net>
Date: Tue, 8 Jan 2019 08:11:46 -0600
MIME-Version: 1.0
In-Reply-To: <5c103aa0-8711-ceb3-38f8-dffe983526ff@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Su Yanjun <suyj.fnst@cn.fujitsu.com>" <suyj.fnst@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, suyanjun218@gmail.com



On 1/7/19 11:15 PM, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
> 
> 
> On 1/8/2019 1:07 PM, Darrick J. Wong wrote:
>> On Tue, Jan 08, 2019 at 12:58:43PM +0800, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
>>>
>>> On 1/8/2019 2:04 AM, Eric Sandeen wrote:
>>>> On 1/7/19 11:52 AM, Darrick J. Wong wrote:
>>>>> On Mon, Jan 07, 2019 at 04:53:10AM -0500, Su Yanjun wrote:
>>>>>> For statx syscall, xfs return the wrong result_mask.
>>>>>>
>>>>>> Signed-off-by: Su Yanjun<suyj.fnst@cn.fujitsu.com>
>>>>>> ---
>>>>>>    fs/xfs/xfs_iops.c | 3 +++
>>>>>>    1 file changed, 3 insertions(+)
>>>>>>
>>>>>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>>>>>> index f48ffd7..3811457 100644
>>>>>> --- a/fs/xfs/xfs_iops.c
>>>>>> +++ b/fs/xfs/xfs_iops.c
>>>>>> @@ -521,6 +521,9 @@ xfs_vn_getattr(
>>>>>>                stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
>>>>>>            }
>>>>>>        }
>>>>>> +   
>>>>>> +    /* Only return mask that we care */
>>>>>> +    stat->result_mask &= request_mask;
>>>>> Why not just:
>>>>>
>>>>>     stat->result_mask = STATX_BASIC_STATS;
>>>>>
>>>>> at the top of the function?
>>>>>
>>>>> I don't see the need to mask off result_mask at all, since we could some
>>>>> day elect to return more than what's in request_mask...
>>> When we run xfstests with nfs, the generic/423 case runs failed. So i review
>>> the nfs'
>>> nfs_getattr code it does validate the request_mask.
>>>
>>> Then i review the xfs' getattr code, it has no such check. Whatever
>>> request_mask
>>>   is set, the stat's result_mask always the 0x7ff.
>> Yes, statx can return more data than what userspace callers ask for:
>>
>>> Maybe it has Unclear semantics about statx's result_mask.
>> "A filesystem may also fill in fields that the caller didn't ask for if
>> it has values for them available and the information is available at no
>> extra cost.  If this happens, the  corresponding  bits will be set in
>> stx_mask."
>>
>> --D
> 
> I get it, then the testcase generic/423 may need update in xfstests.
> Thanks for your reply.

Can you please share the details of the failure you're seeing when you run
it over nfs?

Thanks,
-=Eric
