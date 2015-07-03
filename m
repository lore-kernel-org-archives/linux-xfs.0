Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EB4007FA6
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 01:27:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 506BCAC00B
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2015 23:27:10 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id VJCd5kbDNpHce1oI for
	<xfs@oss.sgi.com>; Thu, 02 Jul 2015 23:27:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id DB7AF220559
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:27:04 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id so_getlJ42s1 for <xfs@oss.sgi.com>;
	Fri,  3 Jul 2015 08:27:02 +0200 (CEST)
Received: from dhcp-0-1-94.intomics.com (dhcp-0-1-94.intomics.com [10.0.1.94])
	(Authenticated sender: rbh)
	by columba.intomics.com (Postfix) with ESMTPSA id C6F85220556
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 08:27:02 +0200 (CEST)
From: Rasmus Borup Hansen <rbh@intomics.com>
Message-Id: <E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Date: Fri, 3 Jul 2015 08:27:28 +0200
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
In-Reply-To: <20150702112623.1c83d473@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8068861468110764385=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8068861468110764385==
Content-Type: multipart/alternative; boundary="Apple-Mail=_B3E9CFD3-E877-4699-AC92-5E53ABDC7CA2"


--Apple-Mail=_B3E9CFD3-E877-4699-AC92-5E53ABDC7CA2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Thank you for the suggestion. I compiled a new xfs_repair, but I got =
similar results from running it.

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

> On 02 Jul 2015, at 11:26, Emmanuel Florac <eflorac@intellique.com> =
wrote:
>=20
> Le Thu, 2 Jul 2015 09:58:19 +0200
> Rasmus Borup Hansen <rbh@intomics.com> =C3=A9crivait:
>=20
>> The file then turns up in lost+found and when I "ls" it I get the
>> same errors again. I've tried deleting it from lost+found, but then
>> xfs_repair finds it again with exactly the same output as show above
>> and puts it back.
>>=20
>> Apart from that, everything apparently works fine.
>>=20
>> Is there a way to permanently get rid of the file in lost+found? Its
>> size is apparently 0 bytes.
>=20
> You should try the latest xfs_repair (3.2.3 IIRC) instead of the stock
> Ubuntu version (3.1.x probably).
>=20
> In case you don't know how to compile it, I've just uploaded it there:
>=20
> http://update.intellique.com/pub/xfs_repair-3.2.3.gz
>=20
> md5sum :
> 756a28228c7e657ce8626d27850f6261  xfs_repair-3.2.3.gz
>=20
> Beware of binaries provided by strangers, however this one should be
> fine :) gunzip it before use...
>=20
> --=20
> =
------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> =
------------------------------------------------------------------------
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--Apple-Mail=_B3E9CFD3-E877-4699-AC92-5E53ABDC7CA2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">Thank you for the suggestion. I compiled a =
new xfs_repair, but I got similar results from running it.</div><div =
class=3D""><br class=3D""></div><div class=3D"">Best,</div><div =
class=3D""><br class=3D""></div><div class=3D"">Rasmus</div><br =
class=3D""><div apple-content-edited=3D"true" class=3D"">
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
class=3D"">On 02 Jul 2015, at 11:26, Emmanuel Florac &lt;<a =
href=3D"mailto:eflorac@intellique.com" =
class=3D"">eflorac@intellique.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D"">Le Thu, 2 Jul 2015 =
09:58:19 +0200<br class=3D"">Rasmus Borup Hansen &lt;<a =
href=3D"mailto:rbh@intomics.com" class=3D"">rbh@intomics.com</a>&gt; =
=C3=A9crivait:<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">The file then turns up in lost+found and when I "ls" it I get =
the<br class=3D"">same errors again. I've tried deleting it from =
lost+found, but then<br class=3D"">xfs_repair finds it again with =
exactly the same output as show above<br class=3D"">and puts it back.<br =
class=3D""><br class=3D"">Apart from that, everything apparently works =
fine.<br class=3D""><br class=3D"">Is there a way to permanently get rid =
of the file in lost+found? Its<br class=3D"">size is apparently 0 =
bytes.<br class=3D""></blockquote><br class=3D"">You should try the =
latest xfs_repair (3.2.3 IIRC) instead of the stock<br class=3D"">Ubuntu =
version (3.1.x probably).<br class=3D""><br class=3D"">In case you don't =
know how to compile it, I've just uploaded it there:<br class=3D""><br =
class=3D""><a =
href=3D"http://update.intellique.com/pub/xfs_repair-3.2.3.gz" =
class=3D"">http://update.intellique.com/pub/xfs_repair-3.2.3.gz</a><br =
class=3D""><br class=3D"">md5sum :<br =
class=3D"">756a28228c7e657ce8626d27850f6261 &nbsp;xfs_repair-3.2.3.gz<br =
class=3D""><br class=3D"">Beware of binaries provided by strangers, =
however this one should be<br class=3D"">fine :) gunzip it before =
use...<br class=3D""><br class=3D"">-- <br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D"">Emmanuel Florac &nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;Direction technique<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;Intellique<br =
class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>&lt;eflorac@intellique.com&gt;<br =
class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;+33 1 78 94 84 =
02<br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D""><br =
class=3D"">_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D"">xfs@oss.sgi.com<br =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs<br =
class=3D""></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_B3E9CFD3-E877-4699-AC92-5E53ABDC7CA2--


--===============8068861468110764385==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8068861468110764385==--
