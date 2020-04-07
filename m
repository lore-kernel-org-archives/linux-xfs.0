Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5DBC2BA1A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 01:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B04B82076E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 01:30:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dp05GDvz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgDGBah (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 21:30:37 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51967 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgDGBah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 21:30:37 -0400
Received: by mail-pj1-f65.google.com with SMTP id n4so50919pjp.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2020 18:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W3uodW8DzOWEJ6Yui4/Q0JoWobC52MS78iiJn3seByk=;
        b=dp05GDvz4v7aalLwKHs4tjh6iW3QaMCrqBbKnA6SvJM5GQWvIIxB5GJ+IMtYdqDS/d
         z3GNr/1KQJtvnKrcoZyF43nOgmoxkMVzzxVk0c4s9h6MMfUGvOFKkPMArKcv8bd6B2PQ
         mihvfgCIzyzI+hq4dvq4NETi5eu34ImRdONUnwZ2Abo9g2onlJXJ3cuusbRTAUrL8V6v
         wBIWu6qgTHlCGn6Z9j6D9EsUfDCEGkeCM9WH9taicnnSvkbaaHdRRYfM/HDQ/Gj3ziPl
         TNAGdseVvFfUqjXhSvu+6yOwYTIQdMZ2WwLcSpahPZvflDrBBgaSmv9lScd7wPsLpN14
         AEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W3uodW8DzOWEJ6Yui4/Q0JoWobC52MS78iiJn3seByk=;
        b=gpuhJU4mwAUS20UalROjhl8MiV0vPMTu7GiNMNVG6VHO5prQxUfpRUysPDJ+mVPRMk
         +K5onIs0yAZQ2WKkAoobMb9jS316atoTNDTKmoc9hTNQ+3g7pMfxUO5geZ5lsCRI8ZNU
         8qLmRPMIgjaB1luT4SPVTv8euLvSnDYI50iu20YGXJxzl1bvdA/F49AX9XRgiSic2Yqy
         qrv0/wODdxiJ36z7AgLzpjb8t/dzwrVAv/luwPSwIvKa6vAdVFePPzmgxJ6+Si5GXzsx
         MlAyCLlyz1SFHJCyXyVBR0E8rtEkdt5JxGfcqX0jPf4iO4sq0ua6F5tcarNmQ+XucJ6E
         1onA==
X-Gm-Message-State: AGi0PuYBJ6fGv/2GNCy8tD3V+xJ9GoQOh5Fws8GPhdgFKLZcICW2TKKP
        /c9iDBGDc5LJ3NUgfnwblA==
X-Google-Smtp-Source: APiQypLMfu0PNyWNBFZmx/LT0VTMGEeTZzysoRx505VbCjmoY6ZSdQ8kNrIeh+kaOCbAdjtOjQkxlQ==
X-Received: by 2002:a17:902:6ac3:: with SMTP id i3mr121199plt.111.1586223034166;
        Mon, 06 Apr 2020 18:30:34 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id x188sm11865871pgb.76.2020.04.06.18.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 18:30:33 -0700 (PDT)
Subject: Re: [PATCH] xfs: check if reserved free disk blocks is needed
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1586078239-14289-1-git-send-email-kaixuxia@tencent.com>
 <20200406133859.GB20708@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <5f323870-6fcf-8935-fea6-bf0fa14d5c2e@gmail.com>
Date:   Tue, 7 Apr 2020 09:30:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200406133859.GB20708@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/4/6 21:38, Brian Foster wrote:
> On Sun, Apr 05, 2020 at 05:17:19PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We don't need to create the new quota inodes from disk when
>> they exist already, so add check if reserved free disk blocks
>> is needed in xfs_trans_alloc().
>>
> 
> I find the commit log to be a bit misleading. We don't actually get into
> this code if the inodes exist already. The need_alloc == false case
> looks like it has more to do with the scenario with the project/group
> inode is shared on older superblocks (explained in the comment near the
> top of the alloc function).
> 
> That aside, the code looks fine to me, so with an improved commit log:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
Thanks for your comments, will send the new version with the improved
commit log and add your Reviewed-by.

>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_qm.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index 6678baa..b684b04 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -780,7 +780,8 @@ struct xfs_qm_isolate {
>>  	}
>>  
>>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
>> -			XFS_QM_QINOCREATE_SPACE_RES(mp), 0, 0, &tp);
>> +			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
>> +			0, 0, &tp);
>>  	if (error)
>>  		return error;
>>  
>> -- 
>> 1.8.3.1
>>
> 

-- 
kaixuxia
