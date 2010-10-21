Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LCAako251399 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 07:10:36 -0500
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AACC1DA698E
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 05:11:49 -0700 (PDT)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	Uo6oi7Fsv84dXeCu for <xfs@oss.sgi.com>;
	Thu, 21 Oct 2010 05:11:49 -0700 (PDT)
Received: by iwn39 with SMTP id 39so5974432iwn.26
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 05:11:49 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Oct 2010 17:41:43 +0530
Message-ID: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
Subject: XFS: bad clientid on recovery on MIPS (VIPT cache)
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4142631779465495937=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4142631779465495937==
Content-Type: multipart/alternative; boundary=00221532be90e933a704931f6d91

--00221532be90e933a704931f6d91
Content-Type: text/plain; charset=ISO-8859-1

Dear member,
If I remove USB flash storage from PC/ARM/MIPS target (i.e
without umount) while copying file to XFS partition and connect it to MIPS
target I always get
XFS: xlog_recover_process_data: bad clientid
XFS: log mount/recovery failed: error 5
XFS: log mount failed
This problem does not occur, if I connect the same USB flash to PC/ARM
target.
I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend with
MIPS)

I had two workaround to avoid this problem on MIPS, but I wish to know the
exact reason of this problme on MIPS.
I am really tired and giving up, so finally thought of taking your help,
your guidence can help me.

1. __flush_cache_all() at the begining of each iteration of while loop in
function xlog_recover_process_data().

     while ((dp < lp) && num_logops) {
+       __flush_cache_all() ;
         ASSERT(dp + sizeof(xlog_op_header_t) <= lp);
         ohead = (xlog_op_header_t *)dp;
         dp += sizeof(xlog_op_header_t);
         if (ohead->oh_clientid != XFS_TRANSACTION &&
             ohead->oh_clientid != XFS_LOG) {
             xlog_warn(
             "XFS: xlog_recover_process_data: bad clientid")

OR

2. Provide new buffer in each call to xlog_bread in function
xlog_do_recovery_pass().

          if (error)
              goto bread_err2;
          /* blocks in data section */
          bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
+        xlog_put_bp(dbp);
+        dbp = xlog_get_bp(log, BTOBB(h_size));
          error = xlog_bread(log, blk_no + hblks, bblks, dbp,
                                     &offset);
          if (error)
              goto bread_err2;

WIth Regards
Ajeet Yadav

--00221532be90e933a704931f6d91
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear member,</div>
<div>If I remove=A0USB flash storage from PC/ARM/MIPS target (i.e without=
=A0umount)=A0while copying=A0file=A0to XFS partition=A0and connect it to MI=
PS target I always get</div>
<div>XFS: xlog_recover_process_data: bad clientid<br>XFS: log mount/recover=
y failed: error 5<br>XFS: log mount failed</div>
<div>This problem does not occur, if I=A0connect the same USB flash to PC/A=
RM target.</div>
<div>I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend wi=
th MIPS)</div>
<div>=A0</div>
<div>I had two workaround to avoid=A0this problem on MIPS, but I wish to kn=
ow the exact reason of this problme on MIPS.</div>
<div>I am really=A0tired and giving up, so finally thought of taking your h=
elp, your guidence can help me.</div>
<div>=A0</div>
<div>1. __flush_cache_all() at the begining of each iteration of while loop=
 in function xlog_recover_process_data().=A0</div>
<div>=A0</div>
<div>=A0=A0=A0=A0 while ((dp &lt; lp) &amp;&amp; num_logops) {</div>
<div>+=A0=A0=A0=A0=A0=A0 __flush_cache_all()=A0;<br>=A0=A0=A0=A0=A0=A0=A0=
=A0 ASSERT(dp + sizeof(xlog_op_header_t) &lt;=3D lp);<br>=A0=A0=A0=A0=A0=A0=
=A0=A0 ohead =3D (xlog_op_header_t *)dp;<br>=A0=A0=A0=A0=A0=A0=A0=A0 dp +=
=3D sizeof(xlog_op_header_t);<br>=A0=A0=A0=A0=A0=A0=A0=A0 if (ohead-&gt;oh_=
clientid !=3D XFS_TRANSACTION &amp;&amp;<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ohead-&gt;oh_clientid !=3D XFS_LOG) {<=
br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 xlog_warn(<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 &quot;XFS: xlog_recover_process_data: bad clientid&quot;)</=
div>
<div>=A0</div>
<div>OR</div>
<div>=A0</div>
<div>2. Provide new buffer in each call to xlog_bread in function xlog_do_r=
ecovery_pass().</div>
<div>=A0</div>
<div>=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (error)<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 goto bread_err2;</div>
<div>=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* blocks in data section */<br>=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bblks =3D (int)BTOBB(be32_to_cpu(rhead-&gt;h_len));</div=
>
<div>+=A0=A0=A0=A0=A0=A0=A0 xlog_put_bp(dbp);<br>+=A0=A0=A0=A0=A0=A0=A0 dbp=
 =3D xlog_get_bp(log, BTOBB(h_size));<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0erro=
r =3D xlog_bread(log, blk_no + hblks, bblks, dbp,<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 &amp;offset);<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (error)<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto bread_err2;=A0</div>
<div>=A0</div>
<div>WIth Regards</div>
<div>Ajeet Yadav</div>
<div>=A0=A0=A0 =A0=A0=A0=A0</div>

--00221532be90e933a704931f6d91--


--===============4142631779465495937==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4142631779465495937==--
