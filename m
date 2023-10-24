Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C28C25B48
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Oct 2023 16:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbjJXQRH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjJXQRG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Oct 2023 12:17:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61CD2118;
        Tue, 24 Oct 2023 09:17:04 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3DCE468AA6; Tue, 24 Oct 2023 18:17:00 +0200 (CEST)
Date:   Tue, 24 Oct 2023 18:16:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] xfs: respect the stable writes flag on the RT
 device
Message-ID: <20231024161659.GB20546@lst.de>
References: <20231024064416.897956-1-hch@lst.de> <20231024064416.897956-4-hch@lst.de> <20231024150904.GA3195650@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024150904.GA3195650@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 24, 2023 at 08:09:04AM -0700, Darrick J. Wong wrote:
> > +	/*
> > +	 * Make the stable writes flag match that of the device the inode
> > +	 * resides on when flipping the RT flag.
> > +	 */
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

This is all copy and pasted from a check a few lines above :)

I guess I could clean it up as well or even add a rt_flag_changed local
variable instead of duplicating the check.

> > +	/*
> > +	 * For real-time inodes update the stable write flags to that of the RT
> > +	 * device instead of the data device.
> > +	 */
> > +	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
> > +		xfs_update_stable_writes(ip);
> 
> I wonder if xfs_update_stable_writes should become an empty function for
> the CONFIG_XFS_RT=n case, to avoid the atomic flags update?
> 
> (The extra code is probably not worth the microoptimization.)

The compiler already eliminates the code because XFS_IS_REALTIME_INODE(ip)
has a stub for CONFIG_XFS_RT=n that always returns 0.
