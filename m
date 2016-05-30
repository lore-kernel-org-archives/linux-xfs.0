Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D34F7CBE
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 03:49:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25014AC003
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 01:49:47 -0700 (PDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com
	[74.125.82.45]) by cuda.sgi.com with ESMTP id JNNZUddL1qpnbtS2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 May 2016 01:48:43 -0700 (PDT)
Received: by mail-wm0-f45.google.com with SMTP id s131so14648417wme.0
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 01:48:43 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
From: baotiao <baotiao@gmail.com>
In-Reply-To: <20160530050452.GM26977@dastard>
Date: Mon, 30 May 2016 16:48:36 +0800
Message-Id: <9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2419360255060093023=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============2419360255060093023==
Content-Type: multipart/alternative; boundary="Apple-Mail=_3BE03A55-D45E-4B6C-AE01-71BB9508A0DD"


--Apple-Mail=_3BE03A55-D45E-4B6C-AE01-71BB9508A0DD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

how can I set the extent size hint to a file with command line?=20
I have google for a lot, but I can't find a answer

----------------------------------------
=20
Github: https://github.com/baotiao
Blog: http://baotiao.github.io
Stackoverflow: http://stackoverflow.com/users/634415/baotiao=20
Linkedin: http://www.linkedin.com/profile/view?id=3D145231990

> On May 30, 2016, at 13:04, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:
>> This machine is running for qemu,  the file is qemu qcow file type
>>=20
>> [root@w-openstack20 =
/data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file disk
>> disk: QEMU QCOW Image (v3), has backing file (path =
/data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), =
429496729600 bytes
>=20
> Oh, you're using delta/snapshot based qcow images. That, by it's
> very nature, generates fragmented image files as they are a delta
> over the backing file.
>=20
> ....
>> actual 48421430, ideal 20716, fragmentation factor 99.96%
>>=20
>> How can I solve this problem, what do you suggest me to do?
>=20
> Use a extent size hint (say 1-8MB) for your qcow2 image files so that
> they don't fragment badly as they are written to.=20
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


--Apple-Mail=_3BE03A55-D45E-4B6C-AE01-71BB9508A0DD
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">how can I set the extent size hint to a file with command =
line?&nbsp;<div class=3D"">I have google for a lot, but I can't find a =
answer</div><div class=3D""><br class=3D""><div class=3D"">
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
class=3D""><div style=3D"orphans: auto; text-align: start; text-indent: =
0px; widows: auto; word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space;" class=3D""><div style=3D"color: =
rgb(0, 0, 0); letter-spacing: normal; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; orphans: =
auto; text-align: start; text-indent: 0px; widows: auto; word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; font-size: 20px;" =
class=3D"">----------------------------------------<br =
class=3D"">&nbsp;</div><div style=3D"orphans: auto; text-align: start; =
text-indent: 0px; widows: auto; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
font-size: 20px;" class=3D"">Github:&nbsp;<a =
href=3D"https://github.com/baotiao" =
class=3D"">https://github.com/baotiao</a><br class=3D"">Blog: <a =
href=3D"http://baotiao.github.io" =
class=3D"">http://baotiao.github.io</a><br class=3D"">Stackoverflow: <a =
href=3D"http://stackoverflow.com/users/634415/baotiao" =
class=3D"">http://stackoverflow.com/users/634415/baotiao</a>&nbsp;</div><d=
iv style=3D"orphans: auto; text-align: start; text-indent: 0px; widows: =
auto; word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; font-size: 20px;" =
class=3D"">Linkedin: <a =
href=3D"http://www.linkedin.com/profile/view?id=3D145231990" =
class=3D"">http://www.linkedin.com/profile/view?id=3D145231990</a></div></=
div></div></div></div>
</div>
<br class=3D""><div><blockquote type=3D"cite" class=3D""><div =
class=3D"">On May 30, 2016, at 13:04, Dave Chinner &lt;<a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D""><div =
class=3D"">On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:<br =
class=3D""><blockquote type=3D"cite" class=3D"">This machine is running =
for qemu, &nbsp;the file is qemu qcow file type<br class=3D""><br =
class=3D"">[root@w-openstack20 =
/data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file disk<br =
class=3D"">disk: QEMU QCOW Image (v3), has backing file (path =
/data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), =
429496729600 bytes<br class=3D""></blockquote><br class=3D"">Oh, you're =
using delta/snapshot based qcow images. That, by it's<br class=3D"">very =
nature, generates fragmented image files as they are a delta<br =
class=3D"">over the backing file.<br class=3D""><br class=3D"">....<br =
class=3D""><blockquote type=3D"cite" class=3D"">actual 48421430, ideal =
20716, fragmentation factor 99.96%<br class=3D""><br class=3D"">How can =
I solve this problem, what do you suggest me to do?<br =
class=3D""></blockquote><br class=3D"">Use a extent size hint (say =
1-8MB) for your qcow2 image files so that<br class=3D"">they don't =
fragment badly as they are written to. <br class=3D""><br =
class=3D"">Cheers,<br class=3D""><br class=3D"">Dave.<br class=3D"">-- =
<br class=3D"">Dave Chinner<br class=3D""><a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a><br =
class=3D""></div></div></blockquote></div><br =
class=3D""></div></body></html>=

--Apple-Mail=_3BE03A55-D45E-4B6C-AE01-71BB9508A0DD--


--===============2419360255060093023==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2419360255060093023==--
