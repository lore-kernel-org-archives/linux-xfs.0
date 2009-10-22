Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGSm6Q113175 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:28:48 -0500
Received: from mail-px0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A8CBC3749D
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:30:21 -0700 (PDT)
Received: from mail-px0-f193.google.com (mail-px0-f193.google.com
	[209.85.216.193]) by cuda.sgi.com with ESMTP id
	mql6a8cbigbfpw3L for <xfs@oss.sgi.com>;
	Thu, 22 Oct 2009 09:30:21 -0700 (PDT)
Received: by pxi31 with SMTP id 31so1420195pxi.20
	for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 09:30:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE06BAE.8090706@sandeen.net>
References: <c2dcdfa40910202307m77a9d7c5lf18e278a9ebae08e@mail.gmail.com>
	<4ADF2EE8.6010700@sandeen.net>
	<c2dcdfa40910211032y5b1d2cd8l418491327d24b87b@mail.gmail.com>
	<4ADF4882.70106@sandeen.net>
	<c2dcdfa40910220209v781f6a76u31e349ea461bc10a@mail.gmail.com>
	<4AE06BAE.8090706@sandeen.net>
Date: Thu, 22 Oct 2009 22:00:20 +0530
Message-ID: <c2dcdfa40910220930l19a8dab0y88e80630a2453b39@mail.gmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 1992 of file
	fs/xfs/xfs_da_btree.c
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0287570883975974612=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============0287570883975974612==
Content-Type: multipart/alternative; boundary=000e0cd24d9e8a5cff0476889cb3

--000e0cd24d9e8a5cff0476889cb3
Content-Type: text/plain; charset=ISO-8859-1

I am already using that patch.
Other than using higher XFS version, can I try any other thing?

I cannot directly use higher XFS version, I will have to backport the
changes for higher to the kernel I am using  because of dependencies.

Thanks & Regards,
Amit Sahrawat
On Thu, Oct 22, 2009 at 7:56 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> Amit Sahrawat wrote:
>
>> Hi Eric,
>>
>> This seems related with the directory Inodes.
>>
>> I tried the changes mentioned in the patch, they didn't work for me.
>> As mine seems to be ARM with EABI.
>>
>
> The other one you might check on is:
>
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=94a3f78566ef98a48814d82892f28bb741624cb8
>
> Other than that, if you can try a newer kernel that'd be great, and if the
> problem remains, let me know what the testcase is and I can try it out.
>
> -Eric
>
>   When files are created at the Root . It reports Root Inode :128 at the
>> crash with bno:2
>>
>> While suppose if another directory is created and Inode is 137
>> And then, rm -rf * in that directory
>> Crash would report error With this inode
>>
>> xfs_da_do_buf: bno 8388631
>> dir: inode 137
>> Filesystem "sda4": XFS internal error xfs_da_do_buf(1) at line 1992 of
>> file fs/x
>> fs/xfs_da_btree.c.  Caller 0xc0118eb8
>> ry
>> rm: unable [<c0022618>] (dump_stack+0x0/0x14) from [<c0125700>]
>> (xfs_error_repor
>> t+0x54/0x64)
>> [<c01256ac>] (xfs_error_report+0x0/0x64) from [<c0118a74>]
>> (xfs_da_do_buf+0x334/
>> 0x6ec)
>> [<c0118740>] (xfs_da_do_buf+0x0/0x6ec) from [<c0118eb8>]
>> (xfs_da_read_buf+0x34/0
>> x3c)
>> [<c0118e84>] (xfs_da_read_buf+0x0/0x3c) from [<c011b5c8>]
>> (xfs_da_node_lookup_in
>> t+0x70/0x318)
>> [<c011b558>] (xfs_da_node_lookup_int+0x0/0x318) from [<c01219d4>]
>> (xfs_dir2_node
>> _removename+0x48/0x500)
>> [<c012198c>] (xfs_dir2_node_removename+0x0/0x500) from [<c011c334>]
>> (xfs_dir_rem
>> ovename+0x100/0x10c)
>> [<c011c234>] (xfs_dir_removename+0x0/0x10c) from [<c014cde4>]
>> (xfs_remove+0x280/
>> 0x424)
>>  r6 = 00000000  r5 = 00000000  r4 = 00003951
>> [<c014cb64>] (xfs_remove+0x0/0x424) from [<c0157044>]
>> (xfs_vn_unlink+0x30/0x60)
>> [<c0157014>] (xfs_vn_unlink+0x0/0x60) from [<c009175c>]
>> (vfs_unlink+0x70/0xac)
>>  r7 = C471C000  r6 = C43BF598  r5 = C395B3B8  r4 = 00000000
>> [<c00916ec>] (vfs_unlink+0x0/0xac) from [<c0093ac0>]
>> (do_unlinkat+0xcc/0x14c)
>>  r6 = C3968AD8  r5 = C395B3B8  r4 = 00000000
>> [<c00939f4>] (do_unlinkat+0x0/0x14c) from [<c0093b58>]
>> (sys_unlink+0x18/0x1c)
>>  r7 = 0000000A  r6 = 0000000C  r5 = 00000008  r4 = BEDCBC19
>> [<c0093b40>] (sys_unlink+0x0/0x1c) from [<c001de40>]
>> (ret_fast_syscall+0x0/0x2c)
>> to remove `5826'xfs_da_do_buf: bno 8388631
>> dir: inode 137
>>
>> Checking this through xfs_check will show:
>> ]# xfs_check /dev/sdb4
>> dir 128 block 8388609 extra leaf entry d5830 402
>> dir 128 block 8388609 extra leaf entry d5831 404
>> dir 128 block 8388609 extra leaf entry d5832 406
>> dir 128 block 8388609 extra leaf entry d5833 408
>> dir 128 block 8388609 extra leaf entry d5834 40a
>> dir 128 block 8388609 extra leaf entry d5835 40c
>> dir 128 block 8388609 extra leaf entry d5836 40e
>> dir 128 block 8388609 extra leaf entry d5837 410
>> ...
>> ...
>> dir 128 block 8388609 extra leaf entry ddab2 5fa
>> dir 128 block 8388609 extra leaf entry ddab3 5fc
>> dir 128 block 8388609 extra leaf entry ddab4 5fe
>> bad free block ent 1 is 65535 should be 0 for dir ino 128 block 16777216
>> bad free block ent 2 is 0 should be 65535 for dir ino 128 block 16777216
>> dir ino 128 missing leaf entry for d5a37/260
>> dir ino 128 missing leaf entry for d5a38/262
>> dir ino 128 missing leaf entry for d5a39/264
>> ...
>> ...
>>
>> I tried checking the inode before and after corruption using xfs_db and
>> xfs_check
>> When I create files and check using xfs_check, no corruption is showed and
>> also xfs_db shows correct results for the inode.
>> While after the crash is observed, xfs_check show the errors I mentioned
>> above.
>> Also, the values for Inode using xfs_db differ from the ones I get after i
>> do xfs_repair -L on the device.
>>
>>
>> Can u get anything from the above mentioned log.
>>
>> Thanks & Regards,
>> Amit Sahrawat
>>
>>
>> On Wed, Oct 21, 2009 at 11:14 PM, Eric Sandeen <sandeen@sandeen.net<mailto:
>> sandeen@sandeen.net>> wrote:
>>
>>    Amit Sahrawat wrote:
>>     > Thanks Eric,
>>     >
>>     > Yes, I am able to get this for the same Inode and Block number.
>>     >
>>     > xfs_check reports error for dir inode 128 missing leaf
>>    entries..(exact
>>     > string I m missing), will provide you the details.
>>     >
>>     > Using xfs_repair fixes the problem. But again the same operation
>>    leads
>>     > to the crash.
>>     > Even on a freshly formatted disk, I get this error.
>>     >
>>     > Please let me know from where I can get this patch to try whether it
>>     > fixes for me or not.
>>
>>
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=ae23a5e87dbbf4657a82e1ff8ebc52ab50361c14
>>
>>    -Eric
>>
>>
>>
>> ------------------------------------------------------------------------
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>
>

--000e0cd24d9e8a5cff0476889cb3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I am already using that patch.</div>
<div>Other than using higher XFS version, can I try any other thing?</div>
<div>=A0</div>
<div>I cannot directly use higher XFS version, I will have to backport the =
changes for higher to the kernel I am using=A0 because of dependencies.</di=
v>
<div><br>Thanks &amp; Regards,</div>
<div>Amit Sahrawat<br></div>
<div class=3D"gmail_quote">On Thu, Oct 22, 2009 at 7:56 PM, Eric Sandeen <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.=
net</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div class=3D"im">Amit Sahrawat wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">Hi Eric,<br><br>This seems relat=
ed with the directory Inodes.<br><br>I tried the changes mentioned in the p=
atch, they didn&#39;t work for me.<br>
As mine seems to be ARM with EABI.<br></blockquote><br></div>The other one =
you might check on is:<br><br><a href=3D"http://git.kernel.org/?p=3Dlinux/k=
ernel/git/torvalds/linux-2.6.git;a=3Dcommitdiff;h=3D94a3f78566ef98a48814d82=
892f28bb741624cb8" target=3D"_blank">http://git.kernel.org/?p=3Dlinux/kerne=
l/git/torvalds/linux-2.6.git;a=3Dcommitdiff;h=3D94a3f78566ef98a48814d82892f=
28bb741624cb8</a><br>
<br>Other than that, if you can try a newer kernel that&#39;d be great, and=
 if the problem remains, let me know what the testcase is and I can try it =
out.<br><br>-Eric<br><br>
<blockquote class=3D"gmail_quote" style=3D"PADDING-LEFT: 1ex; MARGIN: 0px 0=
px 0px 0.8ex; BORDER-LEFT: #ccc 1px solid">
<div>
<div></div>
<div class=3D"h5">When files are created at the Root . It reports Root Inod=
e :128 at the crash with bno:2<br><br>While suppose if another directory is=
 created and Inode is 137<br>And then, rm -rf * in that directory<br>Crash =
would report error With this inode<br>
<br>xfs_da_do_buf: bno 8388631<br>dir: inode 137<br>Filesystem &quot;sda4&q=
uot;: XFS internal error xfs_da_do_buf(1) at line 1992 of file fs/x<br>fs/x=
fs_da_btree.c. =A0Caller 0xc0118eb8<br>ry<br>rm: unable [&lt;c0022618&gt;] =
(dump_stack+0x0/0x14) from [&lt;c0125700&gt;] (xfs_error_repor<br>
t+0x54/0x64)<br>[&lt;c01256ac&gt;] (xfs_error_report+0x0/0x64) from [&lt;c0=
118a74&gt;] (xfs_da_do_buf+0x334/<br>0x6ec)<br>[&lt;c0118740&gt;] (xfs_da_d=
o_buf+0x0/0x6ec) from [&lt;c0118eb8&gt;] (xfs_da_read_buf+0x34/0<br>x3c)<br=
>
[&lt;c0118e84&gt;] (xfs_da_read_buf+0x0/0x3c) from [&lt;c011b5c8&gt;] (xfs_=
da_node_lookup_in<br>t+0x70/0x318)<br>[&lt;c011b558&gt;] (xfs_da_node_looku=
p_int+0x0/0x318) from [&lt;c01219d4&gt;] (xfs_dir2_node<br>_removename+0x48=
/0x500)<br>
[&lt;c012198c&gt;] (xfs_dir2_node_removename+0x0/0x500) from [&lt;c011c334&=
gt;] (xfs_dir_rem<br>ovename+0x100/0x10c)<br>[&lt;c011c234&gt;] (xfs_dir_re=
movename+0x0/0x10c) from [&lt;c014cde4&gt;] (xfs_remove+0x280/<br>0x424)<br=
>
=A0r6 =3D 00000000 =A0r5 =3D 00000000 =A0r4 =3D 00003951<br>[&lt;c014cb64&g=
t;] (xfs_remove+0x0/0x424) from [&lt;c0157044&gt;] (xfs_vn_unlink+0x30/0x60=
)<br>[&lt;c0157014&gt;] (xfs_vn_unlink+0x0/0x60) from [&lt;c009175c&gt;] (v=
fs_unlink+0x70/0xac)<br>
=A0r7 =3D C471C000 =A0r6 =3D C43BF598 =A0r5 =3D C395B3B8 =A0r4 =3D 00000000=
<br>[&lt;c00916ec&gt;] (vfs_unlink+0x0/0xac) from [&lt;c0093ac0&gt;] (do_un=
linkat+0xcc/0x14c)<br>=A0r6 =3D C3968AD8 =A0r5 =3D C395B3B8 =A0r4 =3D 00000=
000<br>[&lt;c00939f4&gt;] (do_unlinkat+0x0/0x14c) from [&lt;c0093b58&gt;] (=
sys_unlink+0x18/0x1c)<br>
=A0r7 =3D 0000000A =A0r6 =3D 0000000C =A0r5 =3D 00000008 =A0r4 =3D BEDCBC19=
<br>[&lt;c0093b40&gt;] (sys_unlink+0x0/0x1c) from [&lt;c001de40&gt;] (ret_f=
ast_syscall+0x0/0x2c)<br>to remove `5826&#39;xfs_da_do_buf: bno 8388631<br>=
dir: inode 137<br>
<br>Checking this through xfs_check will show:<br>]# xfs_check /dev/sdb4<br=
>dir 128 block 8388609 extra leaf entry d5830 402<br>dir 128 block 8388609 =
extra leaf entry d5831 404<br>dir 128 block 8388609 extra leaf entry d5832 =
406<br>
dir 128 block 8388609 extra leaf entry d5833 408<br>dir 128 block 8388609 e=
xtra leaf entry d5834 40a<br>dir 128 block 8388609 extra leaf entry d5835 4=
0c<br>dir 128 block 8388609 extra leaf entry d5836 40e<br>dir 128 block 838=
8609 extra leaf entry d5837 410<br>
...<br>...<br>dir 128 block 8388609 extra leaf entry ddab2 5fa<br>dir 128 b=
lock 8388609 extra leaf entry ddab3 5fc<br>dir 128 block 8388609 extra leaf=
 entry ddab4 5fe<br>bad free block ent 1 is 65535 should be 0 for dir ino 1=
28 block 16777216<br>
bad free block ent 2 is 0 should be 65535 for dir ino 128 block 16777216<br=
>dir ino 128 missing leaf entry for d5a37/260<br>dir ino 128 missing leaf e=
ntry for d5a38/262<br>dir ino 128 missing leaf entry for d5a39/264<br>...<b=
r>
...<br><br>I tried checking the inode before and after corruption using xfs=
_db and xfs_check<br>When I create files and check using xfs_check, no corr=
uption is showed and also xfs_db shows correct results for the inode.<br>
While after the crash is observed, xfs_check show the errors I mentioned ab=
ove.<br>Also, the values for Inode using xfs_db differ from the ones I get =
after i do xfs_repair -L on the device.<br><br><br>Can u get anything from =
the above mentioned log.<br>
<br>Thanks &amp; Regards,<br>Amit Sahrawat<br><br><br></div></div>
<div class=3D"im">On Wed, Oct 21, 2009 at 11:14 PM, Eric Sandeen &lt;<a hre=
f=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a> =
&lt;mailto:<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen=
@sandeen.net</a>&gt;&gt; wrote:<br>
<br>=A0 =A0Amit Sahrawat wrote:<br>=A0 =A0 &gt; Thanks Eric,<br>=A0 =A0 &gt=
;<br>=A0 =A0 &gt; Yes, I am able to get this for the same Inode and Block n=
umber.<br>=A0 =A0 &gt;<br>=A0 =A0 &gt; xfs_check reports error for dir inod=
e 128 missing leaf<br>
=A0 =A0entries..(exact<br>=A0 =A0 &gt; string I m missing), will provide yo=
u the details.<br>=A0 =A0 &gt;<br>=A0 =A0 &gt; Using xfs_repair fixes the p=
roblem. But again the same operation<br>=A0 =A0leads<br>=A0 =A0 &gt; to the=
 crash.<br>=A0 =A0 &gt; Even on a freshly formatted disk, I get this error.=
<br>
=A0 =A0 &gt;<br>=A0 =A0 &gt; Please let me know from where I can get this p=
atch to try whether it<br>=A0 =A0 &gt; fixes for me or not.<br><br><br>=A0 =
=A0<a href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.=
6.git;a=3Dcommitdiff_plain;h=3Dae23a5e87dbbf4657a82e1ff8ebc52ab50361c14" ta=
rget=3D"_blank">http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-=
2.6.git;a=3Dcommitdiff_plain;h=3Dae23a5e87dbbf4657a82e1ff8ebc52ab50361c14</=
a><br>
<br>=A0 =A0-Eric<br><br><br><br></div>-------------------------------------=
-----------------------------------<br><br>________________________________=
_______________<br>xfs mailing list<br><a href=3D"mailto:xfs@oss.sgi.com" t=
arget=3D"_blank">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/listinfo/xfs</a><br></blockquote><br></blockquote></d=
iv><br>

--000e0cd24d9e8a5cff0476889cb3--


--===============0287570883975974612==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0287570883975974612==--
