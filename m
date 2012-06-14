Return-Path: <xfs-bounces@oss.sgi.com>
Received: from tinguely (eagdhcp-232-130.americas.sgi.com [128.162.232.130])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5EGc4Sx002790 for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:38:04 -0500
Received: from tinguely (localhost [127.0.0.1])
	by tinguely (8.14.5/8.14.5) with ESMTP id q5EGc4co002853
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2012 11:38:04 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Received: (from tinguely@localhost)
	by tinguely (8.14.5/8.14.5/Submit) id q5EGc4AE002852
	for xfs@oss.sgi.com; Thu, 14 Jun 2012 11:38:04 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20120614142214.445982138@sgi.com>
Date: Thu, 14 Jun 2012 09:22:14 -0500
From: tinguely@sgi.com
Subject: [PATCH 0/2 v2] Subject xfs: rename log structure and remove xlog_t
	typedef.
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

1/2 Renames the XFS struct log to xlog. This helps crash debugger find the XFS
    log structure.

2/2 Clean up patch that removes the xlog_t typedef. It is a bit more than was
    suggested.

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
