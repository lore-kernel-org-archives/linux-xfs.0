Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C62C83F10
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 02:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjH1CBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 22:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjH1CBu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 22:01:50 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E48123
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 19:01:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so1538295a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 19:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693188107; x=1693792907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tSWFmoDenQvkphm9hwa+4yGp4Vf1sPWNCtkzSFDvlr0=;
        b=i9g6AnzRjLiI1zneS5c/qlkoqYyNzWP5PuQYdlQW63dH4jJ+XAWt7uvwwHk7tHE9Ef
         kL0Q377QF979Vi0JfFL5ZeQ41FmmoO+9LK2je2ysseBK0xpTuSgFrJjdsFNM7dluv58K
         7NjwdI2B/tT6vkm92/4/IJ2vgbpxhEhXqxlKuN1XKpYdBUFt7Jue8fqW3GL8IcFPDvKg
         cTGGBAQpVu4+v5x8jUaAz8b5tNZ0s2sKaznRLc1eeOvB7Nk+SYWYAUGtAX//DEvhJNGT
         WT0bureZcDWuWPVo/Ds2SGZ0IzasdREKjeMtsXngbPaUlJonPvcLMiIwphX4euOyT54k
         Lx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693188107; x=1693792907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSWFmoDenQvkphm9hwa+4yGp4Vf1sPWNCtkzSFDvlr0=;
        b=Q4b2FTGyY4XaiYJ/w+aVTdYQ6ec4Se9LSvMt4JQ75ytdqe7S4Xg0RLOTKfofL9AIJQ
         44BgxFwiWNSUVJXXTKHLE8g8LH90p5Qkjbd+iHlcZirD2tAUkqRnqp58a9uc3WeICpt3
         s6Cx35HhU+0DdqEjeT+GupuoM5sD+vlSHdQgwZboXA5J3iTY4jTY3fZVOD30cepuaJKW
         opNm9cuS9KwVWd+tfQGc2hYGBy5hrrQwGTOMn1rFGy0liJmSBw68IM1Gfx3N/BtSQCrq
         /W/g4z/fRTDO4UXlaeIb13FdK2ExgWLnIgDD5avrB+2eBPnNhHQaeuTbeHn84nv2RnAs
         GKnQ==
X-Gm-Message-State: AOJu0YwuzmsHq2oFJR1uNjjmPBtactsCtZoL7Khpi/VaIxyYy9UgkekD
        1BHMWvLXJ3GjzfzRSp3ShzgNltKUBJLTS1ISVvA=
X-Google-Smtp-Source: AGHT+IErTqD5fb4QKWJ7//Jy0ah8xLPhbd6P8Z0/dWRpPLgeAWJOWNC31ATk+7Bn6Eg0ur+ElP14WQ==
X-Received: by 2002:a05:6a20:f39d:b0:131:c760:2a0b with SMTP id qr29-20020a056a20f39d00b00131c7602a0bmr24896148pzb.52.1693188107641;
        Sun, 27 Aug 2023 19:01:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id 22-20020aa79156000000b006877a17b578sm5490011pfi.40.2023.08.27.19.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 19:01:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qaRZY-007RoU-24;
        Mon, 28 Aug 2023 12:01:44 +1000
Date:   Mon, 28 Aug 2023 12:01:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix an agbno overflow in __xfs_getfsmap_datadev
Message-ID: <ZOwACEnV/ZtTs9TW@dread.disaster.area>
References: <20230823010046.GD11286@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823010046.GD11286@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 22, 2023 at 06:00:46PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> exact power of two.  I traced this to an agbno integer overflow when the
> current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> the last record returned was non-shareable space at the end of an AG.
> 
> __xfs_getfsmap_datadev sets up a data device query by converting the
> incoming fmr_physical into an xfs_fsblock_t and cracking it into an agno
> and agbno pair.  In the (failing) case of where fmr_blockcount of the
> low key is nonzero and the record was for a non-shareable extent, it
> will add fmr_blockcount to start_fsb and info->low.rm_startblock.
> 
> If the low key was actually the last record for that AG, then this
> addition causes info->low.rm_startblock to point beyond EOAG.  When the
> rmapbt range query starts, it'll return an empty set, and fsmap moves on
> to the next AG.
> 
> Or so I thought.  Remember how we added to start_fsb?
> 
> If agsize < 1<<agblklog, start_fsb points to the same AG as the original
> fmr_physical from the low key.  We run the rmapbt query, which returns
> nothing, so getfsmap zeroes info->low and moves on to the next AG.
> 
> If agsize == 1<<agblklog, start_fsb now points to the next AG.  We run
> the rmapbt query on the next AG with the excessively large
> rm_startblock.  If this next AG is actually the last AG, we'll set
> info->high to EOFS (which is now has a lower rm_startblock than
> info->low), and the ranged btree query code will return -EINVAL.  If
> it's not the last AG, we ignore all records for the intermediate AGs.
> 
> Oops.
> 
> Fix this by decoding start_fsb into agno and agbno only after making
> adjustments to start_fsb.  This means that info->low.rm_startblock will
> always be set to a valid agbno, and we always start the rmapbt iteration
> in the correct AG.
> 
> While we're at it, fix the predicate for determining if an fsmap record
> represents non-shareable space to include file data on pre-reflink
> filesystems.
> 
> Reported-by: Dave Chinner <david@fromorbit.com>
> Fixes: 63ef7a35912dd ("xfs: fix interval filtering in multi-step fsmap queries")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Fixes the regression, code looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
