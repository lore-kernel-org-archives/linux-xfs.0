Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A8EFE7F5E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 09:30:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 896EB8F8049
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:30:34 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	YVUPRHbeW49BaWrP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 07:30:32 -0700 (PDT)
Received: by wibxm9 with SMTP id xm9so93539916wib.0
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:30:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150720114648.GB53450@bfoster.bfoster>
References: <CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
	<20150709151811.GE63282@bfoster.bfoster>
	<CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
	<20150709183255.GG63282@bfoster.bfoster>
	<CA++_uht5N6MtqUQfbB9A3R__UvR4aLN2q5-mFKiO__vU-Cxwpw@mail.gmail.com>
	<20150713125214.GA50787@bfoster.bfoster>
	<CA++_uhvrDBuP9nANTc0ZxZudDriYKrrtnaQUZzXPRLs0otD22w@mail.gmail.com>
	<20150713170158.GB50787@bfoster.bfoster>
	<CA++_uhvDrO2BmQ+q0bN=M_L-vUUaLZO9bHoKh0ntFveM5t-DNQ@mail.gmail.com>
	<CA++_uhuJNkO4MDyS_+veFpysGyqzhqLspB3g73DtUCQqK1F80Q@mail.gmail.com>
	<20150720114648.GB53450@bfoster.bfoster>
Date: Mon, 20 Jul 2015 22:30:31 +0800
Message-ID: <CA++_uhvwR1KucdHWnPzS5ysFuYyssFnUB95kS-piC_pRnq=dXw@mail.gmail.com>
Subject: Re: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
	xfs_dir2_sf_get_parent_ino+0xa/0x20
From: Kuo Hugo <tonytkdk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1231010175806122022=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============1231010175806122022==
Content-Type: multipart/alternative; boundary=047d7bfcf2f64167ef051b4f615d

--047d7bfcf2f64167ef051b4f615d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Brain,

>I don=E2=80=99t know much about the Swift bug. A BUG() or crash in the ker=
nel is
generally always a kernel bug, regardless of what userspace is doing. It
>certainly could be that whatever userspace is doing to trigger the kernel
bug is a bug in the userspace application, but either way it shouldn=E2=80=
=99t
cause the >kernel to crash. By the same token, if Swift is updated to fix
the aforementioned bug and the kernel crash no longer reproduces, that
doesn=E2=80=99t >necessarily mean the kernel bug is fixed (just potentially=
 hidden).

Understand.

[Previous Message]

The valid inode has an inode number of 13668207561.
- The fsname for this inode is "sdb."
- The inode does appear to have a non-NULL if_data:

    if_u1 =3D {
      if_extents =3D 0xffff88084feaf5c0,
      if_ext_irec =3D 0xffff88084feaf5c0,
      if_data =3D 0xffff88084feaf5c0 "\004"
    },

        find <mntpath> -inum 13668207561

Q1: Were you able to track down the directory inode mentioned in the
previous message?

Ans: Yes, it=E2=80=99s the directory/file as below. /srv/node/d224 is the m=
ount
point of /dev/sdb . This is the original location of the path. This folder
includes the file 1436266052.71893.ts now. The .ts file is 0 size


[root@r2obj01 ~]# find /srv/node/d224 -inum 13668207561
/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32

[root@r2obj01 ~]# ls -lrt
/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32
-rw------- 1 swift swift 0 Jul 7 22:37 1436266052.71893.ts

Q2: Is it some kind of internal directory used by the application (e.g.,
perhaps related to the quarantine mechanism mentioned in the bug)?

Ans: Yes, it=E2=80=99s a directory which accessing by application.


 37 ffff8810718343c0 ffff88105b9d32c0 ffff8808745aa5e8 REG  [eventpoll]
 38 ffff8808713da780 ffff880010c9a900 ffff88096368a188 REG
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32/1436266=
042.57775.ts
 39 ffff880871cb03c0 ffff880495a8b380 ffff8808a5e6c988 REG
/srv/node/d224/tmp/tmpSpnrHg

 40 ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32

The above operation in the swift-object-server was doing python function
call to rename the file
* /srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32/1436266=
042.57775.ts*
as
*/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32/143626=
6042.57775.ts*

os.rename(old, new)

And it crashed at this point. In the Q1, we found the inum is pointing to
the directory
/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32 .

We found that multiple(over 10) DELETE from application against the target
file at almost same moment. The DELETE is removing the original file in the
directory and create new empty .ts file in this directory. I suspect that
multiple os.rename on the same file in that directory will cause the kernel
panic.

And the file
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32/1436266=
042.57775.ts
was not created.

Regards // Hugo
=E2=80=8B

--047d7bfcf2f64167ef051b4f615d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"" style=3D""><p style=3D"margin:0px 0px 1.2e=
m!important">Hi Brain, </p>
<p style=3D"margin:0px 0px 1.2em!important">&gt;I don=E2=80=99t know much a=
bout the Swift bug. A BUG() or crash in the kernel is generally always a ke=
rnel bug, regardless of what userspace is doing. It &gt;certainly could be =
that whatever userspace is doing to trigger the kernel bug is a bug in the =
userspace application, but either way it shouldn=E2=80=99t cause the &gt;ke=
rnel to crash. By the same token, if Swift is updated to fix the aforementi=
oned bug and the kernel crash no longer reproduces, that doesn=E2=80=99t &g=
t;necessarily mean the kernel bug is fixed (just potentially hidden).</p><p=
 style=3D"margin:0px 0px 1.2em!important">Understand.=C2=A0</p>
<p style=3D"margin:0px 0px 1.2em!important">[Previous Message]</p>
<pre style=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:=
1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"font-size:0.85em;fon=
t-family:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;white-spa=
ce:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,204);pa=
dding:0.5em 0.7em;display:block!important;background-color:rgb(248,248,248)=
">The valid inode has an inode number of 13668207561.
- The fsname for this inode is &quot;sdb.&quot;
- The inode does appear to have a non-NULL if_data:

    if_u1 =3D {
      if_extents =3D 0xffff88084feaf5c0,
      if_ext_irec =3D 0xffff88084feaf5c0,
      if_data =3D 0xffff88084feaf5c0 &quot;\004&quot;
    },

        find &lt;mntpath&gt; -inum 13668207561
</code></pre><p style=3D"margin:0px 0px 1.2em!important">Q1: Were you able =
to track down the directory inode mentioned in the previous message?</p>
<p style=3D"margin:0px 0px 1.2em!important">Ans: Yes, it=E2=80=99s the dire=
ctory/file as below. /srv/node/d224 is the mount point of /dev/sdb . This i=
s the original location of the path. This folder includes the file 14362660=
52.71893.ts now. The .ts file is 0 size </p>
<pre style=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:=
1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"font-size:0.85em;fon=
t-family:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;white-spa=
ce:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,204);pa=
dding:0.5em 0.7em;display:block!important;background-color:rgb(248,248,248)=
">
[root@r2obj01 ~]# find /srv/node/d224 -inum 13668207561
/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32

[root@r2obj01 ~]# ls -lrt /srv/node/d224/objects/45382/b32/b146865bf8034bfc=
42570b747c341b32
-rw------- 1 swift swift 0 Jul 7 22:37 1436266052.71893.ts
</code></pre><p style=3D"margin:0px 0px 1.2em!important">Q2: Is it some kin=
d of internal directory used by the application (e.g., perhaps related to t=
he quarantine mechanism mentioned in the bug)?</p>
<p style=3D"margin:0px 0px 1.2em!important">Ans: Yes, it=E2=80=99s a direct=
ory which accessing by application. </p>
<pre style=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:=
1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"font-size:0.85em;fon=
t-family:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;white-spa=
ce:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,204);pa=
dding:0.5em 0.7em;display:block!important;background-color:rgb(248,248,248)=
">
 37 ffff8810718343c0 ffff88105b9d32c0 ffff8808745aa5e8 REG  [eventpoll]
 38 ffff8808713da780 ffff880010c9a900 ffff88096368a188 REG /srv/node/d224/q=
uarantined/objects/b146865bf8034bfc42570b747c341b32/1436266042.57775.ts
 39 ffff880871cb03c0 ffff880495a8b380 ffff8808a5e6c988 REG  /srv/node/d224/=
tmp/tmpSpnrHg

 40 ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR  /srv/node/d224/=
quarantined/objects/b146865bf8034bfc42570b747c341b32
</code></pre><p style=3D"margin:0px 0px 1.2em!important">The above operatio=
n in the swift-object-server was doing python function call to rename the f=
ile<i>=C2=A0/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b=
32/1436266042.57775.ts</i>=C2=A0as <i>/srv/node/d224/quarantined/objects/b1=
46865bf8034bfc42570b747c341b32/1436266042.57775.ts</i></p>
<p style=3D"margin:0px 0px 1.2em!important"></p><div class=3D""><p></p><blo=
ckquote style=3D"margin:0px 0px 0px 40px;border:none;padding:0px"><div><div=
><div><span style=3D"color:rgb(51,51,51);font-family:Consolas,&#39;Liberati=
on Mono&#39;,Menlo,Courier,monospace;font-size:12px;line-height:16.79999923=
70605px;white-space:pre">os.rename(old, new)</span></div></div></div></bloc=
kquote><p></p></div><p style=3D"margin:0px 0px 1.2em!important"></p>
<p style=3D"margin:0px 0px 1.2em!important">And it crashed at this point. I=
n the Q1, we found the inum is pointing to the directory=C2=A0<span style=
=3D"font-family:Consolas,Inconsolata,Courier,monospace;font-size:12px;line-=
height:15.6000003814697px;white-space:pre;background-color:rgb(248,248,248)=
">/srv/node/d224/objects/45382/b32/b146865bf8034bfc42570b747c341b32</span>=
=C2=A0.=C2=A0</p><p style=3D"margin:0px 0px 1.2em!important">We found that =
multiple(over 10) DELETE from application against the target file at almost=
 same moment. The DELETE is removing the original file in the directory and=
 create new empty .ts file in this directory. I suspect that multiple os.re=
name on the same file in that directory will cause the kernel panic.=C2=A0<=
/p><p style=3D"margin:0px 0px 1.2em!important">And the file /srv/node/d224/=
quarantined/objects/b146865bf8034bfc42570b747c341b32/1436266042.57775.ts wa=
s not created.<br></p><p style=3D"margin:0px 0px 1.2em!important">Regards /=
/ Hugo=C2=A0</p>
<div title=3D"MDH:PGRpdj48Zm9udCBjb2xvcj0iIzk5OTk5OSI+PHNwYW4gc3R5bGU9ImZvb=
nQtc2l6ZTogMTRweDsi
PkhpIEJyYWluLCZuYnNwOzwvc3Bhbj48L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBjb2xvcj0iIzk=
5
OTk5OSI+PGI+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogMTRweDsiPjxicj48L3NwYW4+PC9iPjw=
v
Zm9udD48L2Rpdj48Zm9udCBjb2xvcj0iIzk5OTk5OSI+PGI+PHNwYW4gc3R5bGU9ImZvbnQtc2l=
6
ZTogMTRweDsiPkkgZG9uJ3Qga25vdyBtdWNoIGFib3V0IHRoZSBTd2lmdCBidWcuIEEgQlVHKCk=
g
b3IgY3Jhc2ggaW4gdGhlIGtlcm5lbCBpcyZuYnNwOzwvc3Bhbj48c3BhbiBzdHlsZT0iZm9udC1=
z
aXplOiAxNHB4OyI+Z2VuZXJhbGx5IGFsd2F5cyBhIGtlcm5lbCBidWcsIHJlZ2FyZGxlc3Mgb2Y=
g
d2hhdCB1c2Vyc3BhY2UgaXMgZG9pbmcuIEl0Jm5ic3A7PC9zcGFuPjxzcGFuIHN0eWxlPSJmb25=
0
LXNpemU6IDE0cHg7Ij5jZXJ0YWlubHkgY291bGQgYmUgdGhhdCB3aGF0ZXZlciB1c2Vyc3BhY2U=
g
aXMgZG9pbmcgdG8gdHJpZ2dlciB0aGUmbmJzcDs8L3NwYW4+PC9iPjwvZm9udD48YiBzdHlsZT0=
i
Y29sb3I6IHJnYigxNTMsIDE1MywgMTUzKTsiPjxzcGFuIHN0eWxlPSJmb250LXNpemU6IDE0cHg=
7
Ij5rZXJuZWwgYnVnIGlzIGEgYnVnIGluIHRoZSB1c2Vyc3BhY2UgYXBwbGljYXRpb24sIGJ1dCB=
l
aXRoZXIgd2F5IGl0Jm5ic3A7PC9zcGFuPjwvYj48YiBzdHlsZT0iY29sb3I6IHJnYigxNTMsIDE=
1
MywgMTUzKTsiPjxzcGFuIHN0eWxlPSJmb250LXNpemU6IDE0cHg7Ij5zaG91bGRuJ3QgY2F1c2U=
g
dGhlIGtlcm5lbCB0byBjcmFzaC4gQnkgdGhlIHNhbWUgdG9rZW4sIGlmIFN3aWZ0IGlzJm5ic3A=
7
PC9zcGFuPjwvYj48YiBzdHlsZT0iY29sb3I6IHJnYigxNTMsIDE1MywgMTUzKTsiPjxzcGFuIHN=
0
eWxlPSJmb250LXNpemU6IDE0cHg7Ij51cGRhdGVkIHRvIGZpeCB0aGUgYWZvcmVtZW50aW9uZWQ=
g
YnVnIGFuZCB0aGUga2VybmVsIGNyYXNoIG5vIGxvbmdlciZuYnNwOzwvc3Bhbj48L2I+PGIgc3R=
5
bGU9ImNvbG9yOiByZ2IoMTUzLCAxNTMsIDE1Myk7Ij48c3BhbiBzdHlsZT0iZm9udC1zaXplOiA=
x
NHB4OyI+cmVwcm9kdWNlcywgdGhhdCBkb2Vzbid0IG5lY2Vzc2FyaWx5IG1lYW4gdGhlIGtlcm5=
l
bCBidWcgaXMgZml4ZWQgKGp1c3QmbmJzcDs8L3NwYW4+PC9iPjxiIHN0eWxlPSJjb2xvcjogcmd=
i
KDE1MywgMTUzLCAxNTMpOyI+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogMTRweDsiPnBvdGVudGl=
h
bGx5IGhpZGRlbikuPC9zcGFuPjwvYj48ZGl2Pjxmb250IGNvbG9yPSIjOTk5OTk5Ij48Yj48YnI=
+
PC9iPjwvZm9udD48L2Rpdj48ZGl2PltQcmV2aW91cyBNZXNzYWdlXTwvZGl2PjxkaXY+PGJyPjw=
v
ZGl2PjxkaXY+YGBgPC9kaXY+PGRpdj48c3BhbiBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+VGh=
l
IHZhbGlkIGlub2RlIGhhcyBhbiBpbm9kZSBudW1iZXIgb2YgMTM2NjgyMDc1NjEuPC9zcGFuPjx=
i
ciBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogMTRweDs=
i
Pi0gVGhlIGZzbmFtZSBmb3IgdGhpcyBpbm9kZSBpcyAic2RiLiI8L3NwYW4+PGJyIHN0eWxlPSJ=
m
b250LXNpemU6IDE0cHg7Ij48c3BhbiBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+LSBUaGUgaW5=
v
ZGUgZG9lcyBhcHBlYXIgdG8gaGF2ZSBhIG5vbi1OVUxMIGlmX2RhdGE6PC9zcGFuPjwvZGl2Pjx=
k
aXY+PGJyIHN0eWxlPSJmb250LXNpemU6IDE0cHg7Ij48c3BhbiBzdHlsZT0iZm9udC1zaXplOiA=
x
NHB4OyI+Jm5ic3A7ICZuYnNwOyBpZl91MSA9IHs8L3NwYW4+PGJyIHN0eWxlPSJmb250LXNpemU=
6
IDE0cHg7Ij48c3BhbiBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+Jm5ic3A7ICZuYnNwOyAmbmJ=
z
cDsgaWZfZXh0ZW50cyA9IDB4ZmZmZjg4MDg0ZmVhZjVjMCw8L3NwYW4+PGJyIHN0eWxlPSJmb25=
0
LXNpemU6IDE0cHg7Ij48c3BhbiBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+Jm5ic3A7ICZuYnN=
w
OyAmbmJzcDsgaWZfZXh0X2lyZWMgPSAweGZmZmY4ODA4NGZlYWY1YzAsPC9zcGFuPjxiciBzdHl=
s
ZT0iZm9udC1zaXplOiAxNHB4OyI+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogMTRweDsiPiZuYnN=
w
OyAmbmJzcDsgJm5ic3A7IGlmX2RhdGEgPSAweGZmZmY4ODA4NGZlYWY1YzAgIlwwMDQiPC9zcGF=
u
PjxiciBzdHlsZT0iZm9udC1zaXplOiAxNHB4OyI+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogMTR=
w
eDsiPiZuYnNwOyAmbmJzcDsgfSw8L3NwYW4+PC9kaXY+PGRpdj48c3BhbiBzdHlsZT0iZm9udC1=
z
aXplOiAxNHB4OyI+PGJyPjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuIHN0eWxlPSJmb250LXNpemU=
6
IDE0cHg7Ij4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgZmluZCAmbHQ7bW50cGF0aCZndDs=
g
LWludW0gMTM2NjgyMDc1NjE8L3NwYW4+PGZvbnQgY29sb3I9IiM5OTk5OTkiPjxiPjxicj48L2I=
+
PC9mb250PjwvZGl2PjxkaXY+YGBgPC9kaXY+PGRpdj48YnI+PC9kaXY+UTE6IFdlcmUgeW91IGF=
i
bGUgdG8gdHJhY2sgZG93biB0aGUgZGlyZWN0b3J5IGlub2RlIG1lbnRpb25lZCBpbiB0aGUgcHJ=
l
dmlvdXMgbWVzc2FnZT88YnI+PGJyPkFuczogWWVzLCBpdCdzIHRoZSBkaXJlY3RvcnkvZmlsZSB=
h
cyBiZWxvdy4gL3Nydi9ub2RlL2QyMjQgaXMgdGhlIG1vdW50IHBvaW50IG9mIC9kZXYvc2RiIC4=
g
VGhpcyBpcyB0aGUgb3JpZ2luYWwgbG9jYXRpb24gb2YgdGhlIHBhdGguIFRoaXMgZm9sZGVyIGl=
u
Y2x1ZGVzIHRoZSBmaWxlwqA8c3BhbiBzdHlsZT0iZm9udC1zaXplOiB4LXNtYWxsOyI+MTQzNjI=
2
NjA1Mi43MTg5My50cyBub3cuIFRoZSAudHMgZmlsZSBpcyAwIHNpemUmbmJzcDs8L3NwYW4+PGJ=
y
PjxkaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5gYGA8YnI+PC9kaXY+PC9kaXY+PHNwYW4gc3R5bGU=
9
ImZvbnQtc2l6ZTogeC1zbWFsbDsiPltyb290QHIyb2JqMDEgfl0jIGZpbmQgL3Nydi9ub2RlL2Q=
y
MjQgLWludW0gMTM2NjgyMDc1NjE8L3NwYW4+PGJyPjxzcGFuIHN0eWxlPSJmb250LXNpemU6IHg=
t
c21hbGw7Ij4vc3J2L25vZGUvZDIyNC9vYmplY3RzLzQ1MzgyL2IzMi9iMTQ2ODY1YmY4MDM0YmZ=
j
NDI1NzBiNzQ3YzM0MWIzMjwvc3Bhbj48ZGl2Pjxmb250IHNpemU9IjEiPjxicj48L2ZvbnQ+PHN=
w
YW4gc3R5bGU9ImZvbnQtc2l6ZTogeC1zbWFsbDsiPltyb290QHIyb2JqMDEgfl0jIGxzIC1scnQ=
g
L3Nydi9ub2RlL2QyMjQvb2JqZWN0cy80NTM4Mi9iMzIvYjE0Njg2NWJmODAzNGJmYzQyNTcwYjc=
0
N2MzNDFiMzI8L3NwYW4+PGJyPjxkaXY+PGRpdj48ZGl2Pjxmb250IHNpemU9IjEiPi1ydy0tLS0=
t
LS0gMSBzd2lmdCBzd2lmdCAwIEp1bCA3IDIyOjM3IDE0MzYyNjYwNTIuNzE4OTMudHM8L2ZvbnQ=
+
PC9kaXY+PC9kaXY+PC9kaXY+PGRpdj48ZGl2PjxkaXY+YGBgPGJyPjxkaXY+PGJyPjwvZGl2Pjx=
i
cj5RMjogSXMgaXQgc29tZSBraW5kIG9mIGludGVybmFsIGRpcmVjdG9yeSB1c2VkIGJ5IHRoZSB=
h
cHBsaWNhdGlvbiAoZS5nLiwgcGVyaGFwcyByZWxhdGVkIHRvIHRoZSBxdWFyYW50aW5lIG1lY2h=
h
bmlzbSBtZW50aW9uZWQgaW4gdGhlIGJ1Zyk/PGRpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PkFuczo=
g
WWVzLCBpdCdzIGEgZGlyZWN0b3J5IHdoaWNoIGFjY2Vzc2luZyBieSBhcHBsaWNhdGlvbi4mbmJ=
z
cDs8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxkaXY+YGBgPC9kaXY+PC9kaXY+PC9kaXY+PC9=
k
aXY+PC9kaXY+PC9kaXY+PGZvbnQgc2l6ZT0iMSI+Jm5ic3A7MzcgZmZmZjg4MTA3MTgzNDNjMCB=
m
ZmZmODgxMDViOWQzMmMwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmVudHBvbGxdPGJ=
y
PiZuYnNwOzM4IGZmZmY4ODA4NzEzZGE3ODAgZmZmZjg4MDAxMGM5YTkwMCBmZmZmODgwOTYzNjh=
h
MTg4IFJFRyAvc3J2L25vZGUvZDIyNC9xdWFyYW50aW5lZC9vYmplY3RzL2IxNDY4NjViZjgwMzR=
i
ZmM0MjU3MGI3NDdjMzQxYjMyLzE0MzYyNjYwNDIuNTc3NzUudHM8YnI+Jm5ic3A7MzkgZmZmZjg=
4
MDg3MWNiMDNjMCBmZmZmODgwNDk1YThiMzgwIGZmZmY4ODA4YTVlNmM5ODggUkVHICZuYnNwOy9=
z
cnYvbm9kZS9kMjI0L3RtcC90bXBTcG5ySGc8YnI+PC9mb250PjxkaXY+PGRpdj48ZGl2Pjxmb25=
0
IHNpemU9IjEiPiZuYnNwOzQwIGZmZmY4ODA4NzE1YjQ1NDAgZmZmZjg4MDQ4MTljNThjMCBmZmZ=
m
ODgwMjM4MWY4ZDg4IERJUiAmbmJzcDsvc3J2L25vZGUvZDIyNC9xdWFyYW50aW5lZC9vYmplY3R=
z
L2IxNDY4NjViZjgwMzRiZmM0MjU3MGI3NDdjMzQxYjMyPC9mb250PjwvZGl2PjwvZGl2PjwvZGl=
2
PjxkaXY+PGRpdj5gYGA8YnI+PC9kaXY+PGRpdj5UaGUgYWJvdmUgb3BlcmF0aW9uIGluIHRoZSB=
z
d2lmdC1vYmplY3Qtc2VydmVyIHdhcyBkb2luZyBweXRob24gZnVuY3Rpb24gY2FsbCB0byByZW5=
h
bWUgdGhlIGZpbGUgYDxzcGFuIHN0eWxlPSJmb250LXNpemU6IHgtc21hbGw7Ij4vc3J2L25vZGU=
v
ZDIyNC9vYmplY3RzLzQ1MzgyL2IzMi9iMTQ2ODY1YmY4MDM0YmZjNDI1NzBiNzQ3YzM0MWIzMi8=
8
L3NwYW4+PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogeC1zbWFsbDsiPjE0MzYyNjYwNDIuNTc3NzU=
u
dHM8L3NwYW4+YCBhcyZuYnNwOzxzcGFuIHN0eWxlPSJmb250LXNpemU6IHgtc21hbGw7Ij4vc3J=
2
L25vZGUvZDIyNC9xdWFyYW50aW5lZC9vYmplY3RzL2IxNDY4NjViZjgwMzRiZmM0MjU3MGI3NDd=
j
MzQxYjMyLzE0MzYyNjYwNDIuNTc3NzUudHM8L3NwYW4+PC9kaXY+PC9kaXY+PC9kaXY+PGRpdj4=
8
c3BhbiBzdHlsZT0iZm9udC1zaXplOiB4LXNtYWxsOyI+PGJyPjwvc3Bhbj48L2Rpdj48YmxvY2t=
x
dW90ZSBzdHlsZT0ibWFyZ2luOiAwcHggMHB4IDBweCA0MHB4OyBib3JkZXI6IG5vbmU7IHBhZGR=
p
bmc6IDBweDsiPjxkaXY+PGRpdj48ZGl2PjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDUxLCA1MSw=
g
NTEpOyBmb250LWZhbWlseTogQ29uc29sYXMsICdMaWJlcmF0aW9uIE1vbm8nLCBNZW5sbywgQ29=
1
cmllciwgbW9ub3NwYWNlOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxNi43OTk5OTk=
y
MzcwNjA1cHg7IHdoaXRlLXNwYWNlOiBwcmU7Ij5vcy5yZW5hbWUob2xkLCBuZXcpPC9zcGFuPjw=
v
ZGl2PjwvZGl2PjwvZGl2PjwvYmxvY2txdW90ZT48ZGl2Pjxicj48L2Rpdj48ZGl2PkFuZCBpdCB=
j
cmFzaGVkIGF0IHRoaXMgcG9pbnQuIEluIHRoZSBRMSwgd2UgZm91bmQgdGhlIGludW0gaXMgcG9=
p
bnRpbmcgdG8gdGhlIGZpbGUmbmJzcDs8c3BhbiBzdHlsZT0iZm9udC1zaXplOiB4LXNtYWxsOyI=
+
MTQzNjI2NjA1Mi43MTg5My50cyBpbnN0ZWFkIG9mJm5ic3A7PC9zcGFuPjxzcGFuIHN0eWxlPSJ=
m
b250LXNpemU6IHgtc21hbGw7Ij4xNDM2MjY2MDQyLjU3Nzc1LnRzIC4gSXQncyBhcm91bmQgMTA=
g
c2Vjb25kcyBzaGlmdC4gQW5kIHRoZSAmbmJzcDtmaWxlJm5ic3A7PC9zcGFuPjxzcGFuIHN0eWx=
l
PSJmb250LXNpemU6IHgtc21hbGw7Ij4mbmJzcDs8L3NwYW4+PHNwYW4gc3R5bGU9ImZvbnQtc2l=
6
ZTogeC1zbWFsbDsiPi9zcnYvbm9kZS9kMjI0L3F1YXJhbnRpbmVkL29iamVjdHMvYjE0Njg2NWJ=
m
ODAzNGJmYzQyNTcwYjc0N2MzNDFiMzIvMTQzNjI2NjA0Mi41Nzc3NS50cyB3YXMgbm90IGNyZWF=
0
ZWQgaW4gc3VjY2Vzc2Z1bGx5LiZuYnNwOzwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuIHN0eWxlPSJ=
m
b250LXNpemU6IHgtc21hbGw7Ij5Gcm9tIG15IHBvaW50IG9mIHZpZXcsIHNlZW1zIGxpa2UgdGh=
l
IGFwcGxpY2F0aW9uIHRyaWVkIHRvIGNhbGwgb3MucmVuYW1lIG9mIGZpbGUmbmJzcDs8L3NwYW4=
+
PHNwYW4gc3R5bGU9ImZvbnQtc2l6ZTogeC1zbWFsbDsiPjE0MzYyNjYwNDIuNTc3NzUudHMgYnV=
0
IGl0IGNhbid0IGZpbmQgaXQgc2luY2UgdGhlIGludW0gaXMgZm9yJm5ic3A7PC9zcGFuPjxzcGF=
u
IHN0eWxlPSJmb250LXNpemU6IHgtc21hbGw7Ij4xNDM2MjY2MDUyLjcxODkzLnRzIC48L3NwYW4=
+
PC9kaXY+PGRpdj48c3BhbiBzdHlsZT0iZm9udC1zaXplOiB4LXNtYWxsOyI+PGJyPjwvc3Bhbj4=
8
L2Rpdj48ZGl2Pjxicj48L2Rpdj4=3D" style=3D"height:0px;width:0px;max-height:0p=
x;max-width:0px;overflow:hidden;font-size:0em;padding:0px;margin:0px">=E2=
=80=8B</div></div></div>

--047d7bfcf2f64167ef051b4f615d--


--===============1231010175806122022==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1231010175806122022==--
