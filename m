Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:42539 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbeIECu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 22:50:57 -0400
Date: Wed, 5 Sep 2018 08:23:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904222345.GV5631@dastard>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
 <8045369.1GWcTSHGau@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8045369.1GWcTSHGau@merkaba>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 05:36:43PM +0200, Martin Steigerwald wrote:
> Dave Chinner - 04.09.18, 02:49:
> > On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones wrote:
> > > [This is silly and has no real purpose except to explore the limits.
> > > If that offends you, don't read the rest of this email.]
> > 
> > We do this quite frequently ourselves, even if it is just to remind
> > ourselves how long it takes to wait for millions of IOs to be done.
> 
> Just for the fun of it during an Linux Performance analysis & tuning 
> course I held I created a 1 EiB XFS filesystem a sparse file on another 
> XFS filesystem on an SSD of a ThinkPad T520. It took several hours to 
> create, but then it was there and mountable. AFAIR the sparse file was a 
> bit less than 20 GiB.

Yup, 20GB of single sector IOs takes a long time.

> Trying to write more data to it than the parent filesystem can hold back 
> then resulted in "lost buffer writes" or something like that in 
> kernel.log, but no visible error message to the process that wrote the 
> data.

That should mostly be fixed by now with all the error handling work
that went into the generic writeback path a few kernel releases ago.
Also, remember that the only guaranteed way to determine that there
was a writeback error is to run fsync on the file, and most
applications don't do that after writing their data.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
