Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 475CB29E17
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 10:25:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C329DAC003
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 08:25:50 -0700 (PDT)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	JJxjbvsVmKDn2tyu (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 08:25:49 -0700 (PDT)
Received: by mail-ie0-f175.google.com with SMTP id c12so8470606ieb.20
	for <xfs@oss.sgi.com>; Tue, 09 Apr 2013 08:25:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5164327C.6060808@sandeen.net>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<51642E5E.3040403@sandeen.net>
	<CADFMGuL7968v6L-3=j3FY3YYjeA_XH1CyuLgnL88u-abxiwHvg@mail.gmail.com>
	<5164327C.6060808@sandeen.net>
Date: Tue, 9 Apr 2013 23:25:48 +0800
Message-ID: <CADFMGu+DhNv=wo5GDrCz5j=_w6BF3w_neTGMPxejKZAL6hqrBg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6094548599218897860=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============6094548599218897860==
Content-Type: multipart/alternative; boundary=089e0111e07407255304d9ef2bf6

--089e0111e07407255304d9ef2bf6
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Yes it was executed after a mount/umount because it is configured in fstab
and I reboot the system then it was mounted and then I umount it to run
xfs_repair.


2013/4/9 Eric Sandeen <sandeen@sandeen.net>

> On 4/9/13 10:18 AM, =B7=FB=D3=C0=CC=CE wrote:
> > The servers are back to service now and It's hard to run xfs_repair.
> > It always happen bellow is the xfs_repair log when it happens on
> > another server several days ago.
>
> >  -sh-4.1$ sudo xfs_repair -n /dev/glustervg/glusterlv
>
> Ok; just for what its worth, if you don't mount/umount first,
> you may be running repair -n with a dirty log, and it will
> find "more" corruption than it should, since the log is not
> replayed.
>
> I see that you included a non "-n" repair log as well, was
> that after a mount/umount?  Just to be sure...
>
> Thanks,
> -Eric
>
>
>


--=20
=B7=FB=D3=C0=CC=CE

--089e0111e07407255304d9ef2bf6
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Yes it was executed after a mount/umount because it is con=
figured in fstab and I reboot the system then it was mounted and then I umo=
unt it to run xfs_repair.<br></div><div class=3D"gmail_extra"><br><br><div =
class=3D"gmail_quote">
2013/4/9 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sande=
en.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">
<div class=3D"im">On 4/9/13 10:18 AM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; The servers are back to service now and It&#39;s hard to run xfs_repai=
r.<br>
&gt; It always happen bellow is the xfs_repair log when it happens on<br>
&gt; another server several days ago.<br>
<br>
&gt; &nbsp;-sh-4.1$ sudo xfs_repair -n /dev/glustervg/glusterlv<br>
<br>
</div>Ok; just for what its worth, if you don&#39;t mount/umount first,<br>
you may be running repair -n with a dirty log, and it will<br>
find &quot;more&quot; corruption than it should, since the log is not<br>
replayed.<br>
<br>
I see that you included a non &quot;-n&quot; repair log as well, was<br>
that after a mount/umount? &nbsp;Just to be sure...<br>
<br>
Thanks,<br>
-Eric<br>
<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--089e0111e07407255304d9ef2bf6--


--===============6094548599218897860==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6094548599218897860==--
