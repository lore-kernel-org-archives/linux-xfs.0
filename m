Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6E2CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 00:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91A3161157
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 00:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhIPA7l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 20:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233284AbhIPA7l (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 20:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30C660238;
        Thu, 16 Sep 2021 00:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631753901;
        bh=8v8S7TUGJeiEU464jluQc+cb3JSX9B0qx9x09wr3EX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k+qofblBPfXIIzXgRBKyPmFgTLz71WyFgdx4P36Ot8slgHLZ277K/modVBPjJe63+
         YbE7Zj/RIlEuWOEb7KGjJwsxYhdXz9+oJKsOg04c+hZCBpyl9S9Nju4d/prhM42WFo
         TQrln62jTlxLYtDUrzjVmP28t1Nzk8iLy5XertZQOKRRJtA/u/+S3PdYN9z6Q9XoS9
         Jr9N7MegBZHrNqg7AZxt2j1n5wQvL1OHbvJyW7obkhl/StaDIK3Jzt8ff8EleH2lOz
         0AeNwgsR63wURk3fjKJqPXA+4REWaZxQv8u2rTCwDkunuibIVIOsvTaY7dk+92Ycld
         yjO6CPXTDKXuQ==
Date:   Wed, 15 Sep 2021 17:58:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/61] libfrog: create header file for mocked-up kernel
 data structures
Message-ID: <20210916005821.GC34899@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174721123.350433.6338166230233894732.stgit@magnolia>
 <20210916004646.GO2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916004646.GO2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 10:46:46AM +1000, Dave Chinner wrote:
> On Wed, Sep 15, 2021 at 04:06:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a mockups.h for mocked-up versions of kernel data structures to
> > ease porting of libxfs code.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  include/libxfs.h     |    1 +
> >  libfrog/Makefile     |    1 +
> >  libfrog/mockups.h    |   19 +++++++++++++++++++
> >  libxfs/libxfs_priv.h |    4 +---
> >  4 files changed, 22 insertions(+), 3 deletions(-)
> 
> I don't really like moving this stuff to libfrog. The whole point of
> libxfs/libxfs_priv.h is to define the kernel wrapper stuff that
> libxfs needs to compile and should never be seen by anything outside
> libxfs/...

How did you handle this in your xfsprogs port?  I /think/ the only
reason we need the mockups is to handle the perag structure in xfs_ag.h?
In that case, I guess one could simply omit the stuff below the "kernel
only structures below this line" line?

In that case, can you (or anyone, really) fix libxfs-compare to be smart
enough to filter out the "#ifdef __KERNEL__" parts of libxfs from the
diff?

--D

> Indeed, we -cannot- use spinlocks in userspace code, so I really
> don't see why we'd want to make them more widely visible to the
> userspace xfsprogs code...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
