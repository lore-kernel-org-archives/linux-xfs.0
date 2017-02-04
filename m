Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:52717 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753811AbdBDJ6Y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 4 Feb 2017 04:58:24 -0500
Date: Sat, 4 Feb 2017 10:58:22 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: improve busy extent sorting
Message-ID: <20170204095822.GD18472@lst.de>
References: <1485715421-17182-1-git-send-email-hch@lst.de> <1485715421-17182-4-git-send-email-hch@lst.de> <20170203152242.GD45388@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203152242.GD45388@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Feb 03, 2017 at 10:22:42AM -0500, Brian Foster wrote:
> > -	return container_of(a, struct xfs_extent_busy, list)->agno -
> > -		container_of(b, struct xfs_extent_busy, list)->agno;
> > +	struct xfs_extent_busy	*b1 =
> > +		container_of(l1, struct xfs_extent_busy, list);
> > +	struct xfs_extent_busy	*b2 =
> > +		container_of(l2, struct xfs_extent_busy, list);
> > +
> > +	return b1->agno - b2->agno || b1->bno - b2->bno;
> 
> When will this ever return negative?

Yes, this version is broken unfortunately, I'll fix it up.
