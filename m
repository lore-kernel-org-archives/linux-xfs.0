Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C33727F58
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:08:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93A118F804B
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:08:18 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nu6luGKYDWcLYTJE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:08:17 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t0DK8FH1030241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 15:08:15 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t0DK8EgL004301
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 15:08:14 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfsprogs/repair: secondary sb scan cleanups
Date: Tue, 13 Jan 2015 15:08:11 -0500
Message-Id: <1421179693-17227-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here are a couple patches to clean up the secondary sb scanning in phase
1 of xfs_repair. Patch 1 is a fix for a bug encountered by a user with a
corrupted fs/array that lead to scattered sb corruption:

http://oss.sgi.com/archives/xfs/2015-01/msg00113.html

Patch 2 is a larger cleanup of the affected sb scan function after
reading through the code and not being able to grok the need for some of
the extra complexity therein. I don't think it should affect behavior
much, but thoughts appreciated.

Brian

Brian Foster (2):
  repair: fix unnecessary secondary scan if only last sb is corrupt
  repair: remove unused strided secondary sb scan logic

 repair/globals.h |  2 --
 repair/sb.c      | 67 +++++++++++++++++++-------------------------------------
 2 files changed, 22 insertions(+), 47 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
