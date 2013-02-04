Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3344B7F52
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 19:49:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A352BAC001
	for <xfs@oss.sgi.com>; Sun,  3 Feb 2013 17:49:49 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id aEyAC17fYNneq4I8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Feb 2013 17:49:48 -0800 (PST)
Message-ID: <510F13AF.1020106@tlinx.org>
Date: Sun, 03 Feb 2013 17:49:35 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfsdump showing system problems -- ?  ideas?
References: <510DDE61.6060005@tlinx.org> <20130203231706.GJ2667@dastard>
In-Reply-To: <20130203231706.GJ2667@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> Was fixed in 3.4:
> 
> $ gl -n 1 ad650f5
> commit ad650f5b27bc9858360b42aaa0d9204d16115316
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Mar 7 04:50:21 2012 +0000
> 
>     xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get
>     
>     xfsdump uses for a large buffer for extended attributes, which has a
>     kmalloc'd shadow buffer in the kernel. This can fail after the
>     system has been running for some time as it is a high order
>     allocation. Add a fallback to vmalloc so that it doesn't require
>     contiguous memory and so won't randomly fail while xfsdump is
>     running.
----

AWESOME!!!!!

Thank-you! Thank-you! Thank-you!!!....


I would have been trying all sorts of random things to figure out
what I had messed up!...

==================
Note to Stan:

I was right with ya!.... I felt sketchy about that module..
even though I wasn't using it, and wasn't even loaded, it
got loaded at boot (for Oracle's 'vm' implementation) which
contaminated things.

As for my misconfiguring... was gonna say it was not impossible.
While I've been rolling my own for over a decade, things just get
more and more complicated as time goes on and sometimes I really don't
know what I am doing -- I guess -- usually it ends up with drivers
that "do nothing", though at worst, I could end up with a non-booting
kernel (rare, but non-booting system happening alot more often since
Suse has moved to systemd and started putting needed boot utils in a
non-root partition (/usr is separate on my system).  They tell me either
move /usr to root, or they expect their users to be booting from an initrd.

(which I don't -- my boot HW is builtin to my kernel).
Things I wanna try out, or think I "might" use, I build as
modules:

Right now (some of these probably could or should be builtin, but the system
boots w/out them), have:
# lsmod
Module                  Size  Used by
sch_sfq                10080  3
sch_htb                15123  1
mousedev               11440  1
acpi_cpufreq            7577  1
mperf                   1348  1 acpi_cpufreq
processor              35852  1 acpi_cpufreq
---
but if I type modprobe and press complete (and have my complete
facility loaded), it asks me if I want to display all 342 possibilities.
Probably most of that is network related depending on how I want to
config things (nat/firewall/routing/shaping...none of which I usually
run all the time, so their all mods)...

But I know I have some mods on there that do nothing on my HW, but
I've had a few that didn't at first, but then with tweaks in the BIOS
or kernel updates, started getting used.

So wanted to let you know -- I appreciated the pointers -- I didn't
reject any of them...


But in this case THANK YOU DAVE!!!!

(that's why I post random symptoms sometimes --- on the minuscule hope
that someone might have seen it (or better, has already put in a fix for
it!)....



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
