Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763D0C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5514160231
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 17:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhHLRQk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235044AbhHLRQj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 13:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B1F60724;
        Thu, 12 Aug 2021 17:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628788574;
        bh=c+OdmvKw1pcUayrJOR0u8dNXLYctrQ8A58+EDP/P5ck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tqmg3PcE/oh+dxbrdUKiQ6PGgUPNuCSb09He4MTuRU5VcdUbdMHP6uo/vkFmGHxv9
         kwBBbHEb7t+Ji3EnpguLkQGR8OVj+o/KTSpoAhNYrHaKabXx0VlQjKLKkwFJ1TrznB
         MLb4TbSrX8t3l2QId5CqtfaTtdgZaT6EiT1z1598gA6tM5bYz6w54PcGHvF2cUIcWH
         8aTtdkb1wEDK/cq5X5G5/ARFXGw0E82wqFLUaclPBh6vhbpZZPQBjUIbGA0qWDU3LW
         M8GMObapyTTi2oFOVab4CDSEWWVfpvbdM986jKSMGdbvcGK5AE/yXToLccGb9Zdzin
         qJautJphHmUzA==
Date:   Thu, 12 Aug 2021 10:16:13 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Pavel Reichl <preichl@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: remove the xfs_dinode_t typedef
Message-ID: <20210812171613.GT3601443@magnolia>
References: <20210812084343.27934-1-hch@lst.de>
 <20210812084343.27934-2-hch@lst.de>
 <6d28d82c-4113-3b74-c7bd-f430cf8fbfb3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d28d82c-4113-3b74-c7bd-f430cf8fbfb3@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 12, 2021 at 11:31:31AM +0200, Pavel Reichl wrote:
> 
> On 8/12/21 10:43 AM, Christoph Hellwig wrote:
> >   	/*
> >   	 * If the size is unreasonable, then something
> > @@ -162,8 +162,8 @@ xfs_iformat_extents(
> >    */
> >   STATIC int
> >   xfs_iformat_btree(
> > -	xfs_inode_t		*ip,
> > -	xfs_dinode_t		*dip,
> > +	struct xfs_inode	*ip,
> > +	struct xfs_dinode	*dip,
> >   	int			whichfork)
> 
> Hi,
> 
> since you are also removing xfs_inode_t I'd like to ask if it is a good idea

[assuming you meant xfs_dinode_t here]

> to send a separate patch removing all other instances of xfs_inode_t? (I'm
> happy to do it).

Seems like a reasonable thing to me.

--D

> 
> Patch applies, builds and LGTM.
> 
> Reviewed-by: Pavel Reichl <preichl@redhat.com>
> 
