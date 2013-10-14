Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C92AB7F54
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 23:45:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73B59AC002
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 21:45:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	F2jpFGvFiqlrt99l for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 21:45:07 -0700 (PDT)
Date: Mon, 14 Oct 2013 15:45:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] xfs: reject completely bogus remount options
Message-ID: <20131014044501.GE4446@dastard>
References: <52584C8A.1060808@redhat.com> <52584D56.7090902@sandeen.net>
	<20131013215208.GE5663@dastard> <525B5A1D.90706@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <525B5A1D.90706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, Oct 13, 2013 at 09:42:37PM -0500, Eric Sandeen wrote:
> On 10/13/13 4:52 PM, Dave Chinner wrote:
> > On Fri, Oct 11, 2013 at 02:11:18PM -0500, Eric Sandeen wrote:
> >> There's a long comment about handling non-remountable
> >> options in xfs_fs_remount, but nothing addresses the case
> >> of completely bogus mount options at remount time, which
> >> can lead to some severe strangeness:
> >>
> >> # for I in `seq 1 10`; do mount -o remount,noacl /mnt/test2; done
> >> # for I in `seq 1 10`; do mount -o remount,badoption /mnt/test2; done
> >> # grep sdb4 /etc/mtab
> >> /dev/sdb4 /mnt/test2 xfs rw,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,noacl,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption,badoption 0 0
> >>
> >> This is a bit of a hack, but we can re-use xfs_parseargs()
> >> with a dummy mount struct to just vet all of the remount
> >> options which were passed in.  With this, we get a saner
> >> result:
> >>
> >> [44898.102990] EXT4-fs (sdb4): Unrecognized mount option "badoption" or missing value
> > 
> > ext4? Really? :)
> 
> 
> uhhh ;)
> 
> >> +++ b/fs/xfs/xfs_super.c
> >> @@ -1202,11 +1202,25 @@ xfs_fs_remount(
> >>  	int			*flags,
> >>  	char			*options)
> >>  {
> >> -	struct xfs_mount	*mp = XFS_M(sb);
> >> +	struct xfs_mount	*mp = XFS_M(sb), *dummy_mp;
> >>  	substring_t		args[MAX_OPT_ARGS];
> >>  	char			*p;
> >>  	int			error;
> >>  
> >> +	/*
> >> +	 * Check all the mount options presented to be sure
> >> +	 * there's nothing too crazy in there.  Non-remountable
> >> +	 * but valid options are a different issue.
> >> +	 */
> >> +	dummy_mp = kmem_zalloc(sizeof(*dummy_mp), KM_MAYFAIL);
> >> +	if (dummy_mp) {
> >> +		dummy_mp->m_super = sb;
> >> +		error = xfs_parseargs(dummy_mp, options);
> >> +		kfree(dummy_mp);
> >> +		if (error)
> >> +			return -error;
> > 
> > This, at minimum, leaks dummy_mp->m_fsname, and it will leak other
> > strings that are also kstrdup()d by xfs_parseargs().
> 
> nnngh.  Forgot about that side effect, sorry.  Dammit.
> 
> Think it's still worth doing this if I handle freeing them all up?

If you wrap it all in a helper function (xfs_check-args()?) that
does all the temporary structure allocation and freeing, I think
it will be fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
