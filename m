Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8FFC83F14
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Aug 2023 22:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbjH3W3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242076AbjH3W3p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2023 18:29:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B14B9
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 15:29:30 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68a41035828so134166b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 30 Aug 2023 15:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693434570; x=1694039370; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RfXy64d5x9F+OEOiNrwiEIx+pD3MUDbsux384LU10Gs=;
        b=SkauTuLRPq5i+QxM3mjXsbSFV1NbadgELvdRmxzEBdUUPRInGs3TUdKwhfvmmvYV/I
         vzVK3wX9Qg//GUTAyuUXeOcWq9oqa3VllMENFF8EPTvrz1HTYEDjc1PE2vxD3YuEZQEp
         PZhh+XQhgSsnFgr8LbXzIl5tEedjHhBvjywmmPsOPU6fLLpLoIbizli0bK900Q3IkrG9
         nqiWGAqrw09E3d75+4Mzttf/aW59mfezeNGEk0f5CJmeFiLJUAWs+kzpZLGaFqEKWaNB
         D7jM9WZcu5p8W5yc5z0DA8MOrSXkXogF2CmV1jThTihKkO3/dD0BKXeHUfs7+IyM8Wvd
         IHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693434570; x=1694039370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RfXy64d5x9F+OEOiNrwiEIx+pD3MUDbsux384LU10Gs=;
        b=HeDcyh8sfH04WXjO8ORjAunjUgs+h4XsOG+hBYsdvi2DUM961Qc/hTZl4ANPpU5x46
         rj/PxxwXVPR6Ea4/fxr38BIqPq0dn52CYw1SOLz1oKDhc2YWKP0HF2XcxnjA1nHwbZHo
         ZsaJbgtjKEgTE73KESzPUQBsVe4koa8ynp4G4nlxb+FCEfldTHjotmz0Zxx1MPW5PkZb
         xS11weWMoTS2enwlK058SY+mT+0V793NHdCaC880zJ6rD1ARXMuDJd6zT+19PWZ0rXri
         rMEMbkAfdzkFEo1XmmAT6FTxmyWVZIp7o3btyhLhoWvEcI3Men7675bKaGtPtXqjMMGB
         nwKA==
X-Gm-Message-State: AOJu0YyBRdzWU32X5gd53QFXhehHnqf6Fdv7/Lmabmz7ezN+5OeJcJ8U
        rJbMuLKEL03BUR6Tx/habkDjnw==
X-Google-Smtp-Source: AGHT+IECaJ46FOVHhJCNbnWv4cpbk6ZiXDmLgEpADYaVagCTkhfaVZf9UeE4ztA8JEHVYs/IcmoHXg==
X-Received: by 2002:a05:6a00:b8f:b0:68b:dbbc:dcf4 with SMTP id g15-20020a056a000b8f00b0068bdbbcdcf4mr3925068pfj.4.1693434569673;
        Wed, 30 Aug 2023 15:29:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id z14-20020aa785ce000000b00689f10adef9sm75552pfn.67.2023.08.30.15.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 15:29:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qbTgk-008hir-1m;
        Thu, 31 Aug 2023 08:29:26 +1000
Date:   Thu, 31 Aug 2023 08:29:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH v2] xfs: load uncached unlinked inodes into memory on
 demand
Message-ID: <ZO/Cxj1QCvi8Bsq6@dread.disaster.area>
References: <20230830152659.GJ28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830152659.GJ28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 30, 2023 at 08:26:59AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> shrikanth hegde reports that filesystems fail shortly after mount with
> the following failure:
> 
> 	WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
> 
> This of course is the WARN_ON_ONCE in xfs_iunlink_lookup:
> 
> 	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> 	if (WARN_ON_ONCE(!ip || !ip->i_ino)) { ... }
> 
> From diagnostic data collected by the bug reporters, it would appear
> that we cleanly mounted a filesystem that contained unlinked inodes.
> Unlinked inodes are only processed as a final step of log recovery,
> which means that clean mounts do not process the unlinked list at all.
> 
> Prior to the introduction of the incore unlinked lists, this wasn't a
> problem because the unlink code would (very expensively) traverse the
> entire ondisk metadata iunlink chain to keep things up to date.
> However, the incore unlinked list code complains when it realizes that
> it is out of sync with the ondisk metadata and shuts down the fs, which
> is bad.
> 
> Ritesh proposed to solve this problem by unconditionally parsing the
> unlinked lists at mount time, but this imposes a mount time cost for
> every filesystem to catch something that should be very infrequent.
> Instead, let's target the places where we can encounter a next_unlinked
> pointer that refers to an inode that is not in cache, and load it into
> cache.
> 
> Note: This patch does not address the problem of iget loading an inode
> from the middle of the iunlink list and needing to set i_prev_unlinked
> correctly.
> 
> Reported-by: shrikanth hegde <sshegde@linux.vnet.ibm.com>
> Triaged-by: Ritesh Harjani <ritesh.list@gmail.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: log that we're doing runtime recovery, dont mess with DONTCACHE,
>     and actually return ENOLINK
> ---
>  fs/xfs/xfs_inode.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/xfs/xfs_trace.h |   25 +++++++++++++++++
>  2 files changed, 96 insertions(+), 4 deletions(-)

This version looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
