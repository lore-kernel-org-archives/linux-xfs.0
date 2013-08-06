Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 80D2D7F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 12:46:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EC498F809E
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 10:46:42 -0700 (PDT)
Received: from mail-qe0-f51.google.com (mail-qe0-f51.google.com
	[209.85.128.51]) by cuda.sgi.com with ESMTP id OhJ0pX3J1MuvPXK1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Aug 2013 10:46:25 -0700 (PDT)
Received: by mail-qe0-f51.google.com with SMTP id nd7so389782qeb.24
	for <xfs@oss.sgi.com>; Tue, 06 Aug 2013 10:46:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 6 Aug 2013 13:46:24 -0400
Message-ID: <CAAr1uZ2vu3EUZo_phMMMD27tdaXXskaBbAh4E63zHmyU7qKwuw@mail.gmail.com>
Subject: Cifs client sockoption tcp_nodelay?
From: S H <fabieux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3773694254686086855=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3773694254686086855==
Content-Type: multipart/alternative; boundary=047d7b67853ef3389304e34b00cb

--047d7b67853ef3389304e34b00cb
Content-Type: text/plain; charset=ISO-8859-1

Any way to set the sockoption tcp_nodelay for cifs client?

Nodelay option looks deprecated in manual and fstab mount. The client
doesn't read smb.conf so setting there wouldn't work either.

Could nodelay be set in /proc/fs/cifs?

The reason I ask is reading the share is slow for a few people and a
similar problem was solved on another of our sites by adding nodelay to
MySQL my.conf. Also smbfs is deprecated. Otherwise our other options are to
use NFS on the Windows server where the share is or go with cloud hosting.

Shirley

--047d7b67853ef3389304e34b00cb
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Any way to set the sockoption tcp_nodelay for cifs client?=A0<div><br></div=
>Nodelay option looks deprecated in manual and fstab=A0mount. The client do=
esn&#39;t read smb.conf so setting there wouldn&#39;t work either.<div><br>=
</div>
Could nodelay be set in /proc/fs/cifs?<div><br></div><div>The reason I ask =
is reading the share is slow for a few people=A0and a similar problem was s=
olved on another of our sites by adding nodelay to MySQL my.conf. Also smbf=
s is deprecated. Otherwise our=A0other options are=A0to use NFS on the Wind=
ows server where the share is or go with cloud hosting.</div>
<div><br></div><div>Shirley<span></span></div><div><br></div><div><br></div=
>

--047d7b67853ef3389304e34b00cb--


--===============3773694254686086855==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3773694254686086855==--
