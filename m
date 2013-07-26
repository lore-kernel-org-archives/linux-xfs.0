Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13F277F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 19:19:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 057098F8033
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 17:19:24 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ILnbP8uhhxBZFCAe for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 17:19:23 -0700 (PDT)
Date: Fri, 26 Jul 2013 10:19:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 21/48] xfs: implement extended feature masks
Message-ID: <20130726001917.GI13468@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-22-git-send-email-david@fromorbit.com>
	<20130725220814.GI3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130725220814.GI3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 25, 2013 at 05:08:14PM -0500, Ben Myers wrote:
> On Fri, Jun 07, 2013 at 10:25:44AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The version 5 superblock has extended feature masks for compatible,
> > incompatible and read-only compatible feature sets. Implement the
> > masking and mount-time checking for these feature masks.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> corresponds to commit e721f504cf46a
> 
> > @@ -214,12 +242,6 @@ xfs_mount_validate_sb(
> >  		return XFS_ERROR(ENOSYS);
> >  	}
> >  
> > -
> > -	if (check_inprogress && sbp->sb_inprogress) {
> > -		xfs_warn(mp, "Offline file system operation in progress!");
> > -		return XFS_ERROR(EFSCORRUPTED);
> > -	}
> > -
> 
> Why did this need to be removed?

Think about it for a minute - it's not valid in userspace. i.e. it's
a kernel-side check to determine if userspace is modifying the
filesystem at the current time.

e.g. mkfs.xfs sets it in the primary superblock to prevent the
kernel mounting the filesystem before mkfs completes. If we leave it
in the userspace code, then mkfs will abort when it rereads the
superblock from disk because it's detected that mkfs is running....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
