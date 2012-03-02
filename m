Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q229ng0T027127 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 03:49:42 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LmoK7WJm9XBQml9M for <xfs@oss.sgi.com>;
	Fri, 02 Mar 2012 01:49:40 -0800 (PST)
Date: Fri, 2 Mar 2012 20:49:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: handle kmalloc failure when reading attrs
Message-ID: <20120302094938.GH5091@dastard>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-4-git-send-email-david@fromorbit.com>
	<20120302074920.GE4117@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120302074920.GE4117@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Mar 02, 2012 at 02:49:20AM -0500, Christoph Hellwig wrote:
> I think the subject should be more like:
> 
> xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get

OK.

> > +	kbuf = kmem_zalloc(*len, KM_SLEEP | KM_MAYFAIL);
> > +	if (!kbuf) {
> > +		kbuf = kmem_zalloc_large(*len);
> > +		if (!kbuf)
> > +			return ENOMEM;
> > +	}
> >  
> >  	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
> >  	if (error)
> > @@ -457,7 +460,7 @@ xfs_attrmulti_attr_get(
> >  		error = EFAULT;
> >  
> >   out_kfree:
> > -	kfree(kbuf);
> > +	kmem_free(kbuf);
> 
> kmem_free doesn't handle vmalloced buffers from kmem_zalloc_large, you
> need to use kmem_free_large for them.

static inline void kmem_free_large(void *ptr)
{
        vfree(ptr);
}

That only handles vmalloced memory, but kmem_free()
handles both kmalloc() and vmalloc() memory:

void
kmem_free(const void *ptr)
{
        if (!is_vmalloc_addr(ptr)) {
                kfree(ptr);
        } else {
                vfree(ptr);
        }
}

Avoiding having to open code this vmalloc check is exactly why I
chose kmem_free() here ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
