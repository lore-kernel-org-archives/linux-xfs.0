Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46CE77F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 13:29:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 271AF304053
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:29:27 -0700 (PDT)
Received: from mail.ixserver.net (mail.ixserver.net [94.143.114.23]) by
	cuda.sgi.com with ESMTP id aOH3BHZxw7GmlCdk for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 11:29:23 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 9.0 \(3094\))
Subject: Re: Any way to slow down fragmentation ?
From: =?utf-8?Q?C=C3=A9dric_Lemarchand?= <cedric.lemarchand@ixblue.com>
In-Reply-To: <561D800B.90307@sandeen.net>
Date: Wed, 14 Oct 2015 20:29:19 +0200
Message-Id: <A51D31C2-A5F0-45A9-A258-3F6AB692DBD5@ixblue.com>
References: <561D7D9D.4030409@ixblue.com> <561D800B.90307@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6355480903983112128=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


--===============6355480903983112128==
Content-Type: multipart/alternative; boundary="Apple-Mail=_C0B526B3-FED3-49AC-AEC3-0FCB942EF57D"


--Apple-Mail=_C0B526B3-FED3-49AC-AEC3-0FCB942EF57D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Well .. it seems I missed the most important part of the FAQ, thank for =
pointing it. As you stated, playing with xfs_bmap shows that the 13TB =
file is fragmented a lot, xfs_fsr is now working on it.

Any hints about sector size ? Regarding the workload, my point would be =
that use 4k could not hurts here.

Thanks,

C=C3=A9dric

--=20
C=C3=A9dric Lemarchand
IT Infrastructure Manager
iXBlue
34 rue de la Croix de Fer
78100 St Germain en Laye
France
Tel. +33 1 30 08 88 88
Mob. +33 6 37 23 40 93
Fax +33 1 30 08 88 00
www.ixblue.com <http://www.ixblue.com/>
> On 14 Oct 2015, at 00:04, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>=20
>=20
> On 10/13/15 4:54 PM, C=C3=A9dric Lemarchand wrote:
>> I think I actually have very bad fragmentation values, which
>> unfortunately involve performances drop by an order of magnitude of
>> 3x/4x. A defrag is actually running, but it's really really slow, to =
the
>> point that I will need to constantly defrag the partition, which is =
not
>> optimal. There are approximatively 500Go written sequentially every =
day,
>> and almost 10/12T random writes every week due to backup files =
rotations.
>=20
> Does anything besides the xfs_db "frag" command make you think that
> fragmentation is a problem?  See below...
>=20
>> The partition has been formated with default options, over LVM (one
>> VG/one LV).
>>=20
>> Here are somes questions :
>>=20
>> - is there mkfs.xfs or mounting options that could reduce the
>> fragmentation over the time ?
>> - the backup software writes use blocks size of ~4MB, as the previous
>> question, any options to optimize differents layers (LVM & XFS) ? The
>> underlaying FS could handle 1MB block size, should I set this value =
for
>> XFS too ? do I need to play with "su" and "sw" as stated in the FAQ ?
>>=20
>> I admit that there are so many options that I am a bit lost.
>>=20
>> Thanks,
>>=20
>> C=C3=A9dric
>>=20
>> --
>> Some informations : VM running Debian Jessie, underlaying storage is
>> software raid (ZFS).
>>=20
>>=20
>> df -k
>> Filesystem            1K-blocks        Used   Available Use% Mounted =
on
>> /dev/mapper/VG2-LV1 53685000192 40921853928 12763146264  77% /vrepo1
>>=20
>> xfs_db -r /dev/VG2/LV1 -c frag
>> actual 4222, ideal 137, fragmentation factor 96.76%
>=20
> =
http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.2=
7m_over_50.25._Is_that_bad.3F
>=20
> So in 137 files, you have 4222 extents, or an average of
> about 30 extents per file.
>=20
> Or put another way, you have 39026 gigabytes used, in
> 4222 extents, for an average of 9 gigabytes per extent.
>=20
> Those don't sound like problematic numbers.
>=20
> xfs_bmap on an individual file will show you its mapping.
> But for files of several hundred gigs, having several
> very large extents really is not a problem.
>=20
> I think the xfs_db frag command may be misleading you about
> where the problem lies.
>=20
> Of course it's possible that all but one of your files is
> well laid out, and that last file is horribly, horribly
> fragmented.  But the top-level numbers don't tell us whether
> that might be the case.
>=20
> -Eric
>=20
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


--Apple-Mail=_C0B526B3-FED3-49AC-AEC3-0FCB942EF57D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dutf-8"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">Well .. it seems I missed the most important =
part of the FAQ, thank for pointing it. As you stated, playing with =
xfs_bmap shows that the 13TB file is fragmented a lot, xfs_fsr is now =
working on it.</div><div class=3D""><br class=3D""></div><div =
class=3D"">Any hints about sector size ? Regarding the workload, my =
point would be that use 4k could not hurts here.</div><div class=3D""><br =
class=3D""></div><div class=3D"">Thanks,</div><div class=3D""><br =
class=3D""></div><div class=3D"">C=C3=A9dric</div><div class=3D""><br =
class=3D""></div><div class=3D"">
<div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; orphans: =
auto; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D""><span style=3D"background-color: rgb(255, =
255, 255);" class=3D"">--&nbsp;</span><br class=3D""><div =
style=3D"font-weight: bold; font-size: 13px; font-family: Arial; color: =
rgb(0, 63, 128); margin-top: 10px;" class=3D""><div class=3D"">C=C3=A9dric=
 Lemarchand</div><div style=3D"font-weight: normal; color: rgb(126, 124, =
131);" class=3D"">IT Infrastructure Manager</div><div style=3D"margin-top:=
 12px;" class=3D"">iXBlue</div><div style=3D"font-weight: normal; =
font-size: 10px; color: rgb(126, 124, 131);" class=3D"">34 rue de la =
Croix de Fer</div><div style=3D"font-weight: normal; font-size: 10px; =
color: rgb(126, 124, 131);" class=3D"">78100 St Germain en Laye<br =
class=3D"">France</div><div style=3D"font-weight: normal; font-size: =
12px; margin: 12px 0px;" class=3D"">Tel. +33 1 30 08 88 88<br =
class=3D"">Mob. +33 6 37 23 40 93<br class=3D"">Fax +33 1 30 08 88 =
00</div><div style=3D"margin-bottom: 20px;" class=3D""><a =
href=3D"http://www.ixblue.com" style=3D"font-weight: normal; font-size: =
12px; color: rgb(0, 63, 128);" =
class=3D"">www.ixblue.com</a></div></div></div></div></div></div>
</div>
<br class=3D""><div style=3D""><blockquote type=3D"cite" class=3D""><div =
class=3D"">On 14 Oct 2015, at 00:04, Eric Sandeen &lt;<a =
href=3D"mailto:sandeen@sandeen.net" class=3D"">sandeen@sandeen.net</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D""><div =
class=3D""><br class=3D""><br class=3D"">On 10/13/15 4:54 PM, C=C3=A9dric =
Lemarchand wrote:<br class=3D""><blockquote type=3D"cite" class=3D"">I =
think I actually have very bad fragmentation values, which<br =
class=3D"">unfortunately involve performances drop by an order of =
magnitude of<br class=3D"">3x/4x. A defrag is actually running, but it's =
really really slow, to the<br class=3D"">point that I will need to =
constantly defrag the partition, which is not<br class=3D"">optimal. =
There are approximatively 500Go written sequentially every day,<br =
class=3D"">and almost 10/12T random writes every week due to backup =
files rotations.<br class=3D""></blockquote><br class=3D"">Does anything =
besides the xfs_db "frag" command make you think that<br =
class=3D"">fragmentation is a problem? &nbsp;See below...<br =
class=3D""><br class=3D""><blockquote type=3D"cite" class=3D"">The =
partition has been formated with default options, over LVM (one<br =
class=3D"">VG/one LV).<br class=3D""><br class=3D"">Here are somes =
questions :<br class=3D""><br class=3D"">- is there mkfs.xfs or mounting =
options that could reduce the<br class=3D"">fragmentation over the time =
?<br class=3D"">- the backup software writes use blocks size of ~4MB, as =
the previous<br class=3D"">question, any options to optimize differents =
layers (LVM &amp; XFS) ? The<br class=3D"">underlaying FS could handle =
1MB block size, should I set this value for<br class=3D"">XFS too ? do I =
need to play with "su" and "sw" as stated in the FAQ ?<br class=3D""><br =
class=3D"">I admit that there are so many options that I am a bit =
lost.<br class=3D""><br class=3D"">Thanks,<br class=3D""><br =
class=3D"">C=C3=A9dric<br class=3D""><br class=3D"">--<br class=3D"">Some =
informations : VM running Debian Jessie, underlaying storage is<br =
class=3D"">software raid (ZFS).<br class=3D""><br class=3D""><br =
class=3D"">df -k<br class=3D"">Filesystem =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1K-block=
s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Used &nbsp;&nbsp;Available =
Use% Mounted on<br class=3D"">/dev/mapper/VG2-LV1 53685000192 =
40921853928 12763146264 &nbsp;77% /vrepo1<br class=3D""><br =
class=3D"">xfs_db -r /dev/VG2/LV1 -c frag<br class=3D"">actual 4222, =
ideal 137, fragmentation factor 96.76%<br class=3D""></blockquote><br =
class=3D""><a =
href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_=
says_I.27m_over_50.25._Is_that_bad.3F" =
class=3D"">http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_comma=
nd_says_I.27m_over_50.25._Is_that_bad.3F</a><br class=3D""><br =
class=3D"">So in 137 files, you have 4222 extents, or an average of<br =
class=3D"">about 30 extents per file.<br class=3D""><br class=3D"">Or =
put another way, you have 39026 gigabytes used, in<br class=3D"">4222 =
extents, for an average of 9 gigabytes per extent.<br class=3D""><br =
class=3D"">Those don't sound like problematic numbers.<br class=3D""><br =
class=3D"">xfs_bmap on an individual file will show you its mapping.<br =
class=3D"">But for files of several hundred gigs, having several<br =
class=3D"">very large extents really is not a problem.<br class=3D""><br =
class=3D"">I think the xfs_db frag command may be misleading you =
about<br class=3D"">where the problem lies.<br class=3D""><br =
class=3D"">Of course it's possible that all but one of your files is<br =
class=3D"">well laid out, and that last file is horribly, horribly<br =
class=3D"">fragmented. &nbsp;But the top-level numbers don't tell us =
whether<br class=3D"">that might be the case.<br class=3D""><br =
class=3D"">-Eric<br class=3D""><br =
class=3D"">_______________________________________________<br =
class=3D"">xfs mailing list<br class=3D"">xfs@oss.sgi.com<br =
class=3D"">http://oss.sgi.com/mailman/listinfo/xfs<br =
class=3D""></div></div></blockquote></div><br class=3D""></body></html>=

--Apple-Mail=_C0B526B3-FED3-49AC-AEC3-0FCB942EF57D--


--===============6355480903983112128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6355480903983112128==--
