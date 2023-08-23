Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB52EE49AD
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 01:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjHWBoy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 21:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbjHWBoy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Aug 2023 21:44:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467FDE4B
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 18:44:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68a3082c771so2307954b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Aug 2023 18:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692755091; x=1693359891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wunJnKtF/yKa4KQLXItEcDANGdOlvDN+J91XoYYV78=;
        b=yx/ysS+epJ2T1gKjbyDzj8DWHd87hZpV2us3wCRHNbZFLp5TtceHXRSWEAr80jqVtz
         ydQorDgxGMhTkxX9jfilEQrqBbakPtqvfnxI3mA6iJrqQs5nGn6uW8aQqLCtyxtUveGB
         e4sp1M32NblhC+Xn4ZNRXvWH9mrXOf/3fAM7zlCk20sxlrxeP3sTOauJQx340nk2lRDP
         wKO4AtCBgtLpF+9Z41qgxNhBSRl+RxdmEuFlWcPaqA/LN9Af8fAGfCtfwwMbLj42cyO2
         odaGif5lut/dfP40QB5SyFxOok/tqjwCfNcry7iJChe4tGIfVWrN85JxIGv71wOvEkKg
         RzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692755091; x=1693359891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wunJnKtF/yKa4KQLXItEcDANGdOlvDN+J91XoYYV78=;
        b=kANpQ7a0n98b/3gW53x8P1xsxeWYyfSFd+5VS0voCXjB5CdP0fusFI36ytFRSxUohr
         rbSrgGF1pUr/GEr0jsxyo8aP4pNe/GC6DEEZ6j1Z2buPk/HuU7Ab2wS1Tf+khttpXStg
         8zm/cX8Kgy2puAyuY01iYLaCumjT90MVsgW7kh4/jehO/qkmcEJR6Hmuvehd+8HB8XdL
         7Or1AV2dI5WsrYUEC5+qC8110ttce0UNhn1j1et6QnfZViddyOgu8Jb+p1IBD6Ufx7Yx
         pQELSIGWLYHP3Kj9gFpmQ4EG7raFyMxYaUXKxUb7U69/zLJUsRqvKyfciopfb0MsLjYr
         3v7A==
X-Gm-Message-State: AOJu0Yx4v0mRB1b4uWIkBlNn2xaCk4GlRleP0RldxAgkEkTuliwqdcGG
        u56K8+Y1w6b0+H7H2Z8eaAon6zIyuDnIltb55sI=
X-Google-Smtp-Source: AGHT+IH2OsfpjVSCScuKUXjaJ8C6rmEfGaVBtIXtRh6+A8UbXkdJErlF6kKBsfZrNIn9+DK/Die5iA==
X-Received: by 2002:a05:6a00:2290:b0:68a:5651:b53e with SMTP id f16-20020a056a00229000b0068a5651b53emr9176049pfe.10.1692755090558;
        Tue, 22 Aug 2023 18:44:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id m5-20020aa78a05000000b0068a53ac9d46sm3736263pfa.100.2023.08.22.18.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 18:44:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qYcvP-005Frs-0B;
        Wed, 23 Aug 2023 11:44:47 +1000
Date:   Wed, 23 Aug 2023 11:44:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     tglx@linutronix.de, peterz@infradead.org,
        xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] xfs: fix per-cpu CIL structure aggregation racing
 with dying cpus
Message-ID: <ZOVkjxWZq0YmjrJu@dread.disaster.area>
References: <20230804223854.GL11352@frogsfrogsfrogs>
 <ZOLzgBOuyWHapOyZ@dread.disaster.area>
 <20230822183016.GC11263@frogsfrogsfrogs>
 <ZOVEkMffTLXBJfmn@dread.disaster.area>
 <20230823012011.GE11286@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823012011.GE11286@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 22, 2023 at 06:20:11PM -0700, Darrick J. Wong wrote:
> On Wed, Aug 23, 2023 at 09:28:16AM +1000, Dave Chinner wrote:
> > On Tue, Aug 22, 2023 at 11:30:16AM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 21, 2023 at 03:17:52PM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 04, 2023 at 03:38:54PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > In commit 7c8ade2121200 ("xfs: implement percpu cil space used
> > > > > calculation"), the XFS committed (log) item list code was converted to
> > > > > use per-cpu lists and space tracking to reduce cpu contention when
> > > > > multiple threads are modifying different parts of the filesystem and
> > > > > hence end up contending on the log structures during transaction commit.
> > > > > Each CPU tracks its own commit items and space usage, and these do not
> > > > > have to be merged into the main CIL until either someone wants to push
> > > > > the CIL items, or we run over a soft threshold and switch to slower (but
> > > > > more accurate) accounting with atomics.
> > > > > 
> > > > > Unfortunately, the for_each_cpu iteration suffers from the same race
> > > > > with cpu dying problem that was identified in commit 8b57b11cca88f
> > > > > ("pcpcntrs: fix dying cpu summation race") -- CPUs are removed from
> > > > > cpu_online_mask before the CPUHP_XFS_DEAD callback gets called.  As a
> > > > > result, both CIL percpu structure aggregation functions fail to collect
> > > > > the items and accounted space usage at the correct point in time.
> > > > > 
> > > > > If we're lucky, the items that are collected from the online cpus exceed
> > > > > the space given to those cpus, and the log immediately shuts down in
> > > > > xlog_cil_insert_items due to the (apparent) log reservation overrun.
> > > > > This happens periodically with generic/650, which exercises cpu hotplug
> > > > > vs. the filesystem code.
> > > > > 
> > > > > Applying the same sort of fix from 8b57b11cca88f to the CIL code seems
> > > > > to make the generic/650 problem go away, but I've been told that tglx
> > > > > was not happy when he saw:
> > > > > 
> > > > > "...the only thing we actually need to care about is that
> > > > > percpu_counter_sum() iterates dying CPUs. That's trivial to do, and when
> > > > > there are no CPUs dying, it has no addition overhead except for a
> > > > > cpumask_or() operation."
> > > > > 
> > > > > I have no idea what the /correct/ solution is, but I've been holding on
> > > > > to this patch for 3 months.  In that time, 8b57b11cca88 hasn't been
> > > > > reverted and cpu_dying_mask hasn't been removed, so I'm sending this and
> > > > > we'll see what happens.
> > > > > 
> > > > > So, how /do/ we perform periodic aggregation of per-cpu data safely?
> > > > > Move the xlog_cil_pcp_dead call to the dying section, where at least the
> > > > > other cpus will all be stopped?  And have it dump its items into any
> > > > > online cpu's data structure?
> > > > 
> > > > I suspect that we have to stop using for_each_*cpu() and hotplug
> > > > notifiers altogether for this code.
> > > > 
> > > > That is, we simply create our own bitmap for nr_possible_cpus in the
> > > > CIL checkpoint context we allocate for each checkpoint (i.e. the
> > > > struct xfs_cil_ctx). When we store something on that CPU for that
> > > > CIL context, we set the corresponding bit for that CPU. Then when we
> > > > are aggregating the checkpoint, we simply walk all the cpus with the
> > > > "has items" bit set and grab everything.
> > > > 
> > > > This gets rid of the need for hotplug notifiers completely - we just
> > > > don't care if the CPU is online or offline when we sweep the CIL
> > > > context for items at push time - if the bit is set then there's
> > > > stuff to sweep...
> > > 
> > > Oooh, good idea.  Something like this, then?  Lightly tested via
> > > generic/650 for five minutes...
> > 
> > Not quite what I was saying - you put the cpu mask in the struct
> > xfs_cil, which means it can potentially be accessed from both commit
> > and aggregation at the same time for different checkpoints.
> > 
> > What I was suggesting is that it gets placed in the struct
> > xfs_cil_ctx which is guaranteed to be private to
> 
> private to...?

Sorry, I thought I removed that chunk from my reply - ignore it.

....
> > .....
> > 
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 09638e8fb4ee..ef7775657ce3 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -2313,7 +2313,6 @@ xfs_cpu_dead(
> > >  	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
> > >  		spin_unlock(&xfs_mount_list_lock);
> > >  		xfs_inodegc_cpu_dead(mp, cpu);
> > > -		xlog_cil_pcp_dead(mp->m_log, cpu);
> > >  		spin_lock(&xfs_mount_list_lock);
> > >  	}
> > >  	spin_unlock(&xfs_mount_list_lock);
> > 
> > I wonder if we can do something similar for the inodegc code, and
> > once again get rid of the need for hotpulg notifiers in XFS?
> 
> I would imagine so, if you don't mind bloating up xfs_mount.

The xfs_mount is already huge... :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
