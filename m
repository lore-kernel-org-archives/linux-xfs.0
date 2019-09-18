Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E69FC4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 03:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E825A218AF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 03:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbfIRDY4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Sep 2019 23:24:56 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59021 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726538AbfIRDY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Sep 2019 23:24:56 -0400
X-IronPort-AV: E=Sophos;i="5.64,519,1559491200"; 
   d="scan'208";a="75627860"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 18 Sep 2019 11:24:53 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 4DAF94CE14E7;
        Wed, 18 Sep 2019 11:24:49 +0800 (CST)
Received: from [10.167.220.84] (10.167.220.84) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Wed, 18 Sep 2019 11:24:57 +0800
Subject: Re: question of xfs/148 and xfs/149
To:     Zorro Lang <zlang@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <4BF2FD5A942B1C4B828DDAF5635768C1041AB0E2@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20190917163933.GC736475@magnolia>
 <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Message-ID: <7b5d5797-afff-90bc-0131-38fd13eced34@cn.fujitsu.com>
Date:   Wed, 18 Sep 2019 11:24:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190918025915.GK7239@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.84]
X-yoursite-MailScanner-ID: 4DAF94CE14E7.A14DF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



on 2019/09/18 10:59, Zorro Lang wrote:
> xfs/030 is weird, I've found it long time ago.
> 
> If I do a 'whole disk mkfs' (_scratch_mkfs_xfs), before this sized mkfs:
> 
>    _scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
> 
> Everything looks clear, and test pass. I can't send a patch to do this,
> because I don't know the reason.
Yes. I also found running _scratch_mkfs_xfs in xfs/030 can slove this 
problem yesterday. Or, we can adjust _try_wipe_scratch_devs order in 
check(But I dont't have enough reason to explain why adjust it). as below:
--- a/check
+++ b/check
@@ -753,7 +753,6 @@ for section in $HOST_OPTIONS_SECTIONS; do
                         # _check_dmesg depends on this log in dmesg
                         touch ${RESULT_DIR}/check_dmesg
                 fi
-               _try_wipe_scratch_devs > /dev/null 2>&1
                 if [ "$DUMP_OUTPUT" = true ]; then
                         _run_seq 2>&1 | tee $tmp.out
                         # Because $? would get tee's return code
@@ -799,7 +798,7 @@ for section in $HOST_OPTIONS_SECTIONS; do
                 # Scan for memory leaks after every test so that 
associating
                 # a leak to a particular test will be as accurate as 
possible.
                 _check_kmemleak || err=true
-
+               _try_wipe_scratch_devs > /dev/null 2>&1
                 # test ends after all checks are done.
                 $timestamp && _timestamp
                 stop=`_wallclock`

> 
> I'm not familiar with xfs_repair so much, so I don't know what happens
> underlying. I suppose the the part after the $DSIZE affect the xfs_repair,
> but I don't know why the wipefs can cause that, wipefs only erase 4 bytes
> at the beginning.
> 
  I am finding the reasion. It seems wipefs wipes important information 
and $DSIZE option(using single agcount or dsize, it also fails ) can not 
format disk completely. If we use other options, it can pass.
> Darrick, do you know more about that?
> 
> Thanks,
> Zorro
> 
>>> xfs/148 is a clone of test 030 using xfs_prepair64 instead of xfs_repair.
>>> xfs/149 is a clone of test 031 using xfs_prepair instead of xfs_repair
> I'm not worried about it too much, due to it always 'not run' and never
> failsYes. But I perfer to remove them because IMO they are useless.
> 

> xfs/148 [not run] parallel repair binary xfs_prepair64 is not installed
> xfs/149 [not run] parallel repair binary xfs_prepair is not installed
> Ran: xfs/148 xfs/149
> Not run: xfs/148 xfs/149
> Passed all 2 tests
> 


