Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D1AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 20:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C06461360
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Oct 2021 20:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhJSUqf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Oct 2021 16:46:35 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:42622 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhJSUqe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Oct 2021 16:46:34 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E0E7410676C3;
        Wed, 20 Oct 2021 07:44:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mcvy6-008AeS-8z; Wed, 20 Oct 2021 07:44:18 +1100
Date:   Wed, 20 Oct 2021 07:44:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: Small project: Make it easier to upgrade root fs (i.e. to
 bigtime)
Message-ID: <20211019204418.GZ2361455@dread.disaster.area>
References: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5d00665-ff40-cd6a-3c5c-a022341c3344@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=616f2e24
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=VbAmCkqHifFVU0eH:21 a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=7-415B0cAAAA:8
        a=3JvJZtPct09sYUzoJmAA:9 a=CjuIK1q_8ugA:10 a=R2vQe2jS879yGFxeywUq:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 19, 2021 at 10:18:31AM -0500, Eric Sandeen wrote:
> Darrick taught xfs_admin to upgrade filesystems to bigtime and inobtcount, which is
> nice! But it operates via xfs_repair on an unmounted filesystem, so it's a bit tricky
> to do for the root fs.
> 
> It occurs to me that with the /forcefsck and /fsckoptions files[1], we might be able
> to make this a bit easier. i.e. touch /forcefsck and add "-c bigtime=1" to /fsckoptions,
> and then the initrd/initramfs should run xfs_repair with -c bigtime=1 and do the upgrade.

Does that happen before/after swap is enabled?

What problems can arise from a failed repair here?

Also, ISTR historical problems with doing initrd based root fs
operations because it's not uncommon for the root filesystem to fail
to cleanly unmount on shutdown.  i.e. it can end up not having the
unmount record written because shutdown finishes with the superblock
still referenced. Hence the filesystem has to be mounted and the log
replayed before repair can be run on it....

> However ... fsck.xfs doesn't accept that option, and doesn't pass
> it on to repair, so that doesn't work.
> 
> It seems reasonable to me for fsck.xfs, when it gets the "-f"
> option via init, and the special handling we do already to
> actually Do Something(tm)[2], we could then also pass on any
> additional options we got via the /fsckoptions method.
> 
> Does anyone see a problem with this?  If not, would anyone like to
> take this on as a small project?

As long as it doesn't result in an unbootable system on failure, it
sounds like a good idea to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
