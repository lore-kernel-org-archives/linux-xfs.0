Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F4D429DF8
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 07:07:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0FD578F8035
	for <xfs@oss.sgi.com>; Mon,  6 May 2013 05:07:35 -0700 (PDT)
Received: from mail-lb0-f175.google.com (mail-lb0-f175.google.com
	[209.85.217.175]) by cuda.sgi.com with ESMTP id
	cycqHgQ2l7C3QvGC (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 May 2013 05:07:33 -0700 (PDT)
Received: by mail-lb0-f175.google.com with SMTP id w20so3263267lbh.6
	for <xfs@oss.sgi.com>; Mon, 06 May 2013 05:07:32 -0700 (PDT)
MIME-Version: 1.0
From: Filippo Stenico <filippo.stenico@gmail.com>
Date: Mon, 6 May 2013 14:06:52 +0200
Message-ID: <CADNx=KsT9DC=vveyTZx8EovddFx9mhRS-yzygaORHZ_4VyXfzQ@mail.gmail.com>
Subject: Xfs_repair segfaults.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9023464397804076369=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9023464397804076369==
Content-Type: multipart/alternative; boundary=001a11c2a884a4858704dc0b8bf2

--001a11c2a884a4858704dc0b8bf2
Content-Type: text/plain; charset=ISO-8859-1

Hello,
I've had an issue on a raid5 volume (2 disks failing at same time, and
buggy NAS firmware trying hard to sync then stop for I/O error then retryes
to sync leading (!?) to lost raid and an xfs data corruption.

I've recreated raid, mounted the xfs filesystem, copied about 6TB of data
out of 8TB, the rest of data being unreachable with "structrure needs
cleaning" error.
Thus I tried to unmount/mount and still got same error, then dumped
metadata and tried various xfs_repair with different options but it always
reaches a same point where it always segfaults.

If someone is interested of investigating what's going on here and helping
me recover more data I would be happy to send in in more details....

Cheers

-- 
F

--001a11c2a884a4858704dc0b8bf2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello, <br>I&#39;ve had an issue on a raid5 volume (2 disks failing at same=
 time, and buggy NAS firmware trying hard to sync then stop for I/O error t=
hen retryes to sync leading (!?) to lost raid and an xfs data corruption.<b=
r>

<br>I&#39;ve recreated raid, mounted the xfs filesystem, copied about 6TB o=
f data out of 8TB, the rest of data being unreachable with &quot;structrure=
 needs cleaning&quot; error.<br>Thus I tried to unmount/mount and still got=
 same error, then dumped metadata and tried various xfs_repair with differe=
nt options but it always reaches a same point where it always segfaults.<br=
>

<br>If someone is interested of investigating what&#39;s going on here and =
helping me recover more data I would be happy to send in in more details...=
.<br><br>Cheers <br clear=3D"all"><br>-- <br>F

--001a11c2a884a4858704dc0b8bf2--


--===============9023464397804076369==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9023464397804076369==--
