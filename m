Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TFKuML077834 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 10:20:56 -0500
Message-ID: <4E5BAE54.9070401@sgi.com>
Date: Mon, 29 Aug 2011 10:20:52 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: call mlog_exit in content_stream_restore
References: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
	<1314375344.2821.47.camel@doink>
In-Reply-To: <1314375344.2821.47.camel@doink>
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

Alex Elder wrote:
> On Mon, 2011-08-15 at 13:59 -0500, Bill Kendall wrote:
>> This patch adds mlog_exit() calls to all the return paths in
>> content_stream_restore(). mlog_exit() is supposed to be called before
>> returning from content_stream_dump() and content_stream_restore(), but
>> many paths in the latter did not do so, allowing for the stream exit
>> status to be incorrect.
>>
>> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> It looks like content_stream_restore() *never* used it.

You are right. I was thinking of calls to mlog_exit_hint() from functions
called by content_stream_restore().

> 
> Looking at _mlog_exit(), it looks to me like it could
> benefit from using exit_codestring() rather than the
> exit_strings[] array (which could be deleted).  This
> would report "EXIT_ERROR" instead of just "ERROR" though,
> and normal exit would be reported as "EXIT_NORMAL"
> rather than "SUCCESS".   The function call is more
> resilient though because it handles any value it's
> passed (whereas one could conceivably index beyond
> the end of the exit_strings[] array).
> 
> Just a thought--a suggestion for a future patch.

Currently the stream exit status ("EXIT_*") is not printed on Linux, due
to only supporting a single stream. So we have some flexibility there.
i.e., exit_codestring() could return "ERROR" instead of "EXIT_ERROR".

> 
> More suggestions below.  They apply to pretty much
> the whole thing so I've put it all at the bottom.

...

>> @@ -2545,7 +2545,7 @@ content_stream_restore( ix_t thrdix )
>>  #ifndef EOMFIX
>>  		Media_end( Mediap );
>>  #endif /* ! EOMFIX */
> 
> These #ifdef's are pretty yucky.
> 
> Another suggested future cleanup:  Add a flag to Media_end() to
> indicate whether this is one of those #ifdef's calls, and
> within Media_end() use a single #ifdef to determine whether
> simply return or actually do it, based on that passed-in value.
> Then just call Media_end() in all spots without the #ifdef's.
> 
>> -		return EXIT_NORMAL;
>> +		return mlog_exit(EXIT_NORMAL, RV_DONE);
>>  	}
>>  	tranp->t_sync5 = SYNC_BUSY;
>>  	unlock( );

EOMFIX is always defined, it really shouldn't be conditional code anymore.
I was planning to take care of that in a future patch, but since it may
cleanup this patch a bit I'll do the EOMFIX patch first and resubmit this
afterwards. There's also a number of other #defines that should go away,
I'll look at those as well.

> 
> . . .
> 
>> @@ -2588,7 +2588,7 @@ content_stream_restore( ix_t thrdix )
>>  #ifndef EOMFIX
>>  	Media_end( Mediap );
>>  #endif /* ! EOMFIX */
>> -	return EXIT_NORMAL;
>> +	return mlog_exit(EXIT_NORMAL, rv);
> 
> If you kept this line as-is, use RV_OK rather than rv,
> since it makes it more explicit we know that's what's
> getting returned.  The same would hold in many spots
> above as well.

I'll take a look at doing this.

> 
> But...
> 
> The end of this function is a whole bunch of repetitive
> code.  It would be cleaner to assign a "ret" variable
> (or whatever name you think fits the existing code)
> and then after this last switch statement call:
> 
> 	return mlog_exit(ret, rv);
> 
> (If Media_end() got a flag, you might not need the
> switch statement at all...)

Still need to map the RVAL_* value from finalize() to
the right EXIT_*, so the switch cannot be removed
altogether but can be simplified.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
