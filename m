Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C12C001DC
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 06:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjGSGZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jul 2023 02:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbjGSGZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2023 02:25:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79731BFF
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 23:25:05 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-666eef03ebdso4352218b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2023 23:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689747905; x=1692339905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hP25Soed1QEFQaJ+ZzPLh9PaqofcnmWmosfc3ZNfSCg=;
        b=KbgqbmeHGIFvP3tzeKNjIvVZj9zCB8bBt1AqxyHymAssvSVXK6b4XkVJrStEXFSv5B
         yNder67Z4QSB+OxeYwrjrHNkWk1wrieFoV9jYc4tYRcbde1fU9DGg/mO557Dpds3Di0H
         C+jFj8mssWiCkwwcQ/nAxMbd6CZrXyj+PeX2+sFuMtKRMewAMPmbxKTvcf0miMK/TbiC
         1V7TYZPIKsykSgJdjB/bvl069tt49nCneojDJDvEpHU/7O3hI1iei81cN7PgYDigkKs6
         dsevr5B83nphcF11rRMniuNVB15UuxV0R5frd+VFYi7EZ6szj0kbX0SVjlWK8iCN7ypr
         gB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689747905; x=1692339905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hP25Soed1QEFQaJ+ZzPLh9PaqofcnmWmosfc3ZNfSCg=;
        b=fEBeXV8al/DeRUWYdJykb1EVKyF6DANEYyOYX9eKvPY6DH/Xh0tVTBRRVb3Oq2tU2i
         NOq3u1DRjAsFrhkJtTWgyPvxCleYZIT07tzOZl9gSlgWazh2znswFHVWDkGcaVRfZvO7
         AK+Qoj6IQTLw4vJiQf6ZOJ2QrxqhU1jIiOn5rfC46GPNbAMumwhCf8PmHu0GUuPVAV+m
         1x/WtNSuoWTXBZ7Fuofgw60A6QbYNK/PCCC/YcCZ0VKOv78XRPynxSu5Y+IcoUy+ebqY
         xcb3Fx4sMAwVwSv8Mk2uVgXXQ+y4ey0LpVNezJAGT9GXHqmL7FrG7KnrX7GZbY3/N91n
         YLEQ==
X-Gm-Message-State: ABy/qLaf9jgBt/hraCHSHt3x6GJfj+vXaJb4IEbO2jrrnsX9IYsMPDet
        KO+yyod0O1Myv6DlRxsK7KgmbQ==
X-Google-Smtp-Source: APBJJlHJcLqc+SwKJm7Fy8MEucoXoNKi8EEAlVmuwpZ8oG9CtRJgoYIp24Qtdc4iVvIA+axkDhULoA==
X-Received: by 2002:a05:6a20:8e1f:b0:133:6b64:c92 with SMTP id y31-20020a056a208e1f00b001336b640c92mr18056560pzj.44.1689747905057;
        Tue, 18 Jul 2023 23:25:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id d1-20020aa78e41000000b006826df9e295sm2491398pfr.113.2023.07.18.23.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 23:25:04 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qM0cP-007rQK-1n;
        Wed, 19 Jul 2023 16:25:01 +1000
Date:   Wed, 19 Jul 2023 16:25:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
References: <1DB9F8BB-4A7C-4422-B447-90A08E310E17@oracle.com>
 <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719014413.GC11352@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 18, 2023 at 06:44:13PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 19, 2023 at 10:11:03AM +1000, Dave Chinner wrote:
> > On Tue, Jul 18, 2023 at 10:57:38PM +0000, Wengang Wang wrote:
> > > Hi,
> > > 
> > > I have a XFS metadump (was running with 4.14.35 plussing some back ported patches),
> > > mounting it (log recover) hang at log space reservation. There is 181760 bytes on-disk
> > > free journal space, while the transaction needs to reserve 360416 bytes to start the recovery.
> > > Thus the mount hangs for ever.
> > 
> > Most likely something went wrong at runtime on the 4.14.35 kernel
> > prior to the crash, leaving the on-disk state in an impossible to
> > recover state. Likely an accounting leak in a transaction
> > reservation somewhere, likely in passing the space used from the
> > transaction to the CIL. We've had bugs in this area before, they
> > eventually manifest in log hangs like this either at runtime or
> > during recovery...
> > 
> > > That happens with 4.14.35 kernel and also upstream
> > > kernel (6.4.0).
> > 
> > Upgrading the kernel won't fix recovery - it is likely that the
> > journal state on disk is invalid and so the mount cannot complete 
> 
> Hmm.  It'd be nice to know what the kernel thought it was doing when it
> went down.
> 
> /me wonders if this has anything to do with the EFI recovery creating a
> transaction with tr_itruncate reservation because the log itself doesn't
> record the reservations of the active transactions.

Possibly - it's been that way since 1994 but I don't recall it ever
causing any issues in the past. That's not to say it's correct - I
think it's wrong, but I think the whole transaction reservation
calculation infrastructure needs a complete overhaul....

>
> <begin handwaving>
> 
> Let's say you have a 1000K log, a tr_write reservation is 100k, and a
> tr_itruncate reservations are 300k.  In this case, you could
> theoretically have 10x tr_write transactions running concurrently; or
> you could have 3x tr_itruncate transactions running concurrently.
> 
> Now let's say that someone fires up 10 programs that try to fpunch 10
> separate files.  Those ten threads will consume all the log grant space,
> unmap a block, and log an EFI. I think in reality tr_logcount means
> that 5 threads each consume (2*100k) grant space, but the point here is
> that we've used up all the log grant space.
>
> Then crash the system, having committed the first transaction of the
> two-transaction chain.
> 
> Upon recovery, we'll find the 10x unfinished EFIs and pass them to EFI
> recovery.  However, recovery creates a separate tr_itruncate transaction
> to finish each EFI.  Now do we have a problem because the required log
> grant space is 300k * 10 = 3000k?

Hmmmm. That smells wrong. Can't put my finger on it .....


.... ah. Yeah. That.

We only run one transaction at a time, and we commit the transaction
after logging new intents and capturing the work that remains. So we
return the unused part of the reservation (most of it) back to the
log before we try to recover the next intent in the AIL.

Hence we don't need (300k * 10) in the log to recover these EFIs as
we don't hold all ten reservations at the same time (as we would
have at runtime) - we need (log space used by recovery of intents +
one reservation) to recover them all.

Once we've replayed all the intents from the AIL and converted them
into newly captured intents, they are removed from the AIL and that
moves the tail of the log forwards. This frees up the entire of the
log, and we then run the captured intents that still need to be
processed. We run them one at a time to completion, committing them
as we go, so again we only need space in the log for a single
transaction reservation to complete recovery of the intent chaings.

IOWs, because recovery of intents is single threaded, we only need
to preserve space in the log for a single reservation to make
forwards progress.

> It's late and I don't remember how recovery for non-intent items works
> quite well enough to think that scenario adds up.  Maybe it was the case
> that before the system went down, the log had used 800K of the grant
> space for logged buffers and 100K for a single EFI logged in a tr_write
> transaction.  Then we crashed, reloaded the 800K of stuff, and now we're
> trying to allocate 300K for a tr_itruncate to restart the EFI, but
> there's not enough log grant space?

Possible, if the EFI pins the tail of the log and the rest of the
log is full. I've never seen that happen, and we've been using
itrunc reservations in recovery since 1994, but that doesn't mean it
can't happen.

FWIW, I don't think this is EFI specific. BUI recovery use itrunc
reservations, but what if it was an unlink operation using a remove
reservation to free a directory block that logs a BUI? Same problem,
different vector, right?

I suspect what we really need is for all the intent processing to be
restartable. We already have those for RUIs to relog/restart them
there isn't enough reservation space available to complete
processing the current RUI. We just made EFIs restartable to avoid
busy extent deadlocks, we can easily extend that the same "enough
reservation available" as we use for RUIs, etc. Do the same for BUIs
and RUIs, and then...

... we can set up a reservation calculation for each intent type,
and the reservation needed for a given chain of operations is the
max of all the steps in the chain. Hence if we get part way through
a chain and run out of reservation, we can restart the chain the
the reservation we know is large enough to complete the remaining
part of the chain.

The new reservation may be smaller than the reservation that was
held when we start the intent processing (because it's a rolling
chain with an inherited log ticket), but this guarantees that we can
reduce the reservation to the minimum required at any point in
time if we are running low on log space....

This also gets around the problem of having to reserve enough space
for N operations (e.g. 4 extents in an EFI) when the vast majority
only use and need space for 1 operation. If we get an EFI with N
extents in it, we can try a reservation for (N * efi_res) and if we
can't get that we could just use efi_res and work through the EFI
one extent at a time....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
