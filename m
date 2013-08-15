Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A7D07F4E
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 09:37:07 -0500 (CDT)
Date: Thu, 15 Aug 2013 09:37:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130815143706.GI7153@sgi.com>
References: <20130815055338.GC23580@elgon.mountain>
	<520CA923.4060409@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520CA923.4060409@oracle.com>
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
To: Dan Carpenter <dan.carpenter@oracle.com>, Jeff Liu <jeff.liu@oracle.com>
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hey Dan & Jeff,

On Thu, Aug 15, 2013 at 06:10:43PM +0800, Jeff Liu wrote:
> On 08/15/2013 01:53 PM, Dan Carpenter wrote:
> 
> > The "di_size" variable comes from the disk and it's a signed 64 bit.
> > We check the upper limit but we should check for negative numbers as
> > well.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> > index 123971b..849fc70 100644
> > --- a/fs/xfs/xfs_inode_fork.c
> > +++ b/fs/xfs/xfs_inode_fork.c
> > @@ -167,7 +167,8 @@ xfs_iformat_fork(
> >  			}
> >  
> >  			di_size = be64_to_cpu(dip->di_size);
> > -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> > +			if (unlikely(di_size < 0 ||
> 
> But the di_size is initialized to ZERO while allocating a new inode on disk.
> I wonder if that is better to ASSERT in this case because the current check
> is used to make sure that the item is inlined, or we don't need it at all.

Hmm.  Dan's additional check looks good to me.  In this case I'd say the forced
shutdown is more appropriate than an assert, because here we're reading the
inode from disk, as opposed to looking at a structure that is already incore
which we think we've initialized.  We want to handle unexpected inputs from
disk without crashing even if we are CONFIG_XFS_DEBUG.

How did you come across this one?

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
