Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:42288 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbeBYRrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 12:47:13 -0500
Received: by mail-wr0-f172.google.com with SMTP id k9so18883904wre.9
        for <linux-xfs@vger.kernel.org>; Sun, 25 Feb 2018 09:47:12 -0800 (PST)
Subject: Re: xfs_buf_lock vs aio
References: <20180208221153.GF20266@dastard>
 <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
 <20180214235616.GM7000@dastard>
 <1f90f49b-e11d-3140-f73b-5834e52b5f8a@scylladb.com>
 <20180215213030.GO7000@dastard>
 <946349de-471f-f766-47d8-f32959990cc6@scylladb.com>
 <20180219024055.GW7000@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <ea00b0d5-3d29-d8a7-13f9-83e6a4404192@scylladb.com>
Date: Sun, 25 Feb 2018 19:47:09 +0200
MIME-Version: 1.0
In-Reply-To: <20180219024055.GW7000@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Sorry for the late reply, I was on vacation.


On 02/19/2018 04:40 AM, Dave Chinner wrote:
> On Fri, Feb 16, 2018 at 10:07:55AM +0200, Avi Kivity wrote:
>> On 02/15/2018 11:30 PM, Dave Chinner wrote:
>>> On Thu, Feb 15, 2018 at 11:36:54AM +0200, Avi Kivity wrote:
>>>> On 02/15/2018 01:56 AM, Dave Chinner wrote:
>>>> A little bird whispered in my ear to try XFS_IOC_OPEN_BY_HANDLE to
>>>> avoid the the time update lock, so we'll be trying that next, to
>>>> emulate lazytime.
>>> Biggest problem with that is it requires root permissions. It's not
>>> a solution that can be deployed in practice, so I haven't bothered
>>> suggesting it as something to try.
>>>
>>> If you want to try lazytime, an easier test might be to rebuild the
>>> kernel with this change below to support the lazytime mount option
>>> and not log the timestamp updates. This is essentially the mechanism
>>> that I'll use for this, but it will need to grow more stuff to have
>>> the correct lazytime semantics...
>>>
>> We tried open by handle to see if lazytime would provide relief, but
>> it looks like it just pushes the lock acquisition to another place:
> Whack-a-mole.
>
> This is the whole problem with driving the "nowait" semantics into
> the filesystem implementations - every time we fix one blocking
> point, we find a deeper one, and we have to drive the "nowait"
> semantics deeper into code that should not have to care about IO
> level blocking semantics. And by doing it in a "slap-a-bandaid on
> it" process, we end up with spagetti code that is fragile and
> unmaintainable...

I agree it's not pretty. It would be worse if the kernel did not have 
strict error handling hygiene that allows you to add those EAGAIN 
returns without too much fear.

>
>> However, that function can EAGAIN (it does for IOLOCK) so maybe we
>> can change xfs_ilock to xfs_ilock_nowait and teach it about not
>> waiting for ILOCK too.
> If only it were that simple. Why, exactly, does the direct IO write
> code require the ILOCK exclusive? Indeed, if it goes to allocate
> blocks, we do this:
>
>                  /*
>                   * xfs_iomap_write_direct() expects the shared lock. It
>                   * is unlocked on return.
>                   */
>                  if (lockmode == XFS_ILOCK_EXCL)
>                          xfs_ilock_demote(ip, lockmode);
>
> We demote the lock to shared before we call into the allocation
> code. And for pure direct IO writes, all we care about is ensuring
> the extent map does not change while we do the lookup and check.
> That only requires a shared lock.
>
> So now I've got to go work out why need_excl_ilock() says we need
> an exclusive ilock for direct IO writes when it looks pretty clear
> to me that we don't.
>
> But that's only half the problem. The other problem is that even if
> we take it shared, we're still going to block on IO completion
> taking the ILOCK exclusive to do things like unwritten extent
> completion. So we still need to hack about with "trylock" operations
> into functions into various functions (xfs_ilock_data_map_shared()
> for one).

I'll try your patch and report, thanks.

> What a mess....
>
> Cheers,
>
> Dave.

