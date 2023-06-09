Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE56EC7EE25
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Jun 2023 03:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjFIDWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jun 2023 23:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFIDWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 23:22:43 -0400
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252F430E6
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 20:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1686280960; i=@fujitsu.com;
        bh=E+f615vRtZgTQSiZQz++j3GwE5OerT/Nw8UHfLYyxrw=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=ngRrf5RmrSkSSN7XEQrvaIkz3pbw3EdQ3fB83sjKwdx8TTjJ5poKYyK2UaP2Zr3Wg
         aOh8X4NHAQasXT+V9yntjyokLQ5loHP0bfHezmnpFhIkOhpotAiAH+619cJSI9NJ0W
         lYEuyHBPnkkwjWyJLImtTVdG0UcrojGKCDyiT61PkBfe+l3fbjncw0S+6bcYJ87Cng
         oZ+7fTd3faauxSQMaEe+zIn3cMeWeBgyhXiXexOSSmop3l9ZFitCpr1GkituVcWPfb
         9uBT9uyOmr2dQjf9zjNBEeAFjQK90cn+fJisXkwyXjh6gd33aa8eu79mR/27bsPtVc
         yH7i71hsvxpxw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRWlGSWpSXmKPExsViZ8ORpPt/VlO
  Kwbm5ehb7Lk1ltLj8hM9i158d7A7MHptWdbJ5fN4kF8AUxZqZl5RfkcCasX3fO8aCj/IVu9c9
  Ym5gXCbZxcjFISSwkVFi/46jrF2MnEDOUiaJ5gPKEIltjBJ/d7SCJXgF7CQOzvjDAmKzCKhI9
  F/4wQ4RF5Q4OfMJWFxUIEVixsbFzCC2sICrxMcpd8F6RQQ0JY58u8YEYjMLGEp0tE1kglhwjV
  Hi4a35YAk2AR2JCwv+gjVwCphL9F76xwzRYCGx+M1BdghbXqJ562ywuISAksTFr3dYIewqiYv
  vZ7JB2GoSV89tYp7AKDQLyX2zkIyahWTUAkbmVYymxalFZalFuqZ6SUWZ6RkluYmZOXqJVbqJ
  eqmluuWpxSW6RnqJ5cV6qcXFesWVuck5KXp5qSWbGIFxkFKsaLSD8cnOv3qHGCU5mJREeUsvN
  KYI8SXlp1RmJBZnxBeV5qQWH2KU4eBQkuCNmtmUIiRYlJqeWpGWmQOMSZi0BAePkgjv9clAad
  7igsTc4sx0iNQpRmOO9ob9e5k51jYc2MssxJKXn5cqJc67bwZQqQBIaUZpHtwgWKq4xCgrJcz
  LyMDAIMRTkFqUm1mCKv+KUZyDUUmYV7UVaApPZl4J3L5XQKcwAZ1yOKke5JSSRISUVAOTP9P+
  J/f/xU3zmr8249uH1b853c+oZrWUOuxvnB4jPY/PUHnJ6can/ZuPLqrvlcjlTsnrNTEwKJlzM
  yZ7YrbB5B+NCVov0iNPLlj7rmzly/WyzvOLN73tmBj64lH5z6722yFvcvcuEDhiu3beWZuz66
  uFr6nevmtbOfP6paUZBbpcRVYMLydHfVd4kTR36arMp3/4nJs0V3+Zc6fj+5+0ibs9+dmLe+P
  epTV4Lp07vaP/zOEzbEvVvzGbXDTdVl1/b+kHIe5gF6XV+tfW2F/MX6ql+Fn5xulbZ6vaW+xb
  vlh/rPE3LL9y99DradyJqw/Xr/KU7px8a/f8JQGfV6mE5u9cUJwZX/Rzy5/qqJ/r9JRYijMSD
  bWYi4oTAXD2sQ6QAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-5.tower-565.messagelabs.com!1686280959!86345!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.105.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 4797 invoked from network); 9 Jun 2023 03:22:39 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-5.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 9 Jun 2023 03:22:39 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 7355F1B4;
        Fri,  9 Jun 2023 04:22:39 +0100 (BST)
Received: from R01UKEXCASM223.r01.fujitsu.local (R01UKEXCASM223 [10.182.185.121])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 66F411AE;
        Fri,  9 Jun 2023 04:22:39 +0100 (BST)
Received: from [192.168.50.5] (10.167.234.230) by
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121) with Microsoft SMTP Server
 (TLS) id 15.0.1497.42; Fri, 9 Jun 2023 04:22:37 +0100
Message-ID: <e7c43625-73a5-9de5-f3a0-b8e1d67a46f8@fujitsu.com>
Date:   Fri, 9 Jun 2023 11:22:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHSET v25.0 0/7] xfs_scrub: fixes to the repair code
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <cem@kernel.org>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
 <4af2621e-bd59-f1be-8e07-7800a68c59fa@fujitsu.com>
 <20230608145601.GW1325469@frogsfrogsfrogs>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20230608145601.GW1325469@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.234.230]
X-ClientProxiedBy: G08CNEXHBPEKD10.g08.fujitsu.local (10.167.33.114) To
 R01UKEXCASM223.r01.fujitsu.local (10.182.185.121)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2023/6/8 22:56, Darrick J. Wong 写道:
> On Thu, Jun 08, 2023 at 09:22:02PM +0800, Shiyang Ruan wrote:
>> Hi Darrick,
>>
>> I'm running test on this patchset (patched kernel and xfsprogs, latest
>> xfstests:v2023.05.28).  Now I found xfs/730 failed with message "online
>> scrub didn't fail".  The detail is:
>>
>> FSTYP         -- xfs (debug)
>> PLATFORM      -- Linux/x86_64 f36 6.4.0-rc3-pmem+ #309 SMP PREEMPT_DYNAMIC
>> Wed Jun  7 15:44:15 CST 2023
>> MKFS_OPTIONS  -- -f /dev/pmem1
>> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/pmem1
>> /mnt/scratch
>>
>> xfs/730       - output mismatch (see
>> /root/xts/results//default/xfs/730.out.bad)
>> mv: failed to preserve ownership for
>> '/root/xts/results//default/xfs/730.out.bad': Operation not permitted
>>      --- tests/xfs/730.out	2023-03-16 09:42:15.256141472 +0800
>>      +++ /root/xts/results//default/xfs/730.out.bad	2023-06-08
> 
> Whoah, someone besides me actually runs the repair fuzzers??
> 
> Yay!
> 
>> 20:43:27.436083265 +0800
>>      @@ -1,4 +1,14 @@
>>       QA output created by 730
>>       Format and populate
>>       Fuzz fscounters
>>      +icount = zeroes: online scrub didn't fail.
>>      +icount = ones: online scrub didn't fail.
>>      +icount = firstbit: online scrub didn't fail.
>>      +icount = middlebit: online scrub didn't fail.
>>      ...
>>      (Run 'diff -u /root/xts/tests/xfs/730.out
>> /root/xts/results//default/xfs/730.out.bad'  to see the entire diff)
>>
>>
>> This test case is to fuzz metadata and make sure xfs_scrub can repair the
>> fs. After a little investigation, I think the fuzz actually done to the
>> metadata area but the xfs_scrub seems didn't notice that.  I haven't found
>> the root cause of the problem yet.  Do you have the same message which
>> causes fail on this case?
> 
> Yeah, we recently disabled some code in fscounters.c to fix some other
> correctness problems in the inodegc code.

Do you mean this failure is what you expected?

> My goal was to get this
> series:
> 
> https://lore.kernel.org/linux-xfs/168506061483.3732954.5178462816967376906.stgit@frogsfrogsfrogs/
> 
> merged for 6.5 and then the whole thing would work *completely*
> correctly, but it might be too late now.

But actually I'm running test on your repair-fscounters branch[1], which 
seems to be the same thing as the patchsets you just show to me.  And 
the failure of xfs/730 happened.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-fscounters


--
Thanks,
Ruan.

> 
> --D
> 
>>
>> --
>> Thanks,
>> Ruan.
>>
>> 在 2023/5/26 8:38, Darrick J. Wong 写道:
>>> Hi all,
>>>
>>> Now that we've landed the new kernel code, it's time to reorganize the
>>> xfs_scrub code that handles repairs.  Clean up various naming warts and
>>> misleading error messages.  Move the repair code to scrub/repair.c as
>>> the first step.  Then, fix various issues in the repair code before we
>>> start reorganizing things.
>>>
>>> If you're going to start using this mess, you probably ought to just
>>> pull from my git trees, which are linked below.
>>>
>>> This is an extraordinary way to destroy everything.  Enjoy!
>>> Comments and questions are, as always, welcome.
>>>
>>> --D
>>>
>>> xfsprogs git tree:
>>> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-repair-fixes
>>> ---
>>>    scrub/phase1.c        |    2
>>>    scrub/phase2.c        |    3 -
>>>    scrub/phase3.c        |    2
>>>    scrub/phase4.c        |   22 ++++-
>>>    scrub/phase5.c        |    2
>>>    scrub/phase6.c        |   13 +++
>>>    scrub/phase7.c        |    2
>>>    scrub/repair.c        |  177 ++++++++++++++++++++++++++++++++++++++++++-
>>>    scrub/repair.h        |   16 +++-
>>>    scrub/scrub.c         |  204 +------------------------------------------------
>>>    scrub/scrub.h         |   16 ----
>>>    scrub/scrub_private.h |   55 +++++++++++++
>>>    scrub/xfs_scrub.c     |    2
>>>    13 files changed, 283 insertions(+), 233 deletions(-)
>>>    create mode 100644 scrub/scrub_private.h
>>>
