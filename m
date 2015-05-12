Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FA447F50
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 14:24:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0899F8F808F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 12:24:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Z3zGMv5wrPYOkvW8 for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 12:24:07 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id ABD7763CBFD7
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 14:24:06 -0500 (CDT)
Message-ID: <55525356.1020807@sandeen.net>
Date: Tue, 12 May 2015 14:24:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 0/2 V3] allow UUID changes on V5/CRC filesystems
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
To: xfs-oss <xfs@oss.sgi.com>

Final version?  This has been through some degree of testing, by changing
the UUID after a CRC mkfs, and re-setting it in between two xfs_repair runs
before and after each test in the testsuite.

I still probably owe some xfstests testcases.

This is rebased onto the new xfsprogs libxfs rebase, and I removed the noise
if a user asks to "restore" the UUID on a filesystem which doesn't need it -
it just does nothing, and succeeds silently.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
