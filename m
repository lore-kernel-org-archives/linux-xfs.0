Return-Path: <SRS0=R26v=BK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A739C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 10:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830A8208E4
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jul 2020 10:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732418AbgGaKKu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jul 2020 06:10:50 -0400
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:36665 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGaKKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Jul 2020 06:10:49 -0400
X-Greylist: delayed 671 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Jul 2020 06:10:49 EDT
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [192.168.231.130]) by mgwkm03.jp.fujitsu.com with smtp
         id 68af_6fec_c6b3968b_1d7e_4a9e_870e_f01626c05344;
        Fri, 31 Jul 2020 18:59:32 +0900
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 469D2AC00A5
        for <linux-xfs@vger.kernel.org>; Fri, 31 Jul 2020 18:59:32 +0900 (JST)
Received: from [10.133.116.206] (VPC-Y08P0560552.g01.fujitsu.local [10.133.116.206])
        by m3051.s.css.fujitsu.com (Postfix) with ESMTP id 32B7A3D2;
        Fri, 31 Jul 2020 18:59:32 +0900 (JST)
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
 <20200729232131.GC2005@dread.disaster.area>
From:   Yasunori Goto <y-goto@fujitsu.com>
Message-ID: <0d380010-cccd-162d-32bc-07d094cb152d@fujitsu.com>
Date:   Fri, 31 Jul 2020 18:59:32 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200729232131.GC2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/07/30 8:21, Dave Chinner wrote:
> On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
>> Hi,
>>
>> On 2020/07/28 11:20, Dave Chinner wrote:
>>> On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
>>>> Hi,
>>>>
>>>> I have noticed that we have to drop caches to make the changing of S_DAX
>>>> flag take effect after using chattr +x to turn on DAX for a existing
>>>> regular file. The related function is xfs_diflags_to_iflags, whose
>>>> second parameter determines whether we should set S_DAX immediately.
>>> Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
>>>
>>>    6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
>>>       the change in behaviour for existing regular files may not occur
>>>       immediately.  If the change must take effect immediately, the administrator
>>>       needs to:
>>>
>>>       a) stop the application so there are no active references to the data set
>>>          the policy change will affect
>>>
>>>       b) evict the data set from kernel caches so it will be re-instantiated when
>>>          the application is restarted. This can be achieved by:
>>>
>>>          i. drop-caches
>>>          ii. a filesystem unmount and mount cycle
>>>          iii. a system reboot
>>>
>>>> I can't figure out why we do this. Is this because the page caches in
>>>> address_space->i_pages are hard to deal with?
>>> Because of unfixable races in the page fault path that prevent
>>> changing the caching behaviour of the inode while concurrent access
>>> is possible. The only way to guarantee races can't happen is to
>>> cycle the inode out of cache.
>> I understand why the drop_cache operation is necessary. Thanks.
>>
>> BTW, even normal user becomes to able to change DAX flag for an inode,
>> drop_cache operation still requires root permission, right?
> Step back for a minute and explain why you want to be able to change
> the DAX mode of a file -as a user-.


For example, there are 2 containers executed in a system, which is named as
container A and container B, and these host gives FS-DAX files to each 
containers.
If the user of container A would like to change DAX-off for tuning, then 
he will stop his application
and change DAX flag, but the flag may not be changed.

Then he will "need" to ask host operator to execute drop_cache, and the 
operator did it.
As a result, not only container A, but also container B get the impact 
of drop_cache.

Especially, if this is multi tenant container system, then I think this 
is not acceptable.

Probably, there are 2 problems I think.
1) drop_cache requires root permission.
2) drop_cache has too wide effect.

>
>> So, if kernel have a feature for normal user can operate drop cache for "a
>> inode" with
>> its permission, I think it improve the above limitation, and
>> we would like to try to implement it recently.
> No, drop_caches is not going to be made available to users. That
> makes it s trivial system wide DoS vector.

The current drop_cache feature tries to drop ALL of cache (page cache 
and/or slab cache).
Then, I agree that normal user should not drop all of them.

But my intention was that drop cache of ONE file which is changed dax flag,
(and if possible, drop only the inode cache.)
Do you mean it will be still cause of weakness against DoS attack?
If so, I should give up to solve problem 1) at least.


Thanks,

>
> Cheers,
>
> Dave.

-- 
Yasunori Goto

