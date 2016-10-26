Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36428 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932758AbcJZSAY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2016 14:00:24 -0400
Date: Wed, 26 Oct 2016 10:59:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/39] xfs: introduce the CoW fork
Message-ID: <20161026175956.GG26572@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
 <147743666109.11035.5850104676966406279.stgit@birch.djwong.org>
 <20161026102524.GF29648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161026102524.GF29648@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

On Wed, Oct 26, 2016 at 03:25:24AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 25, 2016 at 04:04:21PM -0700, Darrick J. Wong wrote:
> > Introduce a new in-core fork for storing copy-on-write delalloc
> > reservations and allocated extents that are in the process of being
> > written out.
> > 
> > [Clean up the CoW fork, should there ever be one.]
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> What's up with all these odd commit message and tiny not really
> standalone patches?

Silly me just rammed the old patch stack into the new for-next base,
with the result that the patches that still had un-merged hunks got left
in the patch stack with commit messages intact.

Dave yelled at me to fix the commit messages, so I changed the commit
messages to be the text in the brackets before the S-o-B and pushed the
mess to github.  I figured I ought to wait a day or two for more reviews
to come in before re-spamming everyone.

Sorry about the spew.

--D
