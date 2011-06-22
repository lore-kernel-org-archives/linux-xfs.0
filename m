Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MAmt8K077221 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 05:48:56 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0837DF53E1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:48:53 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id vnKJHTZG6QnD0s04
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:48:53 -0700 (PDT)
Received: by ewy8 with SMTP id 8so207598ewy.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:48:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
References: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
Date: Wed, 22 Jun 2011 16:18:52 +0530
Message-ID: <BANLkTi=wHAxYuLE33AVsc2rp0eEm5GB40w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============5262621147711196396=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5262621147711196396==
Content-Type: multipart/alternative; boundary=0016364c62a1e1b39c04a64ab68a

--0016364c62a1e1b39c04a64ab68a
Content-Type: text/plain; charset=ISO-8859-1

Dear All,
**
*Test Case:13
*        echo "  13. data -> unwritten -> data"
        rm -f $testfile
        $XFS_IO_PROG $xfs_io_opt -f -c "truncate 20k" \
                -c "$alloc_cmd 0 20k" \
                -c "pwrite 0k 8k" -c "fsync" \
                -c "pwrite 12k 8k" -c "fsync" \
                -c "$zero_cmd 4k 12k" \
                -c "$map_cmd -v" $testfile | $filter_cmd
        [ $? -ne 0 ] && die_now

*After executing individual case like this:
*testfile=/data/usb/sda3/252.testfile

echo "13. data -> unwritten -> data"
rm -f $testfile
xfs_io -f -c "truncate 20k" -c \
"falloc 0 20k" -c "pwrite 0k 8k" -c "fsync" -c "pwrite 12k 8k" -c  \
"fsync" -c "fpunch 4k 12k" -c "fiemap -v" $testfile | $filter_cmd

*Original Output(Taken from 252.out):
*        13. data -> unwritten -> data
0: [0..7]: data
1: [8..31]: hole
2: [32..39]: data
*Output in my case*
  13. data -> unwritten -> data
0: [0..15]: data
1: [16..23]: unwritten
2: [24..39]: data

Please let me know about the vailidity of this result.

Thanks & Regards,
Amit Sahrawat
On Wed, Jun 22, 2011 at 3:54 PM, Amit Sahrawat <amit.sahrawat83@gmail.com>wrote:

> While executing Test case no: 252 from xfstestsuites - I got Output
> mismatch.
>
> *Environment tried:*
> *X86 : Linux version 2.6.31.5-127.fc12.i686.PAE*
> *ARM: Linux version2.6.35.13*
>
> On looking at the test case and then dividing the total case into invidual
> test's I could somehow correlate the results as per the commands issues.
> Complete output for the '13' commands in this case is as given below:
>
> [root@localhost PROGS]# sh cmd.sh
>   1. into a hole
> 0: [0..7]: hole
> 1: [8..23]: unwritten
> 2: [24..39]: hole
>   2. into allocated space
> 0: [0..39]: data
>   3. into unwritten space
> 0: [0..39]: unwritten
>   4. hole -> data
> 0: [0..7]: hole
> 1: [8..15]: unwritten
> 2: [16..31]: data
> 3: [32..39]: hole
>   5. hole -> unwritten
> 0: [0..7]: hole
> 1: [8..15]: unwritten
> 2: [16..31]: unwritten
> 3: [32..39]: hole
>   6. data -> hole
> 0: [0..15]: data
> 1: [16..23]: unwritten
> 2: [24..39]: hole
>   7. data -> unwritten
> 0: [0..15]: data
> 1: [16..31]: unwritten
> 2: [32..39]: hole
>   8. unwritten -> hole
> 0: [0..23]: unwritten
> 1: [24..39]: hole
>   9. unwritten -> data
> 0: [0..15]: unwritten
> 1: [16..31]: data
> 2: [32..39]: hole
>   10. hole -> data -> hole
> 0: [0..7]: hole
> 1: [8..15]: unwritten
> 2: [16..23]: data
> 3: [24..31]: unwritten
> 4: [32..39]: hole
>   11. data -> hole -> data
> 0: [0..15]: data
> 1: [16..23]: unwritten
> 2: [24..39]: data
>   12. unwritten -> data -> unwritten
> 0: [0..15]: unwritten
> 1: [16..23]: data
> 2: [24..39]: unwritten
>   13. data -> unwritten -> data
> 0: [0..15]: data
> 1: [16..23]: unwritten
> 2: [24..39]: data
> [root@localhost PROGS]#
> The above output seems as per the tests commands issue. Please correct me
> if i am wrong.
> If this correct, then for the test case we need to change 252.out file.
>
> Thanks & Regards,
> Amit Sahrawat
>
>
>
>
>
>

--0016364c62a1e1b39c04a64ab68a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Dear All,</div><div><strong></strong>=A0</div><div><strong>Test Case:1=
3<br></strong>=A0=A0=A0=A0=A0=A0=A0 echo &quot;=A0 13. data -&gt; unwritten=
 -&gt; data&quot;<br>=A0=A0=A0=A0=A0=A0=A0 rm -f $testfile<br>=A0=A0=A0=A0=
=A0=A0=A0 $XFS_IO_PROG $xfs_io_opt -f -c &quot;truncate 20k&quot; \<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -c &quot;$alloc_cmd 0 20k&quo=
t; \<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -c &quot;pwrite 0k 8k=
&quot; -c &quot;fsync&quot; \<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 -c &quot;pwrite 12k 8k&quot; -c &quot;fsync&quot; \<br>=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -c &quot;$zero_cmd 4k 12k&quot; \<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 -c &quot;$map_cmd -v&quot; $t=
estfile | $filter_cmd<br>=A0=A0=A0=A0=A0=A0=A0 [ $? -ne 0 ] &amp;&amp; die_=
now=A0=A0=A0=A0=A0=A0=A0 </div><p><strong>After executing individual case l=
ike this:<br></strong>testfile=3D/data/usb/sda3/252.testfile</p>
<p>echo &quot;13. data -&gt; unwritten -&gt; data&quot;<br>rm -f $testfile<=
br>xfs_io -f -c &quot;truncate 20k&quot; -c \<br>&quot;falloc 0 20k&quot; -=
c &quot;pwrite 0k 8k&quot; -c &quot;fsync&quot; -c &quot;pwrite 12k 8k&quot=
; -c =A0\<br>
&quot;fsync&quot; -c &quot;fpunch 4k 12k&quot; -c &quot;fiemap -v&quot; $te=
stfile | $filter_cmd</p><p><strong>Original Output(Taken from 252.out):<br>=
</strong>=A0=A0=A0=A0=A0=A0=A0 13. data -&gt; unwritten -&gt; data<br>0: [0=
..7]: data<br>
1: [8..31]: hole<br>2: [32..39]: data</p><div><strong>Output in my case</st=
rong><br>=A0 13. data -&gt; unwritten -&gt; data<br>0: [0..15]: data<br>1: =
[16..23]: unwritten<br>2: [24..39]: data<br><br>Please let me know about th=
e vailidity of this result. </div>
<div>=A0</div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat<br></div><=
div class=3D"gmail_quote">On Wed, Jun 22, 2011 at 3:54 PM, Amit Sahrawat <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:amit.sahrawat83@gmail.com">amit.sahra=
wat83@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-l=
eft-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style: s=
olid;" class=3D"gmail_quote"><div>While executing Test case no: 252 from xf=
stestsuites - I got Output mismatch.</div>
<div>=A0</div><div><strong>Environment tried:</strong></div><div><strong>X8=
6 : Linux version 2.6.31.5-127.fc12.i686.PAE</strong></div><div>
<strong>ARM: Linux version2.6.35.13</strong></div><div>=A0</div><div>On loo=
king at the test case and then dividing the total case into invidual test&#=
39;s I could somehow correlate the results as per the commands issues.</div=
>

<div>Complete output for the &#39;13&#39; commands in this case is as given=
 below:</div><div>=A0</div><div>[root@localhost PROGS]# sh cmd.sh <br>=A0 1=
. into a hole<br>0: [0..7]: hole<br>1: [8..23]: unwritten<br>2: [24..39]: h=
ole<br>

=A0 2. into allocated space<br>0: [0..39]: data<br>=A0 3. into unwritten sp=
ace<br>0: [0..39]: unwritten<br>=A0 4. hole -&gt; data<br>0: [0..7]: hole<b=
r>1: [8..15]: unwritten<br>2: [16..31]: data<br>3: [32..39]: hole<br>=A0 5.=
 hole -&gt; unwritten<br>

0: [0..7]: hole<br>1: [8..15]: unwritten<br>2: [16..31]: unwritten<br>3: [3=
2..39]: hole<br>=A0 6. data -&gt; hole<br>0: [0..15]: data<br>1: [16..23]: =
unwritten<br>2: [24..39]: hole<br>=A0 7. data -&gt; unwritten<br>0: [0..15]=
: data<br>

1: [16..31]: unwritten<br>2: [32..39]: hole<br>=A0 8. unwritten -&gt; hole<=
br>0: [0..23]: unwritten<br>1: [24..39]: hole<br>=A0 9. unwritten -&gt; dat=
a<br>0: [0..15]: unwritten<br>1: [16..31]: data<br>2: [32..39]: hole<br>=A0=
 10. hole -&gt; data -&gt; hole<br>

0: [0..7]: hole<br>1: [8..15]: unwritten<br>2: [16..23]: data<br>3: [24..31=
]: unwritten<br>4: [32..39]: hole<br>=A0 11. data -&gt; hole -&gt; data<br>=
0: [0..15]: data<br>1: [16..23]: unwritten<br>2: [24..39]: data<br>=A0 12. =
unwritten -&gt; data -&gt; unwritten<br>

0: [0..15]: unwritten<br>1: [16..23]: data<br>2: [24..39]: unwritten<br>=A0=
 13. data -&gt; unwritten -&gt; data<br>0: [0..15]: data<br>1: [16..23]: un=
written<br>2: [24..39]: data<br>[root@localhost PROGS]# </div><div>The abov=
e output seems as per the tests commands issue. Please correct me if i am w=
rong.</div>

<div>If this correct, then for the test case we need to change 252.out file=
.</div><div>=A0</div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat</di=
v><font color=3D"#888888"><div>=A0</div><div>=A0</div><div>=A0</div><div>=
=A0</div>
<div>=A0</div>
</font></blockquote></div><br>

--0016364c62a1e1b39c04a64ab68a--


--===============5262621147711196396==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5262621147711196396==--
