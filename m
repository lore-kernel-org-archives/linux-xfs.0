Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6IDkk0w194528 for <xfs@oss.sgi.com>; Wed, 18 Jul 2012 08:46:46 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id DyfhFdD4YlqU4vHA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2012 06:46:45 -0700 (PDT)
Date: Wed, 18 Jul 2012 16:46:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: xfs: use discontiguous xfs_buf support in dabuf wrappers
Message-ID: <20120718134636.GA17265@elgon.mountain>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: dchinner@redhat.com
Cc: xfs@oss.sgi.com

Hello Dave Chinner,

This is a semi-automatic email about new static checker warnings.

The patch 3605431fb973: "xfs: use discontiguous xfs_buf support in
dabuf wrappers" from Jun 22, 2012, leads to the following Smatch
complaint:

fs/xfs/xfs_da_btree.c:2113 xfs_da_get_buf()
	 error: we previously assumed 'bp' could be null (see line 2111)

fs/xfs/xfs_da_btree.c
  2110					    mapp, nmap, 0);
  2111		error = bp ? bp->b_error : XFS_ERROR(EIO);
  2112		if (error) {
  2113			xfs_trans_brelse(trans, bp);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^
If bp is NULL here then it causes an Oops.

  2114			goto out_free;
  2115		}

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
