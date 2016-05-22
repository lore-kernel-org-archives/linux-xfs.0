Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E5D987CA4
	for <xfs@oss.sgi.com>; Sun, 22 May 2016 14:36:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB84E304032
	for <xfs@oss.sgi.com>; Sun, 22 May 2016 12:36:47 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id aWAbpDD6mhW0keFi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 22 May 2016 12:36:42 -0700 (PDT)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <20160324111703.GA4068@bfoster.bfoster>
	<56F3DACB.8040305@profihost.ag> <20160324122417.GB4068@bfoster.bfoster>
	<57332508.307@profihost.ag> <20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
	<5738576B.4010208@profihost.ag> <20160515115017.GA6433@laptop.bfoster>
	<57386E84.3090606@profihost.ag>
	<20160516010602.GA24980@bfoster.bfoster>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <57420A47.2000700@profihost.ag>
Date: Sun, 22 May 2016 21:36:39 +0200
MIME-Version: 1.0
In-Reply-To: <20160516010602.GA24980@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Am 16.05.2016 um 03:06 schrieb Brian Foster:
> On Sun, May 15, 2016 at 02:41:40PM +0200, Stefan Priebe wrote:
>> Hi,
>>
>> find shows a ceph object file:
>> /var/lib/ceph/osd/ceph-13/current/3.29f_head/DIR_F/DIR_9/DIR_2/DIR_D/rbd\udata.904a406b8b4567.00000000000052d6__head_143BD29F__3
>>
> 
> Any idea what this file is? Does it represent user data, Ceph metadata?

It's user data.

> How was it created? Can you create others like it (I'm assuming via some
> file/block operation through Ceph) and/or reproduce the error?

It's the ceph osd daemon creating those files. It works with normal file
operations. I'm not able to force this.

> (Also, this thread is 20+ mails strong at this point, why is this the
> first reference to Ceph? :/)

Cause i still see no reference to ceph. It happens also on non ceph systems.


>> File was again modified since than.
>>
> xfs_bmap -v might still be interesting.

I was on holiday the last days - the file got deleted by ceph. Should i
recollect everything from a new trace?

>> At another system i've different output.
>> [Sun May 15 07:00:44 2016] XFS (md127p3): ino 0x600204f delalloc 1 unwritten
>> 0 pgoff 0x50000 size 0x13d1c8
>> [Sun May 15 07:00:44 2016] ------------[ cut here ]------------
>> [Sun May 15 07:00:44 2016] WARNING: CPU: 2 PID: 108 at
>> fs/xfs/xfs_aops.c:1239 xfs_vm_releasepage+0x10f/0x140()
> 
> This one is different, being a lingering delalloc block in this case.
> 
>> [Sun May 15 07:00:44 2016] Modules linked in: netconsole ipt_REJECT
>> nf_reject_ipv4 xt_multiport iptable_filter ip_tables x_tables bonding
>> coretemp 8021q garp fuse xhci_pci xhci_hcd sb_edac edac_core i2c_i801
>> i40e(O) shpchp vxlan ip6_udp_tunnel udp_tunnel ipmi_si ipmi_msghandler
>> button btrfs xor raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg
>> sd_mod ehci_pci ehci_hcd usbcore usb_common igb ahci i2c_algo_bit libahci
>> i2c_core ptp mpt3sas pps_core raid_class scsi_transport_sas
>> [Sun May 15 07:00:44 2016] CPU: 2 PID: 108 Comm: kswapd0 Tainted: G       O
>> 4.4.10+25-ph #1
> 
> How close is this to an upstream kernel? Upstream XFS? Have you tried to
> reproduce this on an upstream kernel?

It's a vanilla 4.4.10 + a new adaptec driver and some sched and wq
patches from 4.5 and 4.6 but i can try to replace the kernel on one
machine with a 100% vanilla one if this helps.

>> [Sun May 15 07:00:44 2016] Hardware name: Supermicro Super Server/X10SRH-CF,
>> BIOS 1.0b 05/18/2015
>> [Sun May 15 07:00:44 2016]  0000000000000000 ffff880c4da37a88
>> ffffffff9c3c6d0f 0000000000000000
>> [Sun May 15 07:00:44 2016]  ffffffff9ca51a1c ffff880c4da37ac8
>> ffffffff9c0837a7 ffff880c4da37ae8
>> [Sun May 15 07:00:44 2016]  0000000000000001 ffffea0001053080
>> ffff8801429ef490 ffffea00010530a0
>> [Sun May 15 07:00:44 2016] Call Trace:
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c3c6d0f>] dump_stack+0x63/0x84
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c0837a7>]
>> warn_slowpath_common+0x97/0xe0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c08380a>]
>> warn_slowpath_null+0x1a/0x20
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c326f4f>]
>> xfs_vm_releasepage+0x10f/0x140
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c1520c2>]
>> try_to_release_page+0x32/0x50
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c166a8e>]
>> shrink_active_list+0x3ce/0x3e0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c167127>] shrink_lruvec+0x687/0x7d0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c16734c>] shrink_zone+0xdc/0x2c0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c168499>] kswapd+0x4f9/0x970
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c167fa0>] ?
>> mem_cgroup_shrink_node_zone+0x1a0/0x1a0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c0a0d99>] kthread+0xc9/0xe0
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c0a0cd0>] ? kthread_stop+0x100/0x100
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c6b58cf>] ret_from_fork+0x3f/0x70
>> [Sun May 15 07:00:44 2016]  [<ffffffff9c0a0cd0>] ? kthread_stop+0x100/0x100
>> [Sun May 15 07:00:44 2016] ---[ end trace 9497d464aafe5b88 ]---
>> [295086.353469] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0x51000 size 0x13d1c8
> 
> What is md127p3, is the root fs on some kind of raid device? Can you
> provide xfs_info for this filesystem?

It's a mdadm raid 1 amd the root fs.

# xfs_info /
meta-data=/dev/disk/by-uuid/afffa232-0025-4222-9952-adb31482fe4a
isize=256    agcount=4, agsize=1703936 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=6815744, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=3328, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

>> [295086.353473] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0x52000 size 0x13d1c8
>> [295086.353476] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0x53000 size 0x13d1c8
>> [295086.353478] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0x54000 size 0x13d1c8
> ...
>> [295086.567508] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0xab000 size 0x13d1c8
>> [295086.567510] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0xac000 size 0x13d1c8
>> [295086.567515] XFS (md127p3): ino 0x600204f delalloc 1 unwritten 0 pgoff
>> 0xad000 size 0x13d1c8
>>
>> The file to the inode number is:
>> /var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
>>
> 
> xfs_bmap -v might be interesting here as well.

# xfs_bmap -v
/var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en
/var/lib/apt/lists/security.debian.org_dists_wheezy_updates_main_i18n_Translation-en:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
   0: [0..2567]:       41268928..41271495  3 (374464..377031)  2568


> This certainly seems like it is more repeatable. According to google,
> the content of /var/lib/apt/lists/ can be removed and repopulated safely
> with 'apt-get update' (please verify before trying). Does that reproduce
> this variant of the problem?
> Note that the apt command might not directly cause the error message,
> but rather only create the conditions for it to occur sometime later via
> memory reclaim. E.g., you might need to run 'sync; echo 3 >
> /proc/sys/vm/drop_caches' after, or possibly run a dummy workload of
> some kind (e.g., dd if=/dev/zero of=tmpfile bs=1M ...) to cause memory
> pressure and reclaim the pagecache of the package list file.

OK - this is what i did but no trace:
  106  22.05.2016 - 21:31:03 reboot
  108  22.05.2016 - 21:33:25 dmesg -c
  109  22.05.2016 - 21:33:51 mv /var/lib/apt/lists /var/lib/apt/lists.backup
  110  22.05.2016 - 21:33:54 apt-get update
  111  22.05.2016 - 21:34:09 ls -la /var/lib/apt/lists
  112  22.05.2016 - 21:34:58 dmesg
  113  22.05.2016 - 21:35:14 sync; echo 3 >/proc/sys/vm/drop_caches
  114  22.05.2016 - 21:35:17 dmesg
  115  22.05.2016 - 21:35:50 dd if=/dev/zero of=tmpfile bs=1M
count=4096; rm -v tmpfile
  116  22.05.2016 - 21:35:55 dmesg

Greets,
Stefan

> Brian
> 
>> dmesg output / trace was at 7 am today and last modify of the file was
>> yesterday 11 pm.
>>
>> Stefan
>>
>> Am 15.05.2016 um 13:50 schrieb Brian Foster:
>>> On Sun, May 15, 2016 at 01:03:07PM +0200, Stefan Priebe wrote:
>>>> Hi Brian,
>>>>
>>>> here's the new trace:
>>>> [310740.407263] XFS (sdf1): ino 0x27c69cd delalloc 0 unwritten 1 pgoff
>>>> 0x19f000 size 0x1a0000
>>>
>>> So it is actually an unwritten buffer, on what appears to be the last
>>> page of the file. Well, we had 60630fe ("xfs: clean up unwritten buffers
>>> on write failure") that went into 4.6, but that was reproducible on
>>> sub-4k block size filesystems and depends on some kind of write error.
>>> Are either of those applicable here? Are you close to ENOSPC, for
>>> example?
>>>
>>> Otherwise, have you determined what file is associated with that inode
>>> (e.g., 'find <mnt> -inum 0x27c69cd -print')? I'm hoping that gives some
>>> insight on what actually preallocates/writes the file and perhaps that
>>> helps us identify something we can trace. Also, if you think the file
>>> has not been modified since the error, an 'xfs_bmap -v <file>' might be
>>> interesting as well...
>>>
>>> Brian
>>>
>>>> [310740.407265] ------------[ cut here ]------------
>>>> [310740.407269] WARNING: CPU: 3 PID: 108 at fs/xfs/xfs_aops.c:1241
>>>> xfs_vm_releasepage+0x12e/0x140()
>>>> [310740.407270] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4
>>>> xt_multiport iptable_filter ip_tables x_tables bonding coretemp 8021q garp
>>>> fuse sb_edac edac_core i2c_i801 i40e(O) xhci_pci xhci_hcd vxlan
>>>> ip6_udp_tunnel shpchp udp_tunnel ipmi_si ipmi_msghandler button btrfs xor
>>>> raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg sd_mod ehci_pci
>>>> ehci_hcd ahci usbcore libahci igb usb_common i2c_algo_bit i2c_core ptp
>>>> mpt3sas pps_core raid_class scsi_transport_sas
>>>> [310740.407289] CPU: 3 PID: 108 Comm: kswapd0 Tainted: G           O
>>>> 4.4.10+25-ph #1
>>>> [310740.407290] Hardware name: Supermicro Super Server/X10SRH-CF, BIOS 1.0b
>>>> 05/18/2015
>>>> [310740.407291]  0000000000000000 ffff880c4da1fa88 ffffffffa13c6d0f
>>>> 0000000000000000
>>>> [310740.407292]  ffffffffa1a51a1c ffff880c4da1fac8 ffffffffa10837a7
>>>> ffff880c4da1fae8
>>>> [310740.407293]  0000000000000000 ffffea0000e38140 ffff8807e20bfd10
>>>> ffffea0000e38160
>>>> [310740.407295] Call Trace:
>>>> [310740.407299]  [<ffffffffa13c6d0f>] dump_stack+0x63/0x84
>>>> [310740.407301]  [<ffffffffa10837a7>] warn_slowpath_common+0x97/0xe0
>>>> [310740.407302]  [<ffffffffa108380a>] warn_slowpath_null+0x1a/0x20
>>>> [310740.407303]  [<ffffffffa1326f6e>] xfs_vm_releasepage+0x12e/0x140
>>>> [310740.407305]  [<ffffffffa11520c2>] try_to_release_page+0x32/0x50
>>>> [310740.407308]  [<ffffffffa1166a8e>] shrink_active_list+0x3ce/0x3e0
>>>> [310740.407309]  [<ffffffffa1167127>] shrink_lruvec+0x687/0x7d0
>>>> [310740.407311]  [<ffffffffa116734c>] shrink_zone+0xdc/0x2c0
>>>> [310740.407312]  [<ffffffffa1168499>] kswapd+0x4f9/0x970
>>>> [310740.407314]  [<ffffffffa1167fa0>] ?
>>>> mem_cgroup_shrink_node_zone+0x1a0/0x1a0
>>>> [310740.407316]  [<ffffffffa10a0d99>] kthread+0xc9/0xe0
>>>> [310740.407318]  [<ffffffffa10a0cd0>] ? kthread_stop+0x100/0x100
>>>> [310740.407320]  [<ffffffffa16b58cf>] ret_from_fork+0x3f/0x70
>>>> [310740.407321]  [<ffffffffa10a0cd0>] ? kthread_stop+0x100/0x100
>>>> [310740.407322] ---[ end trace bf76ad5e8a4d863e ]---
>>>>
>>>>
>>>> Stefan
>>>>
>>>> Am 11.05.2016 um 17:59 schrieb Brian Foster:
>>>>> Dropped non-XFS cc's, probably no need to spam other lists at this
>>>>> point...
>>>>>
>>>>> On Wed, May 11, 2016 at 04:03:16PM +0200, Stefan Priebe - Profihost AG wrote:
>>>>>>
>>>>>> Am 11.05.2016 um 15:34 schrieb Brian Foster:
>>>>>>> On Wed, May 11, 2016 at 02:26:48PM +0200, Stefan Priebe - Profihost AG wrote:
>>>>>>>> Hi Brian,
>>>>>>>>
>>>>>>>> i'm still unable to grab anything to the trace file? Is there anything
>>>>>>>> to check if it's working at all?
>>>>>>>>
>>>>>>>
>>>>>>> See my previous mail:
>>>>>>>
>>>>>>> http://oss.sgi.com/pipermail/xfs/2016-March/047793.html
>>>>>>>
>>>>>>> E.g., something like this should work after writing to and removing a
>>>>>>> new file:
>>>>>>>
>>>>>>> # trace-cmd start -e "xfs:xfs_releasepage"
>>>>>>> # cat /sys/kernel/debug/tracing/trace_pipe
>>>>>>> ...
>>>>>>> rm-8198  [000] ....  9445.774070: xfs_releasepage: dev 253:4 ino 0x69 pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 0 unwritten 0
>>>>>>
>>>>>> arg sorry yes that's working but delalloc is always 0.
>>>>>>
>>>>>
>>>>> Hrm, Ok. That is strange.
>>>>>
>>>>>> May be i have to hook that into my initramfs to be fast enough?
>>>>>>
>>>>>
>>>>> Not sure that would matter.. you said it occurs within 48 hours? I take
>>>>> that to mean it doesn't occur immediately on boot. You should be able to
>>>>> tell from the logs or dmesg if it happens before you get a chance to
>>>>> start the tracing.
>>>>>
>>>>> Well, the options I can think of are:
>>>>>
>>>>> - Perhaps I botched matching up the line number to the warning, in which
>>>>>    case we might want to try 'grep -v "delalloc 0 unwritten 0"' to catch
>>>>>    any delalloc or unwritten blocks at releasepage() time.
>>>>>
>>>>> - Perhaps there's a race that the tracepoint doesn't catch. The warnings
>>>>>    are based on local vars, so we could instrument the code to print a
>>>>>    warning[1] to try and get the inode number.
>>>>>
>>>>> Brian
>>>>>
>>>>> [1] - compile tested diff:
>>>>>
>>>>> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
>>>>> index 40645a4..94738ea 100644
>>>>> --- a/fs/xfs/xfs_aops.c
>>>>> +++ b/fs/xfs/xfs_aops.c
>>>>> @@ -1038,11 +1038,18 @@ xfs_vm_releasepage(
>>>>>   	gfp_t			gfp_mask)
>>>>>   {
>>>>>   	int			delalloc, unwritten;
>>>>> +	struct xfs_inode	*ip = XFS_I(page->mapping->host);
>>>>>
>>>>>   	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
>>>>>
>>>>>   	xfs_count_page_state(page, &delalloc, &unwritten);
>>>>>
>>>>> +	if (delalloc || unwritten)
>>>>> +		xfs_warn(ip->i_mount,
>>>>> +		"ino 0x%llx delalloc %d unwritten %d pgoff 0x%llx size 0x%llx",
>>>>> +			 ip->i_ino, delalloc, unwritten, page_offset(page),
>>>>> +			 i_size_read(page->mapping->host));
>>>>> +
>>>>>   	if (WARN_ON_ONCE(delalloc))
>>>>>   		return 0;
>>>>>   	if (WARN_ON_ONCE(unwritten))
>>>>>
>>>>>> Stefan
>>>>>>
>>>>>>> Once that is working, add the grep command to filter out "delalloc 0"
>>>>>>> instances, etc. For example:
>>>>>>>
>>>>>>> 	cat .../trace_pipe | grep -v "delalloc 0" > ~/trace.out
>>>>>>>
>>>>>>> Brian
>>>>>>>
>>>>>>>> This still happens in the first 48 hours after a fresh reboot.
>>>>>>>>
>>>>>>>> Stefan
>>>>>>>>
>>>>>>>> Am 24.03.2016 um 13:24 schrieb Brian Foster:
>>>>>>>>> On Thu, Mar 24, 2016 at 01:17:15PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>>>
>>>>>>>>>> Am 24.03.2016 um 12:17 schrieb Brian Foster:
>>>>>>>>>>> On Thu, Mar 24, 2016 at 09:15:15AM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> Am 24.03.2016 um 09:10 schrieb Stefan Priebe - Profihost AG:
>>>>>>>>>>>>>
>>>>>>>>>>>>> Am 23.03.2016 um 15:07 schrieb Brian Foster:
>>>>>>>>>>>>>> On Wed, Mar 23, 2016 at 02:28:03PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>>>>>>>> sorry new one the last one got mangled. Comments inside.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Am 05.03.2016 um 23:48 schrieb Dave Chinner:
>>>>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 04:03:42PM -0500, Brian Foster wrote:
>>>>>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 09:02:06PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>>>>>> Am 04.03.2016 um 20:13 schrieb Brian Foster:
>>>>>>>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 07:47:16PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>>>>>>>> Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>> ...
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> This has happened again on 8 different hosts in the last 24 hours
>>>>>>>>>>>>>>> running 4.4.6.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> All of those are KVM / Qemu hosts and are doing NO I/O except the normal
>>>>>>>>>>>>>>> OS stuff as the VMs have remote storage. So no database, no rsync on
>>>>>>>>>>>>>>> those hosts - just the OS doing nearly nothing.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> All those show:
>>>>>>>>>>>>>>> [153360.287040] WARNING: CPU: 0 PID: 109 at fs/xfs/xfs_aops.c:1234
>>>>>>>>>>>>>>> xfs_vm_releasepage+0xe2/0xf0()
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Ok, well at this point the warning isn't telling us anything beyond
>>>>>>>>>>>>>> you're reproducing the problem. We can't really make progress without
>>>>>>>>>>>>>> more information. We don't necessarily know what application or
>>>>>>>>>>>>>> operations caused this by the time it occurs, but perhaps knowing what
>>>>>>>>>>>>>> file is affected could give us a hint.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> We have the xfs_releasepage tracepoint, but that's unconditional and so
>>>>>>>>>>>>>> might generate a lot of noise by default. Could you enable the
>>>>>>>>>>>>>> xfs_releasepage tracepoint and hunt for instances where delalloc != 0?
>>>>>>>>>>>>>> E.g., we could leave a long running 'trace-cmd record -e
>>>>>>>>>>>>>> "xfs:xfs_releasepage" <cmd>' command on several boxes and wait for the
>>>>>>>>>>>>>> problem to occur. Alternatively (and maybe easier), run 'trace-cmd start
>>>>>>>>>>>>>> -e "xfs:xfs_releasepage"' and leave something like 'cat
>>>>>>>>>>>>>> /sys/kernel/debug/tracing/trace_pipe | grep -v "delalloc 0" >
>>>>>>>>>>>>>> ~/trace.out' running to capture instances.
>>>>>>>>>>>>
>>>>>>>>>>>> Isn't the trace a WARN_ONCE? So it does not reoccur or can i check the
>>>>>>>>>>>> it in the trace.out even the WARN_ONCE was already triggered?
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> The tracepoint is independent from the warning (see
>>>>>>>>>>> xfs_vm_releasepage()), so the tracepoint will fire every invocation of
>>>>>>>>>>> the function regardless of whether delalloc blocks still exist at that
>>>>>>>>>>> point. That creates the need to filter the entries.
>>>>>>>>>>>
>>>>>>>>>>> With regard to performance, I believe the tracepoints are intended to be
>>>>>>>>>>> pretty lightweight. I don't think it should hurt to try it on a box,
>>>>>>>>>>> observe for a bit and make sure there isn't a huge impact. Note that the
>>>>>>>>>>> 'trace-cmd record' approach will save everything to file, so that's
>>>>>>>>>>> something to consider I suppose.
>>>>>>>>>>
>>>>>>>>>> Tests / cat is running. Is there any way to test if it works? Or is it
>>>>>>>>>> enough that cat prints stuff from time to time but does not match -v
>>>>>>>>>> delalloc 0
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> What is it printing where delalloc != 0? You could always just cat
>>>>>>>>> trace_pipe and make sure the event is firing, it's just that I suspect
>>>>>>>>> most entries will have delalloc == unwritten == 0.
>>>>>>>>>
>>>>>>>>> Also, while the tracepoint fires independent of the warning, it might
>>>>>>>>> not be a bad idea to restart a system that has already seen the warning
>>>>>>>>> since boot, just to provide some correlation or additional notification
>>>>>>>>> when the problem occurs.
>>>>>>>>>
>>>>>>>>> Brian
>>>>>>>>>
>>>>>>>>>> Stefan
>>>>>>>>>>
>>>>>>>>>> _______________________________________________
>>>>>>>>>> xfs mailing list
>>>>>>>>>> xfs@oss.sgi.com
>>>>>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>>>>>
>>>>>>>> _______________________________________________
>>>>>>>> xfs mailing list
>>>>>>>> xfs@oss.sgi.com
>>>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>>>
>>>>>> _______________________________________________
>>>>>> xfs mailing list
>>>>>> xfs@oss.sgi.com
>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
