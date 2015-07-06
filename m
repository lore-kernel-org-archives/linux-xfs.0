Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 038AB7F55
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 06:08:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9366FAC002
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 04:08:23 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id bmkeod5gKCg1Lewd for
	<xfs@oss.sgi.com>; Mon, 06 Jul 2015 04:08:19 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id 7299922057D
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:08:18 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id eoslMJQCj1-c for <xfs@oss.sgi.com>;
	Mon,  6 Jul 2015 13:08:16 +0200 (CEST)
Received: from dhcp-0-1-94.intomics.com (dhcp-0-1-94.intomics.com [10.0.1.94])
	(Authenticated sender: rbh)
	by columba.intomics.com (Postfix) with ESMTPSA id 666A122053A
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:08:16 +0200 (CEST)
From: Rasmus Borup Hansen <rbh@intomics.com>
Message-Id: <0F9CF77D-1DA5-41DD-87AA-7F4109F08EFB@intomics.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Date: Mon, 6 Jul 2015 13:08:52 +0200
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
	<20150703235500.GR7943@dastard>
In-Reply-To: <20150703235500.GR7943@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0872809692032374549=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0872809692032374549==
Content-Type: multipart/alternative; boundary="Apple-Mail=_5BDCBB11-E2A9-4596-B143-EB0476F02181"


--Apple-Mail=_5BDCBB11-E2A9-4596-B143-EB0476F02181
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

I've made a metadump and I'm running another xfs_repair, but given that =
the first metadump is 132 GB, will you still be interested in looking at =
the dumps?

Best,

Rasmus

Intomics is a contract research organization specialized in deriving =
core biological insight from large scale data. We help our clients in =
the pharmaceutical industry develop tomorrow's medicines better, faster, =
and cheaper through optimized use of biomedical data.
-----------------------------------------------------------------
Hansen, Rasmus Borup              Intomics - from data to biology
System Administrator              Diplomvej 377
Scientific Programmer             DK-2800 Kgs. Lyngby
                                  Denmark
E: rbh@intomics.com               W: http://www.intomics.com/
P: +45 5167 7972                  P: +45 8880 7979

> On 04 Jul 2015, at 01:55, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Fri, Jul 03, 2015 at 08:27:28AM +0200, Rasmus Borup Hansen wrote:
>> Thank you for the suggestion. I compiled a new xfs_repair, but I got =
similar results from running it.
>=20
> Please take a metadump of the filesystem before and after repair
> so that we can find out what is actually going wrong. Feel free to
> send me a private pointer to the metadump images...
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--Apple-Mail=_5BDCBB11-E2A9-4596-B143-EB0476F02181
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">I've made a metadump and I'm running another =
xfs_repair, but given that the first metadump is 132 GB, will you still =
be interested in looking at the dumps?</div><div class=3D""><br =
class=3D""></div><div class=3D"">Best,</div><div class=3D""><br =
class=3D""></div><div class=3D"">Rasmus</div><br class=3D""><div =
apple-content-edited=3D"true" class=3D"">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: Helvetica; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: -webkit-auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><i class=3D"">Intomics is a =
contract research organization specialized in deriving core biological =
insight from large scale data. We help our clients in the =
pharmaceutical&nbsp;industry develop tomorrow's medicines better, =
faster, and cheaper through optimized use of biomedical data.</i><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-style: normal; font-variant: =
normal; font-weight: normal; letter-spacing: normal; line-height: =
normal; orphans: 2; text-align: -webkit-auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px;  "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; " class=3D""><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier =
New'">-----------------------------------------------------------------</f=
ont></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">Hansen, Rasmus Borup &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Intomics - from data to biology</font></div><div =
class=3D""><font class=3D"Apple-style-span" face=3D"'Courier =
New'">System Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;Diplomvej 377</font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">Scientific Programmer =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DK-2800 Kgs. =
Lyngby</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Denmark</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">E: <a href=3D"mailto:rbh@intomics.com" =
class=3D"">rbh@intomics.com</a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; W: <a href=3D"http://www.intomics.com/" =
class=3D"">http://www.intomics.com/</a></font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">P: +45 5167 7972 =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;P: +45 =
8880 7979</font></div></div></span></span>
</div>
<br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 04 Jul 2015, at 01:55, Dave Chinner &lt;<a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D"">On =
Fri, Jul 03, 2015 at 08:27:28AM +0200, Rasmus Borup Hansen wrote:<br =
class=3D""><blockquote type=3D"cite" class=3D"">Thank you for the =
suggestion. I compiled a new xfs_repair, but I got similar results from =
running it.<br class=3D""></blockquote><br class=3D"">Please take a =
metadump of the filesystem before and after repair<br class=3D"">so that =
we can find out what is actually going wrong. Feel free to<br =
class=3D"">send me a private pointer to the metadump images...<br =
class=3D""><br class=3D"">Cheers,<br class=3D""><br class=3D"">Dave.<br =
class=3D"">-- <br class=3D"">Dave Chinner<br class=3D""><a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a><br =
class=3D""><br =
class=3D"">_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D"">xfs@oss.sgi.com<br =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs<br =
class=3D""></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_5BDCBB11-E2A9-4596-B143-EB0476F02181--


--===============0872809692032374549==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0872809692032374549==--
