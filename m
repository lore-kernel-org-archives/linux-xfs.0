Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1B7697F3F
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 15:12:03 -0500 (CDT)
Received: from eagdhcp-232-205.americas.sgi.com
	(eagdhcp-232-205.americas.sgi.com [128.162.232.205])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB131AC002
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 13:12:02 -0700 (PDT)
Received: from eagdhcp-232-205.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-205.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s2PKC3Lq003843
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 15:12:03 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-205.americas.sgi.com)
Message-Id: <20140325195733.510384972@sgi.com>
Date: Tue, 25 Mar 2014 15:06:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 0/2] xfs: Clean the EFI on errors series
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

Here is a broken up version of the clean the EFI from the AIL
on error.
 
Patch 1 is for log recovery and patch 2 is for log aborts, forced
shutdowns in xfs_bmap_finish() or another thread while the EFI is
in the CIL or AIL and the EFD is in the CIL.
 
If xfs_free_extent() fails while processing the extent free list,
one has to manually remove the EFI because the EFD is not complete
and is not in the transaction.
 
--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
