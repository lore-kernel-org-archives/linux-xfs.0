Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 12:09:34 -0700 (PDT)
Received: from mail.ukfsn.org (s2.ukfsn.org [217.158.120.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58J9TWt001590
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 12:09:30 -0700
Message-ID: <4669A965.20403@dgreaves.com>
Date: Fri, 08 Jun 2007 20:09:25 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
References: <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070607222813.GG85884050@sgi.com>
In-Reply-To: <20070607222813.GG85884050@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

I had this as a PS, then I thought, we could all be wasting our time...

I don't like these "Section mismatch" warnings but that's because I'm paranoid 
rather than because I know what they mean. I'll be happier when someone says 
"That's OK, I know about them, they're not the problem"

WARNING: arch/i386/kernel/built-in.o(.text+0x968f): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9781): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9786): Section mismatch: reference 
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xa25c): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa303): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa31b): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa344): Section mismatch: reference 
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x19): Section mismatch: 
reference to .init.text: (between 'cache_remove_dev' and 'powernow_k6_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0x2160): Section mismatch: reference 
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
WARNING: kernel/built-in.o(.text+0x14502): Section mismatch: reference to 
.init.text: (between 'kthreadd' and 'init_waitqueue_head')


Andrew Morton said a couple of weeks ago:
 > Could the people who write these bugs, please, like, fix them?
 > It's not trivial noise.  These things lead to kernel crashes.

Anyhow...

David Chinner wrote:
> sync just guarantees that metadata changes are logged and data is
> on disk - it doesn't stop the filesystem from doing anything after
> the sync...
No, but there are no apps accessing the filesystem. It's just available for NFS 
serving. Seems safer before potentially hanging the machine?


Also I made these changes to the kernel:
cu:/boot# diff config-2.6.22-rc4-TejuTst-dbg3-dirty 
config-2.6.22-rc4-TejuTst-dbg1-dirty
3,4c3,4
< # Linux kernel version: 2.6.22-rc4-TejuTst-dbg3
< # Thu Jun  7 20:00:34 2007
---
 > # Linux kernel version: 2.6.22-rc4-TejuTst3
 > # Thu Jun  7 10:59:21 2007
242,244c242
< CONFIG_PM_DEBUG=y
< CONFIG_DISABLE_CONSOLE_SUSPEND=y
< # CONFIG_PM_TRACE is not set
---
 > # CONFIG_PM_DEBUG is not set

positive: I can now get sysrq-t :)
negative: if I build skge into the kernel the behaviour changes so I can't run 
netconsole

Just to be sure I tested and this kernel suspends/restores with /huge unmounted.
It also hangs without an umount so the behaviour is the same.

> Ok, so a clean inode is sufficient to prevent hibernate from working.
> 
> So, what's different between a sync and a remount?
> 
> do_remount_sb() does:
> 
>     599         shrink_dcache_sb(sb);
>     600         fsync_super(sb);
> 
> of which a sync does neither. sync does what fsync_super() does in
> different sort of way, but does not call sync_blockdev() on each
> block device. It looks like that is the two main differences between
> sync and remount - remount trims the dentry cache and syncs the blockdev,
> sync doesn't.
> 
>>> What about freezing the filesystem?
>> cu:~# xfs_freeze -f /huge
>> cu:~# /usr/net/bin/hibernate
>> [but this doesn't even hibernate - same as the 'touch']
> 
> I suspect that the frozen filesystem might cause other problems
> in the hibernate process. However, while a freeze calls sync_blockdev()
> it does not trim the dentry cache.....
> 
> So, rather than a remount before hibernate, lets see if we can 
> remove the dentries some other way to determine if removing excess
> dentries/inodes from the caches makes a difference. Can you do:
> 
> # touch /huge/foo
> # sync
> # echo 1 > /proc/sys/vm/drop_caches
> # hibernate
success
> 
> # touch /huge/bar
> # sync
> # echo 2 > /proc/sys/vm/drop_caches
> # hibernate
success
> 
> # touch /huge/baz
> # sync
> # echo 3 > /proc/sys/vm/drop_caches
> # hibernate
success

So I added
# touch /huge/bork
# sync
# hibernate

And it still succeeded - sigh.

So I thought a bit and did:
rm /huge/b* /huge/foo

 > Clean boot
 > # touch /huge/bar
 > # sync
 > # echo 2 > /proc/sys/vm/drop_caches
 > # hibernate
hangs on suspend (sysrq-b doesn't work)

 > Clean boot
 > # touch /huge/baz
 > # sync
 > # echo 3 > /proc/sys/vm/drop_caches
 > # hibernate
hangs on suspend (sysrq-b doesn't work)

So I rebooted and hibernated to make sure I'm not having random behaviour - yep, 
hang on resume (as per usual).

Now I wonder if any other mounts have an effect...
reboot and umount /dev/hdb2 xfs fs, - hang on hibernate


I'm confused. I'm going to order chinese takeaway and then find a serial cable...

David
PS 2.6.21.1 works fine.
