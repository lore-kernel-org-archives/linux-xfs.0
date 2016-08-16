Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14B207CA1
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 09:16:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA10F304101
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 07:16:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iEWeye21rBFDPG2R (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2016 07:16:52 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 4431A4E32F
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 14:16:52 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-57-220.rdu2.redhat.com
	[10.10.57.220])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7GEGp7f012243
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 10:16:51 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v2 0/3] xfs_quota: allow operation on ext4 for project quotas
Date: Tue, 16 Aug 2016 09:16:35 -0500
Message-Id: <1471356998-2876-1-git-send-email-billodo@redhat.com>
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

I'm submitting a version 2 to clarify patch 1 loop logic correction.

This is a resubmission of Dave Chinner's original 2-patch series
to enable using xfs_quota for project quotas on foreign filesystems
(e.g. ext4).

Original series: http://oss.sgi.com/archives/xfs/2016-02/msg00107.html

Updated series:
Patch 1: initial capabilities to enable xfs_quota use on foreign filesystems.
Patch 2: userspace changes to accomodate hoisted ioctl defs in kernel
Patch 3: additional changes to accomodate xfs_quota use on foreign filesystems.

History:
-----
v1: http://oss.sgi.com/archives/xfs/2016-08/msg00435.html
v2: patch 1: slight logic modification to clarify loop in init_args_command
             (functional equivalent)

-----

Again, questions and comments are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
