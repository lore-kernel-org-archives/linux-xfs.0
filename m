Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 04 Apr 2007 06:24:27 -0700 (PDT)
Received: from mail3b1.westend.com (mail3b.westend.com [212.117.79.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l34DOKfB022642
	for <xfs@oss.sgi.com>; Wed, 4 Apr 2007 06:24:21 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail3b1.westend.com (Postfix) with ESMTP id 373B8BF30
	for <xfs@oss.sgi.com>; Wed,  4 Apr 2007 15:05:39 +0200 (CEST)
Received: from mail3b1.westend.com ([127.0.0.1])
	by localhost (mail3b [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 11168-04 for <xfs@oss.sgi.com>;
	Wed, 4 Apr 2007 15:05:35 +0200 (CEST)
Date: Wed, 4 Apr 2007 15:05:35 +0200
From: Thomas Kaehn <tk@westend.com>
Subject: Strange delete performance using XFS
Message-ID: <20070404130535.GE18320@mail3b.westend.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I've got a strange problem on one machine using XFS. Deleting large
directories (containing about 100000 files, 20k each) using "rm -rf"
lasts nearly as long as creating the the files using a bash loop.

The machine is running Debian Sarge with a vanilla 2.6.20.3 kernel.
CPU: Dual Xeon(TM) CPU 3.20GHz
RAM: 4 GB
RAID10: 4x 320 GB disks connected to 3ware 9550SXU-8LP 
 (Firmware Version = FE9X 3.08.00.004)

The XFS was first created using default options and later on with
"-d su=64k,sw=2 -l su=64k" which improved overall performance
but not delete performance.

Has anyone realized similar effects? On a different server (Dell 6850)
the directory can be deleted within seconds. What could be the reason
for the huge difference in delete performance?

Please see below for "time" output. 

| # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
| 
| real    6m6.814s
| user    0m30.290s
| sys     2m42.562s
| # time rm -rf y
| 
| real    5m18.034s
| user    0m0.036s
| sys     0m8.169s

In contrast to this the result on the Dell machine looks more
reasonable:

| # time for i in `seq 1 100000`; do dd if=/dev/zero of=$i bs=1k count=20 >/dev/null 2>&1; done
| 
| real    9m26.658s
| user    0m24.134s
| sys     3m3.623s
| # time rm -rf x
| 
| real    0m10.254s
| user    0m0.124s
| sys     0m10.105s

Ciao,
Thomas

PS: Using JFS and ext3 it is also possible to delete the above directory
in a couple of seconds. Only XFS seems problematic in this regard on
this system.
-- 
Thomas Kähn                   WESTEND GmbH  |  Internet-Business-Provider
Technik                       CISCO Systems Partner - Authorized Reseller
                              Im Süsterfeld 6          Tel 0241/701333-18
tk@westend.com                D-52072 Aachen              Fax 0241/911879
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Die Gesellschaft ist eingetragen im Handelsregister Aachen unter HRB 7608
Geschäftsführer:           Thomas Neugebauer, Thomas Heller, Michael Kolb
