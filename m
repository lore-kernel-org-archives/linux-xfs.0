Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37240 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751083AbdDMKdY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 06:33:24 -0400
Date: Thu, 13 Apr 2017 12:33:22 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: transaction reservations for deleting of shared extents
Message-ID: <20170413103322.GA29553@lst.de>
References: <20170220072945.GA17608@lst.de> <20170221014356.GA5844@birch.djwong.org> <20170412135231.GA3891@lst.de> <20170412230612.GS8502@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170412230612.GS8502@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Apr 12, 2017 at 04:06:12PM -0700, Darrick J. Wong wrote:
> So I think the problem you're seeing here is that just prior to (3g) we
> have the most deferred items (EFIs, specifically) attached to this
> transaction at any point in the whole operation.  There can be so many
> EFIs that we use up the log reservation and blow the ASSERT.

Yes.  I think that's exactly what I'm seing, except that rmap isn't
part of the game.

> > I still don't have a good idea how to fix this, though.  One idea
> > would be to prevent mixing different items, but I think being able
> > to mix them was one of your goals with the defer infrastructure rewrite.
> 
> Yes, we have to be able to perform several different types of updates
> in one defer_ops so that we can execute CoW remappings atomically.

In one defer_ops, but I don't see anything preventing us from starting
a new chained transaction everytime we move from one type to another.
