Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:35839 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756663AbcLPBVv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 20:21:51 -0500
Date: Thu, 15 Dec 2016 17:20:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] duperemove: test presence of dedupe ioctl
Message-ID: <20161216012014.GG5357@birch.djwong.org>
References: <20161209175645.GB16813@birch.djwong.org>
 <20161214104436.GB16862@infradead.org>
 <20161214183845.GA5357@birch.djwong.org>
 <20161214192607.GA2280@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214192607.GA2280@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: mfasheh@versity.com, xfs <linux-xfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Wed, Dec 14, 2016 at 11:26:07AM -0800, Christoph Hellwig wrote:
> On Wed, Dec 14, 2016 at 10:38:45AM -0800, Darrick J. Wong wrote:
> > > > +struct fake_btrfs_ioctl_same_args {
> > > > +	struct btrfs_ioctl_same_args args;
> > > > +	struct btrfs_ioctl_same_extent_info info;
> > > > +};
> > > 
> > > Why does this need a fake structure here?
> > 
> > In order to test the ioctl we have to fill out at least one
> > btrfs_ioctl_same_extent_info so that we get far enough into the fs-specific
> > dedupe_range handler that we've verified that the fs is capable of dedupe and
> > that the fs is willing to try to satisfy the request.
> 
> Oh, got it, it's just the fake that tripped me up.
> 
> > We could just malloc sizeof(_same_args) + sizeof(_same_extent_info)...
> 
> Either that, or more simply just don't give the structure a name
> by just declaring it locally on the stack:
> 
> 	struct {
> 		struct btrfs_ioctl_same_args args;
> 		struct btrfs_ioctl_same_extent_info info;
> 	} sa = { 0 };

Fair enough, no need to pollute the namespace.

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
