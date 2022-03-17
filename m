Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1447C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 16:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiCQQEk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiCQQEi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 12:04:38 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33296E57B
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:03:20 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id qx21so11644475ejb.13
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 09:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jE5g3L9QJre57TOvN3X4RTG7VbO2bRn4G2+PJyIvwHg=;
        b=ZA93hsxlFvioUaOjGKfKxSznAf0sl/re/rAaTJ0RzTddCsW09x6pymFo8Zw6Hqzfcy
         rqqOC2ORNTy68PV7k6URtQqellHLQ2IWYhY6oxnTCiEB51ZDJJIGK1WOcRzNw7LjPmLe
         0Zii5Nv51z58VKhVFXUpaKCT3zRlBxhwRifIEqD0zCSMYtxZrDDDyQw/suUB/MswR/Y9
         uTe7qTdipIs4MSiUDM83IcbdTjQ2H0knv6u2F5h249mIgPWREOU0EyI9HIUgj7Mw6XIP
         EM0Tkz30Tax4Y9vlUVND0ff+M5EK0JRMrblnnc4eE2mQDVHtdt+e2GJHgQAs84HRFvAP
         Lexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jE5g3L9QJre57TOvN3X4RTG7VbO2bRn4G2+PJyIvwHg=;
        b=lPC0DfPU7gF9QOg12YcEk8waOpCbtD5dN6I+JCfg41ZuYVlzr/KST6upjfn8J7KNJw
         MdNHazq6C1Y29aW9ZQT7kbj/isC/PXrIHjWBfdtUUdYmRzhC/MFPs6wuLc/96NByJdpY
         ispMwAasNCaPupf0D+tZyUHFj0esus+lTjI/739eHsc6oGYH0Gc8orm914dpm1PBignx
         wotQe8GvpWxtB35uY2Xes3AUcmfQGwmhrJ7ZDxQEQR6k4pemDOKPL5r8CsFEQk9gcY4y
         mIstXKDchfT7810AXRyz1I0+KgauvyC6+TwaI3Dv4ZYKRavFStYPjmSsgLnwpgEncSbM
         2ftQ==
X-Gm-Message-State: AOAM533kPeAVs96KdqdarCqtqVe0UpSeeD7/Y1FZxGS25Nf+0L0hU9z+
        komag/KpF1B941M+OtjN+cdpQKul0thDnw==
X-Google-Smtp-Source: ABdhPJwkmX3YFwqMJyR3i0qD3T3WgfNcMraeaNctGuuzRVAkYcMUlxlj+M0wfERF7+p+UaG4A4oFqg==
X-Received: by 2002:a17:906:32d8:b0:6ce:d850:f79 with SMTP id k24-20020a17090632d800b006ced8500f79mr4968406ejk.414.1647532999164;
        Thu, 17 Mar 2022 09:03:19 -0700 (PDT)
Received: from ?IPV6:2003:d9:970a:1500:3685:1631:4fc4:d41f? (p200300d9970a1500368516314fc4d41f.dip0.t-ipconnect.de. [2003:d9:970a:1500:3685:1631:4fc4:d41f])
        by smtp.googlemail.com with ESMTPSA id k7-20020aa7c047000000b004132d3b60aasm2775451edo.78.2022.03.17.09.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 09:03:18 -0700 (PDT)
Message-ID: <d4497b47-acac-062e-e287-359813d51f24@colorfullife.com>
Date:   Thu, 17 Mar 2022 17:03:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
 <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
 <20220317024705.GY3927073@dread.disaster.area>
 <20220317030828.GZ3927073@dread.disaster.area>
 <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
 <YjNKrGcR3++izffK@mit.edu>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <YjNKrGcR3++izffK@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/17/22 15:50, Theodore Ts'o wrote:
> On Thu, Mar 17, 2022 at 07:49:02AM +0100, Manfred Spraul wrote:
>>>> BTRFS and ZFS can also detect torn writes, and if you use the
>>>> (non-default) ext4 option "metadata_csum" it will also detect torn
>>> Correction - metadata_csum is ienabled by default, I just ran the
>>> wrong mkfs command when I tested it a few moments ago.
>> For ext4, I have seen so far only corrupted commit blocks that cause mount
>> failures.
>>
>> https://lore.kernel.org/all/8fe067d0-6d57-9dd7-2c10-5a2c34037ee1@colorfullife.com/
> Ext4 uses FUA writes (if available) to write out the commit block.  If
> a FUA write can result in torn writes, in my opinion that's a bug with
> the storage device, or if eMMC devices don't respect FUA writes
> correctly, then we should just disable FUA writes entirely.
>
> In the absence of FUA, ext4 does assume that we can write out the
> commit block as a 4k write, and then issue a cache flush.  If your
> simulator assumes that the 4k write can be torn, on the assumption
> that there is a narrow race between the issuance of the 4k write, the
> device writing 1-3 512 byte sectors, and then due to a power failure,
> the cache flush doesn't complete and the result is a torn write ---
> quite frankly, I'm not sure how any system using checksums can deal
> with that situation.  I think we can only assume that that case is in
> reality quite rare, even if it's technically allowed by the spec.

Just checking the eMMC Spec (JESD 84-B51A)

Table 40, Admitted Data Sector Size, Address Mode and Reliable write 
Granularity:

Native sector size 4 kB devices with emulation mode off have a write 
granularity of 4 kB.

Otherwise the granularity is 512 bytes.

So, to avoid the risk of torn writes for ext4, emulation mode should be 
disabled.
For XFS, the spec provides no solution. (20 kB writes that crosses a 32 
kB boundary)

But, obviously:

The real issues identified were much simpler and I have no evidence that 
torn writes are a real risk.


--

     Manfred

