Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LIFH3Y238604 for <xfs@oss.sgi.com>; Mon, 21 May 2012 13:15:17 -0500
Message-ID: <4FBA863B.4040801@redhat.com>
Date: Mon, 21 May 2012 14:15:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 2/3] xfs: fix xfsaild hang due to premature idle
References: <1337620886-41807-1-git-send-email-bfoster@redhat.com>
	<1337620886-41807-3-git-send-email-bfoster@redhat.com>
	<20120521181232.GS16099@sgi.com>
In-Reply-To: <20120521181232.GS16099@sgi.com>
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

On 05/21/2012 02:12 PM, Ben Myers wrote:
> Hey Brian,
> 
> On Mon, May 21, 2012 at 01:21:25PM -0400, Brian Foster wrote:
>> Running xfstests 273 in a loop reproduces an XFS lockup due to
>> xfsaild entering idle mode indefinitely. The following
>> high-level sequence of events leads to the hang:
>>
>> - xfsaild is running, hits the stuck item threshold and reschedules,
>>   setting xa_last_pushed_lsn appropriately.
>> - xa_threshold is updated.
>> - xfsaild restarts from the previous xa_last_pushed_lsn, hits the
>>   new target and enters idle mode, even though the previously
>>   stuck items still populate the ail.
>>
>> Modify the tout logic to only enter idle mode when the ail is empty.
>> IOW, if we hit the target but did not perform the current scan from
>> the start of the ail, reschedule at least one more time.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Thanks for the patch.  Unfortunately it does not apply cleanly.  Care to spin it again?
> 

Hmm... thought I rebased, but apparently not. Sorry about that, I'll repost...

Brian

> Regards,
> 	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
