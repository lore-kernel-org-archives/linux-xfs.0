Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U3Nu78124840 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:23:57 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC8F1278E07
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:26:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5gqsxt4viD5N2mqy
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 20:26:01 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id CE35F6C248
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 22:26:00 -0500 (CDT)
Message-ID: <4BDA4DC8.6020408@hardwarefreak.com>
Date: Thu, 29 Apr 2010 22:26:00 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list
	too	long
References: <i2hdb2d1ee61004291707k9ffebed2k4ff6eb72354cbe63@mail.gmail.com>
	<p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
In-Reply-To: <p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

James Braid put forth on 4/29/2010 7:41 PM:

>> OS/Kernel Info:
>> Debian Lenny
>> Linux bigmama 2.6.30-2-686-bigmem #1 SMP Sat Sep 26 02:30:18 UTC 2009
>> i686 GNU/Linux
> 
> Filesystems >16TB aren't supported on 32-bit machines - it looks like
> your growfs is going to exceed that limit. Time to upgrade! ;)

Benjamin Lau put forth on 4/29/2010 7:07 PM:

> flags		: fpu vme de pse tsc msr pae mce cx8 apic
> sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr
> sse sse2 ss ht tm pbe nx *lm*

You're in luck Ben.  That trailing "lm" flag stands for "long mode" which is
the x86-64 native 64 bit mode.  Your Xeon appears to be a 64 bit CPU.  It
looks like the Nacona core from around 2004.  It's a netburst model (yuck)
with Intel64 extensions.

This is good news.  Fixing this max 16TB problem should be as simple as
rolling a new kernel with a few different settings and installing it if
you're a roll your own kernel kinda guy.

Run make menuconfig and:
1.  Select the Opteron/.../K8 cpu type
2.  Set high memory support to off
3.  Uncheck PAE
4.  Save and exit
5.  You know the rest of the steps if you roll your own

That should be all that's required to solve your issue.  You can leave your
user space as 32 bit if/until you're ready to do a dist upgrade to a 64 bit
user space.

Or you could just aptitude install one of the 64 bit Lenny kernels from the
mirrors.  That would be quicker, though not necessarily better.  I can't
tell exactly from your post which camp you fall into, though it looks like
the roll your own camp.

Hope this helps.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
