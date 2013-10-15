Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E59797F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 03:50:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D25F98F804B
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 01:50:11 -0700 (PDT)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id Jl1udgDJ0MLDxGK0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Oct 2013 01:50:10 -0700 (PDT)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <katmai@keptprivate.com>) id 1VW0CJ-0007OW-Cf
	for xfs@oss.sgi.com; Tue, 15 Oct 2013 01:41:47 -0700
Date: Tue, 15 Oct 2013 01:41:47 -0700 (PDT)
From: katmai <katmai@keptprivate.com>
Message-ID: <1381826507281-35009.post@n7.nabble.com>
Subject: xfs corrupted
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

i guys,

i have a problem. yesterday there was a power outage at one of my
datacenters, where i have a relatively large fileserver. 2 arrays, 1 x 14 tb
and 1 x 18 tb both in raid6, with an adaptec card.

after the outage, the server came back online, the xfs partitions were
mounted, and everything looked okay. i could access the data and everything
seemed just fine.

today i woke up to lots of i/o errors, and when i rebooted the server, the
partitions would not mount:

Oct 14 04:09:17 kp4 kernel:
Oct 14 04:09:17 kp4 kernel: XFS internal error XFS_WANT_CORRUPTED_RETURN
a<ffffffff80056933>] pdflush+0x0/0x1fb
Oct 14 04:09:17 kp4 kernel: [<ffffffff80056a84>] pdflush+0x151/0x1fb
Oct 14 04:09:17 kp4 kernel: [<ffffffff800cd931>] wb_kupdate+0x0/0x16a
Oct 14 04:09:17 kp4 kernel: [<ffffffff80032c2b>] kthread+0xfe/0x132
Oct 14 04:09:17 kp4 kernel: [<ffffffff8005dfc1>] child_rip+0xa/0x11
Oct 14 04:09:17 kp4 kernel: [<ffffffff800a3ab7>]
keventd_create_kthread+0x0/0xc4
Oct 14 04:09:17 kp4 kernel: [<ffffffff80032b2d>] kthread+0x0/0x132
Oct 14 04:09:17 kp4 kernel: [<ffffffff8005dfb7>] child_rip+0x0/0x11
Oct 14 04:09:17 kp4 kernel:
Oct 14 04:09:17 kp4 kernel: XFS internal error XFS_WANT_CORRUPTED_RETURN at
line 279 of file fs/xfs/xfs_alloc.c. Caller 0xffffffff88342331
Oct 14 04:09:17 kp4 kernel:

got a bunch of these in dmesg.

i googled for solutions and i think i jumped the horse by doing xfs_repair
-L /dev/sdc. it would not clean it with xfs_repair /dev/sdc, and everybody
pretty much says the same thing.

this is what i was getting when trying to mount the array.

Filesystem Corruption of in-memory data detected. Shutting down filesystem
xfs_check

Did i jump the gun by using the -L switch :/ ?



--
View this message in context: http://xfs.9218.n7.nabble.com/xfs-corrupted-tp35009.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
