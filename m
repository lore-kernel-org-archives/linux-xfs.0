Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A384C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 02:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiKQC2e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 21:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiKQC2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 21:28:32 -0500
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBD619028
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 18:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1668652109; i=@fujitsu.com;
        bh=f+pg6RebwoVDhYECA4kchkNIGJuWJF8fhR1tCn60SLo=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=ENYPp5/0oAos3AhfnAd/+wDux/eFMI33S7HlCosGjg/iT2oxS7orH65MrPamEU2RC
         wYgFuUEJMG0E+yQrTWWrtCmPXpZKL/Fo41CaeJ3Hmn3TKXb/xukkplPKIawemuxM3z
         wE4mq7w3G9I2S3goYkEbk8PKrkCnhNDXFLRuVGSPUJk286Ln+NnWA0j0xysmiv4HYl
         M1b+iXAk2LnEk4C/aUMF55V+d7uPME5IGY3vTIReJZJxyP30tl3SfCdlPGouB+iPFJ
         zlEyWAqk9YmHaQEaC9j6hy9fkm54K+SWlzsaB3GjVlXPBoR1qzwxkrIuTS2/RKJwn9
         eMxWYbOfeYaXw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRWlGSWpSXmKPExsViZ8ORqOszpzT
  ZYNMhU4vLT/gsdv3ZwW5x9eUBdove6cIOLB4Tm9+xe2xa1cnmce5ihcfnTXIBLFGsmXlJ+RUJ
  rBmNx76wFmwXrHi5t5G5gfEsXxcjJ4eQwBZGiS97rLoYuYDs5UwSO2+uZYJIbGOU6Oq2BrF5B
  ewk1t1sYwexWQRUJeadecMEEReUODnzCQuILSqQJHF1w11WEFtYwEli29lbbCC2iICzxKqdB8
  DizAJWEr9mvWSBmF8k8W9fM1gNm4CjxLxZG4FsDg5OARuJgzMyIcotJBa/OcgOYctLbH87hxn
  ElhBQlGhb8o8dwq6QmDWrjQnCVpO4em4T8wRGoVlIrpuFZNQsJKMWMDKvYjQtTi0qSy3SNdRL
  KspMzyjJTczM0Uus0k3USy3VLU8tLtE10kssL9ZLLS7WK67MTc5J0ctLLdnECIyNlGLVQzsYX
  y35o3eIUZKDSUmU18y/NFmILyk/pTIjsTgjvqg0J7X4EKMMB4eSBK/4DKCcYFFqempFWmYOME
  5h0hIcPEoivJXNQGne4oLE3OLMdIjUKUZ7jm2f9+1l5pg6+99+Zo7lYHLm17YDzEIsefl5qVL
  ivB2zgdoEQNoySvPghsLSyiVGWSlhXkYGBgYhnoLUotzMElT5V4ziHIxKwrwyk4Gm8GTmlcDt
  fgV0FhPQWQf8ikDOKklESEk1MFWIWjcv/XNbM2zhAY/t67aeCHiiZmSSlhiSOedJQvPzSXv/s
  MSqyEVHlaevfyx9oWLrva8+r5uUL+d6zdtd82Bh7dTILuGYiqU7PDoNZ71hsK9+uHv2sw3bK/
  ZK7lzOpF74Nrl6cRPf/ugfTFtj/ST63/C+qfrBwfmuIG2RkgZnFZPMN71W5dTv05meP5vEyzg
  h9Erq+4e3VxzfxiJ/qZhtvUFm4NJll+7fO3rc4OaEmx3rWFcqpcteOS7iwdSjfmZ/aFO4sc/R
  wPKCJHfFo+yVbB9MTN+90RMtqZn9paNksn2b6DefxvBTE948XONrF/u2tjyuYr21cnHH12226
  u4PVqh+O9r+0lD7wfmrFkosxRmJhlrMRcWJAK++9M2mAwAA
X-Env-Sender: yangx.jy@fujitsu.com
X-Msg-Ref: server-22.tower-565.messagelabs.com!1668652108!247697!1
X-Originating-IP: [62.60.8.97]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.101.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15085 invoked from network); 17 Nov 2022 02:28:28 -0000
Received: from unknown (HELO n03ukasimr01.n03.fujitsu.local) (62.60.8.97)
  by server-22.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 17 Nov 2022 02:28:28 -0000
Received: from n03ukasimr01.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTP id 9135B100182;
        Thu, 17 Nov 2022 02:28:28 +0000 (GMT)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr01.n03.fujitsu.local (Postfix) with ESMTPS id 848CA100043;
        Thu, 17 Nov 2022 02:28:28 +0000 (GMT)
Received: from [10.167.215.54] (10.167.215.54) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 17 Nov 2022 02:28:25 +0000
Message-ID: <8987307e-14b7-44a0-fab0-ab141921f858@fujitsu.com>
Date:   Thu, 17 Nov 2022 10:28:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] xfs: Call kiocb_modified() for buffered write
To:     Stefan Roesch <shr@meta.com>, <shr@fb.com>, <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <ruansy.fnst@fujitsu.com>
References: <1668609741-14-1-git-send-email-yangx.jy@fujitsu.com>
 <15e09968-8395-c8e4-aa6e-aa11b29fa175@meta.com>
From:   =?UTF-8?B?WWFuZywgWGlhby/mnagg5pmT?= <yangx.jy@fujitsu.com>
In-Reply-To: <15e09968-8395-c8e4-aa6e-aa11b29fa175@meta.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.54]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/11/17 3:00, Stefan Roesch write:
> 
> On 11/16/22 6:42 AM, Xiao Yang wrote:
>> kiocb_modified() should be used for sync/async buffered write
>> because it will return -EAGAIN when IOCB_NOWAIT is set. Unfortunately,
>> kiocb_modified() is used by the common xfs_file_write_checks()
>> which is called by all types of write(i.e. buffered/direct/dax write).
>> This issue makes generic/471 with xfs always get the following error:
>> --------------------------------------------------------
>> QA output created by 471
>> pwrite: Resource temporarily unavailable
>> wrote 8388608/8388608 bytes at offset 0
>> XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> pwrite: Resource temporarily unavailable
>> ...
>> --------------------------------------------------------
>>
> There have been earlier discussions about this. Snippet from the
> earlier discussion:
> 
> "generic/471 complains because it expects any write done with RWF_NOWAIT
> to succeed as long as the blocks for the write are already instantiated.
> This isn't necessarily a correct assumption, as there are other conditions
> that can cause an RWF_NOWAIT write to fail with -EAGAIN even if the range
> is already there."

Hi Stefan,

Thanks for your reply.
Could you give me the URL about the earlier discussions?

kiocb_modified() makes all types of write always get -EAGAIN when 
RWF_NOWAIT is set.  I don't think this patch[1] is correct because it 
changed the original logic. The original logic only makes buffered write 
get -EOPNOTSUPP when RWF_NOWAIT is set.
---------------------------------------------
static int file_modified_flags(struct file *file, int flags)
{
...
         if (flags & IOCB_NOWAIT)
                 return -EAGAIN;
...
}
int kiocb_modified(struct kiocb *iocb)
{
         return file_modified_flags(iocb->ki_filp, iocb->ki_flags);
}
---------------------------------------------
PS: kiocb_modified() is used by the common xfs_file_write_checks()
which is called by all types of write(i.e. buffered/direct/dax write).

> 
> So the test itself probably needs fixing.

In my opinion, both kernel and the test probably need to be fixed.

[1] 1aa91d9c9933 ("xfs: Add async buffered write support")

Best Regards,
Xiao Yang
