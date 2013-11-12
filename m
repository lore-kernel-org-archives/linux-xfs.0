Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92BB27F59
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 03:28:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 09988AC008
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 01:28:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id huxSkT02xy96uLIu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 01:28:03 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rAC9S1K0031093
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:02 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9S1x0019830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:01 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rAC9S1TK019816 for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 09:28:01 GMT
Message-ID: <5281F4EB.9060108@oracle.com>
Date: Tue, 12 Nov 2013 17:29:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [RFC PATCH 0/4] xfs: parallel quota check
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Folks,

We have a user report about skip quota check on first mount/boot several
monthes ago, the original discussion thread can be found at:
http://oss.sgi.com/archives/xfs/2013-06/msg00170.html.

As per Dave's suggestion, it would be possible to perform quota check
in parallel, this patch series is just trying to follow up that idea.

Sorry for the too long day as I have to spent most of time dealing with
personl things in the last few monthes, I was afraid I can not quickly
follow up the review procedure.  Now the nightmare is over, it's time to
revive this task.

Also, my previous test results on my laptop and a poor desktop can not
convience me that performs parallism quota check can really get benefits
compare to the current single thread as both machines are shipped with
slow disks, I even observed a little performance regression with millions
of small files(e.g, 100 bytes) as quota check is IO bound, additionaly,
it could affected by the seek time differences.  Now with a Mackbook Air
I bought recently, it can show significant difference.

tests:
- create files via fs_mark (empty file/100 byte small file)
fs_mark -k -S 0 -n 100000 -D 100 -N 1000 -d /xfs -t [10|20|30|50] -s [0|100]
- mount -ouquota,pquota /dev/sdaX /storage
- run each test for 5 times and figure out the average value

test environment:
- laptop: i5-3320M CPU 4 cores, 8G ram, normal SATA disk

results of empty files via time:
- # of file(million)	default			patched
	1		real 1m12.0661s		real 1m8.328s
     			user 0m0.000s		user 0m0.000s
			sys  0m43.692s		sys  0m0.048s

	2		real 1m43.907s		real 1m16.221s
			user 0m0.004s		user 0m0.000s
			sys  1m32.968s		sys  0m0.065s

	3		real 2m36.632s		real 1m48.011s
			user 0m0.000s		user 0m0.002s
			sys  2m23.501s		sys  0m0.094s

	5		real 4m20.266s		real 3m0.145s
			user 0m0.000s		user 0m0.002s
			sys  3m56.264s		sys  0m0.092s

results of 100 bytes files via time:
- # of file(million)	default			patched
	1		real 1m34.492		real 1m51.268s
			user 0m0.008s		user 0m0.008.s
			sys  0m54.432s		sys  0m0.236s

	3		real 3m26.687s		real 3m16.152s
			user 0m0.000s		user 0m0.000s
			sys  2m23.144s		sys  0m0.088s

So with emtpy files, the performance still looks good but with small files,
this change introduced a little regression on very slow storage.  I guess
this is caused by disk seek as data blocks allocated and spreads over the
disk.

In order to get some more reasonable results, I ask a friend helping
run this test on a server which were shown as following.

test environment
- 16core, 25G ram, normal SATA disk, but the XFS is resides on a loop dev. 

result of 100 bytes files via time:
- # of file(million)	default			patched
	1		real 0m19.015s		real 0m16.238s
			user 0m0.004s		user 0m0.002s
			sys  0m4.358s		sys  0m0.030s

	2		real 0m34.106s		real 0m28.300s
			user 0m0.012s		user 0m0.002s
			sys  0m8.820s		sys  0m0.035s

	3		real 0m53.716s		real 46.390s
			user 0m0.002s		user 0m0.005s
			sys  0m13.396s		sys  0m0.023s

	5		real 2m26.361s		real 2m17.415s
			user 0m0.004s		user 0m0.004s
			sys  0m22.188s		sys  0m0.023s

In this case, there is no regression although there is no noticeable
improvements. :(

test environment
- Macbook Air i7-4650U with SSD, 8G ram

- # of file(million)	default			patched
	1		real 0m6.367s		real 0m1.972s
			user 0m0.008s		user 0m0.000s
			sys  0m2.614s		sys  0m0.008s

	2		real 0m3.772s		real 0m15.221s
			user 0m0.000s		user 0m0.000s
			sys  0m0.007s		sys  0m6.269s

	5		real 0m36.036s		real 0m8.902s
			user 0m0.000s		user 0m0.002s
			sys  0m14.025s		sys  0m0.006s


Btw, The current implementation has a defeat considering the duplicated
code at [patch 0/4] xfs: implement parallism quota check at mount time.
Maybe it's better to introduce a new function xfs_bulkstat_ag() which can
be used to bulkstat inodes per ag, hence it could shared at above patch while
adjusting dquota usage per ag, i.e, xfs_qm_dqusage_adjust_perag().

As usual, critism and comments are both welcome!

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
