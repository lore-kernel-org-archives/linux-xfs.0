Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DB5C77B7A
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 01:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjFLBvs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 11 Jun 2023 21:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjFLBvr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Jun 2023 21:51:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87B9115
        for <linux-xfs@vger.kernel.org>; Sun, 11 Jun 2023 18:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45A6F61D59
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jun 2023 01:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95911C433D2;
        Mon, 12 Jun 2023 01:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686534705;
        bh=VTY2Y2P86jVmfsb/6a2QKVQM9KeYPnnGSeUnXShxjys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AnzsjmFOtSWkcw00o3ZI7K4cMQSVs52WtdNjuEZUgCVwVbZcCO2EhyIsaZIOebp1r
         XUIcz6AaObvxxQ4+CleCNgOX9F/vKmmH8Hla+ZoLoXjikykKqzYtr8+9/+SwPPwhjM
         TK1EiOoBgXItGyp8Rb836TfPOHqGwVgw7ruknSdxONhNTrt7qdgH9vTPrGpl4uySEm
         1cfywCp6O7+j5LQH1DdOgdD7+WFB/NYQcPAH+neRrMAHY9pUFFZQLugQRM32CAiw+l
         5jLD2vz9XWLaWgq24xhE4sGrQmgQ4zwYqJeKSP6Jk5l7rRBNxnb0985nx6FNNY6pDI
         mjJdbd7ZZgnLA==
Date:   Sun, 11 Jun 2023 18:51:45 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [Bug report] fstests generic/051 (on xfs) hang on latest linux
 v6.5-rc5+
Message-ID: <20230612015145.GA11441@frogsfrogsfrogs>
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
 <ZIZSPyzReZkGBEFy@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIZSPyzReZkGBEFy@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 12, 2023 at 09:01:19AM +1000, Dave Chinner wrote:
> On Sun, Jun 11, 2023 at 08:48:36PM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > When I tried to do fstests regression test this weekend on latest linux
> > v6.5-rc5+ (HEAD=64569520920a3ca5d456ddd9f4f95fc6ea9b8b45), nearly all
> > testing jobs on xfs hang on generic/051 (more than 24 hours, still blocked).
> > No matter 1k or 4k blocksize, general disk or pmem dev, or any architectures,
> > or any mkfs/mount options testing, all hang there.
> 
> Yup, I started seeing this on upgrade to 6.5-rc5, too. xfs/079
> generates it, because the fsstress process is crashing when the
> XFS filesystems shuts down (maybe a SIGBUS from a mmap page fault?)
> I don't know how reproducable it is yet; these only showed up in my
> thrusday night testing so I haven't had a chance to triage it yet.
> 
> > Someone console log as below (a bit long), the call trace doesn't contains any
> > xfs functions, it might be not a xfs bug, but it can't be reproduced on ext4.
> 
> AFAICT, the coredump is being done on the root drive (where fsstress
> is being executed from), not the XFS test/scratch devices that
> fsstress processes are exercising. I have ext3 root drives for my
> test machines, so at this point I'm not sure that this is even a
> filesystem related regression. i.e. it may be a recent regression in
> the coredump or signal handling code....

Willy was complaining about the same thing on Friday.  Oddly I've not
seen any problems with coredumps on 6.4-rc5, so .... <shrug>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
