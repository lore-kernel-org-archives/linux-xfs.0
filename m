Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88B6A7F4E
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 08:30:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66C8A8F8059
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 06:30:07 -0800 (PST)
Received: from exprod7og119.obsmtp.com (exprod7og119.obsmtp.com [64.18.2.16])
	by cuda.sgi.com with SMTP id 2gY7QIHHu4dHMTvK for
	<xfs@oss.sgi.com>; Thu, 27 Nov 2014 06:30:05 -0800 (PST)
Received: by mail-ob0-f178.google.com with SMTP id gq1so3790287obb.23
	for <xfs@oss.sgi.com>; Thu, 27 Nov 2014 06:30:05 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 27 Nov 2014 19:59:59 +0530
Message-ID: <CANoQhnbjv08FVe0iRFff0fNMV7u7POY9kPtAhCbe_Vz=d8kPxg@mail.gmail.com>
Subject: OS Upgrade Considerations For XFS Volume
From: Bharathiraja P <raja@where2getit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5857145374177660052=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5857145374177660052==
Content-Type: multipart/alternative; boundary=047d7b4724a29e05870508d7fa8a

--047d7b4724a29e05870508d7fa8a
Content-Type: text/plain; charset=UTF-8

Hi there,

We recently upgraded our database system from OpenSuSE-11.4 to OpenSuSE-13.1

Post the upgrade we are noticing load spikes on our database system.

OpenSuSE 11.4 uses kernel-2.6.37 and OpenSuSE-13.1 uses kernel-3.11.10

There seems to be some changes related to XFS in new kernel and I'm getting
this error when I run xfs_logprint

==============
sudo /usr/sbin/xfs_logprint /dev/mapper/pgsql-data
raja's password:
xfs_logprint:
xfs_logprint: /dev/mapper/pgsql-data contains a mounted and writable
filesystem
    data device: 0xfd00
    log device: 0xfd00 daddr: 6442450880 length: 4173824

cycle: 879    version: 2        lsn: 879,3707616    tail_lsn: 879,3666528
length of Log Record: 32256    prev offset: 3707552        num ops: 120
uuid: 314e5417-3787-476d-9ee3-22a81732cb67   format: little endian linux
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: f8163d32  len: 112  clientid: TRANS  flags: WAS_CONT END
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: f8163d32  len: 1664  clientid: TRANS  flags: none
xfs_logprint: unknown log operation type (b001)
**********************************************************************
* ERROR: data block=3707616                                           *
**********************************************************************
Bad data in log
==============


Do we need to do something for the xfs volume post os upgrade for better
performance?

--
Bharathiraja

--047d7b4724a29e05870508d7fa8a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div>Hi there,<br><br></div>We re=
cently upgraded our database system from OpenSuSE-11.4 to OpenSuSE-13.1<br>=
<br></div>Post the upgrade we are noticing load spikes on our database syst=
em.<br><br></div>OpenSuSE 11.4 uses kernel-2.6.37 and OpenSuSE-13.1 uses ke=
rnel-3.11.10<br><br></div>There seems to be some changes related to XFS in =
new kernel and I&#39;m getting this error when I run xfs_logprint<br><br>=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>sudo /usr/sbin/xfs_logprint /=
dev/mapper/pgsql-data <br>raja&#39;s password:<br>xfs_logprint:<br>xfs_logp=
rint: /dev/mapper/pgsql-data contains a mounted and writable filesystem<br>=
=C2=A0=C2=A0=C2=A0 data device: 0xfd00<br>=C2=A0=C2=A0=C2=A0 log device: 0x=
fd00 daddr: 6442450880 length: 4173824<br><br>cycle: 879=C2=A0=C2=A0=C2=A0 =
version: 2=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 lsn: 879,3707616=C2=A0=C2=
=A0=C2=A0 tail_lsn: 879,3666528<br>length of Log Record: 32256=C2=A0=C2=A0=
=C2=A0 prev offset: 3707552=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 num ops: 1=
20<br>uuid: 314e5417-3787-476d-9ee3-22a81732cb67=C2=A0=C2=A0 format: little=
 endian linux<br>h_size: 32768<br>-----------------------------------------=
-----------------------------------<br>Oper (0): tid: f8163d32=C2=A0 len: 1=
12=C2=A0 clientid: TRANS=C2=A0 flags: WAS_CONT END <br>Left over region fro=
m split log item<br>-------------------------------------------------------=
---------------------<br>Oper (1): tid: f8163d32=C2=A0 len: 1664=C2=A0 clie=
ntid: TRANS=C2=A0 flags: none<br>xfs_logprint: unknown log operation type (=
b001)<br>******************************************************************=
****<br>* ERROR: data block=3D3707616=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *<br>***=
*******************************************************************<br>Bad =
data in log<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br><br></div>=
Do we need to do something for the xfs volume post os upgrade for better pe=
rformance?<br><br>--<br></div>Bharathiraja<br></div>

--047d7b4724a29e05870508d7fa8a--


--===============5857145374177660052==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5857145374177660052==--
