Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Mar 2007 06:29:04 -0700 (PDT)
Received: from srv-mailrelais-dz1.argus.int (smtp.argus-presse.fr [213.244.9.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2NDSs6p013977
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 06:28:56 -0700
Received: from srv-mail-dz2.argus.int (srv-mail-dz2.argus.int [192.168.2.10])
	by srv-mailrelais-dz1.argus.int (Postfix) with ESMTP id 6979426968
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 14:10:42 +0100 (CET)
Received: from [10.0.0.111] (pnoel-as.argus.int [10.0.0.111])
	by srv-mail-dz2.argus.int (Postfix) with ESMTP id 595283D94
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2007 14:10:42 +0100 (CET)
Subject: xfs_repair on Debian testing 64bits
From: Patrick =?ISO-8859-1?Q?No=EBl?= <patrick.noel@argus-presse.fr>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 14:10:42 +0100
Message-Id: <1174655443.5441.37.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

i have a device with 5,3To under a debian (sarge) 32bits server.

When i try a xfs_repair (2.8.20) on 5,3To i have a message :

xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate
memory [ ... ] 

i tried mounting the device on a 64 bits (Debian testing) and with
xfs_repair 2.8.20 there is no problem with memory but is very long (12
hours between phase 1 and phase 6)

when i use xfs_repair on 32 bits i saw 8 thread but on 64 bits just only
on thread.

i try to force 8 thread with -o thread=8

and i have this message :

 xfs_repair -o thread=8 /dev/sdb1
 - creating 8 worker thread(s)


but with ps xa  | grep repair i see only one thread.

have an idea to have several thread ?

Thanks

Patrick 
