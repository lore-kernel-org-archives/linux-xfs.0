Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A21CC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiLUWeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Dec 2022 17:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbiLUWeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Dec 2022 17:34:21 -0500
Received: from newman.eecs.umich.edu (newman.eecs.umich.edu [141.212.113.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C191081
        for <linux-xfs@vger.kernel.org>; Wed, 21 Dec 2022 14:34:20 -0800 (PST)
Received: from email.eecs.umich.edu (email.eecs.umich.edu [141.212.113.99] (may be forged))
        by newman.eecs.umich.edu (8.15.2/8.14.4) with ESMTPS id 2BLMY42o3271773
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 21 Dec 2022 17:34:04 -0500
Received: from email.eecs.umich.edu (localhost [127.0.0.1])
        by email.eecs.umich.edu (8.15.2/8.13.0) with ESMTP id 2BLMY4vF3796103;
        Wed, 21 Dec 2022 17:34:04 -0500
Received: from localhost (tpkelly@localhost)
        by email.eecs.umich.edu (8.15.2/8.14.4/Submit) with ESMTP id 2BLMY3Vr3796100;
        Wed, 21 Dec 2022 17:34:03 -0500
Date:   Wed, 21 Dec 2022 17:34:03 -0500 (EST)
From:   Terence Kelly <tpkelly@eecs.umich.edu>
To:     "Darrick J. Wong" <djwong@kernel.org>
cc:     Suyash Mahar <smahar@ucsd.edu>, Dave Chinner <david@fromorbit.com>,
        linux-xfs@vger.kernel.org, Suyash Mahar <suyash12mahar@outlook.com>
Subject: atomic file commits (was: Re: XFS reflink overhead,
 ioctl(FICLONE))
In-Reply-To: <Y6EmqMD9v7J3R2k1@magnolia>
Message-ID: <alpine.DEB.2.22.394.2212211726440.3789880@email.eecs.umich.edu>
References: <CACQnzjuhRzNruTm369wVQU3y091da2c+h+AfRED+AtA-dYqXNQ@mail.gmail.com> <Y5i0ALbAdEf4yNuZ@magnolia> <CACQnzjua_0=Nz_gyza=iFVigceJO6Wbzn4X86E2y4N_Od3Yi0g@mail.gmail.com> <20221215001944.GC1971568@dread.disaster.area>
 <alpine.DEB.2.22.394.2212151910210.1790310@email.eecs.umich.edu> <20221218014649.GE1971568@dread.disaster.area> <CACQnzjtPXY=8nj0H+x+qdR7B=f+m4xgvFzc2LST+=KcMQkL9bg@mail.gmail.com> <Y6EmqMD9v7J3R2k1@magnolia>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



Hi Darrick,

I should have mentioned this earlier, but for several years XFS developer 
Christoph Hellwig has been working on a feature inspired by the FAST 2015 
paper.  My HP colleagues and I met Christoph at FAST 2015 and he expressed 
interest in doing something similar in XFS.  Since then he has reported 
doing a considerable amount of work toward that goal, though I don't know 
the current state of his efforts.

I'm just pointing out a possible connection between the "atomic file 
commits" described below and Christoph's work; I don't know if the 
implementations are similar, but to an outsider it sounds like they aspire 
to serve the same purpose:  Enabling applications to efficiently evolve 
files from one well-defined state to another atomically even in the 
presence of failure.

Regardless of how and by whom this goal is achieved, folks like Suyash and 
I eagerly await the results.

May the Force be with you!

-- Terence



On Mon, 19 Dec 2022, Darrick J. Wong wrote:

> ...
>
> <cough> The bits needed for atomic file commits have been out for review 
> on fsdevel since **before the COVID19 pandemic started**.  It's buried 
> in the middle of the online repair featureset.
>
> Summary of the usage model:
>
> fd = open(sourcefile...)
> tmp_fd = open(..., O_TMPFILE)
>
> ioctl(tmp_fd, FICLONE, fd);	/* clone data to temporary file */
>
> /* write whatever you want to the temporary file */
>
> ioctl(fd, FIEXCHANGE_RANGE, {tmp_fd, file range...}) /* durable commit */
>
> close(tmp_fd)
>
> True, this isn't an ephemeral file -- for such a thing, we could just 
> duplicate the in-memory data fork and never commit it to disk.  But that 
> said, I've been trying to get the parts I /have/ built merged for three 
> years.
>
> I'm planning to push the whole giant thing to the list on Thursday.
>
> --D
