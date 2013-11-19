Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB2CD7F4E
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 17:44:52 -0600 (CST)
Message-ID: <528BF7F2.3050708@sgi.com>
Date: Tue, 19 Nov 2013 17:44:50 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: prevent spurious "head behind tail" warnings
References: <1384900659-22215-1-git-send-email-david@fromorbit.com>
	<528BEF71.1000607@sgi.com> <528BF327.2050802@sandeen.net>
In-Reply-To: <528BF327.2050802@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 11/19/13 17:24, Eric Sandeen wrote:
> On 11/19/13, 5:08 PM, Mark Tinguely wrote:
>> On 11/19/13 16:37, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> When xlog_space_left() cracks the grant head and the log tail, it
>>> does so without locking to synchronise the sampling of the
>>> variables. It samples the grant head first, so if there is a delay
>>> before it smaples the log tail, there is a window where the log tail
>>> could have moved onwards and be moved past the sampled value of the
>>> grant head. This then leads to the "xlog_space_left: head behind
>>> tail" warning message.
>>>
>>> To avoid spurious output in this situation, swap the order in which
>>> the variables are cracked. This means that the head may grant head
>>> may move if there is a delay, but the log tail will be stable, hence
>>> ensure the tail does not jump the head accidentally.
>>>
>>> While this avoids the spurious head behind tail problem, it
>>> introduces the opposite problem - the head can move more than a full
>>> cycle past the tail. The code already handles this case by
>>> indicating that the log is full (i.e. zero space available) but
>>> that's still (generally) a spurious situation.
>>>
>>> Hence, if we detect that the head is more than a cycle ahead of the
>>> tail or the head is behind the tail, start the calculation again by
>>> resampling the variables and trying again. If we get too many
>>> resamples, then throw a warning and return a full or empty log
>>> appropriately.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>
>> I am still getting the debug message:
>>
>>    xlog_verify_grant_tail: space>  BBTOB(tail_blocks)
>>
>> This is a real over grant. It has been a while since I did all the tests, but basically the only way to stop it is to have a lock between checking for xlog_space_left() and actually reserving the space.
>>
>> I am not a fan of another band-aid on a problem that is caused because we are granting space without locks.
>
> Mark, can you remind us of your testcase that produces this?
> (sorry, I guess I should search for that old thread...)
>
> Thanks,
> -Eric
>
>> --Mark.

xfstest 273 hits it 100% of the time for me, as does 32+ process 
fsstress, pretty much any high log usage test.

I know Brian hit this with xfstest 273 when he was testing for commit 
9a3a5dab.

Using xfstest 273, I was seeing ten of thousand of bytes of over commit. 
 From what I recall, I tried a separate lock for the write/reserve grant 
heads, put locks to make sure the verifier was not getting stale 
information, ordered the write/reserve ungrants relative to the grants, 
put in cache smp_mb() call. Some attempts were more successful than 
others, but the only way I could prevent the overgrant completely was to 
put back the global lock between the checking for space and the granting 
of space.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
