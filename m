Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29AC429E0E
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 09:31:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87C0BAC003
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 07:31:19 -0700 (PDT)
Received: from mail-vc0-f178.google.com (mail-vc0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	nriY6qUnbCAohBq2 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 07:31:17 -0700 (PDT)
Received: by mail-vc0-f178.google.com with SMTP id hv10so418689vcb.23
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 07:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <516574AD.7060706@sgi.com>
References: <51656D47.9010806@gmail.com> <516571CA.1020908@gmail.com>
	<516574AD.7060706@sgi.com>
Date: Wed, 10 Apr 2013 10:31:17 -0400
Message-ID: <CAJzLF9kHyj6i6n=i97Pcr6yZvKTm9z5kn1XA0bDmYuLHudi8_g@mail.gmail.com>
Subject: Re: New xfstests generic/308 causes XFS hang (high CPU use), at least
	on 32-bit
From: "Michael L. Semon" <mlsemon35@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8590475174643611312=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============8590475174643611312==
Content-Type: multipart/alternative; boundary=047d7b3a8cd0dcf3a704da02850b

--047d7b3a8cd0dcf3a704da02850b
Content-Type: text/plain; charset=ISO-8859-1

On casual glance, it looks like a test meant to test the end of 32-bit
offsets, built to test a specific ext4 case, and it happened to strafe XFS
on 32-bit in the process.  It is unknown to me whether a script with 64-bit
version of the numbers would have a bad effect.

Michael


On Wed, Apr 10, 2013 at 10:18 AM, Rich Johnston <rjohnston@sgi.com> wrote:

> On 04/10/2013 09:06 AM, Michael L. Semon wrote:
>
>> On 04/10/2013 09:46 AM, Michael L. Semon wrote:
>>
>>  The PC uses kernel 3.8-rc4 + Dave's CRC v4 patches + J. Liu's bitness
>>> patch.
>>>
>>
>> Oops, that was supposed to be "kernel 3.9-rc4."  Sorry.
>>
>> Michael
>>
>> ______________________________**_________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/**listinfo/xfs<http://oss.sgi.com/mailman/listinfo/xfs>
>>
>
> Runs fine on all my 64 bit machines.  I quickly ran a test using
> 3.9.0-rc1+ on a 32 bit machine.  I am seeing the same xfs_io 100% CPU usage.
>
> Looks 32 bit specific.
>
> --Rich
>
>

--047d7b3a8cd0dcf3a704da02850b
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>On casual glance, it looks like a test meant to test =
the end of 32-bit offsets, built to test a specific ext4 case, and it happe=
ned to strafe XFS on 32-bit in the process.=A0 It is unknown to me whether =
a script with 64-bit version of the numbers would have a bad effect.<br>
<br></div><div>Michael<br></div></div><div class=3D"gmail_extra"><br><br><d=
iv class=3D"gmail_quote">On Wed, Apr 10, 2013 at 10:18 AM, Rich Johnston <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:rjohnston@sgi.com" target=3D"_blank">=
rjohnston@sgi.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">On 04/10/2013 09:06 AM, Michael L. Semon wro=
te:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 04/10/2013 09:46 AM, Michael L. Semon wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
The PC uses kernel 3.8-rc4 + Dave&#39;s CRC v4 patches + J. Liu&#39;s bitne=
ss<br>
patch.<br>
</blockquote>
<br>
Oops, that was supposed to be &quot;kernel 3.9-rc4.&quot; =A0Sorry.<br>
<br>
Michael<br>
<br>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</blockquote>
<br>
Runs fine on all my 64 bit machines. =A0I quickly ran a test using 3.9.0-rc=
1+ on a 32 bit machine. =A0I am seeing the same xfs_io 100% CPU usage.<br>
<br>
Looks 32 bit specific.<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
--Rich<br>
<br>
</font></span></blockquote></div><br></div>

--047d7b3a8cd0dcf3a704da02850b--


--===============8590475174643611312==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8590475174643611312==--
