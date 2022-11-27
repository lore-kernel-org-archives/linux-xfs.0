Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1795C43217
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Nov 2022 18:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiK0Spf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Nov 2022 13:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiK0Spf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Nov 2022 13:45:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7ECDFA9
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2022 10:45:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C413C60DBA
        for <linux-xfs@vger.kernel.org>; Sun, 27 Nov 2022 18:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E98C433C1;
        Sun, 27 Nov 2022 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669574733;
        bh=VPlrlb2BNc1yVjKMgrFpqZdWERbaQE52RNQGAopZAlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y/BJJm6MVKtGhXpymoecCkDPMTGc8FK01mZsimTeYJ6njq0p+puJZJI7hXzTiqu4W
         jVIWDknE0PsGXtbQFSh9W4nyB3z7EafjFw6VJwARdBFFAB5qHR/U8IbPnCc9lWgNDX
         fhoev6615ZuSVuGXFYLeMsNhbJTA+7IxjuV2QnMQvs7FjpXIURcglK0UISOilDLiWx
         ZgqUQW767FJ6Q0Z9a0KVHX67H+X88K04U/JMVi92uCbFgpiPJTpQ1tUgPToJkHxLwL
         PbpWg9auk4A2jI25Eb+0GHbnbHdQUoyEAjXm9++Fy19Ygff86+4dHnIZ0rYv1qMQFt
         I8gwxtKpGCEXA==
Date:   Sun, 27 Nov 2022 10:45:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: moar weird metadata corruptions, this time on arm64
Message-ID: <Y4OwTJ8lH8XLPAgZ@magnolia>
References: <Y3wUwvcxijj0oqBl@magnolia>
 <20221122015806.GQ3600936@dread.disaster.area>
 <Y3579xWtwQEdBFw6@magnolia>
 <20221124044023.GU3600936@dread.disaster.area>
 <Y38TNTspBy9RPuBz@magnolia>
 <Y3+fdyRj6tV9/WZu@magnolia>
 <20221124204455.GV3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124204455.GV3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 25, 2022 at 07:44:55AM +1100, Dave Chinner wrote:
> On Thu, Nov 24, 2022 at 08:44:39AM -0800, Darrick J. Wong wrote:
> > Also, last night's run produced this:
> > 
> > ino 0x140bb3 func xfs_bmapi_reserve_delalloc line 4164 data fork:
> >     ino 0x140bb3 nr 0x0 nr_real 0x0 offset 0xb9 blockcount 0x1f startblock 0x935de2 state 1
> >     ino 0x140bb3 nr 0x1 nr_real 0x1 offset 0xe6 blockcount 0xa startblock 0xffffffffe0007 state 0
> >     ino 0x140bb3 nr 0x2 nr_real 0x1 offset 0xd8 blockcount 0xe startblock 0x935e01 state 0
> > ino 0x140bb3 fork 0 oldoff 0xe6 oldlen 0x4 oldprealloc 0x6 isize 0xe6000
> >     ino 0x140bb3 oldgotoff 0xea oldgotstart 0xfffffffffffffffe oldgotcount 0x0 oldgotstate 0
> >     ino 0x140bb3 crapgotoff 0x0 crapgotstart 0x0 crapgotcount 0x0 crapgotstate 0
> >     ino 0x140bb3 freshgotoff 0xd8 freshgotstart 0x935e01 freshgotcount 0xe freshgotstate 0
> >     ino 0x140bb3 nowgotoff 0xe6 nowgotstart 0xffffffffe0007 nowgotcount 0xa nowgotstate 0
> >     ino 0x140bb3 oldicurpos 1 oldleafnr 2 oldleaf 0xfffffc00f0609a00
> >     ino 0x140bb3 crapicurpos 2 crapleafnr 2 crapleaf 0xfffffc00f0609a00
> >     ino 0x140bb3 freshicurpos 1 freshleafnr 2 freshleaf 0xfffffc00f0609a00
> >     ino 0x140bb3 newicurpos 1 newleafnr 3 newleaf 0xfffffc00f0609a00
> > 
> > The old/fresh/nowgot have the same meaning as yesterday.  "crapgot" is
> > the results of duplicating the cursor at the start of the body of
> > xfs_bmapi_reserve_delalloc and performing a fresh lookup at @off.
> > I think @oldgot is a HOLESTARTBLOCK extent because the first lookup
> > didn't find anything, so we filled in imap with "fake hole until the
> > end".  At the time of the first lookup, I suspect that there's only one
> > 32-block unwritten extent in the mapping (hence oldicurpos==1) but by
> > the time we get to recording crapgot, crapicurpos==2.
> 
> Ok, that's much simpler to reason about, and implies the smoke is
> coming from xfs_buffered_write_iomap_begin() or
> xfs_bmapi_reserve_delalloc(). I suspect the former - it does a lot
> of stuff with the ILOCK_EXCL held.....
> 
> .... including calling xfs_qm_dqattach_locked().
> 
> xfs_buffered_write_iomap_begin
>   ILOCK_EXCL
>   look up icur
>   xfs_qm_dqattach_locked
>     xfs_qm_dqattach_one
>       xfs_qm_dqget_inode
>         dquot cache miss
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>         error = xfs_qm_dqread(mp, id, type, can_alloc, &dqp);
>         xfs_ilock(ip, XFS_ILOCK_EXCL);
>   ....
>   xfs_bmapi_reserve_delalloc(icur)
> 
> Yup, that's what is letting the magic smoke out -
> xfs_qm_dqattach_locked() can cycle the ILOCK. If that happens, we
> can pass a stale icur to xfs_bmapi_reserve_delalloc() and it all
> goes downhill from there.
> 
> > IOWS, I think I can safely eliminate FIEXCHANGE shenanigans and
> > concentrate on finding an unlocked unwritten -> written extent
> > conversion.  Or possibly a written -> unwritten extent conversion?
> > 
> > Anyway, long holiday weekend, so I won't get back to this until Monday.
> > Just wanted to persist my notes to the mailing list so I can move on to
> > testing the write race fixes with djwong-dev.
> 
> And I'm on PTO for the next couple of working days, too, so I'm not
> going to write a patch for it right now, either.

No worries, I made a simple patch and pasted in the email discussion.
After three days of rerunning testing I haven't seen any of the
backtraces that I reported in this thread.  Thanks for your help!

Patch:
https://lore.kernel.org/linux-xfs/Y4OuLTwPVdiHMBGi@magnolia/T/#u

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
