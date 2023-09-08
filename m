Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65B5EEB570
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Sep 2023 23:55:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjIHXz1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 19:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjIHXzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2023 19:55:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E93E18E
        for <linux-xfs@vger.kernel.org>; Fri,  8 Sep 2023 16:55:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F52C433C7;
        Fri,  8 Sep 2023 23:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694217321;
        bh=TM8M1AwKw74n1VveYVhOHSRBpiZumSmyTCpLifrbaCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQ0WLWpuplA/Wa1CrdSyHOG1MyPapgZ7shnqAftx5AbQAPVlmv3Y+spiYMn/dB9B5
         ax7yEyEMDVUWrxGrTE/AB/+fUTq+VIDJEhdDEMcgNlf1j9wdWrVG1L83Lc4KzaZmHo
         8e7VwDgTiyHruCDdjNohxFV0t00lxDod5Lq2n6yzzidB7E4PMAT2e5qwsybTPMwhtd
         RSzVwyz8ithL5O/Lk890vrwssEN+aun2QqJW6C+1DQqK/IrNF55RN0/L0b/YdnBnfI
         R6cQBQRsxVnqNe4YFIEzUt+SMAF/fct7fPbFIT8tBmCl0Kh1qaG7nadUwILy62lTj0
         yzYSc+1jn9Sgg==
Date:   Fri, 8 Sep 2023 16:55:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: correct calculation for blockcount
Message-ID: <20230908235521.GO28202@frogsfrogsfrogs>
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
 <26b057ea-c373-4df5-9d7e-cf56d78844a5@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26b057ea-c373-4df5-9d7e-cf56d78844a5@fujitsu.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 08, 2023 at 06:18:52PM +0800, Shiyang Ruan wrote:
> Ping~
> 
> 在 2023/8/28 15:24, Shiyang Ruan 写道:
> > The blockcount, which means length, should be "end + 1 - start".  So,
> > add the missing "+1" here.
> > 
> > Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
> > Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> > ---
> >   fs/xfs/xfs_notify_failure.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> > index 4a9bbd3fe120..459fc8a39635 100644
> > --- a/fs/xfs/xfs_notify_failure.c
> > +++ b/fs/xfs/xfs_notify_failure.c
> > @@ -151,7 +151,7 @@ xfs_dax_notify_ddev_failure(
> >   		agend = min(be32_to_cpu(agf->agf_length),
> >   				ri_high.rm_startblock);

I don't understand this.  ri_high.rm_startblock should be the last agbno
for which we want rmapbt mappings.  If agf_length is 100, then don't we
want to be clamping agend to 99, not 100?  Block 99 is the last block in
an AG.

	agend = min(be32_to_cpu(agf->agf_length) - 1,
		    ri_high.rm_startblock);

If we do the above...

> >   		notify.startblock = ri_low.rm_startblock;
> > -		notify.blockcount = agend - ri_low.rm_startblock;
> > +		notify.blockcount = agend + 1 - ri_low.rm_startblock;

...then this actually makes sense.

> >   		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
> >   				xfs_dax_failure_fn, &notify);

Sorry I've been kinda slow to respond.

--D
