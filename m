Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B4E2C3DA6F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 07:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjHXH3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 03:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbjHXH2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 03:28:31 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D1310C8
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 00:28:28 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-3a8036d805eso4732483b6e.3
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 00:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692862108; x=1693466908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kt84OG0kmWfUO2k29KCAMiDEEfm4xjeiwXWJblOlLJQ=;
        b=1TcuA+L2q0pnk+6uqpPHeDA1xZGlzsXf+egyKU3MofHmJWTobu07KcCgMebr/ic0cE
         VQInBo+KfLikB1xPHOA9pngrVcDaGQytA0VKHlRp8QqN0eiIRvjKZrBrDptHOoiGCDdr
         r5FisCV66zC0WUDKalhPCwdIbtDNPEF5Qfzk2BuFzmq96d0YTkex5yUQ8IO5R2p/eliJ
         DsEcN7BAxsyyUuW2/vHE4AggfNmyKaKcSTXnX5dlbXYRYxDS8xNuZnr2sPgWhATIC/Mw
         PmLvW75UtpdmDhUzS0ToS54Ya5vJmMQXpr3MjxJIRcTw/js30F+dh+r3g4YnYA2gSFGp
         73yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692862108; x=1693466908;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kt84OG0kmWfUO2k29KCAMiDEEfm4xjeiwXWJblOlLJQ=;
        b=POxbNeBbVoi9ZNG48VFq4HWysqlWVIqQMFczQoC/09goj4ToQv7L3X0ii0leux7cOl
         Cwu0t/3MdzZMCB3XDPJG17b+frBc2GLqaVbjfNqXtKzzcz19BjZzuthlECxQb913Orz9
         wCZXjEdoimZq2mPi7kD/HB4gjDXrpdROGCVFtUyar6dKG5ys6DsRYB+w2QNAaZqRWaHK
         bBC4bYy+geJBf4OUxMw0HcSy3uEa3WhiUZ4jryxvC3IiKfOcpF8RDUf9hT4YbqoWpu1z
         1JPa4oibnXn3cHZ4lyj+khXdttIEwzTSHPnghHY0+NiEHzPE6O7EFXDrIN43stLqrwYX
         +aiw==
X-Gm-Message-State: AOJu0YzMjjiBV+6SF6HAgxWqnDqE6sCxPU42LlFzjIKh5Ogb3haBVUi0
        c9PuUEw05PPo/O9T79wpErOKzw==
X-Google-Smtp-Source: AGHT+IGH6e4jsqvW+yq6lhvEejn5gVVnvVXMUPmw9yAfj97ALWJi4zSMomi0DqjX+SbXq16lOvPJ0A==
X-Received: by 2002:a05:6808:1302:b0:3a8:5133:4842 with SMTP id y2-20020a056808130200b003a851334842mr18597468oiv.54.1692862108023;
        Thu, 24 Aug 2023 00:28:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id v19-20020aa78513000000b0068a40d7e7c1sm6865546pfn.111.2023.08.24.00.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 00:28:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZ4lT-005nlU-2u;
        Thu, 24 Aug 2023 17:28:23 +1000
Date:   Thu, 24 Aug 2023 17:28:23 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZOcGl/tujTv2MjEr@dread.disaster.area>
References: <ZLcqF2/7ZBI44C65@dread.disaster.area>
 <20230719014413.GC11352@frogsfrogsfrogs>
 <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <20230824045234.GK11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824045234.GK11263@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 09:52:34PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 18, 2023 at 03:25:46AM +0000, Wengang Wang wrote:
> 
> Since xfs_efi_item_recover is only performing one step of what could be
> a chain of deferred updates, it never rolls the transaction that it
> creates.  It therefore only requires the amount of grant space that
> you'd get with tr_logcount == 1.  It is therefore a bit silly that we
> ask for more than that, and in bad cases like this, hang log recovery
> needlessly.

But this doesn't fix the whatever problem lead to the recovery not
having the same full tr_itruncate reservation available as was held
by the transaction that logged the EFI and was running the extent
free at the time the system crashed. There should -always- be enough
transaction reservation space in the journal to reserve space for an
intent replay if the intent recovery reservation uses the same
reservation type as runtime.

Hence I think this is still just a band-aid over whatever went wrong
at runtime that lead to the log not having enough space for a
reservation that was clearly held at runtime and hadn't yet used.

> Which is exactly what you theorized above.  Ok, I'm starting to be
> convinced... :)

I'm not. :/

> I wonder, if you add this to the variable declarations in
> xfs_efi_item_recover (or xfs_efi_recover if we're actually talking about
> UEK5 here):
> 
> 	struct xfs_trans_resv	resv = M_RES(mp)->tr_itruncate;
> 
> and then change the xfs_trans_alloc call to:
> 
> 	resv.tr_logcount = 1;
> 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
> 
> Does that solve the problem?

It might fix this specific case given the state of the log at the
time the system crashed. However, it doesn't help the general
case where whatever went wrong at runtime results in there being
less than a single tr_itruncate reservation unit available in the
log.

One of the recent RH custom cases I looked at had much less than a
single tr_itruncate unit reservation when it came to recovering the
EFI, so I'm not just making this up.

I really don't think this problem is not solvable at recovery time.
if the runtime hang/crash leaves the EFI pinning the tail of the log
and something has allowed the log to be overfull (i.e. log space
used plus granted EFI reservation > physical log space), then we may
not have any space at all for any sort of reservation during
recovery.

I suspect that the cause of this recovery issue is the we require an
overcommit of the log space accounting before we throttle incoming
transaction reservations (i.e. the new reservation has to overrun
before we throttle). I think that the reservation accounting overrun
detection can race to the first item being placed on the wait list,
which might allow transactions that should be throttled to escape
resulting in a temporary log space overcommit. IF we crash at jsut
the wrong time and an intent-in-progress pins the tail of the log,
the overcommit situation can lead to recovery not having enough
space for intent recovery reservations...

This subtle overcommit is one of the issues I have been trying to
correct with the byte-based grant head accounting patches (which I'm
-finally- getting back to). I know that replaying the log from the
metadump that repoduces the hang with the byte-based grant head
accounting patchset allowed log recovery to succeed. It has a
different concept of where the head and tail are and hence how much
log space is actually available at any given time, and that
difference was just enough to allow a tr_itruncate reservation to
succced. It also has different reservation grant overrun detection
logic, but I'm not 100% sure if it solves this underlying runtime
overcommit problem or not yet...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
