Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7A8E7F56
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:39:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7634A8F8035
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 15:39:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	GBP7q00KV4mGLU7o for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 15:39:51 -0700 (PDT)
Date: Fri, 22 Aug 2014 08:38:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: mmap write/read leaves bad state on pages
Message-ID: <20140821223845.GP26465@dastard>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-2-git-send-email-david@fromorbit.com>
	<20140821124823.GB64112@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140821124823.GB64112@bfoster.bfoster>
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
Cc: clm@fb.com, xfs@oss.sgi.com

On Thu, Aug 21, 2014 at 08:48:24AM -0400, Brian Foster wrote:
> On Thu, Aug 21, 2014 at 03:09:09PM +1000, Dave Chinner wrote:
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1753,11 +1753,69 @@ xfs_vm_readpages(
> >  	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
> >  }
> >  
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
> > +	struct address_space	*mapping = page_mapping(page);
> 
> This breaks xfs as a kernel module:
> 
> $ make -j 8 M=fs/xfs
>   Building modules, stage 2.
>   MODPOST 1 modules
> WARNING: "page_mapping" [fs/xfs/xfs.ko] undefined!
>   ...

Oh, that should just be:

+	struct address_space	*mapping = page->mapping;

> I suppose we could export that symbol, but why wouldn't we just propose
> this change to __set_page_dirty_buffers()?

I'm not going to risk breaking other filesystems that have implicit
dependencies on buffers beyond EOF being dirtied.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
