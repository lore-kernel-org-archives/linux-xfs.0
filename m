Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 53ED67CA0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 02:22:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2759230404E
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:22:13 -0700 (PDT)
Received: from mail-lb0-f194.google.com (mail-lb0-f194.google.com
	[209.85.217.194]) by cuda.sgi.com with ESMTP id
	zBrQwR6ksubQHC8J (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:22:10 -0700 (PDT)
Received: by mail-lb0-f194.google.com with SMTP id bc4so10335141lbc.0
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 00:22:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160321063848.GK11812@dastard>
References: <CANq6e6jjBqis7dhTTPST+bKDbwvYDbzvPg3G7V3eiD-+OB2U7A@mail.gmail.com>
	<20160321063848.GK11812@dastard>
Date: Mon, 21 Mar 2016 08:22:09 +0100
Message-ID: <CANq6e6gHuZsb-g_WAHH5sypedtUb0i6UADp5B=Rio7Cw=G9z1w@mail.gmail.com>
Subject: Re: obtaining xfstests repository
From: Sonia mandelbrott <sonia.mandelbrott@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2007106112715298260=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2007106112715298260==
Content-Type: multipart/alternative; boundary=047d7b3a822463d13a052e89f4b1

--047d7b3a822463d13a052e89f4b1
Content-Type: text/plain; charset=UTF-8

Thank you for your replies, here is output when used your link:

-bash-4.2$ git clone git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
Cloning into 'xfstests-dev'...
fatal: unable to connect to git.kernel.org:
git.kernel.org[0: 149.20.4.72]: errno=Connection timed out
git.kernel.org[1: 199.204.44.194]: errno=Connection timed out
git.kernel.org[2: 198.145.20.140]: errno=Connection timed out
git.kernel.org[3: 2620:3:c000:a:0:1991:8:25]: errno=Network is unreachable
git.kernel.org[4: 2001:4f8:1:10:0:1991:8:25]: errno=Network is unreachable


On Mon, Mar 21, 2016 at 7:38 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Mar 21, 2016 at 05:57:39AM +0100, Sonia mandelbrott wrote:
> > Hi. This might sound stupid to you, but I have gotproblem with obtaining
> > xfstests repo.
> > When I try git clone git://oss.sgi.com/xfs/cmds/xfstests
> > I get timeout after several minutes. I think it is problem with ssh keys?
> > Can You possibly guide me step by step what I need to do?
> > Sorry for all the trouble,
>
> Just use this repository:
>
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b3a822463d13a052e89f4b1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Thank you for your replies, here is output when used =
your link:</div><div><br></div><div>-bash-4.2$ git clone git://<a href=3D"h=
ttp://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git">git.kernel.org/pub/sc=
m/fs/xfs/xfstests-dev.git</a></div><div>Cloning into &#39;xfstests-dev&#39;=
...</div><div>fatal: unable to connect to <a href=3D"http://git.kernel.org"=
>git.kernel.org</a>:</div><div><a href=3D"http://git.kernel.org">git.kernel=
.org</a>[0: 149.20.4.72]: errno=3DConnection timed out</div><div><a href=3D=
"http://git.kernel.org">git.kernel.org</a>[1: 199.204.44.194]: errno=3DConn=
ection timed out</div><div><a href=3D"http://git.kernel.org">git.kernel.org=
</a>[2: 198.145.20.140]: errno=3DConnection timed out</div><div><a href=3D"=
http://git.kernel.org">git.kernel.org</a>[3: 2620:3:c000:a:0:1991:8:25]: er=
rno=3DNetwork is unreachable</div><div><a href=3D"http://git.kernel.org">gi=
t.kernel.org</a>[4: 2001:4f8:1:10:0:1991:8:25]: errno=3DNetwork is unreacha=
ble</div><div><br></div></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Mon, Mar 21, 2016 at 7:38 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Mon, Mar 21, 2016 at 05:57:39AM +0100, Sonia mandelbrott wrote:<br=
>
&gt; Hi. This might sound stupid to you, but I have gotproblem with obtaini=
ng<br>
&gt; xfstests repo.<br>
&gt; When I try git clone git://<a href=3D"http://oss.sgi.com/xfs/cmds/xfst=
ests" rel=3D"noreferrer" target=3D"_blank">oss.sgi.com/xfs/cmds/xfstests</a=
><br>
&gt; I get timeout after several minutes. I think it is problem with ssh ke=
ys?<br>
&gt; Can You possibly guide me step by step what I need to do?<br>
&gt; Sorry for all the trouble,<br>
<br>
</span>Just use this repository:<br>
<br>
git://<a href=3D"http://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git" rel=
=3D"noreferrer" target=3D"_blank">git.kernel.org/pub/scm/fs/xfs/xfstests-de=
v.git</a><br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--047d7b3a822463d13a052e89f4b1--


--===============2007106112715298260==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2007106112715298260==--
