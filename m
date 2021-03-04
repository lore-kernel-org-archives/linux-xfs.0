Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12A9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 08:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ED4864EF6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 08:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbhCDIzZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 03:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbhCDIzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 03:55:09 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6768DC061574
        for <linux-xfs@vger.kernel.org>; Thu,  4 Mar 2021 00:54:29 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id m11so31483743lji.10
        for <linux-xfs@vger.kernel.org>; Thu, 04 Mar 2021 00:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/FwuJRqdFexSkz3CLwdSj8g3jWrBg+FPxWYV0vQf47s=;
        b=fFw10g6V4A0BLUFnDNXS+p/T4ors/bRQnvRtzHiLF4IPH3DMEPQEAjocxkwfK8YCrz
         UrVe3I6JRta7+jhqhI0NPn/XrS8pG4JJCVG+kBvNvlgRSWT7mPmPfflXQwUPksLNCL7g
         o7u68jWb3GcZRZWwXchECtHn280fvXkKi+UiX0rTNHzp3qp1oRwp5NajFElxZEWd00HB
         TS6sIa6tUvVWe7QOpc3v8GtjaHwnaRvcVY9nc6ym2pBmZ03CyFH0+wf8lnK1W5i4CXui
         SqbjaorUsi5PPli8QQXFKoxH8nXz07zR/7Yqrd4bwS9ynGtxxdVvNciw0f1LG2DNr9Ay
         vgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/FwuJRqdFexSkz3CLwdSj8g3jWrBg+FPxWYV0vQf47s=;
        b=Ew6LP8aL93KzZ2yiDitKdI0PDI3p7LgEL8sN9ZD7hlvoKxIFCGoWDg6DrAoc+h0tJM
         pDIulUB5kpPJ+TdOvTS+Zq7hUAB3twIFyXdvtsU6KSJZcfahVlnOxxGykQ72ZHKG8HzF
         ctl+XaCRgdevmuRXZ035b5vd4VrLjxRhVCdNlO8o9yaLTQP3w7MEo2g1eMCM0lE1yPeO
         lJ5eXGovFm86iOvHGmwcBU/OtYfvwgD6y5EI8X57DKuw4cLktT6zZB1xBK5Qop+JWR3N
         yLbLC3/VYlFWg7nHWNcYkvmFE8o9SdUK7/2/cBI3RU7TSjxc89WmQuYpepkCN6cy+kAR
         gCgA==
X-Gm-Message-State: AOAM533bU8z1ne2kknFwc2rhgEMpEYw/UEuDYnsf9wmvEYPF1xLaaN6l
        Ci8YGQ8piMuG3KFyDdNMEJ/2VhREZe0=
X-Google-Smtp-Source: ABdhPJzq10dgQCMZlH/lQzz1vijR45OkJTzEtyGh+wIkPvKxSGIg2Up+OW9JO7fbYmSwBJJCmSbsXQ==
X-Received: by 2002:a2e:8503:: with SMTP id j3mr1747328lji.272.1614848067978;
        Thu, 04 Mar 2021 00:54:27 -0800 (PST)
Received: from amb.lan (user-5-173-161-108.play-internet.pl. [5.173.161.108])
        by smtp.gmail.com with ESMTPSA id h19sm2249827ljk.86.2021.03.04.00.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 00:54:27 -0800 (PST)
From:   =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Subject: Re: xfs_repair doesn't handle: br_startoff 8388608 br_startblock -2
 br_blockcount 1 br_state 0 corruption
To:     Brian Foster <bfoster@redhat.com>,
        =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <744867e7-0457-46c6-f14b-8d7b91a61bbc@gmail.com>
 <20200715114058.GB51908@bfoster>
Message-ID: <b3d66e9b-2223-9413-7d66-d348b63660c5@gmail.com>
Date:   Thu, 4 Mar 2021 09:54:25 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20200715114058.GB51908@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: pl
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

W dniu 15.07.2020 o 13:40, Brian Foster pisze:
> On Wed, Jul 15, 2020 at 09:05:47AM +0200, Arkadiusz Miśkiewicz wrote:
>>
>> Hello.
>>
>> xfs_repair (from for-next from about 2-3 weeks ago) doesn't seem to
>> handle such kind of corruption. Repair (few times) finishes just fine
>> but it ends up again with such trace.
>>
> 
> Are you saying that xfs_repair eventually resolves the corruption but it
> takes multiple tries, and then the corruption reoccurs at runtime? Or
> that xfs_repair doesn't ever resolve the corruption?
> 
> Either way, what does xfs_repair report?

http://ixion.pld-linux.org/~arekm/xfs/xfs-repair.txt

This is repair that I did back in 2020 on medadumped image (linked below)


But I also did repair recently with xfsprogs 5.10.0

http://ixion.pld-linux.org/~arekm/xfs/xfs-repair-sdd1-20210228.txt

on actual fs and today it crashed:

[ 3580.278435] XFS (sdd1): xfs_dabuf_map: bno 8388608 dir: inode 36509341678
[ 3580.278436] XFS (sdd1): [00] br_startoff 8388608 br_startblock -2
br_blockcount 1 br_state 0
[ 3580.278452] XFS (sdd1): Internal error xfs_da_do_buf(1) at line 2557
of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_da_read_buf+0x7c/0x130
[xfs]

so 5.10.0 repair also doesn't fix it.

> 
>> Metadump is possible but problematic (will be huge).
>>
> 
> How huge? Will it compress?

53GB

http://ixion.pld-linux.org/~arekm/xfs/sdd1.metadump.gz


> 
>>
>> Jul  9 14:35:51 x kernel: XFS (sdd1): xfs_dabuf_map: bno 8388608 dir:
>> inode 21698340263
>> Jul  9 14:35:51 x kernel: XFS (sdd1): [00] br_startoff 8388608
>> br_startblock -2 br_blockcount 1 br_state 0
> 
> It looks like we found a hole at the leaf offset of a directory. We'd
> expect to find a leaf or node block there depending on the directory
> format (which appears to be node format based on the stack below) that
> contains hashval lookup information for the dir.
> 
> It's not clear how we'd get into this state. Had this system experienced
> any crash/recovery sequences or storage issues before the first
> occurrence?

Yes, not once, that's my "famous" server which saw a lot of fs damage.

Anyway would be nice if repair could fix such messed startblock because
kernel crashes on it so easily (or at least I assume it's because of that).

> 
> Brian
> 
>> Jul  9 14:35:51 x kernel: XFS (sdd1): Internal error xfs_da_do_buf(1) at
>> line 2557 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller
>> xfs_da_read_buf+0x6a/0x120 [xfs]
>> Jul  9 14:35:51 x kernel: CPU: 3 PID: 2928 Comm: cp Tainted: G
>>   E     5.0.0-1-03515-g3478588b5136 #10
>> Jul  9 14:35:51 x kernel: Hardware name: Supermicro X10DRi/X10DRi, BIOS
>> 3.0a 02/06/2018
>> Jul  9 14:35:51 x kernel: Call Trace:
>> Jul  9 14:35:51 x kernel:  dump_stack+0x5c/0x80
>> Jul  9 14:35:51 x kernel:  xfs_dabuf_map.constprop.0+0x1dc/0x390 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_da_read_buf+0x6a/0x120 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_da3_node_read+0x17/0xd0 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_da3_node_lookup_int+0x6c/0x370 [xfs]
>> Jul  9 14:35:51 x kernel:  ? kmem_cache_alloc+0x14e/0x1b0
>> Jul  9 14:35:51 x kernel:  xfs_dir2_node_lookup+0x4b/0x170 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_dir_lookup+0x1b5/0x1c0 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_lookup+0x57/0x120 [xfs]
>> Jul  9 14:35:51 x kernel:  xfs_vn_lookup+0x70/0xa0 [xfs]
>> Jul  9 14:35:51 x kernel:  __lookup_hash+0x6c/0xa0
>> Jul  9 14:35:51 x kernel:  ? _cond_resched+0x15/0x30
>> Jul  9 14:35:51 x kernel:  filename_create+0x91/0x160
>> Jul  9 14:35:51 x kernel:  do_linkat+0xa5/0x360
>> Jul  9 14:35:51 x kernel:  __x64_sys_linkat+0x21/0x30
>> Jul  9 14:35:51 x kernel:  do_syscall_64+0x55/0x100
>> Jul  9 14:35:51 x kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>>
>> Longer log:
>> http://ixion.pld-linux.org/~arekm/xfs-10.txt
>>
>>
>> -- 
>> Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
>>
> 

(resend because vger still blocks my primary maven domain and most
likely nothing has changed with postmasters attitude, didn't try... :/ )

-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
