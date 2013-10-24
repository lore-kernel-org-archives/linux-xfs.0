Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D426B7F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 17:28:14 -0500 (CDT)
Date: Thu, 24 Oct 2013 17:28:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 13/19] xfs: vectorise directory data operations
Message-ID: <20131024222811.GA10553@sgi.com>
References: <1381789085-21923-1-git-send-email-david@fromorbit.com>
	<1381789085-21923-14-git-send-email-david@fromorbit.com>
	<20131024183909.GV1935@sgi.com> <20131024213117.GX2797@dastard>
	<20131024214112.GZ10553@sgi.com> <20131024220844.GY2797@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131024220844.GY2797@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 25, 2013 at 09:08:44AM +1100, Dave Chinner wrote:
> On Thu, Oct 24, 2013 at 04:41:12PM -0500, Ben Myers wrote:
> > On Fri, Oct 25, 2013 at 08:31:17AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 24, 2013 at 01:39:09PM -0500, Ben Myers wrote:
> > > > On Tue, Oct 15, 2013 at 09:17:59AM +1100, Dave Chinner wrote:
> > > > > From: Dave Chinner <dchinner@redhat.com>
> > > > > 
> > > > > Following from the initial patches to vectorise the shortform
> > > > > directory encode/decode operations, convert half the data block
> > > > > operations to use the vector. The rest will be done in a second
> > > > > patch.
> > > > > 
> > > > > This further reduces the size of the built binary:
> > > > > 
> > > > >    text    data     bss     dec     hex filename
> > > > >  794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
> > > > >  792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
> > > > >  792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
> > > > >  789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
> > > > > 
> > > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Generally looks pretty good, I have a question below...
> > > > 
> > > > >  const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> > > > > @@ -223,6 +415,18 @@ const struct xfs_dir_ops xfs_dir2_ftype_ops = {
> > > > >  	.sf_put_ino = xfs_dir3_sfe_put_ino,
> > > > >  	.sf_get_parent_ino = xfs_dir2_sf_get_parent_ino,
> > > > >  	.sf_put_parent_ino = xfs_dir2_sf_put_parent_ino,
> > > > > +
> > > > > +	.data_entsize = xfs_dir3_data_entsize,
> > > > > +	.data_get_ftype = xfs_dir3_data_get_ftype,
> > > > > +	.data_put_ftype = xfs_dir3_data_put_ftype,
> > > > > +	.data_entry_tag_p = xfs_dir3_data_entry_tag_p,
> > > > > +
> > > > > +	.data_dot_offset = xfs_dir2_data_dot_offset,
> > > > > +	.data_dotdot_offset = xfs_dir2_data_dotdot_offset,
> > > > > +	.data_first_offset = xfs_dir2_data_first_offset,
> > > > > +	.data_dot_entry_p = xfs_dir2_data_dot_entry_p,
> > > > > +	.data_dotdot_entry_p = xfs_dir2_data_dotdot_entry_p,
> > > > > +	.data_first_entry_p = xfs_dir2_data_first_entry_p,
> > > > >  };
> > > > 
> > > > I think there may be a problem here.  Although the dirv2 functions for
> > > > ., .., and first entry offset account for the v2 header size, they
> > > > appear not to be accounting for the modified entry size due to the file
> > > > type field.  Am I missing something?
> > > 
> > > The ftype field is handled by the alignment roundup. i.e. namelen is
> > > 1 or two bytes, plus ftype is 2 or 3 bytes, roundup is to 8 bytes.
> > > Hence adding a byte for the ftype field is not a problem for these
> > > first entries because of their small, fixed size.
> 
> I should point out that this code is functionally identical to the
> way the original macros treated the v4 ftype code. You reviewed that
> code and tested it and it as such this implicit use of padding was
> considered perfectly OK just a couple of months ago.....

It is a detail that I overlooked.  I try to do a thorough review... but
sometimes things don't register.

> > It should either be explicitly correct (and I think it is today), or we
> > need a comment to explain why it's not.  I would prefer the former.
> 
> Well, I'll add a patch at the end of the series to change it. I don't want to
> have to rebase the rest of the patches in the series just because of the
> don't apply because of context mismatches.

Sounds great.

> 
> Besides, the last patch in the series it replaces the offset functions with
> precalculated values. That replacement fixes the offset calculation to
> explicitly use dir2 hdrs and dir3 entsizes, so the problem goes away for
> those entries.

Ok, I'll look out for it then.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
