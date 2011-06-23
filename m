Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NAvsf5177856 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 05:57:54 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 285802832F
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 03:57:53 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	55ldONZfZmd1nfsl for <xfs@oss.sgi.com>;
	Thu, 23 Jun 2011 03:57:53 -0700 (PDT)
Received: by eyh5 with SMTP id 5so587355eyh.26
	for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 03:57:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=2rTU2R_hGGeMhLYzM6FKPOW0L8w@mail.gmail.com>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<4E022818.7030406@linux.vnet.ibm.com>
	<BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
	<20110623062030.GY32466@dastard>
	<BANLkTi=2rTU2R_hGGeMhLYzM6FKPOW0L8w@mail.gmail.com>
Date: Thu, 23 Jun 2011 16:27:52 +0530
Message-ID: <BANLkTinQig04y6Rc9MHGSfpbTSKZpmtHpQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3783902849273100275=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Allison Henderson <achender@linux.vnet.ibm.com>

--===============3783902849273100275==
Content-Type: multipart/alternative; boundary=0016364d1f8be3308104a65ef43a

--0016364d1f8be3308104a65ef43a
Content-Type: text/plain; charset=ISO-8859-1

This is linked with new feature.. Add punch support, although the code
existed before also, but the 'punch' has been specifically handled through
cmd = XFS_IOC_UNRESVP.

Also, *fallocate* is moved out from  *'xfs_iops.c'* to 'file operations' in
*xfs_file.c*, which handles the case for

if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
               return -EOPNOTSUPP;
...
if(mode & FALLOC_FL_PUNCH_HOLE)
                cmd = XFS_IOC_UNRESVSP;
...
Now, for old kernels, how to make sure that this test case does not execute
or return meaningful error? without changing the kernel code it will not
return error;
Since, *FALLOC_FL_KEEP_SIZE *this is true and the command work with
XFS_IOC_RESVP.

Please suggest.


Thanks & Regards,
Amit Sahrawat



On Thu, Jun 23, 2011 at 12:06 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com>wrote:

> Fortunately or Unfortunately I have 2.6.31(x86) and 2.6.35.13(ARM) and both
> do not support "fpunch". As per your earlier mail - 2.6.35.y does not
> support "fpunch" so I though of trying on 2.6.31.y.
>
> I will check out for the return errors in this condition and will update
> more on this.
>
> Thanks & Regards,
> Amit Sahrawat
>
>
>
> On Thu, Jun 23, 2011 at 11:50 AM, Dave Chinner <david@fromorbit.com>wrote:
>
>> On Thu, Jun 23, 2011 at 11:21:26AM +0530, Amit Sahrawat wrote:
>> > Hi,
>> >
>> > *PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE*
>>                                         ^^^^^^^^^^^
>> >
>> > The output as per the command mentioned by you:
>> > [root@localhost xfstests-2011-05-11]# xfs_io -f -c "truncate 20k" -c
>> "falloc
>> > 0 20k" -c "pwrite 0k 8k" -c "fs
>> > ync" -c "pwrite 12k 8k" -c "fsync" -c "fpunch 4k 12k" -c "fiemap -v"
>> > /media/c/newfile
>> > wrote 8192/8192 bytes at offset 0
>> > 8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1111 ops/sec)
>> > command "fs
>> > ync" not found
>> > wrote 8192/8192 bytes at offset 12288
>> > 8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)
>> > /media/c/newfile:
>> > * EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>> >    0: [0..15]:         176..191            16   0x0
>> >    1: [16..23]:        192..199             8 0x800
>> >    2: [24..39]:        200..215            16   0x1
>> > *
>>
>> The fpunch command did not punch the range out.
>>
>> Amit, once again you're testing on a kernel (2.6.31) that does not
>> support the punch operation. As I suggested previously, you need to
>> find out why the fpunch command is not returning an error as that is
>> root cause of your failures.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>

--0016364d1f8be3308104a65ef43a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>This is linked with new feature.. Add punch support, although the code=
 existed before also, but the &#39;punch&#39; has been specifically handled=
 through</div><div>cmd =3D XFS_IOC_UNRESVP.</div><div>=A0</div><div>Also, <=
strong>fallocate</strong> is moved out from =A0<em>&#39;xfs_iops.c&#39;</em=
> to &#39;file operations&#39; in <em>xfs_file.c</em>, which handles the ca=
se for=A0=A0=A0 </div>
<div>=A0</div><div>if (mode &amp; ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_H=
OLE))<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EOPNOTSUPP;</di=
v><div>...</div><div>if(mode &amp; FALLOC_FL_PUNCH_HOLE)<br>=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cmd =3D XFS_IOC_UNRESVSP;</div>
<div>...</div><div>Now, for old kernels, how to make sure that this test ca=
se does not execute or return meaningful error? without changing the kernel=
 code it will not return error;</div><div>Since, <strong>FALLOC_FL_KEEP_SIZ=
E </strong>this is true and the command work=A0with XFS_IOC_RESVP.</div>
<div>=A0</div><div>Please suggest.</div><div>=A0</div><div>=A0</div><div>Th=
anks &amp; Regards,</div><div>Amit Sahrawat</div><div><br><br>=A0</div><div=
 class=3D"gmail_quote">On Thu, Jun 23, 2011 at 12:06 PM, Amit Sahrawat <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:amit.sahrawat83@gmail.com">amit.sahrawa=
t83@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-l=
eft-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style: s=
olid;" class=3D"gmail_quote"><div>Fortunately or Unfortunately I have 2.6.3=
1(x86) and 2.6.35.13(ARM) and both do not support &quot;fpunch&quot;. As pe=
r your earlier mail - 2.6.35.y does not support &quot;fpunch&quot; so I tho=
ugh of trying on 2.6.31.y.</div>

<div>=A0</div><div>I will check out for the return errors in this condition=
 and will update more on this. </div><div>=A0</div><div>Thanks &amp; Regard=
s,</div><div>Amit Sahrawat</div><div><div></div><div class=3D"h5"><div><br>=
<br>
=A0</div><div class=3D"gmail_quote">
On Thu, Jun 23, 2011 at 11:50 AM, Dave Chinner <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&=
gt;</span> wrote:<br><blockquote style=3D"margin: 0px 0px 0px 0.8ex; paddin=
g-left: 1ex; border-left-color: rgb(204, 204, 204); border-left-width: 1px;=
 border-left-style: solid;" class=3D"gmail_quote">

<div>On Thu, Jun 23, 2011 at 11:21:26AM +0530, Amit Sahrawat wrote:<br>
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
<div><div></div><div><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.co=
m</a><br>
</div></div></blockquote></div><br>
</div></div></blockquote></div><br>

--0016364d1f8be3308104a65ef43a--


--===============3783902849273100275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3783902849273100275==--
