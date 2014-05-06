Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D6237FC9
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 03:02:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80A5C8F8035
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 01:02:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kZmCTwLtTzt6oV81 for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 01:02:05 -0700 (PDT)
Date: Tue, 6 May 2014 18:02:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: remove shared supberlock feature checking
Message-ID: <20140506080203.GC5421@dastard>
References: <1399348559-19889-1-git-send-email-david@fromorbit.com>
	<1399348559-19889-6-git-send-email-david@fromorbit.com>
	<536893DB.7050705@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <536893DB.7050705@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 03:48:43PM +0800, Jeff Liu wrote:
> 
> On 05/06 2014 11:55 AM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We reject any filesystem that is mounted with this feature bit set,
> > so we don't need to check for it anywhere else. Remove the function
> > for checking if the feature bit is set and any code that uses it.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_fsops.c |  2 --
> >  fs/xfs/xfs_sb.c    |  3 ++-
> >  fs/xfs/xfs_sb.h    | 17 ++++-------------
> >  3 files changed, 6 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > index b099799..97886a7 100644
> > --- a/fs/xfs/xfs_fsops.c
> > +++ b/fs/xfs/xfs_fsops.c
> > @@ -84,8 +84,6 @@ xfs_fs_geometry(
> >  				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
> >  			(xfs_sb_version_hasdalign(&mp->m_sb) ?
> >  				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
> > -			(xfs_sb_version_hasshared(&mp->m_sb) ?
> > -				XFS_FSOP_GEOM_FLAGS_SHARED : 0) |
> 
> Just a trivial comments, now the XFS_FSOP_GEOM_FLAGS_SHARED is useless, so
> we can remove it from fs/xfs/xfs.h.

That's a public API header file, so removing it could break
applications. It's OK to leave it there, I think.

> Otherwise, looks good to me.
> 
> Reviewed-by: Jie Liu <jeff.liu@oracle.com>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
