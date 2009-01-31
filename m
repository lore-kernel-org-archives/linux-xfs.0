Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0VHcNTw116263 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 11:38:23 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9945189F682
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 09:37:40 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id 81urDOpiEeAE1U2Q for
	<xfs@oss.sgi.com>; Sat, 31 Jan 2009 09:37:40 -0800 (PST)
Date: Sat, 31 Jan 2009 12:37:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.28: All I/O, D-state: 3ware
 9650SE-16ML/Intel/965/MTRR/PAT?
In-Reply-To: <alpine.DEB.1.10.0901310523480.29879@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0901311230510.4472@p34.internal.lan>
References: <alpine.DEB.1.10.0901310523480.29879@p34.internal.lan>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, Alan Piszcz <ap@solarrain.com>, xfs@oss.sgi.com

I think it was a coincidence when I tried to login before, I tried it 
again (after trying to re-produce the problem, which I had been able to 
do) and this time the mouse worked but the keyboard did not..even running
echo b > sysrq-trigger did not reboot the server..  Had to resort to 
manual method.

I am now on kernel 2.6.28.2 and will see if I can make it happen again.

Here are the relevant traces:
http://home.comcast.net/~jpiszcz/20090131/stacktrace-cpus.txt
http://home.comcast.net/~jpiszcz/20090131/sysrq-trigger-m.txt
http://home.comcast.net/~jpiszcz/20090131/sysrq-trigger-t.txt
http://home.comcast.net/~jpiszcz/20090131/sysrq-trigger-w.txt
http://home.comcast.net/~jpiszcz/20090131/sysrq-t.txt
http://home.comcast.net/~jpiszcz/20090131/xfs.txt

The stacktace for each CPU is interesting, see below, XFS related(?)

Can anyone offer any suggestions on what to look for or how to debug this
further?

$ df -i
/dev/sda1            2539035008 1571332 2537463676    1% /r1

Should I be mounting with -o inode64?

/dev/sda1 on /r1 type xfs (rw,noatime,nobarrier,logbufs=8,logbsize=262144)

[2604823.699927] SysRq : Show backtrace of all active CPUs
[2604823.699993] CPU0:
[2604823.699996]  ffffffff807d8f38 0000000000000046 ffff880228b516e8 0000000000000000
[2604823.700000]  ffff8801f4f93588 000000000000000e ffff8801a8843e98 ffffffff8046ff72
[2604823.700000]  ffff880228b516c0 ffffffff80272a8c ffff8801f4f935a8 ffff8801f4f93450
[2604823.700000] Call Trace:
[2604823.700000]  <IRQ>  [<ffffffff8046ff72>] showacpu+0x42/0x60
[2604823.700000]  [<ffffffff80272a8c>] generic_smp_call_function_interrupt+0x4c/0xf0
[2604823.700000]  [<ffffffff8023855f>] smp_call_function_interrupt+0x1f/0x40
[2604823.700000]  [<ffffffff8022a3bb>] call_function_interrupt+0x6b/0x70
[2604823.700000]  <EOI>  [<ffffffff802790d6>] find_get_pages+0x56/0xf0
[2604823.700000]  [<ffffffff802790b4>] find_get_pages+0x34/0xf0
[2604823.700000]  [<ffffffff80281cd7>] pagevec_lookup+0x17/0x20
[2604823.700000]  [<ffffffff803e8459>] xfs_cluster_write+0x99/0x170
[2604823.700000]  [<ffffffff803e8bdb>] xfs_page_state_convert+0x52b/0x6d0
[2604823.700000]  [<ffffffff803e9071>] xfs_vm_writepage+0x71/0x130
[2604823.700000]  [<ffffffff802849c0>] shrink_page_list+0x600/0x760
[2604823.700000]  [<ffffffff80284d9f>] shrink_list+0x27f/0x640
[2604823.700000]  [<ffffffff8040c9e1>] __up_write+0x21/0x150
[2604823.700000]  [<ffffffff8028095d>] determine_dirtyable_memory+0xd/0x20
[2604823.700000]  [<ffffffff802809cd>] get_dirty_limits+0x1d/0x290
[2604823.700000]  [<ffffffff803cd468>] xfs_iomap+0x188/0x310
[2604823.700000]  [<ffffffff802853a6>] shrink_zone+0x246/0x340
[2604823.700000]  [<ffffffff802861de>] try_to_free_pages+0x22e/0x390
[2604823.700000]  [<ffffffff80283330>] isolate_pages_global+0x0/0x270
[2604823.700000]  [<ffffffff8027f472>] __alloc_pages_internal+0x212/0x4e0
[2604823.700000]  [<ffffffff80281644>] __do_page_cache_readahead+0xf4/0x240
[2604823.700000]  [<ffffffff80281ae2>] ondemand_readahead+0x172/0x1f0
[2604823.700000]  [<ffffffff8027af39>] generic_file_aio_read+0x329/0x620
[2604823.700000]  [<ffffffff803f08da>] xfs_read+0x12a/0x280
[2604823.700000]  [<ffffffff802a3ed3>] do_sync_read+0xe3/0x130
[2604823.700000]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
[2604823.700000]  [<ffffffff80608577>] thread_return+0x3d/0x5c6
[2604823.700000]  [<ffffffff802a4aa8>] vfs_read+0xc8/0x170
[2604823.700000]  [<ffffffff802a4c53>] sys_read+0x53/0xa0
[2604823.700000]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
[2604823.700089] CPU2:
[2604823.700091]  ffff88022b8d3f38 0000000000000046 ffff880228b516e8 0000000000000002
[2604823.700094]  00007fff4e576050 00007fff4e576048 00007fff4e57605c ffffffff8046ff72
[2604823.700097]  ffff880228b516c0 ffffffff80272a8c 0000000000000000 ffff880100003eb0
[2604823.700099] Call Trace:
[2604823.700101]  <IRQ>  [<ffffffff8046ff72>] showacpu+0x42/0x60
[2604823.700105]  [<ffffffff80272a8c>] generic_smp_call_function_interrupt+0x4c/0xf0
[2604823.700108]  [<ffffffff8023855f>] smp_call_function_interrupt+0x1f/0x40
[2604823.700110]  [<ffffffff8022a3bb>] call_function_interrupt+0x6b/0x70
[2604823.700111]  <EOI>  [<ffffffff8040f426>] copy_user_generic_string+0x36/0x40
[2604823.700116]  [<ffffffff8025a7e2>] sys_rt_sigprocmask+0x62/0x120
[2604823.700119]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
p34:~#


On Sat, 31 Jan 2009, Justin Piszcz wrote:

> I have opened a case with 3ware about this, but I do not believe the 3ware 
> card is at fault, it appears something to do with X or the memory subsystem.
> This is not easily reproducible and does not occur often. Maybe once or twice 
> per month, if that, hopefully someone can make out what is happening in the 
> trace below?
>
> KERNEL:
> # uname -a
> Linux p34.internal.lan 2.6.28 #9 SMP Thu Jan 1 08:07:31 EST 2009 x86_64 
> GNU/Linux
>
> PROBLEM:
> During I/O to the 3ware RAID (at least in the past 3-4 previous cases when it 
> occured), the system stops all I/O to all processes that are have I/O to 
> perform on the 3ware card.  I did a lot of analysis which is shown at the 
> bottom of this e-mail.
>
> ODDITY:
> After all of the diagnostics I did below(!), what ended up "bringing" the 
> system back to life?  I moved the mouse cursor on the local machine (I run X) 
> and it uses the Intel graphics (Intel DG965WH motherboard), once I logged in, 
> the ENTIRE system became responsive again, what the heck!?  All of the 
> processes in D-state were now freed!  I have taken an echo t > 
> /proc/sysrq-trigger, hopefully someone can shed some light on this?  It 
> almost seems like the memory/MTRR(?) is stomping the other memory that is 
> used by the system?
>
> QUESTION: Why??
> At the bottom of this e-mail (and also the 3ware ticket):
> Request:-  31st January 2009 at 2:24
>        Just as I was about to give up, I went to the machine, woke up the 
> screensaver (moved mouse) and logged in and then EVERYTHING started working 
> again??
>
> NOTE:
> After all of this, I re-ran the unrar, it worked fine.  My guess is X is 
> doing
> something very strange with the memory?  I can try running no X for awhile
> and see if that gets rid of the problem?  Is that the recommended course of
> action, are there other things I can try to debug this problem further? Has
> anyone ever seen anything like this?
>
> CONFIG:
> http://home.comcast.net/~jpiszcz/20090131/config-2.6.28.txt
>
> LOGS: (from Xorg.log)
> (II) intel(0): EDID vendor "DEL", prod id 40984
> (II) intel(0): Output VGA connected
> (II) intel(0): Output VGA using initial mode 1680x1050
> (II) intel(0): detected 512 kB GTT.
> (II) intel(0): detected 7676 kB stolen memory. <- Is this of interest?
> (==) intel(0): video overlay key set to 0x101fe
> (==) intel(0): Will not try to enable page flipping
> (==) intel(0): Triple buffering disabled
> (==) intel(0): Intel XvMC decoder disabled
> (==) intel(0): Using gamma correction (1.0, 1.0, 1.0)
> (**) intel(0): Display dimensions: (430, 270) mm
> (**) intel(0): DPI set to (99, 158)
>
> KERNEL OPTIONS: (of interest?):
>  | |    [*] MTRR (Memory Type Range Register) support                    | |
>  | |    [*]   MTRR cleanup support                                       | |
>  | |    (0)     MTRR cleanup enable value (0-1)                          | |
>  | |    (1)     MTRR cleanup spare reg num (0-7)                         | |
>  | |    [*]   x86 PAT support                                            | |
>
> Should I consider disabling MTRR, x86 PAT support or both?  To see if the
> problem recurs? Are there any other kernel options I have enabled that could
> lead to this problem?
>
> LSPCI:
> 00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 
> 02)
> 00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 
> 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated 
> Graphics Controller (rev 02)
> 00:03.0 Communication controller: Intel Corporation 82P965/G965 HECI 
> Controller (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DC Gigabit Network 
> Connection (rev 02)
> 00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
> Controller #4 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
> Controller #5 (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
> Controller #2 (rev 02)
> 00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
> Controller (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
> (rev 02)
> 00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 
> (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 
> (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 4 
> (rev 02)
> 00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
> (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
> Controller #3 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
> Controller #1 (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
> 00:1f.0 ISA bridge: Intel Corporation 82801HH (ICH8DH) LPC Interface 
> Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port 
> SATA AHCI Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
> 02)
> 01:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID (rev 01)
> 03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101 single-port 
> PATA133 interface (rev b1)
> 07:00.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet 
> Controller (rev 02)
> 07:01.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet 
> Controller
>
> INTERRUPTS:
> # cat /proc/interrupts
>           CPU0       CPU1       CPU2       CPU3
>  0:       8722          0          0          0   IO-APIC-edge      timer
>  1:          2          0          0          0   IO-APIC-edge      i8042
>  9:          0          0          0          0   IO-APIC-fasteoi   acpi
> 12:          3          0          0          0   IO-APIC-edge      i8042
> 16:   10253239   34561425   28715428   20097192   IO-APIC-fasteoi   3w-9xxx, 
> uhci_hcd:usb3
> 18:       1532         38          0          0   IO-APIC-fasteoi 
> ehci_hcd:usb1, uhci_hcd:usb7
> 19:      43319      66498          0          0   IO-APIC-fasteoi 
> uhci_hcd:usb6
> 21:    1503630  282221348   34906481  251529888   IO-APIC-fasteoi 
> uhci_hcd:usb4, eth1
> 22:    3041085   50898734   44446192  106189021   IO-APIC-fasteoi   HDA 
> Intel, eth2
> 23:   13630119   27422086    1544853      13244   IO-APIC-fasteoi 
> ehci_hcd:usb2, uhci_hcd:usb5
> 375:    3059314   15607219    8335846    3335608   PCI-MSI-edge      ahci
> 376:    2259672  275715231   18496746  107799784   PCI-MSI-edge      eth0
> 377:    2653268    4958739          0          0   PCI-MSI-edge 
> i915@pci:0000:00:02.0
> NMI:          0          0          0          0   Non-maskable interrupts
> LOC: 2603771749 2610047685 2594237486 2589369293   Local timer interrupts
> RES:    5511462    1894029    4550761    1766978   Rescheduling interrupts
> CAL:      15747      15686      15135       6535   Function call interrupts
> TLB:     749115     747241     962808     893832   TLB shootdowns
> TRM:          0          0          0          0   Thermal event interrupts
> THR:          0          0          0          0   Threshold APIC interrupts
> SPU:          0          0          0          0   Spurious interrupts
> ERR:          0
> MIS:          0
>
> DETAILS (warning! very long):
>
> Request:-  31st January 2009 at 1:45
>        This problem has happened 3 or 4 times now, it is very strange, it 
> occurs across several kernels, the one I am running now is (2.6.28).  It 
> occurs across two schedulers (so it is unlikely the kernel); noop and 
> deadline.
>
> Essentially what happens is all I/O is blocked during decompression of a file 
> and it stays that way:
>
> Extracting from backup.r81
>
> ...         backup-20090101.img 
> 87%
>
> Extracting from backup.r82
>
> ...         backup-20090101.img 
> 88%
>
> Extracting from backup.r83
>
> ...         backup-20090101.img 
> 89%
>
> Extracting from backup.r84
>
> ...         backup-20090101.img 
> 90%
>
> Here, it is *stuck* at 90%:
>
>  PID USER      PR  NI  VIRT SWAP  RES  SHR S %CPU %MEM   TIME P COMMAND
>  348 user      20   0 18616  16m 1572 1108 R  100  0.0  21:59 0 unrar
>
> It sits at 100%, this has happened during VERIFYs and also when the system is 
> just plain idle.  It seems to be a very nasty bug because the process _never_ 
> seems to complete.
>
> When this bug occurs, it appears all I/O to the array is blocked:
> $ dd if=/dev/zero of=create_file bs=1M count=1024
>
> It just sits there, when I try to strace the process, I get nothing:
> $ strace -p 770
> Process 770 attached - interrupt to quit
>
> I tried some things:
>
> # /opt/3ware/9500/tw_cli  /c0 set verify=5
> Setting Verify Rate on /c0 to 5 (Fastest I/O)...Done.
>
> # /opt/3ware/9500/tw_cli  /c0 set verify=1
> Setting Verify Rate on /c0 to 1 (Fastest Verify)...Done.
>
> # /opt/3ware/9500/tw_cli  /c0 set verify=3
> Setting Verify Rate on /c0 to 3 (Balanced Verify and I/O )...Done.
>
> No difference.
>
> In its current failure mode:
> //p34> info c0
>
> Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
> ------------------------------------------------------------------------------
> u0    RAID-6    VERIFYING      -       91%(A)  64K     12107.1   ON     ON u1 
> SPARE     OK             -       -       -       931.505   -      ON
>
>
> It is verifying, maybe it will 'unblock' the I/O when its done verifying?
>
> As you can see, the box is stagnant during this problem:
> $ vmstat 1
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
> r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> 5  0  83104  47396    136 6586588    0    0   580   442    3    0  1  1 98 
> 0
> 5  0  83104  47380    136 6586612    0    0     0     0 4143  129  0 25 75 
> 0
> 5  0  83104  47380    136 6586612    0    0     0     0 4063  147  0 25 75 
> 0
> 5  0  83104  47380    136 6586612    0    0     0     0 4052  139  0 25 75 
> 0
> 5  0  83104  47256    136 6586612    0    0     0     0 4137  199  0 25 75 
> 0
> 5  0  83104  47256    136 6586612    0    0     0     0 4916  160  0 25 75 
> 0
>
> Here is an iostat on the device (/dev/sda):
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.00    0.00   25.00    0.00    0.00   75.00
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00 
> 0.00    0.00   0.00   0.00
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.00    0.00   25.06    0.00    0.00   74.94
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00 
> 0.00    0.00   0.00   0.00
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.00    0.00   25.00    0.00    0.00   75.00
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00 
> 0.00    0.00   0.00   0.00
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.00    0.00   25.06    0.00    0.00   74.94
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz 
> avgqu-sz   await  svctm  %util
> sda1              0.00     0.00    0.00    0.00     0.00     0.00     0.00 
> 0.00    0.00   0.00   0.00
>
> I will let it sit for now and see if it "comes to" after the VERIFY is 
> complete.  In the interim I have attached the tw_cli /c0 show diag output, 
> but that looks normal as well, at least the most recent output, this looks 
> like it could be a deeper bug than just something on the surface.
>
> The 25% is probably 1 of the CPUs (quad core) pegged at 100% trying to get 
> I/O and the controller is not allowing it!
>
> This problem was *NEVER* experienced when I was not using the 3ware card, it 
> only happened after I began using this card in my machine.
>
> # /opt/3ware/9500/tw_cli  /c0 show all
> /c0 Driver Version = 2.26.02.011
> /c0 Model = 9650SE-16ML
> /c0 Available Memory = 224MB
> /c0 Firmware Version = FE9X 4.06.00.004
> /c0 Bios Version = BE9X 4.05.00.015
> /c0 Boot Loader Version = BL9X 3.08.00.001
> /c0 Serial Number = [[ snip ]]
> /c0 PCB Version = Rev 032
> /c0 PCHIP Version = 2.00
> /c0 ACHIP Version = 1.90
> /c0 Number of Ports = 16
> /c0 Number of Drives = 16
> /c0 Number of Units = 2
> /c0 Total Optimal Units = 2
> /c0 Not Optimal Units = 0 /c0 JBOD Export Policy = off
> /c0 Disk Spinup Policy = 1
> /c0 Spinup Stagger Time Policy (sec) = 1
> /c0 Auto-Carving Policy = off
> /c0 Auto-Carving Size = 2048 GB
> /c0 Auto-Rebuild Policy = on
> /c0 Controller Bus Type = PCIe
> /c0 Controller Bus Width = 8 lanes
> /c0 Controller Bus Speed = 2.5 Gbps/lane
>
> Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
> ------------------------------------------------------------------------------
> u0    RAID-6    VERIFYING      -       92%(A)  64K     12107.1   ON     ON u1 
> SPARE     OK             -       -       -       931.505   -      ON
>
> Port   Status           Unit   Size        Blocks        Serial
> ---------------------------------------------------------------
> p0     OK               u0     931.51 GB   1953525168    WD-...
> p1     OK               u0     931.51 GB   1953525168    WD-...
> p2     OK               u0     931.51 GB   1953525168    WD-...
> p3     OK               u0     931.51 GB   1953525168    WD-...
> p4     OK               u0     931.51 GB   1953525168    WD-...
> p5     OK               u0     931.51 GB   1953525168    WD-...
> p6     OK               u0     931.51 GB   1953525168    WD-...
> p7     OK               u0     931.51 GB   1953525168    WD-...
> p8     OK               u0     931.51 GB   1953525168    WD-...
> p9     OK               u0     931.51 GB   1953525168    WD-...
> p10    OK               u0     931.51 GB   1953525168    WD-...
> p11    OK               u0     931.51 GB   1953525168    WD-...
> p12    OK               u0     931.51 GB   1953525168    WD-...
> p13    OK               u0     931.51 GB   1953525168    WD-...
> p14    OK               u0     931.51 GB   1953525168    WD-...
> p15    OK               u1     931.51 GB   1953525168    WD-...
>
> Name  OnlineState  BBUReady  Status    Volt     Temp     Hours  LastCapTest
> ---------------------------------------------------------------------------
> bbu   On           Yes       OK        OK       OK       255    28-Dec-2008
>
> Once this is "over" then I can attach the tw_cli diag output right now its 
> locking/blocking any I/O, I cannot even ssh to the host, even though the root 
> partition/drives are not on the 3ware controller!!
>
> root      8694  0.0  0.0      0     0 ?        D    Jan29   2:21 [pdflush]
> root      2226  0.0  0.0  10100   404 ?        Ds   Jan01   0:14 
> /sbin/syslogd -r
>
> Lots of processes in D-state.
>
>
> Request:-  31st January 2009 at 2:8
>        Nope, its still LOCKED/blocked/etc:
>
> # /opt/3ware/9500/tw_cli  info c0
>
> Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVrfy
> ------------------------------------------------------------------------------
> u0    RAID-6    OK             -       -       64K     12107.1   ON     ON u1 
> SPARE     OK             -       -       -       931.505   -      ON
>
> Port   Status           Unit   Size        Blocks        Serial
> ---------------------------------------------------------------
> p0     OK               u0     931.51 GB   1953525168    WD-
> p1     OK               u0     931.51 GB   1953525168    WD-
> p2     OK               u0     931.51 GB   1953525168    WD-
> p3     OK               u0     931.51 GB   1953525168    WD-
> p4     OK               u0     931.51 GB   1953525168    WD-
> p5     OK               u0     931.51 GB   1953525168    WD-
> p6     OK               u0     931.51 GB   1953525168    WD-
> p7     OK               u0     931.51 GB   1953525168    WD-
> p8     OK               u0     931.51 GB   1953525168    WD-
> p9     OK               u0     931.51 GB   1953525168    WD-
> p10    OK               u0     931.51 GB   1953525168    WD-
> p11    OK               u0     931.51 GB   1953525168    WD-
> p12    OK               u0     931.51 GB   1953525168    WD-
> p13    OK               u0     931.51 GB   1953525168    WD-
> p14    OK               u0     931.51 GB   1953525168    WD-
> p15    OK               u1     931.51 GB   1953525168    WD-
>
> Name  OnlineState  BBUReady  Status    Volt     Temp     Hours  LastCapTest
> ---------------------------------------------------------------------------
> bbu   On           Yes       OK        OK       OK       255    28-Dec-2008
>
> Completely blocking all I/O..
>
> p34:~# ps auxww | grep -i unrar
> user       348 99.6  0.0  18616  1572 pts/19   R+   04:05  60:59 unrar x 
> backup01.rar
> root       865  0.0  0.0   4220   724 pts/29   S+   05:06   0:00 grep -i 
> unrar
> p34:~# kill -9 348
> p34:~# p34:~# killall -9 dd
> p34:~#
>
> Still...... BLOCKED...
>
>
>
> Request:-  31st January 2009 at 2:13
>        I was able to get a call trace, when I tried to write it to a file 
> though, it was BLOCKED, so this is from a free ssh session I had open:
>
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff80264979>] autoremove_wake_function+0x9/0x30
> [2578818.429166]  [<ffffffff8024597a>] __wake_up_common+0x5a/0x90
> [2578818.429166]  [<ffffffff80608ced>] schedule_timeout+0xad/0xf0
> [2578818.429166]  [<ffffffff80264a83>] prepare_to_wait_exclusive+0x23/0x80
> [2578818.429166]  [<ffffffff805dcad6>] unix_wait_for_peer+0x86/0xd0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff80575cd7>] memcpy_fromiovec+0x57/0x80
> [2578818.429166]  [<ffffffff805dd170>] unix_dgram_sendmsg+0x450/0x5a0
> [2578818.429166]  [<ffffffff8056d77b>] sock_sendmsg+0xcb/0x100
> [2578818.429166]  [<ffffffff802af076>] do_path_lookup+0xd6/0x1a0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802af15d>] kern_path+0x1d/0x40
> [2578818.429166]  [<ffffffff8025408e>] current_fs_time+0x1e/0x30
> [2578818.429166]  [<ffffffff802baa9d>] mnt_want_write+0x2d/0xa0
> [2578818.429166]  [<ffffffff802bb637>] mntput_no_expire+0x27/0x140
> [2578818.429166]  [<ffffffff805dccc2>] unix_find_other+0x1a2/0x200
> [2578818.429166]  [<ffffffff8056cd62>] sockfd_lookup_light+0x22/0x90
> [2578818.429166]  [<ffffffff8056db89>] sys_sendto+0x119/0x180
> [2578818.429166]  [<ffffffff805dd5ba>] unix_dgram_connect+0xaa/0x250
> [2578818.429166]  [<ffffffff8056d046>] sys_connect+0x86/0xe0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] cron          S ffff88022aae7bc8     0   861   3044
> [2578818.429166]  ffff8801005b9b88 0000000000000086 00007f68d6c77000 
> ffffe2000453ab70
> [2578818.429166]  ffffffff807cd000 ffff8801005b5260 ffff880211f8f160 
> ffff8801005b5490
> [2578818.429166]  000000032abe1b60 ffff8801005b9d18 ffff8801005b5490 
> ffffffff8028b45b
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff8028b45b>] handle_mm_fault+0x2bb/0x7a0
> [2578818.429166]  [<ffffffff80608ced>] schedule_timeout+0xad/0xf0
> [2578818.429166]  [<ffffffff80264a83>] prepare_to_wait_exclusive+0x23/0x80
> [2578818.429166]  [<ffffffff805dcad6>] unix_wait_for_peer+0x86/0xd0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff80575cd7>] memcpy_fromiovec+0x57/0x80
> [2578818.429166]  [<ffffffff805dd170>] unix_dgram_sendmsg+0x450/0x5a0
> [2578818.429166]  [<ffffffff8056d77b>] sock_sendmsg+0xcb/0x100
> [2578818.429166]  [<ffffffff802af076>] do_path_lookup+0xd6/0x1a0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802af15d>] kern_path+0x1d/0x40
> [2578818.429166]  [<ffffffff8025408e>] current_fs_time+0x1e/0x30
> [2578818.429166]  [<ffffffff802baa9d>] mnt_want_write+0x2d/0xa0
> [2578818.429166]  [<ffffffff802bb637>] mntput_no_expire+0x27/0x140
> [2578818.429166]  [<ffffffff805dccc2>] unix_find_other+0x1a2/0x200
> [2578818.429166]  [<ffffffff8056cd62>] sockfd_lookup_light+0x22/0x90
> [2578818.429166]  [<ffffffff8056db89>] sys_sendto+0x119/0x180
> [2578818.429166]  [<ffffffff805dd5ba>] unix_dgram_connect+0xaa/0x250
> [2578818.429166]  [<ffffffff8056d046>] sys_connect+0x86/0xe0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] cron          S 00000000ffffffff     0   862   3044
> [2578818.429166]  ffff8801005bbb88 0000000000000086 00007f68d6c77000 
> ffffe2000453ab70
> [2578818.429166]  ffffffff807cd000 ffff8801005b4cf0 ffff88022b8950e0 
> ffff8801005b4f20
> [2578818.429166]  0000000129928420 0000000199ae5567 ffff8801005b4f20 
> ffffffff8028b45b
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff8028b45b>] handle_mm_fault+0x2bb/0x7a0
> [2578818.429166]  [<ffffffff80608ced>] schedule_timeout+0xad/0xf0
> [2578818.429166]  [<ffffffff80264a83>] prepare_to_wait_exclusive+0x23/0x80
> [2578818.429166]  [<ffffffff805dcad6>] unix_wait_for_peer+0x86/0xd0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff80575cd7>] memcpy_fromiovec+0x57/0x80
> [2578818.429166]  [<ffffffff805dd170>] unix_dgram_sendmsg+0x450/0x5a0
> [2578818.429166]  [<ffffffff8056d77b>] sock_sendmsg+0xcb/0x100
> [2578818.429166]  [<ffffffff802af076>] do_path_lookup+0xd6/0x1a0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802af15d>] kern_path+0x1d/0x40
> [2578818.429166]  [<ffffffff8025408e>] current_fs_time+0x1e/0x30
> [2578818.429166]  [<ffffffff802baa9d>] mnt_want_write+0x2d/0xa0
> [2578818.429166]  [<ffffffff802bb637>] mntput_no_expire+0x27/0x140
> [2578818.429166]  [<ffffffff805dccc2>] unix_find_other+0x1a2/0x200
> [2578818.429166]  [<ffffffff8056cd62>] sockfd_lookup_light+0x22/0x90
> [2578818.429166]  [<ffffffff8056db89>] sys_sendto+0x119/0x180
> [2578818.429166]  [<ffffffff805dd5ba>] unix_dgram_connect+0xaa/0x250
> [2578818.429166]  [<ffffffff8056d046>] sys_connect+0x86/0xe0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
>
>
> Request:-  31st January 2009 at 2:16
>        These are the 'optimizations' I use on this array:
>
>  echo 128 > /sys/block/$i/queue/max_sectors_kb   # 128 is default
>  echo 512 > /sys/block/$i/queue/nr_requests      # 128 is default
>  # echo 254 > /sys/block/$i/device/queue_depth   # 254 is default
>  echo deadline > /sys/block/$i/queue/scheduler   # distribution dependent
>  blockdev --setra 16384 /dev/$i                  # set readahead
>
> In the past I had been able to kill the process(es) involved or they died 
> eventually, however, this does not seem to be the case this time, I still 
> cannot get my system back!
>
> Request:-  31st January 2009 at 2:20
>        Here is more of the echo t > sysrq-trigger:
>
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff805de205>] unix_stream_sendmsg+0x3b5/0x3d0
> [2578818.429166]  [<ffffffff80608ced>] schedule_timeout+0xad/0xf0
> [2578818.429166]  [<ffffffff80264b03>] prepare_to_wait+0x23/0x80
> [2578818.429166]  [<ffffffff805ddc92>] unix_stream_recvmsg+0x432/0x5f0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802aeb6c>] __link_path_walk+0xdbc/0xf20
> [2578818.429166]  [<ffffffff8056c60f>] sock_aio_read+0x14f/0x160
> [2578818.429166]  [<ffffffff802a3ed3>] do_sync_read+0xe3/0x130
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802a4b3e>] vfs_read+0x15e/0x170
> [2578818.429166]  [<ffffffff802a4c53>] sys_read+0x53/0xa0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] sshd          S 00000000ffffffff     0 32669  32667
> [2578818.429166]  ffff8801c4b15998 0000000000000086 ffffffff80755008 
> ffffffff8040c2c0
> [2578818.429166]  ffffffff807cd000 ffff88022b968700 ffff88022b8f2bb0 
> ffff88022b968930
> [2578818.429166]  0000000328057c18 0000000199b05a5c ffff88022b968930 
> ffff8801c4b159a8
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff8040c2c0>] rb_insert_color+0x100/0x130
> [2578818.429166]  [<ffffffff8026800f>] hrtimer_start_range_ns+0xdf/0x1b0
> [2578818.429166]  [<ffffffff80267eb9>] hrtimer_try_to_cancel+0x39/0x80
> [2578818.429166]  [<ffffffff80609415>] schedule_hrtimeout_range+0xb5/0x150
> [2578818.429166]  [<ffffffff802678e0>] hrtimer_wakeup+0x0/0x30
> [2578818.429166]  [<ffffffff802b35d9>] do_select+0x539/0x630
> [2578818.429166]  [<ffffffff802b3d30>] __pollwait+0x0/0x130
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80575f57>] memcpy_toiovec+0x57/0x80
> [2578818.429166]  [<ffffffff8060a529>] _spin_lock_bh+0x9/0x20
> [2578818.429166]  [<ffffffff8056fcc3>] release_sock+0x13/0xa0
> [2578818.429166]  [<ffffffff805ab7dc>] tcp_recvmsg+0x32c/0x940
> [2578818.429166]  [<ffffffff8056f110>] sock_common_recvmsg+0x30/0x50
> [2578818.429166]  [<ffffffff8056c60f>] sock_aio_read+0x14f/0x160
> [2578818.429166]  [<ffffffff802b38cf>] core_sys_select+0x1ff/0x310
> [2578818.429166]  [<ffffffff80240bb0>] do_page_fault+0x2f0/0x980
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff8026aa98>] getnstimeofday+0x48/0xc0
> [2578818.429166]  [<ffffffff802308b9>] read_tsc+0x9/0x20
> [2578818.429166]  [<ffffffff8026aa98>] getnstimeofday+0x48/0xc0
> [2578818.429166]  [<ffffffff802b3c71>] sys_select+0x51/0x110
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] bash          S 00000000ffffffff     0 32670  32669
> [2578818.429166]  ffff88022607de88 0000000000000082 ffff8800b773cc60 
> 00000000006c4e5c
> [2578818.429166]  ffffffff807cd000 ffff8801006a8410 ffffffff8071a340 
> ffff8801006a8640
> [2578818.429166]  00000000006a8410 000000019977482f ffff8801006a8640 
> ffffffff807258c8
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff8045be2b>] tty_check_change+0x11b/0x130
> [2578818.429166]  [<ffffffff8025191e>] session_of_pgrp+0xe/0x50
> [2578818.429166]  [<ffffffff8045c6f2>] tty_ioctl+0x8b2/0x920
> [2578818.429166]  [<ffffffff80252872>] do_wait+0x272/0x350
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff802529e5>] sys_wait4+0x95/0xf0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] sr            S 00000000ffffffff     0 32677  32670
> [2578818.429166]  ffff88008f50fe88 0000000000000086 ffff88010ccebbb8 
> 00000000006c4e5c
> [2578818.429166]  ffffffff807cd000 ffff880148a6f260 ffffffff8071a340 
> ffff880148a6f490
> [2578818.429166]  0000000048a6f260 000000019977482f ffff880148a6f490 
> ffffffff807258c8
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff80252872>] do_wait+0x272/0x350
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff802529e5>] sys_wait4+0x95/0xf0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] screen        S 00000000ffffffff     0 32683  32677
> [2578818.429166]  ffff88020a9e5f68 0000000000000086 ffff88022ba8f160 
> ffff88020a9e5f28
> [2578818.429166]  ffffffff807cd000 ffff88022ba8f160 ffff88022b8950e0 
> ffff88022ba8f390
> [2578818.429166]  000000015afa2f00 0000000199b0f5e0 ffff88022ba8f390 
> 00007fff5afa5be2
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff80253955>] alarm_setitimer+0x35/0x70
> [2578818.429166]  [<ffffffff8025a2e9>] sys_pause+0x19/0x30
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] sshd          S 00000000ffffffff     0 32684  10156
> [2578818.429166]  ffff880198c4bbe8 0000000000000082 ffff880228808000 
> ffff880198c4bb68
> [2578818.429166]  ffffffff807cd000 ffff880100552090 ffff88022b8f2bb0 
> ffff8801005522c0
> [2578818.429166]  0000000398c4bb68 000000019977506f ffff8801005522c0 
> ffff8800058e33c0
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff805de205>] unix_stream_sendmsg+0x3b5/0x3d0
> [2578818.429166]  [<ffffffff80608ced>] schedule_timeout+0xad/0xf0
> [2578818.429166]  [<ffffffff80264b03>] prepare_to_wait+0x23/0x80
> [2578818.429166]  [<ffffffff805ddc92>] unix_stream_recvmsg+0x432/0x5f0
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802aeb6c>] __link_path_walk+0xdbc/0xf20
> [2578818.429166]  [<ffffffff8056c60f>] sock_aio_read+0x14f/0x160
> [2578818.429166]  [<ffffffff802a3ed3>] do_sync_read+0xe3/0x130
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff802a4b3e>] vfs_read+0x15e/0x170
> [2578818.429166]  [<ffffffff802a4c53>] sys_read+0x53/0xa0
> [2578818.429166]  [<ffffffff8022986b>] system_call_fastpath+0x16/0x1b
> [2578818.429166] sshd          S 00000000ffffffff     0 32686  32684
> [2578818.429166]  ffff880040dff998 0000000000000086 ffff880040dff9a8 
> ffffffff8040c250
> [2578818.429166]  ffffffff807cd000 ffff8801e96411e0 ffff88022b8f2bb0 
> ffff8801e9641410
> [2578818.429166]  0000000328057c18 0000000199b0a381 ffff8801e9641410 
> ffff880040dff9a8
> [2578818.429166] Call Trace:
> [2578818.429166]  [<ffffffff8040c250>] rb_insert_color+0x90/0x130
> [2578818.429166]  [<ffffffff8026800f>] hrtimer_start_range_ns+0xdf/0x1b0
> [2578818.429166]  [<ffffffff80267eb9>] hrtimer_try_to_cancel+0x39/0x80
> [2578818.429166]  [<ffffffff80609415>] schedule_hrtimeout_range+0xb5/0x150
> [2578818.429166]  [<ffffffff802678e0>] hrtimer_wakeup+0x0/0x30
> [2578818.429166]  [<ffffffff802b35d9>] do_select+0x539/0x630
> [2578818.429166]  [<ffffffff802b3d30>] __pollwait+0x0/0x130
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80249e30>] default_wake_function+0x0/0x10
> [2578818.429166]  [<ffffffff80575f57>] memcpy_toiovec+0x57/0x80
> [2578818.429166]  [<ffffffff8060a529>] _spin_lock_bh+0x9/0x20
> [2578818.429166]  [<ffffffff8056fcc3>] release_sock+0x13/0xa0
> [2578818.429166]  [<ffffffff805ab7dc>] tcp_recvmsg+0x32c/0x940
> [2578818.429166]  [<ffffffff8056f110>] sock_common_recvmsg+0x30/0x50
> [2578818.429166]  [<ffffffff8056c60f>] sock_aio_read+0x14f/0x160
> [2578818.429166]  [<ffffffff802b38cf>] core_sys_select+0x1ff/0x310
> [2578818.429166]  [<ffffffff8045e7a1>] n_tty_read+0x371/0x870
> [2578818.429166]  [<ffffffff80264970>] autoremove_wake_function+0x0/0x30
> [2578818.429166]  [<ffffffff80249e30>] default_wake_fun
>
> Request:-  31st January 2009 at 2:24
>        Just as I was about to give up, I went to the machine, woke up the 
> screensaver (moved mouse) and logged in and then EVERYTHING started working 
> again??
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
