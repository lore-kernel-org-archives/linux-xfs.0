Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725836AbeH3WFd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 30 Aug 2018 18:05:33 -0400
Date: Thu, 30 Aug 2018 14:02:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH, RFC] xfs: re-enable FIBMAP on reflink; disable for swap
Message-ID: <20180830180204.GC2853@bfoster>
References: <2eb759e5-2faa-67fd-5c16-c1d8edc42d02@redhat.com>
 <20180830162545.GA26816@lst.de>
 <dbe27763-2e69-6e3a-f769-2528eda54940@redhat.com>
 <20180830163614.GA27069@lst.de>
 <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65e818f2-885d-50a4-0d4a-7700c703c2af@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 30, 2018 at 11:35:46AM -0500, Eric Sandeen wrote:
> On 8/30/18 11:36 AM, Christoph Hellwig wrote:
> > On Thu, Aug 30, 2018 at 11:31:40AM -0500, Eric Sandeen wrote:
> >> That's no reason to uniquely disallow it for reflinked files, though;
> >> the problem is universal.  It's true for fiemap as well.  So I'm not sure
> >> that's an argument against the patch?
> > 
> > fiemap at least tells you an extent is shared, bmap does not.
> 
> yes, so bmap is clearly the wrong interface to use if you want to
> write directly to a file's blocks.  But if you know enough to check
> the fiemap shared flag, you know enough to not use fibmap for that purpose...
> 

FWIW, this patch seems reasonable to me. To Christoph's point, I don't
think either interface really grants license to write to the underlying
blocks, so either way it's technically being abused for this purpose.
Unless there's a clear way to return an error for a particular type of
file, I think it's reasonable behavior for fibmap to expose the data it
supports (i.e., block maps) and drop the data it doesn't (reflink
state).

Brian

> -Eric
