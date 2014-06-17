Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2320729DF8
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 08:42:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 073B18F8040
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 06:41:59 -0700 (PDT)
Received: from g2t2352.austin.hp.com (g2t2352.austin.hp.com [15.217.128.51])
	by cuda.sgi.com with ESMTP id JYjr8NAAqSSmCcSP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 06:41:57 -0700 (PDT)
Received: from g2t2360.austin.hp.com (g2t2360.austin.hp.com [16.197.8.247])
	by g2t2352.austin.hp.com (Postfix) with ESMTP id 2F9B12DB
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 13:41:57 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g2t2360.austin.hp.com (Postfix) with ESMTP id 2255A4C
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 13:41:57 +0000 (UTC)
Date: Tue, 17 Jun 2014 08:41:05 -0500
From: scameron@beardog.cce.hp.com
Subject: Question about xfstests xfs/122 and xfs/253
Message-ID: <20140617134105.GF29459@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Disposition: inline
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
Cc: scameron@beardog.cce.hp.com


Hi,

I am running xfstests mostly just to exercise a low level driver, and I'm
seeing failures on tests xfs/122 and xfs/253.

I'm using xfstests, xfsprogs, xfsdump cloned fresh from the git repos listed
here: http://xfs.org/index.php/Getting_the_latest_source_code
git hashes:
xfstests: 45d1fac1303acfa102384f48111dc3a458b93493
xfsprogs: 03e956b25243bf4aac034275f89a0f3f2712b79a
xfsdump: b1d6979f1fae82acc79d27cf0add4d55da6d83cc

I'm using kernel 3.16-rc1 on RHEL 6.5 on x86_64.

I would expect that specific versions of xfstests, xfsprogs, xfsdump
are meant to go with specific kernel versions, though it is not clear
to me how to match these up in the general case.  I guessed that
"latest of everything" would have a reasonable chance of being a
matched set.

I'm running it by: "./check -g auto"

with configs/localhost.config:

[root@localhost xfstests]# cat configs/localhost.config
TEST_DEV=/dev/sdc
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sdb
SCRATCH_MNT=/mnt/scratch

I'm not very familiar with these tests, but it looks like xfs/122 is checking
that some structure sizes specific to xfs are correct, and I'm struggling to
see how a low level driver would break that test without breaking a lot of
other stuff, so I'm thinking I can ignore that one (maybe the test is broken?)
But I figured I should ask here in case I'm not correctly understanding what it's
trying to test.

xfs/253, seems to be testing some kind of filename hashing stuff.

Do these failures seem plausibly attributable to a flaw in a low level driver,
or are these failures known issues with xfs or with the tests, or is there
something else I might be doing wrong?

(It occurs to me now I should try the tests with a different driver and
hardware and see how it behaves.)


[root@localhost xfs]# diff -u ../../tests/xfs/122.out 122.out.bad | diffstat
 122.out.bad |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)
[root@localhost xfs]# diff -u ../../tests/xfs/253.out 253.out.bad | diffstat
 253.out.bad |    2 ++
 1 file changed, 2 insertions(+)
[root@localhost xfs]# diff -u ../../tests/xfs/253.out 253.out.bad 
--- ../../tests/xfs/253.out	2014-06-16 10:51:35.881521766 -0500
+++ 253.out.bad	2014-06-16 18:01:13.862884730 -0500
@@ -1,2 +1,4 @@
 QA output created by 253
 Disciplyne of silence is goed.
+mount: Structure needs cleaning
+umount: /dev/sdb: not mounted
[root@localhost xfs]#

Also, I noticed a few tests were not run, I presume that is not out of the ordinary.

xfs/189	 [not run] noattr2 mount option not supported on /dev/sdb
xfs/190 1s ... 1s
xfs/191	 [not run] no mkfs support for NFS v4 ACLs
xfs/194 1s ... 1s
xfs/195	 [not run] fsgqa user not defined.
xfs/196 5s ... 5s
xfs/197	 [not run] This test is only valid on 32 bit machines

And a few others skipped as well.

Thanks,

-- steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
