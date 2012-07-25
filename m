Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6PMV7Vx179588 for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 17:31:07 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	a8FuUFDN8VYrtd6e for <xfs@oss.sgi.com>;
	Wed, 25 Jul 2012 15:31:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuA6X-0006Zr-Sj
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuA6X-0007Ra-L9
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs_io: new functions
Date: Thu, 26 Jul 2012 08:30:47 +1000
Message-Id: <1343255450-28559-1-git-send-email-david@fromorbit.com>
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

This is just a couple of additional functions for xfs_io I have had
sitting around for a while. The first is an interface to
sync_file_range() for better control of file writeback.  The second
and third introduce vectored pread/pwrite so that I could simulate
the same style of vectored IO that KVM does via direct IO (hint -
tracing indicated that the generic direct IO code doesn't handle
this particularly efficiently).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
