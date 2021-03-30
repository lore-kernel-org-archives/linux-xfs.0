Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AEAC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 02:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F436198A
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 02:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhC3ChV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 22:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229483AbhC3Cg5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Mar 2021 22:36:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0FF61989;
        Tue, 30 Mar 2021 02:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617071817;
        bh=TapHapx42nuxr8XzF9uYu6P4/DR9fXfVJfcfCGBG8RE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m4N4PsJOcgsOk3cq8zgaZGizsTp+CFeZJGFg3QZJpPgeDcgJCl+OcW2oGP18s0Y2Q
         PKGP1nGh1HRu7AWjRdetjvF1U5R057q7L3jPFv7obfshC/9OgGkNRzLrU2S2BXVgmb
         G7hBzIc07oXXnke7CgYSj2NaTK4nzPgtxKdMpa+l6GDSLAbRJchEQhYfziaKlK212N
         G0kPMEDA8AnGAdItxOWewzUMnlaJig9O3SVsFcFR4h6IIdcgItjtZ76KeZaMnxT0hA
         N2m5fkvxFPenKO0MF5TcJ0YOJuvx/7LpyfZtkvatAk9nF4hqVqr6MuRP84wpH/uBCD
         TlAOSLSbbvJiw==
Date:   Mon, 29 Mar 2021 19:36:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/6] xfs: use s_inodes in xfs_qm_dqrele_all_inodes
Message-ID: <20210330023656.GK4090233@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
 <161671807853.621936.16639622639548774275.stgit@magnolia>
 <20210330004407.GS63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330004407.GS63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 11:44:07AM +1100, Dave Chinner wrote:
> On Thu, Mar 25, 2021 at 05:21:18PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Using xfs_inode_walk in xfs_qm_dqrele_all_inodes is complete overkill,
> > given that function simplify wants to iterate all live inodes known
> > to the VFS.  Just iterate over the s_inodes list.
> 
> I'm not sure that assertion is true. We attach dquots during inode
> inactivation after the VFS has removed the inode from the s_inodes
> list and evicted the inode. Hence there is a window between the
> inode being removed from the sb->s_inodes lists and it being marked
> XFS_IRECLAIMABLE where we can attach dquots to the inode.
> 
> Indeed, an inode marked XFS_IRECLAIMABLE that has gone through
> evict -> destroy -> inactive -> nlink != 0 -> xfs_free_ eofblocks()
> can have referenced dquots attached to it and require dqrele() to be
> called to release them.

Why do the dquots need to remain attached after destroy_inode?  We can
easily reattach them during inactivation (v3 did this), and I don't know
why an inode needs dquots once we're through making metadata updates.

> Hence I think that xfs_qm_dqrele_all_inodes() is broken if all it is
> doing is walking vfs referenced inodes, because it doesn't actually
> release the dquots attached to reclaimable inodes. If this did
> actually release all dquots, then there wouldn't be a need for the
> xfs_qm_dqdetach() call in xfs_reclaim_inode() just before it's
> handed to RCU to be freed....

Why does it work now, then?  The current code /also/ leaves the dquots
attached to reclaimable inodes, and the quotaoff scan ignores
IRECLAIMABLE inodes.  Has it simply been the case that the dqpurge spins
until reclaim runs, and reclaim gets run quickly enough (or quotaoff runs
infrequently enough) that nobody's complained?

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
