Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57264 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbeJOXgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 19:36:10 -0400
Date: Mon, 15 Oct 2018 08:49:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 24/25] xfs: support returning partial reflink results
Message-ID: <20181015154959.GI28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938931226.8361.7365948775364411156.stgit@magnolia>
 <20181014173546.GI30673@infradead.org>
 <20181014230536.GY6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014230536.GY6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 10:05:36AM +1100, Dave Chinner wrote:
> On Sun, Oct 14, 2018 at 10:35:46AM -0700, Christoph Hellwig wrote:
> > On Fri, Oct 12, 2018 at 05:08:32PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Back when the XFS reflink code only supported clone_file_range, we were
> > > only able to return zero or negative error codes to userspace.  However,
> > > now that copy_file_range (which returns bytes copied) can use XFS'
> > > clone_file_range, we have the opportunity to return partial results.
> > > For example, if userspace sends a 1GB clone request and we run out of
> > > space halfway through, we at least can tell userspace that we completed
> > > 512M of that request like a regular write.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/xfs_file.c    |    5 +----
> > >  fs/xfs/xfs_reflink.c |   20 +++++++++++++++-----
> > >  fs/xfs/xfs_reflink.h |    2 +-
> > >  3 files changed, 17 insertions(+), 10 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index bc9e94bcb7a3..b2b15b8dc4a1 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -928,14 +928,11 @@ xfs_file_remap_range(
> > >  	loff_t		len,
> > >  	unsigned int	remap_flags)
> > >  {
> > > -	int		ret;
> > > -
> > >  	if (!remap_check_flags(remap_flags, RFR_SAME_DATA))
> > >  		return -EINVAL;
> > >  
> > > -	ret = xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > > +	return xfs_reflink_remap_range(file_in, pos_in, file_out, pos_out,
> > >  			len, remap_flags);
> > 
> > Is there any reason not to merge xfs_file_remap_range and
> > xfs_reflink_remap_range at this point?
> 
> Yeah, that seems like a good idea to me - pulling all the
> vfs/generic code interactions back up into xfs_file.c would match
> how the rest of the file operations are layered w.r.t. external and
> internal XFS code...

Yeah, ditto ocfs2.  I'll look into throwing a few more refactors onto
the end of this series... 8-D

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
