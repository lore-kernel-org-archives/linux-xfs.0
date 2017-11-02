Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17088 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932571AbdKBTBg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2017 15:01:36 -0400
Date: Thu, 2 Nov 2017 12:01:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/18] xfs: introduce the xfs_iext_cursor abstraction
Message-ID: <20171102190115.GY4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
 <20171031142230.11755-13-hch@lst.de>
 <20171031220234.GT4911@magnolia>
 <20171102184942.GB4244@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102184942.GB4244@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:49:42PM +0100, Christoph Hellwig wrote:
> On Tue, Oct 31, 2017 at 03:02:34PM -0700, Darrick J. Wong wrote:
> > > +	struct xfs_iext_cursor ext;
> > 
> > I was expecting an extent map cursor to have 'cur' in the name --
> > 'ext' misleads me into thinking that 'ext' is an actual extent.
> > 
> > struct xfs_iext_cursor	*icur;
> > 
> > Also, xfs_iext_insert names its cursor parameter *cur, so why ext here?
> 
> I started out with cur, but in most bmap routines we already have the
> btree cursor named cur, so I had to look for something else.  I could
> probably change to icur, but that will be a heck of an annoying rebase..

How many more patches do you have after the ones you've already sent?

I /do/ have the ability to do evil things like sed -e 's/ext,/icur,/g'
to the patches and re-stuff them in the git branch.  I probably wouldn't
bother with the ones already named 'cur', it's just the 'ext' ones that
increase my cognitive impedance.

--D

> > For now I'm going to assume that xfs_iext_{first,last,next,prev} will
> > actually do something with the ifp parameter in the near future.
> 
> Yes, good assumption.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
