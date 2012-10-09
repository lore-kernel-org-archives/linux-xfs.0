Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99MNWdR116011 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 17:23:32 -0500
Message-ID: <5074A3DB.7010007@redhat.com>
Date: Tue, 09 Oct 2012 18:23:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/14] xfs: xfs_sync_data is redundant.
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
	<1349693772-8064-7-git-send-email-david@fromorbit.com>
	<20121009210124.GT13214@sgi.com> <20121009212851.GP23644@dastard>
	<20121009214144.GU13214@sgi.com>
In-Reply-To: <20121009214144.GU13214@sgi.com>
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

On 10/09/2012 05:41 PM, Ben Myers wrote:
> Hey,
> 
> On Wed, Oct 10, 2012 at 08:28:51AM +1100, Dave Chinner wrote:
>> On Tue, Oct 09, 2012 at 04:01:24PM -0500, Ben Myers wrote:
>>> Hi Brain,
>>
>> [Pinky: "Gee, Brain, what do you want to do tonight?"
>>  Brain: "The same thing we do every night, Pinky - try to take over
>>         the world!"]
> 
> Wish I could say I called him 'brain' on purpose.  Will you be playing the part
> of Pinky in today's show?  ;)
>

Heh, it happens more than you would think. ;)

>>> Given that you found the regression in the output of xfstest 273, could you
>>> do us a favor and review the fix and provide your Reviewed-by, and/or
>>> Tested-by?
>>
>> Brian did test it, just as separate patches:
>>
>> http://oss.sgi.com/archives/xfs/2012-10/msg00037.html
> 
> Brian, would you mind extending your Tested-by?
> 

Sure, I tested Dave's change to xfs_flush_inodes() against 273 and ran
another full test against the entire v3 set on that hardware, without
any further noticeable issues.

Tested-by: Brian Foster <bfoster@redhat.com>

Brian

> Regards,
> 	Ben
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
