Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B78F67F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 14:55:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5D7A3AC004
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 12:55:43 -0700 (PDT)
Received: from mail-ia0-f169.google.com (mail-ia0-f169.google.com
	[209.85.210.169]) by cuda.sgi.com with ESMTP id
	BdJ7axG8arnlO5e2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 12:55:40 -0700 (PDT)
Received: by mail-ia0-f169.google.com with SMTP id h23so1664008iae.0
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 12:55:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
Date: Fri, 12 Apr 2013 03:55:39 +0800
Message-ID: <CADFMGuJM2x-pBTV6TtwkLWv9LCAG661_BY40vq9Efwi=Yroggg@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9220937563619725870=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============9220937563619725870==
Content-Type: multipart/alternative; boundary=bcaec51d2998bc485b04da1b2bd0

--bcaec51d2998bc485b04da1b2bd0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

fs/xfs/xfs_vnodeops.c.  Return address =3D 0xffffffffa02ee20a
The return address always 0xffffffffa02ee20a?



2013/4/12 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> It happens tonight again on one of our servers, how to debug the root
> cause? Thank you.
>
> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp()
> returned error 22.
> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree returned
> error 22
> Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called
> from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =3D
> 0xffffffffa02ee20a
> Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting down
> filesystem
> Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem and
> rectify the problem(s)
> Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
> Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
> Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
> Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.
>
> xfs_repair -n
>
>
> Phase 7 - verify link counts...
> would have reset inode 20021 nlinks from 0 to 1
> would have reset inode 20789 nlinks from 0 to 1
> would have reset inode 35125 nlinks from 0 to 1
> would have reset inode 35637 nlinks from 0 to 1
> would have reset inode 36149 nlinks from 0 to 1
> would have reset inode 38197 nlinks from 0 to 1
> would have reset inode 39477 nlinks from 0 to 1
> would have reset inode 54069 nlinks from 0 to 1
> would have reset inode 62261 nlinks from 0 to 1
> would have reset inode 63029 nlinks from 0 to 1
> would have reset inode 72501 nlinks from 0 to 1
> would have reset inode 79925 nlinks from 0 to 1
> would have reset inode 81205 nlinks from 0 to 1
> would have reset inode 84789 nlinks from 0 to 1
> would have reset inode 87861 nlinks from 0 to 1
> would have reset inode 90663 nlinks from 0 to 1
> would have reset inode 91189 nlinks from 0 to 1
> would have reset inode 95541 nlinks from 0 to 1
> would have reset inode 98101 nlinks from 0 to 1
> would have reset inode 101173 nlinks from 0 to 1
> would have reset inode 113205 nlinks from 0 to 1
> would have reset inode 114741 nlinks from 0 to 1
> would have reset inode 126261 nlinks from 0 to 1
> would have reset inode 140597 nlinks from 0 to 1
> would have reset inode 144693 nlinks from 0 to 1
> would have reset inode 147765 nlinks from 0 to 1
> would have reset inode 152885 nlinks from 0 to 1
> would have reset inode 161333 nlinks from 0 to 1
> would have reset inode 161845 nlinks from 0 to 1
> would have reset inode 167477 nlinks from 0 to 1
> would have reset inode 172341 nlinks from 0 to 1
> would have reset inode 191797 nlinks from 0 to 1
> would have reset inode 204853 nlinks from 0 to 1
> would have reset inode 205365 nlinks from 0 to 1
> would have reset inode 215349 nlinks from 0 to 1
> would have reset inode 215861 nlinks from 0 to 1
> would have reset inode 216373 nlinks from 0 to 1
> would have reset inode 217397 nlinks from 0 to 1
> would have reset inode 224309 nlinks from 0 to 1
> would have reset inode 225589 nlinks from 0 to 1
> would have reset inode 234549 nlinks from 0 to 1
> would have reset inode 234805 nlinks from 0 to 1
> would have reset inode 249653 nlinks from 0 to 1
> would have reset inode 250677 nlinks from 0 to 1
> would have reset inode 252469 nlinks from 0 to 1
> would have reset inode 261429 nlinks from 0 to 1
> would have reset inode 265013 nlinks from 0 to 1
> would have reset inode 266805 nlinks from 0 to 1
> would have reset inode 267317 nlinks from 0 to 1
> would have reset inode 268853 nlinks from 0 to 1
> would have reset inode 272437 nlinks from 0 to 1
> would have reset inode 273205 nlinks from 0 to 1
> would have reset inode 274229 nlinks from 0 to 1
> would have reset inode 278325 nlinks from 0 to 1
> would have reset inode 278837 nlinks from 0 to 1
> would have reset inode 281397 nlinks from 0 to 1
> would have reset inode 292661 nlinks from 0 to 1
> would have reset inode 300853 nlinks from 0 to 1
> would have reset inode 302901 nlinks from 0 to 1
> would have reset inode 305205 nlinks from 0 to 1
> would have reset inode 314165 nlinks from 0 to 1
> would have reset inode 315189 nlinks from 0 to 1
> would have reset inode 320309 nlinks from 0 to 1
> would have reset inode 324917 nlinks from 0 to 1
> would have reset inode 328245 nlinks from 0 to 1
> would have reset inode 335925 nlinks from 0 to 1
> would have reset inode 339253 nlinks from 0 to 1
> would have reset inode 339765 nlinks from 0 to 1
> would have reset inode 348213 nlinks from 0 to 1
> would have reset inode 360501 nlinks from 0 to 1
> would have reset inode 362037 nlinks from 0 to 1
> would have reset inode 366389 nlinks from 0 to 1
> would have reset inode 385845 nlinks from 0 to 1
> would have reset inode 390709 nlinks from 0 to 1
> would have reset inode 409141 nlinks from 0 to 1
> would have reset inode 413237 nlinks from 0 to 1
> would have reset inode 414773 nlinks from 0 to 1
> would have reset inode 417845 nlinks from 0 to 1
> would have reset inode 436021 nlinks from 0 to 1
> would have reset inode 439349 nlinks from 0 to 1
> would have reset inode 447029 nlinks from 0 to 1
> would have reset inode 491317 nlinks from 0 to 1
> would have reset inode 494133 nlinks from 0 to 1
> would have reset inode 495413 nlinks from 0 to 1
> would have reset inode 501301 nlinks from 0 to 1
> would have reset inode 506421 nlinks from 0 to 1
> would have reset inode 508469 nlinks from 0 to 1
> would have reset inode 508981 nlinks from 0 to 1
> would have reset inode 511797 nlinks from 0 to 1
> would have reset inode 513077 nlinks from 0 to 1
> would have reset inode 517941 nlinks from 0 to 1
> would have reset inode 521013 nlinks from 0 to 1
> would have reset inode 522805 nlinks from 0 to 1
> would have reset inode 523317 nlinks from 0 to 1
> would have reset inode 525621 nlinks from 0 to 1
> would have reset inode 527925 nlinks from 0 to 1
> would have reset inode 535605 nlinks from 0 to 1
> would have reset inode 541749 nlinks from 0 to 1
> would have reset inode 573493 nlinks from 0 to 1
> would have reset inode 578613 nlinks from 0 to 1
> would have reset inode 583029 nlinks from 0 to 1
> would have reset inode 585525 nlinks from 0 to 1
> would have reset inode 586293 nlinks from 0 to 1
> would have reset inode 586805 nlinks from 0 to 1
> would have reset inode 591413 nlinks from 0 to 1
> would have reset inode 594485 nlinks from 0 to 1
> would have reset inode 596277 nlinks from 0 to 1
> would have reset inode 603189 nlinks from 0 to 1
> would have reset inode 613429 nlinks from 0 to 1
> would have reset inode 617781 nlinks from 0 to 1
> would have reset inode 621877 nlinks from 0 to 1
> would have reset inode 623925 nlinks from 0 to 1
> would have reset inode 625205 nlinks from 0 to 1
> would have reset inode 626741 nlinks from 0 to 1
> would have reset inode 639541 nlinks from 0 to 1
> would have reset inode 640053 nlinks from 0 to 1
> would have reset inode 640565 nlinks from 0 to 1
> would have reset inode 645173 nlinks from 0 to 1
> would have reset inode 652853 nlinks from 0 to 1
> would have reset inode 656181 nlinks from 0 to 1
> would have reset inode 659253 nlinks from 0 to 1
> would have reset inode 663605 nlinks from 0 to 1
> would have reset inode 667445 nlinks from 0 to 1
> would have reset inode 680757 nlinks from 0 to 1
> would have reset inode 691253 nlinks from 0 to 1
> would have reset inode 691765 nlinks from 0 to 1
> would have reset inode 697653 nlinks from 0 to 1
> would have reset inode 700469 nlinks from 0 to 1
> would have reset inode 707893 nlinks from 0 to 1
> would have reset inode 716853 nlinks from 0 to 1
> would have reset inode 722229 nlinks from 0 to 1
> would have reset inode 722741 nlinks from 0 to 1
> would have reset inode 723765 nlinks from 0 to 1
> would have reset inode 731957 nlinks from 0 to 1
> would have reset inode 742965 nlinks from 0 to 1
> would have reset inode 743477 nlinks from 0 to 1
> would have reset inode 745781 nlinks from 0 to 1
> would have reset inode 746293 nlinks from 0 to 1
> would have reset inode 774453 nlinks from 0 to 1
> would have reset inode 778805 nlinks from 0 to 1
> would have reset inode 785013 nlinks from 0 to 1
> would have reset inode 785973 nlinks from 0 to 1
> would have reset inode 791349 nlinks from 0 to 1
> would have reset inode 796981 nlinks from 0 to 1
> would have reset inode 803381 nlinks from 0 to 1
> would have reset inode 806965 nlinks from 0 to 1
> would have reset inode 811798 nlinks from 0 to 1
> would have reset inode 812310 nlinks from 0 to 1
> would have reset inode 813078 nlinks from 0 to 1
> would have reset inode 813607 nlinks from 0 to 1
> would have reset inode 814183 nlinks from 0 to 1
> would have reset inode 822069 nlinks from 0 to 1
> would have reset inode 828469 nlinks from 0 to 1
> would have reset inode 830005 nlinks from 0 to 1
> would have reset inode 832053 nlinks from 0 to 1
> would have reset inode 832565 nlinks from 0 to 1
> would have reset inode 836661 nlinks from 0 to 1
> would have reset inode 841013 nlinks from 0 to 1
> would have reset inode 841525 nlinks from 0 to 1
> would have reset inode 845365 nlinks from 0 to 1
> would have reset inode 846133 nlinks from 0 to 1
> would have reset inode 847157 nlinks from 0 to 1
> would have reset inode 852533 nlinks from 0 to 1
> would have reset inode 857141 nlinks from 0 to 1
> would have reset inode 863271 nlinks from 0 to 1
> would have reset inode 866855 nlinks from 0 to 1
> would have reset inode 887861 nlinks from 0 to 1
> would have reset inode 891701 nlinks from 0 to 1
> would have reset inode 894773 nlinks from 0 to 1
> would have reset inode 900149 nlinks from 0 to 1
> would have reset inode 902197 nlinks from 0 to 1
> would have reset inode 906293 nlinks from 0 to 1
> would have reset inode 906805 nlinks from 0 to 1
> would have reset inode 909877 nlinks from 0 to 1
> would have reset inode 925493 nlinks from 0 to 1
> would have reset inode 949543 nlinks from 0 to 1
> would have reset inode 955175 nlinks from 0 to 1
> would have reset inode 963623 nlinks from 0 to 1
> would have reset inode 967733 nlinks from 0 to 1
> would have reset inode 968231 nlinks from 0 to 1
> would have reset inode 982069 nlinks from 0 to 1
> would have reset inode 1007413 nlinks from 0 to 1
> would have reset inode 1011509 nlinks from 0 to 1
> would have reset inode 1014069 nlinks from 0 to 1
> would have reset inode 1014581 nlinks from 0 to 1
> would have reset inode 1022005 nlinks from 0 to 1
> would have reset inode 1022517 nlinks from 0 to 1
> would have reset inode 1023029 nlinks from 0 to 1
> would have reset inode 1025333 nlinks from 0 to 1
> would have reset inode 1043765 nlinks from 0 to 1
> would have reset inode 1044789 nlinks from 0 to 1
> would have reset inode 1049397 nlinks from 0 to 1
> would have reset inode 1050933 nlinks from 0 to 1
> would have reset inode 1051445 nlinks from 0 to 1
> would have reset inode 1054261 nlinks from 0 to 1
> would have reset inode 1060917 nlinks from 0 to 1
> would have reset inode 1063477 nlinks from 0 to 1
> would have reset inode 1076021 nlinks from 0 to 1
> would have reset inode 1081141 nlinks from 0 to 1
> would have reset inode 1086261 nlinks from 0 to 1
> would have reset inode 1097269 nlinks from 0 to 1
> would have reset inode 1099829 nlinks from 0 to 1
> would have reset inode 1100853 nlinks from 0 to 1
> would have reset inode 1101877 nlinks from 0 to 1
> would have reset inode 1126709 nlinks from 0 to 1
> would have reset inode 1134389 nlinks from 0 to 1
> would have reset inode 1141045 nlinks from 0 to 1
> would have reset inode 1141557 nlinks from 0 to 1
> would have reset inode 1142581 nlinks from 0 to 1
> would have reset inode 1148469 nlinks from 0 to 1
> would have reset inode 1153333 nlinks from 0 to 1
> would have reset inode 1181749 nlinks from 0 to 1
> would have reset inode 1192245 nlinks from 0 to 1
> would have reset inode 1198133 nlinks from 0 to 1
> would have reset inode 1203765 nlinks from 0 to 1
> would have reset inode 1221429 nlinks from 0 to 1
> would have reset inode 1223989 nlinks from 0 to 1
> would have reset inode 1235509 nlinks from 0 to 1
> would have reset inode 1239349 nlinks from 0 to 1
> would have reset inode 1240885 nlinks from 0 to 1
> would have reset inode 1241397 nlinks from 0 to 1
> would have reset inode 1241909 nlinks from 0 to 1
> would have reset inode 1242421 nlinks from 0 to 1
> would have reset inode 1244981 nlinks from 0 to 1
> would have reset inode 1246517 nlinks from 0 to 1
> would have reset inode 1253429 nlinks from 0 to 1
> would have reset inode 1271861 nlinks from 0 to 1
> would have reset inode 1274677 nlinks from 0 to 1
> would have reset inode 1277749 nlinks from 0 to 1
> would have reset inode 1278773 nlinks from 0 to 1
> would have reset inode 1286709 nlinks from 0 to 1
> would have reset inode 1288245 nlinks from 0 to 1
> would have reset inode 1299765 nlinks from 0 to 1
> would have reset inode 1302325 nlinks from 0 to 1
> would have reset inode 1304885 nlinks from 0 to 1
> would have reset inode 1305397 nlinks from 0 to 1
> would have reset inode 1307509 nlinks from 0 to 1
> would have reset inode 1309493 nlinks from 0 to 1
> would have reset inode 1310517 nlinks from 0 to 1
> would have reset inode 1311029 nlinks from 0 to 1
> would have reset inode 1312053 nlinks from 0 to 1
> would have reset inode 1316917 nlinks from 0 to 1
> would have reset inode 1317941 nlinks from 0 to 1
> would have reset inode 1320821 nlinks from 0 to 1
> would have reset inode 1322805 nlinks from 0 to 1
> would have reset inode 1332789 nlinks from 0 to 1
> would have reset inode 1336373 nlinks from 0 to 1
> would have reset inode 1345653 nlinks from 0 to 1
> would have reset inode 1354549 nlinks from 0 to 1
> would have reset inode 1361973 nlinks from 0 to 1
> would have reset inode 1369909 nlinks from 0 to 1
> would have reset inode 1372981 nlinks from 0 to 1
> would have reset inode 1388853 nlinks from 0 to 1
> would have reset inode 1402933 nlinks from 0 to 1
> would have reset inode 1403445 nlinks from 0 to 1
> would have reset inode 1420085 nlinks from 0 to 1
> would have reset inode 1452853 nlinks from 0 to 1
> would have reset inode 1456437 nlinks from 0 to 1
> would have reset inode 1457973 nlinks from 0 to 1
> would have reset inode 1459253 nlinks from 0 to 1
> would have reset inode 1467957 nlinks from 0 to 1
> would have reset inode 1471541 nlinks from 0 to 1
> would have reset inode 1476661 nlinks from 0 to 1
> would have reset inode 1479733 nlinks from 0 to 1
> would have reset inode 1483061 nlinks from 0 to 1
> would have reset inode 1484085 nlinks from 0 to 1
> would have reset inode 1486133 nlinks from 0 to 1
> would have reset inode 1489461 nlinks from 0 to 1
> would have reset inode 1490037 nlinks from 0 to 1
> would have reset inode 1492021 nlinks from 0 to 1
> would have reset inode 1493557 nlinks from 0 to 1
> would have reset inode 1494069 nlinks from 0 to 1
> would have reset inode 1496885 nlinks from 0 to 1
> would have reset inode 1498421 nlinks from 0 to 1
> would have reset inode 1498933 nlinks from 0 to 1
> would have reset inode 1499957 nlinks from 0 to 1
> would have reset inode 1506101 nlinks from 0 to 1
> would have reset inode 1507637 nlinks from 0 to 1
> would have reset inode 1510453 nlinks from 0 to 1
> would have reset inode 1514293 nlinks from 0 to 1
> would have reset inode 1517365 nlinks from 0 to 1
> would have reset inode 1520693 nlinks from 0 to 1
> would have reset inode 1521973 nlinks from 0 to 1
> would have reset inode 1530421 nlinks from 0 to 1
> would have reset inode 1530933 nlinks from 0 to 1
> would have reset inode 1537333 nlinks from 0 to 1
> would have reset inode 1538357 nlinks from 0 to 1
> would have reset inode 1548853 nlinks from 0 to 1
> would have reset inode 1553973 nlinks from 0 to 1
> would have reset inode 1557301 nlinks from 0 to 1
> would have reset inode 1564213 nlinks from 0 to 1
> would have reset inode 1564725 nlinks from 0 to 1
> would have reset inode 1576501 nlinks from 0 to 1
> would have reset inode 1580597 nlinks from 0 to 1
> would have reset inode 1584693 nlinks from 0 to 1
> would have reset inode 1586485 nlinks from 0 to 1
> would have reset inode 1589301 nlinks from 0 to 1
> would have reset inode 1589813 nlinks from 0 to 1
> would have reset inode 1592629 nlinks from 0 to 1
> would have reset inode 1595701 nlinks from 0 to 1
> would have reset inode 1601077 nlinks from 0 to 1
> would have reset inode 1623861 nlinks from 0 to 1
> would have reset inode 1626677 nlinks from 0 to 1
> would have reset inode 1627701 nlinks from 0 to 1
> would have reset inode 1633333 nlinks from 0 to 1
> would have reset inode 1639221 nlinks from 0 to 1
> would have reset inode 1649205 nlinks from 0 to 1
> would have reset inode 1686325 nlinks from 0 to 1
> would have reset inode 1690677 nlinks from 0 to 1
> would have reset inode 1693749 nlinks from 0 to 1
> would have reset inode 1704757 nlinks from 0 to 1
> would have reset inode 1707061 nlinks from 0 to 1
> would have reset inode 1709109 nlinks from 0 to 1
> would have reset inode 1719349 nlinks from 0 to 1
> would have reset inode 1737013 nlinks from 0 to 1
> would have reset inode 1741365 nlinks from 0 to 1
> would have reset inode 1747509 nlinks from 0 to 1
> would have reset inode 1770805 nlinks from 0 to 1
> would have reset inode 1780789 nlinks from 0 to 1
> would have reset inode 1793589 nlinks from 0 to 1
> would have reset inode 1795125 nlinks from 0 to 1
> would have reset inode 1800757 nlinks from 0 to 1
> would have reset inode 1801269 nlinks from 0 to 1
> would have reset inode 1802549 nlinks from 0 to 1
> would have reset inode 1804085 nlinks from 0 to 1
> would have reset inode 1817141 nlinks from 0 to 1
> would have reset inode 1821749 nlinks from 0 to 1
> would have reset inode 1832757 nlinks from 0 to 1
> would have reset inode 1836341 nlinks from 0 to 1
> would have reset inode 1856309 nlinks from 0 to 1
> would have reset inode 1900597 nlinks from 0 to 1
> would have reset inode 1902901 nlinks from 0 to 1
> would have reset inode 1912373 nlinks from 0 to 1
> would have reset inode 1943093 nlinks from 0 to 1
> would have reset inode 1944373 nlinks from 0 to 1
> would have reset inode 1954101 nlinks from 0 to 1
> would have reset inode 1955893 nlinks from 0 to 1
> would have reset inode 1961781 nlinks from 0 to 1
> would have reset inode 1974325 nlinks from 0 to 1
> would have reset inode 1978677 nlinks from 0 to 1
> would have reset inode 1981237 nlinks from 0 to 1
> would have reset inode 1992245 nlinks from 0 to 1
> would have reset inode 2000949 nlinks from 0 to 1
> would have reset inode 2002229 nlinks from 0 to 1
> would have reset inode 2004789 nlinks from 0 to 1
> would have reset inode 2005301 nlinks from 0 to 1
> would have reset inode 2011189 nlinks from 0 to 1
> would have reset inode 2012981 nlinks from 0 to 1
> would have reset inode 2015285 nlinks from 0 to 1
> would have reset inode 2018869 nlinks from 0 to 1
> would have reset inode 2028341 nlinks from 0 to 1
> would have reset inode 2028853 nlinks from 0 to 1
> would have reset inode 2030901 nlinks from 0 to 1
> would have reset inode 2032181 nlinks from 0 to 1
> would have reset inode 2032693 nlinks from 0 to 1
> would have reset inode 2040117 nlinks from 0 to 1
> would have reset inode 2053685 nlinks from 0 to 1
> would have reset inode 2083893 nlinks from 0 to 1
> would have reset inode 2087221 nlinks from 0 to 1
> would have reset inode 2095925 nlinks from 0 to 1
> would have reset inode 2098741 nlinks from 0 to 1
> would have reset inode 2100533 nlinks from 0 to 1
> would have reset inode 2101301 nlinks from 0 to 1
> would have reset inode 2123573 nlinks from 0 to 1
> would have reset inode 2132789 nlinks from 0 to 1
> would have reset inode 2133813 nlinks from 0 to 1
>
>
>
>
>
> 2013/4/10 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>
>
>> The storage info is as following:
>> RAID-6
>> SATA HDD
>> Controller: PERC H710P Mini (Embedded)
>> Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes
>> 255 heads, 63 sectors/track, 3647334 cylinders
>> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>>
>> sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (30.0 TB/27.2 TiB=
)
>> sd 0:2:1:0: [sdb] Write Protect is off
>> sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
>> sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
>> support DPO or FUA
>> sd 0:2:1:0: [sdb] Attached SCSI disk
>>
>> *-storage
>>        description: RAID bus controller
>>        product: MegaRAID SAS 2208 [Thunderbolt]
>>        vendor: LSI Logic / Symbios Logic
>>        physical id: 0
>>        bus info: pci@0000:02:00.0
>>        logical name: scsi0
>>        version: 01
>>        width: 64 bits
>>         clock: 33MHz
>>        capabilities: storage pm pciexpress vpd msi msix bus_master
>> cap_list rom
>>        configuration: driver=3Dmegaraid_sas latency=3D0
>>        resources: irq:42 ioport:fc00(size=3D256) memory:dd7fc000-dd7ffff=
f
>> memory:dd780000-dd7bffff memory:dc800000-dc81ffff(prefetchable)
>>      *-disk:0
>>           description: SCSI Disk
>>           product: PERC H710P
>>           vendor: DELL
>>           physical id: 2.0.0
>>           bus info: scsi@0:2.0.0
>>           logical name: /dev/sda
>>           version: 3.13
>>           serial: 0049d6ce1d9f2035180096fde490f648
>>           size: 558GiB (599GB)
>>           capabilities: partitioned partitioned:dos
>>           configuration: ansiversion=3D5 signature=3D000aa336
>>      *-disk:1
>>           description: SCSI Disk
>>           product: PERC H710P
>>           vendor: DELL
>>           physical id: 2.1.0
>>           bus info: scsi@0:2.1.0
>>           logical name: /dev/sdb
>>           logical name: /mnt/xfsd
>>           version: 3.13
>>           serial: 003366f71da22035180096fde490f648
>>           size: 27TiB (30TB)
>>           configuration: ansiversion=3D5 mount.fstype=3Dxfs
>> mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,sw=
idth=3D1280,noquota
>> state=3Dmounted
>>
>> Thank you.
>>
>>
>> 2013/4/10 Emmanuel Florac <eflorac@intellique.com>
>>
>>> Le Tue, 9 Apr 2013 23:10:03 +0800
>>> =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com> =A8=A6crivait:
>>>
>>> > > Apr  9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected.
>>> > > Shutting down filesystem
>>>
>>> This. I/O error detected. That means that at some point the underlying
>>> device (disk, RAID array, SAN volume) couldn't be reached. So this
>>> could very well be a case of a flakey drive, array, cable or SCSI
>>> driver.
>>>
>>> What's the storage setup here?
>>>
>>> --
>>> -----------------------------------------------------------------------=
-
>>> Emmanuel Florac     |   Direction technique
>>>                     |   Intellique
>>>                     |   <eflorac@intellique.com>
>>>                     |   +33 1 78 94 84 02
>>> -----------------------------------------------------------------------=
-
>>>
>>
>>
>>
>> --
>> =B7=FB=D3=C0=CC=CE
>>
>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--bcaec51d2998bc485b04da1b2bd0
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>fs/xfs/xfs_vnodeops.c.&nbsp; Return address =3D =
0xffffffffa02ee20a<br></div>The return address always 0xffffffffa02ee20a?<b=
r><br></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_qu=
ote">2013/4/12 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=3D"mailto:y=
ongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&gt;</span><br=
>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>It happens tonight aga=
in on one of our servers, how to debug the root cause? Thank you.<br><br>Ap=
r 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove: xfs_inotobp() ret=
urned error 22.<br>
Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree returned er=
ror 22<br>
Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1) called f=
rom line 1184 of file fs/xfs/xfs_vnodeops.c.&nbsp; Return address =3D 0xfff=
fffffa02ee20a<br>Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected=
. Shutting down filesystem<br>

Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem and re=
ctify the problem(s)<br>Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_for=
ce: error 5 returned.<br>Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_fo=
rce: error 5 returned.<br>

Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.<br=
>Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned.<b=
r><br></div>xfs_repair -n<br><br><br>Phase 7 - verify link counts...<br>

would have reset inode 20021 nlinks from 0 to 1<br>would have reset inode 2=
0789 nlinks from 0 to 1<br>would have reset inode 35125 nlinks from 0 to 1<=
br>would have reset inode 35637 nlinks from 0 to 1<br>would have reset inod=
e 36149 nlinks from 0 to 1<br>

would have reset inode 38197 nlinks from 0 to 1<br>would have reset inode 3=
9477 nlinks from 0 to 1<br>would have reset inode 54069 nlinks from 0 to 1<=
br>would have reset inode 62261 nlinks from 0 to 1<br>would have reset inod=
e 63029 nlinks from 0 to 1<br>

would have reset inode 72501 nlinks from 0 to 1<br>would have reset inode 7=
9925 nlinks from 0 to 1<br>would have reset inode 81205 nlinks from 0 to 1<=
br>would have reset inode 84789 nlinks from 0 to 1<br>would have reset inod=
e 87861 nlinks from 0 to 1<br>

would have reset inode 90663 nlinks from 0 to 1<br>would have reset inode 9=
1189 nlinks from 0 to 1<br>would have reset inode 95541 nlinks from 0 to 1<=
br>would have reset inode 98101 nlinks from 0 to 1<br>would have reset inod=
e 101173 nlinks from 0 to 1<br>

would have reset inode 113205 nlinks from 0 to 1<br>would have reset inode =
114741 nlinks from 0 to 1<br>would have reset inode 126261 nlinks from 0 to=
 1<br>would have reset inode 140597 nlinks from 0 to 1<br>would have reset =
inode 144693 nlinks from 0 to 1<br>

would have reset inode 147765 nlinks from 0 to 1<br>would have reset inode =
152885 nlinks from 0 to 1<br>would have reset inode 161333 nlinks from 0 to=
 1<br>would have reset inode 161845 nlinks from 0 to 1<br>would have reset =
inode 167477 nlinks from 0 to 1<br>

would have reset inode 172341 nlinks from 0 to 1<br>would have reset inode =
191797 nlinks from 0 to 1<br>would have reset inode 204853 nlinks from 0 to=
 1<br>would have reset inode 205365 nlinks from 0 to 1<br>would have reset =
inode 215349 nlinks from 0 to 1<br>

would have reset inode 215861 nlinks from 0 to 1<br>would have reset inode =
216373 nlinks from 0 to 1<br>would have reset inode 217397 nlinks from 0 to=
 1<br>would have reset inode 224309 nlinks from 0 to 1<br>would have reset =
inode 225589 nlinks from 0 to 1<br>

would have reset inode 234549 nlinks from 0 to 1<br>would have reset inode =
234805 nlinks from 0 to 1<br>would have reset inode 249653 nlinks from 0 to=
 1<br>would have reset inode 250677 nlinks from 0 to 1<br>would have reset =
inode 252469 nlinks from 0 to 1<br>

would have reset inode 261429 nlinks from 0 to 1<br>would have reset inode =
265013 nlinks from 0 to 1<br>would have reset inode 266805 nlinks from 0 to=
 1<br>would have reset inode 267317 nlinks from 0 to 1<br>would have reset =
inode 268853 nlinks from 0 to 1<br>

would have reset inode 272437 nlinks from 0 to 1<br>would have reset inode =
273205 nlinks from 0 to 1<br>would have reset inode 274229 nlinks from 0 to=
 1<br>would have reset inode 278325 nlinks from 0 to 1<br>would have reset =
inode 278837 nlinks from 0 to 1<br>

would have reset inode 281397 nlinks from 0 to 1<br>would have reset inode =
292661 nlinks from 0 to 1<br>would have reset inode 300853 nlinks from 0 to=
 1<br>would have reset inode 302901 nlinks from 0 to 1<br>would have reset =
inode 305205 nlinks from 0 to 1<br>

would have reset inode 314165 nlinks from 0 to 1<br>would have reset inode =
315189 nlinks from 0 to 1<br>would have reset inode 320309 nlinks from 0 to=
 1<br>would have reset inode 324917 nlinks from 0 to 1<br>would have reset =
inode 328245 nlinks from 0 to 1<br>

would have reset inode 335925 nlinks from 0 to 1<br>would have reset inode =
339253 nlinks from 0 to 1<br>would have reset inode 339765 nlinks from 0 to=
 1<br>would have reset inode 348213 nlinks from 0 to 1<br>would have reset =
inode 360501 nlinks from 0 to 1<br>

would have reset inode 362037 nlinks from 0 to 1<br>would have reset inode =
366389 nlinks from 0 to 1<br>would have reset inode 385845 nlinks from 0 to=
 1<br>would have reset inode 390709 nlinks from 0 to 1<br>would have reset =
inode 409141 nlinks from 0 to 1<br>

would have reset inode 413237 nlinks from 0 to 1<br>would have reset inode =
414773 nlinks from 0 to 1<br>would have reset inode 417845 nlinks from 0 to=
 1<br>would have reset inode 436021 nlinks from 0 to 1<br>would have reset =
inode 439349 nlinks from 0 to 1<br>

would have reset inode 447029 nlinks from 0 to 1<br>would have reset inode =
491317 nlinks from 0 to 1<br>would have reset inode 494133 nlinks from 0 to=
 1<br>would have reset inode 495413 nlinks from 0 to 1<br>would have reset =
inode 501301 nlinks from 0 to 1<br>

would have reset inode 506421 nlinks from 0 to 1<br>would have reset inode =
508469 nlinks from 0 to 1<br>would have reset inode 508981 nlinks from 0 to=
 1<br>would have reset inode 511797 nlinks from 0 to 1<br>would have reset =
inode 513077 nlinks from 0 to 1<br>

would have reset inode 517941 nlinks from 0 to 1<br>would have reset inode =
521013 nlinks from 0 to 1<br>would have reset inode 522805 nlinks from 0 to=
 1<br>would have reset inode 523317 nlinks from 0 to 1<br>would have reset =
inode 525621 nlinks from 0 to 1<br>

would have reset inode 527925 nlinks from 0 to 1<br>would have reset inode =
535605 nlinks from 0 to 1<br>would have reset inode 541749 nlinks from 0 to=
 1<br>would have reset inode 573493 nlinks from 0 to 1<br>would have reset =
inode 578613 nlinks from 0 to 1<br>

would have reset inode 583029 nlinks from 0 to 1<br>would have reset inode =
585525 nlinks from 0 to 1<br>would have reset inode 586293 nlinks from 0 to=
 1<br>would have reset inode 586805 nlinks from 0 to 1<br>would have reset =
inode 591413 nlinks from 0 to 1<br>

would have reset inode 594485 nlinks from 0 to 1<br>would have reset inode =
596277 nlinks from 0 to 1<br>would have reset inode 603189 nlinks from 0 to=
 1<br>would have reset inode 613429 nlinks from 0 to 1<br>would have reset =
inode 617781 nlinks from 0 to 1<br>

would have reset inode 621877 nlinks from 0 to 1<br>would have reset inode =
623925 nlinks from 0 to 1<br>would have reset inode 625205 nlinks from 0 to=
 1<br>would have reset inode 626741 nlinks from 0 to 1<br>would have reset =
inode 639541 nlinks from 0 to 1<br>

would have reset inode 640053 nlinks from 0 to 1<br>would have reset inode =
640565 nlinks from 0 to 1<br>would have reset inode 645173 nlinks from 0 to=
 1<br>would have reset inode 652853 nlinks from 0 to 1<br>would have reset =
inode 656181 nlinks from 0 to 1<br>

would have reset inode 659253 nlinks from 0 to 1<br>would have reset inode =
663605 nlinks from 0 to 1<br>would have reset inode 667445 nlinks from 0 to=
 1<br>would have reset inode 680757 nlinks from 0 to 1<br>would have reset =
inode 691253 nlinks from 0 to 1<br>

would have reset inode 691765 nlinks from 0 to 1<br>would have reset inode =
697653 nlinks from 0 to 1<br>would have reset inode 700469 nlinks from 0 to=
 1<br>would have reset inode 707893 nlinks from 0 to 1<br>would have reset =
inode 716853 nlinks from 0 to 1<br>

would have reset inode 722229 nlinks from 0 to 1<br>would have reset inode =
722741 nlinks from 0 to 1<br>would have reset inode 723765 nlinks from 0 to=
 1<br>would have reset inode 731957 nlinks from 0 to 1<br>would have reset =
inode 742965 nlinks from 0 to 1<br>

would have reset inode 743477 nlinks from 0 to 1<br>would have reset inode =
745781 nlinks from 0 to 1<br>would have reset inode 746293 nlinks from 0 to=
 1<br>would have reset inode 774453 nlinks from 0 to 1<br>would have reset =
inode 778805 nlinks from 0 to 1<br>

would have reset inode 785013 nlinks from 0 to 1<br>would have reset inode =
785973 nlinks from 0 to 1<br>would have reset inode 791349 nlinks from 0 to=
 1<br>would have reset inode 796981 nlinks from 0 to 1<br>would have reset =
inode 803381 nlinks from 0 to 1<br>

would have reset inode 806965 nlinks from 0 to 1<br>would have reset inode =
811798 nlinks from 0 to 1<br>would have reset inode 812310 nlinks from 0 to=
 1<br>would have reset inode 813078 nlinks from 0 to 1<br>would have reset =
inode 813607 nlinks from 0 to 1<br>

would have reset inode 814183 nlinks from 0 to 1<br>would have reset inode =
822069 nlinks from 0 to 1<br>would have reset inode 828469 nlinks from 0 to=
 1<br>would have reset inode 830005 nlinks from 0 to 1<br>would have reset =
inode 832053 nlinks from 0 to 1<br>

would have reset inode 832565 nlinks from 0 to 1<br>would have reset inode =
836661 nlinks from 0 to 1<br>would have reset inode 841013 nlinks from 0 to=
 1<br>would have reset inode 841525 nlinks from 0 to 1<br>would have reset =
inode 845365 nlinks from 0 to 1<br>

would have reset inode 846133 nlinks from 0 to 1<br>would have reset inode =
847157 nlinks from 0 to 1<br>would have reset inode 852533 nlinks from 0 to=
 1<br>would have reset inode 857141 nlinks from 0 to 1<br>would have reset =
inode 863271 nlinks from 0 to 1<br>

would have reset inode 866855 nlinks from 0 to 1<br>would have reset inode =
887861 nlinks from 0 to 1<br>would have reset inode 891701 nlinks from 0 to=
 1<br>would have reset inode 894773 nlinks from 0 to 1<br>would have reset =
inode 900149 nlinks from 0 to 1<br>

would have reset inode 902197 nlinks from 0 to 1<br>would have reset inode =
906293 nlinks from 0 to 1<br>would have reset inode 906805 nlinks from 0 to=
 1<br>would have reset inode 909877 nlinks from 0 to 1<br>would have reset =
inode 925493 nlinks from 0 to 1<br>

would have reset inode 949543 nlinks from 0 to 1<br>would have reset inode =
955175 nlinks from 0 to 1<br>would have reset inode 963623 nlinks from 0 to=
 1<br>would have reset inode 967733 nlinks from 0 to 1<br>would have reset =
inode 968231 nlinks from 0 to 1<br>

would have reset inode 982069 nlinks from 0 to 1<br>would have reset inode =
1007413 nlinks from 0 to 1<br>would have reset inode 1011509 nlinks from 0 =
to 1<br>would have reset inode 1014069 nlinks from 0 to 1<br>would have res=
et inode 1014581 nlinks from 0 to 1<br>

would have reset inode 1022005 nlinks from 0 to 1<br>would have reset inode=
 1022517 nlinks from 0 to 1<br>would have reset inode 1023029 nlinks from 0=
 to 1<br>would have reset inode 1025333 nlinks from 0 to 1<br>would have re=
set inode 1043765 nlinks from 0 to 1<br>

would have reset inode 1044789 nlinks from 0 to 1<br>would have reset inode=
 1049397 nlinks from 0 to 1<br>would have reset inode 1050933 nlinks from 0=
 to 1<br>would have reset inode 1051445 nlinks from 0 to 1<br>would have re=
set inode 1054261 nlinks from 0 to 1<br>

would have reset inode 1060917 nlinks from 0 to 1<br>would have reset inode=
 1063477 nlinks from 0 to 1<br>would have reset inode 1076021 nlinks from 0=
 to 1<br>would have reset inode 1081141 nlinks from 0 to 1<br>would have re=
set inode 1086261 nlinks from 0 to 1<br>

would have reset inode 1097269 nlinks from 0 to 1<br>would have reset inode=
 1099829 nlinks from 0 to 1<br>would have reset inode 1100853 nlinks from 0=
 to 1<br>would have reset inode 1101877 nlinks from 0 to 1<br>would have re=
set inode 1126709 nlinks from 0 to 1<br>

would have reset inode 1134389 nlinks from 0 to 1<br>would have reset inode=
 1141045 nlinks from 0 to 1<br>would have reset inode 1141557 nlinks from 0=
 to 1<br>would have reset inode 1142581 nlinks from 0 to 1<br>would have re=
set inode 1148469 nlinks from 0 to 1<br>

would have reset inode 1153333 nlinks from 0 to 1<br>would have reset inode=
 1181749 nlinks from 0 to 1<br>would have reset inode 1192245 nlinks from 0=
 to 1<br>would have reset inode 1198133 nlinks from 0 to 1<br>would have re=
set inode 1203765 nlinks from 0 to 1<br>

would have reset inode 1221429 nlinks from 0 to 1<br>would have reset inode=
 1223989 nlinks from 0 to 1<br>would have reset inode 1235509 nlinks from 0=
 to 1<br>would have reset inode 1239349 nlinks from 0 to 1<br>would have re=
set inode 1240885 nlinks from 0 to 1<br>

would have reset inode 1241397 nlinks from 0 to 1<br>would have reset inode=
 1241909 nlinks from 0 to 1<br>would have reset inode 1242421 nlinks from 0=
 to 1<br>would have reset inode 1244981 nlinks from 0 to 1<br>would have re=
set inode 1246517 nlinks from 0 to 1<br>

would have reset inode 1253429 nlinks from 0 to 1<br>would have reset inode=
 1271861 nlinks from 0 to 1<br>would have reset inode 1274677 nlinks from 0=
 to 1<br>would have reset inode 1277749 nlinks from 0 to 1<br>would have re=
set inode 1278773 nlinks from 0 to 1<br>

would have reset inode 1286709 nlinks from 0 to 1<br>would have reset inode=
 1288245 nlinks from 0 to 1<br>would have reset inode 1299765 nlinks from 0=
 to 1<br>would have reset inode 1302325 nlinks from 0 to 1<br>would have re=
set inode 1304885 nlinks from 0 to 1<br>

would have reset inode 1305397 nlinks from 0 to 1<br>would have reset inode=
 1307509 nlinks from 0 to 1<br>would have reset inode 1309493 nlinks from 0=
 to 1<br>would have reset inode 1310517 nlinks from 0 to 1<br>would have re=
set inode 1311029 nlinks from 0 to 1<br>

would have reset inode 1312053 nlinks from 0 to 1<br>would have reset inode=
 1316917 nlinks from 0 to 1<br>would have reset inode 1317941 nlinks from 0=
 to 1<br>would have reset inode 1320821 nlinks from 0 to 1<br>would have re=
set inode 1322805 nlinks from 0 to 1<br>

would have reset inode 1332789 nlinks from 0 to 1<br>would have reset inode=
 1336373 nlinks from 0 to 1<br>would have reset inode 1345653 nlinks from 0=
 to 1<br>would have reset inode 1354549 nlinks from 0 to 1<br>would have re=
set inode 1361973 nlinks from 0 to 1<br>

would have reset inode 1369909 nlinks from 0 to 1<br>would have reset inode=
 1372981 nlinks from 0 to 1<br>would have reset inode 1388853 nlinks from 0=
 to 1<br>would have reset inode 1402933 nlinks from 0 to 1<br>would have re=
set inode 1403445 nlinks from 0 to 1<br>

would have reset inode 1420085 nlinks from 0 to 1<br>would have reset inode=
 1452853 nlinks from 0 to 1<br>would have reset inode 1456437 nlinks from 0=
 to 1<br>would have reset inode 1457973 nlinks from 0 to 1<br>would have re=
set inode 1459253 nlinks from 0 to 1<br>

would have reset inode 1467957 nlinks from 0 to 1<br>would have reset inode=
 1471541 nlinks from 0 to 1<br>would have reset inode 1476661 nlinks from 0=
 to 1<br>would have reset inode 1479733 nlinks from 0 to 1<br>would have re=
set inode 1483061 nlinks from 0 to 1<br>

would have reset inode 1484085 nlinks from 0 to 1<br>would have reset inode=
 1486133 nlinks from 0 to 1<br>would have reset inode 1489461 nlinks from 0=
 to 1<br>would have reset inode 1490037 nlinks from 0 to 1<br>would have re=
set inode 1492021 nlinks from 0 to 1<br>

would have reset inode 1493557 nlinks from 0 to 1<br>would have reset inode=
 1494069 nlinks from 0 to 1<br>would have reset inode 1496885 nlinks from 0=
 to 1<br>would have reset inode 1498421 nlinks from 0 to 1<br>would have re=
set inode 1498933 nlinks from 0 to 1<br>

would have reset inode 1499957 nlinks from 0 to 1<br>would have reset inode=
 1506101 nlinks from 0 to 1<br>would have reset inode 1507637 nlinks from 0=
 to 1<br>would have reset inode 1510453 nlinks from 0 to 1<br>would have re=
set inode 1514293 nlinks from 0 to 1<br>

would have reset inode 1517365 nlinks from 0 to 1<br>would have reset inode=
 1520693 nlinks from 0 to 1<br>would have reset inode 1521973 nlinks from 0=
 to 1<br>would have reset inode 1530421 nlinks from 0 to 1<br>would have re=
set inode 1530933 nlinks from 0 to 1<br>

would have reset inode 1537333 nlinks from 0 to 1<br>would have reset inode=
 1538357 nlinks from 0 to 1<br>would have reset inode 1548853 nlinks from 0=
 to 1<br>would have reset inode 1553973 nlinks from 0 to 1<br>would have re=
set inode 1557301 nlinks from 0 to 1<br>

would have reset inode 1564213 nlinks from 0 to 1<br>would have reset inode=
 1564725 nlinks from 0 to 1<br>would have reset inode 1576501 nlinks from 0=
 to 1<br>would have reset inode 1580597 nlinks from 0 to 1<br>would have re=
set inode 1584693 nlinks from 0 to 1<br>

would have reset inode 1586485 nlinks from 0 to 1<br>would have reset inode=
 1589301 nlinks from 0 to 1<br>would have reset inode 1589813 nlinks from 0=
 to 1<br>would have reset inode 1592629 nlinks from 0 to 1<br>would have re=
set inode 1595701 nlinks from 0 to 1<br>

would have reset inode 1601077 nlinks from 0 to 1<br>would have reset inode=
 1623861 nlinks from 0 to 1<br>would have reset inode 1626677 nlinks from 0=
 to 1<br>would have reset inode 1627701 nlinks from 0 to 1<br>would have re=
set inode 1633333 nlinks from 0 to 1<br>

would have reset inode 1639221 nlinks from 0 to 1<br>would have reset inode=
 1649205 nlinks from 0 to 1<br>would have reset inode 1686325 nlinks from 0=
 to 1<br>would have reset inode 1690677 nlinks from 0 to 1<br>would have re=
set inode 1693749 nlinks from 0 to 1<br>

would have reset inode 1704757 nlinks from 0 to 1<br>would have reset inode=
 1707061 nlinks from 0 to 1<br>would have reset inode 1709109 nlinks from 0=
 to 1<br>would have reset inode 1719349 nlinks from 0 to 1<br>would have re=
set inode 1737013 nlinks from 0 to 1<br>

would have reset inode 1741365 nlinks from 0 to 1<br>would have reset inode=
 1747509 nlinks from 0 to 1<br>would have reset inode 1770805 nlinks from 0=
 to 1<br>would have reset inode 1780789 nlinks from 0 to 1<br>would have re=
set inode 1793589 nlinks from 0 to 1<br>

would have reset inode 1795125 nlinks from 0 to 1<br>would have reset inode=
 1800757 nlinks from 0 to 1<br>would have reset inode 1801269 nlinks from 0=
 to 1<br>would have reset inode 1802549 nlinks from 0 to 1<br>would have re=
set inode 1804085 nlinks from 0 to 1<br>

would have reset inode 1817141 nlinks from 0 to 1<br>would have reset inode=
 1821749 nlinks from 0 to 1<br>would have reset inode 1832757 nlinks from 0=
 to 1<br>would have reset inode 1836341 nlinks from 0 to 1<br>would have re=
set inode 1856309 nlinks from 0 to 1<br>

would have reset inode 1900597 nlinks from 0 to 1<br>would have reset inode=
 1902901 nlinks from 0 to 1<br>would have reset inode 1912373 nlinks from 0=
 to 1<br>would have reset inode 1943093 nlinks from 0 to 1<br>would have re=
set inode 1944373 nlinks from 0 to 1<br>

would have reset inode 1954101 nlinks from 0 to 1<br>would have reset inode=
 1955893 nlinks from 0 to 1<br>would have reset inode 1961781 nlinks from 0=
 to 1<br>would have reset inode 1974325 nlinks from 0 to 1<br>would have re=
set inode 1978677 nlinks from 0 to 1<br>

would have reset inode 1981237 nlinks from 0 to 1<br>would have reset inode=
 1992245 nlinks from 0 to 1<br>would have reset inode 2000949 nlinks from 0=
 to 1<br>would have reset inode 2002229 nlinks from 0 to 1<br>would have re=
set inode 2004789 nlinks from 0 to 1<br>

would have reset inode 2005301 nlinks from 0 to 1<br>would have reset inode=
 2011189 nlinks from 0 to 1<br>would have reset inode 2012981 nlinks from 0=
 to 1<br>would have reset inode 2015285 nlinks from 0 to 1<br>would have re=
set inode 2018869 nlinks from 0 to 1<br>

would have reset inode 2028341 nlinks from 0 to 1<br>would have reset inode=
 2028853 nlinks from 0 to 1<br>would have reset inode 2030901 nlinks from 0=
 to 1<br>would have reset inode 2032181 nlinks from 0 to 1<br>would have re=
set inode 2032693 nlinks from 0 to 1<br>

would have reset inode 2040117 nlinks from 0 to 1<br>would have reset inode=
 2053685 nlinks from 0 to 1<br>would have reset inode 2083893 nlinks from 0=
 to 1<br>would have reset inode 2087221 nlinks from 0 to 1<br>would have re=
set inode 2095925 nlinks from 0 to 1<br>

would have reset inode 2098741 nlinks from 0 to 1<br>would have reset inode=
 2100533 nlinks from 0 to 1<br>would have reset inode 2101301 nlinks from 0=
 to 1<br>would have reset inode 2123573 nlinks from 0 to 1<br>would have re=
set inode 2132789 nlinks from 0 to 1<br>

would have reset inode 2133813 nlinks from 0 to 1<br><br><br><div><br></div=
></div><div class=3D"gmail_extra"><div><div class=3D"h5"><br><br><div class=
=3D"gmail_quote">2013/4/10 =B7=FB=D3=C0=CC=CE <span dir=3D"ltr">&lt;<a href=
=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongtaofu@gmail.com</a>&g=
t;</span><br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">The storage info is as foll=
owing:<div><span style=3D"color:rgb(51,51,51);font-family:arial,verdana,san=
s-serif;font-size:12px;line-height:20px">RAID-6</span><br>

</div><div><span style=3D"color:rgb(51,51,51);font-family:arial,verdana,san=
s-serif;font-size:12px;line-height:20px">SATA HDD</span><span style=3D"colo=
r:rgb(51,51,51);font-family:arial,verdana,sans-serif;font-size:12px;line-he=
ight:20px"><br>


</span></div><div><span style=3D"color:rgb(51,51,51);font-family:arial,verd=
ana,sans-serif;font-size:12px;line-height:20px">Controller:&nbsp;</span><fo=
nt color=3D"#333333" face=3D"arial, verdana, sans-serif"><span style=3D"fon=
t-size:12px;line-height:20px">PERC H710P Mini (Embedded)</span></font></div=
>


<div><font color=3D"#333333" face=3D"arial, verdana, sans-serif"><span styl=
e=3D"font-size:12px;line-height:20px"><div>Disk /dev/sdb: 30000.3 GB, 30000=
346562560 bytes</div><div>255 heads, 63 sectors/track, 3647334 cylinders</d=
iv>


<div>Units =3D cylinders of 16065 * 512 =3D 8225280 bytes</div><div>Sector =
size (logical/physical): 512 bytes / 512 bytes</div><div>I/O size (minimum/=
optimal): 512 bytes / 512 bytes</div><div>Disk identifier: 0x00000000</div>


<div><br></div><div><div>sd 0:2:1:0: [sdb] 58594426880 512-byte logical blo=
cks: (30.0 TB/27.2 TiB)</div><div>sd 0:2:1:0: [sdb] Write Protect is off</d=
iv><div>sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08</div><div>sd 0:2:1:0: [sd=
b] Write cache: enabled, read cache: enabled, doesn&#39;t support DPO or FU=
A</div>


<div>sd 0:2:1:0: [sdb] Attached SCSI disk</div></div><div><br></div><div><d=
iv>*-storage &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><d=
iv>&nbsp; &nbsp; &nbsp; &nbsp;description: RAID bus controller</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp;product: MegaRAID SAS 2208 [Thunderbolt]</div><div=
>


&nbsp; &nbsp; &nbsp; &nbsp;vendor: LSI Logic / Symbios Logic</div><div>&nbs=
p; &nbsp; &nbsp; &nbsp;physical id: 0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;=
bus info: pci@0000:02:00.0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;logical nam=
e: scsi0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;version: 01</div><div>&nbsp; =
&nbsp; &nbsp; &nbsp;width: 64 bits</div>

<div>
&nbsp; &nbsp; &nbsp; &nbsp;clock: 33MHz</div><div>&nbsp; &nbsp; &nbsp; &nbs=
p;capabilities: storage pm pciexpress vpd msi msix bus_master cap_list rom<=
/div><div>&nbsp; &nbsp; &nbsp; &nbsp;configuration: driver=3Dmegaraid_sas l=
atency=3D0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;resources: irq:42 ioport:fc=
00(size=3D256) memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff memory:dc8=
00000-dc81ffff(prefetchable)</div>


<div>&nbsp; &nbsp; &nbsp;*-disk:0</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; description: SCSI Disk</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pro=
duct: PERC H710P</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<=
/div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.0.0</div><div>&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.0.0</div>


<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sda</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13</div><div>&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; serial: 0049d6ce1d9f2035180096fde490f648</div><div>&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; size: 558GiB (599GB)</div><div>&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; capabilities: partitioned partitioned:dos</div>


<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansiversion=3D5 sign=
ature=3D000aa336</div><div>&nbsp; &nbsp; &nbsp;*-disk:1</div><div>&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; description: SCSI Disk</div><div>&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; product: PERC H710P</div><div>&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; vendor: DELL</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical=
 id: 2.1.0</div>


<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.1.0</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sdb</div><div>&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; logical name: /mnt/xfsd</div><div>&nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; version: 3.13</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; serial: 003366f71da22035180096fde490f648</div>


<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 27TiB (30TB)</div><div>&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansiversion=3D5 mount.fstype=3D=
xfs mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,s=
width=3D1280,noquota state=3Dmounted</div></div><div><br></div>


<div>Thank you.</div></span></font></div></div><div class=3D"gmail_extra"><=
div><div><br><br><div class=3D"gmail_quote">2013/4/10 Emmanuel Florac <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:eflorac@intellique.com" target=3D"_blank=
">eflorac@intellique.com</a>&gt;</span><br>


<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Le Tue, 9 Apr 2013 23:10:03 +0800<br>
=B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_bl=
ank">yongtaofu@gmail.com</a>&gt; =A8=A6crivait:<br>
<div><br>
&gt; &gt; Apr &nbsp;9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected.<=
br>
&gt; &gt; Shutting down filesystem<br>
<br>
</div>This. I/O error detected. That means that at some point the underlyin=
g<br>
device (disk, RAID array, SAN volume) couldn&#39;t be reached. So this<br>
could very well be a case of a flakey drive, array, cable or SCSI<br>
driver.<br>
<br>
What&#39;s the storage setup here?<br>
<span><font color=3D"#888888"><br>
--<br>
------------------------------------------------------------------------<br=
>
Emmanuel Florac &nbsp; &nbsp; | &nbsp; Direction technique<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; Intellique<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; &lt;<a href=3D"mailto:eflorac@intellique.com" target=3D"_blank">eflorac=
@intellique.com</a>&gt;<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; +33 1 78 94 84 02<br>
------------------------------------------------------------------------<br=
>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div></div=
></div><span><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br></div></div><span class=3D"HOE=
nZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--bcaec51d2998bc485b04da1b2bd0--


--===============9220937563619725870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9220937563619725870==--
