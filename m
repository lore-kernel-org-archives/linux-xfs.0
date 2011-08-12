Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CJG2gu079237 for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 14:16:02 -0500
Message-ID: <4E457BEE.7060704@sgi.com>
Date: Fri, 12 Aug 2011 14:15:58 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 6/7] xfsdump: convert to the POSIX signal API
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>	
	<1312497011-24840-7-git-send-email-wkendall@sgi.com>
	<1313012883.2865.139.camel@doink>
In-Reply-To: <1313012883.2865.139.camel@doink>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

On 08/10/2011 04:48 PM, Alex Elder wrote:
> On Thu, 2011-08-04 at 17:30 -0500, Bill Kendall wrote:
>> Convert from using the System V signal API to the POSIX API. For
>> xfsdump, this mostly means replacing sigrelse/sighold with
>> sigprocmask, sigset with sigaction and sigpause with sigsuspend.
>>
>> Note that sigprocmask calls will be replaced with pthread_sigmask
>> when pthread support is added to xfsdump.
>>
>> childmain() and cldmgr_entry() are thread entry points. By the time
>> they are spawned the main thread will have already set its signal
>> mask, so no need to setup signals in the thread as the mask is
>> inherited.
>>
>> ring_slave_entry() is a thread entry point but is spawned before the
>> main thread has its signal mask setup. Setup the thread's mask to
>> block the same signals that the main thread will block.  The main
>> thread should be reworked to set its mask earlier, but that will
>> require a fair amount of refactoring that is beyond the scope of
>> this patch.
>>
>> Also simplify code to generate a core file to just use abort()
>> rather than sending SIGQUIT and then waiting for it to arrive.
>
> This all looks quite good to me.  I have one request
> and one question below.
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>
>
>
>> diff --git a/common/main.c b/common/main.c
>> index 825c894..d3b6662 100644
>> --- a/common/main.c
>> +++ b/common/main.c
>> @@ -545,13 +545,20 @@ main( int argc, char *argv[] )
>>   	 * be released at pre-emption points and upon pausing in the main
>>   	 * loop.
>>   	 */
>> +	
>> +	struct sigaction sa;
>
> Define this at the top of the block please.

Will do.

> Is there any requirement that the fields
> other than sa_flags and sa_handler should
> be zeroed before use?

The sa_sigaction field will only be used if sa_flags
has SA_SIGINFO set, and the sa_restored field is obsolete
and not specified by POSIX. Better to explicitly initialize
everything though, so I'll change that.

>
>> +	sigfillset(&sa.sa_mask);
>> +	sa.sa_flags = 0;
>>
>>   	/* always ignore SIGPIPE, instead handle EPIPE as part
>>   	 * of normal sys call error handling
>>   	 */
>> -	sigset( SIGPIPE, SIG_IGN );
>> +	sa.sa_handler = SIG_IGN;
>> +	sigaction( SIGPIPE,&sa, NULL );
>
> Are you guaranteed that the contents of "sa"
> have not been modified by this call?  I'm just
> asking because you reuse it below and I just
> don't know whether the standard says something
> about it.

Yes, sigaction takes a "const struct sigaction *".

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
