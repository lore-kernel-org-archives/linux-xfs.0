Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5437029DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 21:19:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3EF1B304051
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 19:19:16 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ARHSCLKUiQQ1OexT for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 19:19:14 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: fixes for 3.10-rc6
Date: Wed, 12 Jun 2013 12:19:05 +1000
Message-Id: <1371003548-4026-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

Hi Ben,

Here are the fixes I have for 3.10-rc6. The first fixes the log
recovery regression that Dave jones reported, the second fixes a bug
in the CRC on-disk format on 32 bit systems, and the third fixes a
BMBT block corruption when CRCs are enabled. All are simple, short
fixes, so please consider them for 3.10-rc6.

Thanks,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
