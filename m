Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63DF0wf093094 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 08:15:00 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M9qaF1AwxlIjw5ST for
	<xfs@oss.sgi.com>; Tue, 03 Jul 2012 06:14:59 -0700 (PDT)
Message-ID: <4FF2F015.6090109@redhat.com>
Date: Tue, 03 Jul 2012 09:13:57 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3] xfs: re-enable xfsaild idle mode and fix associated
	races
References: <1340880776-45730-1-git-send-email-bfoster@redhat.com>
	<20120702000712.GN19223@dastard> <4FF1A324.7070603@redhat.com>
	<20120702235106.GU19223@dastard>
In-Reply-To: <20120702235106.GU19223@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/02/2012 07:51 PM, Dave Chinner wrote:
> On Mon, Jul 02, 2012 at 09:33:24AM -0400, Brian Foster wrote:
>> On 07/01/2012 08:07 PM, Dave Chinner wrote:
>>> On Thu, Jun 28, 2012 at 06:52:56AM -0400, Brian Foster wrote:
>>>> xfsaild idle mode logic currently leads to a couple hangs:
>>>>
>>>> 1.) If xfsaild is rescheduled in during an incremental scan
>>>>     (i.e., tout != 0) and the target has been updated since
>>>>     the previous run, we can hit the new target and go into
>>>>     idle mode with a still populated ail.
>>>> 2.) A wake up is only issued when the target is pushed forward.
>>>>     The wake up can race with xfsaild if it is currently in the
>>>>     process of entering idle mode, causing future wake up
>>>>     events to be lost.
>>>>
>>>> These hangs have been reproduced and verified as fixed by
>>>> running xfstests 273 in a loop on a slightly modified upstream
>>>> kernel. The kernel is modified to re-enable idle mode as
>>>> previously implemented (when count == 0) and with a revert of
>>>> commit 670ce93f, which includes performance improvements that
>>>> make this harder to reproduce.
>>>>
>>>> The solution, the algorithm for which has been outlined by
>>>> Dave Chinner, is to modify xfsaild to enter idle mode only when
>>>> the ail is empty and the push target has not been moved forward
>>>> since the last push.
>>>>
>>>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>>>
>>> Looks OK to me, and hasn't caused any problems here.
>>>
>>> Final question - did you confirm with powertop that the xfsaild is
>>> no longer causing wakeups a minute or two after you stop writing to
>>> the filesystem? (I haven't yet)
>>>
>>
>> I hadn't tested with powertop, but I had some tracepoints hacked in
>> around the idle/wake cases to verify the thread was actually scheduling
>> out.
> 
> If you've added tracepoints that were useful for
> debugging/verification, then send that as a patch as well. If users
> have trouble then simply asking them for event traces is very easy
> to do and gives us much better insight into what is happening....
> 
> You can't have enough tracepoints when things are going wrong ;)
> 

Ok, duly noted. What I have right now is scattered about a few branches
and not immediately presentable. When I get some time I'll fix them up
and post. If I remember correctly, I had covered: xfsaild end (count,
skip, target, etc.), xfsaild idle, xa_target update (xfs_ail_push()) and
xfsaild wake (which might be extraneous at this point).

Brian

>> FWIW, I just gave powertop a quick test and it appears to work as
>> expected...
>>
>> With current upstream on my rhel6.3 VM, I see the following after
>> running a 'touch /mnt/file;sync' and letting the fs idle for a bit:
>>
>>    0.5% ( 19.9)      xfsaild/vdb1 : xfsaild (process_timeout)
>>
>> and this drops off completely with the patch applied. Thanks for the tip.
> 
> Great, then it is working exactly as expected.
> 
> Cheers,
> 
> Dave.
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
