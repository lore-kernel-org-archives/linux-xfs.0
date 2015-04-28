Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8DBA7F37
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 11:56:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44B3DAC001
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 09:56:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aPIU1c200OBIQZ9s (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 09:56:37 -0700 (PDT)
Date: Wed, 29 Apr 2015 00:56:34 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: generic/204 failure due to e88b64e xfs: use generic percpu counters
	for free inode counter
Message-ID: <20150428165633.GI17534@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
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
Cc: xuw2015@gmail.com

Hi,

I was testing v4.1-rc1 kernel and hit generic/204 failure on 512b block
size v4 xfs and 1k block size v5 xfs. And this seems to be a regression
since v4.0

[root@dhcp-66-86-11 xfstests]# MKFS_OPTIONS="-b size=512" ./check generic/204
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.0.0-rc1+
MKFS_OPTIONS  -- -f -b size=512 /dev/sda6
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sda6 /mnt/testarea/scratch

generic/204 8s ... - output mismatch (see /root/xfstests/results//generic/204.out.bad)
    --- tests/generic/204.out   2014-12-11 00:28:13.409000000 +0800
    +++ /root/xfstests/results//generic/204.out.bad     2015-04-29 00:36:43.232000000 +0800
    @@ -1,2 +1,37664 @@
     QA output created by 204
    +./tests/generic/204: line 83: /mnt/testarea/scratch/108670: No space left on device
    +./tests/generic/204: line 84: /mnt/testarea/scratch/108670: No space left on device
    ...

I bisected to this commit

e88b64e xfs: use generic percpu counters for free inode counter

Seems like the same issue this patch tries to fix, but test still fails
after applying this patch.

[PATCH v2] xfs: use percpu_counter_read_positive for mp->m_icount
http://oss.sgi.com/archives/xfs/2015-04/msg00195.html

Not sure if it's the expected behavior/a known issue, report it to the
list anyway.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
