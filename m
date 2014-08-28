Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A74777F3F
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 17:37:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7DD468F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 15:37:11 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ArJgpXHTN4FBNSWM for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 15:37:09 -0700 (PDT)
Date: Fri, 29 Aug 2014 08:37:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: don't dirty buffers beyond EOF
Message-ID: <20140828223706.GT20518@dastard>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
	<1409226551-16570-2-git-send-email-david@fromorbit.com>
	<20140828133457.GA35386@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140828133457.GA35386@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 28, 2014 at 09:34:57AM -0400, Brian Foster wrote:
> On Thu, Aug 28, 2014 at 09:49:05PM +1000, Dave Chinner wrote:
> > +/*
> > + * This is basically a copy of __set_page_dirty_buffers() with one
> > + * small tweak: buffers beyond EOF do not get marked dirty. If we mark them
> > + * dirty, we'll never be able to clean them because we don't write buffers
> > + * beyond EOF, and that means we can't invalidate pages that span EOF
> > + * that have been marked dirty. Further, the dirty state can leak into
> > + * the file interior if the file is extended, resulting in all sorts of
> > + * bad things happening as the state does not match the unerlying data.
> > + */
> > +STATIC int
> > +xfs_vm_set_page_dirty(
> > +	struct page		*page)
> > +{
> > +	struct address_space	*mapping = page->mapping;
> > +	struct inode		*inode = mapping->host;
> > +	loff_t			end_offset;
> > +	loff_t			offset;
> > +	int			newly_dirty;
> > +
> > +	if (unlikely(!mapping))
> > +		return !TestSetPageDirty(page);
> > +
> > +	end_offset = i_size_read(inode);
> > +	offset = end_offset & PAGE_CACHE_MASK;
> 
> Is this what you intended to do here?
> 
> 	offset = page_offset(page);

Yup, that's a bug. Which points out just how important the buffer
dirty flag is (not) to XFS, doesn't it?

I'll post a fixed patch in a few minutes after it's run a few
tens of millions fsx ops...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
