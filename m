Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77E6C38A02
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 00:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJaARG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 20:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaARF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 20:17:05 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0314138
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 17:17:04 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m6so9376964pfb.0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 17:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bRJnjlkaiE5E85cKG8iNn3FaFremMees4nE0K5C1kms=;
        b=IsiAJJXI9K6WSx+Zvk12g8dbismaglqWidWXcwFoAnGsr0fgkphODI2Z4TkIMSC6mz
         4ZfbUWp2iZmVWop5ZAMTm9WHQoQAOG9W9MK0oyjOC9hOz9KGPO+dlP+LDabmyIMspvnY
         8MfL7VxAPJGnC6A4Jp3xXv4f1wDjfahKgVcohsmVPpBhZMarWi3KGVtzDqJGw+LUJV9M
         BJDMWdaVv7eCMl9WH+kG+HpLhFOYfv+/C7sgmYCzborWTrmUUwlES6o/zO4ou6jp5los
         P5SFOEXmZz5t1NefzJNCUZ9j420Q9XphUMPCPSdSGR9FfjmkMKKObaso2bPkJNJOtR98
         7r2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRJnjlkaiE5E85cKG8iNn3FaFremMees4nE0K5C1kms=;
        b=alACxEB4wT2hluJeOtWe5iSBIgcMc9fL313LYFC83bdI+nrEi2aGK98uhY1lhIYtfx
         B9VgPx3/V3J+zhXqEQk/r3ZACDvw8sOAbHwW17t7iGJoxBF7GKbY1p7/ce2oTFz1rjK/
         LcF/inPix5XDXsUSCsTkkMyBwe2H9D7G9MPeN7LDErhCakm1hQ4+LzBLeNb5YgHSs0Fd
         zDQgU7hpapIrp1UrHocA8LgFybUvqe7OfQcnUPs4C0E9ontub3VgUeSc50VQMxy7EuRN
         oZtU7+XLGryYtRB2RogOE8PzSh17tCtLY6yMjKK/4HFGALkNmNJalGqi3irZnaROv8dI
         msUA==
X-Gm-Message-State: ACrzQf1GyMRaZfE/2PQG+qn4DbneSpYHP5+KMU6Vdssie0ZDlBAfUGXO
        byWqK+zomQiXAnrmgr6CVeZv8dTj4Ep64A==
X-Google-Smtp-Source: AMsMyM50jYAWV80RNHgknMaeHk5HBtQN537kFHKwfsCqnwLIuSdb5hbBGZbYv2mR6QfI0G6CANTROA==
X-Received: by 2002:a63:2cc2:0:b0:41c:681d:60d2 with SMTP id s185-20020a632cc2000000b0041c681d60d2mr9816772pgs.502.1667175424290;
        Sun, 30 Oct 2022 17:17:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id k32-20020a17090a3ea300b001f262f6f717sm2960720pjc.3.2022.10.30.17.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 17:17:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1opIU8-008O1q-QW; Mon, 31 Oct 2022 11:17:00 +1100
Date:   Mon, 31 Oct 2022 11:17:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/13] xfs: check deferred refcount op continuation
 parameters
Message-ID: <20221031001700.GK3600936@dread.disaster.area>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
 <166717329884.417886.372970393704654546.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166717329884.417886.372970393704654546.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 30, 2022 at 04:41:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're in the middle of a deferred refcount operation and decide to
> roll the transaction to avoid overflowing the transaction space, we need
> to check the new agbno/aglen parameters that we're about to record in
> the new intent.  Specifically, we need to check that the new extent is
> completely within the filesystem, and that continuation does not put us
> into a different AG.
> 
> If the keys of a node block are wrong, the lookup to resume an
> xfs_refcount_adjust_extents operation can put us into the wrong record
> block.  If this happens, we might not find that we run out of aglen at
> an exact record boundary, which will cause the loop control to do the
> wrong thing.
> 
> The previous patch should take care of that problem, but let's add this
> extra sanity check to stop corruption problems sooner than later.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_refcount.c |   38 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 36 insertions(+), 2 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
