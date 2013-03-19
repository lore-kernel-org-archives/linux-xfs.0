Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B58B7F3F
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 14:26:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B95D1AC006
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 12:26:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	arMyCfsQiHo1ruwG for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 12:26:40 -0700 (PDT)
Date: Wed, 20 Mar 2013 06:26:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsprogs: reduce bb_numrecs in bno/cnt btrees when
	log consumes all agf space
Message-ID: <20130319192638.GC6369@dastard>
References: <1363699415-28022-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363699415-28022-1-git-send-email-bfoster@redhat.com>
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

On Tue, Mar 19, 2013 at 09:23:35AM -0400, Brian Foster wrote:
> The mkfs code currently creates a single free space extent record
> for each of the bno and cnt btrees in each AG. The start block of
> the record is pushed forward on the AG that hosts an internal log.
> If the log happens to consume all available space in the AG, the
> start block becomes equal to sb->sb_agblocks and thus invalid.
> This causes xfs_repair to complain.
> 
> For example, the following sequence:
> 
> 	mkfs.xfs -d file,name=./fs.img,size=50g,agsize=16m
> 	xfs_repair ./fs.img
> 
> ... produces the following xfs_repair output:
> 
> 	Phase 1 - find and verify superblock...
> 	Phase 2 - using internal log
>         	- scan filesystem freespace and inode maps...
> 	invalid start block 4096 in record 0 of bno btree block 1600/1
> 	invalid start block 4096 in record 0 of cnt btree block 1600/2
>         	- found root inode chunk
> 	...
> 
> xfs_repair appears to correct the numrecs value such that subsequent
> checks are successful. The sequence above is pulled from xfstests
> test #250, which fails due to this behavior.
> 
> Modify mkfs.xfs such that we check the block count value of the
> free space record for the log AG after the log is accounted for. If
> no space is left for the record, reset the record count to 0.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> v2:
> - Drop the byte swap.
> - Add a comment.
> - Fix up the commit log description.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
