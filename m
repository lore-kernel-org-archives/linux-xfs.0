Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4A8C27CA0
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 15:39:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18722304032
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:39:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id RJKTRwbVLlvEeaZu (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Aug 2016 13:39:38 -0700 (PDT)
Date: Wed, 24 Aug 2016 13:39:33 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: don't perform lookups on zero-height btrees
Message-ID: <20160824203933.GA20705@birch.djwong.org>
References: <20160819203022.GD8268@birch.djwong.org>
	<20160824180154.GA8982@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160824180154.GA8982@bfoster.bfoster>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 24, 2016 at 02:01:55PM -0400, Brian Foster wrote:
> On Fri, Aug 19, 2016 at 01:30:22PM -0700, Darrick J. Wong wrote:
> > If the caller passes in a cursor to a zero-height btree (which is
> > impossible), we never set block to anything but NULL, which causes the
> > later dereference of it to crash.  Instead, just return -EFSCORRUPTED.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Did something actually cause this to happen?

Well, if you took a reflink xfs that was formatted before we added the
rmap/refcount btree block counters to the AGF and then tried to mount
it after will blow up like this, because the refcount_level field got
moved to somewhere that's zero in the old image.

Anyone being malicious with xfs_db can also do this to any other _level field.

(Yay automounting!)

--D

> 
> Brian
> 
> >  fs/xfs/libxfs/xfs_btree.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > index 64fd847..4bffea4 100644
> > --- a/fs/xfs/libxfs/xfs_btree.c
> > +++ b/fs/xfs/libxfs/xfs_btree.c
> > @@ -1814,6 +1814,10 @@ xfs_btree_lookup(
> >  
> >  	XFS_BTREE_STATS_INC(cur, lookup);
> >  
> > +	/* No such thing as a zero-level tree. */
> > +	if (cur->bc_nlevels == 0)
> > +		return -EFSCORRUPTED;
> > +
> >  	block = NULL;
> >  	keyno = 0;
> >  
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
