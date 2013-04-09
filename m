Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E7FD7FC7
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:49:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18622AC003
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:49:03 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	4vlVH5JiyqBgDpYF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:49:02 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id c10so8566129ieb.17
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 08:49:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGu+N+aE-PENHcn6fOLxrJtHVWkG_meMFaFZjrT4bFX2iQQ@mail.gmail.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
	<CADFMGuLu5Vz6=7rBU5ECPxupcxWS5rk8j0BKkX6kyJSdGgSrXg@mail.gmail.com>
	<51643749.5080800@sandeen.net>
	<CADFMGu+N+aE-PENHcn6fOLxrJtHVWkG_meMFaFZjrT4bFX2iQQ@mail.gmail.com>
Date: Tue, 9 Apr 2013 23:49:01 +0800
Message-ID: <CADFMGuJTYCRet9yb8qG2f1yK8kOs+c0DGi1OXwEWke8ACmn+LQ@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6187149963148504522=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============6187149963148504522==
Content-Type: multipart/alternative; boundary=14dae934086508883604d9ef7e7c

--14dae934086508883604d9ef7e7c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Or some useful debug tips?


2013/4/9 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> I'll work on reproducing the issue, can you share some tracing script to
> me? Thank you.
>
>
> 2013/4/9 Eric Sandeen <sandeen@sandeen.net>
>
>> On 4/9/13 10:23 AM, =B7=FB=D3=C0=CC=CE wrote:
>> > So my question is why xfs shutdown always  happens? With same
>> > reason(xfs_iunlink_remove: xfs_inotobp() returned error 22
>> > xfs_inactive: xfs_ifree returned error 22 xfs_do_force_shutdown).
>> > The server load is high and is it related?
>>
>> We don't know yet.  :)
>>
>> I'd like to know what was passed to xfs_inotobp when it shut down,
>> and what caused the EINVAL (22) return.  Perhaps some tracing
>> or systemtap scripts could to it.
>>
>> If you only hit this every few weeks, though, it's going to be
>> difficult to catch.
>>
>> -Eric
>>
>> > free -m
>> >              total       used       free     shared    buffers
>> cached
>> > Mem:        129016     128067        948          0         10
>> 119905
>> > -/+ buffers/cache:       8150     120865
>> > Swap:         4093          0       4093
>> >
>> >
>>
>>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--14dae934086508883604d9ef7e7c
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Or some useful debug tips?<br></div><div class=3D"gmail_ex=
tra"><br><br><div class=3D"gmail_quote">2013/4/9 =B7=FB=D3=C0=CC=CE <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yon=
gtaofu@gmail.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr">I&#39;ll work on reproducin=
g the issue, can you share some tracing script to me? Thank you.<br></div><=
div class=3D"gmail_extra">
<div><div class=3D"h5"><br><br><div class=3D"gmail_quote">2013/4/9 Eric San=
deen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D=
"_blank">sandeen@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div>On 4/9/13 10:23 AM, =B7=FB=D3=C0=CC=CE =
wrote:<br>
&gt; So my question is why xfs shutdown always &nbsp;happens? With same<br>
&gt; reason(xfs_iunlink_remove: xfs_inotobp() returned error 22<br>
&gt; xfs_inactive: xfs_ifree returned error 22 xfs_do_force_shutdown).<br>
&gt; The server load is high and is it related?<br>
<br>
</div>We don&#39;t know yet. &nbsp;:)<br>
<br>
I&#39;d like to know what was passed to xfs_inotobp when it shut down,<br>
and what caused the EINVAL (22) return. &nbsp;Perhaps some tracing<br>
or systemtap scripts could to it.<br>
<br>
If you only hit this every few weeks, though, it&#39;s going to be<br>
difficult to catch.<br>
<span><font color=3D"#888888"><br>
-Eric<br>
</font></span><div><div><br>
&gt; free -m<br>
&gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;total &nbsp; &nbsp; &n=
bsp; used &nbsp; &nbsp; &nbsp; free &nbsp; &nbsp; shared &nbsp; &nbsp;buffe=
rs &nbsp; &nbsp; cached<br>
&gt; Mem: &nbsp; &nbsp; &nbsp; &nbsp;129016 &nbsp; &nbsp; 128067 &nbsp; &nb=
sp; &nbsp; &nbsp;948 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 &nbsp; &nbsp; &nbs=
p; &nbsp; 10 &nbsp; &nbsp; 119905<br>
&gt; -/+ buffers/cache: &nbsp; &nbsp; &nbsp; 8150 &nbsp; &nbsp; 120865<br>
&gt; Swap: &nbsp; &nbsp; &nbsp; &nbsp; 4093 &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp;0 &nbsp; &nbsp; &nbsp; 4093<br>
&gt;<br>
&gt;<br>
<br>
</div></div></blockquote></div><br><br clear=3D"all"><br></div></div><span =
class=3D"HOEnZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--14dae934086508883604d9ef7e7c--


--===============6187149963148504522==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6187149963148504522==--
