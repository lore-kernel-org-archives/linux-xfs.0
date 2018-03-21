Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753534AbeCUVbo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 17:31:44 -0400
Date: Wed, 21 Mar 2018 14:31:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/4] misc: remove darwin, irix, and freebsd support
Message-ID: <20180321213138.GA7140@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <20180321031933.GO1757@magnolia>
 <da8feaae-b6a3-613e-71c8-38d16981d701@redhat.com>
 <20180321212617.GX18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180321212617.GX18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 08:26:17AM +1100, Dave Chinner wrote:
> On Wed, Mar 21, 2018 at 01:59:26PM -0500, Eric Sandeen wrote:
> > On 3/20/18 10:19 PM, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Remove these ports since they're not actively maintained:
> > > 
> > > IRIX support was partially removed last year; the OS itself hasn't had a
> > > release since 2006.
> > > 
> > > FreeBSD dropped XFS support in v9.3, which EOLd in January 2017.
> > > 
> > > Darwin/OSX has never supported XFS.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Probably should clean up more than just whole files, see bits & pieces
> > sprinkled throughout:
> > 
> > include/builddefs.in 
> > include/platform_defs.h.in
> > include/gnukfreebsd.h (?)
> 
> So, this makes me wonder. IIRC, that's the header for the debian
> distro on a freebsd kernel. That's a thing, and we package xfsprogs
> in debian. Do they build xfsprogs for that platform, and if they do
> do we care if we break it?

>From the looks of it[1] they (Debian) don't package xfsprogs for
kfreebsd (not even the wheezy release that supposedly had an xfs driver
in the kernle) so I doubt anyone would care.

--D

[1] https://packages.debian.org/search?keywords=xfsprogs

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
