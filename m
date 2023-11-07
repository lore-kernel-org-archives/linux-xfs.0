Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2068DC41535
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Nov 2023 17:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbjKGRA0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Nov 2023 12:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjKGRAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Nov 2023 12:00:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08C893
        for <linux-xfs@vger.kernel.org>; Tue,  7 Nov 2023 09:00:22 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D68BC433C7;
        Tue,  7 Nov 2023 17:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699376422;
        bh=kZ5ZR9oDEDplAutxKoJILzZ67UIowTGMj0kxr9eOKww=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PMgH5P+GXfq3iwE+x6oWGJs8pLrfBlWAWZc+Qh0dXClWvhNRgFQJngFZZb0Yt/4Q1
         qT8tk9YybzsN8IgeXh0QEmXAgbZbdohlCrsnFVC8M2pp6eDcF5quCh8HnR7IIcWHPW
         ycHWnbbGacFpv/AENnc5FHx0C/NdYcrNKElzpdMqOoho89wvroYsMx4Gs7gZSbfl1U
         /+OhblFJ55Kq3ViyoSx0z0LKnhufZuU/QxNj075x4/mHcRp4zYvi3CDnwmnBKWlchA
         l0QjOoOz1xi7zLpbCqXV+FTFke2tL73tzo9YAkfjpy0qcxrr8CrzgDxKPv5v7zV02c
         SNIfvSP8ir+UA==
Date:   Tue, 7 Nov 2023 09:00:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs_scrub.service: reduce CPU usage to 60% when
 possible
Message-ID: <20231107170021.GM1205143@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
 <168506074536.3746099.6775557055565988745.stgit@frogsfrogsfrogs>
 <ZUn6WQslIFg+0Vc4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUn6WQslIFg+0Vc4@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 12:50:33AM -0800, Christoph Hellwig wrote:
> On Thu, May 25, 2023 at 06:55:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Currently, the xfs_scrub background service is configured to use -b,
> > which means that the program runs completely serially.  However, even
> > using 100% of one CPU with idle priority may be enough to cause thermal
> > throttling and unwanted fan noise on smaller systems (e.g. laptops) with
> > fast IO systems.
> > 
> > Let's try to avoid this (at least on systemd) by using cgroups to limit
> > the program's usage to 60% of one CPU and lowering the nice priority in
> > the scheduler.  What we /really/ want is to run steadily on an
> > efficiency core, but there doesn't seem to be a means to ask the
> > scheduler not to ramp up the CPU frequency for a particular task.
> > 
> > While we're at it, group the resource limit directives together.
> 
> Een 60% sounds like a lot to me, at least for systems that don't have
> a whole lot of cores.  Of course there really isn't any good single
> answer.  But this is probably a better default than the previous one,

Agreed, CPUQuota is an overbroad knob.

On my 40-core servers, 60% of one CPU is very feeble and scrubs could
actually go faster.

For laptops and NUCs, 60% was the figure I came up with by running
xfs_scrub on all the laptops and NUCs I could find, and ratcheting down
the cpu usage until just below the point where the fans would speed up
and/or stuttering was no longer noticeable.

I pulled out some ancient craptops for that one.  On a Pentium III 700
with 256M of RAM and a slow PATA SSD the experience wasn't any more
terrible than you'd expect from that era of machine.  That may become
moot if Debian 13 drops support for bare metal i386.

> so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the reviews!

--D

