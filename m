Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 693DB7F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 19:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6E97AC001
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 17:46:02 -0700 (PDT)
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	9kHN52kVgFzYTTVP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 17:45:59 -0700 (PDT)
Received: by mail-ie0-f173.google.com with SMTP id 10so2711480ied.32
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 17:45:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516746AC.3090808@redhat.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
	<CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
	<CADFMGuLxgBFU=FUK94tPsCh+qxRW0rEELxSXYoMQLFJ1u3=q0Q@mail.gmail.com>
	<516746AC.3090808@redhat.com>
Date: Fri, 12 Apr 2013 08:45:58 +0800
Message-ID: <CADFMGuKKOPezbH07v5awUpDWmx2WCk5xR4OGR8KOurTBv69pGA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5976151222630581226=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5976151222630581226==
Content-Type: multipart/alternative; boundary=14dae9340865fe58f004da1f39e8

--14dae9340865fe58f004da1f39e8
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

the workload is about:
24 servers, replica(3) which means the distribute is 8
load is about 3(TB)-8(TB) per day.


2013/4/12 Brian Foster <bfoster@redhat.com>

> On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:
> > It happens tonight again on one of our servers, how to debug the root
> > cause? Thank you.
> >
>
> Hi,
>
> I've attached a system tap script (stap -v xfs.stp) that should
> hopefully print out a bit more data should the issue happen again. Do
> you have a small enough number of nodes (or predictable enough pattern)
> that you could run this on the nodes that tend to fail and collect the
> output?
>
> Also, could you collect an xfs_metadump of the filesystem in question
> and make it available for download and analysis somewhere? I believe the
> ideal approach is to mount/umount the filesystem first to replay the log
> before collecting a metadump, but somebody could correct me on that (to
> be safe, you could collect multiple dumps: pre-mount and post-mount).
>
> Could you also describe your workload a little bit? Thanks.
>
> Brian
>
> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:
> > xfs_inotobp() returned error 22.
> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree returne=
d
> > error 22
> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)
> > called from line 1184 of file fs/xfs/xfs_vnodeops.c.  Return address =
=3D
> > 0xffffffffa02ee20a
> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting
> > down filesystem
> > Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem an=
d
> > rectify the problem(s)
> > Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned=
.
> > Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned=
.
> > Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned=
.
> > Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returned=
.
> >
> > xfs_repair -n
> >
> >
> > Phase 7 - verify link counts...
> > would have reset inode 20021 nlinks from 0 to 1
> > would have reset inode 20789 nlinks from 0 to 1
> > would have reset inode 35125 nlinks from 0 to 1
> > would have reset inode 35637 nlinks from 0 to 1
> > would have reset inode 36149 nlinks from 0 to 1
> > would have reset inode 38197 nlinks from 0 to 1
> > would have reset inode 39477 nlinks from 0 to 1
> > would have reset inode 54069 nlinks from 0 to 1
> > would have reset inode 62261 nlinks from 0 to 1
> > would have reset inode 63029 nlinks from 0 to 1
> > would have reset inode 72501 nlinks from 0 to 1
> > would have reset inode 79925 nlinks from 0 to 1
> > would have reset inode 81205 nlinks from 0 to 1
> > would have reset inode 84789 nlinks from 0 to 1
> > would have reset inode 87861 nlinks from 0 to 1
> > would have reset inode 90663 nlinks from 0 to 1
> > would have reset inode 91189 nlinks from 0 to 1
> > would have reset inode 95541 nlinks from 0 to 1
> > would have reset inode 98101 nlinks from 0 to 1
> > would have reset inode 101173 nlinks from 0 to 1
> > would have reset inode 113205 nlinks from 0 to 1
> > would have reset inode 114741 nlinks from 0 to 1
> > would have reset inode 126261 nlinks from 0 to 1
> > would have reset inode 140597 nlinks from 0 to 1
> > would have reset inode 144693 nlinks from 0 to 1
> > would have reset inode 147765 nlinks from 0 to 1
> > would have reset inode 152885 nlinks from 0 to 1
> > would have reset inode 161333 nlinks from 0 to 1
> > would have reset inode 161845 nlinks from 0 to 1
> > would have reset inode 167477 nlinks from 0 to 1
> > would have reset inode 172341 nlinks from 0 to 1
> > would have reset inode 191797 nlinks from 0 to 1
> > would have reset inode 204853 nlinks from 0 to 1
> > would have reset inode 205365 nlinks from 0 to 1
> > would have reset inode 215349 nlinks from 0 to 1
> > would have reset inode 215861 nlinks from 0 to 1
> > would have reset inode 216373 nlinks from 0 to 1
> > would have reset inode 217397 nlinks from 0 to 1
> > would have reset inode 224309 nlinks from 0 to 1
> > would have reset inode 225589 nlinks from 0 to 1
> > would have reset inode 234549 nlinks from 0 to 1
> > would have reset inode 234805 nlinks from 0 to 1
> > would have reset inode 249653 nlinks from 0 to 1
> > would have reset inode 250677 nlinks from 0 to 1
> > would have reset inode 252469 nlinks from 0 to 1
> > would have reset inode 261429 nlinks from 0 to 1
> > would have reset inode 265013 nlinks from 0 to 1
> > would have reset inode 266805 nlinks from 0 to 1
> > would have reset inode 267317 nlinks from 0 to 1
> > would have reset inode 268853 nlinks from 0 to 1
> > would have reset inode 272437 nlinks from 0 to 1
> > would have reset inode 273205 nlinks from 0 to 1
> > would have reset inode 274229 nlinks from 0 to 1
> > would have reset inode 278325 nlinks from 0 to 1
> > would have reset inode 278837 nlinks from 0 to 1
> > would have reset inode 281397 nlinks from 0 to 1
> > would have reset inode 292661 nlinks from 0 to 1
> > would have reset inode 300853 nlinks from 0 to 1
> > would have reset inode 302901 nlinks from 0 to 1
> > would have reset inode 305205 nlinks from 0 to 1
> > would have reset inode 314165 nlinks from 0 to 1
> > would have reset inode 315189 nlinks from 0 to 1
> > would have reset inode 320309 nlinks from 0 to 1
> > would have reset inode 324917 nlinks from 0 to 1
> > would have reset inode 328245 nlinks from 0 to 1
> > would have reset inode 335925 nlinks from 0 to 1
> > would have reset inode 339253 nlinks from 0 to 1
> > would have reset inode 339765 nlinks from 0 to 1
> > would have reset inode 348213 nlinks from 0 to 1
> > would have reset inode 360501 nlinks from 0 to 1
> > would have reset inode 362037 nlinks from 0 to 1
> > would have reset inode 366389 nlinks from 0 to 1
> > would have reset inode 385845 nlinks from 0 to 1
> > would have reset inode 390709 nlinks from 0 to 1
> > would have reset inode 409141 nlinks from 0 to 1
> > would have reset inode 413237 nlinks from 0 to 1
> > would have reset inode 414773 nlinks from 0 to 1
> > would have reset inode 417845 nlinks from 0 to 1
> > would have reset inode 436021 nlinks from 0 to 1
> > would have reset inode 439349 nlinks from 0 to 1
> > would have reset inode 447029 nlinks from 0 to 1
> > would have reset inode 491317 nlinks from 0 to 1
> > would have reset inode 494133 nlinks from 0 to 1
> > would have reset inode 495413 nlinks from 0 to 1
> > would have reset inode 501301 nlinks from 0 to 1
> > would have reset inode 506421 nlinks from 0 to 1
> > would have reset inode 508469 nlinks from 0 to 1
> > would have reset inode 508981 nlinks from 0 to 1
> > would have reset inode 511797 nlinks from 0 to 1
> > would have reset inode 513077 nlinks from 0 to 1
> > would have reset inode 517941 nlinks from 0 to 1
> > would have reset inode 521013 nlinks from 0 to 1
> > would have reset inode 522805 nlinks from 0 to 1
> > would have reset inode 523317 nlinks from 0 to 1
> > would have reset inode 525621 nlinks from 0 to 1
> > would have reset inode 527925 nlinks from 0 to 1
> > would have reset inode 535605 nlinks from 0 to 1
> > would have reset inode 541749 nlinks from 0 to 1
> > would have reset inode 573493 nlinks from 0 to 1
> > would have reset inode 578613 nlinks from 0 to 1
> > would have reset inode 583029 nlinks from 0 to 1
> > would have reset inode 585525 nlinks from 0 to 1
> > would have reset inode 586293 nlinks from 0 to 1
> > would have reset inode 586805 nlinks from 0 to 1
> > would have reset inode 591413 nlinks from 0 to 1
> > would have reset inode 594485 nlinks from 0 to 1
> > would have reset inode 596277 nlinks from 0 to 1
> > would have reset inode 603189 nlinks from 0 to 1
> > would have reset inode 613429 nlinks from 0 to 1
> > would have reset inode 617781 nlinks from 0 to 1
> > would have reset inode 621877 nlinks from 0 to 1
> > would have reset inode 623925 nlinks from 0 to 1
> > would have reset inode 625205 nlinks from 0 to 1
> > would have reset inode 626741 nlinks from 0 to 1
> > would have reset inode 639541 nlinks from 0 to 1
> > would have reset inode 640053 nlinks from 0 to 1
> > would have reset inode 640565 nlinks from 0 to 1
> > would have reset inode 645173 nlinks from 0 to 1
> > would have reset inode 652853 nlinks from 0 to 1
> > would have reset inode 656181 nlinks from 0 to 1
> > would have reset inode 659253 nlinks from 0 to 1
> > would have reset inode 663605 nlinks from 0 to 1
> > would have reset inode 667445 nlinks from 0 to 1
> > would have reset inode 680757 nlinks from 0 to 1
> > would have reset inode 691253 nlinks from 0 to 1
> > would have reset inode 691765 nlinks from 0 to 1
> > would have reset inode 697653 nlinks from 0 to 1
> > would have reset inode 700469 nlinks from 0 to 1
> > would have reset inode 707893 nlinks from 0 to 1
> > would have reset inode 716853 nlinks from 0 to 1
> > would have reset inode 722229 nlinks from 0 to 1
> > would have reset inode 722741 nlinks from 0 to 1
> > would have reset inode 723765 nlinks from 0 to 1
> > would have reset inode 731957 nlinks from 0 to 1
> > would have reset inode 742965 nlinks from 0 to 1
> > would have reset inode 743477 nlinks from 0 to 1
> > would have reset inode 745781 nlinks from 0 to 1
> > would have reset inode 746293 nlinks from 0 to 1
> > would have reset inode 774453 nlinks from 0 to 1
> > would have reset inode 778805 nlinks from 0 to 1
> > would have reset inode 785013 nlinks from 0 to 1
> > would have reset inode 785973 nlinks from 0 to 1
> > would have reset inode 791349 nlinks from 0 to 1
> > would have reset inode 796981 nlinks from 0 to 1
> > would have reset inode 803381 nlinks from 0 to 1
> > would have reset inode 806965 nlinks from 0 to 1
> > would have reset inode 811798 nlinks from 0 to 1
> > would have reset inode 812310 nlinks from 0 to 1
> > would have reset inode 813078 nlinks from 0 to 1
> > would have reset inode 813607 nlinks from 0 to 1
> > would have reset inode 814183 nlinks from 0 to 1
> > would have reset inode 822069 nlinks from 0 to 1
> > would have reset inode 828469 nlinks from 0 to 1
> > would have reset inode 830005 nlinks from 0 to 1
> > would have reset inode 832053 nlinks from 0 to 1
> > would have reset inode 832565 nlinks from 0 to 1
> > would have reset inode 836661 nlinks from 0 to 1
> > would have reset inode 841013 nlinks from 0 to 1
> > would have reset inode 841525 nlinks from 0 to 1
> > would have reset inode 845365 nlinks from 0 to 1
> > would have reset inode 846133 nlinks from 0 to 1
> > would have reset inode 847157 nlinks from 0 to 1
> > would have reset inode 852533 nlinks from 0 to 1
> > would have reset inode 857141 nlinks from 0 to 1
> > would have reset inode 863271 nlinks from 0 to 1
> > would have reset inode 866855 nlinks from 0 to 1
> > would have reset inode 887861 nlinks from 0 to 1
> > would have reset inode 891701 nlinks from 0 to 1
> > would have reset inode 894773 nlinks from 0 to 1
> > would have reset inode 900149 nlinks from 0 to 1
> > would have reset inode 902197 nlinks from 0 to 1
> > would have reset inode 906293 nlinks from 0 to 1
> > would have reset inode 906805 nlinks from 0 to 1
> > would have reset inode 909877 nlinks from 0 to 1
> > would have reset inode 925493 nlinks from 0 to 1
> > would have reset inode 949543 nlinks from 0 to 1
> > would have reset inode 955175 nlinks from 0 to 1
> > would have reset inode 963623 nlinks from 0 to 1
> > would have reset inode 967733 nlinks from 0 to 1
> > would have reset inode 968231 nlinks from 0 to 1
> > would have reset inode 982069 nlinks from 0 to 1
> > would have reset inode 1007413 nlinks from 0 to 1
> > would have reset inode 1011509 nlinks from 0 to 1
> > would have reset inode 1014069 nlinks from 0 to 1
> > would have reset inode 1014581 nlinks from 0 to 1
> > would have reset inode 1022005 nlinks from 0 to 1
> > would have reset inode 1022517 nlinks from 0 to 1
> > would have reset inode 1023029 nlinks from 0 to 1
> > would have reset inode 1025333 nlinks from 0 to 1
> > would have reset inode 1043765 nlinks from 0 to 1
> > would have reset inode 1044789 nlinks from 0 to 1
> > would have reset inode 1049397 nlinks from 0 to 1
> > would have reset inode 1050933 nlinks from 0 to 1
> > would have reset inode 1051445 nlinks from 0 to 1
> > would have reset inode 1054261 nlinks from 0 to 1
> > would have reset inode 1060917 nlinks from 0 to 1
> > would have reset inode 1063477 nlinks from 0 to 1
> > would have reset inode 1076021 nlinks from 0 to 1
> > would have reset inode 1081141 nlinks from 0 to 1
> > would have reset inode 1086261 nlinks from 0 to 1
> > would have reset inode 1097269 nlinks from 0 to 1
> > would have reset inode 1099829 nlinks from 0 to 1
> > would have reset inode 1100853 nlinks from 0 to 1
> > would have reset inode 1101877 nlinks from 0 to 1
> > would have reset inode 1126709 nlinks from 0 to 1
> > would have reset inode 1134389 nlinks from 0 to 1
> > would have reset inode 1141045 nlinks from 0 to 1
> > would have reset inode 1141557 nlinks from 0 to 1
> > would have reset inode 1142581 nlinks from 0 to 1
> > would have reset inode 1148469 nlinks from 0 to 1
> > would have reset inode 1153333 nlinks from 0 to 1
> > would have reset inode 1181749 nlinks from 0 to 1
> > would have reset inode 1192245 nlinks from 0 to 1
> > would have reset inode 1198133 nlinks from 0 to 1
> > would have reset inode 1203765 nlinks from 0 to 1
> > would have reset inode 1221429 nlinks from 0 to 1
> > would have reset inode 1223989 nlinks from 0 to 1
> > would have reset inode 1235509 nlinks from 0 to 1
> > would have reset inode 1239349 nlinks from 0 to 1
> > would have reset inode 1240885 nlinks from 0 to 1
> > would have reset inode 1241397 nlinks from 0 to 1
> > would have reset inode 1241909 nlinks from 0 to 1
> > would have reset inode 1242421 nlinks from 0 to 1
> > would have reset inode 1244981 nlinks from 0 to 1
> > would have reset inode 1246517 nlinks from 0 to 1
> > would have reset inode 1253429 nlinks from 0 to 1
> > would have reset inode 1271861 nlinks from 0 to 1
> > would have reset inode 1274677 nlinks from 0 to 1
> > would have reset inode 1277749 nlinks from 0 to 1
> > would have reset inode 1278773 nlinks from 0 to 1
> > would have reset inode 1286709 nlinks from 0 to 1
> > would have reset inode 1288245 nlinks from 0 to 1
> > would have reset inode 1299765 nlinks from 0 to 1
> > would have reset inode 1302325 nlinks from 0 to 1
> > would have reset inode 1304885 nlinks from 0 to 1
> > would have reset inode 1305397 nlinks from 0 to 1
> > would have reset inode 1307509 nlinks from 0 to 1
> > would have reset inode 1309493 nlinks from 0 to 1
> > would have reset inode 1310517 nlinks from 0 to 1
> > would have reset inode 1311029 nlinks from 0 to 1
> > would have reset inode 1312053 nlinks from 0 to 1
> > would have reset inode 1316917 nlinks from 0 to 1
> > would have reset inode 1317941 nlinks from 0 to 1
> > would have reset inode 1320821 nlinks from 0 to 1
> > would have reset inode 1322805 nlinks from 0 to 1
> > would have reset inode 1332789 nlinks from 0 to 1
> > would have reset inode 1336373 nlinks from 0 to 1
> > would have reset inode 1345653 nlinks from 0 to 1
> > would have reset inode 1354549 nlinks from 0 to 1
> > would have reset inode 1361973 nlinks from 0 to 1
> > would have reset inode 1369909 nlinks from 0 to 1
> > would have reset inode 1372981 nlinks from 0 to 1
> > would have reset inode 1388853 nlinks from 0 to 1
> > would have reset inode 1402933 nlinks from 0 to 1
> > would have reset inode 1403445 nlinks from 0 to 1
> > would have reset inode 1420085 nlinks from 0 to 1
> > would have reset inode 1452853 nlinks from 0 to 1
> > would have reset inode 1456437 nlinks from 0 to 1
> > would have reset inode 1457973 nlinks from 0 to 1
> > would have reset inode 1459253 nlinks from 0 to 1
> > would have reset inode 1467957 nlinks from 0 to 1
> > would have reset inode 1471541 nlinks from 0 to 1
> > would have reset inode 1476661 nlinks from 0 to 1
> > would have reset inode 1479733 nlinks from 0 to 1
> > would have reset inode 1483061 nlinks from 0 to 1
> > would have reset inode 1484085 nlinks from 0 to 1
> > would have reset inode 1486133 nlinks from 0 to 1
> > would have reset inode 1489461 nlinks from 0 to 1
> > would have reset inode 1490037 nlinks from 0 to 1
> > would have reset inode 1492021 nlinks from 0 to 1
> > would have reset inode 1493557 nlinks from 0 to 1
> > would have reset inode 1494069 nlinks from 0 to 1
> > would have reset inode 1496885 nlinks from 0 to 1
> > would have reset inode 1498421 nlinks from 0 to 1
> > would have reset inode 1498933 nlinks from 0 to 1
> > would have reset inode 1499957 nlinks from 0 to 1
> > would have reset inode 1506101 nlinks from 0 to 1
> > would have reset inode 1507637 nlinks from 0 to 1
> > would have reset inode 1510453 nlinks from 0 to 1
> > would have reset inode 1514293 nlinks from 0 to 1
> > would have reset inode 1517365 nlinks from 0 to 1
> > would have reset inode 1520693 nlinks from 0 to 1
> > would have reset inode 1521973 nlinks from 0 to 1
> > would have reset inode 1530421 nlinks from 0 to 1
> > would have reset inode 1530933 nlinks from 0 to 1
> > would have reset inode 1537333 nlinks from 0 to 1
> > would have reset inode 1538357 nlinks from 0 to 1
> > would have reset inode 1548853 nlinks from 0 to 1
> > would have reset inode 1553973 nlinks from 0 to 1
> > would have reset inode 1557301 nlinks from 0 to 1
> > would have reset inode 1564213 nlinks from 0 to 1
> > would have reset inode 1564725 nlinks from 0 to 1
> > would have reset inode 1576501 nlinks from 0 to 1
> > would have reset inode 1580597 nlinks from 0 to 1
> > would have reset inode 1584693 nlinks from 0 to 1
> > would have reset inode 1586485 nlinks from 0 to 1
> > would have reset inode 1589301 nlinks from 0 to 1
> > would have reset inode 1589813 nlinks from 0 to 1
> > would have reset inode 1592629 nlinks from 0 to 1
> > would have reset inode 1595701 nlinks from 0 to 1
> > would have reset inode 1601077 nlinks from 0 to 1
> > would have reset inode 1623861 nlinks from 0 to 1
> > would have reset inode 1626677 nlinks from 0 to 1
> > would have reset inode 1627701 nlinks from 0 to 1
> > would have reset inode 1633333 nlinks from 0 to 1
> > would have reset inode 1639221 nlinks from 0 to 1
> > would have reset inode 1649205 nlinks from 0 to 1
> > would have reset inode 1686325 nlinks from 0 to 1
> > would have reset inode 1690677 nlinks from 0 to 1
> > would have reset inode 1693749 nlinks from 0 to 1
> > would have reset inode 1704757 nlinks from 0 to 1
> > would have reset inode 1707061 nlinks from 0 to 1
> > would have reset inode 1709109 nlinks from 0 to 1
> > would have reset inode 1719349 nlinks from 0 to 1
> > would have reset inode 1737013 nlinks from 0 to 1
> > would have reset inode 1741365 nlinks from 0 to 1
> > would have reset inode 1747509 nlinks from 0 to 1
> > would have reset inode 1770805 nlinks from 0 to 1
> > would have reset inode 1780789 nlinks from 0 to 1
> > would have reset inode 1793589 nlinks from 0 to 1
> > would have reset inode 1795125 nlinks from 0 to 1
> > would have reset inode 1800757 nlinks from 0 to 1
> > would have reset inode 1801269 nlinks from 0 to 1
> > would have reset inode 1802549 nlinks from 0 to 1
> > would have reset inode 1804085 nlinks from 0 to 1
> > would have reset inode 1817141 nlinks from 0 to 1
> > would have reset inode 1821749 nlinks from 0 to 1
> > would have reset inode 1832757 nlinks from 0 to 1
> > would have reset inode 1836341 nlinks from 0 to 1
> > would have reset inode 1856309 nlinks from 0 to 1
> > would have reset inode 1900597 nlinks from 0 to 1
> > would have reset inode 1902901 nlinks from 0 to 1
> > would have reset inode 1912373 nlinks from 0 to 1
> > would have reset inode 1943093 nlinks from 0 to 1
> > would have reset inode 1944373 nlinks from 0 to 1
> > would have reset inode 1954101 nlinks from 0 to 1
> > would have reset inode 1955893 nlinks from 0 to 1
> > would have reset inode 1961781 nlinks from 0 to 1
> > would have reset inode 1974325 nlinks from 0 to 1
> > would have reset inode 1978677 nlinks from 0 to 1
> > would have reset inode 1981237 nlinks from 0 to 1
> > would have reset inode 1992245 nlinks from 0 to 1
> > would have reset inode 2000949 nlinks from 0 to 1
> > would have reset inode 2002229 nlinks from 0 to 1
> > would have reset inode 2004789 nlinks from 0 to 1
> > would have reset inode 2005301 nlinks from 0 to 1
> > would have reset inode 2011189 nlinks from 0 to 1
> > would have reset inode 2012981 nlinks from 0 to 1
> > would have reset inode 2015285 nlinks from 0 to 1
> > would have reset inode 2018869 nlinks from 0 to 1
> > would have reset inode 2028341 nlinks from 0 to 1
> > would have reset inode 2028853 nlinks from 0 to 1
> > would have reset inode 2030901 nlinks from 0 to 1
> > would have reset inode 2032181 nlinks from 0 to 1
> > would have reset inode 2032693 nlinks from 0 to 1
> > would have reset inode 2040117 nlinks from 0 to 1
> > would have reset inode 2053685 nlinks from 0 to 1
> > would have reset inode 2083893 nlinks from 0 to 1
> > would have reset inode 2087221 nlinks from 0 to 1
> > would have reset inode 2095925 nlinks from 0 to 1
> > would have reset inode 2098741 nlinks from 0 to 1
> > would have reset inode 2100533 nlinks from 0 to 1
> > would have reset inode 2101301 nlinks from 0 to 1
> > would have reset inode 2123573 nlinks from 0 to 1
> > would have reset inode 2132789 nlinks from 0 to 1
> > would have reset inode 2133813 nlinks from 0 to 1
> >
> >
> >
> >
> >
> > 2013/4/10 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gma=
il.com>>
> >
> >     The storage info is as following:
> >     RAID-6
> >     SATA HDD
> >     Controller: PERC H710P Mini (Embedded)
> >     Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes
> >     255 heads, 63 sectors/track, 3647334 cylinders
> >     Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> >     Sector size (logical/physical): 512 bytes / 512 bytes
> >     I/O size (minimum/optimal): 512 bytes / 512 bytes
> >     Disk identifier: 0x00000000
> >
> >     sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (30.0 TB/27.=
2
> >     TiB)
> >     sd 0:2:1:0: [sdb] Write Protect is off
> >     sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
> >     sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn'=
t
> >     support DPO or FUA
> >     sd 0:2:1:0: [sdb] Attached SCSI disk
> >
> >     *-storage
> >            description: RAID bus controller
> >            product: MegaRAID SAS 2208 [Thunderbolt]
> >            vendor: LSI Logic / Symbios Logic
> >            physical id: 0
> >            bus info: pci@0000:02:00.0
> >            logical name: scsi0
> >            version: 01
> >            width: 64 bits
> >            clock: 33MHz
> >            capabilities: storage pm pciexpress vpd msi msix bus_master
> >     cap_list rom
> >            configuration: driver=3Dmegaraid_sas latency=3D0
> >            resources: irq:42 ioport:fc00(size=3D256)
> >     memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff
> >     memory:dc800000-dc81ffff(prefetchable)
> >          *-disk:0
> >               description: SCSI Disk
> >               product: PERC H710P
> >               vendor: DELL
> >               physical id: 2.0.0
> >               bus info: scsi@0:2.0.0
> >               logical name: /dev/sda
> >               version: 3.13
> >               serial: 0049d6ce1d9f2035180096fde490f648
> >               size: 558GiB (599GB)
> >               capabilities: partitioned partitioned:dos
> >               configuration: ansiversion=3D5 signature=3D000aa336
> >          *-disk:1
> >               description: SCSI Disk
> >               product: PERC H710P
> >               vendor: DELL
> >               physical id: 2.1.0
> >               bus info: scsi@0:2.1.0
> >               logical name: /dev/sdb
> >               logical name: /mnt/xfsd
> >               version: 3.13
> >               serial: 003366f71da22035180096fde490f648
> >               size: 27TiB (30TB)
> >               configuration: ansiversion=3D5 mount.fstype=3Dxfs
> >
> mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,swi=
dth=3D1280,noquota
> >     state=3Dmounted
> >
> >     Thank you.
> >
> >
> >     2013/4/10 Emmanuel Florac <eflorac@intellique.com
> >     <mailto:eflorac@intellique.com>>
> >
> >         Le Tue, 9 Apr 2013 23:10:03 +0800
> >         =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com <mailto:yongtaofu@gmail=
.com>> =A8=A6crivait:
> >
> >         > > Apr  9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected.
> >         > > Shutting down filesystem
> >
> >         This. I/O error detected. That means that at some point the
> >         underlying
> >         device (disk, RAID array, SAN volume) couldn't be reached. So
> this
> >         could very well be a case of a flakey drive, array, cable or SC=
SI
> >         driver.
> >
> >         What's the storage setup here?
> >
> >         --
> >
> ------------------------------------------------------------------------
> >         Emmanuel Florac     |   Direction technique
> >                             |   Intellique
> >                             |   <eflorac@intellique.com
> >         <mailto:eflorac@intellique.com>>
> >                             |   +33 1 78 94 84 02
> >
> ------------------------------------------------------------------------
> >
> >
> >
> >
> >     --
> >     =B7=FB=D3=C0=CC=CE
> >
> >
> >
> >
> > --
> > =B7=FB=D3=C0=CC=CE
> >
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> >
>
>


--=20
=B7=FB=D3=C0=CC=CE

--14dae9340865fe58f004da1f39e8
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>the workload is about:<br></div>24 servers, repl=
ica(3) which means the distribute is 8<br></div>load is about 3(TB)-8(TB) p=
er day.<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quo=
te">
2013/4/12 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redh=
at.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span><br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex">
<div class=3D"im">On 04/11/2013 03:11 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; It happens tonight again on one of our servers, how to debug the root<=
br>
&gt; cause? Thank you.<br>
&gt;<br>
<br>
</div>Hi,<br>
<br>
I&#39;ve attached a system tap script (stap -v xfs.stp) that should<br>
hopefully print out a bit more data should the issue happen again. Do<br>
you have a small enough number of nodes (or predictable enough pattern)<br>
that you could run this on the nodes that tend to fail and collect the<br>
output?<br>
<br>
Also, could you collect an xfs_metadump of the filesystem in question<br>
and make it available for download and analysis somewhere? I believe the<br=
>
ideal approach is to mount/umount the filesystem first to replay the log<br=
>
before collecting a metadump, but somebody could correct me on that (to<br>
be safe, you could collect multiple dumps: pre-mount and post-mount).<br>
<br>
Could you also describe your workload a little bit? Thanks.<br>
<br>
Brian<br>
<div><div class=3D"h5"><br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_iunlink_remove:<br>
&gt; xfs_inotobp() returned error 22.<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_inactive: xfs_ifree return=
ed<br>
&gt; error 22<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): xfs_do_force_shutdown(0x1)<br>
&gt; called from line 1184 of file fs/xfs/xfs_vnodeops.c. &nbsp;Return addr=
ess =3D<br>
&gt; 0xffffffffa02ee20a<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): I/O Error Detected. Shutting<b=
r>
&gt; down filesystem<br>
&gt; Apr 12 02:32:10 cqdx kernel: XFS (sdb): Please umount the filesystem a=
nd<br>
&gt; rectify the problem(s)<br>
&gt; Apr 12 02:32:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:32:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:33:19 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt; Apr 12 02:33:49 cqdx kernel: XFS (sdb): xfs_log_force: error 5 returne=
d.<br>
&gt;<br>
&gt; xfs_repair -n<br>
&gt;<br>
&gt;<br>
&gt; Phase 7 - verify link counts...<br>
&gt; would have reset inode 20021 nlinks from 0 to 1<br>
&gt; would have reset inode 20789 nlinks from 0 to 1<br>
&gt; would have reset inode 35125 nlinks from 0 to 1<br>
&gt; would have reset inode 35637 nlinks from 0 to 1<br>
&gt; would have reset inode 36149 nlinks from 0 to 1<br>
&gt; would have reset inode 38197 nlinks from 0 to 1<br>
&gt; would have reset inode 39477 nlinks from 0 to 1<br>
&gt; would have reset inode 54069 nlinks from 0 to 1<br>
&gt; would have reset inode 62261 nlinks from 0 to 1<br>
&gt; would have reset inode 63029 nlinks from 0 to 1<br>
&gt; would have reset inode 72501 nlinks from 0 to 1<br>
&gt; would have reset inode 79925 nlinks from 0 to 1<br>
&gt; would have reset inode 81205 nlinks from 0 to 1<br>
&gt; would have reset inode 84789 nlinks from 0 to 1<br>
&gt; would have reset inode 87861 nlinks from 0 to 1<br>
&gt; would have reset inode 90663 nlinks from 0 to 1<br>
&gt; would have reset inode 91189 nlinks from 0 to 1<br>
&gt; would have reset inode 95541 nlinks from 0 to 1<br>
&gt; would have reset inode 98101 nlinks from 0 to 1<br>
&gt; would have reset inode 101173 nlinks from 0 to 1<br>
&gt; would have reset inode 113205 nlinks from 0 to 1<br>
&gt; would have reset inode 114741 nlinks from 0 to 1<br>
&gt; would have reset inode 126261 nlinks from 0 to 1<br>
&gt; would have reset inode 140597 nlinks from 0 to 1<br>
&gt; would have reset inode 144693 nlinks from 0 to 1<br>
&gt; would have reset inode 147765 nlinks from 0 to 1<br>
&gt; would have reset inode 152885 nlinks from 0 to 1<br>
&gt; would have reset inode 161333 nlinks from 0 to 1<br>
&gt; would have reset inode 161845 nlinks from 0 to 1<br>
&gt; would have reset inode 167477 nlinks from 0 to 1<br>
&gt; would have reset inode 172341 nlinks from 0 to 1<br>
&gt; would have reset inode 191797 nlinks from 0 to 1<br>
&gt; would have reset inode 204853 nlinks from 0 to 1<br>
&gt; would have reset inode 205365 nlinks from 0 to 1<br>
&gt; would have reset inode 215349 nlinks from 0 to 1<br>
&gt; would have reset inode 215861 nlinks from 0 to 1<br>
&gt; would have reset inode 216373 nlinks from 0 to 1<br>
&gt; would have reset inode 217397 nlinks from 0 to 1<br>
&gt; would have reset inode 224309 nlinks from 0 to 1<br>
&gt; would have reset inode 225589 nlinks from 0 to 1<br>
&gt; would have reset inode 234549 nlinks from 0 to 1<br>
&gt; would have reset inode 234805 nlinks from 0 to 1<br>
&gt; would have reset inode 249653 nlinks from 0 to 1<br>
&gt; would have reset inode 250677 nlinks from 0 to 1<br>
&gt; would have reset inode 252469 nlinks from 0 to 1<br>
&gt; would have reset inode 261429 nlinks from 0 to 1<br>
&gt; would have reset inode 265013 nlinks from 0 to 1<br>
&gt; would have reset inode 266805 nlinks from 0 to 1<br>
&gt; would have reset inode 267317 nlinks from 0 to 1<br>
&gt; would have reset inode 268853 nlinks from 0 to 1<br>
&gt; would have reset inode 272437 nlinks from 0 to 1<br>
&gt; would have reset inode 273205 nlinks from 0 to 1<br>
&gt; would have reset inode 274229 nlinks from 0 to 1<br>
&gt; would have reset inode 278325 nlinks from 0 to 1<br>
&gt; would have reset inode 278837 nlinks from 0 to 1<br>
&gt; would have reset inode 281397 nlinks from 0 to 1<br>
&gt; would have reset inode 292661 nlinks from 0 to 1<br>
&gt; would have reset inode 300853 nlinks from 0 to 1<br>
&gt; would have reset inode 302901 nlinks from 0 to 1<br>
&gt; would have reset inode 305205 nlinks from 0 to 1<br>
&gt; would have reset inode 314165 nlinks from 0 to 1<br>
&gt; would have reset inode 315189 nlinks from 0 to 1<br>
&gt; would have reset inode 320309 nlinks from 0 to 1<br>
&gt; would have reset inode 324917 nlinks from 0 to 1<br>
&gt; would have reset inode 328245 nlinks from 0 to 1<br>
&gt; would have reset inode 335925 nlinks from 0 to 1<br>
&gt; would have reset inode 339253 nlinks from 0 to 1<br>
&gt; would have reset inode 339765 nlinks from 0 to 1<br>
&gt; would have reset inode 348213 nlinks from 0 to 1<br>
&gt; would have reset inode 360501 nlinks from 0 to 1<br>
&gt; would have reset inode 362037 nlinks from 0 to 1<br>
&gt; would have reset inode 366389 nlinks from 0 to 1<br>
&gt; would have reset inode 385845 nlinks from 0 to 1<br>
&gt; would have reset inode 390709 nlinks from 0 to 1<br>
&gt; would have reset inode 409141 nlinks from 0 to 1<br>
&gt; would have reset inode 413237 nlinks from 0 to 1<br>
&gt; would have reset inode 414773 nlinks from 0 to 1<br>
&gt; would have reset inode 417845 nlinks from 0 to 1<br>
&gt; would have reset inode 436021 nlinks from 0 to 1<br>
&gt; would have reset inode 439349 nlinks from 0 to 1<br>
&gt; would have reset inode 447029 nlinks from 0 to 1<br>
&gt; would have reset inode 491317 nlinks from 0 to 1<br>
&gt; would have reset inode 494133 nlinks from 0 to 1<br>
&gt; would have reset inode 495413 nlinks from 0 to 1<br>
&gt; would have reset inode 501301 nlinks from 0 to 1<br>
&gt; would have reset inode 506421 nlinks from 0 to 1<br>
&gt; would have reset inode 508469 nlinks from 0 to 1<br>
&gt; would have reset inode 508981 nlinks from 0 to 1<br>
&gt; would have reset inode 511797 nlinks from 0 to 1<br>
&gt; would have reset inode 513077 nlinks from 0 to 1<br>
&gt; would have reset inode 517941 nlinks from 0 to 1<br>
&gt; would have reset inode 521013 nlinks from 0 to 1<br>
&gt; would have reset inode 522805 nlinks from 0 to 1<br>
&gt; would have reset inode 523317 nlinks from 0 to 1<br>
&gt; would have reset inode 525621 nlinks from 0 to 1<br>
&gt; would have reset inode 527925 nlinks from 0 to 1<br>
&gt; would have reset inode 535605 nlinks from 0 to 1<br>
&gt; would have reset inode 541749 nlinks from 0 to 1<br>
&gt; would have reset inode 573493 nlinks from 0 to 1<br>
&gt; would have reset inode 578613 nlinks from 0 to 1<br>
&gt; would have reset inode 583029 nlinks from 0 to 1<br>
&gt; would have reset inode 585525 nlinks from 0 to 1<br>
&gt; would have reset inode 586293 nlinks from 0 to 1<br>
&gt; would have reset inode 586805 nlinks from 0 to 1<br>
&gt; would have reset inode 591413 nlinks from 0 to 1<br>
&gt; would have reset inode 594485 nlinks from 0 to 1<br>
&gt; would have reset inode 596277 nlinks from 0 to 1<br>
&gt; would have reset inode 603189 nlinks from 0 to 1<br>
&gt; would have reset inode 613429 nlinks from 0 to 1<br>
&gt; would have reset inode 617781 nlinks from 0 to 1<br>
&gt; would have reset inode 621877 nlinks from 0 to 1<br>
&gt; would have reset inode 623925 nlinks from 0 to 1<br>
&gt; would have reset inode 625205 nlinks from 0 to 1<br>
&gt; would have reset inode 626741 nlinks from 0 to 1<br>
&gt; would have reset inode 639541 nlinks from 0 to 1<br>
&gt; would have reset inode 640053 nlinks from 0 to 1<br>
&gt; would have reset inode 640565 nlinks from 0 to 1<br>
&gt; would have reset inode 645173 nlinks from 0 to 1<br>
&gt; would have reset inode 652853 nlinks from 0 to 1<br>
&gt; would have reset inode 656181 nlinks from 0 to 1<br>
&gt; would have reset inode 659253 nlinks from 0 to 1<br>
&gt; would have reset inode 663605 nlinks from 0 to 1<br>
&gt; would have reset inode 667445 nlinks from 0 to 1<br>
&gt; would have reset inode 680757 nlinks from 0 to 1<br>
&gt; would have reset inode 691253 nlinks from 0 to 1<br>
&gt; would have reset inode 691765 nlinks from 0 to 1<br>
&gt; would have reset inode 697653 nlinks from 0 to 1<br>
&gt; would have reset inode 700469 nlinks from 0 to 1<br>
&gt; would have reset inode 707893 nlinks from 0 to 1<br>
&gt; would have reset inode 716853 nlinks from 0 to 1<br>
&gt; would have reset inode 722229 nlinks from 0 to 1<br>
&gt; would have reset inode 722741 nlinks from 0 to 1<br>
&gt; would have reset inode 723765 nlinks from 0 to 1<br>
&gt; would have reset inode 731957 nlinks from 0 to 1<br>
&gt; would have reset inode 742965 nlinks from 0 to 1<br>
&gt; would have reset inode 743477 nlinks from 0 to 1<br>
&gt; would have reset inode 745781 nlinks from 0 to 1<br>
&gt; would have reset inode 746293 nlinks from 0 to 1<br>
&gt; would have reset inode 774453 nlinks from 0 to 1<br>
&gt; would have reset inode 778805 nlinks from 0 to 1<br>
&gt; would have reset inode 785013 nlinks from 0 to 1<br>
&gt; would have reset inode 785973 nlinks from 0 to 1<br>
&gt; would have reset inode 791349 nlinks from 0 to 1<br>
&gt; would have reset inode 796981 nlinks from 0 to 1<br>
&gt; would have reset inode 803381 nlinks from 0 to 1<br>
&gt; would have reset inode 806965 nlinks from 0 to 1<br>
&gt; would have reset inode 811798 nlinks from 0 to 1<br>
&gt; would have reset inode 812310 nlinks from 0 to 1<br>
&gt; would have reset inode 813078 nlinks from 0 to 1<br>
&gt; would have reset inode 813607 nlinks from 0 to 1<br>
&gt; would have reset inode 814183 nlinks from 0 to 1<br>
&gt; would have reset inode 822069 nlinks from 0 to 1<br>
&gt; would have reset inode 828469 nlinks from 0 to 1<br>
&gt; would have reset inode 830005 nlinks from 0 to 1<br>
&gt; would have reset inode 832053 nlinks from 0 to 1<br>
&gt; would have reset inode 832565 nlinks from 0 to 1<br>
&gt; would have reset inode 836661 nlinks from 0 to 1<br>
&gt; would have reset inode 841013 nlinks from 0 to 1<br>
&gt; would have reset inode 841525 nlinks from 0 to 1<br>
&gt; would have reset inode 845365 nlinks from 0 to 1<br>
&gt; would have reset inode 846133 nlinks from 0 to 1<br>
&gt; would have reset inode 847157 nlinks from 0 to 1<br>
&gt; would have reset inode 852533 nlinks from 0 to 1<br>
&gt; would have reset inode 857141 nlinks from 0 to 1<br>
&gt; would have reset inode 863271 nlinks from 0 to 1<br>
&gt; would have reset inode 866855 nlinks from 0 to 1<br>
&gt; would have reset inode 887861 nlinks from 0 to 1<br>
&gt; would have reset inode 891701 nlinks from 0 to 1<br>
&gt; would have reset inode 894773 nlinks from 0 to 1<br>
&gt; would have reset inode 900149 nlinks from 0 to 1<br>
&gt; would have reset inode 902197 nlinks from 0 to 1<br>
&gt; would have reset inode 906293 nlinks from 0 to 1<br>
&gt; would have reset inode 906805 nlinks from 0 to 1<br>
&gt; would have reset inode 909877 nlinks from 0 to 1<br>
&gt; would have reset inode 925493 nlinks from 0 to 1<br>
&gt; would have reset inode 949543 nlinks from 0 to 1<br>
&gt; would have reset inode 955175 nlinks from 0 to 1<br>
&gt; would have reset inode 963623 nlinks from 0 to 1<br>
&gt; would have reset inode 967733 nlinks from 0 to 1<br>
&gt; would have reset inode 968231 nlinks from 0 to 1<br>
&gt; would have reset inode 982069 nlinks from 0 to 1<br>
&gt; would have reset inode 1007413 nlinks from 0 to 1<br>
&gt; would have reset inode 1011509 nlinks from 0 to 1<br>
&gt; would have reset inode 1014069 nlinks from 0 to 1<br>
&gt; would have reset inode 1014581 nlinks from 0 to 1<br>
&gt; would have reset inode 1022005 nlinks from 0 to 1<br>
&gt; would have reset inode 1022517 nlinks from 0 to 1<br>
&gt; would have reset inode 1023029 nlinks from 0 to 1<br>
&gt; would have reset inode 1025333 nlinks from 0 to 1<br>
&gt; would have reset inode 1043765 nlinks from 0 to 1<br>
&gt; would have reset inode 1044789 nlinks from 0 to 1<br>
&gt; would have reset inode 1049397 nlinks from 0 to 1<br>
&gt; would have reset inode 1050933 nlinks from 0 to 1<br>
&gt; would have reset inode 1051445 nlinks from 0 to 1<br>
&gt; would have reset inode 1054261 nlinks from 0 to 1<br>
&gt; would have reset inode 1060917 nlinks from 0 to 1<br>
&gt; would have reset inode 1063477 nlinks from 0 to 1<br>
&gt; would have reset inode 1076021 nlinks from 0 to 1<br>
&gt; would have reset inode 1081141 nlinks from 0 to 1<br>
&gt; would have reset inode 1086261 nlinks from 0 to 1<br>
&gt; would have reset inode 1097269 nlinks from 0 to 1<br>
&gt; would have reset inode 1099829 nlinks from 0 to 1<br>
&gt; would have reset inode 1100853 nlinks from 0 to 1<br>
&gt; would have reset inode 1101877 nlinks from 0 to 1<br>
&gt; would have reset inode 1126709 nlinks from 0 to 1<br>
&gt; would have reset inode 1134389 nlinks from 0 to 1<br>
&gt; would have reset inode 1141045 nlinks from 0 to 1<br>
&gt; would have reset inode 1141557 nlinks from 0 to 1<br>
&gt; would have reset inode 1142581 nlinks from 0 to 1<br>
&gt; would have reset inode 1148469 nlinks from 0 to 1<br>
&gt; would have reset inode 1153333 nlinks from 0 to 1<br>
&gt; would have reset inode 1181749 nlinks from 0 to 1<br>
&gt; would have reset inode 1192245 nlinks from 0 to 1<br>
&gt; would have reset inode 1198133 nlinks from 0 to 1<br>
&gt; would have reset inode 1203765 nlinks from 0 to 1<br>
&gt; would have reset inode 1221429 nlinks from 0 to 1<br>
&gt; would have reset inode 1223989 nlinks from 0 to 1<br>
&gt; would have reset inode 1235509 nlinks from 0 to 1<br>
&gt; would have reset inode 1239349 nlinks from 0 to 1<br>
&gt; would have reset inode 1240885 nlinks from 0 to 1<br>
&gt; would have reset inode 1241397 nlinks from 0 to 1<br>
&gt; would have reset inode 1241909 nlinks from 0 to 1<br>
&gt; would have reset inode 1242421 nlinks from 0 to 1<br>
&gt; would have reset inode 1244981 nlinks from 0 to 1<br>
&gt; would have reset inode 1246517 nlinks from 0 to 1<br>
&gt; would have reset inode 1253429 nlinks from 0 to 1<br>
&gt; would have reset inode 1271861 nlinks from 0 to 1<br>
&gt; would have reset inode 1274677 nlinks from 0 to 1<br>
&gt; would have reset inode 1277749 nlinks from 0 to 1<br>
&gt; would have reset inode 1278773 nlinks from 0 to 1<br>
&gt; would have reset inode 1286709 nlinks from 0 to 1<br>
&gt; would have reset inode 1288245 nlinks from 0 to 1<br>
&gt; would have reset inode 1299765 nlinks from 0 to 1<br>
&gt; would have reset inode 1302325 nlinks from 0 to 1<br>
&gt; would have reset inode 1304885 nlinks from 0 to 1<br>
&gt; would have reset inode 1305397 nlinks from 0 to 1<br>
&gt; would have reset inode 1307509 nlinks from 0 to 1<br>
&gt; would have reset inode 1309493 nlinks from 0 to 1<br>
&gt; would have reset inode 1310517 nlinks from 0 to 1<br>
&gt; would have reset inode 1311029 nlinks from 0 to 1<br>
&gt; would have reset inode 1312053 nlinks from 0 to 1<br>
&gt; would have reset inode 1316917 nlinks from 0 to 1<br>
&gt; would have reset inode 1317941 nlinks from 0 to 1<br>
&gt; would have reset inode 1320821 nlinks from 0 to 1<br>
&gt; would have reset inode 1322805 nlinks from 0 to 1<br>
&gt; would have reset inode 1332789 nlinks from 0 to 1<br>
&gt; would have reset inode 1336373 nlinks from 0 to 1<br>
&gt; would have reset inode 1345653 nlinks from 0 to 1<br>
&gt; would have reset inode 1354549 nlinks from 0 to 1<br>
&gt; would have reset inode 1361973 nlinks from 0 to 1<br>
&gt; would have reset inode 1369909 nlinks from 0 to 1<br>
&gt; would have reset inode 1372981 nlinks from 0 to 1<br>
&gt; would have reset inode 1388853 nlinks from 0 to 1<br>
&gt; would have reset inode 1402933 nlinks from 0 to 1<br>
&gt; would have reset inode 1403445 nlinks from 0 to 1<br>
&gt; would have reset inode 1420085 nlinks from 0 to 1<br>
&gt; would have reset inode 1452853 nlinks from 0 to 1<br>
&gt; would have reset inode 1456437 nlinks from 0 to 1<br>
&gt; would have reset inode 1457973 nlinks from 0 to 1<br>
&gt; would have reset inode 1459253 nlinks from 0 to 1<br>
&gt; would have reset inode 1467957 nlinks from 0 to 1<br>
&gt; would have reset inode 1471541 nlinks from 0 to 1<br>
&gt; would have reset inode 1476661 nlinks from 0 to 1<br>
&gt; would have reset inode 1479733 nlinks from 0 to 1<br>
&gt; would have reset inode 1483061 nlinks from 0 to 1<br>
&gt; would have reset inode 1484085 nlinks from 0 to 1<br>
&gt; would have reset inode 1486133 nlinks from 0 to 1<br>
&gt; would have reset inode 1489461 nlinks from 0 to 1<br>
&gt; would have reset inode 1490037 nlinks from 0 to 1<br>
&gt; would have reset inode 1492021 nlinks from 0 to 1<br>
&gt; would have reset inode 1493557 nlinks from 0 to 1<br>
&gt; would have reset inode 1494069 nlinks from 0 to 1<br>
&gt; would have reset inode 1496885 nlinks from 0 to 1<br>
&gt; would have reset inode 1498421 nlinks from 0 to 1<br>
&gt; would have reset inode 1498933 nlinks from 0 to 1<br>
&gt; would have reset inode 1499957 nlinks from 0 to 1<br>
&gt; would have reset inode 1506101 nlinks from 0 to 1<br>
&gt; would have reset inode 1507637 nlinks from 0 to 1<br>
&gt; would have reset inode 1510453 nlinks from 0 to 1<br>
&gt; would have reset inode 1514293 nlinks from 0 to 1<br>
&gt; would have reset inode 1517365 nlinks from 0 to 1<br>
&gt; would have reset inode 1520693 nlinks from 0 to 1<br>
&gt; would have reset inode 1521973 nlinks from 0 to 1<br>
&gt; would have reset inode 1530421 nlinks from 0 to 1<br>
&gt; would have reset inode 1530933 nlinks from 0 to 1<br>
&gt; would have reset inode 1537333 nlinks from 0 to 1<br>
&gt; would have reset inode 1538357 nlinks from 0 to 1<br>
&gt; would have reset inode 1548853 nlinks from 0 to 1<br>
&gt; would have reset inode 1553973 nlinks from 0 to 1<br>
&gt; would have reset inode 1557301 nlinks from 0 to 1<br>
&gt; would have reset inode 1564213 nlinks from 0 to 1<br>
&gt; would have reset inode 1564725 nlinks from 0 to 1<br>
&gt; would have reset inode 1576501 nlinks from 0 to 1<br>
&gt; would have reset inode 1580597 nlinks from 0 to 1<br>
&gt; would have reset inode 1584693 nlinks from 0 to 1<br>
&gt; would have reset inode 1586485 nlinks from 0 to 1<br>
&gt; would have reset inode 1589301 nlinks from 0 to 1<br>
&gt; would have reset inode 1589813 nlinks from 0 to 1<br>
&gt; would have reset inode 1592629 nlinks from 0 to 1<br>
&gt; would have reset inode 1595701 nlinks from 0 to 1<br>
&gt; would have reset inode 1601077 nlinks from 0 to 1<br>
&gt; would have reset inode 1623861 nlinks from 0 to 1<br>
&gt; would have reset inode 1626677 nlinks from 0 to 1<br>
&gt; would have reset inode 1627701 nlinks from 0 to 1<br>
&gt; would have reset inode 1633333 nlinks from 0 to 1<br>
&gt; would have reset inode 1639221 nlinks from 0 to 1<br>
&gt; would have reset inode 1649205 nlinks from 0 to 1<br>
&gt; would have reset inode 1686325 nlinks from 0 to 1<br>
&gt; would have reset inode 1690677 nlinks from 0 to 1<br>
&gt; would have reset inode 1693749 nlinks from 0 to 1<br>
&gt; would have reset inode 1704757 nlinks from 0 to 1<br>
&gt; would have reset inode 1707061 nlinks from 0 to 1<br>
&gt; would have reset inode 1709109 nlinks from 0 to 1<br>
&gt; would have reset inode 1719349 nlinks from 0 to 1<br>
&gt; would have reset inode 1737013 nlinks from 0 to 1<br>
&gt; would have reset inode 1741365 nlinks from 0 to 1<br>
&gt; would have reset inode 1747509 nlinks from 0 to 1<br>
&gt; would have reset inode 1770805 nlinks from 0 to 1<br>
&gt; would have reset inode 1780789 nlinks from 0 to 1<br>
&gt; would have reset inode 1793589 nlinks from 0 to 1<br>
&gt; would have reset inode 1795125 nlinks from 0 to 1<br>
&gt; would have reset inode 1800757 nlinks from 0 to 1<br>
&gt; would have reset inode 1801269 nlinks from 0 to 1<br>
&gt; would have reset inode 1802549 nlinks from 0 to 1<br>
&gt; would have reset inode 1804085 nlinks from 0 to 1<br>
&gt; would have reset inode 1817141 nlinks from 0 to 1<br>
&gt; would have reset inode 1821749 nlinks from 0 to 1<br>
&gt; would have reset inode 1832757 nlinks from 0 to 1<br>
&gt; would have reset inode 1836341 nlinks from 0 to 1<br>
&gt; would have reset inode 1856309 nlinks from 0 to 1<br>
&gt; would have reset inode 1900597 nlinks from 0 to 1<br>
&gt; would have reset inode 1902901 nlinks from 0 to 1<br>
&gt; would have reset inode 1912373 nlinks from 0 to 1<br>
&gt; would have reset inode 1943093 nlinks from 0 to 1<br>
&gt; would have reset inode 1944373 nlinks from 0 to 1<br>
&gt; would have reset inode 1954101 nlinks from 0 to 1<br>
&gt; would have reset inode 1955893 nlinks from 0 to 1<br>
&gt; would have reset inode 1961781 nlinks from 0 to 1<br>
&gt; would have reset inode 1974325 nlinks from 0 to 1<br>
&gt; would have reset inode 1978677 nlinks from 0 to 1<br>
&gt; would have reset inode 1981237 nlinks from 0 to 1<br>
&gt; would have reset inode 1992245 nlinks from 0 to 1<br>
&gt; would have reset inode 2000949 nlinks from 0 to 1<br>
&gt; would have reset inode 2002229 nlinks from 0 to 1<br>
&gt; would have reset inode 2004789 nlinks from 0 to 1<br>
&gt; would have reset inode 2005301 nlinks from 0 to 1<br>
&gt; would have reset inode 2011189 nlinks from 0 to 1<br>
&gt; would have reset inode 2012981 nlinks from 0 to 1<br>
&gt; would have reset inode 2015285 nlinks from 0 to 1<br>
&gt; would have reset inode 2018869 nlinks from 0 to 1<br>
&gt; would have reset inode 2028341 nlinks from 0 to 1<br>
&gt; would have reset inode 2028853 nlinks from 0 to 1<br>
&gt; would have reset inode 2030901 nlinks from 0 to 1<br>
&gt; would have reset inode 2032181 nlinks from 0 to 1<br>
&gt; would have reset inode 2032693 nlinks from 0 to 1<br>
&gt; would have reset inode 2040117 nlinks from 0 to 1<br>
&gt; would have reset inode 2053685 nlinks from 0 to 1<br>
&gt; would have reset inode 2083893 nlinks from 0 to 1<br>
&gt; would have reset inode 2087221 nlinks from 0 to 1<br>
&gt; would have reset inode 2095925 nlinks from 0 to 1<br>
&gt; would have reset inode 2098741 nlinks from 0 to 1<br>
&gt; would have reset inode 2100533 nlinks from 0 to 1<br>
&gt; would have reset inode 2101301 nlinks from 0 to 1<br>
&gt; would have reset inode 2123573 nlinks from 0 to 1<br>
&gt; would have reset inode 2132789 nlinks from 0 to 1<br>
&gt; would have reset inode 2133813 nlinks from 0 to 1<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div></div>&gt; 2013/4/10 =B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtao=
fu@gmail.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mailto:yongtaof=
u@gmail.com">yongtaofu@gmail.com</a>&gt;&gt;<br>
<div><div class=3D"h5">&gt;<br>
&gt; &nbsp; &nbsp; The storage info is as following:<br>
&gt; &nbsp; &nbsp; RAID-6<br>
&gt; &nbsp; &nbsp; SATA HDD<br>
&gt; &nbsp; &nbsp; Controller: PERC H710P Mini (Embedded)<br>
&gt; &nbsp; &nbsp; Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes<br>
&gt; &nbsp; &nbsp; 255 heads, 63 sectors/track, 3647334 cylinders<br>
&gt; &nbsp; &nbsp; Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
&gt; &nbsp; &nbsp; Sector size (logical/physical): 512 bytes / 512 bytes<br=
>
&gt; &nbsp; &nbsp; I/O size (minimum/optimal): 512 bytes / 512 bytes<br>
&gt; &nbsp; &nbsp; Disk identifier: 0x00000000<br>
&gt;<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (=
30.0 TB/27.2<br>
&gt; &nbsp; &nbsp; TiB)<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Write Protect is off<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enab=
led, doesn&#39;t<br>
&gt; &nbsp; &nbsp; support DPO or FUA<br>
&gt; &nbsp; &nbsp; sd 0:2:1:0: [sdb] Attached SCSI disk<br>
&gt;<br>
&gt; &nbsp; &nbsp; *-storage<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;description: RAID bus control=
ler<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;product: MegaRAID SAS 2208 [T=
hunderbolt]<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vendor: LSI Logic / Symbios L=
ogic<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;physical id: 0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bus info: pci@0000:02:00.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;logical name: scsi0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;version: 01<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;width: 64 bits<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;clock: 33MHz<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;capabilities: storage pm pcie=
xpress vpd msi msix bus_master<br>
&gt; &nbsp; &nbsp; cap_list rom<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;configuration: driver=3Dmegar=
aid_sas latency=3D0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;resources: irq:42 ioport:fc00=
(size=3D256)<br>
&gt; &nbsp; &nbsp; memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff<br>
&gt; &nbsp; &nbsp; memory:dc800000-dc81ffff(prefetchable)<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*-disk:0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; description: SCSI Dis=
k<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product: PERC H710P<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.0.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.0.=
0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sd=
a<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; serial: 0049d6ce1d9f2=
035180096fde490f648<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 558GiB (599GB)<=
br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; capabilities: partiti=
oned partitioned:dos<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansive=
rsion=3D5 signature=3D000aa336<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;*-disk:1<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; description: SCSI Dis=
k<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; product: PERC H710P<b=
r>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.1.0<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.1.=
0<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sd=
b<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /mnt/xf=
sd<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; serial: 003366f71da22=
035180096fde490f648<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 27TiB (30TB)<br=
>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansive=
rsion=3D5 mount.fstype=3Dxfs<br>
&gt; &nbsp; &nbsp; mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64=
k,sunit=3D128,swidth=3D1280,noquota<br>
&gt; &nbsp; &nbsp; state=3Dmounted<br>
&gt;<br>
&gt; &nbsp; &nbsp; Thank you.<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; 2013/4/10 Emmanuel Florac &lt;<a href=3D"mailto:eflorac@=
intellique.com">eflorac@intellique.com</a><br>
</div></div>&gt; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:eflorac@intelli=
que.com">eflorac@intellique.com</a>&gt;&gt;<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Le Tue, 9 Apr 2013 23:10:03 +0800<br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE &lt;<a href=3D"ma=
ilto:yongtaofu@gmail.com">yongtaofu@gmail.com</a> &lt;mailto:<a href=3D"mai=
lto:yongtaofu@gmail.com">yongtaofu@gmail.com</a>&gt;&gt; =A8=A6crivait:<br>
<div class=3D"im">&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &gt; Apr &nbsp;9 11:01:30 cqdx kernel=
: XFS (sdb): I/O Error Detected.<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &gt; &gt; Shutting down filesystem<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; This. I/O error detected. That means that =
at some point the<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; underlying<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; device (disk, RAID array, SAN volume) coul=
dn&#39;t be reached. So this<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; could very well be a case of a flakey driv=
e, array, cable or SCSI<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; driver.<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; What&#39;s the storage setup here?<br>
&gt;<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ------------------------------------------=
------------------------------<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; Emmanuel Florac &nbsp; &nbsp; | &nbsp; Dir=
ection technique<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; Intellique<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; &lt;<a href=3D"mailto:eflorac@intelliq=
ue.com">eflorac@intellique.com</a><br>
</div>&gt; &nbsp; &nbsp; &nbsp; &nbsp; &lt;mailto:<a href=3D"mailto:eflorac=
@intellique.com">eflorac@intellique.com</a>&gt;&gt;<br>
<div class=3D"im HOEnZb">&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nbsp; <a href=3D"te=
l:%2B33%201%2078%2094%2084%2002" value=3D"+33178948402">+33 1 78 94 84 02</=
a><br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; ------------------------------------------=
------------------------------<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; &nbsp; &nbsp; --<br>
&gt; &nbsp; &nbsp; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; --<br>
&gt; =B7=FB=D3=C0=CC=CE<br>
&gt;<br>
&gt;<br>
</div><div class=3D"HOEnZb"><div class=3D"h5">&gt; ________________________=
_______________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">=
http://oss.sgi.com/mailman/listinfo/xfs</a><br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=
=C0=CC=CE
</div>

--14dae9340865fe58f004da1f39e8--


--===============5976151222630581226==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5976151222630581226==--
