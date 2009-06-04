Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54JClup258126 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 14:12:48 -0500
Received: from an-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB14C1A6C2D8
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 12:13:05 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com
	[209.85.132.250]) by cuda.sgi.com with ESMTP id
	lbejqOPvrYdxy6Ke for <xfs@oss.sgi.com>;
	Thu, 04 Jun 2009 12:13:05 -0700 (PDT)
Received: by an-out-0708.google.com with SMTP id c37so551859anc.32
	for <xfs@oss.sgi.com>; Thu, 04 Jun 2009 12:13:05 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Jun 2009 15:13:01 -0400
Message-ID: <dc64e7230906041213s2bb9d67fj2df0b3db4ca37704@mail.gmail.com>
Subject: Repairing large partition
From: maillists0@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6322097074925548152=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6322097074925548152==
Content-Type: multipart/alternative; boundary=001636c9356a89f87b046b8a90f7

--001636c9356a89f87b046b8a90f7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pardon if this is the wrong list for this question.

I had a 50T xfs partition, spread across 3 storage devices which were lvm'd.
After a power failure, 2 disks on one device failed. It was raid5, so that
data is unrecoverable.

I replaced the failed disks and rebuilt that array. I can mount the
partition and see data on the first 2 devices. 'I ran xfs_repair -n' to see
what might be done a couple of days ago and it still hasn't finished.  Does
anyone know how I could recreate the partition to include the third device
without losing data from the first two devices? Any help will be greatly
appreciated, including a pointer to the appropriate docs. Thanks.

--001636c9356a89f87b046b8a90f7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pardon if this is the wrong list for this question. <br><br>I had a 50T xfs=
 partition, spread across 3 storage devices which were lvm&#39;d. After a p=
ower failure, 2 disks on one device failed. It was raid5, so that data is u=
nrecoverable. <br>
<br>I replaced the failed disks and rebuilt that array. I can mount the par=
tition and see data on the first 2 devices. &#39;I ran xfs_repair -n&#39; t=
o see what might be done a couple of days ago and it still hasn&#39;t finis=
hed.=A0 Does anyone know how I could recreate the partition to include the =
third device without losing data from the first two devices? Any help will =
be greatly appreciated, including a pointer to the appropriate docs. Thanks=
. <br>

--001636c9356a89f87b046b8a90f7--


--===============6322097074925548152==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6322097074925548152==--
