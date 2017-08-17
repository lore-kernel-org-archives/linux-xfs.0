Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44292 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751851AbdHQHFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Aug 2017 03:05:31 -0400
Date: Thu, 17 Aug 2017 09:05:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] iomap: fix integer truncation issues in the zeroing
        and dirtying helpers
Message-ID: <20170817070529.GA23920@lst.de>
References: <20170811151805.22896-1-hch@lst.de> <20170811160443.GA24087@magnolia> <20170811160658.GA8956@lst.de> <20170816215255.GD4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170816215255.GD4796@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, pmenzel@molgen.mpg.de, stockhausen@collogia.de

On Wed, Aug 16, 2017 at 02:52:55PM -0700, Darrick J. Wong wrote:
> On Fri, Aug 11, 2017 at 06:06:58PM +0200, Christoph Hellwig wrote:
> > On Fri, Aug 11, 2017 at 09:04:43AM -0700, Darrick J. Wong wrote:
> > > Looks fine to me,
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > (Are you going to push this to Al yourself, or do you want me to drag it
> > > through the xfs tree?)
> > 
> > In general we've maintained iomap.c through the XFS tree so far.
> > I think it's easiest to stick to that.
> 
> Needs signed-off-by. :(

Feel free to add it:

Reviewed-by: Christoph Hellwig <hch@lst.de>
