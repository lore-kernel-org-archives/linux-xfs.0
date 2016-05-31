Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 264877CA0
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 21:43:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79AF1AC001
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 19:43:43 -0700 (PDT)
Received: from mail-qg0-f50.google.com (mail-qg0-f50.google.com
	[209.85.192.50]) by cuda.sgi.com with ESMTP id 7kgrYensCciPCe9V
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 May 2016 19:43:37 -0700 (PDT)
Received: by mail-qg0-f50.google.com with SMTP id e93so85166956qgf.2
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 19:43:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
	<9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
Date: Tue, 31 May 2016 10:43:36 +0800
Message-ID: <CAGbZs7i66XWt3PF1_-L-WeBtdH80nfAOv+-Ary+ORKHxFGOLFg@mail.gmail.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
From: =?UTF-8?B?6ZmI5a6X5b+X?= <baotiao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6826909824824552203=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6826909824824552203==
Content-Type: multipart/alternative; boundary=001a11c1248afd1fdc05341a561f

--001a11c1248afd1fdc05341a561f
Content-Type: text/plain; charset=UTF-8

I have fint the way to change the extent size hint
mkfs.xfs -r extsize=40960 /dev/sda1

but I should rebuild the disk, do you have a way more smooth?


On Mon, May 30, 2016 at 4:48 PM, baotiao <baotiao@gmail.com> wrote:

> how can I set the extent size hint to a file with command line?
> I have google for a lot, but I can't find a answer
>
> ----------------------------------------
>
> Github: https://github.com/baotiao
> Blog: http://baotiao.github.io
> Stackoverflow: http://stackoverflow.com/users/634415/baotiao
> Linkedin: http://www.linkedin.com/profile/view?id=145231990
>
> On May 30, 2016, at 13:04, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:
>
> This machine is running for qemu,  the file is qemu qcow file type
>
> [root@w-openstack20
> /data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file disk
> disk: QEMU QCOW Image (v3), has backing file (path
> /data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e),
> 429496729600 bytes
>
>
> Oh, you're using delta/snapshot based qcow images. That, by it's
> very nature, generates fragmented image files as they are a delta
> over the backing file.
>
> ....
>
> actual 48421430, ideal 20716, fragmentation factor 99.96%
>
> How can I solve this problem, what do you suggest me to do?
>
>
> Use a extent size hint (say 1-8MB) for your qcow2 image files so that
> they don't fragment badly as they are written to.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
>


-- 
---
Blog: http://www.chenzongzhi.info
Twitter: https://twitter.com/baotiao <https://twitter.com/#%21/baotiao>
Git: https://github.com/baotiao

--001a11c1248afd1fdc05341a561f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I have fint the way to change the extent size hint<br=
>mkfs.xfs -r extsize=3D40960 /dev/sda1<br><br></div>but I should rebuild th=
e disk, do you have a way more smooth?<br><br></div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">On Mon, May 30, 2016 at 4:48 PM, baotiao=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:baotiao@gmail.com" target=3D"_blan=
k">baotiao@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
"><div style=3D"word-wrap:break-word">how can I set the extent size hint to=
 a file with command line?=C2=A0<div>I have google for a lot, but I can&#39=
;t find a answer</div><div><span class=3D""><br><div>
<div style=3D"color:rgb(0,0,0);letter-spacing:normal;text-align:start;text-=
indent:0px;text-transform:none;white-space:normal;word-spacing:0px;word-wra=
p:break-word"><div style=3D"color:rgb(0,0,0);letter-spacing:normal;text-ali=
gn:start;text-indent:0px;text-transform:none;white-space:normal;word-spacin=
g:0px;word-wrap:break-word"><div style=3D"color:rgb(0,0,0);letter-spacing:n=
ormal;text-align:start;text-indent:0px;text-transform:none;white-space:norm=
al;word-spacing:0px;word-wrap:break-word"><div style=3D"text-align:start;te=
xt-indent:0px;word-wrap:break-word"><div style=3D"color:rgb(0,0,0);letter-s=
pacing:normal;text-transform:none;white-space:normal;word-spacing:0px;text-=
align:start;text-indent:0px;word-wrap:break-word;font-size:20px">----------=
------------------------------<br>=C2=A0</div><div style=3D"text-align:star=
t;text-indent:0px;word-wrap:break-word;font-size:20px">Github:=C2=A0<a href=
=3D"https://github.com/baotiao" target=3D"_blank">https://github.com/baotia=
o</a><br>Blog: <a href=3D"http://baotiao.github.io" target=3D"_blank">http:=
//baotiao.github.io</a><br>Stackoverflow: <a href=3D"http://stackoverflow.c=
om/users/634415/baotiao" target=3D"_blank">http://stackoverflow.com/users/6=
34415/baotiao</a>=C2=A0</div><div style=3D"text-align:start;text-indent:0px=
;word-wrap:break-word;font-size:20px">Linkedin: <a href=3D"http://www.linke=
din.com/profile/view?id=3D145231990" target=3D"_blank">http://www.linkedin.=
com/profile/view?id=3D145231990</a></div></div></div></div></div>
</div>
<br></span><div><div class=3D"h5"><div><blockquote type=3D"cite"><div>On Ma=
y 30, 2016, at 13:04, Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.co=
m" target=3D"_blank">david@fromorbit.com</a>&gt; wrote:</div><br><div><div>=
On Mon, May 30, 2016 at 12:45:07PM +0800, baotiao wrote:<br><blockquote typ=
e=3D"cite">This machine is running for qemu, =C2=A0the file is qemu qcow fi=
le type<br><br>[root@w-openstack20 /data/nova/instances/7898b630-c4ef-49ab-=
9ce9-3735e090c282]# file disk<br>disk: QEMU QCOW Image (v3), has backing fi=
le (path /data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), =
429496729600 bytes<br></blockquote><br>Oh, you&#39;re using delta/snapshot =
based qcow images. That, by it&#39;s<br>very nature, generates fragmented i=
mage files as they are a delta<br>over the backing file.<br><br>....<br><bl=
ockquote type=3D"cite">actual 48421430, ideal 20716, fragmentation factor 9=
9.96%<br><br>How can I solve this problem, what do you suggest me to do?<br=
></blockquote><br>Use a extent size hint (say 1-8MB) for your qcow2 image f=
iles so that<br>they don&#39;t fragment badly as they are written to. <br><=
br>Cheers,<br><br>Dave.<br>-- <br>Dave Chinner<br><a href=3D"mailto:david@f=
romorbit.com" target=3D"_blank">david@fromorbit.com</a><br></div></div></bl=
ockquote></div><br></div></div></div></div></blockquote></div><br><br clear=
=3D"all"><br>-- <br><div class=3D"gmail_signature" data-smartmail=3D"gmail_=
signature"><div dir=3D"ltr"><div>---<br>Blog: <a href=3D"http://www.chenzon=
gzhi.info" target=3D"_blank">http://www.chenzongzhi.info</a><br>Twitter: <a=
 href=3D"https://twitter.com/#%21/baotiao" target=3D"_blank">https://twitte=
r.com/baotiao</a><br>Git: <a href=3D"https://github.com/baotiao" target=3D"=
_blank">https://github.com/baotiao</a><br></div></div></div>
</div>

--001a11c1248afd1fdc05341a561f--


--===============6826909824824552203==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6826909824824552203==--
