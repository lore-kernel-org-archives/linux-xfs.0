Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 776577CA0
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 08:50:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4C64E304039
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 06:50:38 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id HdVfD9M93KUxdIIH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 26 Mar 2016 06:50:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with SMTP id D980B2CE4D
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:50:34 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 8160A2CE3D
	for <xfs@oss.sgi.com>; Sat, 26 Mar 2016 09:50:34 -0400 (EDT)
Date: Sat, 26 Mar 2016 14:50:37 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Weird behaviour of mkfs.xfs
Message-ID: <20160326145037.3b5c6302@harpe.intellique.com>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Hi all,
I'm testing NVMe storage, and it works fine so far. However here's
something bizarre: I've made a RAID-0 array of 2 NVMe drives with
mdadm, and mkfs.xfs /dev/md0 starts an endless, full speed write of the
array:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0,21    0,00    0,17   12,39    0,00   87,24

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
nvme0n1           0,00     0,00    0,00 5152,33     0,00  1288,03   511,98  1019,53  197,87    0,00  197,87   0,19 100,00
nvme1n1           0,00     0,00    0,00 5154,67     0,00  1288,67   512,00    50,62    9,82    0,00    9,82   0,19 100,00
dm-0              0,00     0,00    0,00    0,00     0,00     0,00     0,00     0,00    0,00    0,00    0,00   0,00   0,00
md0               0,00     0,00    0,00 5152,00     0,00  2576,00  1024,00     0,00    0,00    0,00    0,00   0,00   0,00


I'm running a plain vanilla 4.4.6 kernel; the xfs_progs are only
slightly older, being version 4.2.

Nothing will stop the crazy mkfs.xfs, but  a hard reboot. Any idea?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
