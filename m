Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1JrMZ6129282 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 14:53:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B91D98F8049
	for <xfs@oss.sgi.com>; Tue,  1 Nov 2011 12:53:19 -0700 (PDT)
Received: from augusta (augusta.americas.sgi.com [128.162.233.117])
	by estes.americas.sgi.com (Postfix) with ESMTP id A081F700075D
	for <xfs@oss.sgi.com>; Tue,  1 Nov 2011 14:53:19 -0500 (CDT)
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 0/4] xfstests: refactor arg processing in common.dump
Date: Tue,  1 Nov 2011 14:53:03 -0500
Message-Id: <1320177187-18871-1-git-send-email-wkendall@sgi.com>
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

This patch series reworks the argument processing for the
dump and restore helper routines in common.dump.

Note this series depends on the following outstanding patches,
as there are overlapping changes in _parse_args():
    xfstests: add test 264 for testing xfsdump -D
    xfstests: add 265 and 266 for multiple media

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
