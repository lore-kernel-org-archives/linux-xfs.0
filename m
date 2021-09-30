Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78CF9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 21:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F69761A0B
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 21:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348712AbhI3VMo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 17:12:44 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55648 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348668AbhI3VMn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 17:12:43 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 23B4B225F5;
        Thu, 30 Sep 2021 21:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633036259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hF1+AiAkOiwxS7GYNWFY7mrQc9otq7zFJhOd9XeK0UI=;
        b=sIdcON51m/C0XKXzQk94plviKDHXpAnnHT2MTXjurEoYOi3l+ppLUiESWHP63ASv+Drjhv
        GZDnNsiRgqttory5uKonjDBv2FEJTtxtvF0CeXxoJDeGq4cjgT7Kt2B3PIYKKwTixYWill
        6OaecVNdNO/PCqC1rANe2oxeWcK3P7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633036259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hF1+AiAkOiwxS7GYNWFY7mrQc9otq7zFJhOd9XeK0UI=;
        b=txE+MXYPMA8AKS3I5AOUXdzpLNFIZVkV8Yl9tZVtKfYJYsNd5lPsGBiORDVTGxhL+GM/I1
        PseKpwG+r+56bJCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E2F7713B63;
        Thu, 30 Sep 2021 21:10:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6nSdNuInVmFPQwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 30 Sep 2021 21:10:58 +0000
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
To:     Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz> <YVYGcLbu/aDKXkag@nuc10>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
Date:   Thu, 30 Sep 2021 23:10:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YVYGcLbu/aDKXkag@nuc10>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/21 8:48 PM, Rustam Kovhaev wrote:
> On Thu, Sep 30, 2021 at 10:13:40AM +0200, Vlastimil Babka wrote:
>>
>> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
>> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
>> two together last 5 years anyway.
> 
> +1 for adding Kconfig option, it seems like some things are not meant to
> be together.

But if we patch SLOB, we won't need it.

>> Maybe we could also just add the 4 bytes to all SLOB objects, declare
>> kfree() is always fine and be done with it. Yes, it will make SLOB footprint
>> somewhat less tiny, but even whan we added kmalloc power of two alignment
>> guarantees, the impact on SLOB was negligible.
> 
> I'll send a patch to add a 4-byte header for kmem_cache_alloc()
> allocations.

Thanks. Please report in the changelog slab usage from /proc/meminfo
before and after patch (at least a snapshot after a full boot).

>>> Thoughts?
>>>
>>> Cheers,
>>>
>>> Dave.
>>>
>>

