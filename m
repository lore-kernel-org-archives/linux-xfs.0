Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AF217F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 11:41:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 659FB8F8039
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 09:41:08 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YXKVqTLhRtBD6TFy for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 09:41:06 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 0/5] xfs_repair fixes, part 1
Date: Sun,  7 Sep 2014 11:41:00 -0500
Message-Id: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
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

I've been running a modified fsfuzzer and looking at the results
of xfs_repair of the corrupt images; plenty of things pop out.

I'm calling this "part one" because I expect that I'll find
more, but will send things out in digestable chunks as I
accumulate them...

Most of these are obviously correct and trivial; a coupl
require more thought & review.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
