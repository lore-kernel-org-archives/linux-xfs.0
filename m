Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC6ED7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Feb 2015 00:40:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAE0B304032
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2015 22:40:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	jIYkQOHIXIlK9EFt for <xfs@oss.sgi.com>;
	Tue, 24 Feb 2015 22:40:40 -0800 (PST)
Date: Wed, 25 Feb 2015 17:40:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: superblock buffers need to be sector sized
Message-ID: <20150225064038.GE18360@dastard>
References: <1424761944-2034-1-git-send-email-david@fromorbit.com>
	<20150224133652.GB45528@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150224133652.GB45528@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Tue, Feb 24, 2015 at 08:36:52AM -0500, Brian Foster wrote:
> On Tue, Feb 24, 2015 at 06:12:24PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > In secondary_sb_wack() we zero the unused portion of both the
> > on-disk superblock and the in-memory copy that we have. When
> > the device sector size is 4k, this causes xfs_repair to crash like
> > so:
> > 
> > # xfs_repair /dev/ram1
> > Phase 1 - find and verify superblock...
> > Phase 2 - using internal log
> >         - zero log...
> >         - scan filesystem freespace and inode maps...
> > bad magic number
> > bad on-disk superblock 3 - bad magic number
> > primary/secondary superblock 3 conflict - AG superblock geometry info conflicts with filesystem geometry
> > zeroing unused portion of secondary superblock (AG #3)
> > #
> > 
> > The stack trace is indicative:
> > 
> > #0  memset ()
> > #1  0x000000000040404b in secondary_sb_wack
> > #2  verify_set_agheader
> > #3  0x0000000000427b4b in scan_ag
> > #4  0x000000000042a2ca in worker_thread
> > #5  0x00007ffff77ba0a4 in start_thread
> > #6  0x00007ffff74efc2d in clone
> > 
> > Which points at memset overrunning the in memory buffer, as it is
> > only 512 bytes in length.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> The patch subject line should probably say 'xfsprogs:' or 'repair:,'
> otherwise this looks good to me:

Right, my mistake.

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
