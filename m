Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A853C7EE2E
	for <linux-xfs@archiver.kernel.org>; Sat, 27 May 2023 22:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjE0WTq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 May 2023 18:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjE0WTq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 May 2023 18:19:46 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A282D9
        for <linux-xfs@vger.kernel.org>; Sat, 27 May 2023 15:19:44 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1b010338d82so12901525ad.0
        for <linux-xfs@vger.kernel.org>; Sat, 27 May 2023 15:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1685225984; x=1687817984;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rVMc0I5sM3GKqgbVNxbWT1G3x4/GVIgLdFMMjfYEMoE=;
        b=V9xZHiShMzhZxfs6Fswj+tw/Y4JNt+rAWCe33CSU5YC7Jpe/55PPIg7O2fDd+sctYn
         7Y1+z0hw8oVsN51Hvq8owaPsSD+Oa2Y9r2WkR1qLZfCBTsK74XQfaEdzxzY5WITXMorv
         6Z+LsIHRX4hEOOOpxLyuq+8QehX5Xw3iEQYIiP7o4w1d5vVyivPTs4gRNRS2H+tLhGml
         pyLHbxKHTGz96qRZm53q43JwRoE6xbyfmJxW+C8haGHo7VW8bd1ZjiUB93Fnc4wn5ywD
         KQ36br0iFPbgItlK/s8j18i5a3Mors79TrdmlnDLjzOjO0rnizNmnQp08zHU62g0PNon
         zZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685225984; x=1687817984;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVMc0I5sM3GKqgbVNxbWT1G3x4/GVIgLdFMMjfYEMoE=;
        b=lnZT+XKXIGfOc+FuU+QiqSgKlyjdyS6/pBQSZYuTcARasan4i05HQPKuUtzhUVpciw
         aJm7eib7p9SsIxBPv6g8N4mEyoItnzcN68QUVvxalhbBbiVGt5d5IqWwlQR4zaIJtwkn
         f3bSFygsClhyhOf8ilmN+hSG7/epyCj0cPOJdPva118UTSns93Qk1asA2xFjtVoVlSJc
         Lc9BLKfK16MZQqwLvwdB4u6oPiOi6V16X/rONkKxSQAGb2dU1oCsQw2Zmq+vDuSDTzMl
         vNBxveA8g7w4vjcIZ2zDgQ/74RxASz0FfOMzyYh1Y4ZtYmuq0nN+yUzfCNxU2MRxDeXT
         ef9Q==
X-Gm-Message-State: AC+VfDw1KDTISQlkdu9tZjYv2EJ4+OaOqa9NiKg5V8CmIIvyH86LJRoq
        Otb9C7ryQjyoa+va2ATmNRq8soezFanjoDfDiWU=
X-Google-Smtp-Source: ACHHUZ6Tn/pUMpnG5bwWM5/02pkLy9abkWRKc8QTwQmU+v6QQ/nDnnUL7ZpjROxRBe8s8S5gWoF7pA==
X-Received: by 2002:a17:902:d4ca:b0:1ac:6c46:8c80 with SMTP id o10-20020a170902d4ca00b001ac6c468c80mr8639630plg.53.1685225983733;
        Sat, 27 May 2023 15:19:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902748a00b001b0395c3ffasm79962pll.180.2023.05.27.15.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 15:19:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q32GC-004go9-0H;
        Sun, 28 May 2023 08:19:40 +1000
Date:   Sun, 28 May 2023 08:19:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, linux-xfs@vger.kernel.org
Subject: [PATCH, STABLE 6.3.x] xfs: fix livelock in delayed allocation at
 ENOSPC
Message-ID: <ZHKB/KD1yyx77fop@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Greg,

A regression in 6.3.0 has been identified in XFS that causes
filesystem corruption.  It has been seen in the wild by a number of
users, and bisected down to an issued we'd already fixed in 6.4-rc1
with commit:

9419092fb263 ("xfs: fix livelock in delayed allocation at ENOSPC")

This was reported with much less harmful symptoms (alloctor
livelock) and it wasn't realised that it could have other, more
impactful symptoms. A reproducer for the corruption was found
yesterday and, soon after than, the cause of the corruption reports
was identified.

The commit applies cleanly to a 6.3.0 kernel here, so it should also
apply cleanly to a current 6.3.x kernel. I've included the entire
commit below in case that's easier for you.

Can you please pull this commit into the next 6.3.x release as a
matter of priority?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: fix livelock in delayed allocation at ENOSPC

From: Dave Chinner <dchinner@redhat.com>

On a filesystem with a non-zero stripe unit and a large sequential
write, delayed allocation will set a minimum allocation length of
the stripe unit. If allocation fails because there are no extents
long enough for an aligned minlen allocation, it is supposed to
fall back to unaligned allocation which allows single block extents
to be allocated.

When the allocator code was rewritting in the 6.3 cycle, this
fallback was broken - the old code used args->fsbno as the both the
allocation target and the allocation result, the new code passes the
target as a separate parameter. The conversion didn't handle the
aligned->unaligned fallback path correctly - it reset args->fsbno to
the target fsbno on failure which broke allocation failure detection
in the high level code and so it never fell back to unaligned
allocations.

This resulted in a loop in writeback trying to allocate an aligned
block, getting a false positive success, trying to insert the result
in the BMBT. This did nothing because the extent already was in the
BMBT (merge results in an unchanged extent) and so it returned the
prior extent to the conversion code as the current iomap.

Because the iomap returned didn't cover the offset we tried to map,
xfs_convert_blocks() then retries the allocation, which fails in the
same way and now we have a livelock.

Reported-and-tested-by: Brian Foster <bfoster@redhat.com>
Fixes: 85843327094f ("xfs: factor xfs_bmap_btalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1a4e446194dd..b512de0540d5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3540,7 +3540,6 @@ xfs_bmap_btalloc_at_eof(
 	 * original non-aligned state so the caller can proceed on allocation
 	 * failure as if this function was never called.
 	 */
-	args->fsbno = ap->blkno;
 	args->alignment = 1;
 	return 0;
 }
