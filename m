Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDAEDCDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 00:49:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbjJQAtb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 20:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbjJQAtX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 20:49:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB789181
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 17:49:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC8BC433C8;
        Tue, 17 Oct 2023 00:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697503753;
        bh=iAvcz6saDdSqSSo6JieruNXSgesVc35IR+YykqLOFf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JAiUnRJBLECDf0PZwhQXCgBlgLbw0McMghuOMhOUCPg2iiZtVM8bz7mOLvBie5Vhx
         8H+INCvGJKsn3YSM3uSO3qJLkUWyY423sTk1HBErWWXdu1zEN+CTGfEY7ikgZjn/Xs
         eNlBy68DOQtlb1mSrn175SuuUvLrJ+xXJ5WBaez3J6waGMZIQWR31inOF0Wy1+6Tup
         d2HtwqFbxv1JuMifY2iWi/SPUygio8ll3MXRGqPxykIhbVuKFJWV9L9NZh/m4f6fMC
         4M37nSJezS57ocGc5mMJOZlKtqA//N595FfH2utn1giJly2XYRWbw9/70yRMoCwYrm
         F/D7qGpzIsZDw==
Date:   Mon, 16 Oct 2023 17:49:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 2/8] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
Message-ID: <20231017004912.GE11402@frogsfrogsfrogs>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs>
 <169704721662.1773834.1354453014423462886.stgit@frogsfrogsfrogs>
 <20231012053306.GA2795@lst.de>
 <20231012182030.GL21298@frogsfrogsfrogs>
 <20231013055324.GA6991@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013055324.GA6991@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 13, 2023 at 07:53:24AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 12, 2023 at 11:20:30AM -0700, Darrick J. Wong wrote:
> > > Random rambling: there is a fairly large chunk of code duplicated
> > > here.  Maybe the caching series and/or Dave's suggest args cleanup
> > > would be good opportunity to refactor it.  Same for the next two
> > > clusters of two chunks.
> > 
> > Yeah, Dave and I will have to figure out how to integrate these two.
> > I might just pull in his rtalloc_args patch at the end of this series.
> 
> They way I understood his review of Omars patches isn't that he
> has a rtalloc_args patch, but suggest adding that structure.
> 
> I can take care of that after your series and Omar has landed, together
> with the bitmap/summary access abstraction.

Ah.  I stg import'd Dave's suggestionpatch and it more or less applied,
so it's already in the work branch.  It also reduced Omar's patchset
quite a bit.

--D
