Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1EDC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A6B61056
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 16:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238169AbhJMQ7M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbhJMQ6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 12:58:51 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89A7C06176F;
        Wed, 13 Oct 2021 09:56:43 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so2738975pjb.4;
        Wed, 13 Oct 2021 09:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8cbGKp/2SKCzI/7d16DE4Ims0SpFBLwu8hl8mlZLlOo=;
        b=oFOn0Tq6sOCCa7oR6RuKde4xQw/hwbwVhtwaptJIyoz2QA0GkZ9SKG3SAlsSoD+BMa
         gEVYT4q9hXHpebwTNziXfq1juVpttO+VHUMgvGPN4wfIIEFWO6Oshc+V0lsU2MEnKRwk
         gd6zgi2n9+xCksbFjiA2pyYJLXIYgmcK5Y87Fj/1PfYaFN8i1pnw8hLDQJCyPxu3cYqd
         jnm5ImJZzukIJcSrdtu0tw7QzD0ocFZ38OzE9YX6s9whTQ31snbu/eoH3Gfd8ShIGRnN
         0//WyRX584GCgmRxwVTl8z6kqvkPzMFQaHq33lBjtLn9BlUwQGkfvv0zZ8Hvzb7voIds
         nwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8cbGKp/2SKCzI/7d16DE4Ims0SpFBLwu8hl8mlZLlOo=;
        b=c3OttgWwuiCVza8WbYrWmuOL6SDQ6ugJowdBcsyfZOd/8qI9GU0jIeKrsKuObMlYg6
         3Dd3Q545+8zq+5GRX5fhB0fveT0aRW8uYgFMeNNqhqaGpyRvqPVCJrcszlXZprFip/0C
         hEeKuFBtCOFhg1eXvGcu2fBrO1DiQgmnLrK9KwfSHPkyQQMPRkid/qERzbF11j77uf4B
         YJFzK0RRPxRG74h741MkZiQeFIlBhYAHdlKJRSJuLd1ZAE5yySYZhNPa0oaO1yfaRSRY
         0rOXXNCzLvWIRPUuidWHgmjUwyrNTDEkrVzctoGGO6cfkFcEHz4T9XTo47/WkQmKKKj/
         9cUw==
X-Gm-Message-State: AOAM532EBuE/gGjjAGIHFvretA8UxctPI6agNVZR2mwGF0kWmN5JouP5
        xzMc8MGuwWiwqO187lD0+Qg=
X-Google-Smtp-Source: ABdhPJyPTTN4ICW/JsbxaYnIm7r4sYNqOFBOw14o7XVRCfZKdqH5y/kW1VzGq0CitYgns0ZYFAz8Xw==
X-Received: by 2002:a17:90b:17c9:: with SMTP id me9mr404934pjb.197.1634144203230;
        Wed, 13 Oct 2021 09:56:43 -0700 (PDT)
Received: from nuc10 (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id x13sm84916pge.37.2021.10.13.09.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:56:42 -0700 (PDT)
Date:   Wed, 13 Oct 2021 09:56:41 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <YWcPyYk0Rlyvl9a9@nuc10>
References: <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
 <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
 <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
 <20211012204320.GP24307@magnolia>
 <20211012204345.GQ24307@magnolia>
 <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
 <20211012232255.GS24307@magnolia>
 <3928ef69-eaac-241c-eb32-d2dd2eab9384@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3928ef69-eaac-241c-eb32-d2dd2eab9384@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 09:38:31AM +0200, Vlastimil Babka wrote:
> On 10/13/21 01:22, Darrick J. Wong wrote:
> > On Tue, Oct 12, 2021 at 11:32:25PM +0200, Vlastimil Babka wrote:
> >> On 10/12/2021 10:43 PM, Darrick J. Wong wrote:
> >> > On Tue, Oct 12, 2021 at 01:43:20PM -0700, Darrick J. Wong wrote:
> >> >> On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
> >> >>
> >> >> I audited the entire xfs (kernel) codebase and didn't find any other
> >> >> usage errors.  Thanks for the patch; I'll apply it to for-next.
> >> 
> >> Which patch, the one that started this thread and uses kmem_cache_free() instead
> >> of kfree()? I thought we said it's not the best way?
> > 
> > It's probably better to fix slob to be able to tell that a kmem_free'd
> > object actually belongs to a cache and should get freed that way, just
> > like its larger sl[ua]b cousins.
> 
> Agreed. Rustam, do you still plan to do that?

Yes, I do, thank you.

> 
> > However, even if that does come to pass, anybody /else/ who wants to
> > start(?) using XFS on a SLOB system will need this patch to fix the
> > minor papercut.  Now that I've checked the rest of the codebase, I don't
> > find it reasonable to make XFS mutually exclusive with SLOB over two
> > instances of slab cache misuse.  Hence the RVB. :)
> 
> Ok. I was just wondering because Dave's first reply was that actually you'll
> need to expand the use of kfree() instead of kmem_cache_free().
> 
