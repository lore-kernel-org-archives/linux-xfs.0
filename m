Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90BCC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C42223FB
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fD8peGPN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390849AbgJTCyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgJTCyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 22:54:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940A9C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 19:54:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so164991pgl.2
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 19:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0eChFyTsC9dzUp2pHPoLOoGrrAJSaHv3mcTYwnisLTo=;
        b=fD8peGPN5mEVMxw6gmaZYM8NCNQdswkgw8A3yvPMT5nsoHRfixcjrRcumneRM9wFev
         G2tWp15vMLRjyXISHGYhJF0a9q9pskjRdajaqU5kuIX/GzWWgIsOhRwWuSMuVhc/A2nf
         dDjVfTag7ZEoKM+ndxDQjKxJxQViHDIadhGh+U85+KpKLeOea7sKFWkv5wG05Z+ssXJB
         /tDeRsUpfdUd8r9rJIGf9xxFTcrAocqnDA1RFsgiyfMDwDr9qaSrzpDWO9c95BhVP+pM
         HSoFdNJ5RPIW0OCy+xN5/sSOsrZahaEbs+m/YEHuOy4Y7rPPIr/XP/uUwi371vCf5BWd
         +Afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0eChFyTsC9dzUp2pHPoLOoGrrAJSaHv3mcTYwnisLTo=;
        b=oZSsjxsxJEY2oDBXHVlXlSsc4wKuJ1ENfw8EFIokXFZrWIghVzguMxcW8MxMlQ9YbY
         qKAh0650Hwe2XkdoB68hfKLSQhtERbIT9AG58OF3HUvwfudC3OtKqFVbjvaIH7eq5thB
         NaL1PA0ICiGOjv2UDXXzCargBt/ubdvX9IOa8MQ0NmkYlSeiK3tbUNRib2IDPNi2q5+H
         sDqAR2Nczgzs7gxskBGZl2vF9bcIRAoWIHPIegYzLWygNsDuvz4oSD7Z0PRbglh8tHeE
         qyrOx2Y466U2J1TUGKi5chQG33UATrpdylCwOUoGhhyZYV+Q0Cg2OltIFW/Sm+XORSgR
         NtGw==
X-Gm-Message-State: AOAM532m4xa1co9AaQ72N8FzDkNRc3BK4eEvx4NRz/2ifS5iswR0mXdv
        pCpY2G4K+uLuitfJBXHz/A==
X-Google-Smtp-Source: ABdhPJxgWhFsKIcxjz2/dNLectDov/g1iX84IyHPqKhAQUNLg+Vz2TVpl/i5xCDwKs1AUzUJv9h69g==
X-Received: by 2002:a63:f40a:: with SMTP id g10mr889029pgi.66.1603162456164;
        Mon, 19 Oct 2020 19:54:16 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id f2sm298605pfk.187.2020.10.19.19.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 19:54:15 -0700 (PDT)
Subject: Re: [PATCH] xfs: use the SECTOR_SHIFT macro instead of the magic
 number
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
 <1603100845-12205-2-git-send-email-kaixuxia@tencent.com>
 <771644f3-99dd-bdad-ef34-60f65faecd1a@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <162b310a-5d23-d380-8e55-7319f35773a9@gmail.com>
Date:   Tue, 20 Oct 2020 10:54:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <771644f3-99dd-bdad-ef34-60f65faecd1a@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/20 0:32, Eric Sandeen wrote:
> On 10/19/20 4:47 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We use the SECTOR_SHIFT macro to define the sector size shift, so maybe
>> it is more reasonable to use it than the magic number 9.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> 
> Hm ...  SECTOR_SHIFT is a block layer #define, really,
> and blkdev_issue_zeroout is a block layer interface I guess.
> 
> We also have our own BBSHIFT in XFS which is used elsewhere, though.
> 
> And FWIW, /many/ other fs/* manipulations still use the "- 9" today when
> converting s_blocksize_bits to sectors.  *shrug* this seems like something
> that should change tree-wide, if it's to be changed at all.
> 

Yeah, I think the magic number 9 is insecure, maybe a patchset is needed to
change them :)

Thanks,
Kaixu

> -Eric
> 
>> ---
>>  fs/xfs/xfs_bmap_util.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
>> index f2a8a0e75e1f..9f02c1824205 100644
>> --- a/fs/xfs/xfs_bmap_util.c
>> +++ b/fs/xfs/xfs_bmap_util.c
>> @@ -63,8 +63,8 @@ xfs_zero_extent(
>>  	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
>>  
>>  	return blkdev_issue_zeroout(target->bt_bdev,
>> -		block << (mp->m_super->s_blocksize_bits - 9),
>> -		count_fsb << (mp->m_super->s_blocksize_bits - 9),
>> +		block << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
>> +		count_fsb << (mp->m_super->s_blocksize_bits - SECTOR_SHIFT),
>>  		GFP_NOFS, 0);
>>  }
>>  
>>

-- 
kaixuxia
