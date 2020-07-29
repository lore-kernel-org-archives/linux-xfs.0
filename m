Return-Path: <SRS0=aQ/b=BI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9E2C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 02:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 331BF2070B
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jul 2020 02:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgG2Cei (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jul 2020 22:34:38 -0400
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:31123 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbgG2Cei (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jul 2020 22:34:38 -0400
X-Greylist: delayed 670 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jul 2020 22:34:37 EDT
Received: from yt-mxauth.gw.nic.fujitsu.com (unknown [192.168.229.68]) by mgwym02.jp.fujitsu.com with smtp
         id 3a0c_3585_bdf6d9c4_114e_4c2a_95f9_ad8cda76aa74;
        Wed, 29 Jul 2020 11:23:22 +0900
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AD5C6AC00CB
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2020 11:23:21 +0900 (JST)
Received: from [10.133.122.138] (VPC-Y08P0560358.g01.fujitsu.local [10.133.122.138])
        by m3051.s.css.fujitsu.com (Postfix) with ESMTP id A19C7320;
        Wed, 29 Jul 2020 11:23:21 +0900 (JST)
Subject: Re: Can we change the S_DAX flag immediately on XFS without dropping
 caches?
To:     Dave Chinner <david@fromorbit.com>,
        "Li, Hao" <lihao2018.fnst@cn.fujitsu.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>
References: <9dc179147f6a47279d801445f3efeecc@G08CNEXMBPEKD04.g08.fujitsu.local>
 <20200728022059.GX2005@dread.disaster.area>
From:   Yasunori Goto <y-goto@fujitsu.com>
Message-ID: <573feb69-bc38-8eb4-ee9b-7c49802eb737@fujitsu.com>
Date:   Wed, 29 Jul 2020 11:23:21 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200728022059.GX2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On 2020/07/28 11:20, Dave Chinner wrote:
> On Tue, Jul 28, 2020 at 02:00:08AM +0000, Li, Hao wrote:
>> Hi,
>>
>> I have noticed that we have to drop caches to make the changing of S_DAX
>> flag take effect after using chattr +x to turn on DAX for a existing
>> regular file. The related function is xfs_diflags_to_iflags, whose
>> second parameter determines whether we should set S_DAX immediately.
> Yup, as documented in Documentation/filesystems/dax.txt. Specifically:
>
>   6. When changing the S_DAX policy via toggling the persistent FS_XFLAG_DAX flag,
>      the change in behaviour for existing regular files may not occur
>      immediately.  If the change must take effect immediately, the administrator
>      needs to:
>
>      a) stop the application so there are no active references to the data set
>         the policy change will affect
>
>      b) evict the data set from kernel caches so it will be re-instantiated when
>         the application is restarted. This can be achieved by:
>
>         i. drop-caches
>         ii. a filesystem unmount and mount cycle
>         iii. a system reboot
>
>> I can't figure out why we do this. Is this because the page caches in
>> address_space->i_pages are hard to deal with?
> Because of unfixable races in the page fault path that prevent
> changing the caching behaviour of the inode while concurrent access
> is possible. The only way to guarantee races can't happen is to
> cycle the inode out of cache.

I understand why the drop_cache operation is necessary. Thanks.

BTW, even normal user becomes to able to change DAX flag for an inode,
drop_cache operation still requires root permission, right?

So, if kernel have a feature for normal user can operate drop cache for 
"a inode" with
its permission, I think it improve the above limitation, and
we would like to try to implement it recently.

Do you have any opinion making such feature?
(Agree/opposition, or any other comment?)

Thanks,

-- 
Yasunori Goto

