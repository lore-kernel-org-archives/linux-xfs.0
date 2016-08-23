Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 09C9B7CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 17:12:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D06C28F8039
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 15:12:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fsXz4HkAD7WsMjrt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 15:12:46 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 38B7FC057FA6
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 22:12:45 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-62-210.rdu2.redhat.com
	[10.10.62.210])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u7NMCipc003014
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 18:12:44 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH v4 0/2] xfs_quota: allow operation on ext4 for project quotas
Date: Tue, 23 Aug 2016 17:12:30 -0500
Message-Id: <1471990352-31852-1-git-send-email-billodo@redhat.com>
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

submitting v4...

Version 4 of this series modifies patch 2, removing the unnecessary
application of flags for the help and quit commands, and corrects
some output message verbiage and comments.

Version 3 better documented the introduction of the "-f" (foreign
filesystem) flag, along with some minor refactoring of the
init_args_command and init_check_command in quota/init.c, to proper
functionality and better readability. Patch 2 was superfluous as
it was already committed (commit 83f4b5a), so it was removed in v3.

This series is a resubmission of Dave Chinner's original 2-patch series
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
