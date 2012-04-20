Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3KFkdD0238476 for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 10:46:40 -0500
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	uJJgB0ueP0NccXMq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Apr 2012 08:46:38 -0700 (PDT)
Received: by ghbz13 with SMTP id z13so7376035ghb.26
	for <xfs@oss.sgi.com>; Fri, 20 Apr 2012 08:46:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F917B77.6040403@sandeen.net>
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
	<4F917B77.6040403@sandeen.net>
From: Drew Wareham <m3rlin@gmail.com>
Date: Sat, 21 Apr 2012 01:46:17 +1000
Message-ID: <CALcU-6i3MY+Z-dFzE5p34DSMxcQi2dPdXZHenh+=5TObyiB8eQ@mail.gmail.com>
Subject: Re: xfs_check segfault / xfs_repair I/O error
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2423564708856153774=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============2423564708856153774==
Content-Type: multipart/alternative; boundary=14dae9340bdda14dca04be1e31da

--14dae9340bdda14dca04be1e31da
Content-Type: text/plain; charset=UTF-8

Hey Eric,

Good point!  We're running CentOS 5, so is the CentOS-Plus repo the way to
go?  These servers are all setup from a fairly old base image hence using
kmod-xfs, definitely something I'll address.

Cheers


On Sat, Apr 21, 2012 at 1:06 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/15/12 8:15 AM, Drew Wareham wrote:
> > Hello Everyone,
> >
> > Hopefully this is the correct kind of information to send to this list.
> >
> > I have an issue with a large XFS volume (17TB) that mounts, but is not
> readable.  I can view the folder structure on the volume but I can't access
> any of the actual data.  A disk failed in a RAID5 array and while it has
> rebuilt now, it looks like it's caused serious data integrity issues.
> >
> > Here is the CentOS release / Kernel version:
> >     [root@svr608 ~]# uname -a
> >     Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012
> x86_64 x86_64 x86_64 GNU/Linux
> >     [root@svr608 ~]# cat /etc/redhat-release
> >     CentOS release 5.8 (Final)
> >     [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
> >     kmod-xfs.x86_64                            0.4-2
>   installed
>
> You reall, Really, REALLY, *REALLY* want to remove kmod-xfs.
>
> RHEL5 has been shipping with supported xfs for what, 2 years now, and that
> old kmod-xfs
> is an ancient, ancient piece of unmaintained, bitrotting code.  Sadly it
> overrides
> the kernel rpm's xfs.ko.  I don't know if this is the root cause of your
> problem; probably
> not, but eventually it will likely be the root cause of some other problem
> :)
>
> -Eric
>

--14dae9340bdda14dca04be1e31da
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hey Eric,<br><br>Good point!=C2=A0 We&#39;re running CentOS 5, so is the Ce=
ntOS-Plus repo the way to go?=C2=A0 These servers are all setup from a fair=
ly old base image hence using kmod-xfs, definitely something I&#39;ll addre=
ss.<br>

<br>Cheers<br>
<br><br><div class=3D"gmail_quote">On Sat, Apr 21, 2012 at 1:06 AM, Eric Sa=
ndeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@=
sandeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div class=3D"im">On 4/15/12 8:15 AM, Drew Wareham wrote:<br>
&gt; Hello Everyone,<br>
&gt;<br>
&gt; Hopefully this is the correct kind of information to send to this list=
.<br>
&gt;<br>
&gt; I have an issue with a large XFS volume (17TB) that mounts, but is not=
 readable. =C2=A0I can view the folder structure on the volume but I can&#3=
9;t access any of the actual data. =C2=A0A disk failed in a RAID5 array and=
 while it has rebuilt now, it looks like it&#39;s caused serious data integ=
rity issues.<br>


&gt;<br>
&gt; Here is the CentOS release / Kernel version:<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# uname -a<br>
&gt; =C2=A0 =C2=A0 Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:5=
1 EST 2012 x86_64 x86_64 x86_64 GNU/Linux<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# cat /etc/redhat-release<br>
&gt; =C2=A0 =C2=A0 CentOS release 5.8 (Final)<br>
&gt; =C2=A0 =C2=A0 [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep ins=
talled<br>
&gt; =C2=A0 =C2=A0 kmod-xfs.x86_64 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00.4-2 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 installe=
d<br>
<br>
</div>You reall, Really, REALLY, *REALLY* want to remove kmod-xfs.<br>
<br>
RHEL5 has been shipping with supported xfs for what, 2 years now, and that =
old kmod-xfs<br>
is an ancient, ancient piece of unmaintained, bitrotting code. =C2=A0Sadly =
it overrides<br>
the kernel rpm&#39;s xfs.ko. =C2=A0I don&#39;t know if this is the root cau=
se of your problem; probably<br>
not, but eventually it will likely be the root cause of some other problem =
:)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br>
</font></span></blockquote></div><br>

--14dae9340bdda14dca04be1e31da--


--===============2423564708856153774==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2423564708856153774==--
