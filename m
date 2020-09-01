Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF78C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC672083B
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HkXskkPe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgIAJqE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgIAJqD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 05:46:03 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C833EC061244
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 02:46:02 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y6so275186plt.3
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 02:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsAvaOhJVaJyOu+sKoqeUEkpyN59TsTyMphJJKdKk4Q=;
        b=HkXskkPeq8VqtOhxNv7xIzrIgNqfjyTU5pKEyu+KHWdPj4rkYARDaLoyH+R3ll/+W0
         Q7MY9kMUsXSQoRtgLIJiW3X+Z8RHkrEJOt0Cmz8XpesIc5oTRLeS01qX/t2dOanuxNSu
         nQpWa1uSSZiTxTqWKfappsNpXn48CNDQfwmaqv5ONs3ESwC8jL5Z5J0QGQBSQ7wBWAuZ
         gnF32Ld1O8UlY2yZ6v973+E6DifZJMDqKOlvPwk8muSAf02D9i5FiVMpN6jPJGIuAOBt
         CfAJhGgcec5TXrlZ2qQi6+8301XFWYXT3uOTpm2JSphlKpDNvxdQeAWzBo5cMF9+MKu9
         Zj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsAvaOhJVaJyOu+sKoqeUEkpyN59TsTyMphJJKdKk4Q=;
        b=qs31th1EJbX3nXEhregvysercDL1IVX1tOY10woYrSxAZsp6BQI+avL9iI+zZt73jT
         1vVyJzeUYs8797ACzu0YOTzNwavObMhoxlTQU2Ln/MOcvMgxjQzL5PIjnAC/CX51JQVg
         nwIjLThCTnPpjwCIjyBN3LINYvDG7qDHQHaGgke93DL4ETziXUZ/9UAyZnLKZkV8XYLy
         bxq/XqM9V+VBeXyiwmSlHtFgMtNQaZpKVy3TeR8W05qSPB/pYCok9mPbTUNdO7moicc0
         GejWk8Np6MLkFMADeBgq4Ubfqjeffcw2nNCMtm7skKLHMgW+ijviv5OSFIQbyULtmYwA
         Z5Eg==
X-Gm-Message-State: AOAM532BeY8emkBRdHSX4WO/IkDjljZoamihDiPEn1/9BXT/Fb8cKckA
        NWPjysrQWTBNmcrFKvBMbGI=
X-Google-Smtp-Source: ABdhPJz/aFcaQttX0s2kmBtyT5DXavJ+NCxVqsAH6OtzQg1EHAA9wSr+d3KFx9qI3unAxngjvj2lkA==
X-Received: by 2002:a17:90a:9103:: with SMTP id k3mr806501pjo.4.1598953562318;
        Tue, 01 Sep 2020 02:46:02 -0700 (PDT)
Received: from garuda.localnet ([122.171.183.205])
        by smtp.gmail.com with ESMTPSA id ga20sm918639pjb.11.2020.09.01.02.46.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 02:46:01 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V3 01/10] xfs: Add helper for checking per-inode extent count overflow
Date:   Tue, 01 Sep 2020 15:14:21 +0530
Message-ID: <6636871.qDoI5iUcXa@garuda>
In-Reply-To: <20200831164435.GO6096@magnolia>
References: <20200820054349.5525-1-chandanrlinux@gmail.com> <20200831160823.GG6096@magnolia> <20200831164435.GO6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 31 August 2020 10:14:35 PM IST Darrick J. Wong wrote:
> On Mon, Aug 31, 2020 at 09:08:23AM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 20, 2020 at 11:13:40AM +0530, Chandan Babu R wrote:
> > > XFS does not check for possible overflow of per-inode extent counter
> > > fields when adding extents to either data or attr fork.
> > > 
> > > For e.g.
> > > 1. Insert 5 million xattrs (each having a value size of 255 bytes) and
> > >    then delete 50% of them in an alternating manner.
> > > 
> > > 2. On a 4k block sized XFS filesystem instance, the above causes 98511
> > >    extents to be created in the attr fork of the inode.
> > > 
> > >    xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131
> > > 
> > > 3. The incore inode fork extent counter is a signed 32-bit
> > >    quantity. However the on-disk extent counter is an unsigned 16-bit
> > >    quantity and hence cannot hold 98511 extents.
> > > 
> > > 4. The following incorrect value is stored in the attr extent counter,
> > >    # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
> > >    core.naextents = -32561
> > > 
> > > This commit adds a new helper function (i.e.
> > > xfs_iext_count_may_overflow()) to check for overflow of the per-inode
> > > data and xattr extent counters. Future patches will use this function to
> > > make sure that an FS operation won't cause the extent counter to
> > > overflow.
> > > 
> > > Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > 
> > Seems reasonable so far...
> > 
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > --D
> > 
> > > ---
> > >  fs/xfs/libxfs/xfs_inode_fork.c | 23 +++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
> > >  2 files changed, 25 insertions(+)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > > index 0cf853d42d62..3a084aea8f85 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > > @@ -23,6 +23,7 @@
> > >  #include "xfs_da_btree.h"
> > >  #include "xfs_dir2_priv.h"
> > >  #include "xfs_attr_leaf.h"
> > > +#include "xfs_types.h"
> > >  
> > >  kmem_zone_t *xfs_ifork_zone;
> > >  
> > > @@ -728,3 +729,25 @@ xfs_ifork_verify_local_attr(
> > >  
> > >  	return 0;
> > >  }
> > > +
> > > +int
> > > +xfs_iext_count_may_overflow(
> > > +	struct xfs_inode	*ip,
> > > +	int			whichfork,
> > > +	int			nr_to_add)
> > > +{
> > > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
> > > +	uint64_t		max_exts;
> > > +	uint64_t		nr_exts;
> > > +
> > > +	if (whichfork == XFS_COW_FORK)
> > > +		return 0;
> > > +
> > > +	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> > > +
> > > +	nr_exts = ifp->if_nextents + nr_to_add;
> > > +	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> > > +		return -EFBIG;
> 
> Something I thought of after the fact -- can you add a new fault
> injection point to lower the max extent count?  That way we can
> facilitate the construction of fstests cases to check the operation of
> the new predicate without having to spend lots of time constructing huge
> fragmented files.

Sure, I will do that.

> 
> (There /are/ test cases somewhere, riiight? ;))

Apart from executing xfstests, I had tested the patchset with the use case
described in the commit message of this patch. But with an error injection
facility available, it should be easier to add tests to fstests. I will work
on that. Thanks for the suggestion.

> 
> No need to add it here, you can tack it onto the end of the series as a
> new patch.
> 
> --D
> 
> > > +
> > > +	return 0;
> > > +}
> > > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > > index a4953e95c4f3..0beb8e2a00be 100644
> > > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > > @@ -172,5 +172,7 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> > >  
> > >  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
> > >  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> > > +int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> > > +		int nr_to_add);
> > >  
> > >  #endif	/* __XFS_INODE_FORK_H__ */
> 


-- 
chandan



