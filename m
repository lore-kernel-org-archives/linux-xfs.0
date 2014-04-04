Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC2D87FF8
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 14:47:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51700AC012
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 12:47:32 -0700 (PDT)
Received: from mail-vc0-f175.google.com (mail-vc0-f175.google.com
	[209.85.220.175]) by cuda.sgi.com with ESMTP id
	esplIrFApjn4o1VQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 12:47:30 -0700 (PDT)
Received: by mail-vc0-f175.google.com with SMTP id lh14so3455567vcb.6
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 12:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533EFF07.6050308@hardwarefreak.com>
References: <CALjwKZAJ-R8dS13Rsj3+K3hM9p0z08qvi4ZVTYbDWKT1Biu=-Q@mail.gmail.com>
	<533EFF07.6050308@hardwarefreak.com>
Date: Fri, 4 Apr 2014 13:47:28 -0600
Message-ID: <CALjwKZD-ccdjE7cRbQoEaLzcwPmXr9MBhB2dKsjUX9MGAaoc3Q@mail.gmail.com>
Subject: Re: xfs umount with i/o error hang/memory corruption
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7902778682393266114=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============7902778682393266114==
Content-Type: multipart/alternative; boundary=047d7b6783ceae22de04f63cc9de

--047d7b6783ceae22de04f63cc9de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2014 at 12:50 PM, Stan Hoeppner <stan@hardwarefreak.com>wrot=
e:

> On 4/4/2014 1:15 PM, Bob Mastors wrote:
> > Greetings,
> >
> > I am new to xfs and am running into a problem
> > and would appreciate any guidance on how to proceed.
> >
> > After an i/o error from the block device that xfs is using,
> > an umount results in a message like:
> > [  370.636473] XFS (sdx): Log I/O Error Detected.  Shutting down
> filesystem
> > [  370.644073] XFS (h           =EF=BF=BD=EF=BF=BD=EF=BF=BDh"h         =
 =EF=BF=BD=EF=BF=BD=EF=BF=BDH#h          =EF=BF=BD=EF=BF=BD=EF=BF=BDbsg):
> > Please umount the filesystem and rectify the problem(s)
> > Note the garbage on the previous line which suggests memory corruption.
> > About half the time I get the garbled log message. About half the time
> > umount hangs.
> >
> > And then I get this kind of error and the system is unresponsive:
> > Message from syslogd@debian at Apr  4 09:27:40 ...
> >  kernel:[  680.080022] BUG: soft lockup - CPU#2 stuck for 22s!
> [umount:2849]
> >
> > The problem appears to be similar to this issue:
> > http://www.spinics.net/lists/linux-xfs/msg00061.html
> >
> > I can reproduce the problem easily using open-iscsi to create
> > the block device with an iscsi initiator.
> > I use lio to create an iscsi target.
> >
> > The problem is triggered by doing an iscsi logout which causes
> > the block device to return i/o errors to xfs.
> > Steps to reproduce the problem are below.
>
> This is not a problem but the expected behavior.  XFS is designed to do
> this to prevent filesystem corruption.  Logging out of a LUN is no
> different than pulling the power plug on a direct attached disk drive.
> Surely you would not do that to a running filesystem.
>
Sorry, I don't think I was clear on the nature of the problem and it's wide
ranging effects.
Using iscsi to access block storage on another server is the goal.
A failure on the other server is possible which could result in the iscsi
initiator returning i/o errors to xfs.

The behavior that I would like from xfs is to put the filesystem in some
kind of offline state
on an i/o error from the block device. Today xfs usually has this desirable
behavior.
But there is a corner case were instead xfs hangs the entire server,
forcing a hard reboot.

On a large file server with many filesystems using iscsi to talk to block
storage on multiple
block servers, I would like the failure of a single block server to only
impact the filesystems
that are dependent on the block server, and to not impact the other
filesystems.

Bob

> Using VirtualBox, I can reproduce it with two processors but not one.
> > I first saw this on a 3.8 kernel and most recently reproduced it with
> 3.14+.
> ...
>
> The only problem I see here is that XFS should be shutting down every
> time the disk device disappears.  Which means in your test cases where
> it does not, your VM environment isn't passing the IO errors up the
> stack, and it should be.  Which means your VM environment is broken.
>
> Cheers,
>
> Stan
>
>
>

--047d7b6783ceae22de04f63cc9de
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On F=
ri, Apr 4, 2014 at 12:50 PM, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=3D=
"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com</a=
>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On 4/4/2014 1:15 PM, Bob Mas=
tors wrote:<br>
&gt; Greetings,<br>
&gt;<br>
&gt; I am new to xfs and am running into a problem<br>
&gt; and would appreciate any guidance on how to proceed.<br>
&gt;<br>
&gt; After an i/o error from the block device that xfs is using,<br>
&gt; an umount results in a message like:<br>
&gt; [ =C2=A0370.636473] XFS (sdx): Log I/O Error Detected. =C2=A0Shutting =
down filesystem<br>
&gt; [ =C2=A0370.644073] XFS (h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =EF=BF=
=BD=EF=BF=BD=EF=BF=BDh&quot;h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=
=EF=BF=BD=EF=BF=BDH#h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=EF=BF=BD=
=EF=BF=BDbsg):<br>
&gt; Please umount the filesystem and rectify the problem(s)<br>
&gt; Note the garbage on the previous line which suggests memory corruption=
.<br>
&gt; About half the time I get the garbled log message. About half the time=
<br>
&gt; umount hangs.<br>
&gt;<br>
&gt; And then I get this kind of error and the system is unresponsive:<br>
&gt; Message from syslogd@debian at Apr =C2=A04 09:27:40 ...<br>
&gt; =C2=A0kernel:[ =C2=A0680.080022] BUG: soft lockup - CPU#2 stuck for 22=
s! [umount:2849]<br>
&gt;<br>
&gt; The problem appears to be similar to this issue:<br>
&gt; <a href=3D"http://www.spinics.net/lists/linux-xfs/msg00061.html" targe=
t=3D"_blank">http://www.spinics.net/lists/linux-xfs/msg00061.html</a><br>
&gt;<br>
&gt; I can reproduce the problem easily using open-iscsi to create<br>
&gt; the block device with an iscsi initiator.<br>
&gt; I use lio to create an iscsi target.<br>
&gt;<br>
&gt; The problem is triggered by doing an iscsi logout which causes<br>
&gt; the block device to return i/o errors to xfs.<br>
&gt; Steps to reproduce the problem are below.<br>
<br>
</div>This is not a problem but the expected behavior. =C2=A0XFS is designe=
d to do<br>
this to prevent filesystem corruption. =C2=A0Logging out of a LUN is no<br>
different than pulling the power plug on a direct attached disk drive.<br>
Surely you would not do that to a running filesystem.<br></blockquote><div>=
Sorry, I don&#39;t think I was clear on the nature of the problem and it&#3=
9;s wide ranging effects.</div><div>Using iscsi to access block storage on =
another server is the goal.</div>
<div>A failure on the other server is possible which could result in the is=
csi initiator returning i/o errors to xfs.</div><div><br></div><div>The beh=
avior that I would like from xfs is to put the filesystem in some kind of o=
ffline state</div>
<div>on an i/o error from the block device. Today xfs usually has this desi=
rable behavior.</div><div>But there is a corner case were instead xfs hangs=
 the entire server, forcing a hard reboot.</div><div><br></div><div>On a la=
rge file server with many filesystems using iscsi to talk to block storage =
on multiple</div>
<div>block servers, I would like the failure of a single block server to on=
ly impact the filesystems</div><div>that are dependent on the block server,=
 and to not impact the other filesystems.</div><div><br></div><div>Bob</div=
>
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"">
&gt; Using VirtualBox, I can reproduce it with two processors but not one.<=
br>
&gt; I first saw this on a 3.8 kernel and most recently reproduced it with =
3.14+.<br>
</div>...<br>
<br>
The only problem I see here is that XFS should be shutting down every<br>
time the disk device disappears. =C2=A0Which means in your test cases where=
<br>
it does not, your VM environment isn&#39;t passing the IO errors up the<br>
stack, and it should be. =C2=A0Which means your VM environment is broken.<b=
r>
<br>
Cheers,<br>
<br>
Stan<br>
<br>
<br>
</blockquote></div><br></div></div>

--047d7b6783ceae22de04f63cc9de--


--===============7902778682393266114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7902778682393266114==--
