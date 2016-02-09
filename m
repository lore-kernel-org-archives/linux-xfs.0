Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C04B629DFD
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 11:13:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A084C8F804C
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 09:13:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qeDOpNDYTLugrgak (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 09:13:38 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 422528F296
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 17:13:38 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.50.117] (may be
	forged))
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u19HDbgp004812
	for <xfs@oss.sgi.com>; Tue, 9 Feb 2016 12:13:37 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/2] xfs_repair: improved secondary sb search
Date: Tue,  9 Feb 2016 11:13:06 -0600
Message-Id: <1455037988-7213-1-git-send-email-billodo@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


Hello -

Current xfs_repair uses a brute force approach to find a valid
secondary sb. This series optimizes the secondary sb search, using
similar method to determine geometry as that of xfs_mkfs. If the
faster method fails in its search, fall back to original brute force
slower search.

patch 1 has some general infrastructure adjustments, moving general
topology functions from mkfs to libxcmd.

patch 2 adds the new secondary superblock search method.

Questions, comments are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
