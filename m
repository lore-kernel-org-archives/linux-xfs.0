Return-Path: <SRS0=76Cg=BP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEEBC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 08:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59D82177B
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Aug 2020 08:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgHEILU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Aug 2020 04:11:20 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12572 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727873AbgHEIKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Aug 2020 04:10:43 -0400
X-IronPort-AV: E=Sophos;i="5.75,436,1589212800"; 
   d="scan'208";a="97639989"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 05 Aug 2020 16:10:10 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 5AB0B4CE34DE;
        Wed,  5 Aug 2020 16:10:06 +0800 (CST)
Received: from [10.167.225.206] (10.167.225.206) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 5 Aug 2020 16:10:06 +0800
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
From:   "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>
To:     Ira Weiny <ira.weiny@intel.com>
CC:     Dave Chinner <david@fromorbit.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        <yangx.jy@cn.fujitsu.com>, <ruansy.fnst@cn.fujitsu.com>,
        <gujx@cn.fujitsu.com>, Yasunori Goto <y-goto@fujitsu.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
 <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
 <20200729161040.GA1250504@iweiny-DESK2.sc.intel.com>
 <5717e1e5-79fb-af3c-0859-eea3cd8d9626@cn.fujitsu.com>
Message-ID: <ed4b2df4-086f-a384-3695-4ea721a70326@cn.fujitsu.com>
Date:   Wed, 5 Aug 2020 16:10:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <5717e1e5-79fb-af3c-0859-eea3cd8d9626@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.167.225.206]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201)
X-yoursite-MailScanner-ID: 5AB0B4CE34DE.ACE7A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lihao2018.fnst@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

Ping.

Thanks,
Hao Li


On 2020/7/31 17:12, Li, Hao wrote:
> On 2020/7/30 0:10, Ira Weiny wrote:
>
>> On Wed, Jul 29, 2020 at 11:23:21AM +0900, Yasunori Goto wrote:
>>> Hi,
>>>
>>> On 2020/07/28 11:20, Dave Chinner wrote:
>>>> On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
>>>>> Hi,
>>>>>
>>>>> I have noticed that we have to drop caches to make the changing of S_DAX
>>>>> flag take effect after using chattr +x to turn on DAX for a existing
>>>>> regular file. The related function is xfs_diflags_to_iflags, whose
>>>>> second parameter determines whether we should set S_DAX immediately.
>>>> Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
>>>>
>>>>   6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
>>>>      the change in behaviour for existing regular files may not occur
>>>>      immediately.  If the change must take effect immediately, the administrator
>>>>      needs to:
>>>>
>>>>      a) stop the application so there are no active references to the data set
>>>>         the policy change will affect
>>>>
>>>>      b) evict the data set from kernel caches so it will be re-instantiated when
>>>>         the application is restarted. This can be achieved by:
>>>>
>>>>         i. drop-caches
>>>>         ii. a filesystem unmount and mount cycle
>>>>         iii. a system reboot
>>>>
>>>>> I can't figure out why we do this. Is this because the page caches in
>>>>> address_space->i_pages are hard to deal with?
>>>> Because of unfixable races in the page fault path that prevent
>>>> changing the caching behaviour of the inode while concurrent access
>>>> is possible. The only way to guarantee races can't happen is to
>>>> cycle the inode out of cache.
>>> I understand why the drop_cache operation is necessary. Thanks.
>>>
>>> BTW, even normal user becomes to able to change DAX flag for an inode,
>>> drop_cache operation still requires root permission, right?
>>>
>>> So, if kernel have a feature for normal user can operate drop cache for "a
>>> inode" with
>>> its permission, I think it improve the above limitation, and
>>> we would like to try to implement it recently.
>>>
>>> Do you have any opinion making such feature?
>>> (Agree/opposition, or any other comment?)
>> I would not be opposed but there were many hurdles to that implementation.
>>
>> What is the use case you are thinking of here?
>>
>> The compromise of dropping caches was reached because we envisioned that many
>> users would simply want to chose the file mode when a file was created and
>> maintain that mode through the lifetime of the file.  To that end one can
>> simply create directories which have the desired dax mode and any files created
>> in that directory will inherit the dax mode immediately.  
> Inheriting mechanism for DAX mode is reasonable but chattr&drop_caches
> makes things complicated.
>> So there is no need
>> to switch the file mode directly as a normal user.
> The question is, the normal users can indeed use chattr to change the DAX
> mode for a regular file as long as they want. However, when they do this,
> they have no way to make the change take effect. I think this behavior is
> weird. We can say chattr executes successfully because XFS_DIFLAG2_DAX has
> been set onto xfs_inode->i_d.di_flags2, but we can also say chattr doesn't
> finish things completely because S_DAX is not set onto inode->i_flags.
> The user may be confused about why chattr +/-x doesn't work at all. Maybe
> we should find a way for the normal user to make chattr take effects
> without calling the administrator, or we can make the chattr +/x command
> request root permission now that if the user has root permission, he can
> make DAX changing take effect through echo 2 > /proc/sys/vm/drop_caches.
>
>
> Regards,
>
> Hao Li
>
>> Would that work for your use case?
>>
>> Ira


