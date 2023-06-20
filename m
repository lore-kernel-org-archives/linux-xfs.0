Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66248EB64D9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 02:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjFTCJr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jun 2023 22:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFTCJq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2023 22:09:46 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EB7128
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 19:09:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-25e92536fb6so1818739a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jun 2023 19:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687226984; x=1689818984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gueQLpEt7JVDFEGNkkJgzDYbwmpJ8V9m5XfxBGOILQo=;
        b=1juxBMmYGpB0a2RZrOhSXqHq6/f+yPREoagHFdSjtLLpdOawrqwxu1zFXN82VqTGNP
         bBCM+BleiJWVfX+8nyl2PjeCenfD+uCXdIu3QuoPwFpEZYPQYqsIoPGAwPI84IJQipcM
         QT1LqwQmOli++1q/lXjl6RvxVSA/cG8So+6BhyYVmcLa5rO4M/tg09U5sSNU6Ij52y2X
         Vuv56tuUBpdfLYApLLELAUDIwRcXPfk9dBd7oPnS/Mgty6Pcify/hH9Jgxt00i9ZKjAE
         zzwxZaPmY2hFiavMxJgWj7zaIMNx4LUP9H4anrnquxCPNypx+RqN3wi+22TKdRaGOslC
         Du0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687226984; x=1689818984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gueQLpEt7JVDFEGNkkJgzDYbwmpJ8V9m5XfxBGOILQo=;
        b=RaVaiLfMk9V6AOgyY2x171HgeXbrdDIbJpkQE+7BSFtR0r645vNq6gtY1HVq7FUFOj
         gsqXIq8Q2ClTFqApYWL4e4f4enupuyF381gZBMXMZ5ziF1IYt35SoINXOy+m9N5fFFUg
         hVa18B98OVjgLwhfB2wEGr4FTF9VhzHkH7rVek1nXRjcu9XCdVyPjFaVg8CEB3BBIiWK
         7ZNPcTwyTIJ4kqIJszueUMFjAPC68lfC+d+WFMo8UkyTrMTI9Djwb7CS/q2ZZN6+nGG8
         +4d/PjZyMhmqUdatr5uafulhc6HxeloQa1lCRPKS1gGk1KZq6UbAZNP9YUiYp2n6mcIn
         NGbQ==
X-Gm-Message-State: AC+VfDwM7+rsYHkgF/U1OBL+aP1uvNbddMt6EPQV4me2QslrwRMdHjOg
        g8UGrhZh9hwkHo1DZSH1CtnDrNnyfFABJc+LOic=
X-Google-Smtp-Source: ACHHUZ6edIyalyaoRC7IAbm/u072az7ZGXX227hYkWjWVlllhFBcs5orGrtrO6wnZMCFAz8UOIraMA==
X-Received: by 2002:a17:90a:1f82:b0:250:6c76:fd9b with SMTP id x2-20020a17090a1f8200b002506c76fd9bmr6115027pja.38.1687226984053;
        Mon, 19 Jun 2023 19:09:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id ms7-20020a17090b234700b0025ea87b97b9sm7613627pjb.0.2023.06.19.19.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 19:09:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qBQoN-00Dsas-1x;
        Tue, 20 Jun 2023 12:09:39 +1000
Date:   Tue, 20 Jun 2023 12:09:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/7] xfs: fix ranged queries and integer overflows in
 GETFSMAP
Message-ID: <ZJEKY/Kan5gVHoKm@dread.disaster.area>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
 <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168506055189.3727958.722711918040129046.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 25, 2023 at 05:28:08PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> As part of merging the parent pointers patchset into my development
> branch, I noticed a few problems with the GETFSMAP implementation for
> XFS.  The biggest problem is that ranged queries don't work properly if
> the query interval is exactly within a single record.  It turns out that
> I didn't implement the record filtering quite right -- for the first
> call into the btree code, we want to find any rmap that overlaps with
> the range specified, but for subsequent calls, we only want rmaps that
> come after the low key of the query.  This can be fixed by tweaking the
> filtering logic and pushing the key handling into the individual backend
> implementations.
> 
> The second problem I noticed is that there are integer overflows in the
> rtbitmap and external log handlers.  This is the result of a poor
> decision on my part to use the incore rmap records for storing the query
> ranges; this only works for the rmap code, which is smart enough to
> iterate AGs.  This breaks down spectacularly if someone tries to query
> high block offsets in either the rt volume or the log device.  I fixed
> that by introducing a second filtering implementation based entirely on
> daddrs.
> 
> The third problem was minor by comparison -- the rt volume cannot ever
> use rtblocks beyond the end of the last rtextent, so it makes no sense
> for GETFSMAP to try to query those areas.
> 
> Having done that, add a few more patches to clean up some messes.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getfsmap-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=getfsmap-fixes
> ---
>  fs/xfs/libxfs/xfs_alloc.c    |   10 --
>  fs/xfs/libxfs/xfs_refcount.c |   13 +-
>  fs/xfs/libxfs/xfs_rmap.c     |   10 --
>  fs/xfs/xfs_fsmap.c           |  261 ++++++++++++++++++++++--------------------
>  fs/xfs/xfs_trace.h           |   25 ++++
>  5 files changed, 177 insertions(+), 142 deletions(-)

Changes look sensible, but I know my limits: I'm not going to find
off-by-one problems in this code during review.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
