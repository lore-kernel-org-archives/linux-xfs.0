Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B86C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 01:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiBHByA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Feb 2022 20:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241704AbiBHBxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Feb 2022 20:53:41 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 795EAC001F6C
        for <linux-xfs@vger.kernel.org>; Mon,  7 Feb 2022 17:51:19 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 14E3B52C6A5;
        Tue,  8 Feb 2022 12:51:16 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nHFf1-009Nih-AF; Tue, 08 Feb 2022 12:51:15 +1100
Date:   Tue, 8 Feb 2022 12:51:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS disaster recovery
Message-ID: <20220208015115.GI59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
 <20220207223352.GG59729@dread.disaster.area>
 <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6201cc95
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=Mlme3SV-JDJkysWT7FoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 07, 2022 at 05:56:21PM -0500, Sean Caron wrote:
> Got it. I ran an xfs_repair on the simulated metadata filesystem and
> it seems like it almost finished but errored out with the message:
> 
> fatal error -- name create failed in lost+found (28), filesystem may
> be out of space

Not a lot to go on there - can you send me the entire reapir output?

> However there is plenty of space on the underlying volume where the
> metadata dump and sparse image are kept. Even if the sparse image was
> actually 384 TB as it shows up in "ls", there's 425 TB free on the
> volume where it's kept.

Hmmm - the sparse image should be the same size as the filesystem
itself. If it's only 384TB and not 500TB, then either the metadump
or the restore may not have completed fully.

> I wonder since this was a fairly large filesystem (~500 TB) it's
> hitting some kind of limit somewhere with the loopback device?

Shouldn't - I've used larger loopback files hostsed on XFS
filesystems in the past.

> Any thoughts on how I might be able to move past this? I guess I will
> need to xfs_repair this filesystem one way or the other anyway to get
> anything off of it, but it would be nice to run the simulation first
> just to see what to expect.

I think that first we need to make sure that the metadump and
restore process was completed successfully (did you check the exit
value was zero?). xfs_db can be used to do that:

# xfs_db -r <image-file>
xfs_db> sb 0
xfs_db> p agcount
<val>
xfs_db> agf <val - 1>
xfs_db> p
.....
(should dump the last AGF in the filesystem)

If that works, then the metadump/restore should have been complete,
and the size of the image file should match the size of the
filesystem that was dumped...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
