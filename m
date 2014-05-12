Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF5097F3F
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 10:06:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEE318F804B
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:45 -0700 (PDT)
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id If5sAHWSk7qMAqAP
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:41 -0700 (PDT)
Received: by mail-qa0-f53.google.com with SMTP id ih12so7093479qab.40
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 08:06:41 -0700 (PDT)
Received: from tlielax.poochiereds.net ([2001:470:8:d63:3a60:77ff:fe93:a95d])
	by mx.google.com with ESMTPSA id
	r15sm10025356qgr.15.2014.05.12.08.06.39 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 12 May 2014 08:06:40 -0700 (PDT)
From: Jeff Layton <jlayton@poochiereds.net>
Subject: [xfstests PATCH 0/4] locktest: cleanup, bugfixes,
	and add new locking test
Date: Mon, 12 May 2014 11:06:29 -0400
Message-Id: <1399907193-23857-1-git-send-email-jlayton@poochiereds.net>
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

This patchset does some general cleanup of the locktest binary, adds
some infrastructure to allow testing F_GETLK requests, and adds a new
F_GETLK test to the pile.

The main impetus here is a regression that I caused in F_GETLK handling
for v3.15. The patch is making its way to Linus now, but I want to be
sure that it doesn't regress in the future.

Jeff Layton (4):
  locktest: don't assume that F_OPEN should use O_RDWR
  locktest: set f_fd to INVALID_HANDLE on close
  locktest: consolidate do_lock and do_unlock, and add ability to
    F_GETLK
  locktest: add a F_GETLK vs. openmode test

 src/locktest.c | 125 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 56 insertions(+), 69 deletions(-)

-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
