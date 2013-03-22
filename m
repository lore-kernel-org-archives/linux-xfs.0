Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C3F187F66
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 15:59:28 -0500 (CDT)
Message-ID: <514CC62C.7000006@sgi.com>
Date: Fri, 22 Mar 2013 15:59:24 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfsprogs: reduce bb_numrecs in bno/cnt btrees when
	log consumes all agf space
References: <1363699415-28022-1-git-send-email-bfoster@redhat.com>
In-Reply-To: <1363699415-28022-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

Thanks for submitting this patch Brian, it has been committed.

Thanks
--Rich


commit 64ae7fcf6d1284e6905879697b55c4146fa881cf
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Mar 19 13:23:35 2013 +0000

     xfsprogs: reduce bb_numrecs in bno/cnt btrees when log consumes all 
agf space

     The mkfs code currently creates a single free space extent record
     for each of the bno and cnt btrees in each AG. The start block of
     the record is pushed forward on the AG that hosts an internal log.
     If the log happens to consume all available space in the AG, the
     start block becomes equal to sb->sb_agblocks and thus invalid.
     This causes xfs_repair to complain.

     For example, the following sequence:

         mkfs.xfs -d file,name=./fs.img,size=50g,agsize=16m
         xfs_repair ./fs.img

     ... produces the following xfs_repair output:

         Phase 1 - find and verify superblock...
         Phase 2 - using internal log
                 - scan filesystem freespace and inode maps...
         invalid start block 4096 in record 0 of bno btree block 1600/1
         invalid start block 4096 in record 0 of cnt btree block 1600/2
                 - found root inode chunk
         ...

     xfs_repair appears to correct the numrecs value such that subsequent
     checks are successful. The sequence above is pulled from xfstests
     test #250, which fails due to this behavior.

     Modify mkfs.xfs such that we check the block count value of the
     free space record for the log AG after the log is accounted for. If
     no space is left for the record, reset the record count to 0.

     Signed-off-by: Brian Foster <bfoster@redhat.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
