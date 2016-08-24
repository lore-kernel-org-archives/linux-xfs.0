Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F5617CA1
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 21:24:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 01AD1AC002
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id wi5aFJ60N25zWZLf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 19:24:29 -0700 (PDT)
Subject: [PATCH 0/7] xfsprogs: reverse mapping fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Aug 2016 19:24:24 -0700
Message-ID: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is a roll-up of a few fixes[1] for reverse-mapping in xfsprogs 4.8.

The patches have been xfstested with the 'auto' group on x64
and (afaict) don't cause any regressions.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/xfsprogs/tree/for-dave-for-4.8-6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
