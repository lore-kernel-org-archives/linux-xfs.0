Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 23:52:01 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O6puel019382
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 23:51:57 -0700
Message-ID: <48D9E3E2.3040504@sgi.com>
Date: Wed, 24 Sep 2008 16:53:22 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <20080924060508.GH5448@disturbed>
In-Reply-To: <20080924060508.GH5448@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> [ Pete, please wrap your text at 68-72 columns]
>   
Ok will do in future
> On Wed, Sep 24, 2008 at 02:28:13PM +1000, Peter Leckie wrote:
>   
>> The reason the lsn had changed was due to it not being initialized
>> by  the time a copy of the lsn was taken in xfs_qm_dqflush().
>> The lsn was then latter updated causing the test  in
>> xfs_qm_dqflush_done() to fail.
>>
>> Synchronizations between the 2 functions is done by the pincount
>> in  struct xfs_dquot_t  and xfs_qm_dqflush() calls
>> xfs_qm_dqunpin_wait() to wait for the pincount == 0. However after
>> been woken up it does not validate the pincount is actually 0,
>>     
>
> Sure - that's because we only ever send a wakeup when the pin count
> falls to zero. Because we have to be holding the dquot lock when we
> either pin a dquot or wait for it to be unpinned, the act of waiting
> for it to be unpinned with the dquot lock held guarantees that it
> is not pinned when we wake up.
>
> IOWs, the pin count cannot be incremented while we are waiting for
> it to be unpinned, and hence it must be zero when we are woken......
>
>   
>> allowing a false wake up by the scheduler to  cause
>> xfs_qm_dqflush() to prematurely start processing the dquot.
>>     
>
> .... which means I can't see how that would happen...
>
> What am I missing here?
>   
Yeah it's quite intriguing  isn't it, I added the pincount to the
dquot tracing code and sure enough it's 1 all the way through
xfs_qm_dqflush() I can tell you that none of the XFS code is
causing it to wake up. I was going to add some tracing code to
the scheduler to determine who is causing us to wake up however
I had other priorities to work on.

Reading the code it appears things like a threads dying or a
system suspending can cause it. However none of these had
happened, after reading other examples in the Linux kernel
it appeared pretty standard to always re-evaluate the condition
after being woken so I suspect that Linux simply does not
guarantee that we will only be woken by the thread calling
wake_up on  us.


Any insight into this would be much appreciated as I'm also very curious
as to why this is happening.
> As to the patch, your mailer has whitespace damaged it so you need
> to be fix that up.
>   

Ahh yeah copy and past from a terminal, I'll  fix up the patch and
re-send shortly,

Thanks Dave.

Pete
