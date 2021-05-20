Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEFAC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D41F6101E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 May 2021 16:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhETQpZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 May 2021 12:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhETQpY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 May 2021 12:45:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D495161019;
        Thu, 20 May 2021 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621529043;
        bh=2SmbF9szjVLPyyg8ZRmsQkkz9uwIXaIv3T0Nm/ncQ3k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXiqZu+lRGVQeoIzzNpCsRRGXNjD9pGOVsm1iVgpsj9RlHG0ggqf1FfTOlWesQ3j5
         XQYPaMSfZhcg4vk4znK9zNUyjyOX0lPGSMleWkViNjg9ViRde5+HNTpBavpJAYQJT8
         5Zqj8dHa2gbzWMgXrAYIpp935p7cNLrzkGjWjm4DJ5yHjjRQAoYiMmLzAzILjr23Y2
         jdKYSFI7kKYGrVtyEVqAR6qSvCtDRSTSlkw4hkFRGRiLFQYX6mCzgI/k5ddbYJq7dX
         S9pB9mKM8X7BmM5/CcmNFSykZKE6riVdNJwvb6ews1qgfLreC4BX9D/iGUCZynovSB
         14Cuf6rf5ANhw==
Date:   Thu, 20 May 2021 09:44:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: regressions in xfs/168?
Message-ID: <20210520164402.GY9675@magnolia>
References: <20210519210205.GT9675@magnolia>
 <20210519222006.GA664593@dread.disaster.area>
 <20210520000802.GV9675@magnolia>
 <20210520082316.GA1782@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520082316.GA1782@hsiangkao-HP-ZHAN-66-Pro-G1>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 04:23:22PM +0800, Gao Xiang wrote:
> Hi Darrick and Dave,
> 
> On Wed, May 19, 2021 at 05:08:02PM -0700, Darrick J. Wong wrote:
> > On Thu, May 20, 2021 at 08:20:06AM +1000, Dave Chinner wrote:
> > > On Wed, May 19, 2021 at 02:02:05PM -0700, Darrick J. Wong wrote:
> > > > Hm.  Does anyone /else/ see failures with the new test xfs/168 (the fs
> > > > shrink tests) on a 1k blocksize?  It looks as though we shrink the AG so
> > > > small that we trip the assert at the end of xfs_ag_resv_init that checks
> > > > that the reservations for an AG don't exceed the free space in that AG,
> > > > but tripping that doesn't return any error code, so xfs_ag_shrink_space
> > > > commits the new fs size and presses on with even more shrinking until
> > > > we've depleted AG 1 so thoroughly that the fs won't mount anymore.
> > > 
> > > Yup, now that I've got the latest fstests I see that failure, too.
> > > 
> > > [58972.431760] Call Trace:
> > > [58972.432467]  xfs_ag_resv_init+0x1d3/0x240
> > > [58972.433611]  xfs_ag_shrink_space+0x1bf/0x360
> > > [58972.434801]  xfs_growfs_data+0x413/0x640
> > > [58972.435894]  xfs_file_ioctl+0x32f/0xd30
> > > [58972.439289]  __x64_sys_ioctl+0x8e/0xc0
> > > [58972.440337]  do_syscall_64+0x3a/0x70
> > > [58972.441347]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [58972.442741] RIP: 0033:0x7f7021755d87
> > > 
> > > > At a bare minimum we probably need to check the same thing the assert
> > > > does and bail out of the shrink; or maybe we just need to create a
> > > > function to adjust an AG's reservation to make that function less
> > > > complicated.
> > > 
> > > So if I'm reading xfs_ag_shrink_space() correctly, it doesn't
> > > check what the new reservation will be and so it's purely looking at
> > > whether the physical range can be freed or not? And when freeing
> > > that physical range results in less free space in the AG than the
> > > reservation requires, we pop an assert failure rather than failing
> > > the reservation and undoing the shrink like the code is supposed to
> > > do?
> > 
> > Yes.  I've wondered for a while now if that assert in xfs_ag_resv_init
> > should get turned into an ENOSPC return so that callers can decide what
> > they want to do with it.
> 
> Thanks for the detailed analysis (sorry that I didn't check the 1k blocksize
> case before), I'm now renting a department in a new city, no xfstests env
> available for now.
> 
> But if I read/understand correctly, the following code might resolve the issue?
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 6c5f8d10589c..1f918afd5e91 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -312,10 +312,12 @@ xfs_ag_resv_init(
>  	if (error)
>  		return error;
>  
> -	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> -	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
> -	       pag->pagf_freeblks + pag->pagf_flcount);
>  #endif
> +	if (xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
> +	    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
> +	    pag->pagf_freeblks + pag->pagf_flcount)
> +		return -ENOSPC;
> +
>  out:
>  	return error;
>  }
> 
> If that works, could you kindly send out it (or some better/sane solution),
> many thanks in advance!

That does seem to fix the symptoms, though I'm gonna take a closer look
at the error handling elsewhere in that function.

--D

> 
> Thanks,
> Gao Xiang
> 
> > 
> > --D
> > 
> > > IOWs, the problem is the ASSERT firing on debug kernels, not the
> > > actual shrink code that does handle this reservation ENOSPC error
> > > case properly? i.e. we've got something like an uncaught overflow
> > > in xfs_ag_resv_init() that is tripping the assert? (e.g. used >
> > > ask)
> > > 
> > > So I'm not sure that the problem is the shrink code here - it should
> > > undo a reservation failure just fine, but the reservation code is
> > > failing before we get there on a debug kernel...
> > > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
