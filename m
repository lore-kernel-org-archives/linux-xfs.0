Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29197 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753565AbeCUV0U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Mar 2018 17:26:20 -0400
Date: Thu, 22 Mar 2018 08:26:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/4] misc: remove darwin, irix, and freebsd support
Message-ID: <20180321212617.GX18129@dastard>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <20180321031933.GO1757@magnolia>
 <da8feaae-b6a3-613e-71c8-38d16981d701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8feaae-b6a3-613e-71c8-38d16981d701@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Mar 21, 2018 at 01:59:26PM -0500, Eric Sandeen wrote:
> On 3/20/18 10:19 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Remove these ports since they're not actively maintained:
> > 
> > IRIX support was partially removed last year; the OS itself hasn't had a
> > release since 2006.
> > 
> > FreeBSD dropped XFS support in v9.3, which EOLd in January 2017.
> > 
> > Darwin/OSX has never supported XFS.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Probably should clean up more than just whole files, see bits & pieces
> sprinkled throughout:
> 
> include/builddefs.in 
> include/platform_defs.h.in
> include/gnukfreebsd.h (?)

So, this makes me wonder. IIRC, that's the header for the debian
distro on a freebsd kernel. That's a thing, and we package xfsprogs
in debian. Do they build xfsprogs for that platform, and if they do
do we care if we break it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
