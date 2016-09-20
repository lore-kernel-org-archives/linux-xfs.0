Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 139CE7CB1
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 13:20:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D98DD304048
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 11:20:46 -0700 (PDT)
Received: from mail-oi0-f52.google.com (mail-oi0-f52.google.com
	[209.85.218.52]) by cuda.sgi.com with ESMTP id nHlJoAL9JZptwpkW
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2016 11:20:44 -0700 (PDT)
Received: by mail-oi0-f52.google.com with SMTP id w11so32111250oia.2
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2016 11:20:44 -0700 (PDT)
MIME-Version: 1.0
From: Marcin Sura <mailing-lists@sura.pl>
Date: Tue, 20 Sep 2016 20:20:42 +0200
Message-ID: <CACNifpWojiF5XKwNgORqXCyuceRsGNQA+wEDWKpxdoEvJQ6+-w@mail.gmail.com>
Subject: Quick way to check if 32bit app can work with inode64
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8449911516318340481=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8449911516318340481==
Content-Type: multipart/alternative; boundary=001a113cbd189281c1053cf47c72

--001a113cbd189281c1053cf47c72
Content-Type: text/plain; charset=UTF-8

Hi Specialists!

I have a 32bit Java application reading and writing files to NFS share
mounted on Windows 2008R2 server 64bit. The filesystem behind NFS share is
of course XFS, created with default mkfs.xfs and mounted with inode64
option.

I don't have access to app source code.

Is there a quick and fast way to check if the app can be safely used with
inode64? Can I somehow force the files to be created with 64bit inodes
number, so the app can read then?

BR
Marcin

--001a113cbd189281c1053cf47c72
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Specialists!<div><br></div><div>I have a 32bit Java app=
lication reading and writing files to NFS share mounted on Windows 2008R2 s=
erver=C2=A064bit. The filesystem behind NFS share is of course XFS, created=
 with default mkfs.xfs and mounted with inode64 option.</div><div><br></div=
><div>I don&#39;t have access to app source code.</div><div><br></div><div>=
Is there a quick and fast way to check if the app can be safely used with i=
node64? Can I somehow force the files to be created with 64bit inodes numbe=
r, so the app can read then?</div><div><br></div><div>BR</div><div>Marcin</=
div></div>

--001a113cbd189281c1053cf47c72--


--===============8449911516318340481==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8449911516318340481==--
