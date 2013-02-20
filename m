Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E99F7F4E
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 04:42:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 06F338F8035
	for <xfs@oss.sgi.com>; Wed, 20 Feb 2013 02:42:27 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id 282uAdCQ5TbjNVL9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Feb 2013 02:42:25 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 00/10] xfstests: Stress tests improments v5
Date: Wed, 20 Feb 2013 14:42:05 +0400
Message-Id: <1361356935-29153-1-git-send-email-dmonakhov@openvz.org>
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

1   add fio requirement V2
2   add configurable load factors
3   hardcode fops for determinable fsstests runs
4   fsstress add replace file operation
5   allow fsstress to use load factor where appropriate
6   move run_check to common.rc
7   add  fallocate/truncate vs AIO/DIO stress test
8   add  fallocate/punch_hole vs AIO/DIO stress test
9   add defragmentation stress tests for ext4
10  add disk failure simulation test

Known issues which can be triggered this test case:
287'th over EXT4 result in https://gist.github.com/dmonakhov/4994589
298'th (8'th patch) over XFS result in https://gist.github.com/dmonakhov/4994465
300'th and 301'th over EXT4 result in https://gist.github.com/dmonakhov/4770294
303'th over XFS result in https://gist.github.com/dmonakhov/4951456

Changes since V4
Rebase on top of current dev tree.


Changes since V2
Mostly code style cleanups accodring to Dave's comments
- add _scale_fsstress_args function
- move run_check function to common.rc
- Add more comments
- split combined e4defrag testcase in to disicated tescases

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
