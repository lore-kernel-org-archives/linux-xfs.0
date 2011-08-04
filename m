Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74CZ8KV068891 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 07:35:08 -0500
Message-ID: <4E3A91F8.3080606@sgi.com>
Date: Thu, 04 Aug 2011 07:35:04 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org> <4E393AE3.70505@sgi.com>
	<20110803123934.GA13447@infradead.org> <4E39A176.7000906@sgi.com>
	<20110804075331.GA8836@infradead.org>
In-Reply-To: <20110804075331.GA8836@infradead.org>
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

On 08/04/2011 02:53 AM, Christoph Hellwig wrote:
> On Wed, Aug 03, 2011 at 02:28:54PM -0500, Bill Kendall wrote:
>> Here's some background explaining why things are done as they
>> are now, from my understanding of the code.
>>
>> The regular handler won't acquire a lock. The signal handler is
>> replaced because the rules are different when receiving a signal
>> while in a dialog. For instance, SIGINT normally means interrupt
>> the dump session, but in a dialog we just return a caller-supplied
>> value indicating the interrupt.
>>
>> When a dialog is required, the caller does this:
>>
>>     dlog_begin();   // grabs mlog_lock
>>     dlog_*_query(); // ends up in promptinput()
>>     dlog_end();     // releases mlog_lock
>>
>> I think the purpose of holding the lock is simply to prevent
>> other output on the terminal while waiting for a response.
>
> Ok, that makes some sense.
>
>> Any thread may issue a dialog, and it's possible that while
>> a thread is sitting in a dialog, the main thread may try to
>> log a message (e.g., progress report) and get blocked on the
>> mlog lock. At this point nobody would be able to handle signals --
>> the main thread blocks all signals except while in sigsuspend,
>> and other threads always block signals. So we unblock the
>> signals in the current thread to ensure some thread is available
>> to handle them.
>
> Unblocking the signals during the dialog, but still using the normal
> signal handler for it would solve that problem, right?

Right, with some rework of that handler. It would have to do
something like:

   case SIGINT:
       if (is_dialog_active(SIGINT))
           dlg_sigterm_received = BOOL_TRUE;
       else
           sigterm_received = BOOL_TRUE;

(The SIGINT param is needed because it's optional whether a
dialog handles a particular signal.)

Otherwise we'd race between main's use of sigterm_received and
the dialog's need to use it.

Do you prefer this over the signal handler swap?

>
> Btw, I looked over the main sighandler a bit, and it seems like most
> of it can simply go away for a pthreaded variant - there is no need
> to handle SIGCLD, and all threads have the same pid, so basically
> what is left is SIGHUP/SIGTERM/SIGINT/SIGQUIT handling, which does
> nothing but a dlog_desist in most cases and setting the sigfoo_received
> variable.

Yes, the previous patch in this series takes care of that. :)

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
