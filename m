Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74D267CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 02:31:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A93830406A
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:31:36 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id EpXC4KPyQbFrmH2Z for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 00:31:33 -0700 (PDT)
Message-ID: <5746A64D.6080309@cn.fujitsu.com>
Date: Thu, 26 May 2016 15:31:25 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: question about xfs/122
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Hi Darrick

When i run xfstests test case xfs/122 on RHEL7.2GA with xfsprog-dev(4.5.0),
I always get such error about xfs/122:
---------------------------------------------------------
  sizeof(struct xfs_extent_data_info) = 32
  sizeof(struct xfs_fs_eofblocks) = 128
  sizeof(struct xfs_icreate_log) = 28
-sizeof(struct xfs_refcount_key) = 4
-sizeof(struct xfs_refcount_rec) = 12
-sizeof(struct xfs_rmap_key) = 4
-sizeof(struct xfs_rmap_rec) = 24
-sizeof(struct xfs_rmapx_key) = 20
  sizeof(xfs_agf_t) = 224
  sizeof(xfs_agfl_t) = 36
  sizeof(xfs_agi_t) = 336
---------------------------------------------------------

This case can pass with modern xfsprogs(i.e. 4.3+ and all the new v5 stuff) as you said.
Could you tell me which specific version can support this case. In addition, what can be
done to work around this failure.

Please advise. Thanks very much.

Regards,
Xiao Yang





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
