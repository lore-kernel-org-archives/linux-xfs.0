Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE910C4167B
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 18:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjKJSC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235039AbjKJSBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 13:01:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491AB83E3
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 23:17:18 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9273EC433CC;
        Fri, 10 Nov 2023 04:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699591734;
        bh=l6vYhHxtTopAmg7TzRG+pm8oCaPwz+RGGXZ+7KxSYVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpcTPmtALoiyUJikEEzVNdskb2igng0l3HbaSW4+lX/J7Fy3HNchDInJPg3H3G/9m
         0stU4hjigqk0EahrUkg7rMX49jFes8IQiwddNa9tkRU5ilPeaTN6wAhpYbeUEgSq79
         BXLwlix25XwAE2PwzDAWaVSGIxewdmaqb0ZdDGuVq5KkDHKglVc1my1yB1jMkETUtN
         or8q5d/MvU60ZkyMrmMFYq97axsiih3DwQKaznpdQmTKQQRGToKaVAGfvc342uBNDI
         mIBVLfkkLp9SVl+hDW07N/6TJa3YsBs3aY5qu12LNN1euLxRqGvVtSVmIp2IVLsWdL
         XpJ6C7u2yfj9A==
Date:   Thu, 9 Nov 2023 20:48:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     zlang@redhat.com, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET v27.0 0/2] fstests: FIEXCHANGE is now an XFS ioctl
Message-ID: <20231110044854.GF1203404@frogsfrogsfrogs>
References: <169947992096.220003.8427995158013553083.stgit@frogsfrogsfrogs>
 <20231109052106.GA29241@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109052106.GA29241@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 06:21:06AM +0100, Christoph Hellwig wrote:
> On Wed, Nov 08, 2023 at 01:45:20PM -0800, Darrick J. Wong wrote:
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> 
> Isn't the branch all new?
> 
> Anyway, this fixes skipping the tests when not supported, and runs them
> fine when supported:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Christoph Hellwig <hch@lst.de>

Thanks!

> although I wonder a bit if keeping functionality not actually supported
> upstream in upstream xfstests is such a good idea.  Keeping it in
> a development branch for the feature seems more flexible to me.  I guess
> there is no point doing a forth and back for this one now, but maybe
> should be more careful in the future.

At the time Zorro proposed merging all the remaining online fsck tests I
didn't think review of the kernel patches was going to continue on for
years.

--D
