Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CE71C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 06:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49F0F61165
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 06:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhDIGy0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:54:26 -0400
Received: from gateway23.websitewelcome.com ([192.185.48.84]:34129 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhDIGyZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 02:54:25 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id A7E5EC51A
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 01:54:11 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ul1vlLPbnL7DmUl1vlcT3B; Fri, 09 Apr 2021 01:54:11 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yiQ8aK6h6sfF+o8lIOec/EO+BVR5kF4D01S8U9RA7EA=; b=xfBzGLbWBxviVD/fLlQKuAwIl/
        fGSLudVZb/NT8G41TzsLdqyUStepndr8iYrahCxAtGQp0x0Po31GxraZsE8QmcHxCFVLjADW3Rag0
        Uhe+HRdiMISH7ZZPscKO8sIBMXxWO+I3m9Jsc21QjsqNkwYOiE4OGaFhxNJkXoT5S7Q++NNM0ApDF
        DcnlNKenEsmR+HVVBDwht/0BRDqa6LiOmTig0e7ycdlvE+koApqvD1+KzCyyUt8TIRMqMNRlwNfe+
        QT4Ox53X+pyIo10Pf9O7AjnTH7IJI8KkioJpGv3pTo33ZS761dUlBLK8oQpYbhFcgPCOmeKI5xro5
        CShyD6rw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:35336 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lUl1v-000PvB-CH; Fri, 09 Apr 2021 01:54:11 -0500
Subject: Re: [PATCH v3][next] xfs: Replace one-element arrays with
 flexible-array members
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210311042302.GA137676@embeddedor>
 <20210311044700.GU3419940@magnolia>
 <96be7032-a95c-e8d2-a7f8-64b96686ea42@embeddedor.com>
 <20210320201711.GY22100@magnolia>
 <d5a9046e-e204-c854-34fe-2a39e58faea4@embeddedor.com>
 <20210320214831.GA22100@magnolia>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b9973292-efe6-5f95-a3a5-5d86e4081803@embeddedor.com>
Date:   Fri, 9 Apr 2021 01:54:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210320214831.GA22100@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lUl1v-000PvB-CH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:35336
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Hi!

I think I might have caught the issue:

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5e0713bebcd8..9231457371100 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1937,17 +1937,17 @@ xfs_init_zones(void)
 		goto out_destroy_trans_zone;

 	xfs_efd_zone = kmem_cache_create("xfs_efd_item",
-					(sizeof(struct xfs_efd_log_item) +
-					(XFS_EFD_MAX_FAST_EXTENTS - 1) *
-					sizeof(struct xfs_extent)),
-					0, 0, NULL);
+					 struct_size((struct xfs_efd_log_item *)0,
+					 efd_format.efd_extents,
+					 XFS_EFD_MAX_FAST_EXTENTS),
+					 0, 0, NULL);
 	if (!xfs_efd_zone)
 		goto out_destroy_buf_item_zone;

 	xfs_efi_zone = kmem_cache_create("xfs_efi_item",
-					 (sizeof(struct xfs_efi_log_item) +
-					 (XFS_EFI_MAX_FAST_EXTENTS - 1) *
-					 sizeof(struct xfs_extent)),
+					 struct_size((struct xfs_efi_log_item *)0,
+					 efi_format.efi_extents,
+					 XFS_EFI_MAX_FAST_EXTENTS),
 					 0, 0, NULL);
 	if (!xfs_efi_zone)
 		goto out_destroy_efd_zone;

I'm currently testing the patch with the fix above:

https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/commit/?h=testing/xfs-fixed

--
Gustavo

On 3/20/21 16:48, Darrick J. Wong wrote:
> On Sat, Mar 20, 2021 at 03:20:55PM -0500, Gustavo A. R. Silva wrote:
>>
>>
>> On 3/20/21 15:17, Darrick J. Wong wrote:
>>>>>> Below are the results of running xfstests for groups shutdown and log
>>>>>> with the following configuration in local.config:
>>>>>>
>>>>>> export TEST_DEV=/dev/sda3
>>>>>> export TEST_DIR=/mnt/test
>>>>>> export SCRATCH_DEV=/dev/sda4
>>>>>> export SCRATCH_MNT=/mnt/scratch
>>>>>>
>>>>>> The size for both partitions /dev/sda3 and /dev/sda4 is 25GB.
>>>>>
>>>>> Looks good to me, will toss it at my fstests cloud and see if anything
>>>>> shakes out.  Thanks for cleaning up this goofy thorn-pile!
>>>>
>>>> Great. It's been fun to work on this. :p
>>>
>>> Did you run the /entire/ fstests suite?  With this patch applied to
>>> 5.12-rc2, I keep seeing list corruption assertions about an hour into
>>
>> Nope; I run xfstests 'shutdown' and 'log' groups on 5.11.0, only.
>>
>> How do you run the entire fstests?
>> Could you give me some pointers?
> 
> ./check -g all
> 
> (instead of "./check -g shutdown")
> 
>>> the test run, and usually on some test that heavily exercises allocating
>>> and deleting file extents.  I'll try to look at this patch more closely
>>> next week, but I figured I should let you know early, on the off chance
>>> something sticks out to you.
>>
>> OK. I'll go run my tests on 5.12-rc2.
>>
>> Should I run the entire xfstests, too?
> 
> Yes, please.
> 
> --D
> 
>> Thanks
>> --
>> Gustavo
