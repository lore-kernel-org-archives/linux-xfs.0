Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4E8537CA9
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:50:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE147AC006
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:50:16 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Tkfwc7yzNCrWOhSa for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:49:54 -0800 (PST)
Date: Wed, 17 Feb 2016 18:49:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/15] xfs: use vfs inode nlink field everywhere
Message-ID: <20160217074952.GE19486@dastard>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
	<1455693652-3899-13-git-send-email-david@fromorbit.com>
	<20160217073506.GC16363@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217073506.GC16363@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 16, 2016 at 11:35:06PM -0800, Christoph Hellwig wrote:
> > index 685c7a7..1408be3 100644
> > --- a/libxfs/libxfs_api_defs.h
> > +++ b/libxfs/libxfs_api_defs.h
> > @@ -108,4 +108,8 @@
> >  
> >  #define xfs_verify_cksum		libxfs_verify_cksum
> >  
> > +/* inode link counts */
> > +#define set_nlink(inode, nlink)	({ (inode)->i_nlink = (nlink); })
> > +#define inc_nlink(inode)	(inode)->i_nlink++
> 
> Can we defines these as inlines?

I'll probably have to move them somewhere else for that.
include/xfs_inode.h will probably work.

> 
> > +		ip->i_vnode.i_nlink++;		/* account for . */
> 
> Shouldn't we use VFS_I() like everywhere else?

inc_nlink(), too. I forgot to go back and change it when I decided
on adding the wrapper.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
