Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 096DE7F4E
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 16:44:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5D0EAC005
	for <xfs@oss.sgi.com>; Fri,  4 Oct 2013 14:43:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RZ40pn4Z3AYCEiqA for <xfs@oss.sgi.com>;
	Fri, 04 Oct 2013 14:43:56 -0700 (PDT)
Date: Sat, 5 Oct 2013 07:43:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair segfault
Message-ID: <20131004214353.GK4446@dastard>
References: <CAGa4098ZKd2KQfWMgNXYgLr9LJF8r-MpFgQAn3G-W+ovDGHTAw@mail.gmail.com>
	<20131001201909.GR12541@dastard>
	<CAGa409_tDjbsdnf+wDiM7666FeQSjmMfOVdqG-SxOD_WUZMiZQ@mail.gmail.com>
	<20131002104253.GT12541@dastard>
	<CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGa409_wO74zGP1d85RGZ7WbfBPr7s_tKaW3u9k8=9Ps-D5FjQ@mail.gmail.com>
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
To: Viet Nguyen <vietnguyen@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 04, 2013 at 10:51:50AM -0700, Viet Nguyen wrote:
> Hi,
> 
> I was wondering if you got a chance to look at this and if one's available,
> where can I get a patch?

Can you try the patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

libxfs: validity check the directory block leaf entry count

From: Dave Chinner <dchinner@redhat.com>

The directory block format verifier fails to check that the leaf
entry count is in a valid range, and so if it is corrupted then it
can lead to derefencing a pointer outside the block buffer. While we
can't exactly validate the count without first walking the directory
block, we can ensure the count lands in the valid area within the
directory block and hence avoid out-of-block references.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_dir2_data.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index 189699f..1b5196b 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -59,6 +59,18 @@ __xfs_dir3_data_check(
 		btp = xfs_dir2_block_tail_p(mp, hdr);
 		lep = xfs_dir2_block_leaf_p(btp);
 		endp = (char *)lep;
+
+		/*
+		 * The number of leaf entries is limited by the size of the
+		 * block and the amount of space used by the data entries.
+		 * We don't know how much space is used by the data entries yet,
+		 * so just ensure that the count falls somewhere inside the
+		 * block right now.
+		 */
+		XFS_WANT_CORRUPTED_RETURN(be32_to_cpu(btp->count) >
+				((char *)btp - (char *)p) /
+					sizeof(struct xfs_dir2_leaf_entry));
+
 		break;
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
