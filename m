Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7400ECAAA1
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiJaVSM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 17:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiJaVSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 17:18:03 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAE9140FB
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 14:17:41 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h193so3068169pgc.10
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 14:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7imYIaQARpLPoHv27Zftg7BYfJ5RyQtkuHEplG82nQ=;
        b=TUKPrZ2fIsdw0AVNrGKEn06eBv0OllykmzN7zgLr6nNxtO0KlP1ae6kAsvLITJcov6
         3Qg+PsYMIGehtfZKLiy65xebpRQh0HXqEIZ7cdkJrX1pQmm031ufn0vxjXAHy17f1Dk7
         4eg5QXCOdNhbCXqa/6Ed/J1kmGe9dpKYzq4MUJprp4UVhcYLdLXKytGP1LIceMTKprZP
         HN7Pqi8GGBLBNJXpXPdWIX4izcBWC2Ihf+X6CBMAMFjA3z8YDtFNM3RQ5HTqb2tTMfki
         HMxmZUJRYRRCLTwN9ZTVl3BrFXrMxNmSX/IZh8/A7elHLGppoCMpqF1MwpmemXW+C5b8
         UZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7imYIaQARpLPoHv27Zftg7BYfJ5RyQtkuHEplG82nQ=;
        b=A+revXVh5fCF1fd0e6iDjGX1DzZnG4PZlmzAYo5cTNKEyAcW7xIhbBuFR11kavQ6PT
         piXzbcRo47qnKVjBzj54p/jg87AA3mRbEuRjJGa0n9litWklk8CT8B9CUypIDy2fz2m3
         HdVjHoK+hTY1ynllLSmplYWHXKblf1Pfy+/xyBbCRhQYcrcJv+cH8Tj3WGLSEzPAT5VB
         mr5cP9ohPbynmJlOSUE4gK22wn96nEFWXO2ThRyFbobbBjM9eQmYMG2y59q5w7j96iH/
         JoCBE+aMKk2RtjGbkxFkYWQIMCq5NlbAVaNcP1huPWvLg8X6hHPzwHOcHcLL5MPk8jP0
         +1Dg==
X-Gm-Message-State: ACrzQf3YxJVwm4ATtJp3WcbVuZf8xJgwMXM2ZHlBdXOLSL1XsJ5dVjq8
        vc1cp3RGZMQjZ7y2dpm3HQqgzQ==
X-Google-Smtp-Source: AMsMyM7sK9XBC3IFAg+B6r7N/sSCuH9tVf4YyciYmkV1PG0am8Nj1z9F+8ztsQaO0KzEVZxInmFENw==
X-Received: by 2002:aa7:8c44:0:b0:56c:f21f:5e0e with SMTP id e4-20020aa78c44000000b0056cf21f5e0emr16357639pfd.35.1667251060858;
        Mon, 31 Oct 2022 14:17:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id mz9-20020a17090b378900b0020a0571b354sm4600606pjb.57.2022.10.31.14.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 14:17:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opcA4-008jTn-79; Tue, 01 Nov 2022 08:17:36 +1100
Date:   Tue, 1 Nov 2022 08:17:36 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v23.2 3/4] xfs: log the AGI/AGF buffers when rolling
 transactions during an AG repair
Message-ID: <20221031211736.GM3600936@dread.disaster.area>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
 <Y2APIan1VaLglNzY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2APIan1VaLglNzY@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 31, 2022 at 11:08:33AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the only way to lock an allocation group is to hold the AGI
> and AGF buffers.  If a repair needs to roll the transaction while
> repairing some AG metadata, it maintains that lock by holding the two
> buffers across the transaction roll and joins them afterwards.
> 
> However, repair is not like other parts of XFS that employ the bhold -
> roll - bjoin sequence because it's possible that the AGI or AGF buffers
> are not actually dirty before the roll.  This presents two problems --
> First, we need to redirty those buffers to keep them moving along in the
> log to avoid pinning the log tail.  Second, a clean buffer log item can
> detach from the buffer.  If this happens, the buffer type state is
> discarded along with the bli and must be reattached before the next time
> the buffer is logged.   If it is not, the logging code will complain and
> log recovery will not work properly.
> 
> An earlier version of this patch tried to fix the second problem by
> re-setting the buffer type in the bli after joining the buffer to the
> new transaction, but that looked weird and didn't solve the first
> problem.  Instead, solve both problems by logging the buffer before
> rolling the transaction.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

I guess this is fine as long as it is confined to the scrub code;
if we need to hold clean buffers across transaction rolls in other
code we really need to sort out the BLI life cycle issues that this
currently exposes.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
