Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73CBJQk151965 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 07:11:20 -0500
Message-ID: <4E393AE3.70505@sgi.com>
Date: Wed, 03 Aug 2011 07:11:15 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] xfsdump: convert to the POSIX signal API
References: <1311972011-1446-1-git-send-email-wkendall@sgi.com>
	<1311972011-1446-5-git-send-email-wkendall@sgi.com>
	<20110803104813.GA3575@infradead.org>
In-Reply-To: <20110803104813.GA3575@infradead.org>
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
> On Fri, Jul 29, 2011 at 03:40:11PM -0500, Bill Kendall wrote:
>> Convert from using the System V signal API to the POSIX API. For
>> xfsdump, this mostly means replacing sigrelse/sighold with
>> sigprocmask, sigset with sigaction, and sigpause with sigsuspend.
>>
>> childmain() and cldmgr_entry() are thread entry points. By the time
>> they are spawned the main thread will have already set its signal
>> mask, so no need to setup signals in these threads as the mask is
>> inherited.
> 
>>From reading the code that means they actually can't be reached in
> a Linux build at the moment, given that the sproc stub will always
> return -1.

Right. I wanted to submit the signal changes separately from the
threading changes, as the changes were mostly independent except
in a couple of areas like this.

> 
>> ring_slave_entry() is a thread entry point but is spawned before the
>> main thread has its signal mask setup. Setup the thread's mask to
>> block the same signals that the main thread will block.  The main
>> thread should be reworked to set its mask earlier, but that will
>> require a fair amount of refactoring that is beyond the scope of
>> this patch.
> 
> What thread model are you going to use for the multithreaded xfsdump?
> 
> If it's pthreads the signal handlers and the main signal mask are shared
> by all threads, so setting them in ring_slave_entry will affect the whole
> process.  We can do per-thread blocking/unblocking using pthread_sigmask,
> but we can't have per-signal handlers.

Yes, it will be pthreads. My threading series converts all the sigprocmask
calls to pthread_sigmask once xfsdump links with libpthread. Should have
mentioned that in the patch description.

The original code in ring_slave_entry() changed the (process-wide) signal
dispositions. My patch converts these to just block the signals, so I
think this is fine?

> 
> I don't think you'll get around splitting drive_init1, so that we can
> first open the devices, then do the is pipe check and do the signal
> setup based on that, then move on to the remaining drive setup.

I thought it might be possible to avoid treating the pipeline case
separately. It's not obvious to me why xfsdump has to change its
signal handling just because it's in a pipeline. This was something
I was planning to look at.

> 
> Any chance you could throw in a patch to clean that area up a bit?
> Currently ring_create gets a threadfunc argument, which has two
> different but identical implementations.  Moving the small content
> of the two ring_thread implementations directly into ring_create
> would make this a tad more readable.

Sure, I'll submit that as a separate patch.

> 
>> @@ -374,13 +371,14 @@ promptinput( char *buf,
>>  {
>>  	va_list args;
>>  	u_intgen_t alarm_save = 0;
>> -	void (* sigalrm_save)(int) = NULL;
>> -	void (* sigint_save)(int) = NULL;
>> -	void (* sighup_save)(int) = NULL;
>> -	void (* sigterm_save)(int) = NULL;
>> -	void (* sigquit_save)(int) = NULL;
>> +	sigset_t dlog_set, orig_set;
>> +	struct sigaction sa;
>> +	struct sigaction sigalrm_save;
>> +	struct sigaction sigint_save;
>> +	struct sigaction sighup_save;
>> +	struct sigaction sigterm_save;
>> +	struct sigaction sigquit_save;
>>  	intgen_t nread;
>> -	pid_t pid = getpid( );
>>  
>>  	/* display the pre-prompt
>>  	 */
>> @@ -400,38 +398,39 @@ promptinput( char *buf,
>>  	mlog( MLOG_NORMAL | MLOG_NOLOCK | MLOG_BARE, promptstr );
>>  
>>  	/* set up signal handling
>> +	 * the mlog lock is held for the life of the dialog and it's possible
>> +	 * the main thread, which normally does the signal handling, is now
>> +	 * waiting on the mlog lock trying to log a message. so we unblock
>> +	 * the relevant signals for this thread. note this means the current
>> +	 * thread or the main thread might handle one of these signals.
>>  	 */
>> +	sigemptyset( &dlog_set );
>> +	sa.sa_handler = sighandler;
>> +	sigfillset( &sa.sa_mask );
>> +	sa.sa_flags = 0;
>>  	dlog_signo_received = -1;
>>  	if ( dlog_timeouts_flag && timeoutix != IXMAX ) {
>> +		sigaddset( &dlog_set, SIGALRM );
>> +		sigaction( SIGALRM, &sa, &sigalrm_save );
> 
> Why yare all these sigaction calls needed?   As far as I can see
> there is no way we'll ever use a different signal handler than
> "sigaction" for any signal, so simply modifying the signal mask
> should be enough.

There's actually 2 "sighandler" routines. One in main.c and one in
dlog.c. So this does change the handler, it's just that they're
poorly named. I'll rename the dlog version when I resubmit.

> 
>> @@ -554,22 +557,32 @@ main( int argc, char *argv[] )
>>  		sigquit_received = BOOL_FALSE;
>>  		sigstray_received = BOOL_FALSE;
>>  		prbcld_cnt = 0;
>> +
>>  		alarm( 0 );
>> +
>> +		sigemptyset( &blocked_set );
>> +		sigaddset( &blocked_set, SIGINT );
>> +		sigaddset( &blocked_set, SIGHUP );
>> +		sigaddset( &blocked_set, SIGTERM );
>> +		sigaddset( &blocked_set, SIGQUIT );
>> +		sigaddset( &blocked_set, SIGALRM );
>> +		sigprocmask( SIG_SETMASK, &blocked_set, NULL );
>> +
>> +		sa.sa_handler = sighandler;
>> +		sigfillset(&sa.sa_mask);
>> +		sa.sa_flags = 0;
>> +
>> +		sigaction( SIGINT, &sa, NULL );
>> +		sigaction( SIGHUP, &sa, NULL );
>> +		sigaction( SIGTERM, &sa, NULL );
>> +		sigaction( SIGQUIT, &sa, NULL );
>> +		sigaction( SIGALRM, &sa, NULL );
>>  
>>  		/* ignore SIGPIPE, instead handle EPIPE as part
>>  		 * of normal sys call error handling
>>  		 */
>> -		sigset( SIGPIPE, SIG_IGN );
>> +		sa.sa_handler = SIG_IGN;
>> +		sigaction( SIGPIPE, &sa, NULL );
>>  	}
>>  
>>  	/* do content initialization.
>> @@ -588,16 +601,22 @@ main( int argc, char *argv[] )
>>  	 * with just one stream.
>>  	 */
>>  	if ( miniroot || pipeline ) {
>> +		struct sigaction sa;
>>  		intgen_t exitcode;
>>  
>> -		sigset( SIGINT, sighandler );
>> -		sigset( SIGHUP, sighandler );
>> -		sigset( SIGTERM, sighandler );
>> +		sa.sa_handler = sighandler;
>> +		sigfillset(&sa.sa_mask);
>> +		sa.sa_flags = 0;
>> +
>> +		sigaction( SIGINT, &sa, NULL );
>> +		sigaction( SIGHUP, &sa, NULL );
>> +		sigaction( SIGTERM, &sa, NULL );
>>  
>>  		/* ignore SIGPIPE, instead handle EPIPE as part
>>  		 * of normal sys call error handling
>>  		 */
>> -		sigset( SIGPIPE, SIG_IGN );
>> +		sa.sa_handler = SIG_IGN;
>> +		sigaction( SIGPIPE, &sa, NULL );
> 
> Why do we have to do this setup here again?  We just did it a few
> lines above, just separated by the content_init call.  While the dump
> content_init seems to temporarily enabled these signals, it also
> seems to undo that properly.  Given that structure of content_init
> it's not easy to verify that it doesn't miss any, but the right fix
> is to restructure that code using goto based unwinding and return
> to the caller inthe state iwas left in.

Sure, will make that change.

> 
> I don't think there is a point to re-ignore SIGPIPE either way.
> 
> 
> 
>> +			sigprocmask( SIG_SETMASK, &orig_set, NULL );
>>  			return BOOL_FALSE;
>>  		}
>>  
>> @@ -1782,16 +1783,12 @@ baseuuidbypass:
>>  				free( ( void * )drvpath );
>>  			}
>>  			if ( sc_inv_stmtokenp[ strmix ] == INV_TOKEN_NULL ) {
>> -				( void )sigrelse( SIGINT );
>> -				( void )sigrelse( SIGQUIT );
>> -				( void )sigrelse( SIGHUP );
>> +				sigprocmask( SIG_SETMASK, &orig_set, NULL );
>>  				return BOOL_FALSE;
> 
> As mentioned before adding an out_unmask label to this function which
> restores the mask and then returns the boolean retval variable would
> make the code a lot easier to audit.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
