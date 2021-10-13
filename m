Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D736C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 07:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40DC461074
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 07:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbhJMHkg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 03:40:36 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:52548 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238565AbhJMHkg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 03:40:36 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B9FD9222C0;
        Wed, 13 Oct 2021 07:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634110711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2/5m4EyNl7HialOD6IWobME8joFWhALPD0XeJqljVQ=;
        b=d/Y5iKa4s2ThoqvqoYb8etqWtevCqOBHYZ1DF1p+oWm4BNq5proRG8XQwacGegyAqB75Ek
        j8WQTrGXsr/qzoT8mGcjl1Hdzk1hMBiQZTncNkiAKcJfCIdLsoQj+f5aCOhretdrLKNNpA
        cIyKJdpDYlB65nkVFopzCYv4umGIE0Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634110711;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m2/5m4EyNl7HialOD6IWobME8joFWhALPD0XeJqljVQ=;
        b=fbLc4QJpjAioNpDXuQMoQ2cfpcSZhuuFzmAs/0lsu085RIwJJatBvU7POTVHCmbF8Sk8BH
        TogvOXMpdLYrLMDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 858EB13CBE;
        Wed, 13 Oct 2021 07:38:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +E26H/eMZmHgeAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 13 Oct 2021 07:38:31 +0000
Message-ID: <3928ef69-eaac-241c-eb32-d2dd2eab9384@suse.cz>
Date:   Wed, 13 Oct 2021 09:38:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     David Rientjes <rientjes@google.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz> <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz> <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
 <20211012204320.GP24307@magnolia> <20211012204345.GQ24307@magnolia>
 <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
 <20211012232255.GS24307@magnolia>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211012232255.GS24307@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/13/21 01:22, Darrick J. Wong wrote:
> On Tue, Oct 12, 2021 at 11:32:25PM +0200, Vlastimil Babka wrote:
>> On 10/12/2021 10:43 PM, Darrick J. Wong wrote:
>> > On Tue, Oct 12, 2021 at 01:43:20PM -0700, Darrick J. Wong wrote:
>> >> On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
>> >>
>> >> I audited the entire xfs (kernel) codebase and didn't find any other
>> >> usage errors.  Thanks for the patch; I'll apply it to for-next.
>> 
>> Which patch, the one that started this thread and uses kmem_cache_free() instead
>> of kfree()? I thought we said it's not the best way?
> 
> It's probably better to fix slob to be able to tell that a kmem_free'd
> object actually belongs to a cache and should get freed that way, just
> like its larger sl[ua]b cousins.

Agreed. Rustam, do you still plan to do that?

> However, even if that does come to pass, anybody /else/ who wants to
> start(?) using XFS on a SLOB system will need this patch to fix the
> minor papercut.  Now that I've checked the rest of the codebase, I don't
> find it reasonable to make XFS mutually exclusive with SLOB over two
> instances of slab cache misuse.  Hence the RVB. :)

Ok. I was just wondering because Dave's first reply was that actually you'll
need to expand the use of kfree() instead of kmem_cache_free().

