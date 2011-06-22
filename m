Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MAOVZl076267 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 05:24:32 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AD4BDF4EE5
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:24:29 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id AgxEwZPEZGkPnAZs
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:24:29 -0700 (PDT)
Received: by ewy8 with SMTP id 8so200984ewy.26
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 03:24:29 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Jun 2011 15:54:28 +0530
Message-ID: <BANLkTinBNa9ox+jDaorBoKdhoQQzTUA58A@mail.gmail.com>
Subject: XFS Test Case:252 - Shows Wrong Output
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7739822467443922252=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7739822467443922252==
Content-Type: multipart/alternative; boundary=0016364c6ecf9f38ce04a64a5f98

--0016364c6ecf9f38ce04a64a5f98
Content-Type: text/plain; charset=ISO-8859-1

While executing Test case no: 252 from xfstestsuites - I got Output
mismatch.

*Environment tried:*
*X86 : Linux version 2.6.31.5-127.fc12.i686.PAE*
*ARM: Linux version2.6.35.13*

On looking at the test case and then dividing the total case into invidual
test's I could somehow correlate the results as per the commands issues.
Complete output for the '13' commands in this case is as given below:

[root@localhost PROGS]# sh cmd.sh
  1. into a hole
0: [0..7]: hole
1: [8..23]: unwritten
2: [24..39]: hole
  2. into allocated space
0: [0..39]: data
  3. into unwritten space
0: [0..39]: unwritten
  4. hole -> data
0: [0..7]: hole
1: [8..15]: unwritten
2: [16..31]: data
3: [32..39]: hole
  5. hole -> unwritten
0: [0..7]: hole
1: [8..15]: unwritten
2: [16..31]: unwritten
3: [32..39]: hole
  6. data -> hole
0: [0..15]: data
1: [16..23]: unwritten
2: [24..39]: hole
  7. data -> unwritten
0: [0..15]: data
1: [16..31]: unwritten
2: [32..39]: hole
  8. unwritten -> hole
0: [0..23]: unwritten
1: [24..39]: hole
  9. unwritten -> data
0: [0..15]: unwritten
1: [16..31]: data
2: [32..39]: hole
  10. hole -> data -> hole
0: [0..7]: hole
1: [8..15]: unwritten
2: [16..23]: data
3: [24..31]: unwritten
4: [32..39]: hole
  11. data -> hole -> data
0: [0..15]: data
1: [16..23]: unwritten
2: [24..39]: data
  12. unwritten -> data -> unwritten
0: [0..15]: unwritten
1: [16..23]: data
2: [24..39]: unwritten
  13. data -> unwritten -> data
0: [0..15]: data
1: [16..23]: unwritten
2: [24..39]: data
[root@localhost PROGS]#
The above output seems as per the tests commands issue. Please correct me if
i am wrong.
If this correct, then for the test case we need to change 252.out file.

Thanks & Regards,
Amit Sahrawat

--0016364c6ecf9f38ce04a64a5f98
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>While executing Test case no: 252 from xfstestsuites - I got Output mi=
smatch.</div><div>=A0</div><div><strong>Environment tried:</strong></div><d=
iv><strong>X86 : Linux version 2.6.31.5-127.fc12.i686.PAE</strong></div><di=
v>
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
v><div>=A0</div><div>=A0</div><div>=A0</div><div>=A0</div><div>=A0</div>

--0016364c6ecf9f38ce04a64a5f98--


--===============7739822467443922252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7739822467443922252==--
