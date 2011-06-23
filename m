Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5N5pUm3159884 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 00:51:30 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FCBE14F584C
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:51:27 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	PpDGT1VkDOyq2Tl6 for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 22:51:27 -0700 (PDT)
Received: by eyh5 with SMTP id 5so515908eyh.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 22:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E022818.7030406@linux.vnet.ibm.com>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
	<BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
	<4E022818.7030406@linux.vnet.ibm.com>
Date: Thu, 23 Jun 2011 11:21:26 +0530
Message-ID: <BANLkTimuv183W0ef0aYCySWPnv9rLqNuww@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2148202455065918057=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com

--===============2148202455065918057==
Content-Type: multipart/alternative; boundary=e0cb4e70053702493504a65aad17

--e0cb4e70053702493504a65aad17
Content-Type: text/plain; charset=ISO-8859-1

Hi,

*PLATFORM      -- Linux/i686 localhost 2.6.31.5-127.fc12.i686.PAE*

The output as per the command mentioned by you:
[root@localhost xfstests-2011-05-11]# xfs_io -f -c "truncate 20k" -c "falloc
0 20k" -c "pwrite 0k 8k" -c "fs
ync" -c "pwrite 12k 8k" -c "fsync" -c "fpunch 4k 12k" -c "fiemap -v"
/media/c/newfile
wrote 8192/8192 bytes at offset 0
8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1111 ops/sec)
command "fs
ync" not found
wrote 8192/8192 bytes at offset 12288
8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)
/media/c/newfile:
* EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..15]:         176..191            16   0x0
   1: [16..23]:        192..199             8 0x800
   2: [24..39]:        200..215            16   0x1
*
Thanks & Regards,
Amit Sahrawat



On Wed, Jun 22, 2011 at 11:06 PM, Allison Henderson <
achender@linux.vnet.ibm.com> wrote:

> On 06/22/2011 03:48 AM, Amit Sahrawat wrote:
>
>> xfs_io -f -c "truncate 20k" -c \
>> "falloc 0 20k" -c "pwrite 0k 8k" -c "fsync" -c "pwrite 12k 8k" -c  \
>> "fsync" -c "fpunch 4k 12k" -c "fiemap -v" $testfile | $filter_cmd
>>
>> *Original Output(Taken from 252.out):
>> *        13. data ->  unwritten ->  data
>> 0: [0..7]: data
>> 1: [8..31]: hole
>> 2: [32..39]: data
>> *Output in my case*
>>   13. data ->  unwritten ->  data
>> 0: [0..15]: data
>> 1: [16..23]: unwritten
>> 2: [24..39]: data
>>
>> Please let me know about the vailidity of this result.
>>
>
> Hi there,
>
> It looks like the "fpunch 4k 12k" is supposed to be what puts the hole
> there.  If I run the command you have above, the fiemap should show a hole
> like this:
>
>
> xfs_io -f -c "truncate 20k" -c "falloc 0 20k" -c "pwrite 0k 8k" -c "fsync"
> -c "pwrite 12k 8k" -c  "fsync" -c "fpunch 4k 12k" -c "fiemap -v" somefile
> wrote 8192/8192 bytes at offset 0
> 8 KiB, 2 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)
> wrote 8192/8192 bytes at offset 12288
> 8 KiB, 2 ops; 0.0000 sec (339.674 MiB/sec and 86956.5217 ops/sec)
>
> somefile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>   0: [0..7]:          256..263             8   0x0
>
>   1: [8..31]:         hole                24
>   2: [32..39]:        288..295             8   0x1
>
> If you do not see the hole, it could be your punch hole operation is
> failing for some reason.
>
> Allison Henderson
>
>

--e0cb4e70053702493504a65aad17
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div><div>=A0</div><div><strong>PLATFORM=A0=A0=A0=A0=A0 -- Linux/i=
686 localhost 2.6.31.5-127.fc12.i686.PAE</strong></div><div>=A0</div><div>T=
he output as per=A0the command mentioned by you:</div><div>[root@localhost =
xfstests-2011-05-11]# xfs_io -f -c &quot;truncate 20k&quot; -c &quot;falloc=
 0 20k&quot; -c &quot;pwrite 0k 8k&quot; -c &quot;fs<br>
ync&quot; -c &quot;pwrite 12k 8k&quot; -c &quot;fsync&quot; -c &quot;fpunch=
 4k 12k&quot; -c &quot;fiemap -v&quot; /media/c/newfile<br>wrote 8192/8192 =
bytes at offset 0<br>8 KiB, 2 ops; 0.0000 sec (434.028 MiB/sec and 111111.1=
111 ops/sec)<br>
command &quot;fs<br>ync&quot; not found<br>wrote 8192/8192 bytes at offset =
12288<br>8 KiB, 2 ops; 0.0000 sec (977 MiB/sec and 250000.0000 ops/sec)<br>=
/media/c/newfile:<br><strong>=A0EXT: FILE-OFFSET=A0=A0=A0=A0=A0 BLOCK-RANGE=
=A0=A0=A0=A0=A0 TOTAL FLAGS<br>
=A0=A0 0: [0..15]:=A0=A0=A0=A0=A0=A0=A0=A0 176..191=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 16=A0=A0 0x0<br>=A0=A0 1: [16..23]:=A0=A0=A0=A0=A0=A0=A0 192..199=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 8 0x800<br>=A0=A0 2: [24..39]:=A0=A0=
=A0=A0=A0=A0=A0 200..215=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 16=A0=A0 0x1<br><=
/strong></div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat</div>
<div><br><br>=A0</div><div class=3D"gmail_quote">On Wed, Jun 22, 2011 at 11=
:06 PM, Allison Henderson <span dir=3D"ltr">&lt;<a href=3D"mailto:achender@=
linux.vnet.ibm.com">achender@linux.vnet.ibm.com</a>&gt;</span> wrote:<br><b=
lockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-lef=
t-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style: sol=
id;" class=3D"gmail_quote">
<div class=3D"im">On 06/22/2011 03:48 AM, Amit Sahrawat wrote:<br>
</div><div class=3D"im"><blockquote style=3D"margin: 0px 0px 0px 0.8ex; pad=
ding-left: 1ex; border-left-color: rgb(204, 204, 204); border-left-width: 1=
px; border-left-style: solid;" class=3D"gmail_quote">
xfs_io -f -c &quot;truncate 20k&quot; -c \<br>
&quot;falloc 0 20k&quot; -c &quot;pwrite 0k 8k&quot; -c &quot;fsync&quot; -=
c &quot;pwrite 12k 8k&quot; -c =A0\<br>
&quot;fsync&quot; -c &quot;fpunch 4k 12k&quot; -c &quot;fiemap -v&quot; $te=
stfile | $filter_cmd<br>
<br>
*Original Output(Taken from 252.out):<br>
* =A0 =A0 =A0 =A013. data -&gt; =A0unwritten -&gt; =A0data<br>
0: [0..7]: data<br>
1: [8..31]: hole<br>
2: [32..39]: data<br>
*Output in my case*<br>
 =A0 13. data -&gt; =A0unwritten -&gt; =A0data<br>
0: [0..15]: data<br>
1: [16..23]: unwritten<br>
2: [24..39]: data<br>
<br>
Please let me know about the vailidity of this result.<br>
</blockquote>
<br></div>
Hi there,<br>
<br>
It looks like the &quot;fpunch 4k 12k&quot; is supposed to be what puts the=
 hole there. =A0If I run the command you have above, the fiemap should show=
 a hole like this:<div class=3D"im"><br>
<br>
xfs_io -f -c &quot;truncate 20k&quot; -c &quot;falloc 0 20k&quot; -c &quot;=
pwrite 0k 8k&quot; -c &quot;fsync&quot; -c &quot;pwrite 12k 8k&quot; -c =A0=
&quot;fsync&quot; -c &quot;fpunch 4k 12k&quot; -c &quot;fiemap -v&quot; som=
efile<br>

wrote 8192/8192 bytes at offset 0<br>
8 KiB, 2 ops; 0.0000 sec (217.014 MiB/sec and 55555.5556 ops/sec)<br>
wrote 8192/8192 bytes at offset 12288<br></div>
8 KiB, 2 ops; 0.0000 sec (339.674 MiB/sec and 86956.5217 ops/sec)<div class=
=3D"im"><br>
somefile:<br>
=A0EXT: FILE-OFFSET =A0 =A0 =A0BLOCK-RANGE =A0 =A0 =A0TOTAL FLAGS<br></div>
 =A0 0: [0..7]: =A0 =A0 =A0 =A0 =A0256..263 =A0 =A0 =A0 =A0 =A0 =A0 8 =A0 0=
x0<div class=3D"im"><br>
 =A0 1: [8..31]: =A0 =A0 =A0 =A0 hole =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024<br>=
</div>
 =A0 2: [32..39]: =A0 =A0 =A0 =A0288..295 =A0 =A0 =A0 =A0 =A0 =A0 8 =A0 0x1=
<br>
<br>
If you do not see the hole, it could be your punch hole operation is failin=
g for some reason.<br><font color=3D"#888888">
<br>
Allison Henderson<br>
<br>
</font></blockquote></div><br>

--e0cb4e70053702493504a65aad17--


--===============2148202455065918057==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2148202455065918057==--
