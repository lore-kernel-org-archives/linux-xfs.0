Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF451C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 15:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiCNPT6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 11:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiCNPTy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 11:19:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72CF13F16
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 08:18:43 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qx21so34693163ejb.13
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 08:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FJRhOjRsDN9fH9QwExPnUwt0wgafjMW4+9euX4y5Y3Q=;
        b=0xnT1tqJK2a8Uji1FesYjuAxqCPyAfzMTZHkYmzdlqYH2a0WFL6FNkZBmlsEa0eDlF
         ku0FYEzdEEJWd0DwioAeUA2itESKVipsVQqzMFJ/Tq65J6TN4HeplL1z/P0Z93O1GKa/
         WbSMyLiKz5SX7B0fEcnJRhzyj7FtxiqLg1ssduUd3I86WEdqXz1P0HQuXIhGvDkSfd97
         kOWw/q6AMBTVgDYkZHCW3kKFeIepgKvPqViR5GNX+je0N7FIw144JRYNyZJGLdw+j4Rf
         szAw+7z0Wa3brKlWaaJRUQDYC7UvgHhqEbs3y+aNWUBWLkOid/EyqeFJcywOWA/eoiWV
         dgmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FJRhOjRsDN9fH9QwExPnUwt0wgafjMW4+9euX4y5Y3Q=;
        b=CLZzqcMoCRFu8AWlach03A4SH544f7vR/1H8j2dFAufInneIsNA6Ik0/kZE/TdmTax
         tNaEfSdfXviBf4y3MEjaG5LtsnIbucOMB/HjMnXaF9A5WPcUlkNMZqoagdyOcLMz6chq
         zkPVVs4DBb33MKTVMF/peKep3fmStLV5Zd5fAqoWhrlRZRtQ6MTA+AiXqxG28tRMIfWo
         TjVn1J/Md7s7wpVH7UuK0L1LfPXDveL1H6uGqLYNPEZXFjGeWzosnIWUigLhOKdDuO7C
         MOyZxsVN1zboeDS63t48zQciFmPShM3XLCuSUwTWayMUdmkadLnrozurs/MHN86dCHhQ
         +s5g==
X-Gm-Message-State: AOAM532t2J4Z9R8lLzD41FMpZ0CEXC8or7fSuK36zYl/P/vFz1WaA1Ql
        QhD0ZlabO5aGudmKQnbSaAeIKQ==
X-Google-Smtp-Source: ABdhPJxDyPcl72btcTxQ9icSP3vEpMeCWsopyH2oGM3T/Ty3f2vNryrKoYMpt47oaDjfPBMosESvjg==
X-Received: by 2002:a17:906:6158:b0:6ce:61d6:f243 with SMTP id p24-20020a170906615800b006ce61d6f243mr18831093ejl.268.1647271122397;
        Mon, 14 Mar 2022 08:18:42 -0700 (PDT)
Received: from ?IPV6:2003:d9:9704:f500:d3a4:5e24:c829:28b9? (p200300d99704f500d3a45e24c82928b9.dip0.t-ipconnect.de. [2003:d9:9704:f500:d3a4:5e24:c829:28b9])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm6964750ejb.194.2022.03.14.08.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 08:18:41 -0700 (PDT)
Message-ID: <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
Date:   Mon, 14 Mar 2022 16:18:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
From:   Manfred Spraul <manfred@colorfullife.com>
In-Reply-To: <20220313224624.GJ3927073@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 3/13/22 23:46, Dave Chinner wrote:
> On Sun, Mar 13, 2022 at 04:47:19PM +0100, Manfred Spraul wrote:
>> Hello together,
>>
>>
>> after a simulated power failure, I have observed:
>>
>> Metadata CRC error detected at xfs_dir3_block_read_verify+0x9e/0xc0 [xfs],
>> xfs_dir3_block block 0x86f58
>> [14768.047531] XFS (loop0): Unmount and run xfs_repair
>> [14768.047534] XFS (loop0): First 128 bytes of corrupted metadata buffer:
>> [14768.047537] 00000000: 58 44 42 33 9f ab d7 f4 00 00 00 00 00 08 6f 58
>> XDB3..........oX
> For future reference, please paste the entire log message, from
> the time that the fs was mounted to the end of the hexdump output.
> You might not think the hexdump output is important, but as you'll
> see later....
Noted. I had to chose what I add into the mail, too much information.
>> <<<
>>
>> Is this a known issue?
> Is what a known issue? All this is XFS finding a corrupt metadata
> block because a CRC is invalid, which is exactly what it's supposed
> to do.
>
> As it is, CRC errors are indicative of storage problem such as bit
> errors and torn writes, because what has been read from disk does
> not match what XFS wrote when it calculated the CRC.
>
>> The image file is here: https://github.com/manfred-colorfu/nbd-datalog-referencefiles/blob/main/xfs-02/result/data-1821799.img.xz
>>
>> As first question:
>>
>> Are 512 byte sectors supported, or does xfs assume that 4096 byte writes are
>> atomic?
> 512 byte *IO* is supported on devices that have 512 byte sector
> support, but there are other rules that XFS sets for metadata. e.g.
> that metadata writes are expected to be written completely or
> replayed completely as a whole unit regardless of their length.

>   This
> is bookended by the use of cache flushes and FUAs to ensure that
> multi-sector writes are wholly completed before the recovery
> information is tossed away.

[...]


>> How were the power failures simulated:
>>
>> I added support to nbd to log all write operations, including the written
>> data. This got merged into nbd-3.24
>>
>> I've used that to create a log of running dbench (+ a few tar/rm/manual
>> tests) on a 500 MB image file.
>>
>> In total, 2.9 mio 512-byte sector writes. The datalog is ~1.5 GB long.
>>
>> If replaying the initial 1,821,799, 1,821,800, 1,821,801 or 1,821,802
>> blocks, the above listed error message is shown.
>>
>> After 1,821,799 or 1,821,803 sectors, everything is ok.
(Correcting my own typo:)
1,821,798 or 1,821,803 are ok.
>>
>> (block numbers are 0-based)
>>
>>>> H=2400000047010000 C=0x00000001 (NBD_CMD_WRITE+NONE)
>>> O=0000000010deb000 L=00001000
>>> block 1821795 (0x1bcc63): writing to offset 283029504 (0x10deb000), len
>>> 512 (0x200).
>>> block 1821796 (0x1bcc64): writing to offset 283030016 (0x10deb200), len
>>> 512 (0x200).
>>> block 1821797 (0x1bcc65): writing to offset 283030528 (0x10deb400), len
>>> 512 (0x200).  << OK
>>> block 1821798 (0x1bcc66): writing to offset 283031040 (0x10deb600), len
>>> 512 (0x200).  FAIL
>>> block 1821799 (0x1bcc67): writing to offset 283031552 (0x10deb800), len
>>> 512 (0x200).  FAIL
>>> block 1821800 (0x1bcc68): writing to offset 283032064 (0x10deba00), len
>>> 512 (0x200).  FAIL
>>> block 1821801 (0x1bcc69): writing to offset 283032576 (0x10debc00), len
>>> 512 (0x200).  FAIL
>>> block 1821802 (0x1bcc6a): writing to offset 283033088 (0x10debe00), len
>>> 512 (0x200). << OK
> OK, this test is explicitly tearing writes at the storage level.
> When there is an update to multiple sectors of the metadata block,
> the metadata will be inconsistent on disk while those individual
> sector writes are replayed.

Thanks for the clarification.

I'll modify the test application to never tear write operations and retry.

If there are findings, then I'll distribute them.


--

     Manfred

