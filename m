Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F46C7CA1
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 08:49:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5BF1304059
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 06:49:34 -0700 (PDT)
Received: from mail-vk0-f68.google.com (mail-vk0-f68.google.com
	[209.85.213.68]) by cuda.sgi.com with ESMTP id KUdHXdFFUYyrAdTW
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Sep 2016 06:49:33 -0700 (PDT)
Received: by mail-vk0-f68.google.com with SMTP id z126so530202vkd.0
	for <xfs@oss.sgi.com>; Tue, 27 Sep 2016 06:49:33 -0700 (PDT)
MIME-Version: 1.0
From: murali krishna <murali.marimekala@gmail.com>
Date: Tue, 27 Sep 2016 09:49:11 -0400
Message-ID: <CAOSFFyjWR4ASud5aSoYTJKweWA244oMwT9_LRSzwnr0Qftg7Eg@mail.gmail.com>
Subject: Clarification required about xfs_metadump and xfs_mdrestore
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4379459652703962801=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4379459652703962801==
Content-Type: multipart/alternative; boundary=001a1142be68a0ab42053d7d8378

--001a1142be68a0ab42053d7d8378
Content-Type: text/plain; charset=UTF-8

Hi All,

Got your email id from Nathan Scott.

Could you please clarify the reasons behind stating below statement in
xfs_metadump man page.



*xfs_metadump should not be used for any purposes other than for
 debugging and reporting filesystem problems*
Man page: http://man7.org/linux/man-pages/man8/xfs_metadump.8.html

I am trying to encrypt my existing xfs drive (/dev/sda2) and would like to
backup metadata using xfs_metadump and restore it back using xfs_mdrestore
after encrypting my drive. In order to retain entire contents of my
realtime partition (/dev/sda1), I need to perform this step.

Can I use xfs_metadump to backup meta-data of xfs  and restore it back
successfully ?
Why xfs_metadump should be specifically used as debugging tool ? Please
clarify ?

Thanks in Advance,
Murali

--001a1142be68a0ab42053d7d8378
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span class=3D"gmail-im" style=3D"font-size:12.8px">Hi All=
,</span><div><span class=3D"gmail-im" style=3D"font-size:12.8px"><br></span=
></div><div><span class=3D"gmail-im" style=3D"font-size:12.8px">Got your em=
ail id from Nathan Scott.=C2=A0<br><br>Could you please clarify the reasons=
 behind stating below statement in<br>xfs_metadump man page.<br><br><i>xfs_=
metadump should not be used for any purposes other than for<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0debugging and reporting filesystem problems<br></i><br>Man=
 page:=C2=A0<a href=3D"http://man7.org/linux/man-pages/man8/xfs_metadump.8.=
html" rel=3D"noreferrer" target=3D"_blank">http://man7.org/linux/man-<wbr>p=
ages/man8/xfs_metadump.8.html</a><br><br>I am trying to encrypt my existing=
 xfs drive (/dev/sda2) and would like to backup metadata using xfs_metadump=
 and restore it back using xfs_mdrestore after encrypting my drive. In orde=
r to retain entire contents of my realtime partition (/dev/sda1), I need to=
 perform this step.</span><div><span class=3D"gmail-im" style=3D"font-size:=
12.8px"><br></span><span style=3D"font-size:12.8px">Can I use xfs_metadump =
to backup meta-data of xfs=C2=A0 and restore it back successfully ?</span><=
br style=3D"font-size:12.8px"><span style=3D"font-size:12.8px">Why xfs_meta=
dump should be specifically used as debugging tool ? Please clarify ?</span=
><div><span style=3D"font-size:12.8px"><br clear=3D"all"></span><div><div c=
lass=3D"gmail_signature"><div>Thanks in Advance,</div><div>Murali<br></div>=
</div></div>
</div></div></div></div>

--001a1142be68a0ab42053d7d8378--


--===============4379459652703962801==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4379459652703962801==--
