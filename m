Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CB76B7F50
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0EB4304048
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BCFi5g5R64QDD7vc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:20 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5F66D3B759
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:19 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2H030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:18 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/6] fsx
Date: Tue, 22 Dec 2015 14:51:06 +0100
Message-Id: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
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

Here is a bunch of fixes / improvements to fsx.  The first patch was already
posted two weeks ago with no reaction yet; the rest is new.

Thanks,
Andreas

Andreas Gruenbacher (6):
  fsx: Small improvements and fixes
  fsx: Fix hex numbers in operation dump
  fsx: Report number of successful operations
  fsx: Generate test parameters in test()
  fsx: Improve operation logging
  fsx: Add mechanism to replay failed operations

 common/rc             |  14 ++
 ltp/fsx.c             | 415 +++++++++++++++++++++++++++++++++++++-------------
 tests/generic/091     |  12 --
 tests/generic/127.out |  12 +-
 tests/generic/231.out |  12 +-
 tests/generic/263     |  12 --
 6 files changed, 332 insertions(+), 145 deletions(-)

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
