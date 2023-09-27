Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7253E80A88
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 05:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjI0FVm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Sep 2023 01:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjI0FUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Sep 2023 01:20:52 -0400
Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D061982
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 22:17:07 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="133629488"
X-IronPort-AV: E=Sophos;i="6.03,179,1694703600"; 
   d="scan'208";a="133629488"
Received: from unknown (HELO yto-r4.gw.nic.fujitsu.com) ([218.44.52.220])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 14:17:05 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
        by yto-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 0F447D3EB7
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 14:17:03 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
        by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 4A106D5EAD
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 14:17:02 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
        by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id DC2D76B82D
        for <linux-xfs@vger.kernel.org>; Wed, 27 Sep 2023 14:17:01 +0900 (JST)
Received: from [192.168.50.5] (unknown [10.167.234.230])
        by edo.cn.fujitsu.com (Postfix) with ESMTP id 22F9A1A0085;
        Wed, 27 Sep 2023 13:17:01 +0800 (CST)
Message-ID: <5c064cbd-13a3-4d55-9881-0a079476d865@fujitsu.com>
Date:   Wed, 27 Sep 2023 13:17:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
To:     Chandan Babu R <chandanbabu@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com
References: <20230915063854.1784918-1-ruansy.fnst@fujitsu.com>
 <86167409-aa7f-4db4-8335-3f290d507f14@fujitsu.com>
 <20230926145519.GE11439@frogsfrogsfrogs>
 <ZROC8hEabAGS7orb@dread.disaster.area>
 <20230927014632.GE11456@frogsfrogsfrogs>
 <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <87fs306zs1.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27900.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27900.005
X-TMASE-Result: 10--10.036600-10.000000
X-TMASE-MatchedRID: Nb7w6L+eG6KPvrMjLFD6eHchRkqzj/bEC/ExpXrHizy5kqGQ38oKZjya
        5RyZT3SuGLyzmhOFRR1UdjhO4CbFI3WyP3H7wTYlxvp0tuDMx3kQhNjZQYyI3N9RlPzeVuQQqxc
        e4As9TzooUuy27qkKYsttSogzyLqm38rWKQkiws4B6/aPodnUlvBR6fCwqWe06Mw4RnkAvRIXpu
        Di0hstRAj+BlhLAG6VZwuwrfN7kZTYMEqhScrQBbU+IyHhkXf1rzl8sNiWClKbKItl61J/ybLn+
        0Vm71Lc+x/oWSsuvysLbigRnpKlKSPzRlrdFGDw1xp+0MzKEoP1610xb46wKzpje+vxwcuNCFAC
        tEkBuySK6n6G+si8Nw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/9/27 11:38, Chandan Babu R 写道:
> On Tue, Sep 26, 2023 at 06:46:32 PM -0700, Darrick J. Wong wrote:
>> On Wed, Sep 27, 2023 at 11:18:42AM +1000, Dave Chinner wrote:
>>> On Tue, Sep 26, 2023 at 07:55:19AM -0700, Darrick J. Wong wrote:
>>>> On Thu, Sep 21, 2023 at 04:33:04PM +0800, Shiyang Ruan wrote:
>>>>> Hi,
>>>>>
>>>>> Any comments?
>>>>
>>>> I notice that xfs/55[0-2] still fail on my fakepmem machine:
>>>>
>>>> --- /tmp/fstests/tests/xfs/550.out	2023-09-23 09:40:47.839521305 -0700
>>>> +++ /var/tmp/fstests/xfs/550.out.bad	2023-09-24 20:00:23.400000000 -0700
>>>> @@ -3,7 +3,6 @@ Format and mount
>>>>   Create the original files
>>>>   Inject memory failure (1 page)
>>>>   Inject poison...
>>>> -Process is killed by signal: 7
>>>>   Inject memory failure (2 pages)
>>>>   Inject poison...
>>>> -Process is killed by signal: 7
>>>> +Memory failure didn't kill the process
>>>>
>>>> (yes, rmap is enabled)
>>>
>>> Yes, I see the same failures, too. I've just been ignoring them
>>> because I thought that all the memory failure code was still not
>>> complete....
>>
>> Oh, I bet we were supposed to have merged this
>>
>> https://lore.kernel.org/linux-xfs/20230828065744.1446462-1-ruansy.fnst@fujitsu.com/
>>
>> to complete the pmem media failure handling code.  Should we (by which I
>> mostly mean Shiyang) ask Chandan to merge these two patches for 6.7?
>>
> 
> I can add this patch into XFS tree for 6.7. But I will need Acks from Andrew
> Morton and Dan Williams.

Thanks!  And this patch[1] fixes these 3 cases (xfs/55[0-2]).  Please 
add this one as well.

[1]: 
https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com

--
Ruan.

> 
