Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbeH3WcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:32:24 -0400
Date: Thu, 30 Aug 2018 11:28:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830182849.GA4359@magnolia>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
 <20180830180204.GC2853@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180830180204.GC2853@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 02:02:05PM -0400, Brian Foster wrote:
> On Thu, Aug 30, 2018 at 11:35:46AM -0500, Eric Sandeen wrote:
> > On 8/30/18 11:36 AM, Christoph Hellwig wrote:
> > > On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
> > >> That's no reason to uniquely disallow it for reflinked files, though;
> > >> the problem is universal.  It's true for fiemap as well.  So I'm not sure
> > >> that's an argument against the patch?
> > > 
> > > fiemap at least tells you an extent is shared, bmap does not.
> > 
> > yes, so bmap is clearly the wrong interface to use if you want to
> > write directly to a file's blocks.  But if you know enough to check
> > the fiemap shared flag, you know enough to not use fibmap for that purpose...
> > 
> 
> FWIW, this patch seems reasonable to me. To Christoph's point, I don't
> think either interface really grants license to write to the underlying
> blocks, so either way it's technically being abused for this purpose.
> Unless there's a clear way to return an error for a particular type of
> file, I think it's reasonable behavior for fibmap to expose the data it
> supports (i.e., block maps) and drop the data it doesn't (reflink
> state).

But shared block status isn't something that can be dropped lightly.  If
you write to a shared block without realizing it, you'll corrupt every
other file that shares the block.

I prefer to have FIBMAP return errors to *cough* encourage people to use
FIEMAP.  If code are going to abuse the FI[BE]MAP interface they could
at least abuse the one that gives it enough context to avoid fs
corruption.  (A proper fs driver would be preferable, though very
difficult).

Granted, grub's blocklist code doesn't seem to check for shared blocks
when it writes grubenv.... yuck, though TBH I don't have the eye budget
to spend on digging through grub2.  Frankly I think FIBMAP comes verrry
close to "this API is unfixably stupid and shouldn't be enabled for new
use cases and should go away some day".

--D

> Brian
> 
> > -Eric
