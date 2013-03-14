Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C41B17F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 20:28:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39273AC002
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 18:28:41 -0700 (PDT)
Received: from mail-ia0-f171.google.com (mail-ia0-f171.google.com
	[209.85.210.171]) by cuda.sgi.com with ESMTP id
	27atkVZ26tW6p2yn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 18:28:39 -0700 (PDT)
Received: by mail-ia0-f171.google.com with SMTP id z13so1582033iaz.2
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 18:28:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130313234213.GW21651@dastard>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
	<CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
	<5140CBE3.80705@sandeen.net> <20130313234213.GW21651@dastard>
From: Shrinath M <shrinath.m@webyog.com>
Date: Thu, 14 Mar 2013 06:58:19 +0530
Message-ID: <CAOdS1hnVoMtXnOrECrU8xUyRn82UUJ=jMzX0_odnAs0GH8V-yA@mail.gmail.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0540918808216936943=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Supratik Goswami <supratik.goswami@webyog.com>, Ric Wheeler <rwheeler@redhat.com>

--===============0540918808216936943==
Content-Type: multipart/alternative; boundary=14dae93408e7376fd604d7d871a7

--14dae93408e7376fd604d7d871a7
Content-Type: text/plain; charset=UTF-8

Thanks Ben, Dave and Eric.

Eric,
>>but I am wondering if there might be more information before this which
is not in your trimmed logs.
No, this was the first entry every time we have it in /var/log/messages.
dmesg also holds the same. After reboot, it simply fixes without anyone
doing anything.

The Linux we are running is definitely amazon baked one, looks like this -
$~: uname -a Linux ip-100-0-100-1 3.2.34-55.46.amzn1.x86_64 #1 SMP Tue Nov
20 10:06:15 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

 - dmesg shows something like this after repairing/rebooting -

[    8.414176] SGI XFS with ACLs, security attributes, realtime, large
block/inode numbers, no debug enabled
[    8.415342] SGI XFS Quota Management subsystem
[    8.417664] XFS (md0): Mounting Filesystem
[    8.771553] XFS (md0): Starting recovery (logdev: internal)
[    9.977325] XFS (md0): Ending recovery (logdev: internal)

Check the first line there, it says no debug enabled. How good/bad is this
debug mode in production environments? We are not getting any corruption in
our local/test environments, in production, we are getting it once on every
third day.

Dave,
You say unlinked inode list, but if that, it should have an entry in
/var/log/messages, right?
Anyway, how can we create this situation? By forcing multiple processes to
write/delete files from small disk? Since we are still unaware of what is
causing this issue, reproducing it in local/production environment is just
shooting in dark... :(

Does turning up the error level affect the data in any way? Or is it *just*
detailed good logging while being sensitive to all small errors?


Really appreciate the support that you devs are giving which really is the
job of AWS support... I so wish they had some helpful and knowledgeable
people in support.



On Thu, Mar 14, 2013 at 5:12 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Mar 13, 2013 at 01:56:35PM -0500, Eric Sandeen wrote:
> > XFS (md0): xfs_iunlink_remove: xfs_itobp() returned error 117.
>
> Corrupted unlinked inode list. You need to run xfs_repair to fix
> this.
>
> Chers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



-- 
Regards
*Shrinath.M*

--14dae93408e7376fd604d7d871a7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Ben, Dave and Eric.=C2=A0<div><br></div><div style>=
Eric,=C2=A0</div><div style>&gt;&gt;<span style=3D"font-family:arial,sans-s=
erif;font-size:13px">but I am wondering if there might be more information =
before this which is not in your trimmed logs.</span></div>

No, this was the first entry every time we have it in /var/log/messages. dm=
esg also holds the same. After reboot, it simply fixes without anyone doing=
 anything.<div><br></div><div style>The Linux we are running is definitely =
amazon baked one, looks like this -=C2=A0</div>

<div style><div style=3D"font-family:arial,sans-serif;font-size:13px"><font=
 color=3D"#000000"><span style=3D"white-space:pre-wrap"><font face=3D"couri=
er new, monospace">$~: <span class=3D"">uname</span> -a
Linux ip-100-0-100-1 3.2.34-55.46.amzn1.x86_64 #1 SMP Tue Nov 20 10:06:15 U=
TC 2012 x86_64 x86_64 x86_64 GNU/Linux</font></span></font></div><div style=
=3D"font-family:arial,sans-serif;font-size:13px"><font color=3D"#000000"><s=
pan style=3D"white-space:pre-wrap"><font face=3D"courier new, monospace"><b=
r>

</font></span></font></div><div style=3D"font-family:arial,sans-serif;font-=
size:13px"><span style=3D"font-family:arial;font-size:small">=C2=A0- dmesg =
shows something like this after repairing/rebooting -=C2=A0</span></div><di=
v style=3D"font-family:arial,sans-serif;font-size:13px">

<span style=3D"font-family:arial;font-size:small"><br></span></div><div><di=
v>[ =C2=A0 =C2=A08.414176] SGI XFS with ACLs, security attributes, realtime=
, large block/inode numbers, no debug enabled</div><div>[ =C2=A0 =C2=A08.41=
5342] SGI XFS Quota Management subsystem</div>

<div>[ =C2=A0 =C2=A08.417664] XFS (md0): Mounting Filesystem</div><div>[ =
=C2=A0 =C2=A08.771553] XFS (md0): Starting recovery (logdev: internal)</div=
><div>[ =C2=A0 =C2=A09.977325] XFS (md0): Ending recovery (logdev: internal=
)</div><div style=3D"font-family:arial;font-size:small">

<br></div></div><div style=3D"font-family:arial,sans-serif;font-size:13px">=
<span style=3D"font-family:arial;font-size:small">Check the first line ther=
e, it says no debug enabled. How good/bad is this debug mode in production =
environments? We are not getting any corruption in our local/test environme=
nts, in production, we are getting it once on every third day.</span></div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><span style=3D"f=
ont-family:arial;font-size:small"><br></span></div><div style=3D"font-famil=
y:arial,sans-serif;font-size:13px"><span style=3D"font-family:arial;font-si=
ze:small">Dave,=C2=A0</span></div>

<div style=3D"font-family:arial,sans-serif;font-size:13px"><span style=3D"f=
ont-family:arial;font-size:small">You say unlinked inode list, but if that,=
 it should have an entry in /var/log/messages, right?</span></div><div styl=
e=3D"font-family:arial,sans-serif;font-size:13px">

<span style=3D"font-family:arial;font-size:small">Anyway, how can we create=
 this situation? By forcing multiple processes to write/delete files from s=
mall disk? Since we are still unaware of what is causing this issue, reprod=
ucing it in local/production environment is just shooting in dark... :(</sp=
an><br>

</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><span styl=
e=3D"font-family:arial;font-size:small"><br></span></div><div style>Does tu=
rning up the error level affect the data in any way? Or is it *just* detail=
ed good logging while being sensitive to all small errors?</div>

<div style><br></div><div style><br></div><div style>Really appreciate the =
support that you devs are giving which really is the job of AWS support... =
I so wish they had some helpful and knowledgeable people in support.</div>

<div style><br></div><div style><br></div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Thu, Mar 14, 2013 at 5:12 AM, Dave Chinne=
r <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_b=
lank">david@fromorbit.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Mar 13, 2013 at 01=
:56:35PM -0500, Eric Sandeen wrote:<br>
&gt; XFS (md0): xfs_iunlink_remove: xfs_itobp() returned error 117.<br>
<br>
</div>Corrupted unlinked inode list. You need to run xfs_repair to fix<br>
this.<br>
<br>
Chers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><font face=3D"&#39;courier new&#39;, monospace" color=3D"#666666">Regards=
</font><div><b><font face=3D"&#39;courier new&#39;, monospace" color=3D"#66=
6666">Shrinath.M</font></b></div>

<div><br></div>
</div></div>

--14dae93408e7376fd604d7d871a7--


--===============0540918808216936943==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0540918808216936943==--
