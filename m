Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A2FEEB59A
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Sep 2023 07:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbjIMHBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 03:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbjIMHBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2023 03:01:10 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED8E173E
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 00:01:06 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-401f68602a8so70096515e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2023 00:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694588465; x=1695193265; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxEwSrADigL55KUK+kn7a1SeYT+9CqL3SU8EoT51CDk=;
        b=Wua8OQ8hb5BPxMUekouQOb5BZwOj13VSbftvNQwBa6hltLVm0VPPzkksJzVh2Hi+B7
         dP8/NLX+E0uk4CTZ7oHsBnmjEgKaiJYuYywlMgOXdXonJ1uvkj//etMX19k7DIAVpQHf
         DwUWHXJ9m+uJsQx2BhhjcRbIrtXdgLFWWqH9aGysbNjadt4kQsUMZk/NPwRV4+QPrK5p
         Z2Hop3oO80VuTWlnxHOLWxAvamv4hqsnkUuHARirTPOFDXf40XqfsnKZ2HMbfkgWRngr
         8f4wZ3jnk4Ol2mMTD/vaq/OlBcTC3JwJr0vW9NDC6hBN7QsLa++3fWXScgroeKNHaS2v
         oC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694588465; x=1695193265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxEwSrADigL55KUK+kn7a1SeYT+9CqL3SU8EoT51CDk=;
        b=KAA3PwJgwHh05vptfXt2/Zg7Fd4FivVfJFbY5fH15V9Wy6M1baQ38UJ2ihh3Ms4dRm
         3epDGdk4X5VkhpVCTkDvGctEh6tNzj/6kQ4cuXTKxMqeB6cJGl7q6ytIqAR573P6ESKq
         aHdNABstBkAiDhjccF6+cIOt4IhoTRXgkWBOdsdj8Rv5UA5dNOnGkZpqxuNA8B5kJoms
         k23G/8JWM6Ey2al1DkVEpKQ5C7WjpXEaJN07TsosEAe68yjPnGjzgNB69+i3/FuZd2H5
         uTiPJjrO6yumOt+ADWSls21GVbMKhR1iaDULDlBY1JvWSxoEupCOj4OJdDRdt/gY51rC
         6T0Q==
X-Gm-Message-State: AOJu0Yw2FnDIPrRB56HUlDROtjFcqjNarw5sra1CmY9DMfcwhZEAs/IS
        z0mPlpFNbVrDi8NWHrX/jooneQ==
X-Google-Smtp-Source: AGHT+IGICr3IH8Jp41V2bYK9Ff2nTqLZswVkjLZvdCTwqajKf/5QT/EFKcb52xlWuAdRsrkmSCW0Rg==
X-Received: by 2002:adf:ea85:0:b0:319:7c1f:8dae with SMTP id s5-20020adfea85000000b003197c1f8daemr1473001wrm.3.1694588465003;
        Wed, 13 Sep 2023 00:01:05 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g8-20020a5d4888000000b0031912c0ffebsm14594274wrq.23.2023.09.13.00.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 00:01:04 -0700 (PDT)
Date:   Wed, 13 Sep 2023 10:01:01 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Alex Elder <elder@ieee.org>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: delete some dead code in xfile_create()
Message-ID: <3c63cc50-c6a8-4bba-87d8-6556ebe1905e@kadam.mountain>
References: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
 <20230912153824.GB28186@frogsfrogsfrogs>
 <e575bbf3-f0ba-ec39-03c5-9165678d1fc7@ieee.org>
 <20230912162315.GC28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912162315.GC28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 09:23:15AM -0700, Darrick J. Wong wrote:
> On Tue, Sep 12, 2023 at 10:41:53AM -0500, Alex Elder wrote:
> > On 9/12/23 10:38 AM, Darrick J. Wong wrote:
> > > On Tue, Sep 12, 2023 at 06:18:45PM +0300, Dan Carpenter wrote:
> > > > The shmem_file_setup() function can't return NULL so there is no need
> > > > to check and doing so is a bit confusing.
> > > > 
> > > > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > > ---
> > > > No fixes tag because this is not a bug, just some confusing code.
> > > 
> > > Please don't re-send patches that have already been presented here.
> > > https://lore.kernel.org/linux-xfs/20230824161428.GO11263@frogsfrogsfrogs/
> > 
> > FWIW, I side with Dan's argument.  shmem_file_setup() *does not*
> > return NULL.  If it ever *did* return NULL, it would be up to the
> > person who makes that happen to change all callers to check for NULL.
> 
> And as I asked three weeks ago, what's the harm in checking for a NULL
> pointer here?  The kerneldoc for shmem_file_setup doesn't explicitly
> exclude a null return.  True, it doesn't mention the possibility of
> ERR_PTR returns either, but that's an accepted practice for pointer
> returns.

Mixing up error pointers and NULL checking is a common bug.  We never
hit this in run time these days because we've been using static analysis
to prevent it for over a decade.

If you look at the code we used to ship in the 2006 era it's absolutely
amazing (bad).  Static analysis isn't perfect for everything but there
are some kinds of simple bugs where we've almost eliminated them
completely.

> 
> For a call outside of the xfs subsystem, I think it's prudent to have
> stronger return value checking.  Yes, someone changing the interface
> would have to add a null check to all the callsites, but (a) it's benign
> to guard against a behavior change in another module and (b) people miss
> things all the time.
> 
> > The current code *suggests* that it could return NULL, which
> > is not correct.
> 
> Huh?
> 
> Are you talking about this stupid behavior of bots where they decide
> what a function returns based on the callsites in lieu of analyzing the
> actual implementation code?

In this case Smatch is looking at the implementation.

$ smdb return_states shmem_file_setup | grep INTER
mm/shmem.c | shmem_file_setup | 2229 |  4096-ptr_max|        INTERNAL | -1 |                      | struct file*(*)(char*, llong, ulong) |
mm/shmem.c | shmem_file_setup | 2230 |  (-4095)-(-1)|        INTERNAL | -1 |                      | struct file*(*)(char*, llong, ulong) |
mm/shmem.c | shmem_file_setup | 2231 | (-4095)-(-4),(-2)-(-1)|        INTERNAL | -1 |                      | struct file*(*)(char*, llong, ulong) |
mm/shmem.c | shmem_file_setup | 2232 |         (-22)|        INTERNAL | -1 |                      | struct file*(*)(char*, llong, ulong) |
mm/shmem.c | shmem_file_setup | 2233 |         (-12)|        INTERNAL | -1 |                      | struct file*(*)(char*, llong, ulong) |

I also manually reviewed the function implementation to verify.

> 
> I don't feel like getting harassed by bots when someone /does/
> accidentally change the implementation to return NULL, and now one of
> the other build/test/syz bots starts crashing in xfile_create.

If someone changes it to return NULL then there are a few things to
note.

1) That person is going to have change all the call sites.
2) Normally when a function returns both error pointers and NULL then
   the NULL is success. So this code doesn't handle the normal case
   correctly because it assumes NULL is an error.
3) Static checkers will complain if the call sites are not updated.  Try
   to find any IS_ERR vs NULL bugs in the past year that were found at
   run time instead of through static analysis.  Occasionally syzbot
   will hit them before me but it's rare.  I don't even remember the
   last time where this sort of bug managed to reach actual users.

> 
> Of course all that has bought me is ... more f*** bot harassment.
> 
> I'm BURNED OUT, give me a fucking break!

Fair enough.  I should have seen Yang Yingliang's email.

regards,
dan carpenter
