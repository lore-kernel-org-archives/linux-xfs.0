Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8044C00A8F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 15:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjJXPOr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjJXPOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 11:14:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC02EA;
        Tue, 24 Oct 2023 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qpmLAMe3UIUUFs6yiDrqQIACnDygj9UeXkkyfRKdiWA=; b=MP/sNQJ7Oj5bKDcaH/zYzk9b5J
        XJxHdA+lP/zEfA0tHclyq0C6at32laH3EkiCarOa9+mPovCKu8OCXzqk8BZtL9OMuYhylfjQlTEhh
        fpHYd2/nka1it6G++Jm13WWShHNNO81UfVEf7+VWE4VizuayJAQwpsxezeDNdhbBuHs+R/i2HK0O6
        HjnFhzLWlDQdCqjEuLHir5Gwys9wvbLh5wCAeYmKzn9t19zo/ygagFNJaE47wYrpsw0SQBdci6Thp
        EoZPjTGXts/kIbik96TAuyy9mP0JoxWgAKqj21RxKs19czqCODP8ExZelyS/wwtte7Tg4IZuuIjMM
        qJl+Bm8A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvJ79-003Bjb-PR; Tue, 24 Oct 2023 15:14:39 +0000
Date:   Tue, 24 Oct 2023 16:14:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: respect the stable writes flag on the RT device
Message-ID: <ZTffX8jYEsVZTZK6@casper.infradead.org>
References: <20231024064416.897956-1-hch@lst.de>
 <20231024064416.897956-4-hch@lst.de>
 <20231024150904.GA3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024150904.GA3195650@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:09:04AM -0700, Darrick J. Wong wrote:
> > +	if (S_ISREG(VFS_I(ip)->i_mode) &&
> > +	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
> > +		xfs_update_stable_writes(ip);
> 
> Hmm.  Won't the masking operation here result in the if test comparing 0
> or FS_XFLAG_REALTIME to 0 or 1?
> 
> Oh.  FS_XFLAG_REALTIME == 1, so that's not an issue in this one case.
> That's a bit subtle though, I'd have preferred
> 
> 	    XFS_IS_REALTIME_INODE(ip) != !!(fa->fsx_xflags & FS_XFLAG_REALTIME))
> 
> to make it more obvious that the if test isn't comparing apples to
> oranges.

!= !! might be going a bit far.  Would you settle for

XFS_IS_REALTIME_INODE(ip) == !(fa->fsx_xflags & FS_XFLAG_REALTIME)

?  Although none of these read particularly nicely.  Maybe

	XFS_IS_REALTIME_INODE(ip) != ((fa->fsx_xflags & FS_XFLAG_REALTIME) == 0))

Perhaps we need a bool helper for (fa->fsx_xflags & FS_XFLAG_REALTIME)
