Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B521C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Feb 2022 22:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386296AbiBHWYb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Feb 2022 17:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386590AbiBHU4s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Feb 2022 15:56:48 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B582DC0612B9
        for <linux-xfs@vger.kernel.org>; Tue,  8 Feb 2022 12:56:44 -0800 (PST)
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 988A310C68C9;
        Wed,  9 Feb 2022 07:56:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nHXXU-009hEQ-MP; Wed, 09 Feb 2022 07:56:40 +1100
Date:   Wed, 9 Feb 2022 07:56:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Sean Caron <scaron@umich.edu>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: XFS disaster recovery
Message-ID: <20220208205640.GJ59729@dread.disaster.area>
References: <CAA43vkVeMb0SrvLmc8MCU7K8yLUBqHOVk3=JGOi+KDh3zs9Wfw@mail.gmail.com>
 <20220201233312.GX59729@dread.disaster.area>
 <CAA43vkUQ2fb_BEO1oB=bcrsGdcFTxZxyAFUVmLwvkRiobF8EYA@mail.gmail.com>
 <20220207223352.GG59729@dread.disaster.area>
 <CAA43vkWz4ftLGuSvkUn3GFuc=Ca6vLqJ28Nc_CGuTyyNVtXszA@mail.gmail.com>
 <20220208015115.GI59729@dread.disaster.area>
 <CAA43vkXTkCJtM-kQO=GAX=TnAFkD_atygSw4scCwQ8Y-sJZsoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA43vkXTkCJtM-kQO=GAX=TnAFkD_atygSw4scCwQ8Y-sJZsoQ@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6202d90b
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=YbSQJlk7lLm4R3f1oWgA:9 a=CjuIK1q_8ugA:10 a=igBNqPyMv6gA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 08, 2022 at 10:46:45AM -0500, Sean Caron wrote:
> Hi Dave,
> 
> I'm sorry for some imprecise language. The array is around 450 TB raw
> and I will refer to it as roughly half a petabyte but factoring out
> RAID parity disks and spare disks it should indeed be around 384 TB
> formatted.

Ah, OK, looks like it was a complete dump, then.

> I found that if I ran the dev tree xfs_repair with the -P option, I
> could get xfs_repair to complete a run. It exits with return code 130
> but the resulting loopback image filesystem is mountable and I see
> around 27 TB in lost+found which would represent around 9% loss in
> terms of what was actually on the filesystem.

I'm sure that if that much ended up in lost+found, xfs_repair also
threw away a whole load of metadata which means data will have been
lost. And with this much metadata corruption occurring, it tends to
imply that there will be widespread data corruption, too.  Hence I
think it's worth pointing out (maybe unnecessarily!) that xfs_repair
doesn't tell you about (or fix) data corruption - it just rebuilds
the metadata back into a consistent state.

> Given where we started I think this is acceptable (more than
> acceptable, IMO, I was getting to the point of expecting to have to
> write off the majority of the filesystem) and it seems like a way
> forward to get the majority of the data off this old filesystem.

Yes, but you are still going to have to verify the data you can
still access is not corrupted - random offsets within files could
now contain garbage regardless of whether the file was moved to
lost+found or not.

> Is there anything further I should check or any caveats that I should
> bear in mind applying this xfs_repair to the real filesystem? Or does
> it seem reasonable to go ahead, repair this and start copying off?

Seems reasonable to repeat the process on the real filesystem, but
given the caveat about data corruption above, I suspect that the
entire dataset on the filesystem might still end up being a complete
write-off.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
