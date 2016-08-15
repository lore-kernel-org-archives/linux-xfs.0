Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FEAE7CA3
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 13:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47D598F8138
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 11:38:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nMkt8cf4wNF21tfj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 15 Aug 2016 11:38:46 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id D98AF81110
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 18:38:45 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-56-109.rdu2.redhat.com
	[10.10.56.109])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7FIcjrl018199
	for <xfs@oss.sgi.com>; Mon, 15 Aug 2016 14:38:45 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 0/3] xfs_quota: allow operation on ext4 for project quotas
Date: Mon, 15 Aug 2016 13:38:28 -0500
Message-Id: <1471286311-2730-1-git-send-email-billodo@redhat.com>
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

This is a resubmission of Dave Chinner's original 2-patch series
to enable using xfs_quota for project quotas on foreign filesystems
(e.g. ext4).

Original series: http://oss.sgi.com/archives/xfs/2016-02/msg00107.html

Updated series:
Patch 1: initial capabilities to enable xfs_quota use on foreign filesystems.
Patch 2: userspace changes to accomodate hoisted ioctl defs in kernel
Patch 3: additional changes to accomodate xfs_quota use on foreign filesystems.

Questions and comments are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
