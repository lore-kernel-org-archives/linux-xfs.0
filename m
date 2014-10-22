Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 025D87F50
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 05:29:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B8A1230405F
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 03:29:51 -0700 (PDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id qSk8UQTczCHbCwZz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Oct 2014 03:29:49 -0700 (PDT)
Received: by mail-la0-f48.google.com with SMTP id gi9so2589012lab.21
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2014 03:29:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413901892-17117-1-git-send-email-jack@suse.cz>
References: <1413901892-17117-1-git-send-email-jack@suse.cz>
Date: Wed, 22 Oct 2014 18:29:48 +0800
Message-ID: <CAJwOSj85TxdEC2huwAV8s4VFj5WwOogFrBc18SZt_8b0Q+SLCg@mail.gmail.com>
Subject: Re: [PATCH] xfs: Check error during inode btree iteration in
	xfs_bulkstat()
From: jie liu <jeff.u.liu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4162742032109589473=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

--===============4162742032109589473==
Content-Type: multipart/alternative; boundary=001a11348be85c81a00506006d32

--001a11348be85c81a00506006d32
Content-Type: text/plain; charset=UTF-8

Looks good to me.  Reviewed-by: Jie Liu <jeff.u.liu@gmail.com>


Cheers,
-Jeff

On Tue, Oct 21, 2014 at 10:31 PM, Jan Kara <jack@suse.cz> wrote:

> xfs_bulkstat() doesn't check error return from xfs_btree_increment(). In
> case of specific fs corruption that could result in xfs_bulkstat()
> entering an infinite loop because we would be looping over the same
> chunk over and over again. Fix the problem by checking the return value
> and terminating the loop properly.
>
> Coverity-id: 1231338
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_itable.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index f1deb961a296..66d5c619517d 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -474,6 +474,10 @@ xfs_bulkstat(
>                          */
>                         agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>                         error = xfs_btree_increment(cur, 0, &tmp);
> +                       if (error) {
> +                               end_of_ag = 1;
> +                               break;
> +                       }
>                         cond_resched();
>                 }
>                 /*
> --
> 1.8.1.4
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--001a11348be85c81a00506006d32
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Looks good to me.=C2=A0 Reviewed-by: Jie Liu &lt;<a href=
=3D"mailto:jeff.u.liu@gmail.com">jeff.u.liu@gmail.com</a>&gt;<div><br></div=
><div><br></div><div>Cheers,</div><div>-Jeff</div></div><div class=3D"gmail=
_extra"><br><div class=3D"gmail_quote">On Tue, Oct 21, 2014 at 10:31 PM, Ja=
n Kara <span dir=3D"ltr">&lt;<a href=3D"mailto:jack@suse.cz" target=3D"_bla=
nk">jack@suse.cz</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">xf=
s_bulkstat() doesn&#39;t check error return from xfs_btree_increment(). In<=
br>
case of specific fs corruption that could result in xfs_bulkstat()<br>
entering an infinite loop because we would be looping over the same<br>
chunk over and over again. Fix the problem by checking the return value<br>
and terminating the loop properly.<br>
<br>
Coverity-id: 1231338<br>
Signed-off-by: Jan Kara &lt;<a href=3D"mailto:jack@suse.cz">jack@suse.cz</a=
>&gt;<br>
---<br>
=C2=A0fs/xfs/xfs_itable.c | 4 ++++<br>
=C2=A01 file changed, 4 insertions(+)<br>
<br>
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c<br>
index f1deb961a296..66d5c619517d 100644<br>
--- a/fs/xfs/xfs_itable.c<br>
+++ b/fs/xfs/xfs_itable.c<br>
@@ -474,6 +474,10 @@ xfs_bulkstat(<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 agino =3D r.ir_startino + XFS_INODES_PER_CHUNK;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 error =3D xfs_btree_increment(cur, 0, &amp;tmp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (error) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0end_of_ag =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cond_resched();<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.8.1.4<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</font></span></blockquote></div><br></div>

--001a11348be85c81a00506006d32--


--===============4162742032109589473==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4162742032109589473==--
