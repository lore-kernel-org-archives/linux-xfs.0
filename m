Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 037F829DFB
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 18:49:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E38BF8F8066
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 16:49:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EBEpbuKZALr5L9sm for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 16:49:09 -0700 (PDT)
Date: Fri, 20 Sep 2013 09:49:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/4] xfs: push down inactive transaction mgmt for ifree
Message-ID: <20130919234905.GR9901@dastard>
References: <1379618121-35105-1-git-send-email-bfoster@redhat.com>
	<1379618121-35105-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379618121-35105-4-git-send-email-bfoster@redhat.com>
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

On Thu, Sep 19, 2013 at 03:15:20PM -0400, Brian Foster wrote:
> Push the inode free work performed during xfs_inactive() down into
> a new xfs_inactive_ifree() helper. This clears xfs_inactive() from
> all inode locking and transaction management more directly
> associated with freeing the inode xattrs, extents and the inode
> itself.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good. I'll wait for the fixed versions of the other patches
so i can test it before signing off on it. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
