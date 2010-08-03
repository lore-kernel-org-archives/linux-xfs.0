Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o737NM7D230244 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 02:23:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4D721681BBB
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 00:23:40 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	tLDl2NTUHUNZ5Aua for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 00:23:40 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] dio: serialise unaligned direct IO V3
Date: Tue,  3 Aug 2010 17:23:21 +1000
Message-Id: <1280820204-1418-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: xfs@oss.sgi.com

Updated version of the unaligned direct IO tracking bug fixes.

Version 3:
- address Christoph's review comments
- add a mempool to avoid memory allocation failures to address Jan's comment.

Version 2:
- address scalability concerns

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
