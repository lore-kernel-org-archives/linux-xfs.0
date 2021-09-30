Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DAEC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80D0A615E0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 08:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348889AbhI3IPY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:15:24 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39170 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348866AbhI3IPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 04:15:24 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 230E522604;
        Thu, 30 Sep 2021 08:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632989621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5Thg/LdS+f/OKiGebbx9x8XYiOc+eM0qG2VzPO3ksA=;
        b=hrvXjqxldUZaVP6V9n8Ne2cJpHPgc53PR5EUoYb3IoavUPBpwGK1vQbl0IQBFJIr7CElyr
        l00SIPUnq4rWthUOhUoLFBrLbL/49ZhI+w852lCVVzPLkk+6cE9mj/GBxlRByxn3BOPKdr
        yUO6/O4Zqyst7gHhae3vlaEhx4HSIFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632989621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5Thg/LdS+f/OKiGebbx9x8XYiOc+eM0qG2VzPO3ksA=;
        b=qW7AxlIsdvqS3QXhaO/Apmfy+pkRmM9UlKBjSJ4/soig/IGHz6HanIdehExw0AJRZarJLz
        V78KLOOgcJSib3Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E5BB0140CC;
        Thu, 30 Sep 2021 08:13:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HRZfN7RxVWEdJwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 30 Sep 2021 08:13:40 +0000
Message-ID: <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
Date:   Thu, 30 Sep 2021 10:13:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@ZenIV.linux.org.uk>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
In-Reply-To: <20210930044202.GP2361455@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/30/21 06:42, Dave Chinner wrote:
> On Wed, Sep 29, 2021 at 02:23:47PM -0700, Rustam Kovhaev wrote:
>> For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
>> and it puts the size of the allocated blocks in that header.
>> Blocks allocated with kmem_cache_alloc() allocations do not have that
>> header.
>> 
>> SLOB explodes when you allocate memory with kmem_cache_alloc() and then
>> try to free it with kfree() instead of kmem_cache_free().
>> SLOB will assume that there is a header when there is none, read some
>> garbage to size variable and corrupt the adjacent objects, which
>> eventually leads to hang or panic.
>> 
>> Let's make XFS work with SLOB by using proper free function.
>> 
>> Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
>> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> 
> IOWs, XFS has been broken on SLOB for over 5 years and nobody
> anywhere has noticed.
> 
> And we've just had a discussion where the very best solution was to
> use kfree() on kmem_cache_alloc() objects so we didn't ahve to spend
> CPU doing global type table lookups or use an extra 8 bytes of
> memory per object to track the slab cache just so we could call
> kmem_cache_free() with the correct slab cache.
> 
> But, of course, SLOB doesn't allow this and I was really tempted to
> solve that by adding a Kconfig "depends on SLAB|SLUB" option so that
> we don't have to care about SLOB not working.
> 
> However, as it turns out that XFS on SLOB has already been broken
> for so long, maybe we should just not care about SLOB code and
> seriously consider just adding a specific dependency on SLAB|SLUB...

I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
two together last 5 years anyway.
Maybe we could also just add the 4 bytes to all SLOB objects, declare
kfree() is always fine and be done with it. Yes, it will make SLOB footprint
somewhat less tiny, but even whan we added kmalloc power of two alignment
guarantees, the impact on SLOB was negligible.

> Thoughts?
> 
> Cheers,
> 
> Dave.
> 

