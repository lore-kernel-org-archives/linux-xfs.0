Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A22E87CA0
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 23:03:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 366558F8037
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2016 21:03:50 -0700 (PDT)
Received: from nm32.bullet.mail.sg3.yahoo.com (nm32.bullet.mail.sg3.yahoo.com
	[106.10.151.27]) by cuda.sgi.com with ESMTP id u4e6GFScQ8o436x8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 08 Aug 2016 21:03:45 -0700 (PDT)
Date: Tue, 9 Aug 2016 04:02:55 +0000 (UTC)
From: Gim Leong Chin <chingimleong@yahoo.com.sg>
Message-ID: <592673683.10446004.1470715375850.JavaMail.yahoo@mail.yahoo.com>
In-Reply-To: <20160808174427.24d8272c@harpe.intellique.com>
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160808161132.1d76eb5c@harpe.intellique.com>
	<1470670691.8958.11.camel@filmlight.ltd.uk>
	<20160808174427.24d8272c@harpe.intellique.com>
Subject: Re: Advice needed with file system corruption
MIME-Version: 1.0
Reply-To: Gim Leong Chin <chingimleong@yahoo.com.sg>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2786244616168090254=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Steve Brooks <sjb14@st-andrews.ac.uk>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2786244616168090254==
Content-Type: multipart/alternative;
	boundary="----=_Part_10446003_2107006600.1470715375844"

------=_Part_10446003_2107006600.1470715375844
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



      From: Emmanuel Florac <eflorac@intellique.com>
 To: Roger Willcocks <roger@filmlight.ltd.uk>=20
Cc: Steve Brooks <sjb14@st-andrews.ac.uk>; xfs@oss.sgi.com
 Sent: Monday, 8 August 2016, 23:44
 Subject: Re: Advice needed with file system corruption
  =20
Le Mon, 08 Aug 2016 16:38:11 +0100
Roger Willcocks <roger@filmlight.ltd.uk> =C3=A9crivait:

> >=20
> > Late to the game, I just wanted to remark that I've unfortunately
> > verified many times that write activity during rebuilds on Adaptec
> > RAID controllers often creates corruption. I've reported that to
> > Adaptec, but they don't seem to care much...
> >=C2=A0=20
>=20

> It seems like explicitly disabling individual disk drives write-back
> cache somewhat mitigates the effect.=20

Drives connected to RAID controllers with battery backed cache should have =
their caches "disabled" (they are really set to write through mode instead)=
.=C2=A0 By the way, I found out in lab testing that 7200 RPM SATA drives su=
ffer a big performance loss when doing sequential writes in cache write thr=
ough mode.

  
------=_Part_10446003_2107006600.1470715375844
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div style=3D"color:#000; background-color:#fff; f=
ont-family:Helvetica Neue-Light, Helvetica Neue Light, Helvetica Neue, Helv=
etica, Arial, Lucida Grande, Sans-Serif;font-size:13px"><div><span></span><=
/div><div id=3D"yui_3_16_0_ym19_1_1470711140752_47422" class=3D"qtdSeparate=
BR"><br><br></div><div style=3D"display: block;" id=3D"yui_3_16_0_ym19_1_14=
70711140752_47426" class=3D"yahoo_quoted">  <div id=3D"yui_3_16_0_ym19_1_14=
70711140752_47425" style=3D"font-family: Helvetica Neue-Light, Helvetica Ne=
ue Light, Helvetica Neue, Helvetica, Arial, Lucida Grande, Sans-Serif; font=
-size: 13px;"> <div id=3D"yui_3_16_0_ym19_1_1470711140752_47424" style=3D"f=
ont-family: HelveticaNeue, Helvetica Neue, Helvetica, Arial, Lucida Grande,=
 Sans-Serif; font-size: 16px;"> <div id=3D"yui_3_16_0_ym19_1_1470711140752_=
47423" dir=3D"ltr"> <font face=3D"Arial" size=3D"2"> <hr size=3D"1"> <b><sp=
an style=3D"font-weight:bold;">From:</span></b> Emmanuel Florac &lt;eflorac=
@intellique.com&gt;<br> <b><span style=3D"font-weight: bold;">To:</span></b=
> Roger Willcocks &lt;roger@filmlight.ltd.uk&gt; <br><b><span style=3D"font=
-weight: bold;">Cc:</span></b> Steve Brooks &lt;sjb14@st-andrews.ac.uk&gt;;=
 xfs@oss.sgi.com<br> <b><span style=3D"font-weight: bold;">Sent:</span></b>=
 Monday, 8 August 2016, 23:44<br> <b><span style=3D"font-weight: bold;">Sub=
ject:</span></b> Re: Advice needed with file system corruption<br> </font> =
</div> <div id=3D"yui_3_16_0_ym19_1_1470711140752_47447" class=3D"y_msg_con=
tainer"><br>Le Mon, 08 Aug 2016 16:38:11 +0100<br clear=3D"none">Roger Will=
cocks &lt;<a shape=3D"rect" ymailto=3D"mailto:roger@filmlight.ltd.uk" href=
=3D"mailto:roger@filmlight.ltd.uk">roger@filmlight.ltd.uk</a>&gt; =C3=A9cri=
vait:<br clear=3D"none"><br clear=3D"none">&gt; &gt; <br clear=3D"none">&gt=
; &gt; Late to the game, I just wanted to remark that I've unfortunately<br=
 clear=3D"none">&gt; &gt; verified many times that write activity during re=
builds on Adaptec<br clear=3D"none">&gt; &gt; RAID controllers often create=
s corruption. I've reported that to<br clear=3D"none">&gt; &gt; Adaptec, bu=
t they don't seem to care much...<br clear=3D"none">&gt; &gt;&nbsp;  <br cl=
ear=3D"none">&gt; <br clear=3D"none"><br clear=3D"none">&gt; It seems like =
explicitly disabling individual disk drives write-back<br clear=3D"none">&g=
t; cache somewhat mitigates the effect. <br clear=3D"none"><br clear=3D"non=
e"><div class=3D"yqt7438623993" id=3D"yqtfd82408"><div id=3D"yui_3_16_0_ym1=
9_1_1470711140752_47627" dir=3D"ltr">Drives connected to RAID controllers w=
ith battery backed cache should have their caches "disabled" (they are real=
ly set to write through mode instead).&nbsp; By the way, I found out in lab=
 testing that 7200 RPM SATA drives suffer a big performance loss when doing=
 sequential writes in cache write through mode.<a id=3D"yui_3_16_0_ym19_1_1=
470711140752_47582" shape=3D"rect" href=3D"http://oss.sgi.com/mailman/listi=
nfo/xfs" target=3D"_blank"></a></div></div><br><br></div> </div> </div>  </=
div></div></body></html>
------=_Part_10446003_2107006600.1470715375844--


--===============2786244616168090254==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2786244616168090254==--
