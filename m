Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBF1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiDGBue (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiDGBud (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:50:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC01231787
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 06C7CCE25B2
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61830C385A3;
        Thu,  7 Apr 2022 01:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649296109;
        bh=PdHqQU5aak0Y1gmhcpUQvLLh7WTvJk/r6HoQY+c7Agk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ruyOKNKUJ65tARiZjUbYn6Yr9ifxNXNLNBp9mvjliARbudy/SRSRoxrUhmAO5F3oo
         p/J3eVJsaYyUwqL6XqqNmxTBgYwJZE+Uv3Yu3cULc5hvVf2Gt/CkrLVwv+7cn5M6JD
         7fyBn6gG8NLh4QnIdYgi567OKMQslnL3NwoXi8OApXaifFlRv43bd++ELpJqrFig/H
         eEumn32dBJosL0Ccn8zshCjHnju+CsQAbSKg5230qbmiLs/RHJSx35MLPPATJ2aMUZ
         Xt6bt1CbZnxEY6L/WZOkp5SGBCMWftm38LDyS1vWDNjfva1l2PgRrCPumo4KY4epAE
         Be2FnDTrT9DCg==
Date:   Wed, 6 Apr 2022 18:48:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V9 15/19] xfs: Directory's data fork extent counter can
 never overflow
Message-ID: <20220407014828.GX27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-16-chandan.babu@oracle.com>
 <20220407011311.GE1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407011311.GE1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 11:13:11AM +1000, Dave Chinner wrote:
> On Wed, Apr 06, 2022 at 11:48:59AM +0530, Chandan Babu R wrote:
> > The maximum file size that can be represented by the data fork extent counter
> > in the worst case occurs when all extents are 1 block in length and each block
> > is 1KB in size.
> > 
> > With XFS_MAX_EXTCNT_DATA_FORK_SMALL representing maximum extent count and with
> > 1KB sized blocks, a file can reach upto,
> > (2^31) * 1KB = 2TB
> > 
> > This is much larger than the theoretical maximum size of a directory
> > i.e. XFS_DIR2_SPACE_SIZE * 3 = ~96GB.
> > 
> > Since a directory's inode can never overflow its data fork extent counter,
> > this commit removes all the overflow checks associated with
> > it. xfs_dinode_verify() now performs a rough check to verify if a diretory's
> > data fork is larger than 96GB.
> > 
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> 
> Mostly OK, just a simple cleanup needed.
> 
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index ee8d4eb7d048..54b106ae77e1 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -491,6 +491,15 @@ xfs_dinode_verify(
> >  	if (mode && nextents + naextents > nblocks)
> >  		return __this_address;
> >  
> > +	if (S_ISDIR(mode)) {
> > +		uint64_t	max_dfork_nexts;
> > +
> > +		max_dfork_nexts = (XFS_DIR2_MAX_SPACES * XFS_DIR2_SPACE_SIZE) >>
> > +					mp->m_sb.sb_blocklog;
> > +		if (nextents > max_dfork_nexts)
> > +			return __this_address;
> > +	}
> 
> max_dfork_nexts for a directory is a constant that should be
> calculated at mount time via xfs_da_mount() and stored in the
> mp->m_dir_geo structure. Then this code simple becomes:
> 
> 	if (S_ISDIR(mode) && nextents > mp->m_dir_geo->max_extents)
> 		return __this_address;

I have the same comment as Dave, FWIW. :)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
