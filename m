Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4DEF27F5E
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:25:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C01A8F8070
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:25:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gSBHICH99AxUmtcy for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:25:52 -0700 (PDT)
Date: Wed, 25 Mar 2015 08:25:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: add initial DAX support
Message-ID: <20150324212550.GU28621@dastard>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-9-git-send-email-david@fromorbit.com>
	<55115E20.7090105@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55115E20.7090105@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 02:52:48PM +0200, Boaz Harrosh wrote:
> On 03/24/2015 12:51 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > @@ -363,6 +365,10 @@ xfs_parseargs(
> >  			mp->m_flags |= XFS_MOUNT_DISCARD;
> >  		} else if (!strcmp(this_char, MNTOPT_NODISCARD)) {
> >  			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> > +#ifdef CONFIG_FS_DAX
> > +		} else if (!strcmp(this_char, MNTOPT_DAX)) {
> > +			mp->m_flags |= XFS_MOUNT_DAX;
> 
> Hi
> 
> So what I see, (I might be wrong), is that once this flag is set here the
> fs (At above xfs_diflags_to_iflags() ) will start serving DAX inodes.

No, it won't, because...

> > @@ -1501,6 +1508,20 @@ xfs_fs_fill_super(
> >  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> >  		sb->s_flags |= MS_I_VERSION;
> >  
> > +	if (mp->m_flags & XFS_MOUNT_DAX) {
> > +		xfs_warn(mp,
> > +	"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> > +		if (sb->s_blocksize != PAGE_SIZE) {
> > +			xfs_alert(mp,
> > +		"Filesystem block size invalid for DAX Turning DAX off.");
> > +			mp->m_flags &= ~XFS_MOUNT_DAX;
> > +		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
> > +			xfs_alert(mp,
> > +		"Block device does not support DAX Turning DAX off.");
> > +			mp->m_flags &= ~XFS_MOUNT_DAX;
> > +		}
> > +	}

We run these tests and then clear the XFS_MOUNT_DAX flag later.

> If we agree about the s_flags MS_MOUNT_DAX  then we can define a
> 	if (MNTOPT_DAX)
> 		dax_enable_if_supported(sb);

No, I don't see any reason for a mount flag for this, because we
do not want to be stuck relying on a mount option forever. Once
This code has been shaken out, I fully intend DAX to be turned on
automatically for any device that supports, and for it to be turned
on and off on a per-inode basis through on-disk inode flags. i.e.
the mount option is really a temporary solution and I don't want to
code in any dependencies on DAX being mount wide existing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
