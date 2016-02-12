Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F9CC7CBF
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 13:04:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 327088F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:04:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oAbUOMaOKfAEqu2q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 11:03:58 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id C2D43C0C2351
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 19:03:57 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-59-18.rdu2.redhat.com
	[10.10.59.18])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1CJ3vCV023782
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 14:03:57 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/2 v4] xfs_repair: improved secondary sb search
Date: Fri, 12 Feb 2016 13:03:29 -0600
Message-Id: <1455303811-9874-1-git-send-email-billodo@redhat.com>
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

New iteration (v4) of this series...

Current xfs_repair uses a brute force approach to find a valid
secondary sb. This series optimizes the secondary sb search, using
similar method to determine geometry as that of xfs_mkfs. If the
faster method fails in its search, fall back to original brute force
slower search.

version history
----
v1: http://oss.sgi.com/archives/xfs/2016-02/msg00304.html
v2: patch 2 whitespace fixups
v3: patch 2 correct functionality; style fixups
v4: patch 1,2 properly see to style and whitespace fixups
----

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
