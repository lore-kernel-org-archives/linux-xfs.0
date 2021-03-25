Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09DFC433C1
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:30:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADAE61A2A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:30:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhCYO3m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:29:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:42020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCYO3m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 10:29:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616682581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hq+364Gyz3cSxoIAyE0vkUkHwS69imXT89V2QvwJtPI=;
        b=EZ/ntjKZnzr9IhGnLvfvy+hSZRR7rkas2DhXqBQajik24ruBq7NKKzCkxvM3JnTQjF5ufY
        A90caqSQsy4QxF5ulvb2poEXF65RS3Wa3nnMFwo4YV5WFpO6fbZX5yOKt3nWGMc5q1WsWa
        nxmvGsEm0rEEx3Gua0D++OmjAxzn3tI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 06123AC16;
        Thu, 25 Mar 2021 14:29:41 +0000 (UTC)
Date:   Thu, 25 Mar 2021 15:29:40 +0100
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/18] xfs: remove the di_dmevmask and di_dmstate fields
 from struct xfs_icdinode
Message-ID: <YFyeVLbI/7JCKPnX@technoir>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-6-hch@lst.de>
 <20210324181429.GD22100@magnolia>
 <20210324182042.GA16478@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324182042.GA16478@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 07:20:42PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 24, 2021 at 11:17:59AM -0700, Darrick J. Wong wrote:
> > On Wed, Mar 24, 2021 at 03:21:16PM +0100, Christoph Hellwig wrote:
> > > The legacy DMAPI fields were never set by upstream Linux XFS, and have no
> > > way to be read using the kernel APIs.  So instead of bloating the in-core
> > > inode for them just copy them from the on-disk inode into the log when
> > > logging the inode.  The only caveat is that we need to make sure to zero
> > > the fields for newly read or deleted inodes, which is solved using a new
> > > flag in the inode.
> > 
> > How long ago /did/ non-upstream XFS have DMAPI support?  Does it still
> > have it now?  What's the cost of zeroing the fields?
> > 
> > (Really what I'm saying is that I have so little clue of what dmevmask
> > and dmstate do that I don't really know what Magic Smoke comes out if
> > these fields get zeroed by an upstream kernel.)
> 
> SuSE is shipping SGI patches for it in SLES12, their second newest
> release. Which is still supported AFAIK.

Indeed SLE12-SP3 was the last release to ship with DMAPI. The general
support has ended (although LTSS is still supported till mid-2022).

Either way booting/rescue from a non-SLE12 medium isn't supported, and
this cleanup is not going to be backported (LTSS only receives critical
fixes anyway), so it's probably safe to keep those fields always zeroed
in upstream kernels.

Perhaps even renaming those fields on xfs_dinode and xfs_log_dinode to
unused/pads would make sense, since they could be repurposed. Needs
though a couple of cleanups on the xfsprogs side too, so probably
outside the scope of this series (I have a bunch of patches to that
effect that I need to send sometime).

Regards,
Anthony
