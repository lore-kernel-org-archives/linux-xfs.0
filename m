Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2EF57CBF
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 17:47:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ADB7A304048
	for <xfs@oss.sgi.com>; Tue, 27 Aug 2013 15:47:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	dmCg9LlyWvFFOR57 for <xfs@oss.sgi.com>;
	Tue, 27 Aug 2013 15:47:26 -0700 (PDT)
Date: Wed, 28 Aug 2013 08:47:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: check correct status variable for
	xfs_inobt_get_rec() call
Message-ID: <20130827224722.GZ6023@dastard>
References: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1377638145-18800-1-git-send-email-bfoster@redhat.com>
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

On Tue, Aug 27, 2013 at 05:15:45PM -0400, Brian Foster wrote:
> The call to xfs_inobt_get_rec() in xfs_dialloc_ag() passes 'j' as
> the output status variable. The immediately following
> XFS_WANT_CORRUPTED_GOTO() checks the value of 'i,' which is from
> the previous lookup call and has already been checked. Fix the
> corruption check to use 'j.'
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
