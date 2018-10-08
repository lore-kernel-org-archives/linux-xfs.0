Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40678 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbeJICN2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 22:13:28 -0400
Date: Mon, 8 Oct 2018 11:59:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/15] vfs: change clone and dedupe range function
 pointers to return bytes completed
Message-ID: <20181008185951.GF28243@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
 <153870033496.29072.3660384210745578982.stgit@magnolia>
 <20181006104134.GF25747@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181006104134.GF25747@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

On Sat, Oct 06, 2018 at 03:41:34AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 04, 2018 at 05:45:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Change the clone_file_range and dedupe_file_range functions to return
> > the number of bytes they operated on.  This is the precursor to allowing
> > fs implementations to return short clone/dedupe results to the user,
> > which will enable us to obey resource limits in a graceful manner.
> 
> For clone this doesn't make any sense, as we don't allow 'short clones'.

That's correct.  The overall goal is that copy_file_range will be able
to call ->clone_file_range with a "I can handle a short clone" flag so
that the fs (and the prep functions) know that they're allowed to
shorten the request length, and we have a way to communicate the actual
results back to userspace.

Neither FS_IOC_CLONE nor FS_IOC_CLONERANGE will be able to take
advantage of this, of course.  They won't pass in the flag, and any
implementation that wants to shorten the length will pass back -EINVAL
instead.

--D
