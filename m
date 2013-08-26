Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0FA217F54
	for <xfs@oss.sgi.com>; Mon, 26 Aug 2013 11:12:56 -0500 (CDT)
Date: Mon, 26 Aug 2013 11:12:52 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch] xfs: check for underflow in xfs_iformat_fork()
Message-ID: <20130826161252.GV7153@sgi.com>
References: <20130815055338.GC23580@elgon.mountain>
	<520CA923.4060409@oracle.com> <20130815143706.GI7153@sgi.com>
	<20130815222650.GX6023@dastard> <20130823173613.GT5262@sgi.com>
	<20130826143714.GA6329@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130826143714.GA6329@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jeff Liu <jeff.liu@oracle.com>

Hey Dan,

On Mon, Aug 26, 2013 at 05:37:15PM +0300, Dan Carpenter wrote:
> On Fri, Aug 23, 2013 at 12:36:13PM -0500, Ben Myers wrote:
> > Dan,
> > 
> > On Fri, Aug 16, 2013 at 08:26:50AM +1000, Dave Chinner wrote:
> > > On Thu, Aug 15, 2013 at 09:37:06AM -0500, Ben Myers wrote:
> > > > Hey Dan & Jeff,
> > > > 
> > > > On Thu, Aug 15, 2013 at 06:10:43PM +0800, Jeff Liu wrote:
> > > > > On 08/15/2013 01:53 PM, Dan Carpenter wrote:
> > > > > 
> > > > > > The "di_size" variable comes from the disk and it's a signed 64 bit.
> > > > > > We check the upper limit but we should check for negative numbers as
> > > > > > well.
> > > > > > 
> > > > > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> > > > > > index 123971b..849fc70 100644
> > > > > > --- a/fs/xfs/xfs_inode_fork.c
> > > > > > +++ b/fs/xfs/xfs_inode_fork.c
> > > > > > @@ -167,7 +167,8 @@ xfs_iformat_fork(
> > > > > >  			}
> > > > > >  
> > > > > >  			di_size = be64_to_cpu(dip->di_size);
> > > > > > -			if (unlikely(di_size > XFS_DFORK_DSIZE(dip, ip->i_mount))) {
> > > > > > +			if (unlikely(di_size < 0 ||
> > > > > 
> > > > > But the di_size is initialized to ZERO while allocating a new inode on disk.
> > > > > I wonder if that is better to ASSERT in this case because the current check
> > > > > is used to make sure that the item is inlined, or we don't need it at all.
> > > > 
> > > > Hmm.  Dan's additional check looks good to me.  In this case I'd say the forced
> > > > shutdown is more appropriate than an assert, because here we're reading the
> > > > inode from disk, as opposed to looking at a structure that is already incore
> > > > which we think we've initialized.  We want to handle unexpected inputs from
> > > > disk without crashing even if we are CONFIG_XFS_DEBUG.
> > > 
> > > There are lots of places where we only check di_size to be greater
> > > than some value, and don't check for it being less than zero. Hence
> > > I think that a better solution might be to di_size unsigned as that
> > > will catch "negative" sizes for all types of situations.
> > 
> > What do you say to making di_size unsigned?  Any interest?
> > 
> 
> I'm not the right person to change "lots of places".  Some of these
> are probably subtle.  Just give me the reported-by and I'm happy.

I'll apply this for now, and we'll see if someone is interested enough to pick
up the rest.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
