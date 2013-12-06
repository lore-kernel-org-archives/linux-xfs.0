Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C82C29E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 15:23:36 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3239AC00D
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 13:23:32 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	rB6LNUHW006853
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 15:23:30 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20131206212027.846346746@sgi.com>
Date: Fri, 06 Dec 2013 15:20:27 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] misc log recovery patches
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

A couple log recovery patches.

patch 1 is a correction to commit:
	commit 2a84108fe275f95fbe838b1c92b7c45258dcae5c
	Author: Mark Tinguely <tinguely@sgi.com>
	Date:   Wed Oct 2 07:51:12 2013 -0500
	xfs: free the list of recovery items on error

Errors in phase 1/2 of xlog_recover_commit_trans will free the
transaction pointer and the new call to xlog_recover_process_data
will reuse and refree the pointer. I missed it in testing of the
2a84108 patch. Found by Dan Carpenter and verified by forcing an
error in xlog_recover_process_data.

	---

patch 2 is the second version of the patch to remove the EFI from
the AIL when log recovery of the EFI item fails. If the EFI entry is
not removed from the AIL, then xfs_ail_push_all_sync will hang while
doing the forced shutdown. I moved the removal of all EFIs from the
AIL to the caller, xlog_recover_process_efis to catch all the errors
coming from xlog_recover_process_efi. This bug was found and verified
using a metadata dump of a filesystem that has an error freeing an
extent.

Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
