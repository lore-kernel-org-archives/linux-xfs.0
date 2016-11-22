Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30381 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933584AbcKVSWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2016 13:22:24 -0500
Date: Tue, 22 Nov 2016 10:21:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/16] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
Message-ID: <20161122182149.GN16813@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
 <20161115101650.GE1607@infradead.org>
 <47f53245-13eb-f77a-f9d8-f532efc907fe@redhat.com>
 <20161116052116.GR28922@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161116052116.GR28922@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Wed, Nov 16, 2016 at 04:21:16PM +1100, Dave Chinner wrote:
> On Tue, Nov 15, 2016 at 07:41:19AM -0600, Eric Sandeen wrote:
> > On 11/15/16 4:16 AM, Christoph Hellwig wrote:
> > > On Fri, Nov 04, 2016 at 05:08:30PM -0700, Eric Sandeen wrote:
> > >> >From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001
> > > 
> > > It should claim to be from Eric here I think..
> > 
> > > And mention that it's a port from a kernel commit.
> > 
> > I suppose - do we have a clear policy on that?  What should the format
> > be for kernel<->userspace cross-ports in terms of From:, SoB:, etc?
> > 
> > I guess the libxfs-apply script in tools/ implicitly defines that, i.e. -
> > 
> >         # We want to format it like a normal patch with a line to say what repo
> >         # and commit it was sourced from:
> >         #
> >         # xfs: make several functions static
> >         #
> >         # From: Eric Sandeen <sandeen@sandeen.net>
> >         #
> >         # Source kernel commit: 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
> >         #
> >         # <body>
> 
> Yes, exactly. I asked Darricki last week to regenerate the patches
> with this commit message problem using the libxfs-apply tool as it
> handles all this commit reference/orignal author reformatting
> automatically now.

Heh, I fixed up the patches and forgot to send out v2 patches.
I'll do that now.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
