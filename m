Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE4FBEB64D9
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 02:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbjFPCTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 22:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbjFPCTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 22:19:22 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DAE2683
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:19:21 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-25e803df0d7so232808a91.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686881961; x=1689473961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HQDcn9tZwM6dJWJSarO3qZdUTtjx5HJEKAidy6nCHT0=;
        b=j2Bjm6kf5Eqktbi2p/5amdCmf/zA3T1CQ2B0xd9dhgAyt49o66qLgnbEGlDoFlO5tV
         LevH1j2L06gW9RJZr4cm7eYHevPQwswKT0pOKZ/4hNcw5KprhsnRZ2MW2RMbUY+UWHAK
         eixBMvC3sKNypLBkgHhbcGNAta0gjGRAyx+POa2JxyUOJ4MURgJ+CTJN9fEsviIxXdVv
         K/1e8id1/NlEyTDG7SOVa/P6q4PrT4EWT5RBqkfChkSQ5IdfzHkpZpdvAabkLafgP0Vm
         E+fU1Y6Iy1Sg89e5edKssqBl7bR8R5/j/HQApYctj2KE5Tvssms1+IrmAjV1Q9kKPOD+
         9zKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686881961; x=1689473961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQDcn9tZwM6dJWJSarO3qZdUTtjx5HJEKAidy6nCHT0=;
        b=Unzm3GmlbV8GKULVeFadS0MoktKDIZ5DanieCxEG1NHi1+t159Sc3d9WwknWxVMkUr
         zp3GAt5MXnrdBd3K0DGMMaqIvHbwGMJIuqP3AKRxSkyZu446v1NxT4xNhFHa7d/MiiRG
         f0uDjbBXg9nqDgAoPE64XtT8cxc7i6m7AxJPWmoYMgUo6uGy9w3vgVTwd5vV5ibUXhej
         yQor90PABdECHz6KIIeTlW6N8225YVbd5NOZs0toI60imBYdQIRRLu5W66s6QIqfsglN
         i+fSsUdQ4lAMReLCkTmJZnklq5U8iOaP/9290HFjV0IkCLbJ+jPeGvOa9JgzTiYWFy6e
         pfSw==
X-Gm-Message-State: AC+VfDx50ODqndM1iSvbFh3HdJWVcaA3yqLcE23i48Ze+SOm32dRbAiw
        9txJ+nposbkcbkJry6OJbHyBgNpWJrP1HUSu4m0=
X-Google-Smtp-Source: ACHHUZ5gdqKB8aPPzmlVp9TXL0vRSZ6J5bLE9MDUGnPpw7n/6lr01gdGxkb417+pntnNBOxPU177+A==
X-Received: by 2002:a17:90a:3903:b0:246:634d:a89c with SMTP id y3-20020a17090a390300b00246634da89cmr445509pjb.41.1686881960993;
        Thu, 15 Jun 2023 19:19:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902d70500b001ac94b33ab1sm5965687ply.304.2023.06.15.19.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:19:20 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9z3W-00CIkU-0c;
        Fri, 16 Jun 2023 12:19:18 +1000
Date:   Fri, 16 Jun 2023 12:19:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        mcgrof@kernel.org, jack@suse.cz, hch@infradead.org,
        ruansy.fnst@fujitsu.com
Subject: Re: [PATCH 2/3] fs: wait for partially frozen filesystems
Message-ID: <ZIvGpuS5is6Sc6ln@dread.disaster.area>
References: <168688010689.860947.1788875898367401950.stgit@frogsfrogsfrogs>
 <168688011838.860947.2073512011056060112.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168688011838.860947.2073512011056060112.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 06:48:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Jan Kara suggested that when one thread is in the middle of freezing a
> filesystem, another thread trying to freeze the same fs but with a
> different freeze_holder should wait until the freezer reaches either end
> state (UNFROZEN or COMPLETE) instead of returning EBUSY immediately.
> 
> Neither caller can do anything sensible with this race other than retry
> but they cannot really distinguish EBUSY as in "someone other holder of
> the same type has the sb already frozen" from "freezing raced with
> holder of a different type".
> 
> Plumb in the extra coded needed to wait for the fs freezer to reach an
> end state and try the freeze again.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/super.c |   34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)

Simple enough. I was going to comment about replacing wait_unfrozen
with a variant on wait_for_partially_frozen(), but then I looked at
the next patch....

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
