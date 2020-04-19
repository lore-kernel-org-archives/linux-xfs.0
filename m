Return-Path: <SRS0=tLNC=6D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED90C38A30
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Apr 2020 13:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1F521D94
	for <linux-xfs@archiver.kernel.org>; Sun, 19 Apr 2020 13:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="KDMNQp72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDSNSb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 19 Apr 2020 09:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgDSNSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 19 Apr 2020 09:18:31 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB76C061A0F
        for <linux-xfs@vger.kernel.org>; Sun, 19 Apr 2020 06:18:30 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k11so8647714wrp.5
        for <linux-xfs@vger.kernel.org>; Sun, 19 Apr 2020 06:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=d7uWd42bxjLECBoyKqUFcSgX+qLoIr7sHSlgcJYFfKA=;
        b=KDMNQp72IvNSjc7YnZXiEJCdTe46bTWRD0hpXvaAVeVyc48Wxi3CP103NqG5iKHIFe
         mgZAsMUeYWWkln8MaxDa7cuLZB4zWLz/Ke8rt664lMRA7aw68Qb2CUjA6TRycOTKpZzx
         86GamItWImZrHqvb/OcO3mT2Lugr4tVQ6suKsete4SifQmOw06RWWjfmeXgu0L0+XU+u
         YzSaeTAk2/HiFJVRww/sNI9uoiaj1ndBZiUtR2erZLK+wrgNin+AbvGk0/arbNcEuzQN
         jWZihNsaAMFpfXJk4DZS2Z4lHQx7XeQHH9vIw/DXIKOKkNfm0+mI/WRBzC4n/k8FikhC
         uocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=d7uWd42bxjLECBoyKqUFcSgX+qLoIr7sHSlgcJYFfKA=;
        b=fGzq+arpuKutYjOlDPvCuQVmfQlNBuvj2q8g8s59osePpbg+mYoCynyGcgFYridIkl
         Ms5KBASs4+RuqjwKH5Cbo72WcgWoRWmXUjCUXzU3wocdD0mHLeRbGRVmdAwhG4js5lmU
         NEBBzlNJwqiDpcx8/35zyywBMaYWRTaW5kStXFDlEPBDcDdJXhYEFZnQi9tq3oaONHpc
         uvuOTcrWD/mfJJi+zo8+xQ8xeEczIZ6IX5RZlw4oycVeuXXzRfktqHI7x5rDkQQFouJV
         SNPHWwmmaDKm2xIrLUPaxQX+WoEPGDReteWGOtwsCdjz/cL1Lq+lPsUICuz519gvvNqm
         BJ6g==
X-Gm-Message-State: AGi0PuY2mz5RnhlQ+UnBvPgANYZitaRb6SaUg9ZzM6zkAYCT7hGknNBW
        41eCm5w2Mh29gtNrBdV50dRFbD+bEFo=
X-Google-Smtp-Source: APiQypLGytTbLGbx5f7rIxpb/IprQ4USxbwGEHlHZE/oXxnV95PH3Pu7knPlyNkad/NlfVLq2TgwgQ==
X-Received: by 2002:a5d:408d:: with SMTP id o13mr14718403wrp.249.1587302309472;
        Sun, 19 Apr 2020 06:18:29 -0700 (PDT)
Received: from ?IPv6:2001:16b8:48da:6b00:34d4:fc5b:d862:dbd2? ([2001:16b8:48da:6b00:34d4:fc5b:d862:dbd2])
        by smtp.gmail.com with ESMTPSA id i25sm15688322wml.43.2020.04.19.06.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 06:18:28 -0700 (PDT)
Subject: Re: [PATCH 3/5] iomap: call __clear_page_buffers in
 iomap_page_release
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200418225123.31850-1-guoqing.jiang@cloud.ionos.com>
 <20200418225123.31850-4-guoqing.jiang@cloud.ionos.com>
 <20200419074729.GA17062@infradead.org>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <d5c7c15c-965c-5003-fd90-92e3cb6f10de@cloud.ionos.com>
Date:   Sun, 19 Apr 2020 15:18:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200419074729.GA17062@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 19.04.20 09:47, Christoph Hellwig wrote:
> On Sun, Apr 19, 2020 at 12:51:21AM +0200, Guoqing Jiang wrote:
>> After the helper is exported, we can call it to simplify code a little.
>>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Darrick J. Wong <darrick.wong@oracle.com>
>> Cc: linux-xfs@vger.kernel.org
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> ---
>>   fs/iomap/buffered-io.c | 4 +---
>>   1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
>> index 89e21961d1ad..b06568ad9a7a 100644
>> --- a/fs/iomap/buffered-io.c
>> +++ b/fs/iomap/buffered-io.c
>> @@ -74,9 +74,7 @@ iomap_page_release(struct page *page)
>>   		return;
>>   	WARN_ON_ONCE(atomic_read(&iop->read_count));
>>   	WARN_ON_ONCE(atomic_read(&iop->write_count));
>> -	ClearPagePrivate(page);
>> -	set_page_private(page, 0);
>> -	put_page(page);
>> +	__clear_page_buffers(page);
> We should not call a helper mentioning buffers in code that has
> nothing to do with buffers.  If you want to us __clear_page_buffers
> more widely please give it a better name first.

Yes, I will rename it to clear_page_private as Matthew suggested.

> You'll also forgot to Cc me on the other patches in the series, which is
> a completel no-go as it doesn't allow for a proper review.

Sorry, will cc you with the series next time.

Thanks,
Guoqing

