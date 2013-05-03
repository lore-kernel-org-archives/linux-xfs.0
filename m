Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 133477F4C
	for <xfs@oss.sgi.com>; Fri,  3 May 2013 07:28:51 -0500 (CDT)
Message-ID: <5183AD53.7030403@sgi.com>
Date: Fri, 3 May 2013 07:28:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Josef,

The patch does not compile on older kernels (i.e. SLES11 SP2).

fsync-tester.c: In function 'test_three':
fsync-tester.c:133: warning: implicit declaration of function 'syncfs'
/tmp/cciHR6Gb.o: In function `test_three':
/data/lwork/gulag1c/rjohnston/xfstests/src/fsync-tester.c:133: undefined 
reference to `syncfs'
collect2: ld returned 1 exit status
gmake[3]: *** [fsync-tester] Error 1
gmake[2]: *** [src] Error 2
make[1]: *** [default] Error 2
make: *** [default] Error 2


src/fsync-tester.c
133                                 syncfs(test_fd);
Typo ?????                          ^^^^^^
Did you mean fsync?

Regards,
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
