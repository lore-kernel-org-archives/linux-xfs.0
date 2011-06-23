Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N5lB5H159758 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 00:47:12 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6718273EA
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:47:10 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id ZhzWtPxjuXeAOLwH
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:47:10 -0700 (PDT)
Received: by ewy8 with SMTP id 8so509176ewy.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:47:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110622225718.GU32466@dastard>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<20110622225718.GU32466@dastard>
Date: Thu, 23 Jun 2011 11:17:09 +0530
Message-ID: <BANLkTimrYg7vu2ZrwA=KJ0RMkAMxjaigng@mail.gmail.com>
Subject: Re: XFS Test Case:252 - Shows Wrong Output
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1244210194197875734=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1244210194197875734==
Content-Type: multipart/alternative; boundary=0016364d1f8bab239404a65a9dd5

--0016364d1f8bab239404a65a9dd5
Content-Type: text/plain; charset=ISO-8859-1

This is the original result I got after running test case : 252
[root@localhost xfstests-2011-05-11]# ./check -xfs 252
*FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb4
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdb4 /media/d*
252  - output mismatch (see 252.out.bad)
--- 252.out 2011-06-21 12:47:23.000000000 +0530
+++ 252.out.bad 2011-06-23 11:10:33.000000000 +0530
@@ -1,47 +1,51 @@
 QA output created by 252
  1. into a hole
+0: [0..7]: hole
+1: [8..23]: unwritten
+2: [24..39]: hole
  2. into allocated space
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..39]: data
+0: [0..39]: data
  3. into unwritten space
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..39]: unwritten
+0: [0..39]: unwritten
  4. hole -> data
-0: [0..23]: hole
-1: [24..31]: data
-2: [32..39]: hole
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..31]: data
+3: [32..39]: hole
  5. hole -> unwritten
-0: [0..23]: hole
-1: [24..31]: unwritten
+0: [0..7]: hole
+1: [8..31]: unwritten
 2: [32..39]: hole
  6. data -> hole
-0: [0..7]: data
-1: [8..39]: hole
+0: [0..15]: data
+1: [16..23]: unwritten
+2: [24..39]: hole
  7. data -> unwritten
-0: [0..7]: data
-1: [8..23]: hole
-2: [24..31]: unwritten
-3: [32..39]: hole
+0: [0..15]: data
+1: [16..31]: unwritten
+2: [32..39]: hole
  8. unwritten -> hole
-0: [0..7]: unwritten
-1: [8..39]: hole
+0: [0..23]: unwritten
+1: [24..39]: hole
  9. unwritten -> data
-0: [0..7]: unwritten
-1: [8..23]: hole
-2: [24..31]: data
-3: [32..39]: hole
+0: [0..15]: unwritten
+1: [16..31]: data
+2: [32..39]: hole
  10. hole -> data -> hole
+0: [0..7]: hole
+1: [8..15]: unwritten
+2: [16..23]: data
+3: [24..31]: unwritten
+4: [32..39]: hole
  11. data -> hole -> data
-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
+0: [0..15]: data
+1: [16..23]: unwritten
+2: [24..39]: data
  *12. unwritten -> data -> unwritten
*-0: [0..7]: unwritten
-1: [8..31]: hole
-2: [32..39]: unwritten
*+0: [0..15]: unwritten
+1: [16..23]: data
+2: [24..39]: unwritten
* * 13. data -> unwritten -> data
*-0: [0..7]: data
-1: [8..31]: hole
-2: [32..39]: data
*+0: [0..15]: data
+1: [16..23]: unwritten
+2: [24..39]: data
*Ran: 252
Failures: 252
Failed 1 of 1 tests
[root@localhost xfstests-2011-05-11]#
The above output if for kernel version 2.6.31..

Thanks & Regards,
Amit Sahrawat

On Thu, Jun 23, 2011 at 4:27 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jun 22, 2011 at 04:18:52PM +0530, Amit Sahrawat wrote:
> > Dear All,
> > **
> > *Test Case:13
> > *        echo "  13. data -> unwritten -> data"
> >         rm -f $testfile
> >         $XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
> >                 -c "$alloc_cmd 0 20k" \
> >                 -c "pwrite 0k 8k" -c "fsync" \
> >                 -c "pwrite 12k 8k" -c "fsync" \
> >                 -c "$zero_cmd 4k 12k" \
> >                 -c "$map_cmd -v" $testfile | $filter_cmd
> >         [ $? -ne 0 ] && die_now
> >
> > *After executing individual case like this:
> > *testfile=/data/usb/sda3/252.testfile
> >
> > echo "13. data -> unwritten -> data"
> > rm -f $testfile
> > xfs_io -f -c "truncate 20k" -c \
> > "falloc 0 20k" -c "pwrite 0k 8k" -c "fsync" -c "pwrite 12k 8k" -c  \
> > "fsync" -c "fpunch 4k 12k" -c "fiemap -v" $testfile | $filter_cmd
> >
> > *Original Output(Taken from 252.out):
> > *        13. data -> unwritten -> data
> > 0: [0..7]: data
> > 1: [8..31]: hole
> > 2: [32..39]: data
> > *Output in my case*
> >   13. data -> unwritten -> data
> > 0: [0..15]: data
> > 1: [16..23]: unwritten
> > 2: [24..39]: data
>
> FWIW, it would be much easier for us to understand your problem if
> you simply posted the output of a failing "check 252" (it's a diff
> of the output vs the golden output!) rather than a bunch of strange
> mangled script outputs from whatever wrapper you are using to run
> xfstests that nobody but you understand.
>
> Anyway, I'm pretty sure that 2.6.35.y doesn't support punching holes
> via the fallocate operation and so this check in the test:
>
> _require_xfs_io_falloc_punch
>
> is probably not detecting that punch is not supported correctly.
> Perhaps that is what you need to check first...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016364d1f8bab239404a65a9dd5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>This is the original result I got after running test case : 252</div><=
div>[root@localhost xfstests-2011-05-11]# ./check -xfs 252<br><strong>FSTYP=
=A0=A0=A0=A0=A0=A0=A0=A0 -- xfs (non-debug)<br>PLATFORM=A0=A0=A0=A0=A0 -- L=
inux/i686 localhost 2.6.31.5-127.fc12.i686.PAE<br>
MKFS_OPTIONS=A0 -- -f -bsize=3D4096 /dev/sdb4<br>MOUNT_OPTIONS -- -o contex=
t=3Dsystem_u:object_r:nfs_t:s0 /dev/sdb4 /media/d</strong></div><div>252=A0=
 - output mismatch (see 252.out.bad)<br>--- 252.out=A02011-06-21 12:47:23.0=
00000000 +0530<br>
+++ 252.out.bad=A02011-06-23 11:10:33.000000000 +0530<br>@@ -1,47 +1,51 @@<=
br>=A0QA output created by 252<br>=A0=A01. into a hole<br>+0: [0..7]: hole<=
br>+1: [8..23]: unwritten<br>+2: [24..39]: hole<br>=A0=A02. into allocated =
space<br>
-0: [0..7]: data<br>-1: [8..23]: hole<br>-2: [24..39]: data<br>+0: [0..39]:=
 data<br>=A0=A03. into unwritten space<br>-0: [0..7]: unwritten<br>-1: [8..=
23]: hole<br>-2: [24..39]: unwritten<br>+0: [0..39]: unwritten<br>=A0=A04. =
hole -&gt; data<br>
-0: [0..23]: hole<br>-1: [24..31]: data<br>-2: [32..39]: hole<br>+0: [0..7]=
: hole<br>+1: [8..15]: unwritten<br>+2: [16..31]: data<br>+3: [32..39]: hol=
e<br>=A0=A05. hole -&gt; unwritten<br>-0: [0..23]: hole<br>-1: [24..31]: un=
written<br>
+0: [0..7]: hole<br>+1: [8..31]: unwritten<br>=A02: [32..39]: hole<br>=A0=
=A06. data -&gt; hole<br>-0: [0..7]: data<br>-1: [8..39]: hole<br>+0: [0..1=
5]: data<br>+1: [16..23]: unwritten<br>+2: [24..39]: hole<br>=A0=A07. data =
-&gt; unwritten<br>
-0: [0..7]: data<br>-1: [8..23]: hole<br>-2: [24..31]: unwritten<br>-3: [32=
..39]: hole<br>+0: [0..15]: data<br>+1: [16..31]: unwritten<br>+2: [32..39]=
: hole<br>=A0=A08. unwritten -&gt; hole<br>-0: [0..7]: unwritten<br>-1: [8.=
.39]: hole<br>
+0: [0..23]: unwritten<br>+1: [24..39]: hole<br>=A0=A09. unwritten -&gt; da=
ta<br>-0: [0..7]: unwritten<br>-1: [8..23]: hole<br>-2: [24..31]: data<br>-=
3: [32..39]: hole<br>+0: [0..15]: unwritten<br>+1: [16..31]: data<br>+2: [3=
2..39]: hole<br>
=A0=A010. hole -&gt; data -&gt; hole<br>+0: [0..7]: hole<br>+1: [8..15]: un=
written<br>+2: [16..23]: data<br>+3: [24..31]: unwritten<br>+4: [32..39]: h=
ole<br>=A0=A011. data -&gt; hole -&gt; data<br>-0: [0..7]: data<br>-1: [8..=
31]: hole<br>
-2: [32..39]: data<br>+0: [0..15]: data<br>+1: [16..23]: unwritten<br>+2: [=
24..39]: data<br>=A0=A0<strong>12. unwritten -&gt; data -&gt; unwritten<br>=
</strong>-0: [0..7]: unwritten<br>-1: [8..31]: hole<br>-2: [32..39]: unwrit=
ten<br>
<strong>+0: [0..15]: unwritten<br>+1: [16..23]: data<br>+2: [24..39]: unwri=
tten<br></strong>=A0<strong>=A013. data -&gt; unwritten -&gt; data<br></str=
ong>-0: [0..7]: data<br>-1: [8..31]: hole<br>-2: [32..39]: data<br><strong>=
+0: [0..15]: data<br>
+1: [16..23]: unwritten<br>+2: [24..39]: data<br></strong>Ran: 252<br>Failu=
res: 252<br>Failed 1 of 1 tests<br>[root@localhost xfstests-2011-05-11]# <b=
r></div><div>The above output if for kernel version 2.6.31..</div><div>
=A0</div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat<br>=A0</div><di=
v class=3D"gmail_quote">On Thu, Jun 23, 2011 at 4:27 AM, Dave Chinner <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com=
</a>&gt;</span> wrote:<br>
<blockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-l=
eft-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style: s=
olid;" class=3D"gmail_quote"><div><div></div><div class=3D"h5">On Wed, Jun =
22, 2011 at 04:18:52PM +0530, Amit Sahrawat wrote:<br>

&gt; Dear All,<br>
&gt; **<br>
&gt; *Test Case:13<br>
&gt; * =A0 =A0 =A0 =A0echo &quot; =A013. data -&gt; unwritten -&gt; data&qu=
ot;<br>
&gt; =A0 =A0 =A0 =A0 rm -f $testfile<br>
&gt; =A0 =A0 =A0 =A0 $XFS_IO_PROG $xfs_io_opt -f -c &quot;truncate 20k&quot=
; \<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -c &quot;$alloc_cmd 0 20k&quot; \<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -c &quot;pwrite 0k 8k&quot; -c &quot;f=
sync&quot; \<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -c &quot;pwrite 12k 8k&quot; -c &quot;=
fsync&quot; \<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -c &quot;$zero_cmd 4k 12k&quot; \<br>
&gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -c &quot;$map_cmd -v&quot; $testfile |=
 $filter_cmd<br>
&gt; =A0 =A0 =A0 =A0 [ $? -ne 0 ] &amp;&amp; die_now<br>
&gt;<br>
&gt; *After executing individual case like this:<br>
&gt; *testfile=3D/data/usb/sda3/252.testfile<br>
&gt;<br>
&gt; echo &quot;13. data -&gt; unwritten -&gt; data&quot;<br>
&gt; rm -f $testfile<br>
&gt; xfs_io -f -c &quot;truncate 20k&quot; -c \<br>
&gt; &quot;falloc 0 20k&quot; -c &quot;pwrite 0k 8k&quot; -c &quot;fsync&qu=
ot; -c &quot;pwrite 12k 8k&quot; -c =A0\<br>
&gt; &quot;fsync&quot; -c &quot;fpunch 4k 12k&quot; -c &quot;fiemap -v&quot=
; $testfile | $filter_cmd<br>
&gt;<br>
&gt; *Original Output(Taken from 252.out):<br>
&gt; * =A0 =A0 =A0 =A013. data -&gt; unwritten -&gt; data<br>
&gt; 0: [0..7]: data<br>
&gt; 1: [8..31]: hole<br>
&gt; 2: [32..39]: data<br>
&gt; *Output in my case*<br>
&gt; =A0 13. data -&gt; unwritten -&gt; data<br>
&gt; 0: [0..15]: data<br>
&gt; 1: [16..23]: unwritten<br>
&gt; 2: [24..39]: data<br>
<br>
</div></div>FWIW, it would be much easier for us to understand your problem=
 if<br>
you simply posted the output of a failing &quot;check 252&quot; (it&#39;s a=
 diff<br>
of the output vs the golden output!) rather than a bunch of strange<br>
mangled script outputs from whatever wrapper you are using to run<br>
xfstests that nobody but you understand.<br>
<br>
Anyway, I&#39;m pretty sure that 2.6.35.y doesn&#39;t support punching hole=
s<br>
via the fallocate operation and so this check in the test:<br>
<br>
_require_xfs_io_falloc_punch<br>
<br>
is probably not detecting that punch is not supported correctly.<br>
Perhaps that is what you need to check first...<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br>

--0016364d1f8bab239404a65a9dd5--


--===============1244210194197875734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1244210194197875734==--
