Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_BL,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6703BC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 14:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B6C207D8
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 14:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fVSRoqRM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgESO4O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 10:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgESO4N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 10:56:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B0C08C5C0
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 07:56:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v63so6060pfb.10
        for <linux-xfs@vger.kernel.org>; Tue, 19 May 2020 07:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vvb6jHiLTL33P8XZNL4AJp2Nxf/cGK/BG7R04hAIFi8=;
        b=fVSRoqRM/qQeyq0klKqnI+bk6EBL2CGAUcWLMhfzwnBthmkMFJZcEVE6eJkg3bzYO4
         v9CEtjrNFpwdlbGeDjpENgMg1j/KiI/OUoVS9gT9aGod6pGHU4gaJ/JaKZvvRMN0gJ9A
         9e8eLX6FeFPpRUl8U5NH/oGjeM0oucrzbzBHvCGCp0wx+5Po8Dry0xVBELUyEPME6Mjz
         OJ+tUv9Cw+OLucDkoDZJgQyQvYknGkJl/Yjl1v778pwQvKSMNJas0upobmTnn1Kvp8vm
         Vh40355REM6Y9Z34m8yXiltT4qmtjP/Fx7unXYbAqZ/sFnPbQdK8Ohsbz+b8nUvEX+XV
         wwGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vvb6jHiLTL33P8XZNL4AJp2Nxf/cGK/BG7R04hAIFi8=;
        b=RCyV9g9mTdvzjXf+fBuZlCTsUCBNZfOlhOWId7ZtON6Rz7vjFdgkJemaereR3tnAjM
         BRLQ/XYEqtuRoMWFJ2TJpfmbyfQIE1La3oM4sEc6bzC/FMi2Yt1JXDfstuiu4Y6/qFa/
         HWi6qhnHj6x3jLBPafzDD9UBKypxKyTJTJFngpXcggDg00ilad2vZLhZWA/V/0g1KORZ
         2b32N6yh/n1p19JsIqGy6NZIpIK5An4cMuVzi6gUucRSa6fIsw4/bndLIg6HROK05nwG
         GUBmCPqygb0KjsVWcQ62EWE4HfiQBa2wUC4BDoZZbCrIotYXcAok9If6MzYkS2RKSskh
         hGJA==
X-Gm-Message-State: AOAM531IzrxOVvxN2XOsNsPNhI94L85ni2ozN0wS2CfYsO+pID+sOlpI
        k//RtR1YKbN751gUc8QcqA==
X-Google-Smtp-Source: ABdhPJyV5w3jdG512mqB8JxyDztiUzMiE9wK+eQlFFonjtuItMIywmJro9afsvWYyJgTs9ka9GW5qQ==
X-Received: by 2002:aa7:8c53:: with SMTP id e19mr17997581pfd.264.1589900172813;
        Tue, 19 May 2020 07:56:12 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.8])
        by smtp.gmail.com with ESMTPSA id d2sm11676127pfc.7.2020.05.19.07.56.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 07:56:10 -0700 (PDT)
Subject: Re: [PATCH] mkfs: simplify the configured sector sizes setting in
 validate_sectorsize
To:     Eric Sandeen <sandeen@sandeen.net>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1589870320-29475-1-git-send-email-kaixuxia@tencent.com>
 <BYAPR04MB49656AE414B13D704CCC6A6B86B90@BYAPR04MB4965.namprd04.prod.outlook.com>
 <1b6748ad-249a-dbf0-efbd-c13edd344aaa@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <64a8d225-1d55-e6f1-eed3-b9a04eb426d6@gmail.com>
Date:   Tue, 19 May 2020 22:56:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1b6748ad-249a-dbf0-efbd-c13edd344aaa@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/5/19 21:03, Eric Sandeen wrote:
> On 5/19/20 3:38 AM, Chaitanya Kulkarni wrote:
>> On 5/18/20 11:39 PM, xiakaixu1987@gmail.com wrote:
>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>
>>> There are two places that set the configured sector sizes in validate_sectorsize,
>>> actually we can simplify them and combine into one if statement.
>>> Is it me or patch description seems to be longer than what is in the
>> tree ?
>>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>>> ---
>>>   mkfs/xfs_mkfs.c | 14 ++++----------
>>>   1 file changed, 4 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 039b1dcc..e1904d57 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -1696,14 +1696,6 @@ validate_sectorsize(
>>>   	int			dry_run,
>>>   	int			force_overwrite)
>>>   {
>>> -	/* set configured sector sizes in preparation for checks */
>>> -	if (!cli->sectorsize) {
>>> -		cfg->sectorsize = dft->sectorsize;
>>> -	} else {
>>> -		cfg->sectorsize = cli->sectorsize;
>>> -	}
>>> -	cfg->sectorlog = libxfs_highbit32(cfg->sectorsize);
>>> -
>>
>> If above logic is correct which I've not looked into it, then dft is
>> not used in validate_sectorsize(), how about something like this on
>> the top of this this patch (totally untested):-
> 
> Honestly if not set via commandline, and probing fails, we should fall
> back to dft->sectorsize so that all the defaults are still set in one place,
> i.e. the defaults structure mkfs_default_params.

The original logic in validate_sectorsize() is:

  static void 
  validate_sectorsize(
    ...
    if (!cli->sectorsize) {
	cfg->sectorsize = dft->sectorsize;
    } else {
	cfg->sectorsize = cli->sectorsize;
    }
    ...
    if (!cli->sectorsize) {
	if (!ft->lsectorsize)
	   ft->lsectorsize = XFS_MIN_SECTORSIZE;
	...
	cfg->sectorsize = ft->psectorsize;
	...
    } 
    ...
  }

Firstly, if not set via commandline and probing fails, we will use the
XFS_MIN_SECTORSIZE (actually equal to dft->sectorsize). 
Secondly, for the !cli->sectorsize case, the first if statement set cfg->sectorsize
to dft->sectorsize, but the cfg->sectorsize value would be overwrote and set to
ft->psectorsize in the next if statement, so the first if statement is meaningless
and the two if statements can be combined.

> 
> -Eric
>  
> 

-- 
kaixuxia
