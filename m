Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93064C05027
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Feb 2023 05:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBJFAh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Feb 2023 00:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBJFAh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Feb 2023 00:00:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5FC2F783
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 21:00:35 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id k13so5398040plg.0
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 21:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hitAlID6562LDoIZ1YNYsn79YgxXdUizQO6bFZ5reA4=;
        b=hoteTnSk94Aoqe90vfEhTNq6/embqALzZxowgIGKoxZTBD7yppUftJnEml6HdiiI6Q
         A7ckauf2HASwPDr6zuN04ohQ/VyyjPI+th47gPYEKy5VPLj4IQKMHGZT3hKAW9jDQcpR
         syyYjq2ljxX3U1HdW64GYmqov+uoWwnH4hYBR1ESV7Cwr1Euw/HD76nuuPZ7V+FYmEX4
         QplfY8wmzFc3TzRdtICM1mJZIyjZhmgaxh7y6M7tKsrth5xBMPnfI+kQHd1f9B8tvdXp
         OGYLB6QHGRl0ioLbB5tDrSZPf091kSENLhhoG2bMFlrJ0ZURmCW7fNsA2kukfJMCyhdP
         ntwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hitAlID6562LDoIZ1YNYsn79YgxXdUizQO6bFZ5reA4=;
        b=RiRnYRt/VRnD/dCvKvI5msfc3O4/ViJ7EJn5SNZoJ9LtZKiX8SjjM/aKhR/6yIYg8f
         kVj9xg6/C2HpSHX/HMR4GZzN4MFpTF1S4i06k2yFY9fSMIsfg6zPwNhC6z4QPjUVjt+l
         Lf+5xf6n5Um/z72/pzZEaY/p+Ki1gurQgVGBh/FLfX+XHajkC1K4HAejaAFi9keuR3dw
         MU/84phKgJHqaoWxbpUtiDcMLqiuyhlteMoHckO3d7pCZEqBbbdFp80OprIA11HamRVS
         BGEgwPRUWrqP7ONPcNSJl459XDpZCmbtd55rE8O6IxXC8adAydI6IQO8p+LmFPm5uRNd
         QUrg==
X-Gm-Message-State: AO0yUKWL7PT2pRMiOtvp9/PhEipJPU65TrzUfap5peYKMTK2l4zHvzja
        bMZCHCKuL/Qz/LT62rYiDF1ujA==
X-Google-Smtp-Source: AK7set8D4XN8XtH68mATe5QPqoiLpl6Orhbn9nKhpF6Zn/mGfhzZikQSBVnY/PZxaqBqJmLCwSxJtw==
X-Received: by 2002:a17:902:db10:b0:199:2e77:fe16 with SMTP id m16-20020a170902db1000b001992e77fe16mr15922527plx.58.1676005235123;
        Thu, 09 Feb 2023 21:00:35 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709027e4b00b00189b2b8dbedsm2342218pln.228.2023.02.09.21.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 21:00:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pQLWR-00DVX8-7l; Fri, 10 Feb 2023 16:00:31 +1100
Date:   Fri, 10 Feb 2023 16:00:31 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 00/42] xfs: per-ag centric allocation alogrithms
Message-ID: <20230210050031.GJ360264@dread.disaster.area>
References: <20230209221825.3722244-1-david@fromorbit.com>
 <Y+W1hDsoWiaCVqlB@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+W1hDsoWiaCVqlB@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2023 at 07:09:56PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 10, 2023 at 09:17:43AM +1100, Dave Chinner wrote:
> > This series continues the work towards making shrinking a filesystem possible.
> > We need to be able to stop operations from taking place on AGs that need to be
> > removed by a shrink, so before shrink can be implemented we need to have the
> > infrastructure in place to prevent incursion into AGs that are going to be, or
> > are in the process, of being removed from active duty.
> 
> From a quick glance, it looks like all the random things I had comments
> about were fixed, so for patches 14, 20-23, 28, and 42:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> I'm leaving off patch #7 until tomorrow so that I can think about it
> with a non-tired brain.  I didn't see anything obviously wrong in the
> diff itself -- but I still need to adjust my mental model per what Dave
> said in his previously reply (active perag refs are for user-facing
> online operations, passive refs are for internal operations) and
> (re)examine how that relates to scrub and repair.
> 
> Mostly I tripped over "but repair needs to use passive references once
> the AG has had it's state changed to "offline" -- currently, repair uses
> the same perag reference that scrub _gets.  If scrub now gets an
> "active" reference and something needs repair, do we mark the AG offline
> and keep the active reference?  Or downgrade it to a passive reference?

So one of the things I was trying to explain and didn't do a very
good job of is that active references are references that prevent AG
operational state changes.

That is, if we want to take an AG offline, or just prevent new
allocations in an AG, we have to wait for all the active references
to drain before we can change the operational state.

This does not prevent an active reference from being taken when an
AG is offline - all an active reference in an offline state does is
prevent the AG from being put back online whilst that active
reference to the offline AG persists.

e.g. repair can drain all the active references on an online AG,
then mark it offline, then take a new active reference to pin the AG
in the offline state while it does the repair work on that AG.

Similarly, shrink can pin an AG in a "being shrunk" operational
state that allows inodes and extents to be freed, but no new
allocations to be made by draining the active references, changing
the state and then pinning by taking a new reference. Then the
shrink process can move all the user data and metadata out of the AG
without needing special tricks to avoid allocating in that AG. If it
fails to move everything or is aborted, it can drop it's active
reference and put the AG back online...

This means that the new allocation code that now takes active
references will be morphing further to be "grab active reference,
check AG opstate allows allocation, if not drop active reference and
skip AG".

Once an AG is ready to be removed, grabbing an active reference
will fail so at that point the AG is skipped without even getting to
state checks. Once all the passive references then drain, the perag
can be RCU freed.

> I've (tried to) design scrub & repair as if they were just another pile
> of higher level code that uses libxfs to manipulate metadata, just like
> fallocate and reflink and all those types of things.  But then, I was
> designing for a world where there's only one type of AG reference. :)

For the moment, everything in scrub/repair will work just fine with
passive references. It's only once we start using AG opstate to
control allocator, caching and scanning behaviour that they might
want to start using active references...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
