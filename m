Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U4Xcu3258408 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 22:33:39 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F831CD8CC
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 20:32:56 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id 3Rm0cFWmdCOSrguQ for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 20:32:56 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: [PATCH] enable possibility of ALL different atime mount options
Date: Fri, 30 Jan 2009 03:22:01 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901300322.02079.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

Utako Kusaka has provided this patch
http://oss.sgi.com/archives/xfs/2007-10/msg00168.html
It works for me GRACEFULLY with ALL different atime mount options: atime|noatime|relatime.
Note, the mount options are effective, not only accepted.
Prior to this patch, mount option atime has been ignored.

Please put the patch to mainline, it would save worries for users, who need the traditional atime
bahavior.  Think of some corner cases for desktop usage.

-- 
Roland Eggner

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
