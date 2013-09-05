Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C3D3729DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:59:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE78A8F8050
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:59:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SBttVJmgzS4ohC9o for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 17:59:50 -0700 (PDT)
Date: Thu, 5 Sep 2013 10:59:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 04/11] xfs: update inode allocation transaction
	reservations for finobt
Message-ID: <20130905005946.GR23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-5-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:25:01PM -0400, Brian Foster wrote:
> Update inode allocation transaction reservations for the finobt. A
> create via record modification requires a log reservation for the
> additional finobt record. Any such allocation could result in an
> finobt removal if the inode chunk has become fully allocated, thus
> we include a reservation for a finobt btree merge as well.
> Allocation of a new inode chunk must account for splits in the
> finobt as well as the existing ialloc tree.

These transaction reservation changes are only necessary for
filesystems with free inode btrees, otherwise they just use more log
space than is necessary.

Can you add helper functions for the free inode btree reservations,
and have them return 0 when the feature is not enabled? That way the
code stays pretty clean, is self documenting and doesn't take
unnecessary space when the feature is not enabled....

> Also update XFS_IALLOC_SPACE_RES() to reserve data blocks for
> finobt split/merge scenarios.

Needs to handle the enabled/disabled case, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
