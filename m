Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A239B7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 04:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F6198F8037
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:47:40 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id 5iCLzG1MT3M1V7ko for
	<xfs@oss.sgi.com>; Wed, 29 Oct 2014 02:47:38 -0700 (PDT)
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain
	[127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9T9lTPW022284
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 17:47:29 +0800
Message-ID: <1414575977.17402.3.camel@G08JYZSD130126.localdomain>
Subject: [Question]: xfstests test generic/233 failure
From: Zeng Linggang <zenglg.jy@cn.fujitsu.com>
Date: Wed, 29 Oct 2014 17:46:17 +0800
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
To: xfs@oss.sgi.com

Hello,

When I take XFS filesystem as test target, the case generic/233 often
fails in my test machines (RHEL7.0GA: 3.10.0-123) with output like this:
generic/233  [failed, exit status 1] - output mismatch (see
/var/lib/xfstests/results//generic/233.out.bad)
--- tests/generic/233.out       2014-10-22 14:17:06.239461640 +0800
+++ results/generic/233.out.bad 2014-10-23 14:39:48.210480319 +0800
@@ -4,4 +4,7 @@
seed = S
Comparing user usage
-Comparing group usage
+4c4
+< #1001     --   31348   32000   32000            772  1000  1000
+---
+> #1001     --   31144   32000   32000            772  1000  1000
...
generic/231 and generic/270 also have the similar quota accounting mismatch.

Could anyone give me some hints about it?

Thanks,
Zeng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
