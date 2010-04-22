Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MGGewD213697 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 11:16:40 -0500
Received: from CGYSNEX002.encana.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7B65154826F
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:18:40 -0700 (PDT)
Received: from CGYSNEX002.encana.com (cgysnex002.encana.com [142.56.87.69]) by
	cuda.sgi.com with ESMTP id OE3xI4bc0G9d6ZOH for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 09:18:40 -0700 (PDT)
Received: from CGYEX202.encana.com (unverified) by CGYSNEX002.encana.com
	(Clearswift SMTPRS 5.3.2) with ESMTP id
	<T95316f84a48e38574516f8@CGYSNEX002.encana.com> for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 10:18:39 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: different error messages for mkfs.xfs -ssize
Date: Thu, 22 Apr 2010 10:18:39 -0600
Message-ID: <F57F2AD357626644AF76410876025D751277F5@CGYEX705.encana.com>
In-Reply-To: <20100422153636.GB3822@laptop.oracle.com>
References: <20100422153636.GB3822@laptop.oracle.com>
From: "Kinzel, David" <David.Kinzel@encana.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>, xfs@oss.sgi.com
Cc: greg.marsden@oracle.com, joe.jin@oracle.com

>-----Original Message-----
>From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] 
>On Behalf Of Wengang Wang
>Sent: Thursday, April 22, 2010 9:37 AM
>To: xfs@oss.sgi.com
>Cc: greg.marsden@oracle.com; joe.jin@oracle.com
>Subject: different error messages for mkfs.xfs -ssize
>
>Hi experts,
>
>I got different error messages when provide different value for -ssize.
>Why the error messages are different? They are different but no one is
>containing more info than the other.

1639         if (sectorsize < XFS_MIN_SECTORSIZE ||
1640             sectorsize > XFS_MAX_SECTORSIZE || sectorsize >
blocksize) {
1641                 fprintf(stderr, _("illegal sector size %d\n"),
sectorsize);
1642                 usage();
1643         }

According to the defaults:

62 #define XFS_MIN_SECTORSIZE_LOG  9       /* i.e. 512 bytes */
64 #define XFS_MIN_SECTORSIZE      (1 << XFS_MIN_SECTORSIZE_LOG)

Looks like your sectorsize is not greater than XFS_MIN_SECTORSIZE
(illegal sector size)

For 3072,

1561                                         if (sectorsize <= 0 ||
1562                                             !ispow2(sectorsize))
1563                                                 illegal(value, "s
sectsize");

3072 is not a power of two (illegal value)

>
>[root@desk test-xfsprogs]# mkfs.xfs -ssize=256 /dev/sda10 -f 
>2>&1 |head -n 1
>illegal sector size 256
>[root@desk test-xfsprogs]# mkfs.xfs -ssize=3072 /dev/sda10 -f 
>2>&1 |head -n 1
>Illegal value 3072 for -s sectsize option
>
>regards,
>wengang.
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs
>

This email communication and any files transmitted with it may contain confidential and or proprietary information and is provided for the use of the intended recipient only.  Any review, retransmission or dissemination of this information by anyone other than the intended recipient is prohibited.  If you receive this email in error, please contact the sender and delete this communication and any copies immediately.  Thank you.
http://www.encana.com



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
