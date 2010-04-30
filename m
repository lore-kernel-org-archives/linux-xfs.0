Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U4XInY127549 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 23:33:18 -0500
Received: from mail-iw0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AF831AFDA9A
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 21:35:23 -0700 (PDT)
Received: from mail-iw0-f193.google.com (mail-iw0-f193.google.com
	[209.85.223.193]) by cuda.sgi.com with ESMTP id
	JTLZ02L4GXkNryN1 for <xfs@oss.sgi.com>;
	Thu, 29 Apr 2010 21:35:23 -0700 (PDT)
Received: by iwn31 with SMTP id 31so9573978iwn.30
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 21:35:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDA4DC8.6020408@hardwarefreak.com>
References: <i2hdb2d1ee61004291707k9ffebed2k4ff6eb72354cbe63@mail.gmail.com>
	<p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
	<4BDA4DC8.6020408@hardwarefreak.com>
Date: Thu, 29 Apr 2010 21:34:30 -0700
Message-ID: <m2udb2d1ee61004292134w8ca69b3cv9bf1b437dcef6531@mail.gmail.com>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too
	long
From: Benjamin Lau <benjamin.a.lau@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Definitely in the roll my own camp though I try to avoid it on my
machines at the office (but I have no problem with it for my own
systems at home... which is where this server lives).

I'll give this a try and see how it goes.

Thanks!

Ben

On Thu, Apr 29, 2010 at 8:26 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> James Braid put forth on 4/29/2010 7:41 PM:
>
>>> OS/Kernel Info:
>>> Debian Lenny
>>> Linux bigmama 2.6.30-2-686-bigmem #1 SMP Sat Sep 26 02:30:18 UTC 2009
>>> i686 GNU/Linux
>>
>> Filesystems >16TB aren't supported on 32-bit machines - it looks like
>> your growfs is going to exceed that limit. Time to upgrade! ;)
>
> Benjamin Lau put forth on 4/29/2010 7:07 PM:
>
>> flags =A0 =A0 =A0 =A0 : fpu vme de pse tsc msr pae mce cx8 apic
>> sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
>> sse sse2 ss ht tm pbe nx *lm*
>
> You're in luck Ben. =A0That trailing "lm" flag stands for "long mode" whi=
ch is
> the x86-64 native 64 bit mode. =A0Your Xeon appears to be a 64 bit CPU. =
=A0It
> looks like the Nacona core from around 2004. =A0It's a netburst model (yu=
ck)
> with Intel64 extensions.
>
> This is good news. =A0Fixing this max 16TB problem should be as simple as
> rolling a new kernel with a few different settings and installing it if
> you're a roll your own kernel kinda guy.
>
> Run make menuconfig and:
> 1. =A0Select the Opteron/.../K8 cpu type
> 2. =A0Set high memory support to off
> 3. =A0Uncheck PAE
> 4. =A0Save and exit
> 5. =A0You know the rest of the steps if you roll your own
>
> That should be all that's required to solve your issue. =A0You can leave =
your
> user space as 32 bit if/until you're ready to do a dist upgrade to a 64 b=
it
> user space.
>
> Or you could just aptitude install one of the 64 bit Lenny kernels from t=
he
> mirrors. =A0That would be quicker, though not necessarily better. =A0I ca=
n't
> tell exactly from your post which camp you fall into, though it looks like
> the roll your own camp.
>
> Hope this helps.
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
