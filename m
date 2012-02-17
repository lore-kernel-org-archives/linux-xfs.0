Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HMkbkb114890 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:46:37 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id iervOcHU8llSgASg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 14:46:36 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1RyWZX-0001Cq-LA
	for xfs@oss.sgi.com; Fri, 17 Feb 2012 14:46:35 -0800
Message-ID: <33345988.post@talk.nabble.com>
Date: Fri, 17 Feb 2012 14:46:35 -0800 (PST)
From: kdasu <kdasu.kdev@gmail.com>
Subject: [PATCH 0/4] xfs: resurrect realtime subvolume support on kernel 2.6.37
MIME-Version: 1.0
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


Fixed bimap inode deadlock  existing on 2.6.37.

[PATCH 4/4]   xfs: fix deadlock in xfs_rtfree_extent with kernel v2.6.37

Also added the realtime subvolume patches from the 2.6.39 release.

[PATCH 1/4] xfs: only lock the rt bitmap inode once per allocation
[PATCH 2/4] xfs: fix xfs_get_extsz_hint for a zero extent size hint
[PATCH 3/4] xfs: add lockdep annotations for the rt inodes

These fixes were needed to resurrect realtime subvolume support on 
2.6.37 kernel.

I suspect the deadlock problem while freeing multiple extents 
exits  on 2.6.39  in the xfs_rtfree_entent() call.

Kamal
-- 
View this message in context: http://old.nabble.com/-PATCH-0-4--xfs%3A-resurrect-realtime-subvolume-support-on-kernel-2.6.37-tp33345988p33345988.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
