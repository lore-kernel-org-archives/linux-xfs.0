Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60D607CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 17:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A278304043
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ebX4AFgOzraAdvOR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 15:45:30 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 37CE063141
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 22:45:30 +0000 (UTC)
Received: from localhost.localdomain.com (unused [10.10.52.194] (may be
	forged))
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4BMjTWH031072
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 18:45:29 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v5 0/2] xfs_repair: improved secondary sb search
Date: Wed, 11 May 2016 17:45:15 -0500
Message-Id: <1463006717-6104-1-git-send-email-billodo@redhat.com>
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

New iteration (v5) of this series...

Current xfs_repair uses a brute force approach to find a valid
secondary sb. This series optimizes the secondary sb search, using
similar method to determine geometry as that of xfs_mkfs. If the
faster method fails in its search, fall back to original brute force
slower search.

version history:
----
v1: http://oss.sgi.com/archives/xfs/2016-02/msg00304.html
v2: patch 2 whitespace fixups
v3: patch 2 correct functionality; style fixups
v4: patch 1,2 properly see to style and whitespace fixups
v5: patch 1 rebase to latest
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
