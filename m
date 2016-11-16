Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:42951 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750697AbcKPFVU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2016 00:21:20 -0500
Date: Wed, 16 Nov 2016 16:21:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get
Message-ID: <20161116052116.GR28922@dastard>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
 <147830451072.26713.4807330905355527976.stgit@birch.djwong.org>
 <20161115101650.GE1607@infradead.org>
 <47f53245-13eb-f77a-f9d8-f532efc907fe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47f53245-13eb-f77a-f9d8-f532efc907fe@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On Tue, Nov 15, 2016 at 07:41:19AM -0600, Eric Sandeen wrote:
> On 11/15/16 4:16 AM, Christoph Hellwig wrote:
> > On Fri, Nov 04, 2016 at 05:08:30PM -0700, Eric Sandeen wrote:
> >> >From c400ee3ed1b13d45adde68e12254dc6ab6977b59 Mon Sep 17 00:00:00 2001
> > 
> > It should claim to be from Eric here I think..
> 
> > And mention that it's a port from a kernel commit.
> 
> I suppose - do we have a clear policy on that?  What should the format
> be for kernel<->userspace cross-ports in terms of From:, SoB:, etc?
> 
> I guess the libxfs-apply script in tools/ implicitly defines that, i.e. -
> 
>         # We want to format it like a normal patch with a line to say what repo
>         # and commit it was sourced from:
>         #
>         # xfs: make several functions static
>         #
>         # From: Eric Sandeen <sandeen@sandeen.net>
>         #
>         # Source kernel commit: 0d5a75e9e23ee39cd0d8a167393dcedb4f0f47b2
>         #
>         # <body>

Yes, exactly. I asked Darricki last week to regenerate the patches
with this commit message problem using the libxfs-apply tool as it
handles all this commit reference/orignal author reformatting
automatically now.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
