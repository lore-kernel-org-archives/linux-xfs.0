Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CE3C432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 23:33:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF2260FC0
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 23:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239862AbhHaXd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 19:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238552AbhHaXd4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 19:33:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 940BD60F91;
        Tue, 31 Aug 2021 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630452780;
        bh=9hJSWlNne+ekXkZJNxIlB3hMu9XqQyR9cUxW6qYYe/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJzfGDXPF3pCQNjx/Vf+9VOSnlSfZfPg8QAeGO9GHT4467tPVmWEpqqkhwsIZ7A4U
         s8HXly4WGGmR58rU+eX8vr+W2uW9vyxw/SX4AaKyw3BtRlQ6qu4xfA0IjrXB53vzBf
         gMfQWg4REqPKYwpvSSiXleDDJO9gTX5WdfLJwG2+jsgve96sdb4mZCWKw0G9E+W2af
         qoFhbEbHl2a/Tt65ortDIxNTN1ztAuZw2ZTW2GuF3ZC2EQRkFmfzp+wZCFWWt4cohU
         vO2LdMOwwv8d9Fvfl5kaHzpqVdCdn2jcDCUWGrqisPGDBUIKzx95cVfDaKBneTTxyj
         vWYlS3974gBoA==
Date:   Tue, 31 Aug 2021 16:33:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: warn about V4 deprecation when creating new V4
 filesystems
Message-ID: <20210831233300.GC9942@magnolia>
References: <20210831224438.GB9942@magnolia>
 <20210831232927.GV3657114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831232927.GV3657114@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 01, 2021 at 09:29:27AM +1000, Dave Chinner wrote:
> On Tue, Aug 31, 2021 at 03:44:38PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> > September 2025 it will be turned off by default in the kernel and five
> > years after that, support will be removed entirely.  Warn people
> > formatting new filesystems with the old format, particularly since V4 is
> > not the default.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  mkfs/xfs_mkfs.c |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 53904677..b8c11ce9 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
> >  		}
> >  
> >  	} else {	/* !crcs_enabled */
> > +		/*
> > +		 * The V4 filesystem format is deprecated in the upstream Linux
> > +		 * kernel.  In September 2025 it will be turned off by default
> > +		 * in the kernel and in September 2030 support will be removed
> > +		 * entirely.
> > +		 */
> > +		fprintf(stdout,
> > +_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
> > +
> >  		/*
> >  		 * The kernel doesn't support crc=0,finobt=1 filesystems.
> >  		 * If crcs are not enabled and the user has not explicitly
> > 
> 
> Looks good to me.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Do we need to update the mkfs filter in fstests now?

AFAICT, no, because (so far) the only fstests that care about mkfs
output only look for messages on stderr, and dump stdout to $seqres.full
or /dev/null.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
