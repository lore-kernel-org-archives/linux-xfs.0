Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD86C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 22:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjEQWtc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 May 2023 18:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEQWtb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 May 2023 18:49:31 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DCC340CD
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:49:30 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae50da739dso9866885ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 15:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684363769; x=1686955769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7s4MX2qO4o8qqXeR7rMYJUDec4HV8ZnPWMmw9j08tU8=;
        b=AQh6xlMtYm3uJvB9pmMcT8s95YuwIWxJmyNGyvL52tzCz7LscgjVaTaU9WEgeUh0o7
         Xs8UauIeU1zWNUahdBBTSFVPIZwwspEGxtfbRgLEk3DCp+JSJjMGRLc2gTXDuJRmdcUv
         Cy0F7lt8KNhXwWts3bI5tRsTJ3okwg37FPPJrM2KQJFz814WhGwQM8pqTfzG0Gv67wNb
         fRZ4O/FmrxzhbbQ6NxUE0aY8LUAqdfVrXHaJC79QxBM4wmQfgDcT/e3+C0iWH72swlQ7
         7Nnqj8i4QMV4aqVtUeJ1DtGJP0A2d3EmqL1FIprLtBorvUgI9AhCxpKK/ehqxBbzCmKi
         A05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684363769; x=1686955769;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7s4MX2qO4o8qqXeR7rMYJUDec4HV8ZnPWMmw9j08tU8=;
        b=FYiHwsLTwxpEoD05FLdrDXupfDDfSwUf2NMzS6JF/BVHReggiLqmR0GlEFC/atAjEn
         lqO6DugnL/AcUFG2sz4PawqdXP1e0ASlRc8qNk0FfKEumseXAfsBYZQ2UMjlAImgPiHS
         j0AghaNFTQ0nd6NYYqhD/drJNtSG6lx+Vd+6OdIw9VTBTVr6tgbwWD0S+lSnuFWBetce
         DbI4OIZfTAvgjVsruSpLsx9X5HQyYzUQbRLi5cuEMqRf01GYnwTNWBKVyK60qVFLh2SF
         54LRPk+3DxvRfuOP+Fksog4eJscflw72ZqxyOpKfIBrjfH5AQeNTss0oIbsG81Kda1mb
         saEg==
X-Gm-Message-State: AC+VfDwrOZJnq/eDozEQdCSs9t0ADVoNQeEanMYcUwg5lmPuFLudWt45
        yd5HOV1mOSSx/ggqiM/wtTGWnA==
X-Google-Smtp-Source: ACHHUZ6gSK3zBapEcOG4ceMKogWJ6bcJO2hVrOziCRMycmNqo0NnLv6iEmWS5GgyGzXgtHApk5CWXA==
X-Received: by 2002:a17:902:d48c:b0:1a6:ebc1:c54c with SMTP id c12-20020a170902d48c00b001a6ebc1c54cmr587476plg.1.1684363769636;
        Wed, 17 May 2023 15:49:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f54d00b001ae626afed4sm363998plf.220.2023.05.17.15.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 15:49:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pzPxW-000isX-0d;
        Thu, 18 May 2023 08:49:26 +1000
Date:   Thu, 18 May 2023 08:49:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: avoid freeing multiple extents from same AG in
 pending transactions
Message-ID: <ZGVZ9o1LIkZ5NPAo@dread.disaster.area>
References: <20230424225102.23402-1-wen.gang.wang@oracle.com>
 <20230512182455.GJ858799@frogsfrogsfrogs>
 <592C0DE1-F4F5-4C9A-8799-E9E81524CDC0@oracle.com>
 <20230512211326.GK858799@frogsfrogsfrogs>
 <050A91C4-54EC-4EB8-A701-7C9F640B7ADB@oracle.com>
 <11835435-29A1-4F34-9CE5-C9ED84567E98@oracle.com>
 <20230517005913.GM858799@frogsfrogsfrogs>
 <ZGQwdes/DQPXRJgj@dread.disaster.area>
 <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94FD314F-7819-4187-AC42-F984AF42C662@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 07:14:32PM +0000, Wengang Wang wrote:
> > On May 16, 2023, at 6:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, May 16, 2023 at 05:59:13PM -0700, Darrick J. Wong wrote:
> > I was thinking this code changes to:
> > 
> > flags |= XFS_ALLOC_FLAG_TRY_FLUSH;
> > ....
> > <attempt allocation>
> > ....
> > if (busy) {
> > xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> > trace_xfs_alloc_size_busy(args);
> > error = xfs_extent_busy_flush(args->tp, args->pag,
> > busy_gen, flags);
> > if (!error) {
> > flags &= ~XFS_ALLOC_FLAG_TRY_FLUSH;
> 
> What’s the benefits to use XFS_ALLOC_FLAG_TRY_FLUSH?
> If no change happened to pagb_gen, we would get nothing good in the retry
> but waste cycles. Or I missed something?

You missed something: the synchronous log force is always done.

The log force is what allows busy extents to be resolved - busy
extents have to be committed to stable storage before they can be
removed from the busy extent tree.

If online discards are not enabled, busy extents are resolved
directly in journal IO completion - the log force waits for this to
occur. In this case, pag->pagb_gen will have already incremented to
indicate progress has been made, and we should never wait in the
loop after the log force. The only time we do that is when the
current transaction holds busy extents itself, and hence if the
current tx holds busy extents we should not wait beyond the log
force....

If online discards are enabled, then they'll be scheduled by journal
IO completion. i.e. waiting on the log force guarntees pending
discards have been scheduled and they'll start completing soon after
the log force returns. When they complete they'll start incrementing
pag->pagb_gen. This is the case the pag->pagb_gen wait loop exists
for - it waits for a discard to complete and resolve the busy extent
in it's IO compeltion routine. At which point the allocation attempt
can restart.

However, the same caveat about the current tx holding
busy extents still exists - we can't tell the difference between
"discards scheduled but not completed" and "no busy extents to
resolve" in the flush code. Hence regardless of the online discard
feature state, we should not be waiting on busy extent generation
changes if we hold busy extents in the transaction....

IOWs, the TRY_FLUSH code reflects the fact that for most users, the
log force resolves the busy extents, not the wait loop on
pag->pagb_gen changing. The wait loop only really kicks in when
online discard is active, and in that case we really do want to
retry allocation without waiting for (potentially very slow)
discards to complete first. We'll do that "wait for discards" the
second time we fail to find a non-busy extent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
