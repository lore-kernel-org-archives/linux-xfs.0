Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9IC8hUk221824 for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 07:08:44 -0500
Received: from smtprelay03.ispgateway.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C57D1935815
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 05:09:54 -0700 (PDT)
Received: from smtprelay03.ispgateway.de (smtprelay03.ispgateway.de
	[80.67.29.28]) by cuda.sgi.com with ESMTP id xadMc33tlyprF9bs
	for <xfs@oss.sgi.com>; Mon, 18 Oct 2010 05:09:54 -0700 (PDT)
Received: from [62.43.225.238] (helo=[192.168.30.191])
	by smtprelay03.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68) (envelope-from <richard.ems@cape-horn-eng.com>)
	id 1P7oXJ-0003i0-JY
	for xfs@oss.sgi.com; Mon, 18 Oct 2010 14:09:53 +0200
Message-ID: <4CBC3910.70806@cape-horn-eng.com>
Date: Mon, 18 Oct 2010 14:09:52 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: cannot defrag volume, fragmentation factor 21.73%
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi all,

this is on openSUSE 11.3.

# uname -a
Linux fs1 2.6.34.7-0.3-default #1 SMP 2010-09-20 15:27:38 +0200 x86_64 =

x86_64 x86_64 GNU/Linux

# echo frag | xfs_db -r /dev/disk/by-label/data1
xfs_db> actual 6451844, ideal 5050129, fragmentation factor 21.73%

# xfs_db -V
xfs_db version 3.1.2

# xfs_fsr -V
xfs_fsr version 3.1.2

# df -h /dev/sdb1
Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1              17T   13T  4.3T  75% /data_1


The volume is new, 12TB were rsync'ed from another volume, some new =

files came after the sync.

I ran several times xfs_fsr, but the 21.73% factor stays there.
There where some busy or modified files on which I started xfs_fsr later =

again, but this ones where small files and the 21.73% is still there.

Any ideas?

Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
