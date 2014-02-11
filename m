Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 571577F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:55:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 00D0BAC016
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 11:55:29 -0800 (PST)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id x93MzwWmBhu3CbjC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 11:55:28 -0800 (PST)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <cody@linux.vnet.ibm.com>;
	Tue, 11 Feb 2014 14:55:28 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com
	[9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id A8DE0C9003E
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:55:22 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by b01cxnp23034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	s1BJtPwk9175468 for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 19:55:25 GMT
Received: from d01av03.pok.ibm.com (localhost [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	s1BJtPDB030829 for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:55:25 -0500
Received: from [9.80.95.14] ([9.80.95.14])
	by d01av03.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id
	s1BJtOKF030773 for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 14:55:24 -0500
Message-ID: <52FA8021.9050604@linux.vnet.ibm.com>
Date: Tue, 11 Feb 2014 11:55:13 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: xfs_repair fails to repair, run under valgrind shows "Invalid read..."
	and XFS_CORRUPTION_ERROR
Content-Type: multipart/mixed; boundary="------------060604090100000501030309"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060604090100000501030309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

xfsprogs version: v3.2.0-alpha2-14-g6e79202

uname: Linux hostname 3.11.10-301.fc20.ppc64 #1 SMP Tue Dec 10 00:35:15 
MST 2013 ppc64 POWER8 (architected), altivec supported CHRP IBM,8286-42A 
GNU/Linux

full log attached.

--------------060604090100000501030309
Content-Type: text/x-log;
 name="xfs_repair_fail_valgrind.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xfs_repair_fail_valgrind.log"


syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair -n /dev/sda5                 
==6601== Memcheck, a memory error detector
==6601== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
==6601== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
==6601== Command: ./repair/xfs_repair -n /dev/sda5
==6601== 
--6601-- WARNING: Serious error when reading debug info
--6601-- When reading debug info from /usr/lib64/valgrind/memcheck-ppc64-linux:
--6601-- Can't make sense of .eh_frame section mapping
--6601-- WARNING: unhandled syscall:  62
--6601-- You may be able to write your own handler.
--6601-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--6601-- Nevertheless we consider this a bug.  Please report
--6601-- it at http://valgrind.org/support/bug_reports.html.
--6601-- WARNING: unhandled syscall:  62
--6601-- You may be able to write your own handler.
--6601-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--6601-- Nevertheless we consider this a bug.  Please report
--6601-- it at http://valgrind.org/support/bug_reports.html.
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
would have cleared inode 134685059
data fork in regular inode 134685060 claims used block 8438124
correcting nextents for inode 134685060
bad data fork in inode 134685060
would have cleared inode 134685060
data fork in regular inode 134685061 claims used block 8438127
correcting nextents for inode 134685061
bad data fork in inode 134685061
would have cleared inode 134685061
data fork in regular inode 134685062 claims used block 8438131
correcting nextents for inode 134685062
bad data fork in inode 134685062
would have cleared inode 134685062
data fork in regular inode 134685063 claims used block 8438136
correcting nextents for inode 134685063
bad data fork in inode 134685063
would have cleared inode 134685063
data fork in regular inode 134685064 claims used block 8438140
correcting nextents for inode 134685064
bad data fork in inode 134685064
would have cleared inode 134685064
data fork in regular inode 134685065 claims used block 8438144
correcting nextents for inode 134685065
bad data fork in inode 134685065
would have cleared inode 134685065
data fork in regular inode 134685066 claims used block 8438147
correcting nextents for inode 134685066
bad data fork in inode 134685066
would have cleared inode 134685066
data fork in regular inode 134685067 claims used block 8438150
correcting nextents for inode 134685067
bad data fork in inode 134685067
would have cleared inode 134685067
data fork in regular inode 134685068 claims used block 8438154
correcting nextents for inode 134685068
bad data fork in inode 134685068
would have cleared inode 134685068
data fork in regular inode 134685069 claims used block 8438157
correcting nextents for inode 134685069
bad data fork in inode 134685069
would have cleared inode 134685069
data fork in regular inode 134685070 claims used block 8438161
correcting nextents for inode 134685070
bad data fork in inode 134685070
would have cleared inode 134685070
data fork in regular inode 134685071 claims used block 8438164
correcting nextents for inode 134685071
bad data fork in inode 134685071
would have cleared inode 134685071
bad . entry in directory inode 134754783, was 134779771: would correct
bad nblocks 3 for inode 135280001, would reset to 17
bad nblocks 74 for inode 135280003, would reset to 1
bad nblocks 49 for inode 135280005, would reset to 2
bad nblocks 2 for inode 135280006, would reset to 1
inode 135280007 - extent offset too large - start 8567439, count 69, offset 15534687187369984
correcting nextents for inode 135280007
bad data fork in inode 135280007
would have cleared inode 135280007
bad nblocks 8 for inode 135280008, would reset to 1
bad nblocks 7 for inode 135280009, would reset to 1
bad nblocks 12 for inode 135280010, would reset to 1
bad nblocks 12 for inode 135280011, would reset to 1
bad nblocks 19 for inode 135280014, would reset to 1
bad nblocks 12 for inode 135280015, would reset to 1
data fork in regular inode 137150480 claims used block 8577327
correcting nextents for inode 137150480
bad data fork in inode 137150480
would have cleared inode 137150480
data fork in regular inode 137150481 claims used block 8586960
correcting nextents for inode 137150481
bad data fork in inode 137150481
would have cleared inode 137150481
data fork in regular inode 137150482 claims used block 8586977
correcting nextents for inode 137150482
bad data fork in inode 137150482
would have cleared inode 137150482
data fork in regular inode 137150483 claims used block 8572108
correcting nextents for inode 137150483
bad data fork in inode 137150483
would have cleared inode 137150483
data fork in regular inode 137150484 claims used block 8572109
correcting nextents for inode 137150484
bad data fork in inode 137150484
would have cleared inode 137150484
data fork in regular inode 137150485 claims used block 8572114
correcting nextents for inode 137150485
bad data fork in inode 137150485
would have cleared inode 137150485
data fork in regular inode 137150486 claims used block 8572116
correcting nextents for inode 137150486
bad data fork in inode 137150486
would have cleared inode 137150486
data fork in regular inode 137150488 claims used block 8577514
correcting nextents for inode 137150488
bad data fork in inode 137150488
would have cleared inode 137150488
data fork in regular inode 137150489 claims used block 8578212
correcting nextents for inode 137150489
bad data fork in inode 137150489
would have cleared inode 137150489
data fork in regular inode 137150490 claims used block 8578429
correcting nextents for inode 137150490
bad data fork in inode 137150490
would have cleared inode 137150490
data fork in regular inode 137150491 claims used block 8578968
correcting nextents for inode 137150491
bad data fork in inode 137150491
would have cleared inode 137150491
data fork in regular inode 137150492 claims used block 8578969
correcting nextents for inode 137150492
bad data fork in inode 137150492
would have cleared inode 137150492
data fork in regular inode 137150493 claims used block 8578970
correcting nextents for inode 137150493
bad data fork in inode 137150493
would have cleared inode 137150493
data fork in regular inode 137150494 claims used block 8578971
correcting nextents for inode 137150494
bad data fork in inode 137150494
would have cleared inode 137150494
data fork in regular inode 137150495 claims used block 8578972
correcting nextents for inode 137150495
bad data fork in inode 137150495
would have cleared inode 137150495
        - agno = 3
would have cleared inode 77579760
data fork in ino 77579761 claims dup extent, off - 0, start - 8438117, cnt 3
correcting nextents for inode 77579761
bad data fork in inode 77579761
would have cleared inode 77579761
data fork in ino 77579762 claims dup extent, off - 0, start - 8438120, cnt 1
correcting nextents for inode 77579762
bad data fork in inode 77579762
would have cleared inode 77579762
data fork in ino 77579763 claims dup extent, off - 0, start - 8438121, cnt 3
correcting nextents for inode 77579763
bad data fork in inode 77579763
would have cleared inode 77579763
data fork in ino 77579764 claims dup extent, off - 0, start - 8438124, cnt 3
correcting nextents for inode 77579764
bad data fork in inode 77579764
would have cleared inode 77579764
data fork in ino 77579765 claims dup extent, off - 0, start - 8438127, cnt 4
correcting nextents for inode 77579765
bad data fork in inode 77579765
would have cleared inode 77579765
data fork in ino 77579766 claims dup extent, off - 0, start - 8438131, cnt 5
correcting nextents for inode 77579766
bad data fork in inode 77579766
would have cleared inode 77579766
data fork in ino 77579767 claims dup extent, off - 0, start - 8438136, cnt 4
correcting nextents for inode 77579767
bad data fork in inode 77579767
would have cleared inode 77579767
data fork in ino 77579768 claims dup extent, off - 0, start - 8438140, cnt 4
correcting nextents for inode 77579768
bad data fork in inode 77579768
would have cleared inode 77579768
data fork in ino 77579769 claims dup extent, off - 0, start - 8438144, cnt 3
correcting nextents for inode 77579769
bad data fork in inode 77579769
would have cleared inode 77579769
data fork in ino 77579770 claims dup extent, off - 0, start - 8438147, cnt 3
correcting nextents for inode 77579770
bad data fork in inode 77579770
would have cleared inode 77579770
data fork in ino 77579771 claims dup extent, off - 0, start - 8438150, cnt 4
correcting nextents for inode 77579771
bad data fork in inode 77579771
would have cleared inode 77579771
data fork in ino 77579772 claims dup extent, off - 0, start - 8438154, cnt 3
correcting nextents for inode 77579772
bad data fork in inode 77579772
would have cleared inode 77579772
data fork in ino 77579773 claims dup extent, off - 0, start - 8438157, cnt 4
correcting nextents for inode 77579773
bad data fork in inode 77579773
would have cleared inode 77579773
data fork in ino 77579774 claims dup extent, off - 0, start - 8438161, cnt 3
correcting nextents for inode 77579774
bad data fork in inode 77579774
would have cleared inode 77579774
data fork in ino 77579775 claims dup extent, off - 0, start - 8438164, cnt 3
correcting nextents for inode 77579775
bad data fork in inode 77579775
would have cleared inode 77579775
entry "zipgrep" at block 8 offset 2224 in directory inode 134320266 references free inode 137150483
        would clear inode number in entry at offset 2224...
entry "gnome-font-viewer.mo" at block 0 offset 1024 in directory inode 134322940 references free inode 137150489
        would clear inode number in entry at offset 1024...
entry "gnome-font-viewer.mo" at block 1 offset 1272 in directory inode 134322941 references free inode 137150493
        would clear inode number in entry at offset 1272...
entry "gnome-font-viewer.mo" at block 1 offset 2304 in directory inode 134322942 references free inode 137150495
        would clear inode number in entry at offset 2304...
entry "libbonobo-2.0.mo" at block 0 offset 1024 in directory inode 134322950 references free inode 134685057
        would clear inode number in entry at offset 1024...
entry "libbonobo-2.0.mo" at block 0 offset 1016 in directory inode 134322951 references free inode 134685060
        would clear inode number in entry at offset 1016...
entry "libbonobo-2.0.mo" at block 0 offset 1496 in directory inode 134322952 references free inode 134685065
        would clear inode number in entry at offset 1496...
entry "libbonobo-2.0.mo" at block 0 offset 1472 in directory inode 134322953 references free inode 134685068
        would clear inode number in entry at offset 1472...
entry "libbonobo-2.0.mo" at block 0 offset 1640 in directory inode 134322954 references free inode 134685069
        would clear inode number in entry at offset 1640...
entry "libbonobo-2.0.mo" at block 0 offset 1304 in directory inode 134322955 references free inode 134685070
        would clear inode number in entry at offset 1304...
entry "libbonobo-2.0.mo" at block 0 offset 680 in directory inode 134322956 references free inode 134685071
        would clear inode number in entry at offset 680...
entry "gnome-font-viewer.mo" at block 0 offset 3168 in directory inode 134323184 references free inode 137150488
        would clear inode number in entry at offset 3168...
entry "gnome-font-viewer.mo" at block 0 offset 2928 in directory inode 134323192 references free inode 137150490
        would clear inode number in entry at offset 2928...
entry "gnome-font-viewer.mo" at block 0 offset 2488 in directory inode 134323198 references free inode 137150491
        would clear inode number in entry at offset 2488...
entry "gnome-font-viewer.mo" at block 0 offset 3048 in directory inode 134323200 references free inode 137150492
        would clear inode number in entry at offset 3048...
entry "gnome-font-viewer.mo" at block 0 offset 2200 in directory inode 134323204 references free inode 137150494
        would clear inode number in entry at offset 2200...
entry "libbonobo-2.0.mo" at block 0 offset 544 in directory inode 134323299 references free inode 134685056
        would clear inode number in entry at offset 544...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323305 references free inode 134685058
        would clear inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 144 in directory inode 134323311 references free inode 134685059
        would clear inode number in entry at offset 144...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323326 references free inode 134685061
        would clear inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 704 in directory inode 134323327 references free inode 134685062
        would clear inode number in entry at offset 704...
entry "libbonobo-2.0.mo" at block 0 offset 544 in directory inode 134323363 references free inode 134685063
        would clear inode number in entry at offset 544...
entry "libbonobo-2.0.mo" at block 0 offset 344 in directory inode 134323374 references free inode 134685064
        would clear inode number in entry at offset 344...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323378 references free inode 134685066
        would clear inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 704 in directory inode 134323387 references free inode 134685067
        would clear inode number in entry at offset 704...
entry "unzip.1.gz" at block 9 offset 2136 in directory inode 134323469 references free inode 137150484
        would clear inode number in entry at offset 2136...
entry "unzipsfx.1.gz" at block 9 offset 2200 in directory inode 134323469 references free inode 137150485
        would clear inode number in entry at offset 2200...
entry "zipgrep.1.gz" at block 9 offset 2256 in directory inode 134323469 references free inode 137150486
        would clear inode number in entry at offset 2256...
data fork in ino 134685056 claims dup extent, off - 0, start - 8438113, cnt 4
correcting nextents for inode 134685056
bad data fork in inode 134685056
would have cleared inode 134685056
data fork in ino 134685057 claims dup extent, off - 0, start - 8438117, cnt 3
correcting nextents for inode 134685057
bad data fork in inode 134685057
would have cleared inode 134685057
would have cleared inode 134685063
data fork in ino 134685064 claims dup extent, off - 0, start - 8438140, cnt 4
correcting nextents for inode 134685064
bad data fork in inode 134685064
would have cleared inode 134685064
data fork in ino 134685065 claims dup extent, off - 0, start - 8438144, cnt 3
correcting nextents for inode 134685065
bad data fork in inode 134685065
would have cleared inode 134685065
data fork in ino 134685066 claims dup extent, off - 0, start - 8438147, cnt 3
correcting nextents for inode 134685066
bad data fork in inode 134685066
would have cleared inode 134685066
data fork in ino 134685067 claims dup extent, off - 0, start - 8438150, cnt 4
correcting nextents for inode 134685067
bad data fork in inode 134685067
would have cleared inode 134685067
data fork in ino 134685068 claims dup extent, off - 0, start - 8438154, cnt 3
correcting nextents for inode 134685068
bad data fork in inode 134685068
would have cleared inode 134685068
data fork in ino 134685069 claims dup extent, off - 0, start - 8438157, cnt 4
correcting nextents for inode 134685069
bad data fork in inode 134685069
would have cleared inode 134685069
data fork in ino 134685070 claims dup extent, off - 0, start - 8438161, cnt 3
correcting nextents for inode 134685070
bad data fork in inode 134685070
would have cleared inode 134685070
data fork in ino 134685071 claims dup extent, off - 0, start - 8438164, cnt 3
correcting nextents for inode 134685071
bad data fork in inode 134685071
would have cleared inode 134685071
bad . entry in directory inode 134754783, was 134779771: would correct
data fork in ino 135280000 claims dup extent, off - 0, start - 8577327, cnt 17
correcting nextents for inode 135280000
bad data fork in inode 135280000
would have cleared inode 135280000
data fork in ino 135280001 claims dup extent, off - 0, start - 8586960, cnt 17
correcting nextents for inode 135280001
bad data fork in inode 135280001
would have cleared inode 135280001
data fork in ino 135280003 claims dup extent, off - 0, start - 8572108, cnt 1
correcting nextents for inode 135280003
bad data fork in inode 135280003
would have cleared inode 135280003
data fork in ino 135280004 claims dup extent, off - 0, start - 8572109, cnt 5
correcting nextents for inode 135280004
bad data fork in inode 135280004
would have cleared inode 135280004
data fork in ino 135280005 claims dup extent, off - 0, start - 8572114, cnt 2
correcting nextents for inode 135280005
bad data fork in inode 135280005
would have cleared inode 135280005
data fork in ino 135280006 claims dup extent, off - 0, start - 8572116, cnt 1
correcting nextents for inode 135280006
bad data fork in inode 135280006
would have cleared inode 135280006
inode 135280007 - extent offset too large - start 8567439, count 69, offset 15534687187369984
correcting nextents for inode 135280007
bad data fork in inode 135280007
would have cleared inode 135280007
data fork in ino 135280008 claims dup extent, off - 0, start - 8577514, cnt 1
correcting nextents for inode 135280008
bad data fork in inode 135280008
would have cleared inode 135280008
data fork in ino 135280009 claims dup extent, off - 0, start - 8578212, cnt 1
correcting nextents for inode 135280009
bad data fork in inode 135280009
would have cleared inode 135280009
data fork in ino 135280010 claims dup extent, off - 0, start - 8578429, cnt 1
correcting nextents for inode 135280010
bad data fork in inode 135280010
would have cleared inode 135280010
data fork in ino 135280011 claims dup extent, off - 0, start - 8578968, cnt 1
correcting nextents for inode 135280011
bad data fork in inode 135280011
would have cleared inode 135280011
data fork in ino 135280012 claims dup extent, off - 0, start - 8578969, cnt 1
correcting nextents for inode 135280012
bad data fork in inode 135280012
would have cleared inode 135280012
data fork in ino 135280013 claims dup extent, off - 0, start - 8578970, cnt 1
correcting nextents for inode 135280013
bad data fork in inode 135280013
would have cleared inode 135280013
data fork in ino 135280014 claims dup extent, off - 0, start - 8578971, cnt 1
correcting nextents for inode 135280014
bad data fork in inode 135280014
would have cleared inode 135280014
data fork in ino 135280015 claims dup extent, off - 0, start - 8578972, cnt 1
correcting nextents for inode 135280015
bad data fork in inode 135280015
would have cleared inode 135280015
data fork in ino 137150480 claims dup extent, off - 0, start - 8577327, cnt 17
correcting nextents for inode 137150480
bad data fork in inode 137150480
would have cleared inode 137150480
data fork in ino 137150481 claims dup extent, off - 0, start - 8586960, cnt 17
correcting nextents for inode 137150481
bad data fork in inode 137150481
would have cleared inode 137150481
data fork in regular inode 137150482 claims used block 8586977
correcting nextents for inode 137150482
would have cleared inode 137150482
data fork in ino 137150483 claims dup extent, off - 0, start - 8572108, cnt 1
correcting nextents for inode 137150483
bad data fork in inode 137150483
would have cleared inode 137150483
data fork in ino 137150484 claims dup extent, off - 0, start - 8572109, cnt 5
correcting nextents for inode 137150484
bad data fork in inode 137150484
would have cleared inode 137150484
data fork in ino 137150485 claims dup extent, off - 0, start - 8572114, cnt 2
correcting nextents for inode 137150485
bad data fork in inode 137150485
would have cleared inode 137150485
data fork in ino 137150486 claims dup extent, off - 0, start - 8572116, cnt 1
correcting nextents for inode 137150486
bad data fork in inode 137150486
would have cleared inode 137150486
data fork in ino 137150488 claims dup extent, off - 0, start - 8577514, cnt 1
correcting nextents for inode 137150488
bad data fork in inode 137150488
would have cleared inode 137150488
bad data fork in inode 137150490
would have cleared inode 137150490
data fork in ino 137150491 claims dup extent, off - 0, start - 8578968, cnt 1
correcting nextents for inode 137150491
bad data fork in inode 137150491
would have cleared inode 137150491
data fork in ino 137150492 claims dup extent, off - 0, start - 8578969, cnt 1
correcting nextents for inode 137150492
bad data fork in inode 137150492
would have cleared inode 137150492
data fork in ino 137150493 claims dup extent, off - 0, start - 8578970, cnt 1
correcting nextents for inode 137150493
bad data fork in inode 137150493
would have cleared inode 137150493
data fork in ino 137150494 claims dup extent, off - 0, start - 8578971, cnt 1
correcting nextents for inode 137150494
bad data fork in inode 137150494
would have cleared inode 137150494
data fork in ino 137150495 claims dup extent, off - 0, start - 8578972, cnt 1
correcting nextents for inode 137150495
bad data fork in inode 137150495
would have cleared inode 137150495
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "system.d" in shortform directory inode 67687581 points to free inode 135280000
would junk entry
entry "hwspinlock" in dir inode 70039312 inconsistent with .. value (70042219) in ino 134754783
        would clear entry "hwspinlock"
entry, would junk entry.ko" in directory inode 77579738 points to free inode 77579760
entry , would junk entry.ko" in directory inode 77579738 points to free inode 77579761
entry , would junk entry.ko" in directory inode 77579738 points to free inode 77579762
entry "nf_nat.ko" in directory inode 77579738 points to free inode 77579763, would junk entry
en, would junk entry.ko" in directory inode 77579738 points to free inode 77579764
entry "nf_nat_ftp.ko" in directory inode 77579738 points to free inode 77579765, would junk entry
entry "nf_nat_irc.ko" in directory inode 77579738 points to free inode 77579766, would junk entry
entry , would junk entry.ko" in directory inode 77579738 points to free inode 77579767
entry , would junk entry.ko" in directory inode 77579738 points to free inode 77579768
entry "nf, would junk entry.ko" in directory inode 77579738 points to free inode 77579769
entry "nf_nat_sip.ko" in directory inode 77579738 points to free inode 77579770, would junk entry
entry "nf_nat_tftp.ko" in directory inode 77579738 points to free inode 77579771, would junk entry
entry "nfnetlink.ko" in directory inode 77579738 points to free inode 77579772, would junk entry
ent, would junk entry.ko" in directory inode 77579738 points to free inode 77579773
entry ", would junk entry.ko" in directory inode 77579738 points to free inode 77579774
en, would junk entry.ko" in directory inode 77579738 points to free inode 77579775
bad hash table for directory inode 77579738 (no data entry): would rebuild
entry "attr" in directory inode 134320266 points to free inode 137150480, would junk entry
entry "db_deadlock" in directory inode 134320266 points to free inode 137150481, would junk entry
entry "db_stat" in directory inode 134320266 points to free inode 137150482, would junk entry
entry "zipgrep" in directory inode 134320266 points to free inode 137150483, would junk entry
entry "g, would junk entryo" in directory inode 134322940 points to free inode 137150489
bad hash table for directory inode 134322940 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134322941 points to free inode 137150493
bad hash table for directory inode 134322941 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134322942 points to free inode 137150495
bad hash table for directory inode 134322942 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322950 points to free inode 134685057
bad hash table for directory inode 134322950 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322951 points to free inode 134685060
bad hash table for directory inode 134322951 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322952 points to free inode 134685065
bad hash table for directory inode 134322952 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322953 points to free inode 134685068
bad hash table for directory inode 134322953 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322954 points to free inode 134685069
bad hash table for directory inode 134322954 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322955 points to free inode 134685070
bad hash table for directory inode 134322955 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134322956 points to free inode 134685071
bad hash table for directory inode 134322956 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134323184 points to free inode 137150488
bad hash table for directory inode 134323184 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134323192 points to free inode 137150490
bad hash table for directory inode 134323192 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134323198 points to free inode 137150491
bad hash table for directory inode 134323198 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134323200 points to free inode 137150492
bad hash table for directory inode 134323200 (no data entry): would rebuild
entry "g, would junk entryo" in directory inode 134323204 points to free inode 137150494
bad hash table for directory inode 134323204 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323299 points to free inode 134685056
bad hash table for directory inode 134323299 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323305 points to free inode 134685058
bad hash table for directory inode 134323305 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323311 points to free inode 134685059
bad hash table for directory inode 134323311 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323326 points to free inode 134685061
bad hash table for directory inode 134323326 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323327 points to free inode 134685062
bad hash table for directory inode 134323327 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323363 points to free inode 134685063
bad hash table for directory inode 134323363 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323374 points to free inode 134685064
bad hash table for directory inode 134323374 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323378 points to free inode 134685066
bad hash table for directory inode 134323378 (no data entry): would rebuild
entr, would junk entryo" in directory inode 134323387 points to free inode 134685067
bad hash table for directory inode 134323387 (no data entry): would rebuild
entry "unzip.1.gz" in directory inode 134323469 points to free inode 137150484, would junk entry
e, would junk entryz" in directory inode 134323469 points to free inode 137150485
entry "zipgrep.1.gz" in directory inode 134323469 points to free inode 137150486, would junk entry
entry "." in dir 134754783 points to an already connected directory inode 134779771
        would clear entry "."
would create missing "." entry in dir ino 134754783
entry "yum" in directory inode 135117175 points to free inode 135280004, would junk entry
bad hash table for directory inode 135117175 (no data entry): would rebuild
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 134555749, would move to lost+found
disconnected inode 134748865, would move to lost+found
disconnected inode 134748917, would move to lost+found
disconnected dir inode 134754783, would move to lost+found
disconnected inode 134765632, would move to lost+found
disconnected inode 134765633, would move to lost+found
disconnected inode 134765634, would move to lost+found
disconnected inode 134765635, would move to lost+found
disconnected inode 134765636, would move to lost+found
disconnected inode 134765637, would move to lost+found
disconnected inode 135280016, would move to lost+found
disconnected inode 135280017, would move to lost+found
disconnected inode 135280018, would move to lost+found
disconnected inode 135280019, would move to lost+found
disconnected inode 135280020, would move to lost+found
disconnected inode 135280021, would move to lost+found
disconnected inode 135280022, would move to lost+found
disconnected inode 135280037, would move to lost+found
disconnected inode 135280038, would move to lost+found
disconnected inode 135280039, would move to lost+found
disconnected inode 135280040, would move to lost+found
disconnected inode 135280041, would move to lost+found
disconnected inode 135280042, would move to lost+found
disconnected inode 135280043, would move to lost+found
disconnected inode 135280044, would move to lost+found
disconnected inode 135280045, would move to lost+found
disconnected inode 135280046, would move to lost+found
disconnected inode 135280047, would move to lost+found
disconnected inode 135280048, would move to lost+found
disconnected inode 135280049, would move to lost+found
disconnected inode 135280050, would move to lost+found
disconnected inode 135280051, would move to lost+found
disconnected inode 135280052, would move to lost+found
disconnected inode 135280053, would move to lost+found
disconnected inode 135280054, would move to lost+found
disconnected inode 135280055, would move to lost+found
disconnected inode 135280056, would move to lost+found
disconnected inode 135280057, would move to lost+found
disconnected inode 135280058, would move to lost+found
disconnected inode 135280059, would move to lost+found
disconnected inode 135280060, would move to lost+found
disconnected inode 135280061, would move to lost+found
disconnected inode 135280062, would move to lost+found
disconnected inode 135280063, would move to lost+found
disconnected inode 135280064, would move to lost+found
disconnected inode 135280065, would move to lost+found
disconnected inode 135280066, would move to lost+found
disconnected inode 135280067, would move to lost+found
disconnected inode 135280257, would move to lost+found
disconnected inode 135280258, would move to lost+found
disconnected inode 135338277, would move to lost+found
disconnected inode 135338278, would move to lost+found
disconnected inode 135338284, would move to lost+found
disconnected inode 135338286, would move to lost+found
disconnected inode 135338287, would move to lost+found
disconnected inode 135338288, would move to lost+found
disconnected inode 135338289, would move to lost+found
disconnected inode 135338366, would move to lost+found
disconnected inode 135361331, would move to lost+found
disconnected inode 135418058, would move to lost+found
disconnected inode 135424793, would move to lost+found
disconnected inode 135424797, would move to lost+found
disconnected inode 135470020, would move to lost+found
disconnected inode 135470025, would move to lost+found
disconnected inode 135470033, would move to lost+found
disconnected inode 135470037, would move to lost+found
disconnected inode 135470050, would move to lost+found
disconnected inode 135495346, would move to lost+found
disconnected inode 135495495, would move to lost+found
disconnected inode 135495496, would move to lost+found
disconnected inode 135525755, would move to lost+found
disconnected inode 135525845, would move to lost+found
disconnected inode 135648551, would move to lost+found
disconnected inode 135648552, would move to lost+found
disconnected inode 135648553, would move to lost+found
disconnected inode 135648600, would move to lost+found
disconnected inode 135648676, would move to lost+found
disconnected inode 135648678, would move to lost+found
disconnected inode 135648679, would move to lost+found
disconnected inode 135653700, would move to lost+found
disconnected inode 135653716, would move to lost+found
disconnected inode 135701266, would move to lost+found
disconnected inode 135710889, would move to lost+found
disconnected inode 135711371, would move to lost+found
disconnected inode 135841274, would move to lost+found
disconnected inode 135841275, would move to lost+found
disconnected inode 136103192, would move to lost+found
disconnected inode 136250457, would move to lost+found
disconnected inode 136374233, would move to lost+found
disconnected inode 136413756, would move to lost+found
disconnected inode 137150557, would move to lost+found
disconnected inode 137160438, would move to lost+found
disconnected inode 137160523, would move to lost+found
disconnected inode 137167242, would move to lost+found
Phase 7 - verify link counts...
would have reset inode 67687581 nlinks from 4 to 3
would have reset inode 70039312 nlinks from 114 to 113
would have reset inode 134779772 nlinks from 1 to 2
would have reset inode 134779773 nlinks from 1 to 2
would have reset inode 134779774 nlinks from 1 to 2
would have reset inode 134779775 nlinks from 1 to 2
would have reset inode 134780032 nlinks from 1 to 2
would have reset inode 134780033 nlinks from 1 to 2
would have reset inode 135117175 nlinks from 49 to 48
would have reset inode 202927847 nlinks from 6 to 5
No modify flag set, skipping filesystem flush and exiting.
==6601== 
==6601== HEAP SUMMARY:
==6601==     in use at exit: 88,349,232 bytes in 55,012 blocks
==6601==   total heap usage: 1,434,708 allocs, 1,379,696 frees, 451,243,273 bytes allocated
==6601== 
==6601== LEAK SUMMARY:
==6601==    definitely lost: 3,744 bytes in 11 blocks
==6601==    indirectly lost: 256 bytes in 4 blocks
==6601==      possibly lost: 0 bytes in 0 blocks
==6601==    still reachable: 88,345,232 bytes in 54,997 blocks
==6601==         suppressed: 0 bytes in 0 blocks
==6601== 
==6601== For counts of detected and suppressed errors, rerun with: -v
==6601== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)
syncop8lp7 xfsprogs # valgrind ./repair/xfs_repair /dev/sda5                    
==6700== Memcheck, a memory error detector
==6700== Copyright (C) 2002-2012, and GNU GPL'd, by Julian Seward et al.
==6700== Using Valgrind-3.8.1 and LibVEX; rerun with -h for copyright info
==6700== Command: ./repair/xfs_repair /dev/sda5
==6700== 
--6700-- WARNING: Serious error when reading debug info
--6700-- When reading debug info from /usr/lib64/valgrind/memcheck-ppc64-linux:
--6700-- Can't make sense of .eh_frame section mapping
--6700-- WARNING: unhandled syscall:  62
--6700-- You may be able to write your own handler.
--6700-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--6700-- Nevertheless we consider this a bug.  Please report
--6700-- it at http://valgrind.org/support/bug_reports.html.
--6700-- WARNING: unhandled syscall:  62
--6700-- You may be able to write your own handler.
--6700-- Read the file README_MISSING_SYSCALL_OR_IOCTL.
--6700-- Nevertheless we consider this a bug.  Please report
--6700-- it at http://valgrind.org/support/bug_reports.html.
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
data fork in regular inode 134685056 claims used block 8438113
correcting nextents for inode 134685056
bad data fork in inode 134685056
cleared inode 134685056
data fork in regular inode 134685057 claims used block 8438117
correcting nextents for inode 134685057
bad data fork in inode 134685057
cleared inode 134685057
data fork in regular inode 134685058 claims used block 8438120
correcting nextents for inode 134685058
bad data fork in inode 134685058
cleared inode 134685058
data fork in regular inode 134685059 claims used block 8438121
correcting nextents for inode 134685059
bad data fork in inode 134685059
cleared inode 134685059
data fork in regular inode 134685060 claims used block 8438124
correcting nextents for inode 134685060
bad data fork in inode 134685060
cleared inode 134685060
data fork in regular inode 134685061 claims used block 8438127
correcting nextents for inode 134685061
bad data fork in inode 134685061
cleared inode 134685061
data fork in regular inode 134685062 claims used block 8438131
correcting nextents for inode 134685062
bad data fork in inode 134685062
cleared inode 134685062
data fork in regular inode 134685063 claims used block 8438136
correcting nextents for inode 134685063
bad data fork in inode 134685063
cleared inode 134685063
data fork in regular inode 134685064 claims used block 8438140
correcting nextents for inode 134685064
bad data fork in inode 134685064
cleared inode 134685064
data fork in regular inode 134685065 claims used block 8438144
correcting nextents for inode 134685065
bad data fork in inode 134685065
cleared inode 134685065
data fork in regular inode 134685066 claims used block 8438147
correcting nextents for inode 134685066
bad data fork in inode 134685066
cleared inode 134685066
data fork in regular inode 134685067 claims used block 8438150
correcting nextents for inode 134685067
bad data fork in inode 134685067
cleared inode 134685067
data fork in regular inode 134685068 claims used block 8438154
correcting nextents for inode 134685068
bad data fork in inode 134685068
cleared inode 134685068
data fork in regular inode 134685069 claims used block 8438157
correcting nextents for inode 134685069
bad data fork in inode 134685069
cleared inode 134685069
data fork in regular inode 134685070 claims used block 8438161
correcting nextents for inode 134685070
bad data fork in inode 134685070
cleared inode 134685070
data fork in regular inode 134685071 claims used block 8438164
correcting nextents for inode 134685071
bad data fork in inode 134685071
cleared inode 134685071
bad . entry in directory inode 134754783, was 134779771: correcting
correcting nblocks for inode 135280001, was 3 - counted 17
correcting nblocks for inode 135280003, was 74 - counted 1
correcting nblocks for inode 135280005, was 49 - counted 2
correcting nblocks for inode 135280006, was 2 - counted 1
inode 135280007 - extent offset too large - start 8567439, count 69, offset 15534687187369984
correcting nextents for inode 135280007
bad data fork in inode 135280007
cleared inode 135280007
correcting nblocks for inode 135280008, was 8 - counted 1
correcting nblocks for inode 135280009, was 7 - counted 1
correcting nblocks for inode 135280010, was 12 - counted 1
correcting nblocks for inode 135280011, was 12 - counted 1
correcting nblocks for inode 135280014, was 19 - counted 1
correcting nblocks for inode 135280015, was 12 - counted 1
data fork in regular inode 137150480 claims used block 8577327
correcting nextents for inode 137150480
bad data fork in inode 137150480
cleared inode 137150480
data fork in regular inode 137150481 claims used block 8586960
correcting nextents for inode 137150481
bad data fork in inode 137150481
cleared inode 137150481
data fork in regular inode 137150482 claims used block 8586977
correcting nextents for inode 137150482
bad data fork in inode 137150482
cleared inode 137150482
data fork in regular inode 137150483 claims used block 8572108
cleared inode 137150489
data fork in regular inode 137150490 claims used block 8578429
correcting nextents for inode 137150490
bad data fork in inode 137150490
cleared inode 137150490
data fork in regular inode 137150491 claims used block 8578968
correcting nextents for inode 137150491
bad data fork in inode 137150491
cleared inode 137150491
data fork in regular inode 137150492 claims used block 8578969
correcting nextents for inode 137150492
bad data fork in inode 137150492
cleared inode 137150492
data fork in regular inode 137150493 claims used block 8578970
correcting nextents for inode 137150493
bad data fork in inode 137150493
cleared inode 137150493
data fork in regular inode 137150494 claims used block 8578971
correcting nextents for inode 137150494
bad data fork in inode 137150494
cleared inode 137150494
data fork in regular inode 137150495 claims used block 8578972
correcting nextents for inode 137150495
bad data fork in inode 137150495
cleared inode 137150495
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 3
        - agno = 0
        - agno = 2
entry "attr" at block 1 offset 3112 in directory inode 134320266 references free inode 137150480
        - agno = 1
        clearing inode number in entry at offset 3112...
entry "db_deadlock" at block 1 offset 3408 in directory inode 134320266 references free inode 137150481
        clearing inode number in entry at offset 3408...
data fork in ino 77579760 claims dup extent, off - 0, start - 8438113, cnt 4
entry "db_stat" at block 1 offset 3720 in directory inode 134320266 references free inode 137150482
        clearing inode number in entry at offset 3720...
entry "zipgrep" at block 8 offset 2224 in directory inode 134320266 references free inode 137150483
        clearing inode number in entry at offset 2224...
entry "gnome-font-viewer.mo" at block 0 offset 1024 in directory inode 134322940 references free inode 137150489
        clearing inode number in entry at offset 1024...
entry "gnome-font-viewer.mo" at block 1 offset 1272 in directory inode 134322941 references free inode 137150493
        clearing inode number in entry at offset 1272...
entry "gnome-font-viewer.mo" at block 1 offset 2304 in directory inode 134322942 references free inode 137150495
        clearing inode number in entry at offset 2304...
entry "libbonobo-2.0.mo" at block 0 offset 1024 in directory inode 134322950 references free inode 134685057
        clearing inode number in entry at offset 1024...
entry "libbonobo-2.0.mo" at block 0 offset 1016 in directory inode 134322951 references free inode 134685060
        clearing inode number in entry at offset 1016...
entry "libbonobo-2.0.mo" at block 0 offset 1496 in directory inode 134322952 references free inode 134685065
        clearing inode number in entry at offset 1496...
entry "libbonobo-2.0.mo" at block 0 offset 1472 in directory inode 134322953 references free inode 134685068
        clearing inode number in entry at offset 1472...
entry "libbonobo-2.0.mo" at block 0 offset 1640 in directory inode 134322954 references free inode 134685069
        clearing inode number in entry at offset 1640...
entry "libbonobo-2.0.mo" at block 0 offset 1304 in directory inode 134322955 references free inode 134685070
        clearing inode number in entry at offset 1304...
entry "libbonobo-2.0.mo" at block 0 offset 680 in directory inode 134322956 references free inode 134685071
        clearing inode number in entry at offset 680...
entry "gnome-font-viewer.mo" at block 0 offset 3168 in directory inode 134323184 references free inode 137150488
        clearing inode number in entry at offset 3168...
entry "gnome-font-viewer.mo" at block 0 offset 2928 in directory inode 134323192 references free inode 137150490
        clearing inode number in entry at offset 2928...
entry "gnome-font-viewer.mo" at block 0 offset 2488 in directory inode 134323198 references free inode 137150491
        clearing inode number in entry at offset 2488...
entry "gnome-font-viewer.mo" at block 0 offset 3048 in directory inode 134323200 references free inode 137150492
        clearing inode number in entry at offset 3048...
entry "gnome-font-viewer.mo" at block 0 offset 2200 in directory inode 134323204 references free inode 137150494
        clearing inode number in entry at offset 2200...
entry "libbonobo-2.0.mo" at block 0 offset 544 in directory inode 134323299 references free inode 134685056
        clearing inode number in entry at offset 544...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323305 references free inode 134685058
        clearing inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 144 in directory inode 134323311 references free inode 134685059
        clearing inode number in entry at offset 144...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323326 references free inode 134685061
        clearing inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 704 in directory inode 134323327 references free inode 134685062
        clearing inode number in entry at offset 704...
entry "libbonobo-2.0.mo" at block 0 offset 544 in directory inode 134323363 references free inode 134685063
        clearing inode number in entry at offset 544...
entry "libbonobo-2.0.mo" at block 0 offset 344 in directory inode 134323374 references free inode 134685064
        clearing inode number in entry at offset 344...
entry "libbonobo-2.0.mo" at block 0 offset 472 in directory inode 134323378 references free inode 134685066
        clearing inode number in entry at offset 472...
entry "libbonobo-2.0.mo" at block 0 offset 704 in directory inode 134323387 references free inode 134685067
        clearing inode number in entry at offset 704...
entry "unzip.1.gz" at block 9 offset 2136 in directory inode 134323469 references free inode 137150484
        clearing inode number in entry at offset 2136...
entry "unzipsfx.1.gz" at block 9 offset 2200 in directory inode 134323469 references free inode 137150485
        clearing inode number in entry at offset 2200...
entry "zipgrep.1.gz" at block 9 offset 2256 in directory inode 134323469 references free inode 137150486
        clearing inode number in entry at offset 2256...
data fork in ino 135280000 claims dup extent, off - 0, start - 8577327, cnt 17
correcting nextents for inode 135280000
bad data fork in inode 135280000
cleared inode 135280000
data fork in ino 135280001 claims dup extent, off - 0, start - 8586960, cnt 17
correcting nextents for inode 135280001
bad data fork in inode 135280001
cleared inode 135280001
data fork in ino 135280003 claims dup extent, off - 0, start - 8572108, cnt 1
correcting nextents for inode 135280003
bad data fork in inode 135280003
cleared inode 135280003
data fork in ino 135280004 claims dup extent, off - 0, start - 8572109, cnt 5
correcting nextents for inode 135280004
bad data fork in inode 135280004
cleared inode 135280004
data fork in ino 135280005 claims dup extent, off - 0, start - 8572114, cnt 2
correcting nextents for inode 135280005
bad data fork in inode 135280005
cleared inode 135280005
data fork in ino 135280006 claims dup extent, off - 0, start - 8572116, cnt 1
correcting nextents for inode 135280006
bad data fork in inode 135280006
cleared inode 135280006
data fork in ino 135280008 claims dup extent, off - 0, start - 8577514, cnt 1
correcting nextents for inode 135280008
bad data fork in inode 135280008
cleared inode 135280008
bad data fork in inode 135280010
cleared inode 135280010
data fork in ino 135280011 claims dup extent, off - 0, start - 8578968, cnt 1
correcting nextents for inode 135280011
bad data fork in inode 135280011
cleared inode 135280011
data fork in ino 135280012 claims dup extent, off - 0, start - 8578969, cnt 1
correcting nextents for inode 135280012
bad data fork in inode 135280012
cleared inode 135280012
data fork in ino 135280013 claims dup extent, off - 0, start - 8578970, cnt 1
correcting nextents for inode 135280013
bad data fork in inode 135280013
cleared inode 135280013
data fork in ino 135280014 claims dup extent, off - 0, start - 8578971, cnt 1
correcting nextents for inode 135280014
bad data fork in inode 135280014
cleared inode 135280014
data fork in ino 135280015 claims dup extent, off - 0, start - 8578972, cnt 1
correcting nextents for inode 135280015
bad data fork in inode 135280015
cleared inode 135280015
correcting nextents for inode 77579760
bad data fork in inode 77579760
cleared inode 77579760
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
entry "system.d" in shortform directory inode 67687581 points to free inode 135280000

entry "hwspinlock" in dir inode 70039312 inconsistent with .. value (70042219) in ino 134754783
rebuilding directory inode 70039312
entry "nf_conntrack_sip.ko" in directory inode 77579738 points to free inode 77579760
bad hash table for directory inode 77579738 (no data entry): rebuilding
rebuilding directory inode 77579738
rebuilding directory inode 134320266
bad hash table for directory inode 134322940 (no data entry): rebuilding
rebuilding directory inode 134322940
bad hash table for directory inode 134322941 (no data entry): rebuilding
rebuilding directory inode 134322941
bad hash table for directory inode 134322942 (no data entry): rebuilding
rebuilding directory inode 134322942
bad hash table for directory inode 134322950 (no data entry): rebuilding
rebuilding directory inode 134322950
bad hash table for directory inode 134322951 (no data entry): rebuilding
rebuilding directory inode 134322951
bad hash table for directory inode 134322952 (no data entry): rebuilding
rebuilding directory inode 134322952
bad hash table for directory inode 134322953 (no data entry): rebuilding
rebuilding directory inode 134322953
bad hash table for directory inode 134322954 (no data entry): rebuilding
rebuilding directory inode 134322954
bad hash table for directory inode 134322955 (no data entry): rebuilding
rebuilding directory inode 134322955
bad hash table for directory inode 134322956 (no data entry): rebuilding
rebuilding directory inode 134322956
bad hash table for directory inode 134323184 (no data entry): rebuilding
rebuilding directory inode 134323184
bad hash table for directory inode 134323192 (no data entry): rebuilding
rebuilding directory inode 134323192
bad hash table for directory inode 134323198 (no data entry): rebuilding
rebuilding directory inode 134323198
bad hash table for directory inode 134323200 (no data entry): rebuilding
rebuilding directory inode 134323200
bad hash table for directory inode 134323204 (no data entry): rebuilding
rebuilding directory inode 134323204
bad hash table for directory inode 134323299 (no data entry): rebuilding
rebuilding directory inode 134323299
bad hash table for directory inode 134323305 (no data entry): rebuilding
rebuilding directory inode 134323305
bad hash table for directory inode 134323311 (no data entry): rebuilding
rebuilding directory inode 134323311
bad hash table for directory inode 134323326 (no data entry): rebuilding
rebuilding directory inode 134323326
bad hash table for directory inode 134323327 (no data entry): rebuilding
rebuilding directory inode 134323327
bad hash table for directory inode 134323363 (no data entry): rebuilding
rebuilding directory inode 134323363
bad hash table for directory inode 134323374 (no data entry): rebuilding
rebuilding directory inode 134323374
bad hash table for directory inode 134323378 (no data entry): rebuilding
rebuilding directory inode 134323378
bad hash table for directory inode 134323387 (no data entry): rebuilding
rebuilding directory inode 134323387
rebuilding directory inode 134323469
entry "yum" in directory inode 135117175 points to free inode 135280004
bad hash table for directory inode 135117175 (no data entry): rebuilding
rebuilding directory inode 135117175
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 134555749, moving to lost+found
==6700== Invalid read of size 8
==6700==    at 0x1003DB10: libxfs_trans_commit (trans.c:743)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)
==6700==  Address 0x13cbf4b8 is 216 bytes inside a block of size 416 free'd
==6700==    at 0x4067C2C: free (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003C9EF: libxfs_iput (kmem.h:41)
==6700==    by 0x1003DB0B: libxfs_trans_commit (trans.c:740)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)
==6700== 
==6700== Invalid write of size 8
==6700==    at 0x1003DB38: libxfs_trans_commit (trans.c:747)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)
==6700==  Address 0x13cbf4b8 is 216 bytes inside a block of size 416 free'd
==6700==    at 0x4067C2C: free (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003C9EF: libxfs_iput (kmem.h:41)
==6700==    by 0x1003DB0B: libxfs_trans_commit (trans.c:740)
==6700==    by 0x10028F9B: mv_orphanage (phase6.c:1222)
==6700==    by 0x1002A627: phase6 (phase6.c:2970)
==6700==    by 0x1000490F: main (xfs_repair.c:779)
==6700== 
disconnected inode 134748865, moving to lost+found
disconnected inode 134748917, moving to lost+found
disconnected dir inode 134754783, moving to lost+found
disconnected inode 134765632, moving to lost+found
disconnected inode 134765633, moving to lost+found
disconnected inode 134765634, moving to lost+found
disconnected inode 134765636, moving to lost+found
disconnected inode 134765637, moving to lost+found
disconnected inode 135280016, moving to lost+found
disconnected inode 135280017, moving to lost+found
disconnected inode 135280018, moving to lost+found
disconnected inode 135280019, moving to lost+found
disconnected inode 135280020, moving to lost+found
disconnected inode 135280021, moving to lost+found
disconnected inode 135280022, moving to lost+found
disconnected inode 135280023, moving to lost+found
disconnected inode 135280024, moving to lost+found
disconnected inode 135280025, moving to lost+found
disconnected inode 135280026, moving to lost+found
disconnected inode 135280027, moving to lost+found
disconnected inode 135280028, moving to lost+found
disconnected inode 135280029, moving to lost+found
disconnected inode 135280030, moving to lost+found
disconnected inode 135280031, moving to lost+found
disconnected inode 135280032, moving to lost+found
disconnected inode 135280033, moving to lost+found
disconnected inode 135280034, moving to lost+found
disconnected inode 135280035, moving to lost+found
disconnected inode 135280036, moving to lost+found
disconnected inode 135280037, moving to lost+found
disconnected inode 135280038, moving to lost+found
disconnected inode 135280039, moving to lost+found
disconnected inode 135280040, moving to lost+found
disconnected inode 135280041, moving to lost+found
disconnected inode 135280042, moving to lost+found
disconnected inode 135280043, moving to lost+found
disconnected inode 135280044, moving to lost+found
disconnected inode 135280045, moving to lost+found
disconnected inode 135280046, moving to lost+found
disconnected inode 135280047, moving to lost+found
disconnected inode 135280048, moving to lost+found
disconnected inode 135280049, moving to lost+found
disconnected inode 135280050, moving to lost+found
disconnected inode 135280051, moving to lost+found
disconnected inode 135280052, moving to lost+found
disconnected inode 135280053, moving to lost+found
disconnected inode 135280054, moving to lost+found
disconnected inode 135280055, moving to lost+found
disconnected inode 135280056, moving to lost+found
disconnected inode 135280057, moving to lost+found
disconnected inode 135280058, moving to lost+found
disconnected inode 135280059, moving to lost+found
disconnected inode 135280060, moving to lost+found
disconnected inode 135280061, moving to lost+found
disconnected inode 135280062, moving to lost+found
disconnected inode 135280063, moving to lost+found
disconnected inode 135280064, moving to lost+found
disconnected inode 135280065, moving to lost+found
disconnected inode 135280066, moving to lost+found
disconnected inode 135280067, moving to lost+found
disconnected inode 135280257, moving to lost+found
disconnected inode 135280258, moving to lost+found
disconnected inode 135338277, moving to lost+found
disconnected inode 135338278, moving to lost+found
disconnected inode 135338284, moving to lost+found
disconnected inode 135338286, moving to lost+found
disconnected inode 135338287, moving to lost+found
disconnected inode 135338288, moving to lost+found
disconnected inode 135338289, moving to lost+found
disconnected inode 135338366, moving to lost+found
disconnected inode 135361331, moving to lost+found
disconnected inode 135418058, moving to lost+found
disconnected inode 135424793, moving to lost+found
disconnected inode 135424797, moving to lost+found
disconnected inode 135470020, moving to lost+found
disconnected inode 135470025, moving to lost+found
disconnected inode 135470033, moving to lost+found
disconnected inode 135470037, moving to lost+found
disconnected inode 135470050, moving to lost+found
disconnected inode 135495346, moving to lost+found
disconnected inode 135495495, moving to lost+found
disconnected inode 135495496, moving to lost+found
disconnected inode 135525755, moving to lost+found
disconnected inode 135525845, moving to lost+found
disconnected inode 135648551, moving to lost+found
disconnected inode 135648552, moving to lost+found
disconnected inode 135648553, moving to lost+found
disconnected inode 135648600, moving to lost+found
disconnected inode 135648676, moving to lost+found
disconnected inode 135648678, moving to lost+found
disconnected inode 135648679, moving to lost+found
disconnected inode 135653700, moving to lost+found
disconnected inode 135653716, moving to lost+found
disconnected inode 135701266, moving to lost+found
disconnected inode 135710889, moving to lost+found
disconnected inode 135711371, moving to lost+found
disconnected inode 135841274, moving to lost+found
disconnected inode 135841275, moving to lost+found
disconnected inode 136103192, moving to lost+found
disconnected inode 136250457, moving to lost+found
disconnected inode 136374233, moving to lost+found
disconnected inode 136413756, moving to lost+found
disconnected inode 137150557, moving to lost+found
disconnected inode 137160438, moving to lost+found
disconnected inode 137160523, moving to lost+found
disconnected inode 137167242, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 12878 nlinks from 69 to 70
==6700== Invalid read of size 8
==6700==    at 0x1003DB10: libxfs_trans_commit (trans.c:743)
==6700==    by 0x1002C0DF: phase7 (phase7.c:111)
==6700==    by 0x1000492F: main (xfs_repair.c:782)
==6700==  Address 0x13d50c38 is 216 bytes inside a block of size 416 free'd
==6700==    at 0x4067C2C: free (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003C9EF: libxfs_iput (kmem.h:41)
==6700==    by 0x1003DB0B: libxfs_trans_commit (trans.c:740)
==6700==    by 0x1002C0DF: phase7 (phase7.c:111)
==6700==    by 0x1000492F: main (xfs_repair.c:782)
==6700== 
==6700== Invalid write of size 8
==6700==    at 0x1003DB38: libxfs_trans_commit (trans.c:747)
==6700==    by 0x1002C0DF: phase7 (phase7.c:111)
==6700==    by 0x1000492F: main (xfs_repair.c:782)
==6700==  Address 0x13d50c38 is 216 bytes inside a block of size 416 free'd
==6700==    at 0x4067C2C: free (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003C9EF: libxfs_iput (kmem.h:41)
==6700==    by 0x1003DB0B: libxfs_trans_commit (trans.c:740)
==6700==    by 0x1002C0DF: phase7 (phase7.c:111)
==6700==    by 0x1000492F: main (xfs_repair.c:782)
==6700== 
resetting inode 67687581 nlinks from 4 to 3
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239040/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239060/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239098/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239090/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390a8/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390a0/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390d0/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x323b038/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3257670/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3259e68/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3298f38/0x1000
==6700== Syscall param pwrite64(buf) points to uninitialised byte(s)
==6700==    at 0x40F810C: pwrite64 (pwrite64.c:51)
==6700==    by 0x1003ABDB: __write_buf (rdwr.c:801)
==6700==    by 0x1003C1B7: libxfs_writebufr (rdwr.c:863)
==6700==    by 0x10036C4F: cache_flush (cache.c:600)
==6700==    by 0x1003C77B: libxfs_bcache_flush (rdwr.c:994)
==6700==    by 0x10004C6B: main (xfs_repair.c:886)
==6700==  Address 0xbeb0622 is 34 bytes inside a block of size 4,096 alloc'd
==6700==    at 0x406631C: memalign (in /usr/lib64/valgrind/vgpreload_memcheck-ppc64-linux.so)
==6700==    by 0x1003ADEF: __initbuf (rdwr.c:367)
==6700==    by 0x1003B797: libxfs_getbufr_map (rdwr.c:416)
==6700==    by 0x100365C3: cache_node_get (cache.c:273)
==6700==    by 0x1003A8DB: __cache_lookup (rdwr.c:519)
==6700==    by 0x1003BA6F: libxfs_getbuf_map (rdwr.c:601)
==6700==    by 0x1003D333: libxfs_trans_get_buf_map (trans.c:525)
==6700==    by 0x10059A3B: xfs_da_get_buf (xfs_da_btree.c:2580)
==6700==    by 0x10060E27: xfs_dir3_data_init (xfs_dir2_data.c:558)
==6700==    by 0x1006407F: xfs_dir2_leaf_addname (xfs_dir2_leaf.c:826)
==6700==    by 0x1005D59B: xfs_dir_createname (xfs_dir2.c:233)
==6700==    by 0x100290D3: mv_orphanage (phase6.c:1205)
==6700== 
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x1dff1d8/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32af510/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32c4748/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32d6708/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x322bfc8/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x322c070/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3259e68/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390a8/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x323b038/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239060/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390a0/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32af510/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239098/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239058/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x322c070/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3239040/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32c4748/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32d6708/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x32390d0/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x3257670/0x1000
Invalid inode number 0xfeffffffffffffff
xfs_dir_ino_validate: XFS_ERROR_REPORT
xfs_dir3_data_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x322bfc8/0x1000
xfs_dir3_block_write_verify: XFS_CORRUPTION_ERROR
libxfs_writebufr: write verifer failed on bno 0x1dff1d8/0x1000
==6700== Warning: noted but unhandled ioctl 0x20001261 with no size/direction hints
==6700==    This could cause spurious value errors to appear.
==6700==    See README_MISSING_SYSCALL_OR_IOCTL for guidance on writing a proper wrapper.
done
==6700== 
==6700== HEAP SUMMARY:
==6700==     in use at exit: 88,637,308 bytes in 55,170 blocks
==6700==   total heap usage: 1,491,690 allocs, 1,436,520 frees, 456,682,715 bytes allocated
==6700== 
==6700== LEAK SUMMARY:
==6700==    definitely lost: 5,120 bytes in 22 blocks
==6700==    indirectly lost: 108 bytes in 2 blocks
==6700==      possibly lost: 81,474,448 bytes in 38,930 blocks
==6700==    still reachable: 7,157,632 bytes in 16,216 blocks
==6700==         suppressed: 0 bytes in 0 blocks
==6700== Rerun with --leak-check=full to see details of leaked memory
==6700== 
==6700== For counts of detected and suppressed errors, rerun with: -v
==6700== Use --track-origins=yes to see where uninitialised values come from
==6700== ERROR SUMMARY: 502 errors from 5 contexts (suppressed: 0 from 0)

--------------060604090100000501030309
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------060604090100000501030309--
