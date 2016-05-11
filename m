Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A0E17CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 09:03:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C53788F8035
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 07:03:25 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id tVWcaAhvyQWk0dhh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 07:03:18 -0700 (PDT)
Subject: Re: xfs trace in 4.4.2 / also in 4.3.3 WARNING fs/xfs/xfs_aops.c:1232
	xfs_vm_releasepage
References: <20160304210341.GA8035@bfoster.bfoster>
	<20160305224845.GR30721@dastard> <56F299E3.4020703@profihost.ag>
	<20160323140736.GD43073@bfoster.bfoster>
	<56F3A101.1020300@profihost.ag>
	<56F3A213.2020908@profihost.ag> <20160324111703.GA4068@bfoster.bfoster>
	<56F3DACB.8040305@profihost.ag> <20160324122417.GB4068@bfoster.bfoster>
	<57332508.307@profihost.ag> <20160511133417.GA42410@bfoster.bfoster>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Message-ID: <57333BA4.4040402@profihost.ag>
Date: Wed, 11 May 2016 16:03:16 +0200
MIME-Version: 1.0
In-Reply-To: <20160511133417.GA42410@bfoster.bfoster>
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
Cc: linux-fsdevel@vger.kernel.org, "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


Am 11.05.2016 um 15:34 schrieb Brian Foster:
> On Wed, May 11, 2016 at 02:26:48PM +0200, Stefan Priebe - Profihost AG wrote:
>> Hi Brian,
>>
>> i'm still unable to grab anything to the trace file? Is there anything
>> to check if it's working at all?
>>
> 
> See my previous mail:
> 
> http://oss.sgi.com/pipermail/xfs/2016-March/047793.html
> 
> E.g., something like this should work after writing to and removing a
> new file:
> 
> # trace-cmd start -e "xfs:xfs_releasepage"
> # cat /sys/kernel/debug/tracing/trace_pipe
> ...
> rm-8198  [000] ....  9445.774070: xfs_releasepage: dev 253:4 ino 0x69 pgoff 0x9ff000 size 0xa00000 offset 0 length 0 delalloc 0 unwritten 0

arg sorry yes that's working but delalloc is always 0.

May be i have to hook that into my initramfs to be fast enough?

Stefan

> Once that is working, add the grep command to filter out "delalloc 0"
> instances, etc. For example:
> 
> 	cat .../trace_pipe | grep -v "delalloc 0" > ~/trace.out
> 
> Brian
> 
>> This still happens in the first 48 hours after a fresh reboot.
>>
>> Stefan
>>
>> Am 24.03.2016 um 13:24 schrieb Brian Foster:
>>> On Thu, Mar 24, 2016 at 01:17:15PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>
>>>> Am 24.03.2016 um 12:17 schrieb Brian Foster:
>>>>> On Thu, Mar 24, 2016 at 09:15:15AM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>
>>>>>> Am 24.03.2016 um 09:10 schrieb Stefan Priebe - Profihost AG:
>>>>>>>
>>>>>>> Am 23.03.2016 um 15:07 schrieb Brian Foster:
>>>>>>>> On Wed, Mar 23, 2016 at 02:28:03PM +0100, Stefan Priebe - Profihost AG wrote:
>>>>>>>>> sorry new one the last one got mangled. Comments inside.
>>>>>>>>>
>>>>>>>>> Am 05.03.2016 um 23:48 schrieb Dave Chinner:
>>>>>>>>>> On Fri, Mar 04, 2016 at 04:03:42PM -0500, Brian Foster wrote:
>>>>>>>>>>> On Fri, Mar 04, 2016 at 09:02:06PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>> Am 04.03.2016 um 20:13 schrieb Brian Foster:
>>>>>>>>>>>>> On Fri, Mar 04, 2016 at 07:47:16PM +0100, Stefan Priebe wrote:
>>>>>>>>>>>>>> Am 20.02.2016 um 19:02 schrieb Stefan Priebe - Profihost AG:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> Am 20.02.2016 um 15:45 schrieb Brian Foster <bfoster@redhat.com>:
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> On Sat, Feb 20, 2016 at 09:02:28AM +0100, Stefan Priebe wrote:
>>>>>>>> ...
>>>>>>>>>
>>>>>>>>> This has happened again on 8 different hosts in the last 24 hours
>>>>>>>>> running 4.4.6.
>>>>>>>>>
>>>>>>>>> All of those are KVM / Qemu hosts and are doing NO I/O except the normal
>>>>>>>>> OS stuff as the VMs have remote storage. So no database, no rsync on
>>>>>>>>> those hosts - just the OS doing nearly nothing.
>>>>>>>>>
>>>>>>>>> All those show:
>>>>>>>>> [153360.287040] WARNING: CPU: 0 PID: 109 at fs/xfs/xfs_aops.c:1234
>>>>>>>>> xfs_vm_releasepage+0xe2/0xf0()
>>>>>>>>>
>>>>>>>>
>>>>>>>> Ok, well at this point the warning isn't telling us anything beyond
>>>>>>>> you're reproducing the problem. We can't really make progress without
>>>>>>>> more information. We don't necessarily know what application or
>>>>>>>> operations caused this by the time it occurs, but perhaps knowing what
>>>>>>>> file is affected could give us a hint.
>>>>>>>>
>>>>>>>> We have the xfs_releasepage tracepoint, but that's unconditional and so
>>>>>>>> might generate a lot of noise by default. Could you enable the
>>>>>>>> xfs_releasepage tracepoint and hunt for instances where delalloc != 0?
>>>>>>>> E.g., we could leave a long running 'trace-cmd record -e
>>>>>>>> "xfs:xfs_releasepage" <cmd>' command on several boxes and wait for the
>>>>>>>> problem to occur. Alternatively (and maybe easier), run 'trace-cmd start
>>>>>>>> -e "xfs:xfs_releasepage"' and leave something like 'cat
>>>>>>>> /sys/kernel/debug/tracing/trace_pipe | grep -v "delalloc 0" >
>>>>>>>> ~/trace.out' running to capture instances.
>>>>>>
>>>>>> Isn't the trace a WARN_ONCE? So it does not reoccur or can i check the
>>>>>> it in the trace.out even the WARN_ONCE was already triggered?
>>>>>>
>>>>>
>>>>> The tracepoint is independent from the warning (see
>>>>> xfs_vm_releasepage()), so the tracepoint will fire every invocation of
>>>>> the function regardless of whether delalloc blocks still exist at that
>>>>> point. That creates the need to filter the entries.
>>>>>
>>>>> With regard to performance, I believe the tracepoints are intended to be
>>>>> pretty lightweight. I don't think it should hurt to try it on a box,
>>>>> observe for a bit and make sure there isn't a huge impact. Note that the
>>>>> 'trace-cmd record' approach will save everything to file, so that's
>>>>> something to consider I suppose.
>>>>
>>>> Tests / cat is running. Is there any way to test if it works? Or is it
>>>> enough that cat prints stuff from time to time but does not match -v
>>>> delalloc 0
>>>>
>>>
>>> What is it printing where delalloc != 0? You could always just cat
>>> trace_pipe and make sure the event is firing, it's just that I suspect
>>> most entries will have delalloc == unwritten == 0.
>>>
>>> Also, while the tracepoint fires independent of the warning, it might
>>> not be a bad idea to restart a system that has already seen the warning
>>> since boot, just to provide some correlation or additional notification
>>> when the problem occurs.
>>>
>>> Brian
>>>
>>>> Stefan
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
