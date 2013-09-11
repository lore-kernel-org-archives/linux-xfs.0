Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8AD957F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 16:18:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28212AC006
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 14:18:35 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id HkmITwC4cAC3PBfQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Sep 2013 14:18:28 -0700 (PDT)
Date: Thu, 12 Sep 2013 00:18:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: recovery of swap extents operations for CRC filesystems
Message-ID: <20130911211819.GB10527@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
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
To: dchinner@redhat.com
Cc: xfs@oss.sgi.com

Hello Dave Chinner,

The patch 638f44163d57: "xfs: recovery of swap extents operations for
CRC filesystems" from Aug 30, 2013, leads to the following
static checker warning: "fs/xfs/xfs_log_recover.c:2999
xlog_recover_inode_pass2()
	 info: ignoring unreachable code."

fs/xfs/xfs_log_recover.c
  2992  out_release:
  2993          xfs_buf_relse(bp);
  2994  error:
  2995          if (need_free)
  2996                  kmem_free(in_f);
  2997          return XFS_ERROR(error);
                ^^^^^^^^^^^^^^^^^^^^^^^
  2998  
  2999          xfs_buf_relse(bp);
  3000          goto error;

These two added lines are unreachable.  Sometimes people add dead code
for later, so this might be intentional.  It's not clear.

  3001  }

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
