Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049F8C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Feb 2022 21:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241070AbiBWVKi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Feb 2022 16:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiBWVKh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Feb 2022 16:10:37 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36444DF79
        for <linux-xfs@vger.kernel.org>; Wed, 23 Feb 2022 13:10:09 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C793F10E1FD5;
        Thu, 24 Feb 2022 08:10:07 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nMyti-00Fbj0-Lp; Thu, 24 Feb 2022 08:10:06 +1100
Date:   Thu, 24 Feb 2022 08:10:06 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Emmanuel Florac <eflorac@intellique.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: experience with very large filesystems
Message-ID: <20220223211006.GL59715@dread.disaster.area>
References: <20220223163513.43f1f054@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223163513.43f1f054@harpe.intellique.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6216a2b1
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=oGFeUVbbRNcA:10 a=7-415B0cAAAA:8
        a=uNa512s-Ul_eXjojblQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 23, 2022 at 04:35:13PM +0100, Emmanuel Florac wrote:
> Hi everyone,
> 
> I have a large filesystem (1.2 PiB) that's been working flawlessly for
> 4 years (an LV aggregating 4 300~ish TB RAID-6 arrays). However it's
> getting really full (more than 1.1 PiB full right now), and I'm
> considering expanding it to 1.8 PiB or more.
> 
> Any thoughts, caveats or else?

From the filesystem side, that should not be an issue at all.

From the storage side, you really want to expand the storage with
chunks that have the same geometry (stripe unit and stripe width)
so that it doesn't screw up the alignment of the filesystem to the
new storage.

And that's where the difficultly may lie. If the existing storage
volume the filesystem sits on doesn't end exactly on a stripe width
boundary, you're going to have to offset the start of the new
storage volumes part way into the first stripe width in the volumes
to ensure that when the filesystem expands, then end of the first
stripe width in the new volume is exactly where the filesystem
expects it to be.

Other than that, there shouldn't be any filesystem level concerns
about doubling the size of the filesystem capacity via growfs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
