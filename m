Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeJORkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 13:40:21 -0400
Date: Mon, 15 Oct 2018 02:55:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 00/22] xfs-4.20: major documentation surgery
Message-ID: <20181015095549.GA23946@infradead.org>
References: <153862669110.26427.16504658853992750743.stgit@magnolia>
 <20181006005154.GM12041@dastard>
 <20181011112735.4f696d8a@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011112735.4f696d8a@lwn.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jonathan Corbet <corbet@lwn.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org

On Thu, Oct 11, 2018 at 11:27:35AM -0600, Jonathan Corbet wrote:
> On Sat, 6 Oct 2018 10:51:54 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > Can you let us know whether the CC-by-SA 4.0 license is acceptible
> > or not? That's really the only thing that we need clarified at this
> > point - if it's OK I'll to pull this into the XFS tree for the 4.20
> > merge window. If not, we'll go back to the drawing board....
> 
> OK, I've had a long conversation with the LF lawyer, and she said clearly
> that we really should not be introducing CC-SA material into the kernel
> source tree.  It's a pain; I really do like CC-SA better for
> documentation, but it's not GPL-compatible, and that creates a problem for
> the processed docs.

That was exactly my concern with this patchset.

Btw, I think we have the same issue with idr.rst, and unless we can
relicense it we should drop it from the tree, as it actually includes
kernel source files.
