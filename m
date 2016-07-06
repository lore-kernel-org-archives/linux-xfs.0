Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8DC4C7CD7
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 05:35:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 610208F8039
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 03:35:06 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	3TwYIxxOcacqByXe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Jul 2016 03:35:00 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id t74so196479757ioi.0
	for <xfs@oss.sgi.com>; Wed, 06 Jul 2016 03:35:00 -0700 (PDT)
From: Kirubakaran Kaliannan <kirubak@zadarastorage.com>
References: 662a938320f87297adda5d0b81565c78@mail.gmail.com
In-Reply-To: 662a938320f87297adda5d0b81565c78@mail.gmail.com
MIME-Version: 1.0
Date: Wed, 6 Jul 2016 16:04:54 +0530
Message-ID: <d44e3415e126865eee4b216339cf9858@mail.gmail.com>
Subject: RE: xfs mount hung on a corrupted filesystem
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9055548993424003117=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============9055548993424003117==
Content-Type: multipart/alternative; boundary=001a114c9d4c1a12a50536f51f89

--001a114c9d4c1a12a50536f51f89
Content-Type: text/plain; charset=UTF-8

Hi All,



Sending it once again, in case we all missed this earlier mail,



Any help is much appreciated.

This bug hangs the mount with the following stack. Similar to (
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382801)



root@zios-vsa-00000253-vc-0:~# cat /proc/26511/task/26511/stack

[<ffffffffc0776c69>] xfs_ail_push_all_sync+0xa9/0xe0 [xfs]

[<ffffffffc076c2e7>] xfs_log_quiesce+0x37/0x70 [xfs]

[<ffffffffc076c33a>] xfs_log_unmount+0x1a/0x70 [xfs]

[<ffffffffc0760845>] xfs_mountfs+0x5e5/0x7b0 [xfs]

[<ffffffffc0763fca>] xfs_fs_fill_super+0x2ca/0x360 [xfs]

[<ffffffff811eb220>] mount_bdev+0x1b0/0x1f0

[<ffffffffc0761c95>] xfs_fs_mount+0x15/0x20 [xfs]

[<ffffffff811ebb79>] mount_fs+0x39/0x1b0

[<ffffffff812070db>] vfs_kern_mount+0x6b/0x120

[<ffffffff8120a032>] do_mount+0x222/0xca0

[<ffffffff8120adab>] SyS_mount+0x8b/0xe0

[<ffffffff817179cd>] system_call_fastpath+0x16/0x1b

[<ffffffffffffffff>] 0xffffffffffffffff





Is this a known issue ? otherwise how to avoid the hang, a mount failure
will help to force-repair the filesystem and remount.



Thanks

-kiru



*From:* Kirubakaran Kaliannan [mailto:kirubak@zadarastorage.com]
*Sent:* Wednesday, June 29, 2016 11:25 AM
*To:* 'xfs@oss.sgi.com'
*Subject:* xfs mount hung on a corrupted filesystem





Hi XFS-developers,



We are running XFS on ubuntu kernel-3.18.19



On a drive failure connected to my server, the file-system experienced the
corruption. Attached the corruption.out file which contains the information
regarding the corruption.



Later when the file-system is unmounted and mounted back, the mount hung
with the following stack (attached the dmesg when mount is run)



------------------

[ 3611.093909]  [<ffffffff81710c85>] dump_stack+0x4e/0x71

[ 3611.093943]  [<ffffffffc07ff68e>] xfs_error_report+0x3e/0x40 [xfs]

[ 3611.093964]  [<ffffffffc07beccc>] ? xfs_free_extent+0x10c/0x170 [xfs]

[ 3611.093984]  [<ffffffffc07bd45f>]
xfs_free_ag_extent.constprop.13+0x20f/0x980 [xfs]

[ 3611.094012]  [<ffffffffc07be4cf>] ? xfs_alloc_fix_freelist+0x4af/0x510
[xfs]

[ 3611.094070]  [<ffffffffc07beccc>] xfs_free_extent+0x10c/0x170 [xfs]

[ 3611.094120]  [<ffffffffc0827da5>] xlog_recover_process_efi+0x175/0x1b0
[xfs]

[ 3611.094180]  [<ffffffffc0829ed4>]
xlog_recover_process_efis.isra.27+0x64/0xb0 [xfs]

[ 3611.094227]  [<ffffffffc082d181>] xlog_recover_finish+0x21/0xb0 [xfs]

[ 3611.094271]  [<ffffffffc0821204>] xfs_log_mount_finish+0x34/0x50 [xfs]

[ 3611.094317]  [<ffffffffc0817769>] xfs_mountfs+0x509/0x7b0 [xfs]

[ 3611.094359]  [<ffffffffc081afca>] xfs_fs_fill_super+0x2ca/0x360 [xfs]

[ 3611.094369]  [<ffffffff811eb220>] mount_bdev+0x1b0/0x1f0

[ 3611.094406]  [<ffffffffc081ad00>] ? xfs_parseargs+0xbe0/0xbe0 [xfs]

[ 3611.094443]  [<ffffffffc0818c95>] xfs_fs_mount+0x15/0x20 [xfs]

[ 3611.094452]  [<ffffffff811ebb79>] mount_fs+0x39/0x1b0

[ 3611.094460]  [<ffffffff81192fc5>] ? __alloc_percpu+0x15/0x20

[ 3611.094472]  [<ffffffff812070db>] vfs_kern_mount+0x6b/0x120

[ 3611.094479]  [<ffffffff8120a032>] do_mount+0x222/0xca0

[ 3611.094486]  [<ffffffff8120adab>] SyS_mount+0x8b/0xe0

[ 3611.094495]  [<ffffffff817179cd>] system_call_fastpath+0x16/0x1b

[ 3611.094512] XFS (dm-56): Failed to recover EFIs

[ 3611.095813] XFS (dm-56): log mount finish failed

-----------



My initial analysis shows, exactly the issue is same as in (but expired)

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382801



filesystem getting corrupted is the first problem. But the mount hang
instead of failing is making it difficult to repair the filesystem.



Can you please help progress on this issue ?

I have the metadump of the filesystem, and can provide any details required.



Thanks

-kiru

--001a114c9d4c1a12a50536f51f89
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html; charset=
=3Dus-ascii"><meta name=3D"Generator" content=3D"Microsoft Word 12 (filtere=
d medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Comic Sans MS";
	panose-1:3 15 7 2 3 3 2 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style></head><body lang=3D"EN-US" link=3D"blue" vlink=3D"purple"><div =
class=3D"WordSection1"><p class=3D"MsoNormal"><span style=3D"color:#1f497d"=
>=C2=A0</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">Hi A=
ll,</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</=
span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">Sending it on=
ce again, in case we all missed this earlier mail,</span></p><p class=3D"Ms=
oNormal"><span style=3D"color:#1f497d">=C2=A0</span></p><p class=3D"MsoNorm=
al"><span style=3D"color:#1f497d">Any help is much appreciated.</span></p><=
p class=3D"MsoNormal"><span style=3D"color:#1f497d">This bug hangs the moun=
t with the following stack. Similar to (</span><span style=3D"font-size:10.=
0pt;font-family:&quot;Comic Sans MS&quot;;color:black"><a href=3D"https://b=
ugs.launchpad.net/ubuntu/+source/linux/+bug/1382801"><span style=3D"color:b=
lack;text-decoration:none">https://bugs.launchpad.net/ubuntu/+source/linux/=
+bug/1382801</span></a>)</span><span style=3D"color:#1f497d"></span></p><p =
class=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</span></p><p class=
=3D"MsoNormal"><span style=3D"color:#1f497d">root@zios-vsa-00000253-vc-0:~#=
 cat /proc/26511/task/26511/stack</span></p><p class=3D"MsoNormal"><span st=
yle=3D"color:#1f497d">[&lt;ffffffffc0776c69&gt;] xfs_ail_push_all_sync+0xa9=
/0xe0 [xfs]</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">=
[&lt;ffffffffc076c2e7&gt;] xfs_log_quiesce+0x37/0x70 [xfs]</span></p><p cla=
ss=3D"MsoNormal"><span style=3D"color:#1f497d">[&lt;ffffffffc076c33a&gt;] x=
fs_log_unmount+0x1a/0x70 [xfs]</span></p><p class=3D"MsoNormal"><span style=
=3D"color:#1f497d">[&lt;ffffffffc0760845&gt;] xfs_mountfs+0x5e5/0x7b0 [xfs]=
</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">[&lt;ffffff=
ffc0763fca&gt;] xfs_fs_fill_super+0x2ca/0x360 [xfs]</span></p><p class=3D"M=
soNormal"><span style=3D"color:#1f497d">[&lt;ffffffff811eb220&gt;] mount_bd=
ev+0x1b0/0x1f0</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497=
d">[&lt;ffffffffc0761c95&gt;] xfs_fs_mount+0x15/0x20 [xfs]</span></p><p cla=
ss=3D"MsoNormal"><span style=3D"color:#1f497d">[&lt;ffffffff811ebb79&gt;] m=
ount_fs+0x39/0x1b0</span></p><p class=3D"MsoNormal"><span style=3D"color:#1=
f497d">[&lt;ffffffff812070db&gt;] vfs_kern_mount+0x6b/0x120</span></p><p cl=
ass=3D"MsoNormal"><span style=3D"color:#1f497d">[&lt;ffffffff8120a032&gt;] =
do_mount+0x222/0xca0</span></p><p class=3D"MsoNormal"><span style=3D"color:=
#1f497d">[&lt;ffffffff8120adab&gt;] SyS_mount+0x8b/0xe0</span></p><p class=
=3D"MsoNormal"><span style=3D"color:#1f497d">[&lt;ffffffff817179cd&gt;] sys=
tem_call_fastpath+0x16/0x1b</span></p><p class=3D"MsoNormal"><span style=3D=
"color:#1f497d">[&lt;ffffffffffffffff&gt;] 0xffffffffffffffff</span></p><p =
class=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</span></p><p class=
=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</span></p><p class=3D"M=
soNormal"><span style=3D"color:#1f497d">Is this a known issue ? otherwise h=
ow to avoid the hang, a mount failure will help to force-repair the filesys=
tem and remount.</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f4=
97d">=C2=A0</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">=
Thanks</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">-kiru=
</span></p><p class=3D"MsoNormal"><span style=3D"color:#1f497d">=C2=A0</spa=
n></p><div><div style=3D"border:none;border-top:solid #b5c4df 1.0pt;padding=
:3.0pt 0in 0in 0in"><p class=3D"MsoNormal"><b><span style=3D"font-size:10.0=
pt;font-family:&quot;Tahoma&quot;,&quot;sans-serif&quot;">From:</span></b><=
span style=3D"font-size:10.0pt;font-family:&quot;Tahoma&quot;,&quot;sans-se=
rif&quot;"> Kirubakaran Kaliannan [mailto:<a href=3D"mailto:kirubak@zadaras=
torage.com">kirubak@zadarastorage.com</a>] <br><b>Sent:</b> Wednesday, June=
 29, 2016 11:25 AM<br><b>To:</b> &#39;<a href=3D"mailto:xfs@oss.sgi.com">xf=
s@oss.sgi.com</a>&#39;<br><b>Subject:</b> xfs mount hung on a corrupted fil=
esystem</span></p></div></div><p class=3D"MsoNormal">=C2=A0</p><p class=3D"=
MsoNormal">=C2=A0</p><p class=3D"MsoNormal">Hi XFS-developers,</p><p class=
=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal" style=3D"text-autospace:non=
e"><span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;co=
lor:black">We are running XFS on ubuntu kernel-3.18.19</span></p><p class=
=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-size:10.0p=
t;font-family:&quot;Comic Sans MS&quot;;color:black">=C2=A0</span></p><p cl=
ass=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-size:10=
.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">On a drive failure =
connected to my server, the file-system experienced the corruption. Attache=
d the corruption.out file which contains the information regarding the corr=
uption.</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><spa=
n style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:bla=
ck">=C2=A0</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><=
span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:=
black">Later when the file-system is unmounted and mounted back, the mount =
hung with the following stack (attached the dmesg when mount is run)</span>=
</p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"fon=
t-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">=C2=A0</sp=
an></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"=
font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">-------=
-----------</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none">=
<span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color=
:black">[ 3611.093909]=C2=A0 [&lt;ffffffff81710c85&gt;] dump_stack+0x4e/0x7=
1</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span styl=
e=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">[ =
3611.093943]=C2=A0 [&lt;ffffffffc07ff68e&gt;] xfs_error_report+0x3e/0x40 [x=
fs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span st=
yle=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">=
[ 3611.093964]=C2=A0 [&lt;ffffffffc07beccc&gt;] ? xfs_free_extent+0x10c/0x1=
70 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><sp=
an style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:bl=
ack">[ 3611.093984]=C2=A0 [&lt;ffffffffc07bd45f&gt;] xfs_free_ag_extent.con=
stprop.13+0x20f/0x980 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-=
autospace:none"><span style=3D"font-size:10.0pt;font-family:&quot;Comic San=
s MS&quot;;color:black">[ 3611.094012]=C2=A0 [&lt;ffffffffc07be4cf&gt;] ? x=
fs_alloc_fix_freelist+0x4af/0x510 [xfs]</span></p><p class=3D"MsoNormal" st=
yle=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-family:&qu=
ot;Comic Sans MS&quot;;color:black">[ 3611.094070]=C2=A0 [&lt;ffffffffc07be=
ccc&gt;] xfs_free_extent+0x10c/0x170 [xfs]</span></p><p class=3D"MsoNormal"=
 style=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-family:=
&quot;Comic Sans MS&quot;;color:black">[ 3611.094120]=C2=A0 [&lt;ffffffffc0=
827da5&gt;] xlog_recover_process_efi+0x175/0x1b0 [xfs]</span></p><p class=
=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-size:10.0p=
t;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3611.094180]=C2=A0 [=
&lt;ffffffffc0829ed4&gt;] xlog_recover_process_efis.isra.27+0x64/0xb0 [xfs]=
</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=
=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3=
611.094227]=C2=A0 [&lt;ffffffffc082d181&gt;] xlog_recover_finish+0x21/0xb0 =
[xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span =
style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black=
">[ 3611.094271]=C2=A0 [&lt;ffffffffc0821204&gt;] xfs_log_mount_finish+0x34=
/0x50 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none">=
<span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color=
:black">[ 3611.094317]=C2=A0 [&lt;ffffffffc0817769&gt;] xfs_mountfs+0x509/0=
x7b0 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><=
span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:=
black">[ 3611.094359]=C2=A0 [&lt;ffffffffc081afca&gt;] xfs_fs_fill_super+0x=
2ca/0x360 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:no=
ne"><span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;c=
olor:black">[ 3611.094369]=C2=A0 [&lt;ffffffff811eb220&gt;] mount_bdev+0x1b=
0/0x1f0</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><spa=
n style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:bla=
ck">[ 3611.094406]=C2=A0 [&lt;ffffffffc081ad00&gt;] ? xfs_parseargs+0xbe0/0=
xbe0 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><=
span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:=
black">[ 3611.094443]=C2=A0 [&lt;ffffffffc0818c95&gt;] xfs_fs_mount+0x15/0x=
20 [xfs]</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><sp=
an style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:bl=
ack">[ 3611.094452]=C2=A0 [&lt;ffffffff811ebb79&gt;] mount_fs+0x39/0x1b0</s=
pan></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D=
"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3611=
.094460]=C2=A0 [&lt;ffffffff81192fc5&gt;] ? __alloc_percpu+0x15/0x20</span>=
</p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"fon=
t-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3611.094=
472]=C2=A0 [&lt;ffffffff812070db&gt;] vfs_kern_mount+0x6b/0x120</span></p><=
p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-siz=
e:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3611.094479]=
=C2=A0 [&lt;ffffffff8120a032&gt;] do_mount+0x222/0xca0</span></p><p class=
=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-size:10.0p=
t;font-family:&quot;Comic Sans MS&quot;;color:black">[ 3611.094486]=C2=A0 [=
&lt;ffffffff8120adab&gt;] SyS_mount+0x8b/0xe0</span></p><p class=3D"MsoNorm=
al" style=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-fami=
ly:&quot;Comic Sans MS&quot;;color:black">[ 3611.094495]=C2=A0 [&lt;fffffff=
f817179cd&gt;] system_call_fastpath+0x16/0x1b</span></p><p class=3D"MsoNorm=
al" style=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-fami=
ly:&quot;Comic Sans MS&quot;;color:black">[ 3611.094512] XFS (dm-56): Faile=
d to recover EFIs</span></p><p class=3D"MsoNormal" style=3D"text-autospace:=
none"><span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;=
;color:black">[ 3611.095813] XFS (dm-56): log mount finish failed</span></p=
><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-s=
ize:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">-----------</=
span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=
=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">=C2=
=A0</span></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span st=
yle=3D"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">=
My initial analysis shows, exactly the issue is same as in (but expired)</s=
pan></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D=
"font-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black"><a hre=
f=3D"https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1382801"><span st=
yle=3D"color:black;text-decoration:none">https://bugs.launchpad.net/ubuntu/=
+source/linux/+bug/1382801</span></a> </span></p><p class=3D"MsoNormal" sty=
le=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-family:&quo=
t;Comic Sans MS&quot;;color:black">=C2=A0</span></p><p class=3D"MsoNormal" =
style=3D"text-autospace:none"><span style=3D"font-size:10.0pt;font-family:&=
quot;Comic Sans MS&quot;;color:black">filesystem getting corrupted is the f=
irst problem. But the mount hang instead of failing is making it difficult =
to repair the filesystem.</span></p><p class=3D"MsoNormal" style=3D"text-au=
tospace:none"><span style=3D"font-size:10.0pt;font-family:&quot;Comic Sans =
MS&quot;;color:black">=C2=A0</span></p><p class=3D"MsoNormal" style=3D"text=
-autospace:none"><span style=3D"font-size:10.0pt;font-family:&quot;Comic Sa=
ns MS&quot;;color:black">Can you please help progress on this issue ?</span=
></p><p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"fo=
nt-size:10.0pt;font-family:&quot;Comic Sans MS&quot;;color:black">I have th=
e metadump of the filesystem, and can provide any details required.</span><=
/p><p class=3D"MsoNormal">=C2=A0</p><p class=3D"MsoNormal">Thanks</p><p cla=
ss=3D"MsoNormal">-kiru</p></div></body></html>

--001a114c9d4c1a12a50536f51f89--


--===============9055548993424003117==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9055548993424003117==--
