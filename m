Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB0257F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:13:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B969B8F8066
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 16:13:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Yd6VkLlV6DVJm1BJ for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 16:13:34 -0700 (PDT)
Date: Fri, 24 May 2013 09:13:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] xfs: don't emit v5 superblock warnings on write
Message-ID: <20130523231332.GD24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-9-git-send-email-david@fromorbit.com>
	<20130522222608.GR20028@sgi.com> <20130523000327.GQ29466@dastard>
	<20130523152338.GS20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130523152338.GS20028@sgi.com>
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

On Thu, May 23, 2013 at 10:23:38AM -0500, Ben Myers wrote:
> On Thu, May 23, 2013 at 10:03:27AM +1000, Dave Chinner wrote:
> > On Wed, May 22, 2013 at 05:26:08PM -0500, Ben Myers wrote:
> > > On Tue, May 21, 2013 at 06:02:07PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > We write the superblock every 30s or so which results in the
> > > > verifier being called. Right now that results in this output
> > > > every 30s:
> > > > 
> > > > XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> > > > Use of these features in this kernel is at your own risk!
> > > > 
> > > > And spamming the logs. Stop this output from occurring on superblock
> > > > writes.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_mount.c |   18 +++++++++++-------
> > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > index f6bfbd7..e8e310c 100644
> > > > --- a/fs/xfs/xfs_mount.c
> > > > +++ b/fs/xfs/xfs_mount.c
> > > > @@ -314,7 +314,8 @@ STATIC int
> > > >  xfs_mount_validate_sb(
> > > >  	xfs_mount_t	*mp,
> > > >  	xfs_sb_t	*sbp,
> > > > -	bool		check_inprogress)
> > > > +	bool		check_inprogress,
> > > > +	bool		check_version)
> > > >  {
> > > >  
> > > >  	/*
> > > > @@ -337,9 +338,10 @@ xfs_mount_validate_sb(
> > > >  
> > > >  	/*
> > > >  	 * Version 5 superblock feature mask validation. Reject combinations the
> > > > -	 * kernel cannot support up front before checking anything else.
> > > > +	 * kernel cannot support up front before checking anything else. For
> > > > +	 * write validation, we don't need to check feature masks.
> > > >  	 */
> > > > -	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> > > > +	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> > > 
> > > if (!quiet_version) {
> > > >  		xfs_alert(mp,
> > > >  "Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!\n"
> > > >  "Use of these features in this kernel is at your own risk!");
> > > 
> > > }
> > > 
> > > Since the stated goal of the patch is to be quieter and not to disable useful
> > > tests in the verifier, I suggest you disable the print rather than disable the
> > > test.
> > 
> > Checking the feature fields for whether the kernel supports the
> > features in them on write is not useful in any way.
> 
> Could it not detect corruption of the feature flags before they're written out?
> My impression was that this was among the design goals of the verifiers.

It might, but we don't verify any of the existing feature flags,
either. For that matter, how do you verify them when the in-core
superblock can be modified asynchronously to the on-disk version in
the buffer without locking the incore superblock?

And if we do lock the incore superblock, how do we deal with the
lock inversion that this causes?

> > That's why the
> > variable is named "check_version" because it skips the v5
> > version field checking. This is stuff that is used by the mount
> > path (i.e. superblock read path), not the writeback path.
> 
> You were saying above that it's the write path that is spamming the logs.

The function is used by both the read and the write verifiers, but
the feature mask checks are only relevant to the read path which
occurs during mount. Doing the checks on write is what is spamming
the logs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
