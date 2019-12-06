Return-Path: <SRS0=r/Pz=Z4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD61C3F68F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 07:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E2C2467B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Dec 2019 07:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfLFHIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Dec 2019 02:08:32 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:3946 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726214AbfLFHIc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Dec 2019 02:08:32 -0500
X-IronPort-AV: E=Sophos;i="5.69,283,1571673600"; 
   d="scan'208";a="79707266"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Dec 2019 15:08:25 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 4C5114CE1BED;
        Fri,  6 Dec 2019 14:59:56 +0800 (CST)
Received: from [10.167.220.84] (10.167.220.84) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1395.4; Fri, 6 Dec 2019 15:08:27 +0800
Subject: Re: [PATCH] xfs/148: sort attribute list output
To:     Xiaoli Feng <xifeng@redhat.com>
CC:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eryu Guan <guaneryu@gmail.com>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
References: <20191204023642.GD7328@magnolia>
 <443856653.20019671.1575615076055.JavaMail.zimbra@redhat.com>
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Message-ID: <1c4f93ac-96b7-f347-250a-1e678fb14693@cn.fujitsu.com>
Date:   Fri, 6 Dec 2019 15:08:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <443856653.20019671.1575615076055.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) To
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201)
X-yoursite-MailScanner-ID: 4C5114CE1BED.AEE5A
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



on 2019/12/06 14:51, Xiaoli Feng wrote:
> Hi,
> 
> ----- Original Message -----
>> From: "Darrick J. Wong" <darrick.wong@oracle.com>
>> To: "Eryu Guan" <guaneryu@gmail.com>
>> Cc: "Yang Xu" <xuyang2018.ky@cn.fujitsu.com>, "fstests" <fstests@vger.kernel.org>, "xfs" <linux-xfs@vger.kernel.org>
>> Sent: Wednesday, December 4, 2019 10:36:42 AM
>> Subject: [PATCH] xfs/148: sort attribute list output
>>
>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Yang Xu reported a test failure in xfs/148 that I think comes from
>> extended attributes being returned in a different order than they were
>> set.  Since order isn't important in this test, sort the output to make
>> it consistent.
>>
>> Reported-by: Yang Xu <xuyang2018.ky@cn.fujitsu.com>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>   tests/xfs/148     |    2 +-
>>   tests/xfs/148.out |    4 ++--
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tests/xfs/148 b/tests/xfs/148
>> index 42cfdab0..ec1d0ece 100755
>> --- a/tests/xfs/148
>> +++ b/tests/xfs/148
>> @@ -76,7 +76,7 @@ test_names+=("too_many" "are_bad/for_you")
>>   
>>   access_stuff() {
>>   	ls $testdir
>> -	$ATTR_PROG -l $testfile
>> +	$ATTR_PROG -l $testfile | grep 'a_' | sort
>>   
>>   	for name in "${test_names[@]}"; do
>>   		ls "$testdir/f_$name"
>> diff --git a/tests/xfs/148.out b/tests/xfs/148.out
>> index c301ecb6..f95b55b7 100644
>> --- a/tests/xfs/148.out
>> +++ b/tests/xfs/148.out
>> @@ -4,10 +4,10 @@ f_another
>>   f_are_bad_for_you
>>   f_something
>>   f_too_many_beans
>> +Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
>> +Attribute "a_are_bad_for_you" has a 3 byte value for
> 
>  From my test on RHEL8&RHEL7, when touch a file, there is a default attribute:
> Attribute "selinux" has a 37 byte value for TEST_DIR/mount-148/testfile
> Could you share the OS you test?
Hi Xiao
    IMHO, the aim of this test is to check kernel whether catch corrupt 
directory name or attr names. selinux is not check target. Also, if you 
disable selinux, it doesn't generate selinux in 148.out.  So Darrick 
filters selinux.

Thanks
Yang Xu
> 
> Thanks.
> 
>> TEST_DIR/mount-148/testfile
>>   Attribute "a_something" has a 3 byte value for TEST_DIR/mount-148/testfile
>>   Attribute "a_too_many_beans" has a 3 byte value for
>>   TEST_DIR/mount-148/testfile
>> -Attribute "a_are_bad_for_you" has a 3 byte value for
>> TEST_DIR/mount-148/testfile
>> -Attribute "a_another" has a 3 byte value for TEST_DIR/mount-148/testfile
>>   TEST_DIR/mount-148/testdir/f_something
>>   Attribute "a_something" had a 3 byte value for TEST_DIR/mount-148/testfile:
>>   heh
>>
>>
> 
> 
> 


