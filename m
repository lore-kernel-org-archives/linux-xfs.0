Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 68F147CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:20:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E7C1304048
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 12:20:04 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id SWD6Se7J34vImdgy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 12:19:59 -0700 (PDT)
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
Message-ID: <573385EA.6050603@profihost.ag>
Date: Wed, 11 May 2016 21:20:10 +0200
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

OK i changed the grep command.

>
> - Perhaps there's a race that the tracepoint doesn't catch. The warnings
>    are based on local vars, so we could instrument the code to print a
>    warning[1] to try and get the inode number.

Thx i also added your patch.

So we need to wait another 48h.

Greets,
Stefan

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
