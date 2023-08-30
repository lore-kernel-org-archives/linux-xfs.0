Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ABC9C83F14
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 01:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbjH3BC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 21:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbjH3BB6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 21:01:58 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630251BF
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:56 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-56f84dd2079so2485899a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 18:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693357316; x=1693962116; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MHF1ifdkJHsG3PJ8NHaLr6qUm4SUMCRzGNgN47BqNUk=;
        b=EkzrP4tcRITdQfgcG9B9iV9aVkLemtIKxaQvkp02RJIVznvpa9gZULlHNfW7RRloaR
         ZBHxWGD2ZyGTwyP5hFHEn2QJ+lXBDIHPcs9dtESnehkNXRqoxvEpZAsrzflidm2IzZyF
         qyjVl6DKZaiLumyEVCyrv87306CQjzZ7+q7KHz774b/r/DEZvpGtYZ7aPqgtB+JBbCQQ
         tLfFsq5p02riI6djcQ7iItKt8dF7fD2LPyua7zCUBVGpX+B6jvs0Y/B37iJLBEa+yHaA
         1ahs/m0CMPjYiyQ6Xd/yIeIkZmKfUT/uZ3fT/s0vwiiylE1yZg8wxadt5Tj0KfRdwYiy
         WlHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693357316; x=1693962116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHF1ifdkJHsG3PJ8NHaLr6qUm4SUMCRzGNgN47BqNUk=;
        b=A44+/mtT+v1mIGdh1aMN/OnAMNmKafyPZmdaciG88bp8yOHH5+qa4DruWRIJ4HFxM6
         dU+cEKLCmB+gcptoSsBqXenPt0NhH49r7kdrTu97352kTGbDnixrKb9LYbCz+NxR3Yfy
         RQK9TL1VtWqEdJ0QPtTiTurDcBaJbVZ4WsbiM0HwtDj+kosCaNnJSYSpKcY2CC+xHzwC
         YfKFx4D1y+KQsJtWbWaYW8YqMEHWH3gmRnmeIpNleC9uGW07htSU6iOEMtri9UCMP/KW
         qLwzzghtYTeWh3Vznsr7X7I383sk0AmmyQGM1GvQS8Ypa9LduXAmVKgDKRwL2u1CsuHB
         KNnQ==
X-Gm-Message-State: AOJu0YwMyVS0wcKTP93x1IdsDBbcs0dUlQd4skeQ6DGVESPgYk/zIvHK
        +IJklp/wPTzJH53OqCcgL7fdSw==
X-Google-Smtp-Source: AGHT+IEkbs24DHXv4Aofhw/3kNBd8y29Kmp1VIPrJs+YyPo+pQRKHODBydLt2i+fz8pQfpzUqVv+2Q==
X-Received: by 2002:a17:90b:368a:b0:26b:2f9:a898 with SMTP id mj10-20020a17090b368a00b0026b02f9a898mr766808pjb.47.1693357315834;
        Tue, 29 Aug 2023 18:01:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d51000b00198d7b52eefsm9964942plg.257.2023.08.29.18.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 18:01:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qb985-008IZy-1d;
        Wed, 30 Aug 2023 10:32:17 +1000
Date:   Wed, 30 Aug 2023 10:32:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, linux-xfs@vger.kernel.org,
        sandeen@sandeen.net
Subject: Re: [PATCH 1/2] xfs: allow inode inactivation during a ro mount log
 recovery
Message-ID: <ZO6OEckBfMWCxcxW@dread.disaster.area>
References: <169335056369.3525521.1326787329447266634.stgit@frogsfrogsfrogs>
 <169335056933.3525521.6054773682023937525.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335056933.3525521.6054773682023937525.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:09:29PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> In the next patch, we're going to prohibit log recovery if the primary
> superblock contains an unrecognized rocompat feature bit even on
> readonly mounts.  This requires removing all the code in the log
> mounting process that temporarily disables the readonly state.
> 
> Unfortunately, inode inactivation disables itself on readonly mounts.
> Clearing the iunlinked lists after log recovery needs inactivation to
> run to free the unreferenced inodes, which (AFAICT) is the only reason
> why log mounting plays games with the readonly state in the first place.
> 
> Therefore, change the inactivation predicates to allow inactivation
> during log recovery of a readonly mount.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
