Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 41F627FB3
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 02:50:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FDB78F8050
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 00:50:25 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id BdaWrKu3hmeFBKmC (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Feb 2013 00:50:23 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/8] xfstests: Stress tests improments v3
Date: Wed, 13 Feb 2013 12:49:55 +0400
Message-Id: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

This is third version of the patch series, previous version
can be found here: http://oss.sgi.com/archives/xfs/2012-09/msg00328.html

xfstests-add-fio-requirement-V2
xfstests-get-rid-of-hardcoded-sbin-mkfs
xfstest-add-configurable-load-factors
xfstest-allow-fsstress-to-use-load-factor-where-appr
run-check-to-common_rc
add-fallocate-truncate-vs-AIO-DIO-stress-test
add-fallocate-punch_hole-vs-AIO-DIO-stress-test
add-defragmentation-stress-tests-for-ext4

Changes since V2

Mostly code style cleanups accodring to Dave's comments
- add _scale_fsstress_args function
- move run_check function to common.rc
- Add more comments
- split combined e4defrag testcase in to disicated tescases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
