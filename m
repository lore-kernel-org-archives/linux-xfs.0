Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4THsgIV013373 for <xfs@oss.sgi.com>; Tue, 29 May 2012 12:54:42 -0500
Message-ID: <4FC50D5B.8010803@redhat.com>
Date: Tue, 29 May 2012 13:54:35 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs:  shutdown xfs_sync_worker before the log
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
	<20120525204536.GA4721@sgi.com> <20120529150715.GB4721@sgi.com>
	<4FC4ED13.6030904@redhat.com> <20120529170430.GC4721@sgi.com>
In-Reply-To: <20120529170430.GC4721@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On 05/29/2012 01:04 PM, Ben Myers wrote:
> Hey Brian,
> 
> On Tue, May 29, 2012 at 11:36:51AM -0400, Brian Foster wrote:
>> On 05/29/2012 11:07 AM, Ben Myers wrote:
>>> On Fri, May 25, 2012 at 03:45:36PM -0500, Ben Myers wrote:
>>>> On Thu, May 24, 2012 at 05:39:52PM -0500, Ben Myers wrote:
>>>>> Anyway, I'll make some time to work on this tomorrow so I can test it
>>>>> over the weekend.
>>>>
>>>> This is going to spin over the weekend.  See what you think.
>>>
>>> I'm reasonably satisfied with the test results over the weekend.  I did end
>>> up hitting an unrelated assert:
>>
>> I started testing the xfsaild idle patch based against the xfs tree over the
>> weekend (after testing successfully against Linus' tree for several days) and
>> reproduced the xfs_sync_worker() hang that Mark alerted me to last week.  I
>> was considering doing a bisect in that tree since it doesn't occur in Linus'
>> tree, but it sounds like I can pull this patch now and shouldn't expect to
>> reproduce the sync_worker() hang either, correct? Thanks.
> 
> D'oh!  The xfs_sync_worker hang that Mark mentioned last week is when the sync
> worker blocks on log reservation for the dummy transaction used to cover the
> log, which means that it will not be calling xfs_ail_push_all, which might have
> the effect of loosening things up a bit.
> 
> This thread is about a crash due to the xfs_sync_worker racing with unmount.  A
> fix for this crash is in Linus' tree as of late last week.  Here we're looking
> into replacing the existing fix with something that is a bit cleaner.  s_umount
> is overkill for this situation, so now we're calling cancel_delayed_work_sync
> to shutdown the sync_worker before shutting down the log in order to prevent
> the crash.
> 
> Unfortunately this fix won't help you with the hang.  If you're considering
> bisecting this, I think that Juerg Haefliger has reproduced a/the log hang all
> the way back to 2.6.38.  Also Chris J Arges has reproduced one on 2.6.32.52.
> 
> See thread 'Still seeing hangs in xlog_grant_log_space'.  The log hang is a
> wily coyote.  ;)
> 

Ah, ok. Thanks for the context and sorry for the noise in this thread. I
do find it interesting that I hit this rather quickly after so many
hours of testing on Linus' tree without seeing it once.

I didn't reproduce at the -rc2 tag in the xfs tree. That isn't too many
bisections so perhaps I'll just carry on with the bisect since I need to
gauge how often this occurs anyways. It will either prove my test as a
sporadic reproducer and not provide anything useful, or I get lucky and
maybe find a useful data point. If the latter, I'll carry it over to the
right thread... ;)

Brian

> Regards,
> Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
