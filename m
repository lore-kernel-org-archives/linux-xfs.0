Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0FFE92701
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:13:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjJEONi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbjJEOLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:11:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8721713
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 20:30:11 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1c77449a6daso4109965ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 20:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696476611; x=1697081411; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VajkbiKJRdhbUhinvkMr3kT4T3QOd76bccn/DGDHE60=;
        b=tB37CuDyO66i71VGLGvspLHqs0iJHLLlANOriclUWK5I97TKDaJ822ey75zhjJMQ32
         tWb8H0DN7/wAbpNuMIASJ3OoNGf3qqQFSZY6TklhYteowLhrwHjaJfodVQoeNNtDkPfi
         ty+dzny6jApl8zEVHAdz6sqXj7HmYJeQ90L2m1HBqtNxFj0hDCS8dUP3HRHIyxqdO8fl
         lO5AovBOI29F4eytCBw+kkq3rqiot+5+7VADPCoXbRuud/FjxtNOxpeWgW/XlHJNCFTH
         r0UP/nNfIemnghk1k8yw6Hrtzh+eSXBe8G6ZOSIw2tMUjxJR/aZ0tun4J1p2xo0p2EpM
         d/wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696476611; x=1697081411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VajkbiKJRdhbUhinvkMr3kT4T3QOd76bccn/DGDHE60=;
        b=SNTWGAOjQCcRyFqCofh9Rx/jmORMSmnvKFnqCiqeYpzzgzfzu5E9Mp1ickBRHGoGWZ
         rV/IMMSH91xus81feY+NnyRZpZS1hXiXsXQB0GDlCJ9chMMof9tMQHGvYnlBJKdiiINL
         fVDBqEceCE1BjN3DhxYfPD1hmyaU4r8k0rQ96dezwR6JT4KwOU5sNQj5+2KMSN3wkHKr
         gKPu6NAzzyJEbOuaKvWNPDYCcKTm+gfZ55Ao9N+4xkZV9jq/Y8ZnlvwdddKDHrVPBzlX
         Yy8MTkWa2Mpzmot8/SekL48yH1G5Gu92wY4J2euc7x8+wAzg2L5lXaeiT89dVbk/2UwQ
         hDeg==
X-Gm-Message-State: AOJu0YyaZFoCnu4nX7PoVvK4ZshPekWtIFKwadJRpkiT/Dup92K0HSh9
        k1PjKvzGopazRNUDcnGU7Tp61A==
X-Google-Smtp-Source: AGHT+IHKkkFLqm4AXPVtyiw6wZNz7yOWODtyWpPN/wO7ocottBk437dd8oa+e4NwbU+3IV0VfPKObw==
X-Received: by 2002:a17:903:230e:b0:1c3:e5bf:a9f8 with SMTP id d14-20020a170903230e00b001c3e5bfa9f8mr5165045plh.19.1696476611069;
        Wed, 04 Oct 2023 20:30:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902ed0500b001c3ea6073e0sm361803pld.37.2023.10.04.20.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 20:30:10 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoF3w-009cIp-0F;
        Thu, 05 Oct 2023 14:30:08 +1100
Date:   Thu, 5 Oct 2023 14:30:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: remove __xfs_free_extent_later
Message-ID: <ZR4twC3dSlT9HRL1@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059193.3312911.17799392857205480363.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059193.3312911.17799392857205480363.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:31:54PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_free_extent_later is a trivial helper, so remove it to reduce the
> amount of thinking required to understand the deferred freeing
> interface.  This will make it easier to introduce automatic reaping of
> speculative allocations in the next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c             |    2 +-
>  fs/xfs/libxfs/xfs_alloc.c          |    2 +-
>  fs/xfs/libxfs/xfs_alloc.h          |   14 +-------------
>  fs/xfs/libxfs/xfs_bmap.c           |    4 ++--
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
>  fs/xfs/libxfs/xfs_ialloc.c         |    5 +++--
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
>  fs/xfs/libxfs/xfs_refcount.c       |    6 +++---
>  fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
>  fs/xfs/scrub/reap.c                |    2 +-
>  fs/xfs/xfs_extfree_item.c          |    2 +-
>  fs/xfs/xfs_reflink.c               |    2 +-
>  12 files changed, 17 insertions(+), 28 deletions(-)

Ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
