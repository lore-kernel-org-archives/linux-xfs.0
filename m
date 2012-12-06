Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB68mp5K104138 for <xfs@oss.sgi.com>; Thu, 6 Dec 2012 02:48:51 -0600
Received: from mail-qa0-f53.google.com (mail-qa0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id xIH2GpEWVfDXuAWv
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Dec 2012 00:51:15 -0800 (PST)
Received: by mail-qa0-f53.google.com with SMTP id a19so416493qad.5
	for <xfs@oss.sgi.com>; Thu, 06 Dec 2012 00:51:15 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 6 Dec 2012 09:51:15 +0100
Message-ID: <CAA_rkDfFUmZzT_kMznsTSNVxdfqfmz=bmJ400wdBOzocgP32eA@mail.gmail.com>
Subject: XFS write cache flush policy
From: Lin Li <sdeber@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4168675985966872175=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4168675985966872175==
Content-Type: multipart/alternative; boundary=047d7b6757e09fe53a04d02b33ee

--047d7b6757e09fe53a04d02b33ee
Content-Type: text/plain; charset=ISO-8859-1

Hi, Guys. I recently suffered a huge data loss on power cut on an XFS
partition. The problem was that I copied a lot of files (roughly 20Gb) to
an XFS partition, then 10 hours later, I got an unexpected power cut. As a
result, all these newly copied files disappeared as if they had never been
copied. I tried to check and repair the partition, but xfs_check reports no
error at all. So I guess the problem is that the meta data for these files
were all kept in the cache (64Mb) and were never committed to the hard
disk.

What is the cache flush policy for XFS? Does it always reserve some fixed
space in cache for metadata? I asked because I thought since I copied such
a huge amount of data, at least some of these files must be fully committed
to the hard disk, then cache is only 64Mb anyway. But the reality is all of
them were lost. the only possibility I can think is some part of the cache
was reserved for meta data, so even the cache is fully filled, this part
will not be written to the disk. Am I right?

--047d7b6757e09fe53a04d02b33ee
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi, Guys. I recently suffered a huge data loss on power cut on an XFS parti=
tion. The problem was that I copied a lot of files (roughly 20Gb) to an XFS=
 partition, then 10 hours later, I got an unexpected power cut. As a result=
, all these newly copied files disappeared as if they had never been copied=
. I tried to check and repair the partition, but xfs_check reports no error=
 at all. So I guess the problem is that the meta data for these files were =
all kept in the cache (64Mb) and were never committed to the hard disk. <br=
>
<br>What is the cache flush policy for XFS? Does it always reserve some fix=
ed space in cache for metadata? I asked because I thought since I copied su=
ch a huge amount of data, at least some of these files must be fully commit=
ted to the hard disk, then cache is only 64Mb anyway. But the reality is al=
l of them were lost. the only possibility I can think is some part of the c=
ache was reserved for meta data, so even the cache is fully filled, this pa=
rt will not be written to the disk. Am I right? <br>

--047d7b6757e09fe53a04d02b33ee--


--===============4168675985966872175==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4168675985966872175==--
