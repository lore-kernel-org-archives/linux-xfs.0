Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E86E37CA0
	for <xfs@oss.sgi.com>; Sun, 15 May 2016 06:03:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AF22E30406B
	for <xfs@oss.sgi.com>; Sun, 15 May 2016 04:03:27 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id pF0LS1089iedUyu9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 15 May 2016 04:03:09 -0700 (PDT)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <56F299E3.4020703@profihost.ag>
	<20160323140736.GD43073@bfoster.bfoster>
	<56F3A101.1020300@profihost.ag>
	<56F3A213.2020908@profihost.ag> <20160324111703.GA4068@bfoster.bfoster>
	<56F3DACB.8040305@profihost.ag> <20160324122417.GB4068@bfoster.bfoster>
	<57332508.307@profihost.ag> <20160511133417.GA42410@bfoster.bfoster>
	<57333BA4.4040402@profihost.ag>
	<20160511155951.GF42410@bfoster.bfoster>
From: Stefan Priebe <s.priebe@profihost.ag>
Message-ID: <5738576B.4010208@profihost.ag>
Date: Sun, 15 May 2016 13:03:07 +0200
MIME-Version: 1.0
In-Reply-To: <20160511155951.GF42410@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Brian,

here's the new trace:
[310740.407263] XFS (sdf1): ino 0x27c69cd delalloc 0 unwritten 1 pgoff 
0x19f000 size 0x1a0000
[310740.407265] ------------[ cut here ]------------
[310740.407269] WARNING: CPU: 3 PID: 108 at fs/xfs/xfs_aops.c:1241 
xfs_vm_releasepage+0x12e/0x140()
[310740.407270] Modules linked in: netconsole ipt_REJECT nf_reject_ipv4 
xt_multiport iptable_filter ip_tables x_tables bonding coretemp 8021q 
garp fuse sb_edac edac_core i2c_i801 i40e(O) xhci_pci xhci_hcd vxlan 
ip6_udp_tunnel shpchp udp_tunnel ipmi_si ipmi_msghandler button btrfs 
xor raid6_pq dm_mod raid1 md_mod usbhid usb_storage ohci_hcd sg sd_mod 
ehci_pci ehci_hcd ahci usbcore libahci igb usb_common i2c_algo_bit 
i2c_core ptp mpt3sas pps_core raid_class scsi_transport_sas
[310740.407289] CPU: 3 PID: 108 Comm: kswapd0 Tainted: G           O 
4.4.10+25-ph #1
[310740.407290] Hardware name: Supermicro Super Server/X10SRH-CF, BIOS 
1.0b 05/18/2015
[310740.407291]  0000000000000000 ffff880c4da1fa88 ffffffffa13c6d0f 
0000000000000000
[310740.407292]  ffffffffa1a51a1c ffff880c4da1fac8 ffffffffa10837a7 
ffff880c4da1fae8
[310740.407293]  0000000000000000 ffffea0000e38140 ffff8807e20bfd10 
ffffea0000e38160
[310740.407295] Call Trace:
[310740.407299]  [<ffffffffa13c6d0f>] dump_stack+0x63/0x84
[310740.407301]  [<ffffffffa10837a7>] warn_slowpath_common+0x97/0xe0
[310740.407302]  [<ffffffffa108380a>] warn_slowpath_null+0x1a/0x20
[310740.407303]  [<ffffffffa1326f6e>] xfs_vm_releasepage+0x12e/0x140
[310740.407305]  [<ffffffffa11520c2>] try_to_release_page+0x32/0x50
[310740.407308]  [<ffffffffa1166a8e>] shrink_active_list+0x3ce/0x3e0
[310740.407309]  [<ffffffffa1167127>] shrink_lruvec+0x687/0x7d0
[310740.407311]  [<ffffffffa116734c>] shrink_zone+0xdc/0x2c0
[310740.407312]  [<ffffffffa1168499>] kswapd+0x4f9/0x970
[310740.407314]  [<ffffffffa1167fa0>] ? 
mem_cgroup_shrink_node_zone+0x1a0/0x1a0
[310740.407316]  [<ffffffffa10a0d99>] kthread+0xc9/0xe0
[310740.407318]  [<ffffffffa10a0cd0>] ? kthread_stop+0x100/0x100
[310740.407320]  [<ffffffffa16b58cf>] ret_from_fork+0x3f/0x70
[310740.407321]  [<ffffffffa10a0cd0>] ? kthread_stop+0x100/0x100
[310740.407322] ---[ end trace bf76ad5e8a4d863e ]---


Stefan

Am 11.05.2016 um 17:59 schrieb Brian Foster:
> Dropped non-XFS cc's, probably no need to spam other lists at this
> point...
>
> On Wed, May 11, 2016 at 04:03:16PM +0200, Stefan Priebe - Profihost AG wrote:
>>
>> Am 11.05.2016 um 15:34 schrieb Brian Foster:
>>> On Wed, May 11, 2016 at 02:26:48PM +0200, Stefan Priebe - Profihost AG wrote:
>>>> Hi Brian,
>>>>
>>>> i'm still unable to grab anything to the trace file? Is there anything
>>>> to check if it's working at all?
>>>>
>>>
>>> See my previous mail:
>>>
>>> http://oss.sgi.com/pipermail/xfs/2016-March/047793.html
>>>
>>> E.g., something like this should work after writing to and removing a
>>> new file:
>>>
>>> # trace-cmd start -e "xfs:xfs_releasepage"
>>> # cat /sys/kernel/debug/tracing/trace_pipe
>>> ...
>>> rm-8198  [000] ....  9445.774070: xfs_releasepage: dev 253:4 ino 0x69 pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 0 unwritten 0
>>
>> arg sorry yes that's working but delalloc is always 0.
>>
>
> Hrm, Ok. That is strange.
>
>> May be i have to hook that into my initramfs to be fast enough?
>>
>
> Not sure that would matter.. you said it occurs within 48 hours? I take
> that to mean it doesn't occur immediately on boot. You should be able to
> tell from the logs or dmesg if it happens before you get a chance to
> start the tracing.
>
> Well, the options I can think of are:
>
> - Perhaps I botched matching up the line number to the warning, in which
>    case we might want to try 'grep -v "delalloc 0 unwritten 0"' to catch
>    any delalloc or unwritten blocks at releasepage() time.
>
> - Perhaps there's a race that the tracepoint doesn't catch. The warnings
>    are based on local vars, so we could instrument the code to print a
>    warning[1] to try and get the inode number.
>
> Brian
>
> [1] - compile tested diff:
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 40645a4..94738ea 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1038,11 +1038,18 @@ xfs_vm_releasepage(
>   	gfp_t			gfp_mask)
>   {
>   	int			delalloc, unwritten;
> +	struct xfs_inode	*ip = XFS_I(page->mapping->host);
>
>   	trace_xfs_releasepage(page->mapping->host, page, 0, 0);
>
>   	xfs_count_page_state(page, &delalloc, &unwritten);
>
> +	if (delalloc || unwritten)
> +		xfs_warn(ip->i_mount,
> +		"ino 0x%llx delalloc %d unwritten %d pgoff 0x%llx size 0x%llx",
> +			 ip->i_ino, delalloc, unwritten, page_offset(page),
> +			 i_size_read(page->mapping->host));
> +
>   	if (WARN_ON_ONCE(delalloc))
>   		return 0;
>   	if (WARN_ON_ONCE(unwritten))
>
>> Stefan
>>
>>> Once that is working, add the grep command to filter out "delalloc 0"
>>> instances, etc. For example:
>>>
>>> 	cat .../trace_pipe | grep -v "delalloc 0" > ~/trace.out
>>>
>>> Brian
>>>
>>>> This still happens in the first 48 hours after a fresh reboot.
>>>>
>>>> Stefan
>>>>
>>>> Am 24.03.2016 um 13:24 schrieb Brian Foster:
>>>>> On Thu, Mar 24, 2016 at 01:17:15PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>
>>>>>> Am 24.03.2016 um 12:17 schrieb Brian Foster:
>>>>>>> On Thu, Mar 24, 2016 at 09:15:15AM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>
>>>>>>>> Am 24.03.2016 um 09:10 schrieb Stefan Priebe - Profihost AG:
>>>>>>>>>
>>>>>>>>> Am 23.03.2016 um 15:07 schrieb Brian Foster:
>>>>>>>>>> On Wed, Mar 23, 2016 at 02:28:03PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>>>> sorry new one the last one got mangled. Comments inside.
>>>>>>>>>>>
>>>>>>>>>>> Am 05.03.2016 um 23:48 schrieb Dave Chinner:
>>>>>>>>>>>> On Fri, Mar 04, 2016 at 04:03:42PM -0500, Brian Foster wrote:
>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 09:02:06PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>> Am 04.03.2016 um 20:13 schrieb Brian Foster:
>>>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 07:47:16PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>>>> Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>> On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
>>>>>>>>>> ...
>>>>>>>>>>>
>>>>>>>>>>> This has happened again on 8 different hosts in the last 24 hours
>>>>>>>>>>> running 4.4.6.
>>>>>>>>>>>
>>>>>>>>>>> All of those are KVM / Qemu hosts and are doing NO I/O except the normal
>>>>>>>>>>> OS stuff as the VMs have remote storage. So no database, no rsync on
>>>>>>>>>>> those hosts - just the OS doing nearly nothing.
>>>>>>>>>>>
>>>>>>>>>>> All those show:
>>>>>>>>>>> [153360.287040] WARNING: CPU: 0 PID: 109 at fs/xfs/xfs_aops.c:1234
>>>>>>>>>>> xfs_vm_releasepage+0xe2/0xf0()
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Ok, well at this point the warning isn't telling us anything beyond
>>>>>>>>>> you're reproducing the problem. We can't really make progress without
>>>>>>>>>> more information. We don't necessarily know what application or
>>>>>>>>>> operations caused this by the time it occurs, but perhaps knowing what
>>>>>>>>>> file is affected could give us a hint.
>>>>>>>>>>
>>>>>>>>>> We have the xfs_releasepage tracepoint, but that's unconditional and so
>>>>>>>>>> might generate a lot of noise by default. Could you enable the
>>>>>>>>>> xfs_releasepage tracepoint and hunt for instances where delalloc != 0?
>>>>>>>>>> E.g., we could leave a long running 'trace-cmd record -e
>>>>>>>>>> "xfs:xfs_releasepage" <cmd>' command on several boxes and wait for the
>>>>>>>>>> problem to occur. Alternatively (and maybe easier), run 'trace-cmd start
>>>>>>>>>> -e "xfs:xfs_releasepage"' and leave something like 'cat
>>>>>>>>>> /sys/kernel/debug/tracing/trace_pipe | grep -v "delalloc 0" >
>>>>>>>>>> ~/trace.out' running to capture instances.
>>>>>>>>
>>>>>>>> Isn't the trace a WARN_ONCE? So it does not reoccur or can i check the
>>>>>>>> it in the trace.out even the WARN_ONCE was already triggered?
>>>>>>>>
>>>>>>>
>>>>>>> The tracepoint is independent from the warning (see
>>>>>>> xfs_vm_releasepage()), so the tracepoint will fire every invocation of
>>>>>>> the function regardless of whether delalloc blocks still exist at that
>>>>>>> point. That creates the need to filter the entries.
>>>>>>>
>>>>>>> With regard to performance, I believe the tracepoints are intended to be
>>>>>>> pretty lightweight. I don't think it should hurt to try it on a box,
>>>>>>> observe for a bit and make sure there isn't a huge impact. Note that the
>>>>>>> 'trace-cmd record' approach will save everything to file, so that's
>>>>>>> something to consider I suppose.
>>>>>>
>>>>>> Tests / cat is running. Is there any way to test if it works? Or is it
>>>>>> enough that cat prints stuff from time to time but does not match -v
>>>>>> delalloc 0
>>>>>>
>>>>>
>>>>> What is it printing where delalloc != 0? You could always just cat
>>>>> trace_pipe and make sure the event is firing, it's just that I suspect
>>>>> most entries will have delalloc == unwritten == 0.
>>>>>
>>>>> Also, while the tracepoint fires independent of the warning, it might
>>>>> not be a bad idea to restart a system that has already seen the warning
>>>>> since boot, just to provide some correlation or additional notification
>>>>> when the problem occurs.
>>>>>
>>>>> Brian
>>>>>
>>>>>> Stefan
>>>>>>
>>>>>> _______________________________________________
>>>>>> xfs mailing list
>>>>>> xfs@oss.sgi.com
>>>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
