Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 07:17:21 -0700 (PDT)
Received: from mail.interline.it (mail.interline.it [195.182.241.4])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GEH6DW004385
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 07:17:07 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.interline.it (Postfix) with ESMTP id C5D23B12
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 15:08:51 +0200 (CEST)
Received: from mail.interline.it ([127.0.0.1])
	by localhost (pin [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 01259-03 for <xfs@oss.sgi.com>;
	Wed, 16 Aug 2006 15:08:50 +0200 (CEST)
Received: from [192.168.1.98] (unknown [88.36.237.170])
	by mail.interline.it (Postfix) with ESMTP id CAFC4B0C
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 15:08:49 +0200 (CEST)
From: "Daniele P." <daniele@interline.it>
Subject: xfsdump -s unacceptable performances
Date: Wed, 16 Aug 2006 15:15:00 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200608161515.00543.daniele@interline.it>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi all,
I'm new to the list. I have a problem with xfsdump using the -s option.
I'm aware that the latest version (2.2.38) skip the scan and prune of
the entire filesystem (see the test below), but there are other places
where xfsdump performs an entire scan of the filesystem, slowing down
the backup process.

For example in:
 * dump/inomap.c after "phase 3" there is a function call to
   bigstat_iter that scan the entire filesystem
 * dump/content.c the function dump_dirs again scan the entire
   filesystem

Are all there scan really necessary?
Could we expect a performance fix?
Is there a workaround?

I have done some test, and with quite large filesystem the performances
where unacceptable. Dumping one directory with 4 file using 4KB of space
takes hours (or days, it hasn't finished yet) if the underlying filesystem
contains around 10.000.000 inodes.

On request I could provide more information and the output of some test.

Let's start with a simple comparison between 2.2.27 and 2.2.38
using a small filesystem (40.000 inodes).

time xfsdump -p 60 -v drive=debug,media=debug \
-s etc/20060401-0030 - /media/xfs-test | dd of=/dev/null
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 2.2.27 (dump format 3.0) - Running single-threaded
[...]
xfsdump: media file size 17780576 bytes
xfsdump: dump size (non-dir files) : 16477472 bytes
xfsdump: dump complete: 219459 seconds elapsed
xfsdump: Dump Status: SUCCESS
34727+1 records in
34727+1 records out
17780576 bytes transferred in 219459.047053 seconds (81 bytes/sec)

real    3657m39.120s
user    0m2.361s
sys     0m9.238s


time /usr/lib/bin/xfsdump -p 60 -v drive=debug,media=debug \
-s etc/20060401-0030 - /media/xfs-test | dd of=/dev/null
/usr/lib/bin/xfsdump: using file dump (drive_simple) strategy
/usr/lib/bin/xfsdump: version 2.2.38 (dump format 3.0) - Running single-threaded
[...]
/usr/lib/bin/xfsdump: media file size 17780576 bytes
/usr/lib/bin/xfsdump: dump size (non-dir files) : 16477472 bytes
/usr/lib/bin/xfsdump: dump complete: 18 seconds elapsed
/usr/lib/bin/xfsdump: Dump Status: SUCCESS
34727+1 records in
34727+1 records out
17780576 bytes transferred in 17.451939 seconds (1018831 bytes/sec)

real    0m17.575s
user    0m0.132s
sys     0m1.035s

Thanks in advance for your suggestions.

Daniele P.
