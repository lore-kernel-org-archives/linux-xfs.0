Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n150LjGE180371 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 18:21:46 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4335AC002
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 16:21:06 -0800 (PST)
Received: from eagdhcp-232-197.americas.sgi.com
	(eagdhcp-232-197.americas.sgi.com [128.162.232.197])
	by estes.americas.sgi.com (Postfix) with ESMTP id F011B7000103
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 18:21:05 -0600 (CST)
Message-Id: <400220E1-CB3D-4CD3-B094-176629B246B5@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: xfsdump 3.0.0 source tarball released
Date: Wed, 4 Feb 2009 18:21:05 -0600
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsdump-3.0.0.tar.gz

This version contains important bug fixes to xfsdump 2.2.49:

xfsdump-3.0.0 (4 February 2009)
         - Bump major package version number to signify changed
           dependencies and moved binaries (xfs_fsr and estimate
           have moved into xfsprogs).
         - xfsdump should no longer make use of internal XFS
           headers and libraries, in particular no use of libxfs
           is permitted in this package anymore (such detailed
           on-disk format knowledge is the realm of xfsprogs).
         - Fix xfsdump/xfsrestore to work on systems with 64k
           page size.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
