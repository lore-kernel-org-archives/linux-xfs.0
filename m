Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72D1E7F4E
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:05:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 563D0304097
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:05:01 -0700 (PDT)
Received: from mail-qg0-f68.google.com (mail-qg0-f68.google.com
	[209.85.192.68]) by cuda.sgi.com with ESMTP id FYWjxO8pIzeQSVCH
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:04:56 -0700 (PDT)
Received: by mail-qg0-f68.google.com with SMTP id q107so206090qgd.7
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:04:55 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Jun 2014 21:04:55 +0200
Message-ID: <CA+o=1OVmonTKZXujrJHJu17sn-Svf53wYhD5VKJVuaofffwKOw@mail.gmail.com>
Subject: Log record CRC mismatch after unclean unmount (was: Metadata CRC
	error upon unclean unmount)
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
To: xfs@oss.sgi.com

Accidentally sent it to Eric instead of here.

Kernel messages:

XFS (sdb1): Mounting V5 Filesystem
XFS (sdb1): Starting recovery (logdev: internal)
XFS (sdb1): log record CRC mismatch: found 0x956b6019, expected 0xc5023e00.
ffffc90004840000: 00 00 00 01 00 00 00 00 69 01 00 00 50 35 60 de
........i...P5`.
ffffc90004840010: 00 00 00 10 69 00 00 00 4e 41 52 54 2a 00 00 00
....i...NART*...
XFS (sdb1): log mount/recovery failed: error 117
XFS (sdb1): log mount failed

Metadata dump (base64 encoded, gzipped): https://clbin.com/xigeP

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
