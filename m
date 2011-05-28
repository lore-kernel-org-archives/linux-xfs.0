Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4S7jP8H091389 for <xfs@oss.sgi.com>; Sat, 28 May 2011 02:45:26 -0500
Received: from firestarter.dermichi.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2F3D1659F03
	for <xfs@oss.sgi.com>; Sat, 28 May 2011 00:45:24 -0700 (PDT)
Received: from firestarter.dermichi.com (firestarter.dermichi.com
	[78.41.115.230]) by cuda.sgi.com with ESMTP id 8W1QG3pgk4DtRFeA
	for <xfs@oss.sgi.com>; Sat, 28 May 2011 00:45:24 -0700 (PDT)
Received: from speechless.lan.dermichi.com
	([2001:470:26:2a9:4a5b:39ff:fe18:7163])
	by firestarter.dermichi.com with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.76) (envelope-from <mw@dermichi.com>) id 1QQECz-00057z-Mh
	for xfs@oss.sgi.com; Sat, 28 May 2011 09:45:23 +0200
Message-ID: <4DE0A80C.7060806@dermichi.com>
Date: Sat, 28 May 2011 09:45:16 +0200
From: Michael Weissenbacher <mw@dermichi.com>
MIME-Version: 1.0
Subject: logbufs default value
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
>From linux-2.6.39/Documentation/filesystems/xfs.txt:
  logbufs=value
        Set the number of in-memory log buffers.  Valid numbers range
        from 2-8 inclusive.
        The default value is 8 buffers for filesystems with a
        blocksize of 64KiB, 4 buffers for filesystems with a blocksize
        of 32KiB, 3 buffers for filesystems with a blocksize of 16KiB
        and 2 buffers for all other configurations.  Increasing the
        number of buffers may increase performance on some workloads
        at the cost of the memory used for the additional log buffers
        and their associated control structures.

Is this still valid? I thought that newer kernels would always use 8 as
default?

tia,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
