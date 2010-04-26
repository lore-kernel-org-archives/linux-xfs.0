Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3QMsW0p112101 for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 17:54:33 -0500
Received: from esri3.esri.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1DC988D79F
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 15:56:31 -0700 (PDT)
Received: from esri3.esri.com (esrismtp2.esri.com [198.102.62.103]) by
	cuda.sgi.com with ESMTP id 4hlYQhyKHl6gcBUk for
	<xfs@oss.sgi.com>; Mon, 26 Apr 2010 15:56:31 -0700 (PDT)
Received: from leoray.esri.com (leoray.esri.com [10.27.102.12])
	by esri3.esri.com (8.11.7p3+Sun/8.11.7) with ESMTP id o3QMuSC11237
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 15:56:28 -0700 (PDT)
Received: from leoray.esri.com (leoray.esri.com [127.0.0.1])
	by leoray.esri.com (8.14.3/8.14.3) with ESMTP id o3QMuSJq007148
	for <xfs@oss.sgi.com>; Mon, 26 Apr 2010 15:56:28 -0700
Received: (from ray5147@localhost)
	by leoray.esri.com (8.14.3/8.14.3/Submit) id o3QMuSOr007147
	for xfs@oss.sgi.com; Mon, 26 Apr 2010 15:56:28 -0700
Date: Mon, 26 Apr 2010 15:56:28 -0700
From: Ray Van Dolson <rvandolson@esri.com>
Subject: O_SYNC behavior?
Message-ID: <20100426225627.GA7106@esri.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

End-user question:

NFS client accessing an NFS export on an XFS based filesystem via
"sync" (O_SYNC) mode.

Will write confirmation be sent back from the NFS server when the data
is written to the xfs journal, or not until it is actually written to
disk (assuming in this case the journal is on a separate SSD device or
something similar)?

Thanks,
Ray

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
