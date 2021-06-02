Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4FADC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90DAF61396
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 06:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhFBGRU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 02:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhFBGRT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 02:17:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58631611CA;
        Wed,  2 Jun 2021 06:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622614537;
        bh=5Rs4hwyQqK3yvtPARDy+ztvWLazfqLsbhVwtOtcyDn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UllUzHzH6S5S9F0yxjKd+nI/QFfoy/i/mYUjEBfnK9fhggi+otozno3hIuDhdnmHN
         UWlV67Qgp3N9fbKC+F+8IkJkCWr1AhjACE7F+1FQ+/h7bi09U8Yla53kfzlxSHCLsn
         oOG22/MmoF2v6x4i5vhT6OHd9s62sxFPu3svHq7lFES1xGNt3HhznQHRKbfwRYV/8j
         9ZhpPIpr1n5IxoMyLrCFqIctD0vwV7ncjg/ALvxYzw5E0MvgugG6z+es8meb3qv1la
         3wp8epWsVCy+qYz5yi6PVgxDPiHoXSvhBNDzLSGfC4QmE+PlWNtTLYlNRb5hS0EES7
         IGuqRsQk0b8UA==
Date:   Tue, 1 Jun 2021 23:15:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 12/14] xfs: pass struct xfs_eofblocks to the inode scan
 callback
Message-ID: <20210602061536.GH26380@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
 <162259521860.662681.12154848311244033442.stgit@locust>
 <20210602020416.GR664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602020416.GR664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 12:04:16PM +1000, Dave Chinner wrote:
> On Tue, Jun 01, 2021 at 05:53:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Pass a pointer to the actual eofb structure around the inode scanner
> > functions instead of a void pointer, now that none of the functions is
> > used as a callback.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_icache.c |   30 +++++++++++++-----------------
> >  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> Looks ok.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> As mentioned in #xfs, I think there's followup work here to rename
> struct xfs_eofblocks to struct xfs_icwalk now that it really has
> nothing specific to do with eofblock scanning anymore.

Ok, I'll tack a rename patch on the end.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
