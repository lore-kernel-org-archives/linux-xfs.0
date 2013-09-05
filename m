Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 294FA7F58
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 19:36:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6442AC003
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:36:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gmSGvtC9Hxc6GEGR for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 17:36:24 -0700 (PDT)
Date: Thu, 5 Sep 2013 10:36:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 01/11] xfs: refactor xfs_ialloc_btree.c to support
	multiple inobt numbers
Message-ID: <20130905003621.GO23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-2-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:24:58PM -0400, Brian Foster wrote:
> The introduction of the free inode btree (finobt) requires that
> xfs_ialloc_btree.c handle multiple trees. Refactor xfs_ialloc_btree.c
> so the caller specifies the btree type on cursor initialization to
> prepare for addition of the finobt.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Simple enough, obvious place to start. :)

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
