Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p655300h223991 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 00:03:01 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B534E1794732
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 22:02:59 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id F2CaqWPxdVL31OA1
	for <xfs@oss.sgi.com>; Mon, 04 Jul 2011 22:02:59 -0700 (PDT)
Received: from speechless.lan.dermichi.com
	([2001:470:26:2a9:4a5b:39ff:fe18:7163])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1Qdxmj-0002KV-6R
	for xfs@oss.sgi.com; Tue, 05 Jul 2011 07:02:57 +0200
Message-ID: <4E129B00.4020709@dermichi.com>
Date: Tue, 05 Jul 2011 07:02:56 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: xfs_bmap Cannot allocate memory
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi List!
I've got a file here on which i cannot use xfs_bmap to determine it's
fragments. All that i know is that it must have a really great number of
them. It was the result of running a smbd without strict allocate. The
machine itself has 8GiB of RAM and 10GiB of swap available, so that
shouldn't be the problem. I guess this is some bug in xfs_bmap. Or is it
a known limitation?

# xfs_bmap /backup/tmp/cannot_allocate_memory.vhd
xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x0
["/backup/tmp/cannot_allocate_memory.vhd"]: Cannot allocate memory

Another thing i noticed is that when i use the filefrag utility it
reports a different fragment count when invoked with -v than without it,
which i found pretty strange too. From that output i judge that the real
count is 62715, which is also not in sync with 45487.
# filefrag /backup/tmp/cannot_allocate_memory.vhd
/backup/tmp/cannot_allocate_memory.vhd: 1364 extents found
# filefrag -v /backup/tmp/cannot_allocate_memory.vhd | tail -n5
62711 43265805  57280748  57265654     17
62712 43266061  57265655  57280764      1
62713 43266317  57396971  57265655     17
62714 43266573  57265656  57396987      1 eof
/backup/tmp/cannot_allocate_memory.vhd: 45487 extents found

Other than that everything works perfectly well and xfs_repair doesn't
report any problems with the filesystem. So it's only a "cosmetical" issue.

Thanks for any hints,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
