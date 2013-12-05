Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70CE97F3F
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:58:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D30B5AC005
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:58:54 -0800 (PST)
Received: from mail-wg0-f50.google.com (mail-wg0-f50.google.com
	[74.125.82.50]) by cuda.sgi.com with ESMTP id LjYEbnHY8nc2NAjq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Dec 2013 07:58:49 -0800 (PST)
Received: by mail-wg0-f50.google.com with SMTP id a1so14865801wgh.17
	for <xfs@oss.sgi.com>; Thu, 05 Dec 2013 07:58:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
	<52A03513.6030408@hardwarefreak.com>
	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>
From: Mike Dacre <mike.dacre@gmail.com>
Date: Thu, 5 Dec 2013 07:58:06 -0800
Message-ID: <CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
Subject: Fwd: Sudden File System Corruption
Content-Type: multipart/mixed; boundary=f46d04428770e298a604eccb9add
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--f46d04428770e298a604eccb9add
Content-Type: multipart/alternative; boundary=f46d04428770e298a104eccb9adb

--f46d04428770e298a104eccb9adb
Content-Type: text/plain; charset=UTF-8

Hi Stan,


On Thu, Dec 5, 2013 at 12:10 AM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 12/4/2013 8:55 PM, Mike Dacre wrote:
> ...
> > I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an
> XFS.
>
> It's a 9260-4i, not a 9240, a huge difference.  I went digging through
> your dmesg output because I knew the 9240 doesn't support RAID6.  A few
> questions.  What is the LSI RAID configuration?
>

You are right, sorry.  9260-4i

1.  Level -- confirm RAID6
>
Definitely RAID6

2.  Strip size?  (eg 512KB)
>
64KB

3.  Stripe size? (eg 7168KB, 14*256)
>
Not sure how to get this

4.  BBU module?
>
Yes. iBBU, state optimal, 97% charged.

5.  Is write cache enabled?
>
> Yes: Cahced IO and Write Back with BBU are enabled.

I have also attached an adapter summary (megaraid_adp_info.txt) and a
virtual and physical drive summary (megaraid_drive_info.txt).


> What is the XFS geometry?
>
> 5.  xfs_info /dev/sda
>

`xfs_info /dev/sda1`
meta-data =/dev/sda1          isize=256    agcount=26, agsize=268435455 blks
               =                         sectsz=512   attr=2
data         =                         bsize=4096   blocks=6835404288,
imaxpct=5
               =                         sunit=0      swidth=0 blks
naming    =version 2            bsize=4096   ascii-ci=0
log          =internal               bsize=4096   blocks=521728, version=2
              =                          sectsz=512   sunit=0 blks,
lazy-count=1
realtime   =none                   extsz=4096   blocks=0, rtextents=0

This is also attached as xfs_info.txt


> A combination of these these being wrong could very well be part of your
> problems.
>
> ...
> > IO errors when any requests were made.  This happened while it was being
>
> I didn't see any IO errors in your dmesg output.  None.
>
> Good point.  These happened while trying to ls.  I am not sure why I can't
find them in the log, they printed out to the console as 'Input/Output'
errors, simply stating that the ls command failed.


> > accessed by  5 different users, one was doing a very large rm operation
> (rm
> > *sh on thousands on files in a directory).  Also, about 30 minutes before
> > we had connected the globus connect endpoint to allow easy file transfers
> > to SDSC.
>
> With delaylog enabled, which I believe it is in RHEL/CentOS 6, a single
> big rm shouldn't kill the disks.  But with the combination of other
> workloads it seems you may have been seeking the disks to death.
>
That is possible, workloads can get really high sometimes.  I am not sure
how to control that without significantly impacting performance - I want a
single user to be able to use 98% IO capacity sometimes... but other times
I want the load to be split amongst many users.  Also, each user can
execute jobs simultaneously on 23 different computers, each acessing the
same drive via NFS.  This is a great system most of the time, but sometimes
the workloads on the drive get really high.

...
> > In the end, I successfully repaired the filesystem with `xfs_repair -L
> > /dev/sda1`.  However, I am nervous that some files may have been
> corrupted.
>
> I'm sure your users will let you know.  I'd definitely have a look in
> the directory that was targeted by the big rm operation which apparently
> didn't finish when XFS shutdown.
>
> > Do any of you have any idea what could have caused this problem?
>
> Yes.  A few things.  The first is this, and it's a big one:
>
> Dec  4 18:15:28 fruster kernel: io scheduler noop registered
> Dec  4 18:15:28 fruster kernel: io scheduler anticipatory registered
> Dec  4 18:15:28 fruster kernel: io scheduler deadline registered
> Dec  4 18:15:28 fruster kernel: io scheduler cfq registered (default)
>
>
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
>
> "As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much
> of the parallelization in XFS."
>
> *Never* use the CFQ elevator with XFS, and never with a high performance
> storage system.  In fact, IMHO, never use CFQ period.  It was horrible
> even before 3.2.12.  It is certain that CFQ is playing a big part in
> your 120s timeouts, though it may not be solely responsible for your IO
> bottleneck.  Switch to deadline or noop immediately, deadline if LSI
> write cache is disabled, noop if it is enabled.  Execute this manually
> now, and add it to a startup script and verify it is being set at
> startup, as it's not permanent:
>
> echo deadline > /sys/block/sda/queue/scheduler
>
> Wow, this is huge, I can't believe I missed that.  I have switched it to
noop now as we use write caching.  I have been trying to figure out for a
while why I would keep getting timeouts when the NFS load was high.  If you
have any other suggestions for how I can improve performance, I would
greatly appreciate it.


> This one simple command line may help pretty dramatically, immediately,
> assuming your hardware array parameters aren't horribly wrong for your
> workloads, and your XFS alignment correctly matches the hardware geometry.
>
> Great, thanks.  Our workloads vary considerably as we are a biology
research lab, sometimes we do lots of seeks, other times we are almost
maxing out read or write speed with massively parallel processes all
accessing the disk at the same time.


> --
> Stan
>
>
>
-Mike

--f46d04428770e298a104eccb9adb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_quote"><div dir=3D"ltr">Hi Stan,<br><d=
iv class=3D"gmail_extra"><br><br><div class=3D"gmail_quote"><div class=3D"i=
m">On Thu, Dec 5, 2013 at 12:10 AM, Stan Hoeppner <span dir=3D"ltr">&lt;<a =
href=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak=
.com</a>&gt;</span> wrote:<br>


<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">On 12/4/2013 8:55 PM, Mike Dacre wrote:<br>
...<br>
&gt; I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i. =C2=A0It =
has an XFS.<br>
<br>
It&#39;s a 9260-4i, not a 9240, a huge difference. =C2=A0I went digging thr=
ough<br>
your dmesg output because I knew the 9240 doesn&#39;t support RAID6. =C2=A0=
A few<br>
questions. =C2=A0What is the LSI RAID configuration?<br></blockquote><div>=
=C2=A0</div></div><div>You are right, sorry. =C2=A09260-4i</div><div class=
=3D"im"><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bo=
rder-left-style:solid;padding-left:1ex">



1. =C2=A0Level -- confirm RAID6<br></blockquote></div><div>Definitely RAID6=
=C2=A0</div><div class=3D"im"><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-col=
or:rgb(204,204,204);border-left-style:solid;padding-left:1ex">



2. =C2=A0Strip size? =C2=A0(eg 512KB)<br></blockquote></div><div>64KB=C2=A0=
</div><div class=3D"im"><div><br></div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb=
(204,204,204);border-left-style:solid;padding-left:1ex">



3. =C2=A0Stripe size? (eg 7168KB, 14*256)<br></blockquote></div><div>Not su=
re how to get this=C2=A0</div><div><br></div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-col=
or:rgb(204,204,204);border-left-style:solid;padding-left:1ex">



4. =C2=A0BBU module?<br></blockquote><div>Yes. iBBU, state optimal, 97% cha=
rged.=C2=A0</div><div class=3D"im"><div><br></div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-lef=
t-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">



5. =C2=A0Is write cache enabled?<br>
<br></blockquote></div><div>Yes: Cahced IO and Write Back with BBU are enab=
led.</div><div><br></div><div>I have also attached an adapter summary (mega=
raid_adp_info.txt) and a virtual and physical drive summary (megaraid_drive=
_info.txt).=C2=A0</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex">
What is the XFS geometry?<br>
<br>
5. =C2=A0xfs_info /dev/sda<br></blockquote></div><div><div><br></div><div>`=
xfs_info /dev/sda1`</div><div>meta-data =3D/dev/sda1 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0isize=3D256 =C2=A0 =C2=A0agcount=3D26, agsize=3D268435455 blks=
</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 sectsz=3D512 =C2=A0 attr=3D2</div>


<div>data =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 bl=
ocks=3D6835404288, imaxpct=3D5</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0=
 blks</div><div>naming =C2=A0 =C2=A0=3Dversion 2 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-ci=3D0</div>


<div>log =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D521728, version=
=3D2</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0sectsz=3D512 =C2=A0 sunit=3D0 blks, lazy-count=3D1</div><div>real=
time =C2=A0 =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0</div>


</div><div><br></div><div>This is also attached as xfs_info.txt=C2=A0</div>=
<div class=3D"im"><div><br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,2=
04,204);border-left-style:solid;padding-left:1ex">



<br>
A combination of these these being wrong could very well be part of your<br=
>
problems.<br>
<br>
...<br>
<div>&gt; IO errors when any requests were made. =C2=A0This happened while =
it was being<br>
<br>
</div>I didn&#39;t see any IO errors in your dmesg output. =C2=A0None.<br>
<div><br></div></blockquote></div><div>Good point. =C2=A0These happened whi=
le trying to ls. =C2=A0I am not sure why I can&#39;t find them in the log, =
they printed out to the console as &#39;Input/Output&#39; errors, simply st=
ating that the ls command failed.</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex"><div>
&gt; accessed by =C2=A05 different users, one was doing a very large rm ope=
ration (rm<br>
&gt; *sh on thousands on files in a directory). =C2=A0Also, about 30 minute=
s before<br>
&gt; we had connected the globus connect endpoint to allow easy file transf=
ers<br>
&gt; to SDSC.<br>
<br>
</div>With delaylog enabled, which I believe it is in RHEL/CentOS 6, a sing=
le<br>
big rm shouldn&#39;t kill the disks. =C2=A0But with the combination of othe=
r<br>
workloads it seems you may have been seeking the disks to death.<br></block=
quote></div><div>That is possible, workloads can get really high sometimes.=
 =C2=A0I am not sure how to control that without significantly impacting pe=
rformance - I want a single user to be able to use 98% IO capacity sometime=
s... but other times I want the load to be split amongst many users. =C2=A0=
Also, each user can execute jobs simultaneously on 23 different computers, =
each acessing the same drive via NFS. =C2=A0This is a great system most of =
the time, but sometimes the workloads on the drive get really high.=C2=A0</=
div>

<div class=3D"im">
<div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-lef=
t-style:solid;padding-left:1ex">
...<br>
<div>&gt; In the end, I successfully repaired the filesystem with `xfs_repa=
ir -L<br>
&gt; /dev/sda1`. =C2=A0However, I am nervous that some files may have been =
corrupted.<br>
<br>
</div>I&#39;m sure your users will let you know. =C2=A0I&#39;d definitely h=
ave a look in<br>
the directory that was targeted by the big rm operation which apparently<br=
>
didn&#39;t finish when XFS shutdown.<br>
<div><br>
&gt; Do any of you have any idea what could have caused this problem?<br>
<br>
</div>Yes. =C2=A0A few things. =C2=A0The first is this, and it&#39;s a big =
one:<br>
<br>
Dec =C2=A04 18:15:28 fruster kernel: io scheduler noop registered<br>
Dec =C2=A04 18:15:28 fruster kernel: io scheduler anticipatory registered<b=
r>
Dec =C2=A04 18:15:28 fruster kernel: io scheduler deadline registered<br>
Dec =C2=A04 18:15:28 fruster kernel: io scheduler cfq registered (default)<=
br>
<br>
<a href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesy=
stems_for_.3Csomething.3E" target=3D"_blank">http://xfs.org/index.php/XFS_F=
AQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E</a><br>
<br>
&quot;As of kernel 3.2.12, the default i/o scheduler, CFQ, will defeat much=
<br>
of the parallelization in XFS.&quot;<br>
<br>
*Never* use the CFQ elevator with XFS, and never with a high performance<br=
>
storage system. =C2=A0In fact, IMHO, never use CFQ period. =C2=A0It was hor=
rible<br>
even before 3.2.12. =C2=A0It is certain that CFQ is playing a big part in<b=
r>
your 120s timeouts, though it may not be solely responsible for your IO<br>
bottleneck. =C2=A0Switch to deadline or noop immediately, deadline if LSI<b=
r>
write cache is disabled, noop if it is enabled. =C2=A0Execute this manually=
<br>
now, and add it to a startup script and verify it is being set at<br>
startup, as it&#39;s not permanent:<br>
<br>
echo deadline &gt; /sys/block/sda/queue/scheduler<br>
<br></blockquote></div><div>Wow, this is huge, I can&#39;t believe I missed=
 that. =C2=A0I have switched it to noop now as we use write caching. =C2=A0=
I have been trying to figure out for a while why I would keep getting timeo=
uts when the NFS load was high. =C2=A0If you have any other suggestions for=
 how I can improve performance, I would greatly appreciate it.</div>

<div class=3D"im">
<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex">
This one simple command line may help pretty dramatically, immediately,<br>
assuming your hardware array parameters aren&#39;t horribly wrong for your<=
br>
workloads, and your XFS alignment correctly matches the hardware geometry.<=
br>
<span><font color=3D"#888888"><br></font></span></blockquote></div><div>Gre=
at, thanks. =C2=A0Our workloads vary considerably as we are a biology resea=
rch lab, sometimes we do lots of seeks, other times we are almost maxing ou=
t read or write speed with massively parallel processes all accessing the d=
isk at the same time.</div>


<div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-l=
eft-style:solid;padding-left:1ex"><span><font color=3D"#888888">
--<br>
Stan<br>
<br>
<br></font></span></blockquote><span class=3D"HOEnZb"><font color=3D"#88888=
8"><div><br></div><div>-Mike=C2=A0</div></font></span></div><br></div></div=
>
</div><br></div>

--f46d04428770e298a104eccb9adb--

--f46d04428770e298a604eccb9add
Content-Type: text/plain; charset=US-ASCII; name="megaraid_adp_info.txt"
Content-Disposition: attachment; filename="megaraid_adp_info.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hou6dsrm0

QWRhcHRlciAjMAoKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiAgICAgICAgICAgICAgICAgICAgVmVy
c2lvbnMKICAgICAgICAgICAgICAgID09PT09PT09PT09PT09PT0KUHJvZHVjdCBOYW1lICAgIDog
TFNJIE1lZ2FSQUlEIFNBUyA5MjYwLTRpClNlcmlhbCBObyAgICAgICA6IFNWMTQ4MjE5NzIKRlcg
UGFja2FnZSBCdWlsZDogMTIuMTQuMC0wMTY3CgogICAgICAgICAgICAgICAgICAgIE1mZy4gRGF0
YQogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpNZmcuIERhdGUgICAgICAgOiAxMS8y
NC8xMQpSZXdvcmsgRGF0ZSAgICAgOiAwMC8wMC8wMApSZXZpc2lvbiBObyAgICAgOiA2MUEKQmF0
dGVyeSBGUlUgICAgIDogTi9BCgogICAgICAgICAgICAgICAgSW1hZ2UgVmVyc2lvbnMgaW4gRmxh
c2g6CiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09CkZXIFZlcnNpb24gICAgICAgICA6
IDIuMTMwLjM5My0yNTUxCkJJT1MgVmVyc2lvbiAgICAgICA6IDMuMjguMDBfNC4xNC4wNS4wMF8w
eDA1MjcwMDAwClByZWJvb3QgQ0xJIFZlcnNpb246IDA0LjA0LTAyMDojJTAwMDA5CldlYkJJT1Mg
VmVyc2lvbiAgICA6IDYuMC01Mi1lXzQ4LVJlbApOVkRBVEEgVmVyc2lvbiAgICAgOiAyLjA5LjAz
LTAwNDUKQm9vdCBCbG9jayBWZXJzaW9uIDogMi4wMi4wMC4wMC0wMDAwCkJPT1QgVmVyc2lvbiAg
ICAgICA6IDA5LjI1MC4wMS4yMTkKCiAgICAgICAgICAgICAgICBQZW5kaW5nIEltYWdlcyBpbiBG
bGFzaAogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpOb25lCgogICAgICAgICAgICAg
ICAgUENJIEluZm8KICAgICAgICAgICAgICAgID09PT09PT09PT09PT09PT0KQ29udHJvbGxlciBJ
ZAk6IDAwMDAKVmVuZG9yIElkICAgICAgIDogMTAwMApEZXZpY2UgSWQgICAgICAgOiAwMDc5ClN1
YlZlbmRvcklkICAgICA6IDEwMDAKU3ViRGV2aWNlSWQgICAgIDogOTI2MAoKSG9zdCBJbnRlcmZh
Y2UgIDogUENJRQoKQ2hpcFJldmlzaW9uICAgIDogQjQKCkxpbmsgU3BlZWQgCSAgICAgOiAwIApO
dW1iZXIgb2YgRnJvbnRlbmQgUG9ydDogMCAKRGV2aWNlIEludGVyZmFjZSAgOiBQQ0lFCgpOdW1i
ZXIgb2YgQmFja2VuZCBQb3J0OiA0IApQb3J0ICA6ICBBZGRyZXNzCjAgICAgICAgIDUwMDMwNDgw
MDEyOTQ5N2YgCjEgICAgICAgIDAwMDAwMDAwMDAwMDAwMDAgCjIgICAgICAgIDAwMDAwMDAwMDAw
MDAwMDAgCjMgICAgICAgIDAwMDAwMDAwMDAwMDAwMDAgCgogICAgICAgICAgICAgICAgSFcgQ29u
ZmlndXJhdGlvbgogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpTQVMgQWRkcmVzcyAg
ICAgIDogNTAwNjA1YjAwNDEzNzgyMApCQlUgICAgICAgICAgICAgIDogUHJlc2VudApBbGFybSAg
ICAgICAgICAgIDogUHJlc2VudApOVlJBTSAgICAgICAgICAgIDogUHJlc2VudApTZXJpYWwgRGVi
dWdnZXIgIDogUHJlc2VudApNZW1vcnkgICAgICAgICAgIDogUHJlc2VudApGbGFzaCAgICAgICAg
ICAgIDogUHJlc2VudApNZW1vcnkgU2l6ZSAgICAgIDogNTEyTUIKVFBNICAgICAgICAgICAgICA6
IEFic2VudApPbiBib2FyZCBFeHBhbmRlcjogQWJzZW50ClVwZ3JhZGUgS2V5ICAgICAgOiBBYnNl
bnQKVGVtcGVyYXR1cmUgc2Vuc29yIGZvciBST0MgICAgOiBBYnNlbnQKVGVtcGVyYXR1cmUgc2Vu
c29yIGZvciBjb250cm9sbGVyICAgIDogQWJzZW50CgoKICAgICAgICAgICAgICAgIFNldHRpbmdz
CiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09CkN1cnJlbnQgVGltZSAgICAgICAgICAg
ICAgICAgICAgIDogNzoyMTo1NCAxMi81LCAyMDEzClByZWRpY3RpdmUgRmFpbCBQb2xsIEludGVy
dmFsICAgIDogMzAwc2VjCkludGVycnVwdCBUaHJvdHRsZSBBY3RpdmUgQ291bnQgIDogMTYKSW50
ZXJydXB0IFRocm90dGxlIENvbXBsZXRpb24gICAgOiA1MHVzClJlYnVpbGQgUmF0ZSAgICAgICAg
ICAgICAgICAgICAgIDogMzAlClBSIFJhdGUgICAgICAgICAgICAgICAgICAgICAgICAgIDogMzAl
CkJHSSBSYXRlICAgICAgICAgICAgICAgICAgICAgICAgIDogMzAlCkNoZWNrIENvbnNpc3RlbmN5
IFJhdGUgICAgICAgICAgIDogMzAlClJlY29uc3RydWN0aW9uIFJhdGUgICAgICAgICAgICAgIDog
MzAlCkNhY2hlIEZsdXNoIEludGVydmFsICAgICAgICAgICAgIDogNHMKTWF4IERyaXZlcyB0byBT
cGludXAgYXQgT25lIFRpbWUgOiA0CkRlbGF5IEFtb25nIFNwaW51cCBHcm91cHMgICAgICAgIDog
MnMKUGh5c2ljYWwgRHJpdmUgQ29lcmNpb24gTW9kZSAgICAgOiBEaXNhYmxlZApDbHVzdGVyIE1v
ZGUgICAgICAgICAgICAgICAgICAgICA6IERpc2FibGVkCkFsYXJtICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIDogRW5hYmxlZApBdXRvIFJlYnVpbGQgICAgICAgICAgICAgICAgICAgICA6IEVu
YWJsZWQKQmF0dGVyeSBXYXJuaW5nICAgICAgICAgICAgICAgICAgOiBFbmFibGVkCkVjYyBCdWNr
ZXQgU2l6ZSAgICAgICAgICAgICAgICAgIDogMTUKRWNjIEJ1Y2tldCBMZWFrIFJhdGUgICAgICAg
ICAgICAgOiAxNDQwIE1pbnV0ZXMKUmVzdG9yZSBIb3RTcGFyZSBvbiBJbnNlcnRpb24gICAgOiBE
aXNhYmxlZApFeHBvc2UgRW5jbG9zdXJlIERldmljZXMgICAgICAgICA6IEVuYWJsZWQKTWFpbnRh
aW4gUEQgRmFpbCBIaXN0b3J5ICAgICAgICAgOiBFbmFibGVkCkhvc3QgUmVxdWVzdCBSZW9yZGVy
aW5nICAgICAgICAgIDogRW5hYmxlZApBdXRvIERldGVjdCBCYWNrUGxhbmUgRW5hYmxlZCAgICA6
IFNHUElPL2kyYyBTRVAKTG9hZCBCYWxhbmNlIE1vZGUgICAgICAgICAgICAgICAgOiBBdXRvClVz
ZSBGREUgT25seSAgICAgICAgICAgICAgICAgICAgIDogTm8KU2VjdXJpdHkgS2V5IEFzc2lnbmVk
ICAgICAgICAgICAgOiBObwpTZWN1cml0eSBLZXkgRmFpbGVkICAgICAgICAgICAgICA6IE5vClNl
Y3VyaXR5IEtleSBOb3QgQmFja2VkdXAgICAgICAgIDogTm8KRGVmYXVsdCBMRCBQb3dlclNhdmUg
UG9saWN5ICAgICAgOiBDb250cm9sbGVyIERlZmluZWQKTWF4aW11bSBudW1iZXIgb2YgZGlyZWN0
IGF0dGFjaGVkIGRyaXZlcyB0byBzcGluIHVwIGluIDEgbWluIDogMTIwIApBdXRvIEVuaGFuY2Vk
IEltcG9ydCAgICAgICAgICAgICA6IFllcwpBbnkgT2ZmbGluZSBWRCBDYWNoZSBQcmVzZXJ2ZWQg
ICA6IE5vCkFsbG93IEJvb3Qgd2l0aCBQcmVzZXJ2ZWQgQ2FjaGUgIDogTm8KRGlzYWJsZSBPbmxp
bmUgQ29udHJvbGxlciBSZXNldCAgOiBObwpQRksgaW4gTlZSQU0gICAgICAgICAgICAgICAgICAg
ICA6IE5vClVzZSBkaXNrIGFjdGl2aXR5IGZvciBsb2NhdGUgICAgIDogTm8KUE9TVCBkZWxheQkJ
CSA6IDkwIHNlY29uZHMKQklPUyBFcnJvciBIYW5kbGluZyAgICAgICAgICAJIDogU3RvcCBPbiBF
cnJvcnMKQ3VycmVudCBCb290IE1vZGUgCQkgIDpOb3JtYWwKICAgICAgICAgICAgICAgIENhcGFi
aWxpdGllcwogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpSQUlEIExldmVsIFN1cHBv
cnRlZCAgICAgICAgICAgICA6IFJBSUQwLCBSQUlEMSwgUkFJRDUsIFJBSUQ2LCBSQUlEMDAsIFJB
SUQxMCwgUkFJRDUwLCBSQUlENjAsIFBSTCAxMSwgUFJMIDExIHdpdGggc3Bhbm5pbmcsIFNSTCAz
IHN1cHBvcnRlZCwgUFJMMTEtUkxRMCBEREYgbGF5b3V0IHdpdGggbm8gc3BhbiwgUFJMMTEtUkxR
MCBEREYgbGF5b3V0IHdpdGggc3BhbgpTdXBwb3J0ZWQgRHJpdmVzICAgICAgICAgICAgICAgICA6
IFNBUywgU0FUQQoKQWxsb3dlZCBNaXhpbmc6CgpNaXggaW4gRW5jbG9zdXJlIEFsbG93ZWQKTWl4
IG9mIFNBUy9TQVRBIG9mIEhERCB0eXBlIGluIFZEIEFsbG93ZWQKTWl4IG9mIFNBUy9TQVRBIG9m
IFNTRCB0eXBlIGluIFZEIEFsbG93ZWQKTWl4IG9mIFNTRC9IREQgaW4gVkQgQWxsb3dlZAoKICAg
ICAgICAgICAgICAgIFN0YXR1cwogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpFQ0Mg
QnVja2V0IENvdW50ICAgICAgICAgICAgICAgICA6IDAKCiAgICAgICAgICAgICAgICBMaW1pdGF0
aW9ucwogICAgICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpNYXggQXJtcyBQZXIgVkQgICAg
ICAgICAgOiAzMiAKTWF4IFNwYW5zIFBlciBWRCAgICAgICAgIDogOCAKTWF4IEFycmF5cyAgICAg
ICAgICAgICAgIDogMTI4IApNYXggTnVtYmVyIG9mIFZEcyAgICAgICAgOiA2NCAKTWF4IFBhcmFs
bGVsIENvbW1hbmRzICAgIDogMTAwOCAKTWF4IFNHRSBDb3VudCAgICAgICAgICAgIDogODAgCk1h
eCBEYXRhIFRyYW5zZmVyIFNpemUgICA6IDgxOTIgc2VjdG9ycyAKTWF4IFN0cmlwcyBQZXJJTyAg
ICAgICAgIDogNDIgCk1heCBMRCBwZXIgYXJyYXkgICAgICAgICA6IDE2IApNaW4gU3RyaXAgU2l6
ZSAgICAgICAgICAgOiA4IEtCCk1heCBTdHJpcCBTaXplICAgICAgICAgICA6IDEuMCBNQgpNYXgg
Q29uZmlndXJhYmxlIENhY2hlQ2FkZSBTaXplOiAwIEdCCkN1cnJlbnQgU2l6ZSBvZiBDYWNoZUNh
ZGUgICAgICA6IDAgR0IKQ3VycmVudCBTaXplIG9mIEZXIENhY2hlICAgICAgIDogMzQ2IE1CCgog
ICAgICAgICAgICAgICAgRGV2aWNlIFByZXNlbnQKICAgICAgICAgICAgICAgID09PT09PT09PT09
PT09PT0KVmlydHVhbCBEcml2ZXMgICAgOiAxIAogIERlZ3JhZGVkICAgICAgICA6IDAgCiAgT2Zm
bGluZSAgICAgICAgIDogMCAKUGh5c2ljYWwgRGV2aWNlcyAgOiAxOCAKICBEaXNrcyAgICAgICAg
ICAgOiAxNiAKICBDcml0aWNhbCBEaXNrcyAgOiAwIAogIEZhaWxlZCBEaXNrcyAgICA6IDAgCgog
ICAgICAgICAgICAgICAgU3VwcG9ydGVkIEFkYXB0ZXIgT3BlcmF0aW9ucwogICAgICAgICAgICAg
ICAgPT09PT09PT09PT09PT09PQpSZWJ1aWxkIFJhdGUgICAgICAgICAgICAgICAgICAgIDogWWVz
CkNDIFJhdGUgICAgICAgICAgICAgICAgICAgICAgICAgOiBZZXMKQkdJIFJhdGUgICAgICAgICAg
ICAgICAgICAgICAgICA6IFllcwpSZWNvbnN0cnVjdCBSYXRlICAgICAgICAgICAgICAgIDogWWVz
ClBhdHJvbCBSZWFkIFJhdGUgICAgICAgICAgICAgICAgOiBZZXMKQWxhcm0gQ29udHJvbCAgICAg
ICAgICAgICAgICAgICA6IFllcwpDbHVzdGVyIFN1cHBvcnQgICAgICAgICAgICAgICAgIDogTm8K
QkJVICAgICAgICAgICAgICAgICAgICAgICAgICAgICA6IFllcwpTcGFubmluZyAgICAgICAgICAg
ICAgICAgICAgICAgIDogWWVzCkRlZGljYXRlZCBIb3QgU3BhcmUgICAgICAgICAgICAgOiBZZXMK
UmV2ZXJ0aWJsZSBIb3QgU3BhcmVzICAgICAgICAgICA6IFllcwpGb3JlaWduIENvbmZpZyBJbXBv
cnQgICAgICAgICAgIDogWWVzClNlbGYgRGlhZ25vc3RpYyAgICAgICAgICAgICAgICAgOiBZZXMK
QWxsb3cgTWl4ZWQgUmVkdW5kYW5jeSBvbiBBcnJheSA6IE5vCkdsb2JhbCBIb3QgU3BhcmVzICAg
ICAgICAgICAgICAgOiBZZXMKRGVueSBTQ1NJIFBhc3N0aHJvdWdoICAgICAgICAgICA6IE5vCkRl
bnkgU01QIFBhc3N0aHJvdWdoICAgICAgICAgICAgOiBObwpEZW55IFNUUCBQYXNzdGhyb3VnaCAg
ICAgICAgICAgIDogTm8KU3VwcG9ydCBTZWN1cml0eSAgICAgICAgICAgICAgICA6IE5vClNuYXBz
aG90IEVuYWJsZWQgICAgICAgICAgICAgICAgOiBObwpTdXBwb3J0IHRoZSBPQ0Ugd2l0aG91dCBh
ZGRpbmcgZHJpdmVzIDogWWVzClN1cHBvcnQgUEZLICAgICAgICAgICAgICAgICAgICAgOiBZZXMK
U3VwcG9ydCBQSSAgICAgICAgICAgICAgICAgICAgICA6IE5vClN1cHBvcnQgQm9vdCBUaW1lIFBG
SyBDaGFuZ2UgICAgOiBObwpEaXNhYmxlIE9ubGluZSBQRksgQ2hhbmdlICAgICAgIDogTm8KUEZL
IFRyYWlsVGltZSBSZW1haW5pbmcgICAgICAgICA6IDAgZGF5cyAwIGhvdXJzClN1cHBvcnQgU2hp
ZWxkIFN0YXRlICAgICAgICAgICAgOiBObwpCbG9jayBTU0QgV3JpdGUgRGlzayBDYWNoZSBDaGFu
Z2U6IE5vClN1cHBvcnQgT25saW5lIEZXIFVwZGF0ZQk6IFllcwoKICAgICAgICAgICAgICAgIFN1
cHBvcnRlZCBWRCBPcGVyYXRpb25zCiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09ClJl
YWQgUG9saWN5ICAgICAgICAgIDogWWVzCldyaXRlIFBvbGljeSAgICAgICAgIDogWWVzCklPIFBv
bGljeSAgICAgICAgICAgIDogWWVzCkFjY2VzcyBQb2xpY3kgICAgICAgIDogWWVzCkRpc2sgQ2Fj
aGUgUG9saWN5ICAgIDogWWVzClJlY29uc3RydWN0aW9uICAgICAgIDogWWVzCkRlbnkgTG9jYXRl
ICAgICAgICAgIDogTm8KRGVueSBDQyAgICAgICAgICAgICAgOiBObwpBbGxvdyBDdHJsIEVuY3J5
cHRpb246IE5vCkVuYWJsZSBMREJCTSAgICAgICAgIDogWWVzClN1cHBvcnQgQnJlYWttaXJyb3Ig
IDogTm8KUG93ZXIgU2F2aW5ncyAgICAgICAgOiBObwoKICAgICAgICAgICAgICAgIFN1cHBvcnRl
ZCBQRCBPcGVyYXRpb25zCiAgICAgICAgICAgICAgICA9PT09PT09PT09PT09PT09CkZvcmNlIE9u
bGluZSAgICAgICAgICAgICAgICAgICAgICAgICAgICA6IFllcwpGb3JjZSBPZmZsaW5lICAgICAg
ICAgICAgICAgICAgICAgICAgICAgOiBZZXMKRm9yY2UgUmVidWlsZCAgICAgICAgICAgICAgICAg
ICAgICAgICAgIDogWWVzCkRlbnkgRm9yY2UgRmFpbGVkICAgICAgICAgICAgICAgICAgICAgICA6
IE5vCkRlbnkgRm9yY2UgR29vZC9CYWQgICAgICAgICAgICAgICAgICAgICA6IE5vCkRlbnkgTWlz
c2luZyBSZXBsYWNlICAgICAgICAgICAgICAgICAgICA6IE5vCkRlbnkgQ2xlYXIgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICA6IE5vCkRlbnkgTG9jYXRlICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICA6IE5vClN1cHBvcnQgVGVtcGVyYXR1cmUgICAgICAgICAgICAgICAgICAgICA6IFll
cwpEaXNhYmxlIENvcHliYWNrICAgICAgICAgICAgICAgICAgICAgICAgOiBObwpFbmFibGUgSkJP
RCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOiBObwpFbmFibGUgQ29weWJhY2sgb24gU01B
UlQgICAgICAgICAgICAgICAgOiBObwpFbmFibGUgQ29weWJhY2sgdG8gU1NEIG9uIFNNQVJUIEVy
cm9yICAgOiBZZXMKRW5hYmxlIFNTRCBQYXRyb2wgUmVhZCAgICAgICAgICAgICAgICAgIDogTm8K
UFIgQ29ycmVjdCBVbmNvbmZpZ3VyZWQgQXJlYXMgICAgICAgICAgIDogWWVzCkVuYWJsZSBTcGlu
IERvd24gb2YgVW5Db25maWd1cmVkIERyaXZlcyA6IFllcwpEaXNhYmxlIFNwaW4gRG93biBvZiBo
b3Qgc3BhcmVzICAgICAgICAgOiBObwpTcGluIERvd24gdGltZSAgICAgICAgICAgICAgICAgICAg
ICAgICAgOiAzMCAKVDEwIFBvd2VyIFN0YXRlICAgICAgICAgICAgICAgICAgICAgICAgIDogTm8K
ICAgICAgICAgICAgICAgIEVycm9yIENvdW50ZXJzCiAgICAgICAgICAgICAgICA9PT09PT09PT09
PT09PT09Ck1lbW9yeSBDb3JyZWN0YWJsZSBFcnJvcnMgICA6IDAgCk1lbW9yeSBVbmNvcnJlY3Rh
YmxlIEVycm9ycyA6IDAgCgogICAgICAgICAgICAgICAgQ2x1c3RlciBJbmZvcm1hdGlvbgogICAg
ICAgICAgICAgICAgPT09PT09PT09PT09PT09PQpDbHVzdGVyIFBlcm1pdHRlZCAgICAgOiBObwpD
bHVzdGVyIEFjdGl2ZSAgICAgICAgOiBObwoKICAgICAgICAgICAgICAgIERlZmF1bHQgU2V0dGlu
Z3MKICAgICAgICAgICAgICAgID09PT09PT09PT09PT09PT0KUGh5IFBvbGFyaXR5ICAgICAgICAg
ICAgICAgICAgICAgOiAwIApQaHkgUG9sYXJpdHlTcGxpdCAgICAgICAgICAgICAgICA6IDAgCkJh
Y2tncm91bmQgUmF0ZSAgICAgICAgICAgICAgICAgIDogMzAgClN0cmlwIFNpemUgICAgICAgICAg
ICAgICAgICAgICAgIDogMjU2a0IKRmx1c2ggVGltZSAgICAgICAgICAgICAgICAgICAgICAgOiA0
IHNlY29uZHMKV3JpdGUgUG9saWN5ICAgICAgICAgICAgICAgICAgICAgOiBXQgpSZWFkIFBvbGlj
eSAgICAgICAgICAgICAgICAgICAgICA6IFJBCkNhY2hlIFdoZW4gQkJVIEJhZCAgICAgICAgICAg
ICAgIDogRGlzYWJsZWQKQ2FjaGVkIElPICAgICAgICAgICAgICAgICAgICAgICAgOiBObwpTTUFS
VCBNb2RlICAgICAgICAgICAgICAgICAgICAgICA6IE1vZGUgNgpBbGFybSBEaXNhYmxlICAgICAg
ICAgICAgICAgICAgICA6IFllcwpDb2VyY2lvbiBNb2RlICAgICAgICAgICAgICAgICAgICA6IE5v
bmUKWkNSIENvbmZpZyAgICAgICAgICAgICAgICAgICAgICAgOiBVbmtub3duCkRpcnR5IExFRCBT
aG93cyBEcml2ZSBBY3Rpdml0eSAgIDogTm8KQklPUyBDb250aW51ZSBvbiBFcnJvciAgICAgICAg
ICAgOiAzIApTcGluIERvd24gTW9kZSAgICAgICAgICAgICAgICAgICA6IE5vbmUKQWxsb3dlZCBE
ZXZpY2UgVHlwZSAgICAgICAgICAgICAgOiBTQVMvU0FUQSBNaXgKQWxsb3cgTWl4IGluIEVuY2xv
c3VyZSAgICAgICAgICAgOiBZZXMKQWxsb3cgSEREIFNBUy9TQVRBIE1peCBpbiBWRCAgICAgOiBZ
ZXMKQWxsb3cgU1NEIFNBUy9TQVRBIE1peCBpbiBWRCAgICAgOiBZZXMKQWxsb3cgSEREL1NTRCBN
aXggaW4gVkQgICAgICAgICAgOiBZZXMKQWxsb3cgU0FUQSBpbiBDbHVzdGVyICAgICAgICAgICAg
OiBObwpNYXggQ2hhaW5lZCBFbmNsb3N1cmVzICAgICAgICAgICA6IDE2IApEaXNhYmxlIEN0cmwt
UiAgICAgICAgICAgICAgICAgICA6IFllcwpFbmFibGUgV2ViIEJJT1MgICAgICAgICAgICAgICAg
ICA6IFllcwpEaXJlY3QgUEQgTWFwcGluZyAgICAgICAgICAgICAgICA6IE5vCkJJT1MgRW51bWVy
YXRlIFZEcyAgICAgICAgICAgICAgIDogWWVzClJlc3RvcmUgSG90IFNwYXJlIG9uIEluc2VydGlv
biAgIDogTm8KRXhwb3NlIEVuY2xvc3VyZSBEZXZpY2VzICAgICAgICAgOiBZZXMKTWFpbnRhaW4g
UEQgRmFpbCBIaXN0b3J5ICAgICAgICAgOiBZZXMKRGlzYWJsZSBQdW5jdHVyaW5nICAgICAgICAg
ICAgICAgOiBObwpaZXJvIEJhc2VkIEVuY2xvc3VyZSBFbnVtZXJhdGlvbiA6IE5vClByZUJvb3Qg
Q0xJIEVuYWJsZWQgICAgICAgICAgICAgIDogWWVzCkxFRCBTaG93IERyaXZlIEFjdGl2aXR5ICAg
ICAgICAgIDogWWVzCkNsdXN0ZXIgRGlzYWJsZSAgICAgICAgICAgICAgICAgIDogWWVzClNBUyBE
aXNhYmxlICAgICAgICAgICAgICAgICAgICAgIDogTm8KQXV0byBEZXRlY3QgQmFja1BsYW5lIEVu
YWJsZSAgICAgOiBTR1BJTy9pMmMgU0VQClVzZSBGREUgT25seSAgICAgICAgICAgICAgICAgICAg
IDogTm8KRW5hYmxlIExlZCBIZWFkZXIgICAgICAgICAgICAgICAgOiBZZXMKRGVsYXkgZHVyaW5n
IFBPU1QgICAgICAgICAgICAgICAgOiAwIApFbmFibGVDcmFzaER1bXAgICAgICAgICAgICAgICAg
ICA6IE5vCkRpc2FibGUgT25saW5lIENvbnRyb2xsZXIgUmVzZXQgIDogTm8KRW5hYmxlTERCQk0g
ICAgICAgICAgICAgICAgICAgICAgOiBZZXMKVW4tQ2VydGlmaWVkIEhhcmQgRGlzayBEcml2ZXMg
ICAgOiBBbGxvdwpUcmVhdCBTaW5nbGUgc3BhbiBSMUUgYXMgUjEwICAgICA6IE5vCk1heCBMRCBw
ZXIgYXJyYXkgICAgICAgICAgICAgICAgIDogMTYKUG93ZXIgU2F2aW5nIG9wdGlvbiAgICAgICAg
ICAgICAgOiBEb24ndCBBdXRvIHNwaW4gZG93biBDb25maWd1cmVkIERyaXZlcwpNYXggcG93ZXIg
c2F2aW5ncyBvcHRpb24gaXMgIG5vdCBhbGxvd2VkIGZvciBMRHMuIE9ubHkgVDEwIHBvd2VyIGNv
bmRpdGlvbnMgYXJlIHRvIGJlIHVzZWQuCkRlZmF1bHQgc3BpbiBkb3duIHRpbWUgaW4gbWludXRl
czogMzAgCkVuYWJsZSBKQk9EICAgICAgICAgICAgICAgICAgICAgIDogTm8KVFRZIExvZyBJbiBG
bGFzaCAgICAgICAgICAgICAgICAgOiBObwpBdXRvIEVuaGFuY2VkIEltcG9ydCAgICAgICAgICAg
ICA6IFllcwpCcmVha01pcnJvciBSQUlEIFN1cHBvcnQgICAgICAgICA6IFllcwpEaXNhYmxlIEpv
aW4gTWlycm9yICAgICAgICAgICAgICA6IE5vCkVuYWJsZSBTaGllbGQgU3RhdGUgICAgICAgICAg
ICAgIDogTm8KVGltZSB0YWtlbiB0byBkZXRlY3QgQ01FICAgICAgICAgOiA2MHMKCkV4aXQgQ29k
ZTogMHgwMAo=
--f46d04428770e298a604eccb9add
Content-Type: text/plain; charset=US-ASCII; name="megaraid_drive_info.txt"
Content-Disposition: attachment; filename="megaraid_drive_info.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hou6dstg1

U3lzdGVtCglPcGVyYXRpbmcgU3lzdGVtOiAgTGludXggdmVyc2lvbiAyLjYuMzItMzU4LjIzLjIu
ZWw2Lng4Nl82NCAKCURyaXZlciBWZXJzaW9uOiAwNi41MDQuMDEuMDAtcmgxCglDTEkgVmVyc2lv
bjogOC4wNy4wNwoKQWRhcHRlciAwIC0tIFZpcnR1YWwgRHJpdmUgSW5mb3JtYXRpb246ClZpcnR1
YWwgRHJpdmU6IDAgKFRhcmdldCBJZDogMCkKTmFtZSAgICAgICAgICAgICAgICA6ClJBSUQgTGV2
ZWwgICAgICAgICAgOiBQcmltYXJ5LTYsIFNlY29uZGFyeS0wLCBSQUlEIExldmVsIFF1YWxpZmll
ci0zClNpemUgICAgICAgICAgICAgICAgOiAyNS40NjMgVEIKU2VjdG9yIFNpemUgICAgICAgICA6
IDUxMgpJcyBWRCBlbXVsYXRlZCAgICAgIDogTm8KUGFyaXR5IFNpemUgICAgICAgICA6IDMuNjM3
IFRCClN0YXRlICAgICAgICAgICAgICAgOiBPcHRpbWFsClN0cmlwIFNpemUgICAgICAgICAgOiA2
NCBLQgpOdW1iZXIgT2YgRHJpdmVzICAgIDogMTYKU3BhbiBEZXB0aCAgICAgICAgICA6IDEKRGVm
YXVsdCBDYWNoZSBQb2xpY3k6IFdyaXRlQmFjaywgUmVhZEFoZWFkLCBDYWNoZWQsIE5vIFdyaXRl
IENhY2hlIGlmIEJhZCBCQlUKQ3VycmVudCBDYWNoZSBQb2xpY3k6IFdyaXRlQmFjaywgUmVhZEFo
ZWFkLCBDYWNoZWQsIE5vIFdyaXRlIENhY2hlIGlmIEJhZCBCQlUKRGVmYXVsdCBBY2Nlc3MgUG9s
aWN5OiBSZWFkL1dyaXRlCkN1cnJlbnQgQWNjZXNzIFBvbGljeTogUmVhZC9Xcml0ZQpEaXNrIENh
Y2hlIFBvbGljeSAgIDogRW5hYmxlZApFbmNyeXB0aW9uIFR5cGUgICAgIDogTm9uZQpCYWQgQmxv
Y2tzIEV4aXN0OiBObwpJcyBWRCBDYWNoZWQ6IE5vCgoKCkV4aXQgQ29kZTogMHgwMAoKSGFyZHdh
cmUKICAgICAgICBDb250cm9sbGVyCiAgICAgICAgICAgICAgICAgUHJvZHVjdE5hbWUgICAgICAg
OiBMU0kgTWVnYVJBSUQgU0FTIDkyNjAtNGkoQnVzIDAsIERldiAwKQogICAgICAgICAgICAgICAg
IFNBUyBBZGRyZXNzICAgICAgIDogNTAwNjA1YjAwNDEzNzgyMAogICAgICAgICAgICAgICAgIEZX
IFBhY2thZ2UgVmVyc2lvbjogMTIuMTQuMC0wMTY3CiAgICAgICAgICAgICAgICAgU3RhdHVzICAg
ICAgICAgICAgOiBPcHRpbWFsCiAgICAgICAgQkJVCiAgICAgICAgICAgICAgICAgQkJVIFR5cGUg
ICAgICAgICAgOiBpQkJVCiAgICAgICAgICAgICAgICAgU3RhdHVzICAgICAgICAgICAgOiBIZWFs
dGh5CiAgICAgICAgRW5jbG9zdXJlCiAgICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAg
OiBTQVMyWDI4ICAgICAgICAgCiAgICAgICAgICAgICAgICAgVHlwZSAgICAgICAgICAgICAgOiBT
RVMKICAgICAgICAgICAgICAgICBTdGF0dXMgICAgICAgICAgICA6IE9LCgogICAgICAgICAgICAg
ICAgIFByb2R1Y3QgSWQgICAgICAgIDogU0dQSU8gICAgICAgICAgIAogICAgICAgICAgICAgICAg
IFR5cGUgICAgICAgICAgICAgIDogU0dQSU8KICAgICAgICAgICAgICAgICBTdGF0dXMgICAgICAg
ICAgICA6IE9LCgogICAgICAgIFBEIAogICAgICAgICAgICAgICAgQ29ubmVjdG9yICAgICAgICAg
IDogUG9ydCAwIC0gMzxJbnRlcm5hbD48RW5jbCBQb3MgMSA+OiBTbG90IDAgCiAgICAgICAgICAg
ICAgICBWZW5kb3IgSWQgICAgICAgICAgOiBBVEEgICAgIAogICAgICAgICAgICAgICAgUHJvZHVj
dCBJZCAgICAgICAgIDogV0RDIFdEMjAwMkZBRVgtMAogICAgICAgICAgICAgICAgU3RhdGUgICAg
ICAgICAgICAgIDogT25saW5lCiAgICAgICAgICAgICAgICBEaXNrIFR5cGUgICAgICAgICAgOiBT
QVRBLEhhcmQgRGlzayBEZXZpY2UKICAgICAgICAgICAgICAgIENhcGFjaXR5ICAgICAgICAgICA6
IDEuODE4IFRCCiAgICAgICAgICAgICAgICBQb3dlciBTdGF0ZSAgICAgICAgOiBBY3RpdmUKCiAg
ICAgICAgICAgICAgICBDb25uZWN0b3IgICAgICAgICAgOiBQb3J0IDAgLSAzPEludGVybmFsPjxF
bmNsIFBvcyAxID46IFNsb3QgMSAKICAgICAgICAgICAgICAgIFZlbmRvciBJZCAgICAgICAgICA6
IEFUQSAgICAgCiAgICAgICAgICAgICAgICBQcm9kdWN0IElkICAgICAgICAgOiBXREMgV0QyMDAy
RkFFWC0wCiAgICAgICAgICAgICAgICBTdGF0ZSAgICAgICAgICAgICAgOiBPbmxpbmUKICAgICAg
ICAgICAgICAgIERpc2sgVHlwZSAgICAgICAgICA6IFNBVEEsSGFyZCBEaXNrIERldmljZQogICAg
ICAgICAgICAgICAgQ2FwYWNpdHkgICAgICAgICAgIDogMS44MTggVEIKICAgICAgICAgICAgICAg
IFBvd2VyIFN0YXRlICAgICAgICA6IEFjdGl2ZQoKICAgICAgICAgICAgICAgIENvbm5lY3RvciAg
ICAgICAgICA6IFBvcnQgMCAtIDM8SW50ZXJuYWw+PEVuY2wgUG9zIDEgPjogU2xvdCAyIAogICAg
ICAgICAgICAgICAgVmVuZG9yIElkICAgICAgICAgIDogQVRBICAgICAKICAgICAgICAgICAgICAg
IFByb2R1Y3QgSWQgICAgICAgICA6IFdEQyBXRDIwMDJGQUVYLTAKICAgICAgICAgICAgICAgIFN0
YXRlICAgICAgICAgICAgICA6IE9ubGluZQogICAgICAgICAgICAgICAgRGlzayBUeXBlICAgICAg
ICAgIDogU0FUQSxIYXJkIERpc2sgRGV2aWNlCiAgICAgICAgICAgICAgICBDYXBhY2l0eSAgICAg
ICAgICAgOiAxLjgxOCBUQgogICAgICAgICAgICAgICAgUG93ZXIgU3RhdGUgICAgICAgIDogQWN0
aXZlCgogICAgICAgICAgICAgICAgQ29ubmVjdG9yICAgICAgICAgIDogUG9ydCAwIC0gMzxJbnRl
cm5hbD48RW5jbCBQb3MgMSA+OiBTbG90IDMgCiAgICAgICAgICAgICAgICBWZW5kb3IgSWQgICAg
ICAgICAgOiBBVEEgICAgIAogICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAgIDogV0RD
IFdEMjAwMkZBRVgtMAogICAgICAgICAgICAgICAgU3RhdGUgICAgICAgICAgICAgIDogT25saW5l
CiAgICAgICAgICAgICAgICBEaXNrIFR5cGUgICAgICAgICAgOiBTQVRBLEhhcmQgRGlzayBEZXZp
Y2UKICAgICAgICAgICAgICAgIENhcGFjaXR5ICAgICAgICAgICA6IDEuODE4IFRCCiAgICAgICAg
ICAgICAgICBQb3dlciBTdGF0ZSAgICAgICAgOiBBY3RpdmUKCiAgICAgICAgICAgICAgICBDb25u
ZWN0b3IgICAgICAgICAgOiBQb3J0IDAgLSAzPEludGVybmFsPjxFbmNsIFBvcyAxID46IFNsb3Qg
NSAKICAgICAgICAgICAgICAgIFZlbmRvciBJZCAgICAgICAgICA6IEFUQSAgICAgCiAgICAgICAg
ICAgICAgICBQcm9kdWN0IElkICAgICAgICAgOiBXREMgV0QyMDAyRkFFWC0wCiAgICAgICAgICAg
ICAgICBTdGF0ZSAgICAgICAgICAgICAgOiBPbmxpbmUKICAgICAgICAgICAgICAgIERpc2sgVHlw
ZSAgICAgICAgICA6IFNBVEEsSGFyZCBEaXNrIERldmljZQogICAgICAgICAgICAgICAgQ2FwYWNp
dHkgICAgICAgICAgIDogMS44MTggVEIKICAgICAgICAgICAgICAgIFBvd2VyIFN0YXRlICAgICAg
ICA6IEFjdGl2ZQoKICAgICAgICAgICAgICAgIENvbm5lY3RvciAgICAgICAgICA6IFBvcnQgMCAt
IDM8SW50ZXJuYWw+PEVuY2wgUG9zIDEgPjogU2xvdCA2IAogICAgICAgICAgICAgICAgVmVuZG9y
IElkICAgICAgICAgIDogQVRBICAgICAKICAgICAgICAgICAgICAgIFByb2R1Y3QgSWQgICAgICAg
ICA6IFdEQyBXRDIwMDJGQUVYLTAKICAgICAgICAgICAgICAgIFN0YXRlICAgICAgICAgICAgICA6
IE9ubGluZQogICAgICAgICAgICAgICAgRGlzayBUeXBlICAgICAgICAgIDogU0FUQSxIYXJkIERp
c2sgRGV2aWNlCiAgICAgICAgICAgICAgICBDYXBhY2l0eSAgICAgICAgICAgOiAxLjgxOCBUQgog
ICAgICAgICAgICAgICAgUG93ZXIgU3RhdGUgICAgICAgIDogQWN0aXZlCgogICAgICAgICAgICAg
ICAgQ29ubmVjdG9yICAgICAgICAgIDogUG9ydCAwIC0gMzxJbnRlcm5hbD48RW5jbCBQb3MgMSA+
OiBTbG90IDcgCiAgICAgICAgICAgICAgICBWZW5kb3IgSWQgICAgICAgICAgOiBBVEEgICAgIAog
ICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAgIDogV0RDIFdEMjAwMkZBRVgtMAogICAg
ICAgICAgICAgICAgU3RhdGUgICAgICAgICAgICAgIDogT25saW5lCiAgICAgICAgICAgICAgICBE
aXNrIFR5cGUgICAgICAgICAgOiBTQVRBLEhhcmQgRGlzayBEZXZpY2UKICAgICAgICAgICAgICAg
IENhcGFjaXR5ICAgICAgICAgICA6IDEuODE4IFRCCiAgICAgICAgICAgICAgICBQb3dlciBTdGF0
ZSAgICAgICAgOiBBY3RpdmUKCiAgICAgICAgICAgICAgICBDb25uZWN0b3IgICAgICAgICAgOiBQ
b3J0IDAgLSAzPEludGVybmFsPjxFbmNsIFBvcyAxID46IFNsb3QgNCAKICAgICAgICAgICAgICAg
IFZlbmRvciBJZCAgICAgICAgICA6IEFUQSAgICAgCiAgICAgICAgICAgICAgICBQcm9kdWN0IElk
ICAgICAgICAgOiBXREMgV0QyMDAyRkFFWC0wCiAgICAgICAgICAgICAgICBTdGF0ZSAgICAgICAg
ICAgICAgOiBPbmxpbmUKICAgICAgICAgICAgICAgIERpc2sgVHlwZSAgICAgICAgICA6IFNBVEEs
SGFyZCBEaXNrIERldmljZQogICAgICAgICAgICAgICAgQ2FwYWNpdHkgICAgICAgICAgIDogMS44
MTggVEIKICAgICAgICAgICAgICAgIFBvd2VyIFN0YXRlICAgICAgICA6IEFjdGl2ZQoKICAgICAg
ICAgICAgICAgIENvbm5lY3RvciAgICAgICAgICA6IFBvcnQgMCAtIDM8SW50ZXJuYWw+PEVuY2wg
UG9zIDEgPjogU2xvdCAxMSAKICAgICAgICAgICAgICAgIFZlbmRvciBJZCAgICAgICAgICA6IEFU
QSAgICAgCiAgICAgICAgICAgICAgICBQcm9kdWN0IElkICAgICAgICAgOiBXREMgV0QyMDAyRkFF
WC0wCiAgICAgICAgICAgICAgICBTdGF0ZSAgICAgICAgICAgICAgOiBPbmxpbmUKICAgICAgICAg
ICAgICAgIERpc2sgVHlwZSAgICAgICAgICA6IFNBVEEsSGFyZCBEaXNrIERldmljZQogICAgICAg
ICAgICAgICAgQ2FwYWNpdHkgICAgICAgICAgIDogMS44MTggVEIKICAgICAgICAgICAgICAgIFBv
d2VyIFN0YXRlICAgICAgICA6IEFjdGl2ZQoKICAgICAgICAgICAgICAgIENvbm5lY3RvciAgICAg
ICAgICA6IFBvcnQgMCAtIDM8SW50ZXJuYWw+PEVuY2wgUG9zIDEgPjogU2xvdCAxMCAKICAgICAg
ICAgICAgICAgIFZlbmRvciBJZCAgICAgICAgICA6IEFUQSAgICAgCiAgICAgICAgICAgICAgICBQ
cm9kdWN0IElkICAgICAgICAgOiBXREMgV0QyMDAyRkFFWC0wCiAgICAgICAgICAgICAgICBTdGF0
ZSAgICAgICAgICAgICAgOiBPbmxpbmUKICAgICAgICAgICAgICAgIERpc2sgVHlwZSAgICAgICAg
ICA6IFNBVEEsSGFyZCBEaXNrIERldmljZQogICAgICAgICAgICAgICAgQ2FwYWNpdHkgICAgICAg
ICAgIDogMS44MTggVEIKICAgICAgICAgICAgICAgIFBvd2VyIFN0YXRlICAgICAgICA6IEFjdGl2
ZQoKICAgICAgICAgICAgICAgIENvbm5lY3RvciAgICAgICAgICA6IFBvcnQgMCAtIDM8SW50ZXJu
YWw+PEVuY2wgUG9zIDEgPjogU2xvdCA5IAogICAgICAgICAgICAgICAgVmVuZG9yIElkICAgICAg
ICAgIDogQVRBICAgICAKICAgICAgICAgICAgICAgIFByb2R1Y3QgSWQgICAgICAgICA6IFdEQyBX
RDIwMDJGQUVYLTAKICAgICAgICAgICAgICAgIFN0YXRlICAgICAgICAgICAgICA6IE9ubGluZQog
ICAgICAgICAgICAgICAgRGlzayBUeXBlICAgICAgICAgIDogU0FUQSxIYXJkIERpc2sgRGV2aWNl
CiAgICAgICAgICAgICAgICBDYXBhY2l0eSAgICAgICAgICAgOiAxLjgxOCBUQgogICAgICAgICAg
ICAgICAgUG93ZXIgU3RhdGUgICAgICAgIDogQWN0aXZlCgogICAgICAgICAgICAgICAgQ29ubmVj
dG9yICAgICAgICAgIDogUG9ydCAwIC0gMzxJbnRlcm5hbD48RW5jbCBQb3MgMSA+OiBTbG90IDgg
CiAgICAgICAgICAgICAgICBWZW5kb3IgSWQgICAgICAgICAgOiBBVEEgICAgIAogICAgICAgICAg
ICAgICAgUHJvZHVjdCBJZCAgICAgICAgIDogV0RDIFdEMjAwMkZBRVgtMAogICAgICAgICAgICAg
ICAgU3RhdGUgICAgICAgICAgICAgIDogT25saW5lCiAgICAgICAgICAgICAgICBEaXNrIFR5cGUg
ICAgICAgICAgOiBTQVRBLEhhcmQgRGlzayBEZXZpY2UKICAgICAgICAgICAgICAgIENhcGFjaXR5
ICAgICAgICAgICA6IDEuODE4IFRCCiAgICAgICAgICAgICAgICBQb3dlciBTdGF0ZSAgICAgICAg
OiBBY3RpdmUKCiAgICAgICAgICAgICAgICBDb25uZWN0b3IgICAgICAgICAgOiBQb3J0IDAgLSAz
PEludGVybmFsPjxFbmNsIFBvcyAxID46IFNsb3QgMTUgCiAgICAgICAgICAgICAgICBWZW5kb3Ig
SWQgICAgICAgICAgOiBBVEEgICAgIAogICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAg
IDogV0RDIFdEMjAwMkZBRVgtMAogICAgICAgICAgICAgICAgU3RhdGUgICAgICAgICAgICAgIDog
T25saW5lCiAgICAgICAgICAgICAgICBEaXNrIFR5cGUgICAgICAgICAgOiBTQVRBLEhhcmQgRGlz
ayBEZXZpY2UKICAgICAgICAgICAgICAgIENhcGFjaXR5ICAgICAgICAgICA6IDEuODE4IFRCCiAg
ICAgICAgICAgICAgICBQb3dlciBTdGF0ZSAgICAgICAgOiBBY3RpdmUKCiAgICAgICAgICAgICAg
ICBDb25uZWN0b3IgICAgICAgICAgOiBQb3J0IDAgLSAzPEludGVybmFsPjxFbmNsIFBvcyAxID46
IFNsb3QgMTQgCiAgICAgICAgICAgICAgICBWZW5kb3IgSWQgICAgICAgICAgOiBBVEEgICAgIAog
ICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAgIDogV0RDIFdEMjAwMkZBRVgtMAogICAg
ICAgICAgICAgICAgU3RhdGUgICAgICAgICAgICAgIDogT25saW5lCiAgICAgICAgICAgICAgICBE
aXNrIFR5cGUgICAgICAgICAgOiBTQVRBLEhhcmQgRGlzayBEZXZpY2UKICAgICAgICAgICAgICAg
IENhcGFjaXR5ICAgICAgICAgICA6IDEuODE4IFRCCiAgICAgICAgICAgICAgICBQb3dlciBTdGF0
ZSAgICAgICAgOiBBY3RpdmUKCiAgICAgICAgICAgICAgICBDb25uZWN0b3IgICAgICAgICAgOiBQ
b3J0IDAgLSAzPEludGVybmFsPjxFbmNsIFBvcyAxID46IFNsb3QgMTMgCiAgICAgICAgICAgICAg
ICBWZW5kb3IgSWQgICAgICAgICAgOiBBVEEgICAgIAogICAgICAgICAgICAgICAgUHJvZHVjdCBJ
ZCAgICAgICAgIDogV0RDIFdEMjAwMkZBRVgtMAogICAgICAgICAgICAgICAgU3RhdGUgICAgICAg
ICAgICAgIDogT25saW5lCiAgICAgICAgICAgICAgICBEaXNrIFR5cGUgICAgICAgICAgOiBTQVRB
LEhhcmQgRGlzayBEZXZpY2UKICAgICAgICAgICAgICAgIENhcGFjaXR5ICAgICAgICAgICA6IDEu
ODE4IFRCCiAgICAgICAgICAgICAgICBQb3dlciBTdGF0ZSAgICAgICAgOiBBY3RpdmUKCiAgICAg
ICAgICAgICAgICBDb25uZWN0b3IgICAgICAgICAgOiBQb3J0IDAgLSAzPEludGVybmFsPjxFbmNs
IFBvcyAxID46IFNsb3QgMTIgCiAgICAgICAgICAgICAgICBWZW5kb3IgSWQgICAgICAgICAgOiBB
VEEgICAgIAogICAgICAgICAgICAgICAgUHJvZHVjdCBJZCAgICAgICAgIDogV0RDIFdEMjAwMkZB
RVgtMAogICAgICAgICAgICAgICAgU3RhdGUgICAgICAgICAgICAgIDogT25saW5lCiAgICAgICAg
ICAgICAgICBEaXNrIFR5cGUgICAgICAgICAgOiBTQVRBLEhhcmQgRGlzayBEZXZpY2UKICAgICAg
ICAgICAgICAgIENhcGFjaXR5ICAgICAgICAgICA6IDEuODE4IFRCCiAgICAgICAgICAgICAgICBQ
b3dlciBTdGF0ZSAgICAgICAgOiBBY3RpdmUKClN0b3JhZ2UKCiAgICAgICBWaXJ0dWFsIERyaXZl
cwogICAgICAgICAgICAgICAgVmlydHVhbCBkcml2ZSAgICAgIDogVGFyZ2V0IElkIDAgLFZEIG5h
bWUgCiAgICAgICAgICAgICAgICBTaXplICAgICAgICAgICAgICAgOiAyNS40NjMgVEIKICAgICAg
ICAgICAgICAgIFN0YXRlICAgICAgICAgICAgICA6IE9wdGltYWwKICAgICAgICAgICAgICAgIFJB
SUQgTGV2ZWwgICAgICAgICA6IDYgCgoKRXhpdCBDb2RlOiAweDAwCg==
--f46d04428770e298a604eccb9add
Content-Type: text/plain; charset=US-ASCII; name="xfs_info.txt"
Content-Disposition: attachment; filename="xfs_info.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hou6dstp2

bWV0YS1kYXRhPS9kZXYvc2RhMSAgICAgICAgICAgICAgaXNpemU9MjU2ICAgIGFnY291bnQ9MjYs
IGFnc2l6ZT0yNjg0MzU0NTUgYmxrcwogICAgICAgICA9ICAgICAgICAgICAgICAgICAgICAgICBz
ZWN0c3o9NTEyICAgYXR0cj0yCmRhdGEgICAgID0gICAgICAgICAgICAgICAgICAgICAgIGJzaXpl
PTQwOTYgICBibG9ja3M9NjgzNTQwNDI4OCwgaW1heHBjdD01CiAgICAgICAgID0gICAgICAgICAg
ICAgICAgICAgICAgIHN1bml0PTAgICAgICBzd2lkdGg9MCBibGtzCm5hbWluZyAgID12ZXJzaW9u
IDIgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBhc2NpaS1jaT0wCmxvZyAgICAgID1pbnRlcm5h
bCAgICAgICAgICAgICAgIGJzaXplPTQwOTYgICBibG9ja3M9NTIxNzI4LCB2ZXJzaW9uPTIKICAg
ICAgICAgPSAgICAgICAgICAgICAgICAgICAgICAgc2VjdHN6PTUxMiAgIHN1bml0PTAgYmxrcywg
bGF6eS1jb3VudD0xCnJlYWx0aW1lID1ub25lICAgICAgICAgICAgICAgICAgIGV4dHN6PTQwOTYg
ICBibG9ja3M9MCwgcnRleHRlbnRzPTAK
--f46d04428770e298a604eccb9add
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--f46d04428770e298a604eccb9add--
