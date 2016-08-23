Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 335F07CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 11:40:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B94F8AC002
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 09:40:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PgxI1rhMpgIwGCuF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 09:40:39 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 82B8C4DAF8
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 16:40:38 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-62-210.rdu2.redhat.com
	[10.10.62.210])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7NGeb4X007416
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 12:40:38 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v3 0/3] xfs_quota: allow operation on ext4 for project quotas 
Date: Tue, 23 Aug 2016 11:40:24 -0500
Message-Id: <1471970426-5509-1-git-send-email-billodo@redhat.com>
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

I'm submitting a version 3 to better document the introduction of
the "-f" (foreign filesystem) flag, along with some minor refactoring
of the init_args_command and init_check_command in quota/init.c, to
proper functionality and better readability.

Also, for this series, patch 2 was superfluous as it was already
committed (commit 83f4b5a), so remove it from the series.

This is a resubmission of Dave Chinner's original 2-patch series
to enable using xfs_quota for project quotas on foreign filesystems
(e.g. ext4).

Original series: http://oss.sgi.com/archives/xfs/2016-02/msg00107.html

Updated series:
Patch 1: initial capabilities to enable xfs_quota use on foreign filesystems.
Patch 2: REMOVED (superfluous)
Patch 3: additional changes to accomodate xfs_quota use on foreign filesystems.

Questions and comments are welcome.

Thanks-
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
