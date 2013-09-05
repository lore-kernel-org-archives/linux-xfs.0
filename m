Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 935D429DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 20:00:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CADD8F804C
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 18:00:42 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kXOG8oIXLGtNuWar for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 18:00:41 -0700 (PDT)
Date: Thu, 5 Sep 2013 11:00:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 05/11] xfs: update ifree transaction reservations for
	finobt
Message-ID: <20130905010036.GS23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-6-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-6-git-send-email-bfoster@redhat.com>
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

On Tue, Sep 03, 2013 at 02:25:02PM -0400, Brian Foster wrote:
> Update the ifree transaction log reservations to support the
> finobt. An inode free can now mean an extra record modification,
> record removal (i.e., inode chunk being freed) or a record
> insertion (i.e., a previously full inode chunk).
> 
> Define XFS_IFREE_SPACE_RES() for the inactive transaction to
> reserve data blocks for possible finobt merge/split situations.

Same comment about doing this with helper functions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
