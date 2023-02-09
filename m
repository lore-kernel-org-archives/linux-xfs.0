Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D5DC05027
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Feb 2023 05:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBIFni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Feb 2023 00:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIFni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 00:43:38 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E341731
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 21:43:37 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id x31so884196pgl.6
        for <linux-xfs@vger.kernel.org>; Wed, 08 Feb 2023 21:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uebf0zsI8KonnqlyG5Qgn+NV6kFxozx00UYig4JUA/o=;
        b=7l5TuVZGvbQdPzWsZH6/Wt5KccV0rzK/Xxkp90hqL4tJvGGTv4cMLXrdQcBLolqEln
         z0Y7/eYk3uUyXu5zvfHd6ETID5lkcUofPuCh+/kXD1LzBEZFPXe8aduDsx01pcEC3YlC
         5Ul8IYBW+C0Y0wxbgAWP9hDJduoqRU/DNQsx3jT5TkVFy9Bc8VSk91XvEJkf25KSCH0B
         i04+2yltwdoqzOOxJnUgbRFacbqC9jt3QrSn4LUm5IDOmoIL3o0JXJi2wR4QRDBGKS9q
         bA0v+dYPV3TAfFETnSw0/ePlgRHH66FAhDYqqmpR5nFxaixgi/JsEc1d7jFkR3Lm04vi
         Q1/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uebf0zsI8KonnqlyG5Qgn+NV6kFxozx00UYig4JUA/o=;
        b=F51xWh93EcdyvTtb3uAF3AAwkPAAMq//Q103ihn49+wA+pTVMZagLorV4dESNCdDUc
         IOUmBx5aRclvrG/dTllV/EaLZw5mJ1n9f2gnzBlq9K1EPHGHQjdVP2SwmJVffxxVHGHS
         teUaa1vMowyuq3dJGw8HQ9i/fIKN44nAc+Jnm5IW6/bNIbwjnokbG1NqJZegTu9yNyth
         KC+PU93W0fJQbCYrpaXH49rbWSPKWm618q8t5EhvVsFhgRd3FybwXw2Ug1pIs2daFxNd
         TcnpMf97HV7Yzigieef6QlcwUxZgTEEifiaRPRbzZlhZqjJ0FePH7UbRpvFRnbGQuJwf
         0Mbg==
X-Gm-Message-State: AO0yUKX7zacV9yg8aIW4MBeW5sp+/Jv5xVqlstXqCgMJyJSxQ7pDKZNK
        qjNSfGr4ymwAelcI7Idb4PTV31vkop4EKMjv
X-Google-Smtp-Source: AK7set8ltaZK9jQNV7IDAtDzCfjVyUULE1GYcuprYW+Rk0u7nMT6sjHXoqMp+TP+FUYkdLtS4tl6ng==
X-Received: by 2002:a62:6101:0:b0:575:b783:b6b3 with SMTP id v1-20020a626101000000b00575b783b6b3mr8085434pfb.28.1675921416913;
        Wed, 08 Feb 2023 21:43:36 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id z9-20020aa791c9000000b0059416691b64sm457589pfa.19.2023.02.08.21.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 21:43:36 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPziX-00D7Vv-ND; Thu, 09 Feb 2023 16:43:33 +1100
Date:   Thu, 9 Feb 2023 16:43:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Xiaole He <hexiaole1994@126.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org, dchinner@redhat.com,
        chandan.babu@oracle.com, huhai@kylinos.cn, zhangshida@kylinos.cn,
        Xiaole He <hexiaole@kylinos.cn>
Subject: Re: [PATCH v1 2/2] libxfs: fix reservation space for removing
 transaction
Message-ID: <20230209054333.GE360264@dread.disaster.area>
References: <20230209031637.19026-1-hexiaole1994@126.com>
 <20230209031637.19026-2-hexiaole1994@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209031637.19026-2-hexiaole1994@126.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 09, 2023 at 11:16:37AM +0800, Xiaole He wrote:
> In libxfs/xfs_trans_resv.c:
> 
> /* libxfs/xfs_trans_resv.c begin */
>  1 /*
>  2  * For removing a directory entry we can modify:
>  3  *    the parent directory inode: inode size
>  4  *    the removed inode: inode size
>  5  *    the directory btree could join: (max depth + v2) * dir block size
>  6  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
>  7  * And the bmap_finish transaction can free the dir and bmap blocks giving:
>  8  *    the agf for the ag in which the blocks live: 2 * sector size
>  9  *    the agfl for the ag in which the blocks live: 2 * sector size
> 10  *    the superblock for the free block count: sector size
> 11  ...
> 12  */
> 13 STATIC uint
> 14 xfs_calc_remove_reservation(
> 15         struct xfs_mount        *mp)
> 16 {
> 17         return XFS_DQUOT_LOGRES(mp) +
> 18                 xfs_calc_iunlink_add_reservation(mp) +
> 19                 max((xfs_calc_inode_res(mp, 2) +
> 20                      xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
> 21                                       XFS_FSB_TO_B(mp, 1))),
> 22                     (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
> 23 	...
> 24 }
> /* libxfs/xfs_trans_resv.c end */
> 
> Above lines 8-10 indicates there has 5 sector size of space to be
> reserved, but the above line 22 only reserve 4 sector size of space,

We don't log the superblock when lazycount=1 (i.e. default behaviour
for all v5 filesystems and almost all v4 filesystems created in the
last 15 years). Hence a count of 4 is actually correct for almost
all the production XFS filesystems out there.

Even ignoring that little detail, I don't think the comment you are
referencing reflects how extent freeing works these days. There is
no "bmap_finish" transaction in a directory entry remove operation
anymore - that was replaced long ago by generic intent-based
deferred log operations. Those deferred ops only process a single
extent freeing at a time (i.e. inserting a single new freespace
extent into the freespace btrees), so I don't think this comment
reflects reality anymore.

Now that we have minimum 64MB log sizes in mkfs, and a historical
reservation calculation for min log size calculations, we can reduce
the transaction reservation sizes down to match the current reality
without having to care about it changing minimum log sizes.

Hence I think it's time we actually fixed these "bmap_finish
multiple extent free" over-estimations to reflect the current
reality of only processing a single extent per intent. That means
fixing the comments and the code. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
