Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N6asEB161507 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 01:36:55 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5337E00DE8
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 23:36:52 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	7S3NnfbprBYKruTL for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 23:36:52 -0700 (PDT)
Received: by eyh5 with SMTP id 5so524996eyh.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 23:36:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110623062030.GY32466@dastard>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<4E022818.7030406@linux.vnet.ibm.com>
	<BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
	<20110623062030.GY32466@dastard>
Date: Thu, 23 Jun 2011 12:06:51 +0530
Message-ID: <BANLkTi=2rTU2R_hGGeMhLYzM6FKPOW0L8w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============8920944493571582987=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Allison Henderson <achender@linux.vnet.ibm.com>

--===============8920944493571582987==
Content-Type: multipart/alternative; boundary=0016364c6ecf730c7004a65b4f0b

--0016364c6ecf730c7004a65b4f0b
Content-Type: text/plain; charset=ISO-8859-1

Fortunately or Unfortunately I have 2.6.31(x86) and 2.6.35.13(ARM) and both
do not support "fpunch". As per your earlier mail - 2.6.35.y does not
support "fpunch" so I though of trying on 2.6.31.y.

I will check out for the return errors in this condition and will update
more on this.

Thanks & Regards,
Amit Sahrawat



On Thu, Jun 23, 2011 at 11:50 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jun 23, 2011 at 11:21:26AM +0530, Amit Sahrawat wrote:
> > Hi,
> >
> > *PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE*
>                                         ^^^^^^^^^^^
> >
> > The output as per the command mentioned by you:
> > [root@localhost xfstests-2011-05-11]# xfs_io -f -c "truncate 20k" -c
> "falloc
> > 0 20k" -c "pwrite 0k 8k" -c "fs
> > ync" -c "pwrite 12k 8k" -c "fsync" -c "fpunch 4k 12k" -c "fiemap -v"
> > /media/c/newfile
> > wrote 8192/8192 bytes at offset 0
> > 8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1111 ops/sec)
> > command "fs
> > ync" not found
> > wrote 8192/8192 bytes at offset 12288
> > 8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)
> > /media/c/newfile:
> > * EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
> >    0: [0..15]:         176..191            16   0x0
> >    1: [16..23]:        192..199             8 0x800
> >    2: [24..39]:        200..215            16   0x1
> > *
>
> The fpunch command did not punch the range out.
>
> Amit, once again you're testing on a kernel (2.6.31) that does not
> support the punch operation. As I suggested previously, you need to
> find out why the fpunch command is not returning an error as that is
> root cause of your failures.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016364c6ecf730c7004a65b4f0b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Fortunately or Unfortunately I have 2.6.31(x86) and 2.6.35.13(ARM) and=
 both do not support &quot;fpunch&quot;. As per your earlier mail - 2.6.35.=
y does not support &quot;fpunch&quot; so I though of trying on 2.6.31.y.</d=
iv>
<div>=A0</div><div>I will check out for the return errors in this condition=
 and will update more on this. </div><div>=A0</div><div>Thanks &amp; Regard=
s,</div><div>Amit Sahrawat</div><div><br><br>=A0</div><div class=3D"gmail_q=
uote">
On Thu, Jun 23, 2011 at 11:50 AM, Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com">david@fromorbit.com</a>&gt;</span> wrote:<=
br><blockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; borde=
r-left-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style=
: solid;" class=3D"gmail_quote">
<div class=3D"im">On Thu, Jun 23, 2011 at 11:21:26AM +0530, Amit Sahrawat w=
rote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; *PLATFORM =A0 =A0 =A0-- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PA=
E*<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 ^^^^^^^^^^^<br>
&gt;<br>
&gt; The output as per the command mentioned by you:<br>
&gt; [root@localhost xfstests-2011-05-11]# xfs_io -f -c &quot;truncate 20k&=
quot; -c &quot;falloc<br>
&gt; 0 20k&quot; -c &quot;pwrite 0k 8k&quot; -c &quot;fs<br>
&gt; ync&quot; -c &quot;pwrite 12k 8k&quot; -c &quot;fsync&quot; -c &quot;f=
punch 4k 12k&quot; -c &quot;fiemap -v&quot;<br>
&gt; /media/c/newfile<br>
&gt; wrote 8192/8192 bytes at offset 0<br>
&gt; 8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1111 ops/sec)<br>
&gt; command &quot;fs<br>
&gt; ync&quot; not found<br>
&gt; wrote 8192/8192 bytes at offset 12288<br>
&gt; 8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)<br>
&gt; /media/c/newfile:<br>
&gt; * EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0TOTAL FLAGS<br>
&gt; =A0 =A00: [0..15]: =A0 =A0 =A0 =A0 176..191 =A0 =A0 =A0 =A0 =A0 =A016 =
=A0 0x0<br>
&gt; =A0 =A01: [16..23]: =A0 =A0 =A0 =A0192..199 =A0 =A0 =A0 =A0 =A0 =A0 8 =
0x800<br>
&gt; =A0 =A02: [24..39]: =A0 =A0 =A0 =A0200..215 =A0 =A0 =A0 =A0 =A0 =A016 =
=A0 0x1<br>
</div>&gt; *<br>
<br>
The fpunch command did not punch the range out.<br>
<br>
Amit, once again you&#39;re testing on a kernel (2.6.31) that does not<br>
support the punch operation. As I suggested previously, you need to<br>
find out why the fpunch command is not returning an error as that is<br>
root cause of your failures.<br>
<div><div></div><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br>

--0016364c6ecf730c7004a65b4f0b--


--===============8920944493571582987==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8920944493571582987==--
