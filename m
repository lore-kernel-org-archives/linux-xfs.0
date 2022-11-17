Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9647C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 16:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiKQQPL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Nov 2022 11:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiKQQO5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 11:14:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D495F92
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 08:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668701634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BGMtZW26mB4neyCq67JPxIbBHmoUvkGMnI9jDxzJca8=;
        b=DuYh1r9hv6tSr5UZS3q7IX0uKg170mkOwL2HmbtRI4m9YIXPhLOuv3TBgD7GnbjAw9svrf
        uzayK/QpnWhk8lwP6DgRkDvEJXX99B39MabfIQyw84EmlF/4Rxmf1LLbFCHR/7mA5nNZfI
        755cwHY98wNhc8+iCumB4+cQuPH+bF0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-605-aci7j6U4NfyBR29DEtzI8g-1; Thu, 17 Nov 2022 11:13:50 -0500
X-MC-Unique: aci7j6U4NfyBR29DEtzI8g-1
Received: by mail-il1-f200.google.com with SMTP id a14-20020a921a0e000000b003016bfa7e50so1479613ila.16
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 08:13:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BGMtZW26mB4neyCq67JPxIbBHmoUvkGMnI9jDxzJca8=;
        b=vGDDoaXUUwimnSTYfM3xP3YoWgTw92ebGp2Ax/QXLFv5P8mN47WmwIjVDFVl3uqjql
         ucL5n8nhl806RVnyuNzmti6LWgKw5arkUrKUDFVBRfXLHXoI1QQNhjOLsxMN7wKeQ8Za
         nAiPA0LgLFNP2YE7axIXqD+9/fnR/HVE7AZNCWcmOkchWe+AXT+LMpquFIvNHb5+mp4U
         zAfzSMONaZB6B2jSt/YQTdx4P+c0F7WQNiXWEDYbk5CXsZ1icmk+pIvZdSqqfD0C2Heq
         wDNSPedDI8U8Xk0K5IP/atDuCzx51KadEOA+F7yPl1RMKSN9c/19lH45poTrmpMRSl9L
         HGpw==
X-Gm-Message-State: ANoB5pnsbYASuJgylRsqPwY/7kGhXQTPdE5ZS3GNJFCtl0nKx5dBV7cC
        yWaul9Hlu2dkR14e5v80lA2Taz7b4t92z4LamEfG6NkZR3g1gZn+xBLiNIRljdMJL2yjtUgJRXT
        yjUsXiR9bNlWC7jQa3AXL
X-Received: by 2002:a02:3b5d:0:b0:363:d405:587 with SMTP id i29-20020a023b5d000000b00363d4050587mr1328194jaf.86.1668701629462;
        Thu, 17 Nov 2022 08:13:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7HFBJIkpO7PlfPPLiSFI5dDC/12vEY0AGZ4eQ/9eQVbWFs/frq1qIVoYb2qIEyGd1/xRphSQ==
X-Received: by 2002:a02:3b5d:0:b0:363:d405:587 with SMTP id i29-20020a023b5d000000b00363d4050587mr1328178jaf.86.1668701629185;
        Thu, 17 Nov 2022 08:13:49 -0800 (PST)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id w22-20020a056638025600b003636e5c4612sm374380jaq.33.2022.11.17.08.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 08:13:48 -0800 (PST)
Message-ID: <6ad3b4b0-f25b-1609-e79b-82204bc5577a@redhat.com>
Date:   Thu, 17 Nov 2022 10:13:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH] xfs: fix incorrect usage of xfs_btree_check_block
To:     Guo Xuenan <guoxuenan@huawei.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        jack.qiu@huawei.com, fangwei1@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com, leo.lilong@huawei.com, zengheng4@huawei.com
References: <20221103113709.251669-1-guoxuenan@huawei.com>
 <Y2k5NTjTRdsDAuhN@magnolia> <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
Content-Language: en-US
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <1afe73bb-481c-01b3-8c61-3d208e359f40@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/7/22 7:50 PM, Guo Xuenan wrote:
> On 2022/11/8 0:58, Darrick J. Wong wrote:
>> On Thu, Nov 03, 2022 at 07:37:09PM +0800, Guo Xuenan wrote:
>>> xfs_btree_check_block contains a tag XFS_ERRTAG_BTREE_CHECK_{L,S}BLOCK,
>>> it is a fault injection tag, better not use it in the macro ASSERT.
>>>
>>> Since with XFS_DEBUG setting up, we can always trigger assert by `echo 1
>>>> /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
>>> It's confusing and strange.
>> Please be more specific about how this is confusing or strange.
> I meant in current code, the ASSERT will alway happen,when we
> `echo 1 > /sys/fs/xfs/${disk}/errortag/btree_chk_{s,l}blk`.
> xfs_btree_islastblock
>   ->ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
>     ->xfs_btree_check_{l/s}block
>       ->XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_{S,L}BLOCK)
> we can use error injection to trigger this ASSERT.

Hmmm...

> I think ASERRT macro and error injection are to find some effective problems,
> not to create some kernel panic.

You can avoid a panic by turning XFS_ASSERT_FATAL off in Kconfig, or
at runtime by setting fs.xfs.bug_on_assert to 0, but ...

> So, putting the error injection function in
> ASSERT is a little strange.

Ok, so I think the argument is that in the default config, setting this error
injection tag will immediately result in a system panic, which probably isn't
what we want.  Is my understanding correct?

But in the bigger picture, isn't this:

ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);

putting a disk corruption check into an ASSERT? That in itself seems a bit
suspect.  However, the ASSERT was all introduced in:

commit 27d9ee577dccec94fb0fc1a14728de64db342f86
Author: Darrick J. Wong <darrick.wong@oracle.com>
Date:   Wed Nov 6 08:47:09 2019 -0800

    xfs: actually check xfs_btree_check_block return in xfs_btree_islastblock
    
    Coverity points out that xfs_btree_islastblock doesn't check the return
    value of xfs_btree_check_block.  Since the question "Does the cursor
    point to the last block in this level?" only makes sense if the caller
    previously performed a lookup or seek operation, the block should
    already have been checked.
    
    Therefore, check the return value in an ASSERT and turn the whole thing
    into a static inline predicate.
    
    Coverity-id: 114069
    Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

which seems to imply that we really should not get here with a corrupt block during
normal operation.

Perhaps the error tag can get set after the block "should already have been checked"
but before this test in the ASSERT?

-Eric

