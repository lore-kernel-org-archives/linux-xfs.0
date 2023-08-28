Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D810C83F10
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 05:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjH1FVw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 01:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjH1FVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2023 01:21:42 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D06D12D
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 22:21:34 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a8506f5b73so2120167b6e.0
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 22:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693200093; x=1693804893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Bysmz5K1f1isGlAjF9wNbQh3sg8KLv+xyLr+yDVw5A=;
        b=UNugA+Y1zQXmTigo0+DmIl1K6R9FrsznKHBqRiTqgGH3njhbFQFlh/2dHR1Vh2RR1N
         zCcBbAFdkxV9HlvtN+Jt/uMzLNQInm3mk6Lsz8V+IYXHnhSF+VTyz/dm2ANtFdJjmjDk
         mHZOEw2B0TX/pXnvRFzVJuuC3J6m9Ai0GQxYe36YqW6FgM7EjZLaJN3HSVBGzp4D2515
         ZcnPiK95fY6rF0tGLbArD/KopV68oNOs2Uh1xkgGCDznwqmjCUFXNo1Zzs3udCCy0fTg
         VfJna6iAlO9b6UK1tm7jDJlNf7tacDhdSbG5lLHbjCPbAjbOKqJkPyDdDQhCEvCgIJts
         Kr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693200093; x=1693804893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Bysmz5K1f1isGlAjF9wNbQh3sg8KLv+xyLr+yDVw5A=;
        b=UuI4Tpkbw2LiGjrPOwBcCrYhgn6cmuT3VHwn5YWa76U15ybi7JXltda6dAKUpZYzDb
         JvR2Um9Y5FsPNgEVoEZP2fPfg68g7Bfx277tgKl+EwOtASTwxfCDR8KWU/Q/08vH51dc
         t0/BG87JP9/nfcriShRfZX1c4yiqLlh+MiTTRDMvdQK5K4WmQbm5hlMpSUYtmFirjq8Z
         Q/clAmAQwy5eVgrwdW/c8HPivM9WzL3LgO9RAcH+daHNsdQV24GrDbPdx3AEOVcGSyzf
         rdt3xfFj81s9L9pKfEe2SNz48VRMCgOSJOQBpqBU0z0j6Fuf9MyD5HWcvh7f5f6OASwr
         /cYA==
X-Gm-Message-State: AOJu0Yz/aYocRG8NilpJREkFcxNlR4P8CEqAHRbX+m+eaX3ZulkGsfMF
        iQFBt3BOeGme6qpGhWF9wnkQOQ==
X-Google-Smtp-Source: AGHT+IGwpAUQr1jIDHi5aDfXApmrP3HeTYJtTok/gyj9aVahuEhRcG7esD62DoNNU8iVCULiVaKHRw==
X-Received: by 2002:a05:6808:bcb:b0:3a7:3100:f8b9 with SMTP id o11-20020a0568080bcb00b003a73100f8b9mr11597574oik.31.1693200093613;
        Sun, 27 Aug 2023 22:21:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id a14-20020a62bd0e000000b006875df4773fsm5663182pff.163.2023.08.27.22.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 22:21:33 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qaUgs-007VOW-1U;
        Mon, 28 Aug 2023 15:21:30 +1000
Date:   Mon, 28 Aug 2023 15:21:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cheng.lin130@zte.com.cn
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: introduce protection for drop nlink
Message-ID: <ZOwu2vrzX/0dX89/@dread.disaster.area>
References: <ZOpuadBnaY5QxpVN@dread.disaster.area>
 <202308281129517963677@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202308281129517963677@zte.com.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2023 at 11:29:51AM +0800, cheng.lin130@zte.com.cn wrote:
> > On Sat, Aug 26, 2023 at 10:54:11PM +0800, cheng.lin130@zte.com.cn wrote:
> > > > > In the old kernel version, this situation was
> > > > > encountered, but I don't know how it happened. It was already a scene
> > > > > with directory errors: "Too many links".
> > How do you overflow the directory link count in XFS? You can't fit
> > 2^31 unique names in the directory data segment - the directory will
> > ENOSPC at 32GB of name data, and that typically occurs with at most
> > 300-500 million dirents (depending on name lengths) in the
> > directory.
> > IOWs, normal operation shouldn't be able overflow the directory link
> > count at all, and so underruns shouldn't occur, either.
> Customer's explanation: in the nlink incorrect directory, not many directories
> will be created, and normally there are only 2 regular files.
> And only found this one directory with incorrect nlink when xfs_repair.
>   systemd-fsck[5635]: Phase 2 - using internal log
>   systemd-fsck[5635]: - zero log...
>   systemd-fsck[5635]: - scan filesystem freespace and inode maps...
>   systemd-fsck[5635]: agi unlinked bucket 9 is 73 in ag 22 (inode=23622320201)

So the directory inode is on the unlinked list, as I suggested it
would be.

>   systemd-fsck[5635]: - 21:46:00: scanning filesystem freespace - 32 of 32 allocation groups done
>   systemd-fsck[5635]: - found root inode chunk
>   ...

How many other inodes were repaired or trashed or moved to
lost+found?

>   systemd-fsck[5635]: Phase 7 - verify and correct link counts...
>   systemd-fsck[5635]: resetting inode 23622320201 nlinks from 4294967284 to 2

The link count of the directory inode on the unlinked list was
actually -12, so this isn't an "off by one" error. It's still just 2
adjacent bits being cleared when they shouldn't have been, though.

What is the xfs_info (or mkfs) output for the filesystem that this
occurred on?

.....

> If it's just a incorrect count of one dicrectory, after ignore it, the fs
> can work normally(with error). Is it worth stopping the entire fs
> immediately for this condition?

The inode is on the unlinked list with a non-zero link count. That
means it cannot be removed from the unlinked list (because the inode
will not be freed during inactivation) and so the unlinked list is
effectively corrupt. Anything that removes an inode or creates a
O_TMPFILE or uses RENAME_WHITEOUT can trip over this corrupt
unlinked list and have things go from bad to worse. Hence the
corruption is not limited to the directory inode or operations
involving that directory inode. We generally shut down the
filesystem when this sort of corruption occurs - it needs to be
repaired ASAP, otherwise other stuff will randomly fail and you'll
still end up with a shut down filesystem. Better to fail fast in
corruption cases than try to ignore it and vainly hope that
everything will work out for the best....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
