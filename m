Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 918EB7F7E
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 01:14:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A9DFAC001
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 23:14:53 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id aEu2FHbru9c2dXE7 for
	<xfs@oss.sgi.com>; Thu, 25 Jun 2015 23:14:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id 64EDF2204AE
	for <xfs@oss.sgi.com>; Fri, 26 Jun 2015 08:14:49 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ViT5fBIHNuES for <xfs@oss.sgi.com>;
	Fri, 26 Jun 2015 08:14:47 +0200 (CEST)
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
From: Rasmus Borup Hansen <rbh@intomics.com>
In-Reply-To: <20150625184132.773a5ecd@harpe.intellique.com>
Date: Fri, 26 Jun 2015 08:14:49 +0200
Message-Id: <09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0878564622799652947=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


--===============0878564622799652947==
Content-Type: multipart/alternative; boundary="Apple-Mail=_F5F5889C-1533-4FEF-8C69-FD8079843B1F"


--Apple-Mail=_F5F5889C-1533-4FEF-8C69-FD8079843B1F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

I tried mounting the file system read-only (which triggered a quota =
check =E2=80=93 does this make sense when the file system is read-only?) =
and then I scanned the file system for files with the spurious inodes to =
see if I could find a pattern. This took quite a while, and I didn't =
find any patterns, except that all the files in directories with project =
quotas were affected (but there were also other files). I'm now running =
xfs_repair without -n (and I had to mount and unmount the file system =
before it would start). I'll report back when it has finished.

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

> On 25 Jun 2015, at 18:41, Emmanuel Florac <eflorac@intellique.com> =
wrote:
>=20
> Le Wed, 24 Jun 2015 09:39:45 +0200
> Rasmus Borup Hansen <rbh@intomics.com> =C3=A9crivait:
>=20
>> Only the first 20 lines are included. There are currently 250000+
>> more lines with "directory flags set on non-directory inode" and the
>> check is still running (the mostly small files take up around 30 TB,
>> so it'll probably take a while).
>>=20
>> I recently enabled user and project quota and updated from 3.13.0-53.
>> The file system has been heavily used for the last month or so.
>>=20
>> Does anyone have any thoughts on this? I'm tempted to stop using
>> quotas when the file system (hopefully) works again, as it's my
>> impression that project quotas are not widely used.
>=20
> Did you first try remounting then unmounting the volume to clear the
> log? That could clear out xfs_repair output.
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


--Apple-Mail=_F5F5889C-1533-4FEF-8C69-FD8079843B1F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">I tried mounting the file system read-only =
(which triggered a quota check =E2=80=93 does this make sense when the =
file system is read-only?) and then I scanned the file system for files =
with the spurious inodes to see if I could find a pattern. This took =
quite a while, and I didn't find any patterns, except that all the files =
in directories with project quotas were affected (but there were also =
other files). I'm now running xfs_repair without -n (and I had to mount =
and unmount the file system before it would start). I'll report back =
when it has finished.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Best,</div><div class=3D""><br class=3D""></div><div =
class=3D"">Rasmus</div><br class=3D""><div apple-content-edited=3D"true" =
class=3D"">
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
class=3D"">On 25 Jun 2015, at 18:41, Emmanuel Florac &lt;<a =
href=3D"mailto:eflorac@intellique.com" =
class=3D"">eflorac@intellique.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D"">Le Wed, 24 Jun 2015 =
09:39:45 +0200<br class=3D"">Rasmus Borup Hansen &lt;<a =
href=3D"mailto:rbh@intomics.com" class=3D"">rbh@intomics.com</a>&gt; =
=C3=A9crivait:<br class=3D""><br class=3D""><blockquote type=3D"cite" =
class=3D"">Only the first 20 lines are included. There are currently =
250000+<br class=3D"">more lines with "directory flags set on =
non-directory inode" and the<br class=3D"">check is still running (the =
mostly small files take up around 30 TB,<br class=3D"">so it'll probably =
take a while).<br class=3D""><br class=3D"">I recently enabled user and =
project quota and updated from 3.13.0-53.<br class=3D"">The file system =
has been heavily used for the last month or so.<br class=3D""><br =
class=3D"">Does anyone have any thoughts on this? I'm tempted to stop =
using<br class=3D"">quotas when the file system (hopefully) works again, =
as it's my<br class=3D"">impression that project quotas are not widely =
used.<br class=3D""></blockquote><br class=3D"">Did you first try =
remounting then unmounting the volume to clear the<br class=3D"">log? =
That could clear out xfs_repair output.<br class=3D""><br class=3D"">-- =
<br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D"">Emmanuel Florac &nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;Direction technique<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;Intellique<br =
class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>&lt;<a =
href=3D"mailto:eflorac@intellique.com" =
class=3D"">eflorac@intellique.com</a>&gt;<br class=3D""> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nbsp;+33 1 78 94 84 =
02<br =
class=3D"">---------------------------------------------------------------=
---------<br class=3D""><br =
class=3D"">_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D""><a =
href=3D"mailto:xfs@oss.sgi.com" class=3D"">xfs@oss.sgi.com</a><br =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs<br =
class=3D""></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_F5F5889C-1533-4FEF-8C69-FD8079843B1F--


--===============0878564622799652947==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0878564622799652947==--
