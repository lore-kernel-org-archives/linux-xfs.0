Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB53C77B6E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Apr 2023 06:31:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjDLGbW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 02:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDLGbV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2023 02:31:21 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B094ECD
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 23:31:20 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id p8so10408763plk.9
        for <linux-xfs@vger.kernel.org>; Tue, 11 Apr 2023 23:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681281080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7bwVEK6QvXrqqWbnogjq3HuhLsxVh/sXn6CJvJQrrqA=;
        b=xch4eGMab0EiAUslBlSD5FnlbrgTQlYHleYwsgE+pnPSstr7/bx8g1THbsRPqGYAVr
         S7N6P6Fr9zAFsPwCoJ6jW1UP9wHtPQ7EyyAEnYelcL8PElkQ/YYOONQjyXfYzDJhxCV1
         AcfzES83rqz2E7BLa3j4LgzLthc24UW1rIQkox/AaP15Ys9Bvrp7obK3kkF/6zeCw9xE
         Sx/dAahPpYv0jbevF61a2ONpBAY3rQtDofFGi7dscLTZXV8Kcv2PjTs405CEaLjYopa7
         ADalL8Pg87pVoxJTEXqLzgxxQgwr459Ahh8sjEfZvjpNmC2qrU+DnrqGI/0zx3GoSqFQ
         HXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681281080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bwVEK6QvXrqqWbnogjq3HuhLsxVh/sXn6CJvJQrrqA=;
        b=kKg9WT45xy+mCEdiCtvIsI5xFceLvU8Jq3/wO0hKHIAmvGbPje7Ep+6ziWIzUb+a3H
         mL+g60XAhdR0O0IDAjMjtRlcd8Lf7ltDzdVvObLMaZCH96DCjJNJNUPxbE6v8GVIt01j
         CBw5SJUpVYWbW8ftF1+x27McWna1RyHcbxsmE2ga5MZd9lDCZfdMTrfMEytsrM0sv4cf
         Sj1VZIkqHQIsz8u/m07/oTwXGuGIDEJ02H2t5qvbYKcLple66pajT9ZAAsX5r8cGEt9m
         h9oc7V5wHCOXa2jCNXyhUQYrXs8MzdzYjFlocymTfN+GPRLgX248svbS8/kwdQ0EZcQH
         prpA==
X-Gm-Message-State: AAQBX9dGoW4mjB4VrKkaWUp0GCutK/i1GwhwUiKvcDtsaEONxFzK3tfq
        mLWk+eE0Bx1QkxUKe8JClKBYCjusBB0x30zr6v5RcwEJ
X-Google-Smtp-Source: AKy350YqBTpg60iT4yv2Q6ZMCDrEe4NOSArL/LXYmDNSQCOXW+vvwUfsAP3MQ3U0eZYpRoLfwpl33Q==
X-Received: by 2002:a17:903:2888:b0:1a6:3ffb:8997 with SMTP id ku8-20020a170903288800b001a63ffb8997mr7046126plb.42.1681281079695;
        Tue, 11 Apr 2023 23:31:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id y8-20020a1709029b8800b001a239325f1csm10716071plp.100.2023.04.11.23.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 23:31:19 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pmU0h-002OdT-Ij; Wed, 12 Apr 2023 16:31:15 +1000
Date:   Wed, 12 Apr 2023 16:31:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     dchinner@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 14/22] xfs: fix bugs in parent pointer checking
Message-ID: <20230412063115.GJ3223426@dread.disaster.area>
References: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168127095051.417736.2174858080826643116.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 08:48:26PM -0700, Darrick J. Wong wrote:
> Hi Dave,
> 
> Please pull this branch with changes for xfs.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> --D
> 
> The following changes since commit 0916056eba4fd816f8042a3960597c316ea10256:
> 
> xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)
> 
> are available in the Git repository at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-parent-fixes-6.4_2023-04-11
> 
> for you to fetch changes up to 0916056eba4fd816f8042a3960597c316ea10256:
> 
> xfs: fix parent pointer scrub racing with subdirectory reparenting (2023-04-11 19:00:20 -0700)
> 
> ----------------------------------------------------------------
> xfs: fix bugs in parent pointer checking [v24.5]
> 
> Jan Kara pointed out that the VFS doesn't take i_rwsem of a child
> subdirectory that is being moved from one parent to another.  Upon
> deeper analysis, I realized that this was the source of a very hard to
> trigger false corruption report in the parent pointer checking code.
> 
> Now that we've refactored how directory walks work in scrub, we can also
> get rid of all the unnecessary and broken locking to make parent pointer
> scrubbing work properly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------

Empty pull request?

Looks like the next pull-req is empty, too, and the commits that are
supposed to be in these are in pull-req after that?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
