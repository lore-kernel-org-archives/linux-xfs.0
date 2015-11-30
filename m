Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98BE17F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 10:52:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8355E304067
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:52:03 -0800 (PST)
Received: from mail1.bemta14.messagelabs.com (mail1.bemta14.messagelabs.com
	[193.109.254.107]) by cuda.sgi.com with ESMTP id
	ogtnXQmoFHGx6XE5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:52:00 -0800 (PST)
From: Sandeep Patel <spatel@omnifone.com>
Subject: XFS corruptions
Date: Mon, 30 Nov 2015 16:51:57 +0000
Message-ID: <558408F298C8CE4C89D93BD56AB474E8018617B2B3@EXBE1IS02.omnifone.com>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8492985413460499157=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8492985413460499157==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_558408F298C8CE4C89D93BD56AB474E8018617B2B3EXBE1IS02omni_"

--_000_558408F298C8CE4C89D93BD56AB474E8018617B2B3EXBE1IS02omni_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

We have multiple 22 disk raid 6 arrays using LSI 9280-24i4e raid cards, al=
l using enterprise grade drives. The array is setup with physical drive ca=
che disabled and mounted using inode64 with nobarriers option in Oracle Li=
nux Server release 6.6, kernel version 3.8.13-55.1.5.el6uek.x86_64. We are=
 suffering from corruptions with xfs_repair unable to permanently fix the =
the issues. Output of dmesg from the latest corruption.

Pid: 5319, comm: glusterfsd Not tainted 3.8.13-55.1.5.el6uek.x86_64 #2
Call Trace:
[<ffffffffa02a3a9f>] xfs_error_report+0x3f/0x50 [xfs]
[<ffffffffa02ed416>] ? xfs_iread_extents+0x86/0x110 [xfs]
[<ffffffffa02a3b0e>] xfs_corruption_error+0x5e/0x90 [xfs]
[<ffffffffa02c7ac8>] xfs_bmap_read_extents+0x3f8/0x450 [xfs]
[<ffffffffa02ed416>] ? xfs_iread_extents+0x86/0x110 [xfs]
[<ffffffffa02eb94e>] ? xfs_iext_realloc_direct+0xae/0x160 [xfs]
[<ffffffffa02ed416>] xfs_iread_extents+0x86/0x110 [xfs]
[<ffffffffa02fb0cc>] ? xfs_trans_free_item_desc+0x3c/0x50 [xfs]
[<ffffffffa02c5df5>] xfs_bmap_last_extent+0x95/0xb0 [xfs]
[<ffffffffa02c5ef6>] xfs_bmap_last_offset+0x66/0xc0 [xfs]
[<ffffffffa02dc123>] ? xfs_dir_lookup+0xc3/0x170 [xfs]
[<ffffffffa02dbc96>] xfs_dir2_isblock+0x26/0x60 [xfs]
[<ffffffffa02dc123>] xfs_dir_lookup+0xc3/0x170 [xfs]
[<ffffffffa02b6497>] xfs_lookup+0x87/0x110 [xfs]
[<ffffffff811a92ed>] ? __d_alloc+0x14d/0x180
[<ffffffffa02aea84>] xfs_vn_lookup+0x54/0xa0 [xfs]
[<ffffffff8119db43>] ? lookup_dcache+0xa3/0xd0
[<ffffffff8119d3ad>] lookup_real+0x1d/0x60
[<ffffffff8119dba8>] __lookup_hash+0x38/0x50
[<ffffffff8119dc0e>] lookup_slow+0x4e/0xc0
[<ffffffff811a1d41>] path_lookupat+0x201/0x780
[<ffffffff811a22f4>] filename_lookup+0x34/0xc0
[<ffffffff811a35b9>] user_path_at_empty+0x59/0xa0
[<ffffffff811a3611>] ? user_path_at+0x11/0x20
[<ffffffff811986c0>] ? vfs_fstatat+0x50/0xb0
[<ffffffff811a3611>] user_path_at+0x11/0x20
[<ffffffff811a3698>] sys_linkat+0x78/0x250
[<ffffffff810e37e6>] ? __audit_syscall_exit+0x216/0x2c0
[<ffffffff815a25d9>] system_call_fastpath+0x16/0x1b
XFS (sdb): Corruption detected. Unmount and run xfs_repair
XFS (sdb): corrupt dinode 6442451040, (btree extents).
ffff88042615d000: 42 4d 41 50 00 00 00 fe ff ff ff ff ff ff ff ff BMAP....=
........
XFS (sdb): Internal error xfs_bmap_read_extents(1) at line 1610 of file fs=
/xfs/xfs_bmap.c. Caller 0xffffffffa02ed416

What could be causing these issues?

Thanks for your help in advanced.

______________________________________________________________________
This email has been scanned by the Symantec Email Security.cloud service.
For more information please visit http://www.symanteccloud.com
______________________________________________________________________
--_000_558408F298C8CE4C89D93BD56AB474E8018617B2B3EXBE1IS02omni_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-mic=
rosoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word=
" xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"ht=
tp://www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii=
">
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
=09{font-family:Verdana;
=09panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0cm;
=09margin-bottom:.0001pt;
=09font-size:11.0pt;
=09font-family:"Calibri","sans-serif";
=09mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:blue;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:purple;
=09text-decoration:underline;}
span.EmailStyle17
=09{mso-style-type:personal-compose;
=09font-family:"Calibri","sans-serif";
=09color:windowtext;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-family:"Calibri","sans-serif";
=09mso-fareast-language:EN-US;}
@page WordSection1
=09{size:612.0pt 792.0pt;
=09margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-GB" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Ve=
rdana&quot;,&quot;sans-serif&quot;;color:black;background:#FBF9F7">Hi,<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Ve=
rdana&quot;,&quot;sans-serif&quot;;color:black;background:#FBF9F7"><o:p>&n=
bsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:9.0pt;font-family:&quot;Ve=
rdana&quot;,&quot;sans-serif&quot;;color:black;background:#FBF9F7">We have=
 multiple 22 disk raid 6 arrays using LSI 9280-24i4e raid cards, all using=
 enterprise grade drives. The array is setup with physical
 drive cache disabled and mounted using inode64 with nobarriers option in =
Oracle Linux Server release 6.6, kernel version 3.8.13-55.1.5.el6uek.x86_6=
4. We are suffering from corruptions with xfs_repair unable to permanently=
 fix the the issues. Output of dmesg
 from the latest corruption.</span><span style=3D"font-size:9.0pt;font-fam=
ily:&quot;Verdana&quot;,&quot;sans-serif&quot;;color:black"><br>
<br>
<span style=3D"background:#FBF9F7">Pid: 5319, comm: glusterfsd Not tainted=
 3.8.13-55.1.5.el6uek.x86_64 #2</span><br>
<span style=3D"background:#FBF9F7">Call Trace:</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02a3a9f&gt;] xfs_error_re=
port&#43;0x3f/0x50 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02ed416&gt;] ? xfs_iread_=
extents&#43;0x86/0x110 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02a3b0e&gt;] xfs_corrupti=
on_error&#43;0x5e/0x90 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02c7ac8&gt;] xfs_bmap_rea=
d_extents&#43;0x3f8/0x450 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02ed416&gt;] ? xfs_iread_=
extents&#43;0x86/0x110 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02eb94e&gt;] ? xfs_iext_r=
ealloc_direct&#43;0xae/0x160 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02ed416&gt;] xfs_iread_ex=
tents&#43;0x86/0x110 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02fb0cc&gt;] ? xfs_trans_=
free_item_desc&#43;0x3c/0x50 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02c5df5&gt;] xfs_bmap_las=
t_extent&#43;0x95/0xb0 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02c5ef6&gt;] xfs_bmap_las=
t_offset&#43;0x66/0xc0 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02dc123&gt;] ? xfs_dir_lo=
okup&#43;0xc3/0x170 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02dbc96&gt;] xfs_dir2_isb=
lock&#43;0x26/0x60 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02dc123&gt;] xfs_dir_look=
up&#43;0xc3/0x170 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02b6497&gt;] xfs_lookup&#=
43;0x87/0x110 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a92ed&gt;] ? __d_alloc&=
#43;0x14d/0x180</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffffa02aea84&gt;] xfs_vn_looku=
p&#43;0x54/0xa0 [xfs]</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff8119db43&gt;] ? lookup_dca=
che&#43;0xa3/0xd0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff8119d3ad&gt;] lookup_real&=
#43;0x1d/0x60</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff8119dba8&gt;] __lookup_has=
h&#43;0x38/0x50</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff8119dc0e&gt;] lookup_slow&=
#43;0x4e/0xc0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a1d41&gt;] path_lookupa=
t&#43;0x201/0x780</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a22f4&gt;] filename_loo=
kup&#43;0x34/0xc0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a35b9&gt;] user_path_at=
_empty&#43;0x59/0xa0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a3611&gt;] ? user_path_=
at&#43;0x11/0x20</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811986c0&gt;] ? vfs_fstata=
t&#43;0x50/0xb0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a3611&gt;] user_path_at=
&#43;0x11/0x20</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff811a3698&gt;] sys_linkat&#=
43;0x78/0x250</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff810e37e6&gt;] ? __audit_sy=
scall_exit&#43;0x216/0x2c0</span><br>
<span style=3D"background:#FBF9F7">[&lt;ffffffff815a25d9&gt;] system_call_=
fastpath&#43;0x16/0x1b</span><br>
<span style=3D"background:#FBF9F7">XFS (sdb): Corruption detected. Unmount=
 and run xfs_repair</span><br>
<span style=3D"background:#FBF9F7">XFS (sdb): corrupt dinode 6442451040, (=
btree extents).</span><br>
<span style=3D"background:#FBF9F7">ffff88042615d000: 42 4d 41 50 00 00 00 =
fe ff ff ff ff ff=20ff ff ff BMAP............</span><br>
<span style=3D"background:#FBF9F7">XFS (sdb): Internal error xfs_bmap_read=
_extents(1) at line 1610 of file fs/xfs/xfs_bmap.c. Caller 0xffffffffa02ed=
416</span><br>
<br>
<span style=3D"background:#FBF9F7">What could be causing these issues?</sp=
an><br>
<br>
<span style=3D"background:#FBF9F7">Thanks for your help in advanced.<o:p><=
/o:p></span></span></p>
</div>
<br clear=3D"both">
______________________________________________________________________<BR>=

This email has been scanned by the Symantec Email Security.cloud service.<=
BR>
For more information please visit http://www.symanteccloud.com<BR>
______________________________________________________________________<BR>=

</body>
</html>

--_000_558408F298C8CE4C89D93BD56AB474E8018617B2B3EXBE1IS02omni_--


--===============8492985413460499157==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8492985413460499157==--
