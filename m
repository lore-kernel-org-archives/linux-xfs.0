Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 415337F37
	for <xfs@oss.sgi.com>; Mon, 27 May 2013 00:36:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0DC7AC004
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 22:36:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WRM9xbt2MVRYhZt4 for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 22:36:13 -0700 (PDT)
Date: Mon, 27 May 2013 15:36:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.3: Oops running xfstests
Message-ID: <20130527053608.GS29466@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <986348673.5787542.1369385526612.JavaMail.root@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: CAI Qian <caiqian@redhat.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Fri, May 24, 2013 at 04:52:06AM -0400, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Dave Chinner" <david@fromorbit.com>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: xfs@oss.sgi.com, stable@vger.kernel.org
> > Sent: Thursday, May 23, 2013 11:51:15 AM
> > Subject: Re: 3.9.3: Oops running xfstests
> > 
> > On Wed, May 22, 2013 at 11:21:17PM -0400, CAI Qian wrote:
> > > Fedora-19 based distro and LVM partitions.
> > 
> > Cai: As I've asked previously please include all the relevant
> > information about your test system and the workload it is running
> > when the problem occurs.  Stack traces aren't any good to us in
> > isolation, and just dumping them on us causes unnecessary round
> > trips.
> > 
> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> Sometimes, those information is going to drive me crazy due to the
> amount of information need to gather from a system that been already
> returned to the automation testing system pool and I never have access
> to it anymore.

So automate the collection of all the static information.

> Some of the information has like very little percentage
> of the relevant as far as I can tell. I knew sometimes that 1% percentage
> does count but the amount of efforts need to gather that 1% just crazy. :)

It answers basic questions about your system:
	- how many CPUs
	- how much RAM
	- kernel version, userspace xfs utilities version
	- mount option
	- filesystem size
	- filesystem configuration
	- storage configuration
	- storage hardware
	- error messages that are occurring.

Whether you consider that irrelevant information doesn't matter.
They fact is that it is basic information that *we need* to
understand what your environment is that reproduced the problem. If
you don't supply that information, we can't even begin to triage the
problem.

> Since we have been in the same company, feel free to ping me and I can
> give you the instruction to access the system and reproducer for it. Also,

I don't scale to manually gathering information from every
person that reports a problem. My time is far better spent reviewing
information and asking for more than it is gathering information.

> I have been reproduced this on several x64 systems and nothing special

"nothing special". You say that a lot. You are giving you opinion
abou tyour hardware, leaving me with no information to determine
whether there is anything special about myself. I don't want your
opinion - I want *data*.

> I will provide the information as far I knew for now.
> - kernel version (uname -a): 3.9.3
> - xfsprogs version (xfs_repair -V): Fedora-19 xfsprogs-3.1.10
> - number of CPUs: 8

What type of CPUs? That's why we ask for /proc/cpuinfo....

> - contents of /proc/mounts: nothing special. Just Fedora-19 autopart

What are the contents?

> - contents of /proc/partitions: nothing special. Just Fedora-19 autopart

Contents, please.

> - RAID layout (hardware and/or software):
> Nothing special,

You say nothing special. I see:

> 06:21:51,812 INFO kernel:[   27.480775] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x500000e0130ddbe2
> 06:21:51,812 NOTICE kernel:[   27.539634] scsi 0:0:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
> 06:21:51,812 INFO kernel:[   27.592421] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x500000e0130fa8f2
> 06:21:51,812 NOTICE kernel:[   27.651334] scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5

Hardware RAID of some kind. So, details, please. Indeed, googling
for "IBM-ESXS MAY2073RC" turns up this lovely link:

http://webcache.googleusercontent.com/search?client=safari&rls=x86_64&q=cache:dD2J_ZuKGF4J:http://www.ibm.com/support/entry/portal/docdisplay%3Flndocid%3DMIGR-5078767%2BIBM-ESXS+MAY2073RC&oe=UTF-8&redir_esc=&hl=en&ct=clnk

	"Corrects firmware defect that can cause data corruption"

http://www-947.ibm.com/support/entry/portal/docdisplay?lndocid=MIGR-5092677

	"Additional Information
	A subset of optional IBM Options hard drive shipped between April
	2010 and January 2013 running firmware levels A3C2, A3C0, A3BE, or
	A3B8 may be exposed to a possible undetected data loss or data error
	during a proximal write."


That might be relevant to a filesystem corruption problem, yes?
Start to understand why we ask for basic information about your
hardware now?

> - LVM configuration: nothing special. Just Fedora-19 autopart. The below information
>   from the installation time. Later, everything been formatted to XFS.

Manually?

>   name = vg_ibmls4102-lv_root  status = True  kids = 0 id = 7
>   parents = ['existing 139508MB lvmvg vg_ibmls4102 (3)']
>   uuid = wVn1JV-DQ4U-vXHD-liJi-kX0M-O6eA-geU4gs  size = 51200.0
>   format = existing ext4 filesystem
>   major = 0  minor = 0  exists = True  protected = False
>   sysfs path = /devices/virtual/block/dm-1  partedDevice = parted.Device instance --
>   model: Linux device-mapper (linear)  path: /dev/mapper/vg_ibmls4102-lv_root  type: 12
.....

Ugh. That's unreadable.....

>   PVs = ['existing 69505MB partition sda2 (2) with existing lvmpv',
>  'existing 70005MB partition sdb1 (5) with existing lvmpv']
>   LVs = ['existing 71028MB lvmlv vg_ibmls4102-lv_home (6) with existing ext4 filesystem',
>  'existing 51200MB lvmlv vg_ibmls4102-lv_root (7) with existing ext4 filesystem',
>  'existing 17280MB lvmlv vg_ibmls4102-lv_swap (8) with existing swap']

But what I see here is that there are partitions and LVM, and
everything is using ext4. That's not useful to me. What I'm after is
the output of pvdisplay, vgdisplay and lvdisplay. That's not very
hard...

> - type of disks you are using: nothing special

Do you really think they are nothing special now after reading the
above information?

> - write cache status of drives: missed; need to reprovision the system.
> - size of BBWC and mode it is running in: missed; need to reprovision the system.
> - xfs_info output on the filesystem in question: missed; need to reprovision the system.
> - dmesg output showing all error messages and stack traces:
>   http://people.redhat.com/qcai/stable/console.txt

Looking at dmesg output (next time, please, just dmesg) there's been
kernel modules bounced in and out of the kernel so all the kernel
modules are force loaded. You've run trinity on this system for at
least several hours before running other tests, which has left
who-knows what mess behind in memory.  It's been OOMed at least 15
times and it's been up and running under test workloads for over 24
hours before I see the first XFS filesystem get mounted.

The PID that has tripped over the attribute problem is called "comm"
which means it is unrelated to xfstests. And in processing the oops,
a pair of slab corruptions in the DRM subsystem is detected, which
kind of points at large scale memory corruption unrelated to XFS.

That's most likely, because I've already pointed out memory
corruption way outside XFS is occurring:

> > > =============================================================================
> > > [  304.898489] BUG kmalloc-4096 (Tainted: G      D     ): Padding
> > > overwritten. 0xffff8801fbeb7c28-0xffff8801fbeb7fff
> > > [  304.898490]
> > > -----------------------------------------------------------------------------
> > > [  304.898490]
> > > [  304.898491] INFO: Slab 0xffffea0007efac00 objects=7 used=7 fp=0x
> > > (null) flags=0x20000000004080
> > > [  304.898492] Pid: 357, comm: systemd-udevd Tainted: G    B D      3.9.3
> > > #1
> > > [  304.898492] Call Trace:
> > > [  304.898495]  [<ffffffff81181ed2>] slab_err+0xc2/0xf0
> > > [  304.898497]  [<ffffffff8118176d>] ? init_object+0x3d/0x70
> > > [  304.898498]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170
> > > [  304.898500]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0
> > > [  304.898501]  [<ffffffff811820e3>] check_slab+0x73/0x100
> > > [  304.898503]  [<ffffffff81606b50>] alloc_debug_processing+0x21/0x118
> > > [  304.898504]  [<ffffffff8160772f>] __slab_alloc+0x3b8/0x4a2
> > > [  304.898506]  [<ffffffff81161b57>] ? vma_link+0xb7/0xc0
> > > [  304.898508]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0
> > > [  304.898509]  [<ffffffff81184dd1>] kmem_cache_alloc_trace+0x1b1/0x200
> > > [  304.898510]  [<ffffffff811bda63>] seq_read+0x2e3/0x3b0
> > > [  304.898512]  [<ffffffff8119c56c>] vfs_read+0x9c/0x170
> > > [  304.898513]  [<ffffffff8119c939>] sys_read+0x49/0xa0
> > > [  304.898514]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b
> > 
> > That's something different, and indicates memory corruption is being
> > seen as a result of something that is occuring through the /proc or
> > /sys filesystems. Unrelated to XFS, I think...

So, can you reproduce this problem on a clean, *pristine* system
that hasn't been used for destructive testing for 24 hours prior to
running xfstests?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
