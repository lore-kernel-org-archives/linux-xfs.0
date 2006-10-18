Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Oct 2006 03:41:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9IAexaG026686
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 03:41:00 -0700
Received: from mxb.liv.ac.uk (mxb.liv.ac.uk [138.253.100.102])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF960D199F18
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 02:35:22 -0700 (PDT)
Received: from mailhuba.liv.ac.uk ([138.253.100.36])
	by mxb.liv.ac.uk with esmtp (Exim 4.62)
	(envelope-from <jrc@ns.ph.liv.ac.uk>)
	id 1Ga7pY-0000yI-D8
	for xfs@oss.sgi.com; Wed, 18 Oct 2006 10:35:20 +0100
Received: from localhost ([127.0.0.1] helo=mailhuba.liv.ac.uk)
	by mailhuba.liv.ac.uk with esmtp (Exim 4.54)
	id 1Ga7pY-0003Jc-BK
	for xfs@oss.sgi.com; Wed, 18 Oct 2006 10:35:20 +0100
Received: from npa.ph.liv.ac.uk ([138.253.148.32])
	by mailhuba.liv.ac.uk with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.54)
	id 1Ga7pY-0003JY-Af
	for xfs@oss.sgi.com; Wed, 18 Oct 2006 10:35:20 +0100
Received: from smartpet.ph.liv.ac.uk (root@smartpet.ph.liv.ac.uk [138.253.148.194])
	by npa.ph.liv.ac.uk (8.13.8/8.13.8/Debian-2) with ESMTP id k9I9ZKX7009553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 10:35:20 +0100
Received: from smartpet.ph.liv.ac.uk (jrc@localhost.localdomain [127.0.0.1])
	by smartpet.ph.liv.ac.uk (8.13.4/8.13.4/Debian-3) with ESMTP id k9I9ZKo3014553
	for <xfs@oss.sgi.com>; Wed, 18 Oct 2006 10:35:20 +0100
Received: (from jrc@localhost)
	by smartpet.ph.liv.ac.uk (8.13.4/8.13.4/Submit) id k9I9ZKYD014552
	for xfs@oss.sgi.com; Wed, 18 Oct 2006 10:35:20 +0100
From: John Cresswell <jrc@ns.ph.liv.ac.uk>
Message-Id: <200610180935.k9I9ZKYD014552@smartpet.ph.liv.ac.uk>
Subject: Xfsdump error
Date: Wed, 18 Oct 2006 10:35:20 +0100 (BST)
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I hope sombody can help me with this problem.
I have had to physically move our server, and
though connections and tape drives are the same, backups no longer work.
The tape drive can be written and read OK using tar, for example,
but not using xfsdump. A truncated example follows ...

xfsdump: RLIMIT_AS org cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: RLIMIT_STACK org cur 0x800000 max 0xffffffffffffffff
xfsdump: raising stack size soft limit from 0x800000 to 0x2000000
xfsdump: RLIMIT_STACK new cur 0x2000000 max 0xffffffffffffffff
xfsdump: RLIMIT_DATA org cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: RLIMIT_FSIZE org cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: RLIMIT_FSIZE now cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: RLIMIT_CPU cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: RLIMIT_CPU now cur 0xffffffffffffffff max 0xffffffffffffffff
xfsdump: INTGENMAX == 2147483647 (0x7fffffff)
xfsdump: UINTGENMAX == 4294967295 (0xffffffff)
xfsdump: OFF64MAX == 9223372036854775807 (0x7fffffffffffffff)
xfsdump: OFFMAX == -1 (0x7fffffff)
xfsdump: SIZEMAX == 4294967295 (0xffffffff)
xfsdump: INOMAX == 4294967295 (0xffffffff)
xfsdump: TIMEMAX == 2147483647 (0x7fffffff)
xfsdump: SIZE64MAX == 18446744073709551615 (0xffffffffffffffff)
xfsdump: INO64MAX == 18446744073709551615 (0xffffffffffffffff)
xfsdump: UINT64MAX == 18446744073709551615 (0xffffffffffffffff)
xfsdump: INT64MAX == 9223372036854775807 (0x7fffffffffffffff)
xfsdump: UINT32MAX == 4294967295 (0xffffffff)
xfsdump: INT32MAX == 2147483647 (0x7fffffff)
xfsdump: INT16MAX == 32767 (0x7fff)
xfsdump: UINT16MAX == 65535 (0xffff)
xfsdump: getpagesize( ) returns 4096
xfsdump: parent pid is 7297
xfsdump: effective user id is 0
xfsdump: using scsi tape (drive_scsitape) strategy
xfsdump: tty fd: 0; terminal interrupt character:  (03)
xfsdump: version 2.2.38 (dump format 3.0) - Running single-threaded
xfsdump: fs /export uuid [d59b77df-6e56-49b7-856d-7c2bacb7c57a]
xfsdump: creating directory /var/lib/xfsdump
xfsdump: resume range stream 0 ino 0:0 to end
xfsdump: WARNING: most recent level 0 dump was interrupted, but not resuming that dump since resume (-R) option not specified
xfsdump: level 0 dump of npa:/export
xfsdump: dump date: Wed Oct 18 09:56:01 2006
xfsdump: session id: 77440a1f-d61f-4315-9e12-ccd096fa858e
xfsdump: session label: "/export"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: bulkstat iteration initiated: start_ino == 0
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 128
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 2230883
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 2785347
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 3588899
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 4113891
xfsdump: ino 4540232 needed second bulkstat
xfsdump: ino 4545271 needed second bulkstat
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 5375201
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 7842945
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 9222497
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 9736641
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 75575268
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 76707332
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 77242663
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 77422823
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 78178664
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 79292758
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 80733591
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 83899577
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 84257849
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 136783452
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 137734076
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 141140476
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 141728988
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 142489212
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 143249328
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 143281968
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 143936176
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 145334544
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 145775696
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 201680272
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 208763379
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 209858739
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 210436659
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 211180467
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 214054426
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 215593183
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 216111071
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 217291263
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 273758656
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 274418496
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 277780772
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 278588324
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 279454859
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 284168267
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 284755275
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 285215467
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 285503627
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 337274924
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 338171052
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 339546220
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 340043340
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 340992265
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 342762057
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 343076495
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 344008943
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 344511183
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 345227919
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 420142481
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 420809489
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 421786033
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 422572785
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 423664947
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 424436998
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 426447494
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 427601286
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 475055112
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 477004168
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 477632424
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 479016360
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 479412040
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 480766906
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 483064993
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 483435617
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 485800065
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 486061025
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 547300066
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 548584128
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 549429280
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 549713856
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 550381568
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 551134178
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 551933346
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 552581890
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 603979939
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 608241813
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 609062421
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 609567061
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 610336085
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 610596469
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 612194039
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 617336539
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 617982715
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 618639227
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 672791504
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 675193712
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 677938608
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 678411024
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 678710193
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 679546549
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 682810133
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 683599925
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 685319189
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 685606325
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 766982390
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 767990806
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 770229430
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 771004374
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 774490396
xfsdump: calling bulkstat
...
xfsdump: bulkstat returns buflen 4096 ino 1018623604
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4011 ino 1019807284
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 0
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: skipping (only one dump stream)
xfsdump: bulkstat iteration initiated: start_ino == 0
xfsdump: calling bulkstat
xfsdump: bulkstat returns buflen 4096 ino 128
xfsdump: ino map construction complete
xfsdump: estimated dump size: 81317119424 bytes
xfsdump: estimated dump header size: 19318112 bytes
xfsdump: estimated component sizes: global hdr: 1337006139379712 bytes, inomap: 81616060935045120 bytes,  dir entries: 734544548415406080 bytes, file hdrs: 16395459996558557184 bytes, datasz: 578909639576387602 bytes
xfsdump: drive op: init
xfsdump: drive op: sync
xfsdump: Media op: begin media file
xfsdump: drive op: begin read
xfsdump: preparing drive
xfsdump: tape op: opening drive
xfsdump: tape op: get status
xfsdump: tape status = bot onl 
xfsdump: tape op: get block size info
xfsdump: max=1048576 cur=0
xfsdump: variable block size tape drive at /dev/st0
xfsdump: tape op: get block size info
xfsdump: max=1048576 cur=0
xfsdump: recommended tape media file size set to 0x7fffffffffffffff bytes
xfsdump: recommended tape media mark separation set to 0x1000000 bytes
xfsdump: determining tape record size: trying 1048576 (0x100000) bytes
xfsdump: tape op: get status
xfsdump: tape status = bot onl 
xfsdump: tape positioned at BOT: doing redundant rewind
xfsdump: tape op: rewind 0
xfsdump: tape op: get status
xfsdump: tape status = bot onl 
xfsdump: tape op: reading 1048576 bytes
xfsdump: tape op read of 1048576 bytes failed: errno == 16 (Device or resource busy)
xfsdump: tape op: get status
xfsdump: tape status = onl 
xfsdump: ERROR: unexpected tape error: errno 16 nread -1 blksz 1048576 recsz 1048576 isvar 1 wasatbot 1 eod 0 fmk 0 eot 0 onl 1 wprot 0 ew 0 
xfsdump: ERROR: unexpected error from do_begin_read: 10
xfsdump: content.c: 2291: mlog_exit called: exit_code: FAULT return: CORE (fatal error - core dumped)
xfsdump: dump size (non-dir files) : 0 bytes
xfsdump: NOTE: dump interrupted: 1 seconds elapsed: may resume later using -R option
xfsdump: content.c: 2731: mlog_exit_hint called: hint: INTERRUPT (dump interrupted)
xfsdump: main.c: 621: mlog_exit called: exit_code: FAULT return: UNKNOWN (unknown error)
xfsdump: closing inventory stream 0: interrupted
xfsdump: content.c: 5593: mlog_exit_hint called: hint: INTERRUPT (dump interrupted)
xfsdump: Dump Status: INTERRUPT
.
