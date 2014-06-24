Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E63A47F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 16:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA8C1304032
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:50:55 -0700 (PDT)
Received: from mail-qc0-f196.google.com (mail-qc0-f196.google.com
	[209.85.216.196]) by cuda.sgi.com with ESMTP id
	PKr4hnOI9aiB4mqd (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 14:50:53 -0700 (PDT)
Received: by mail-qc0-f196.google.com with SMTP id c9so245480qcz.11
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140624201946.GJ9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
Date: Tue, 24 Jun 2014 23:50:52 +0200
Message-ID: <CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Managed to get the "metadata CRC error" again. Trying to get useful
info from an initramfs recovery shell is fun.

dmesg:

[    4.215841] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    4.224047] XFS (sda1): Mounting V5 Filesystem
[    4.527156] XFS (sda1): Starting recovery (logdev: internal)
[    4.546698] XFS (sda1): Metadata CRC error detected at
xfs_agi_read_verify+0x5e/0x110 [xfs], block 0x2
[    4.547083] XFS (sda1): Unmount and run xfs_repair
[    4.547347] XFS (sda1): First 64 bytes of corrupted metadata buffer:
[    4.547670] ffff8800364d3600: 58 41 47 49 00 00 00 01 00 00 00 00
00 13 d0 00  XAGI............
[    4.548027] ffff8800364d3610: 00 00 17 40 00 00 00 03 00 00 00 01
00 00 00 2b  ...@...........+
[    4.548382] ffff8800364d3620: 00 0c 95 40 ff ff ff ff ff ff ff ff
ff ff ff ff  ...@............
[    4.548752] ffff8800364d3630: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff  ................
[    4.549420] XFS (sda1): metadata I/O error: block 0x2
("xfs_trans_read_buf_map") error 74 numblks 1


Metadata dump (xz + base64): https://clbin.com/4KYSR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
