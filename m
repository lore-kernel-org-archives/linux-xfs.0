Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6SCnei3174844 for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 07:49:40 -0500
Received: from mail-qy0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A43A38D0E5
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 05:50:26 -0700 (PDT)
Received: from mail-qy0-f173.google.com (mail-qy0-f173.google.com
	[209.85.221.173]) by cuda.sgi.com with ESMTP id
	XzvRQDTUDfzAk9dw for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2009 05:50:26 -0700 (PDT)
Received: by qyk3 with SMTP id 3so4638740qyk.20
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2009 05:50:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
References: <362522677.1010811248671789619.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
	<1938435153.1010831248671852499.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Date: Tue, 28 Jul 2009 20:50:25 +0800
Message-ID: <b094161c0907280550y58cde45fja97b2c413c92a8d4@mail.gmail.com>
Subject: Re: BUG REPORT: XFS LOG FORWARD COMPATIBILITY PROBLEM
From: Eddy Zhao <eddy.y.zhao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1416429439103848319=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lmcilroy@redhat.com>
Cc: xfs@oss.sgi.com

--===============1416429439103848319==
Content-Type: multipart/alternative; boundary=0016364ee89cb4510b046fc38331

--0016364ee89cb4510b046fc38331
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Lachlan:

>
> We all start somewhere!
>

Yes. I'll start from this problem :)

>
> It should also be the same architecture too - is it possible you have a
> 32 bit kernel on the 2.6.10 system and a 64 bit kernel on the 2.6.28
> system?  If so then this fix might help
>

The two systems are all 32bit.

Enlightened by your suggestion, I find problem lies in the two systems are
different architecture. One is arm, on is x86. Use 2.6.10 on both system,
XFS created on arm can't mount on x86, vice versa (dump stack at
xlog_recover_process_data).

Use xfs_logprint to inspect log, tool exit with assertion failed:
"item->ri_buf[0].i_len == sizeof(xfs_inode_log_format_t)". Debug the
assertion and find xfs_inode_log_format_t on arm is 56 byte, on x86 is 52
byte. Then find on 2.6.10 xfs_inode_log_format is not packed!! Fix this, fix
the mount failed problem.

Grep the code and find a lot other log/metadata needs pack on 2.6.10. I find
these
 xfs_fid64
 xfs_extent_32_t
 xfs_efi_log_format_32_t
 xfs_efd_log_format_32_t
 xfs_inode_log_format_32_t
 xfs_flock64_32
 compat_xfs_fsop_geom_v1_t
 compat_xfs_inogrp_t
 xfs_dir2_sf_off_t
 xfs_dir2_sf_hdr_t
 xfs_dir2_sf_entry_t

Is there any other log/metadata needs pack on 2.6.10? Any other
problem/caveat I need pay attention to while/besides fix pack bug?

Thanks
Eddy

--0016364ee89cb4510b046fc38331
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Hello Lachlan:</p>
<p>&gt;<br>&gt; We all start somewhere!<br>&gt;</p>
<p>Yes. I&#39;ll start from this problem :)</p>
<p>&gt;<br>&gt; It should also be the same architecture too - is it possibl=
e you have a<br>&gt; 32 bit kernel on the 2.6.10 system and a 64 bit kernel=
 on the 2.6.28<br>&gt; system?=A0 If so then this fix might help<br>&gt;</p=
>

<p>The two systems are all 32bit.</p>
<p>Enlightened by your suggestion, I find problem lies in the two systems a=
re different architecture. One is arm, on is x86. Use 2.6.10 on both system=
, XFS created on arm can&#39;t mount on x86, vice versa (dump stack at xlog=
_recover_process_data). </p>

<p>Use xfs_logprint to inspect log, tool exit with assertion failed: &quot;=
item-&gt;ri_buf[0].i_len =3D=3D sizeof(xfs_inode_log_format_t)&quot;. Debug=
 the assertion and find xfs_inode_log_format_t on arm is 56 byte, on x86 is=
 52 byte. Then find on 2.6.10 xfs_inode_log_format is not packed!! Fix this=
, fix the mount failed problem.</p>

<p>Grep the code and find a lot other log/metadata needs pack on 2.6.10. I =
find these<br>=A0xfs_fid64<br>=A0xfs_extent_32_t<br>=A0xfs_efi_log_format_3=
2_t<br>=A0xfs_efd_log_format_32_t<br>=A0xfs_inode_log_format_32_t<br>=A0xfs=
_flock64_32<br>
=A0compat_xfs_fsop_geom_v1_t<br>=A0compat_xfs_inogrp_t<br>=A0xfs_dir2_sf_of=
f_t<br>=A0xfs_dir2_sf_hdr_t<br>=A0xfs_dir2_sf_entry_t</p>
<p>Is there any other log/metadata needs pack on 2.6.10? Any other problem/=
caveat I need pay attention to while/besides fix pack bug?</p>
<p>Thanks<br>Eddy</p>

--0016364ee89cb4510b046fc38331--


--===============1416429439103848319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1416429439103848319==--
