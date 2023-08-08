Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AACC001DE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Aug 2023 15:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjHHPy7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Aug 2023 11:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjHHPxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Aug 2023 11:53:16 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495642135
        for <linux-xfs@vger.kernel.org>; Tue,  8 Aug 2023 08:43:12 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-79acc14c09eso1665596241.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 Aug 2023 08:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691509362; x=1692114162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aFc1O/620Mo/LCac8/B6sLOyJwtjfj/ZYlgRhW/DyrM=;
        b=zBRjI3NvgOa74Vd86v8nOeU7WfQ/lNVl5v198gXRvY3w1RWFP/mYmhGiUQGCFjzzLF
         Mm+NvH6hBfwAEYzrZPFhCyQPZedUzLhd0omvr37Lltz9pn/gLlmBbTsF35ueZHSHBGH2
         QsvxZ4xUnl7BBF/K7FwibvymAVSBn6TfPg+4UB1RqaJpQ1elbi2x57p8dLmggZCWSL+y
         MbY0zlmmQVgKkZt6E2ly1soCja+5d6HtlinySWLqnyUZgzfUcpimRfrUB3wpCJis5hUZ
         DBCLxrZX4CZHFByum2UxChX6OBUcj0+iUuSbVqoptBIfbv9Rg2y20fgbn8vR44k3skgC
         sK6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691509362; x=1692114162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFc1O/620Mo/LCac8/B6sLOyJwtjfj/ZYlgRhW/DyrM=;
        b=gLi7dXdiW8InCUVQQXGhKxMvROJz8k+QDDrlZyP5bm03PJ0ktRpVJZxpkQl3htbED/
         ftdUT0ronqKrgzzoq4Bz/tJlclpwpYTSVc3LOiwXrBZVakNurDzeCMZ3vkBfX9djGK5J
         C57ZjD7IoRHWBLdVwsEMtg1tvyQ7dMwfWuAFF+EWueoNBsfncdV7jGfCG7UsJ7F4mZUn
         r/Ouj1h5rt9B5uBYE9NI1bphlvbZ+465ybEcd3O5bsFkCeZSuQh2zrL/vbrTetOcV7tS
         uLE2/7VK7vEOQaYWH3Su79GmxLlO4coFjY3nvrK1/oy+5OdDoo+hy/eQ+Lt6tARZMqQy
         yS+w==
X-Gm-Message-State: AOJu0YwR/yL6PVEqIqCXNWIXLuljD+MedvVT+jBEfRVxwQI7P2+0dMDw
        ph4ukssYbkrzflhwDkAWBhxGCh4Zye49AAvYWa8=
X-Google-Smtp-Source: AGHT+IH5Rr5E/AF0CTlofjPyDmoy6BRUnjUD5cpbm0LbO5dgaS8agg9l2fJdg6ua6yD4etupMylEWA==
X-Received: by 2002:a05:6808:ec6:b0:3a4:25ab:eecb with SMTP id q6-20020a0568080ec600b003a425abeecbmr13497799oiv.51.1691478888946;
        Tue, 08 Aug 2023 00:14:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id r2-20020a17090a2e8200b00260cce91d20sm7063903pjd.33.2023.08.08.00.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 00:14:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTGvW-002cBp-0u;
        Tue, 08 Aug 2023 17:14:46 +1000
Date:   Tue, 8 Aug 2023 17:14:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: rewrite xchk_inode_is_allocated to work properly
Message-ID: <ZNHrZoBjTRj4JX/u@dread.disaster.area>
References: <169049625702.922264.5146998399930069330.stgit@frogsfrogsfrogs>
 <169049625753.922264.11707952061753226050.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049625753.922264.11707952061753226050.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:31:03PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Back in the mists of time[1], I proposed this function to assist the
> inode btree scrubbers in checking the inode btree contents against the
> allocation state of the inode records.  The original version performed a
> direct lookup in the inode cache and returned the allocation status if
> the cached inode hadn't been reused and wasn't in an intermediate state.
> Brian thought it would be better to use the usual iget/irele mechanisms,
> so that was changed for the final version.
> 
> Unfortunately, this hasn't aged well -- the IGET_INCORE flag only has
> one user and clutters up the regular iget path, which makes it hard to
> reason about how it actually works.  Worse yet, the inode inactivation
> series silently broke it because iget won't return inodes that are
> anywhere in the inactivation machinery, even though the caller is
> already required to prevent inode allocation and freeing.  Inodes in the
> inactivation machinery are still allocated, but the current code's
> interactions with the iget code prevent us from being able to say that.
> 
> Now that I understand the inode lifecycle better than I did in early
> 2017, I now realize that as long as the cached inode hasn't been reused
> and isn't actively being reclaimed, it's safe to access the i_mode field
> (with the AGI, rcu, and i_flags locks held), and we don't need to worry
> about the inode being freed out from under us.
> 
> Therefore, port the original version to modern code structure, which
> fixes the brokennes w.r.t. inactivation.  In the next patch we'll remove
> IGET_INCORE since it's no longer necessary.
> 
> [1] https://lore.kernel.org/linux-xfs/149643868294.23065.8094890990886436794.stgit@birch.djwong.org/
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Lotsa comments, nothing triggered me this time through :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
