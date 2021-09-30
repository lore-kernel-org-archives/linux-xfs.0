Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B075CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 18:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A0B161209
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Sep 2021 18:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344778AbhI3SuC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344777AbhI3SuC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 14:50:02 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B45C06176A;
        Thu, 30 Sep 2021 11:48:19 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m21so7132806pgu.13;
        Thu, 30 Sep 2021 11:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJFF8/1GlPuEUwN0VlLL/s/A+hGOPfTSgKTAVipRj/o=;
        b=QyFfNne9PMK7JPGenPXu/J4Ppw33qKynidqLdq9XPGDpBjfCxfcSeRZRUrBq0roF+A
         cCqEyUFm6FvgCUolg7SbTvYmHL25eZINm68Ya7z+PgS458fAl2U4qnoN+YWS4Cgn6Rpc
         yZxfoGN4go2HiDKvvjExJIiVFOdZOtImg0Z3gLUCE6XZZRnhOUePMlGIOP4UMYicgT+t
         Pf/kHavzNlZG3IFIzaRhqyscXxsAPs6iyNOAQxfoqiDmiGPgaQ9PaD73sMN5CXpeFWUp
         yFPVF2t+DtW0GhIVgIFXqu3J4MLtgfrzj0WjKfqGbEOwqeU5jpvqNt8HfodWIuLa3EbM
         GWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJFF8/1GlPuEUwN0VlLL/s/A+hGOPfTSgKTAVipRj/o=;
        b=7+zfrUm6dnht482iesXhBdTm1cYUiTIRDoygBoL1vTY/Ns9AyUL9XAtUyvOnm1EPN4
         8C1Xgfin9uKAgCin+CskX57v2pWqhxYM+vSbELbbn/XapuKl2/hJTRiGdgkvgQX+LjZH
         K7LjidGiFFaZBqN/2AqwJAXVklZOC8MaZnnFpz0lt9kSSJo66adOESDT6q9lpmfumnSj
         cl9MBeWF+PQ6rucGTSu2S7HAX2Uhm2b7hCpQxR/ydFcqduzUCUM5LEknJcMrgSOb1zGD
         0Tv6HFoaRQjMvuRrmizSgjbqpYiW+KgLdtrSQybppa9yiKUmWIxN+AoWjdEt3mRLGJez
         DjPQ==
X-Gm-Message-State: AOAM5333sqFM7WdK5u8Hq0lZoFJbKil/kOjMfVFnMkz7ecYSvLWCzlJR
        kluBdb/TSra/fiPXusZH0SK5C0kq30Fke2jo
X-Google-Smtp-Source: ABdhPJzkJgaUuPXajizt5X6cfj7CNftU7P/7jMjamgEoLqx3JTN3GqJ3g243nMinTfvVwOBY6ulkVw==
X-Received: by 2002:a63:af4b:: with SMTP id s11mr6208016pgo.185.1633027698467;
        Thu, 30 Sep 2021 11:48:18 -0700 (PDT)
Received: from nuc10 (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id d24sm3652910pfn.62.2021.09.30.11.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 11:48:18 -0700 (PDT)
Date:   Thu, 30 Sep 2021 11:48:16 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Dave Chinner <david@fromorbit.com>, djwong@kernel.org,
        linux-xfs@vger.kernel.org, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <YVYGcLbu/aDKXkag@nuc10>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 30, 2021 at 10:13:40AM +0200, Vlastimil Babka wrote:
> On 9/30/21 06:42, Dave Chinner wrote:
> > On Wed, Sep 29, 2021 at 02:23:47PM -0700, Rustam Kovhaev wrote:
> >> For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
> >> and it puts the size of the allocated blocks in that header.
> >> Blocks allocated with kmem_cache_alloc() allocations do not have that
> >> header.
> >> 
> >> SLOB explodes when you allocate memory with kmem_cache_alloc() and then
> >> try to free it with kfree() instead of kmem_cache_free().
> >> SLOB will assume that there is a header when there is none, read some
> >> garbage to size variable and corrupt the adjacent objects, which
> >> eventually leads to hang or panic.
> >> 
> >> Let's make XFS work with SLOB by using proper free function.
> >> 
> >> Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
> >> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> > 
> > IOWs, XFS has been broken on SLOB for over 5 years and nobody
> > anywhere has noticed.
> > 
> > And we've just had a discussion where the very best solution was to
> > use kfree() on kmem_cache_alloc() objects so we didn't ahve to spend
> > CPU doing global type table lookups or use an extra 8 bytes of
> > memory per object to track the slab cache just so we could call
> > kmem_cache_free() with the correct slab cache.
> > 
> > But, of course, SLOB doesn't allow this and I was really tempted to
> > solve that by adding a Kconfig "depends on SLAB|SLUB" option so that
> > we don't have to care about SLOB not working.
> > 
> > However, as it turns out that XFS on SLOB has already been broken
> > for so long, maybe we should just not care about SLOB code and
> > seriously consider just adding a specific dependency on SLAB|SLUB...
> 
> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
> two together last 5 years anyway.

+1 for adding Kconfig option, it seems like some things are not meant to
be together.

> Maybe we could also just add the 4 bytes to all SLOB objects, declare
> kfree() is always fine and be done with it. Yes, it will make SLOB footprint
> somewhat less tiny, but even whan we added kmalloc power of two alignment
> guarantees, the impact on SLOB was negligible.

I'll send a patch to add a 4-byte header for kmem_cache_alloc()
allocations.

> > Thoughts?
> > 
> > Cheers,
> > 
> > Dave.
> > 
> 
