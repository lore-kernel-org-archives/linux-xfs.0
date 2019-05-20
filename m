Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32830 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfETXKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:10:55 -0400
Date: Mon, 20 May 2019 16:10:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 0/3] xfsprogs: more libxfs/ spring cleaning
Message-ID: <20190520231042.GJ5335@magnolia>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
 <20190520230311.GI5335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520230311.GI5335@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 20, 2019 at 04:03:11PM -0700, Darrick J. Wong wrote:
> On Thu, May 16, 2019 at 12:42:45PM -0500, Eric Sandeen wrote:
> > It wasn't super clear before - my goal here is to keep reducing
> > cosmetic differences between kernelspace & userspace libxfs/*
> > files and functions.
> > 
> > To that end, 3 more patches ... the first one may requires someone
> > who groks the libxfs_* API namespace picture (looking at you, Dave!)
> > 
> > (this abandons the "make new files" patches I sent before, at least
> > for now, I'll heed dave's advice to minimize moves...)
> 
> Er, can you turn on diffstat for each patch that gets sent?  That'll
> make it much easier for me to figure out if any of these patches have to
> go in the kernel first.
> 
> I /think/ the answer is 'no'....?

Yes, this is purely userspace stuff, no kernel patches required.

For the whole series (modulo everyone else's comments),
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> --D
> 
> > Thanks,
> > -Eric
