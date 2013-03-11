Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 085917F3F
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 07:16:41 -0500 (CDT)
Message-ID: <513DCB25.6000701@sgi.com>
Date: Mon, 11 Mar 2013 07:16:37 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: skip freelist scans of corrupt agf
References: <513B5393.4000203@sandeen.net>
In-Reply-To: <513B5393.4000203@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

This has been commited.

Thanks
--Rich

commit a529cc7f0e5bd1632e5169d015c54e3a6122ee0f
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sat Mar 9 15:21:55 2013 +0000

     xfsprogs: skip freelist scans of corrupt agf

     If an agf has bad values in the freelist, this can wreak
     havoc if, for example, first > last and the loop
     never exits; we index agfl->agfl_bno[i] off into the weeds.

     If they're off, warn about it and skip the scan.

     This is done both in xfs_check and xfs_db's freespace cmd.

     Also fix uninit'd variable "i" from previous, similar fix
     for xfs_repair.

     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
     Reviewed-by: Dave Chinner <dchinner@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
