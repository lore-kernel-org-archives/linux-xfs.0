Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 53DC729DF9
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 17:12:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 316FE8F804B
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:12:26 -0700 (PDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
	[209.85.212.171]) by cuda.sgi.com with ESMTP id
	rE14Z9Vxog1xz3Vr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 15:12:24 -0700 (PDT)
Received: by mail-wi0-f171.google.com with SMTP id ho1so5813071wib.10
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 15:12:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5839367.DyqsVHbRuQ@myrada>
References: <5839367.DyqsVHbRuQ@myrada>
Date: Tue, 23 Sep 2014 18:12:22 -0400
Message-ID: <CAA43vkWP5MEv=EoUxthjniyiiLm8hZNSS-agcm2C3dBDMXQ8Zw@mail.gmail.com>
Subject: Re: Corrupted file system
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9024299704797146337=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Diane Trout <diane@caltech.edu>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============9024299704797146337==
Content-Type: multipart/alternative; boundary=f46d043c08e8972c060503c2dc8f

--f46d043c08e8972c060503c2dc8f
Content-Type: text/plain; charset=UTF-8

Hi Diane,

Probably best to reformat and restore from a backup at this point. I'm
notorious for my views on xfs_repair but most folks here will agree that in
the case where there has been a major underlying array failure, there is
not much it can do to help. Better to just mount ro,noreplaylog and get
what you can in these sorts of scenarios, IMO.

"Did you try the latest copy of xfs_repair"? Sometimes it will get further
or not crash, but it likely will still maul whatever's left of your
filesystem.

Best of luck,

Sean


On Tue, Sep 23, 2014 at 6:02 PM, Diane Trout <diane@caltech.edu> wrote:

> Hi,
>
> I had a raid failure at work that ended up corrupting an xfs filesystem the
> tail of the xfs_repair command looks like the below. I was able to
> generate a
> metadata dump but is there a point to making it available?
>
> It does crash repeatedly at the same place
>
> (I'm not subscribed to the list, so could you reply directly as well?)
>
> disconnected inode 15276, moving to lost+found
> disconnected inode 15277, moving to lost+found
> disconnected inode 15278, moving to lost+found
> disconnected inode 15279, moving to lost+found
> disconnected inode 15280, moving to lost+found
> disconnected inode 15281, moving to lost+found
> disconnected inode 15282, moving to lost+found
> disconnected inode 15283, moving to lost+found
> disconnected inode 15284, moving to lost+found
> disconnected inode 15286, moving to lost+found
> disconnected inode 15287, moving to lost+found
> disconnected inode 15288, moving to lost+found
> disconnected inode 15289, moving to lost+found
> disconnected inode 15290, moving to lost+found
> disconnected inode 15291, moving to lost+found
> disconnected inode 15292, moving to lost+found
> disconnected inode 15293, moving to lost+found
> disconnected inode 15294, moving to lost+found
> disconnected inode 15295, moving to lost+found
> disconnected inode 15360, moving to lost+found
> corrupt dinode 15360, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x7f369883e6f0)
>
> fatal error -- 117 - couldn't iget disconnected inode
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

--f46d043c08e8972c060503c2dc8f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Diane,<div><br></div><div>Probably best to reformat and=
 restore from a backup at this point. I&#39;m notorious for my views on xfs=
_repair but most folks here will agree that in the case where there has bee=
n a major underlying array failure, there is not much it can do to help. Be=
tter to just mount ro,noreplaylog and get what you can in these sorts of sc=
enarios, IMO.</div><div><br></div><div>&quot;Did you try the latest copy of=
 xfs_repair&quot;? Sometimes it will get further or not crash, but it likel=
y will still maul whatever&#39;s left of your filesystem.</div><div><br></d=
iv><div>Best of luck,</div><div><br></div><div>Sean</div><div><br></div></d=
iv><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Sep 23=
, 2014 at 6:02 PM, Diane Trout <span dir=3D"ltr">&lt;<a href=3D"mailto:dian=
e@caltech.edu" target=3D"_blank">diane@caltech.edu</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex">Hi,<br>
<br>
I had a raid failure at work that ended up corrupting an xfs filesystem the=
<br>
tail of the xfs_repair command looks like the below. I was able to generate=
 a<br>
metadata dump but is there a point to making it available?<br>
<br>
It does crash repeatedly at the same place<br>
<br>
(I&#39;m not subscribed to the list, so could you reply directly as well?)<=
br>
<br>
disconnected inode 15276, moving to lost+found<br>
disconnected inode 15277, moving to lost+found<br>
disconnected inode 15278, moving to lost+found<br>
disconnected inode 15279, moving to lost+found<br>
disconnected inode 15280, moving to lost+found<br>
disconnected inode 15281, moving to lost+found<br>
disconnected inode 15282, moving to lost+found<br>
disconnected inode 15283, moving to lost+found<br>
disconnected inode 15284, moving to lost+found<br>
disconnected inode 15286, moving to lost+found<br>
disconnected inode 15287, moving to lost+found<br>
disconnected inode 15288, moving to lost+found<br>
disconnected inode 15289, moving to lost+found<br>
disconnected inode 15290, moving to lost+found<br>
disconnected inode 15291, moving to lost+found<br>
disconnected inode 15292, moving to lost+found<br>
disconnected inode 15293, moving to lost+found<br>
disconnected inode 15294, moving to lost+found<br>
disconnected inode 15295, moving to lost+found<br>
disconnected inode 15360, moving to lost+found<br>
corrupt dinode 15360, extent total =3D 1, nblocks =3D 0.=C2=A0 This is a bu=
g.<br>
Please capture the filesystem metadata with xfs_metadump and<br>
report it to <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>.<br>
cache_node_purge: refcount was 1, not zero (node=3D0x7f369883e6f0)<br>
<br>
fatal error -- 117 - couldn&#39;t iget disconnected inode<br>
<br>
<br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br>
</blockquote></div><br></div>

--f46d043c08e8972c060503c2dc8f--


--===============9024299704797146337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9024299704797146337==--
