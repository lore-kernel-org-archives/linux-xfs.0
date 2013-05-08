Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 236C529E0E
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 21:41:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0844A304051
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:41:30 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	sgSOtqkKBKvpWuXf for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 19:41:29 -0700 (PDT)
Date: Wed, 8 May 2013 12:41:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: automatically add -F to xfs_io on non-xfs
Message-ID: <20130508024124.GI24635@dastard>
References: <51850BED.6050109@redhat.com>
 <5189B9DA.7010807@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5189B9DA.7010807@sandeen.net>
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
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 07, 2013 at 09:35:06PM -0500, Eric Sandeen wrote:
> The -F flag to xfs_io originally enabled it to operate on non-xfs
> filesystems.  This restriction was removed upstream in favor of
> gracefully failing on the handful of operations that actually
> required xfs, and the option was deprecated.
> 
> However, xfstests is still used on distros with older xfsprogs, and
> so "xfs_io -F" was necessary throughout xfstests.
> 
> Simplify this by appending -F to XFS_IO_PROG when it's needed -
> i.e. if we're using old xfsprogs on a non-xfs filesystem.
> 
> This will eliminate errors when new tests leave out the -F, and
> if and when -F is finally removed, there will be one central
> location in xfstests to update.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: test for necessity of -F in all cases, and convert
> a bunch more direct callers of xfs_io to $XFS_IO_PROG

Yup, that fixes the one concern I had with the first patch.
Loks good.

Acked-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
