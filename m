Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73JSw21174156 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 14:28:58 -0500
Message-ID: <4E39A176.7000906@sgi.com>
Date: Wed, 03 Aug 2011 14:28:54 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org> <4E393AE3.70505@sgi.com>
	<20110803123934.GA13447@infradead.org>
In-Reply-To: <20110803123934.GA13447@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Aug 03, 2011 at 07:11:15AM -0500, Bill Kendall wrote:
>> Right. I wanted to submit the signal changes separately from the
>> threading changes, as the changes were mostly independent except
>> in a couple of areas like this.
> 
> Sounds fine - it's just something I noticed when looking over the code.
> 
>> The original code in ring_slave_entry() changed the (process-wide) signal
>> dispositions. My patch converts these to just block the signals, so I
>> think this is fine?
> 
> It probably is fine, but still not very nice code.  Let's hope we
> can get this sorted out.
> 
>>> I don't think you'll get around splitting drive_init1, so that we can
>>> first open the devices, then do the is pipe check and do the signal
>>> setup based on that, then move on to the remaining drive setup.
>> I thought it might be possible to avoid treating the pipeline case
>> separately. It's not obvious to me why xfsdump has to change its
>> signal handling just because it's in a pipeline. This was something
>> I was planning to look at.
> 
> Good to know.  Maybe the ptools history is able to explain something
> about it?

The original code never blocked signals in 'miniroot', then later code
was added to do the same if in a pipeline. The commit message is of
no help, but reading between the lines I'd say that since a pipeline
implies a single stream, they decided to lump that in with the
single-thread (miniroot) case. Maybe I'm just seeing what I want to
see though. :)

> 
>>> Why yare all these sigaction calls needed?   As far as I can see
>>> there is no way we'll ever use a different signal handler than
>>> "sigaction" for any signal, so simply modifying the signal mask
>>> should be enough.
>> There's actually 2 "sighandler" routines. One in main.c and one in
>> dlog.c. So this does change the handler, it's just that they're
>> poorly named. I'll rename the dlog version when I resubmit.
> 
> You're right.  But looking at the dlog handler I still don't
> like the code there very much.  It just saves the caught signal
> in a global variable.  What if we got more than one signal
> in that section?    Moreover I don't really understand the point
> of the code at all, maybe the lack of existance of the mlog lock
> referred to in your comment in the current is part of that.
> 
> I suspect the problem is that the normal signal handler may acquite
> that lock?  Given that pthread locking primitives are not allowed
> to be called from signal handlers that means there is a bigger
> problem to solve.

Here's some background explaining why things are done as they
are now, from my understanding of the code.

The regular handler won't acquire a lock. The signal handler is
replaced because the rules are different when receiving a signal
while in a dialog. For instance, SIGINT normally means interrupt
the dump session, but in a dialog we just return a caller-supplied
value indicating the interrupt.

When a dialog is required, the caller does this:

    dlog_begin();   // grabs mlog_lock
    dlog_*_query(); // ends up in promptinput()
    dlog_end();     // releases mlog_lock

I think the purpose of holding the lock is simply to prevent
other output on the terminal while waiting for a response.

Any thread may issue a dialog, and it's possible that while
a thread is sitting in a dialog, the main thread may try to
log a message (e.g., progress report) and get blocked on the
mlog lock. At this point nobody would be able to handle signals --
the main thread blocks all signals except while in sigsuspend,
and other threads always block signals. So we unblock the
signals in the current thread to ensure some thread is available
to handle them.

I do have another patch in progress for this area of the code
to remove the use of alarm() for the timeout, as alarm() is
already used in the main thread. It also addresses an issue in
the existing code which relies on the current thread receiving
the signal. If another thread receives it, we won't come out of
the read(). If you have suggestions on others ways to clean
this up, I'd be happy to hear them.

Thanks,
Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
