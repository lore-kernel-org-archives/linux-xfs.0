Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8FF77F75
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 04:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CB6E30405F
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 02:05:04 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	SuQiT0cgw0oU3xRM (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 02:05:01 -0700 (PDT)
Received: by iodt126 with SMTP id t126so75100184iod.2
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 02:05:01 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Aug 2015 17:05:00 +0800
Message-ID: <CANX=BtYB4yoGwxz72sUN+6aSVL0fQ1JnS3PEw0zRqTbtO4_KDg@mail.gmail.com>
Subject: xfs directory quota doesn't work
From: Simon Xia <simonxiaomg@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9105940595080709873=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9105940595080709873==
Content-Type: multipart/alternative; boundary=001a114043c60eb392051dce9020

--001a114043c60eb392051dce9020
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi, everyone, I encounter a problem when using xfs

now I have two tasks and I wanna run them in different directory and limit
the directory=E2=80=99s size. I use xfs=E2=80=99s project quota to achieve =
this.

I follow the steps from here:
https://solidlinux.wordpress.com/2012/12/09/xfs-quota-managament/

here is detail of my two config files

/etc/projects:

11:/home/xiameng.xm/xfs_dir/task1
12:/home/xiameng.xm/xfs_dir/task2

/etc/projid:

task1:11
task2:12

and here is my step:

touch test_xfs
dd if=3D/dev/zero of=3Dtest_xfs bs=3D1000000 count=3D1
mkfs.xfs test_xfs

mkdir xfs_dir
mount test_xfs ./xfs_dir -o pquota,loop

xfs_quota -xc 'project =E2=80=93s task1' /home/xiameng.xm/xfs_dir
xfs_quota -xc 'project =E2=80=93s task2' /home/xiameng.xm/xfs_dir

xfs_quota -x -c 'limit -p bhard=3D2m task1' /home/xiameng.xm/xfs_dir
xfs_quota -x -c 'limit -p bhard=3D10m task2' /home/xiameng.xm/xfs_dir

here is the output of xfs_quota -x -c 'report /home/xiameng.xm/xfs_dir'

Project quota on /home/xiameng.xm/xfs_dir (/dev/loop1)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
task1               0          0       2048     00 [--------]
task2               0          0      10240     00 [--------]

the question is no mater how large I create a file in ./xfs_dir/task1 or
./xfs_dir/task2, it success!

the quota limit doesn=E2=80=99t work!

Any help will be appreciated :)


ps: I also post my question here:
http://unix.stackexchange.com/questions/224606/xfs-directory-quota-doesnt-w=
ork

----

Best Regards
Simon Xia
=E2=80=8B

--001a114043c60eb392051dce9020
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"markdown-here-wrapper" style=3D""><p style=
=3D"margin:1.2em 0px!important">hi, everyone, I encounter a problem when us=
ing xfs</p>
<p style=3D"margin:1.2em 0px!important">now I have two tasks and I wanna ru=
n them in different directory and limit the directory=E2=80=99s size. I use=
 xfs=E2=80=99s project quota to achieve this.</p>
<p style=3D"margin:1.2em 0px!important">I follow the steps from here:<a hre=
f=3D"https://solidlinux.wordpress.com/2012/12/09/xfs-quota-managament/">htt=
ps://solidlinux.wordpress.com/2012/12/09/xfs-quota-managament/</a></p>
<p style=3D"margin:1.2em 0px!important">here is detail of my two config fil=
es </p>
<p style=3D"margin:1.2em 0px!important">/etc/projects:</p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">11:/home/xiameng.xm/xfs_d=
ir/task1
12:/home/xiameng.xm/xfs_dir/task2
</code></pre><p style=3D"margin:1.2em 0px!important">/etc/projid:</p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">task1:11
task2:12
</code></pre><p style=3D"margin:1.2em 0px!important">and here is my step:</=
p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">touch test_xfs
dd if=3D/dev/zero of=3Dtest_xfs bs=3D1000000 count=3D1
mkfs.xfs test_xfs

mkdir xfs_dir
mount test_xfs ./xfs_dir -o pquota,loop

xfs_quota -xc &#39;project =E2=80=93s task1&#39; /home/xiameng.xm/xfs_dir
xfs_quota -xc &#39;project =E2=80=93s task2&#39; /home/xiameng.xm/xfs_dir

xfs_quota -x -c &#39;limit -p bhard=3D2m task1&#39; /home/xiameng.xm/xfs_di=
r
xfs_quota -x -c &#39;limit -p bhard=3D10m task2&#39; /home/xiameng.xm/xfs_d=
ir
</code></pre><p style=3D"margin:1.2em 0px!important">here is the output of =
<code style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mo=
nospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px=
 solid rgb(234,234,234);border-radius:3px;display:inline;background-color:r=
gb(248,248,248)">xfs_quota -x -c &#39;report /home/xiameng.xm/xfs_dir&#39;<=
/code></p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">Project quota on /home/xi=
ameng.xm/xfs_dir (/dev/loop1)
                               Blocks
Project ID       Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
task1               0          0       2048     00 [--------]
task2               0          0      10240     00 [--------]
</code></pre><p style=3D"margin:1.2em 0px!important">the question is no mat=
er how large I create a file in <code style=3D"font-size:0.85em;font-family=
:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;padding:0px 0.3em=
;white-space:pre-wrap;border:1px solid rgb(234,234,234);border-radius:3px;d=
isplay:inline;background-color:rgb(248,248,248)">./xfs_dir/task1</code> or =
<code style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mo=
nospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px=
 solid rgb(234,234,234);border-radius:3px;display:inline;background-color:r=
gb(248,248,248)">./xfs_dir/task2</code>, it success!</p>
<p style=3D"margin:1.2em 0px!important">the quota limit doesn=E2=80=99t wor=
k!</p>
<p style=3D"margin:1.2em 0px!important">Any help will be appreciated :)</p>
<p style=3D"margin:1.2em 0px!important"><br></p><p style=3D"margin:1.2em 0p=
x!important">ps: I also post my question here:=C2=A0<a href=3D"http://unix.=
stackexchange.com/questions/224606/xfs-directory-quota-doesnt-work">http://=
unix.stackexchange.com/questions/224606/xfs-directory-quota-doesnt-work</a>=
</p><p style=3D"margin:1.2em 0px!important">----</p><p style=3D"margin:1.2e=
m 0px!important">Best Regards<br>Simon Xia</p>
<div title=3D"MDH:PGRpdj5oaSwgZXZlcnlvbmUsIEkgZW5jb3VudGVyIGEgcHJvYmxlbSB3a=
GVuIHVzaW5nIHhmczwv
ZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+PGRpdj5ub3cgSSBoYXZlIHR3byB0YXNrcyBhbmQgSSB=
3
YW5uYSBydW4gdGhlbSBpbiBkaWZmZXJlbnQgZGlyZWN0b3J5IGFuZCBsaW1pdCB0aGUgZGlyZWN=
0
b3J5J3Mgc2l6ZS4gSSB1c2UgeGZzJ3MgcHJvamVjdCBxdW90YSB0byBhY2hpZXZlIHRoaXMuPC9=
k
aXY+PGRpdj48YnI+PC9kaXY+PGRpdj5JIGZvbGxvdyB0aGUgc3RlcHMgZnJvbSBoZXJlOltodHR=
w
czovL3NvbGlkbGludXgud29yZHByZXNzLmNvbS8yMDEyLzEyLzA5L3hmcy1xdW90YS1tYW5hZ2F=
t
ZW50L11bMV08L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PmhlcmUgaXMgZGV0YWlsIG9mIG15IHR=
3
byBjb25maWcgZmlsZXMmbmJzcDs8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pi9ldGMvcHJvamV=
j
dHM6PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj4mbmJzcDsgJm5ic3A7IDExOi9ob21lL3hpYW1=
l
bmcueG0veGZzX2Rpci90YXNrMTwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyAxMjovaG9tZS94aWF=
t
ZW5nLnhtL3hmc19kaXIvdGFzazI8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pi9ldGMvcHJvaml=
k
OjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyB0YXNrMToxMTwvZGl2Pjx=
k
aXY+Jm5ic3A7ICZuYnNwOyB0YXNrMjoxMjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+YW5kIGh=
l
cmUgaXMgbXkgc3RlcDo8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PiZuYnNwOyAmbmJzcDsgdG9=
1
Y2ggdGVzdF94ZnM8L2Rpdj48ZGl2PiZuYnNwOyAmbmJzcDsgZGQgaWY9L2Rldi96ZXJvIG9mPXR=
l
c3RfeGZzIGJzPTEwMDAwMDAgY291bnQ9MTwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyBta2ZzLnh=
m
cyB0ZXN0X3hmczwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyZuYnNwOzwvZGl2PjxkaXY+Jm5ic3A=
7
ICZuYnNwOyBta2RpciB4ZnNfZGlyPC9kaXY+PGRpdj4mbmJzcDsgJm5ic3A7IG1vdW50IHRlc3R=
f
eGZzIC4veGZzX2RpciAtbyBwcXVvdGEsbG9vcDwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyZuYnN=
w
OzwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyB4ZnNfcXVvdGEgLXhjICdwcm9qZWN0IOKAk3MgdGF=
z
azEnIC9ob21lL3hpYW1lbmcueG0veGZzX2RpcjwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyB4ZnN=
f
cXVvdGEgLXhjICdwcm9qZWN0IOKAk3MgdGFzazInIC9ob21lL3hpYW1lbmcueG0veGZzX2Rpcjw=
v
ZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyZuYnNwOzwvZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyB4ZnN=
f
cXVvdGEgLXggLWMgJ2xpbWl0IC1wIGJoYXJkPTJtIHRhc2sxJyAvaG9tZS94aWFtZW5nLnhtL3h=
m
c19kaXI8L2Rpdj48ZGl2PiZuYnNwOyAmbmJzcDsgeGZzX3F1b3RhIC14IC1jICdsaW1pdCAtcCB=
i
aGFyZD0xMG0gdGFzazInIC9ob21lL3hpYW1lbmcueG0veGZzX2RpcjwvZGl2PjxkaXY+PGJyPjw=
v
ZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+aGVyZSBpcyB0aGUgb3V0cHV0IG9mIGB4ZnNfcXVvdGE=
g
LXggLWMgJ3JlcG9ydCAvaG9tZS94aWFtZW5nLnhtL3hmc19kaXInYDwvZGl2PjxkaXY+PGJyPjw=
v
ZGl2PjxkaXY+Jm5ic3A7ICZuYnNwOyBQcm9qZWN0IHF1b3RhIG9uIC9ob21lL3hpYW1lbmcueG0=
v
eGZzX2RpciAoL2Rldi9sb29wMSk8L2Rpdj48ZGl2PiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnN=
w
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A=
7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7QmxvY2tzPC9kaXY+PGR=
p
dj4mbmJzcDsgJm5ic3A7IFByb2plY3QgSUQgJm5ic3A7ICZuYnNwOyAmbmJzcDsgVXNlZCAmbmJ=
z
cDsgJm5ic3A7ICZuYnNwOyBTb2Z0ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEhhcmQgJm5ic3A7ICZ=
u
YnNwO1dhcm4vR3JhY2U8L2Rpdj48ZGl2PiZuYnNwOyAmbmJzcDsgLS0tLS0tLS0tLSAtLS0tLS0=
t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTwvZGl2PjxkaXY+Jm5=
i
c3A7ICZuYnNwOyB0YXNrMSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnN=
w
OyAmbmJzcDsgMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7MCAmbmJzcDsgJm5=
i
c3A7ICZuYnNwOyAyMDQ4ICZuYnNwOyAmbmJzcDsgMDAgWy0tLS0tLS0tXTwvZGl2PjxkaXY+Jm5=
i
c3A7ICZuYnNwOyB0YXNrMiAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnN=
w
OyAmbmJzcDsgMCAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7MCAmbmJzcDsgJm5=
i
c3A7ICZuYnNwOzEwMjQwICZuYnNwOyAmbmJzcDsgMDAgWy0tLS0tLS0tXTwvZGl2PjxkaXY+PGJ=
y
PjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+dGhlIHF1ZXN0aW9uIGlzIG5vIG1hdGVyIGhvdyB=
s
YXJnZSBJIGNyZWF0ZSBhIGZpbGUgaW4gYC4veGZzX2Rpci90YXNrMWAgb3IgYC4veGZzX2Rpci9=
0
YXNrMmAsIGl0IHN1Y2Nlc3MhPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj50aGUgcXVvdGEgbGl=
t
aXQgZG9lc24ndCB3b3JrITwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+QW55IGhlbHAgd2lsbCB=
i
ZSBhcHByZWNpYXRlZCA6KTwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+Jm5ic3A7IFsxXTogaHR=
0
cHM6Ly9zb2xpZGxpbnV4LndvcmRwcmVzcy5jb20vMjAxMi8xMi8wOS94ZnMtcXVvdGEtbWFuYWd=
h
bWVudC88L2Rpdj48L2Rpdj48YnIgY2xlYXI9ImFsbCI+PGRpdj48YnI+PC9kaXY+PGRpdj48YnI=
+
PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj48YnI+PC9kaXY+PGJyPjxkaXYgY2xhc3M9ImdtYWl=
s
X3NpZ25hdHVyZSI+PGRpdiBkaXI9Imx0ciI+QmVzdCBSZWdhcmRzPGRpdj48YnI+PC9kaXY+PGR=
p
dj5TaW1vbiBYaWE8L2Rpdj48L2Rpdj48L2Rpdj4K" style=3D"height:0;width:0;max-hei=
ght:0;max-width:0;overflow:hidden;font-size:0em;padding:0;margin:0">=E2=80=
=8B</div></div></div>

--001a114043c60eb392051dce9020--


--===============9105940595080709873==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9105940595080709873==--
