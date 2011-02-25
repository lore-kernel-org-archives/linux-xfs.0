Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PL0i04222968 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 15:00:45 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1CC3304070
	for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 13:03:28 -0800 (PST)
Message-ID: <4D681924.7030707@sgi.com>
Date: Fri, 25 Feb 2011 15:03:32 -0600
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: prune inventory sessions by session id
References: <1298564720-11447-1-git-send-email-wkendall@sgi.com>
	<1298662049.1990.7053.camel@doink>
In-Reply-To: <1298662049.1990.7053.camel@doink>
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

On 02/25/2011 01:27 PM, Alex Elder wrote:
> On Thu, 2011-02-24 at 10:25 -0600, Bill Kendall wrote:
>> Allow xfsinvutil to prune inventory sessions by their ID
>> instead of only by filesystem and cutoff date.
>
> This would have been a bit nicer with a little more
> explanation.  I.e.:
> - You specify the session id using the new "-s<sessid>"
>    command line option.
> - The "-s" option is mutually exclusive with "-u<UUID>"
>    and "-M<mount_point>  <mm/dd/yy>".  It also cannot be
>    used together with the "-i" (interactive) or "-C"
>    (consistency check) options.
> - The change is implemented by adding a session id argument
>    to CheckAndPruneFstab(), CheckAndPruneInvIndexFile(), and
>    CheckAndPruneStObjFile().  That session becomes a third
>    way of identifying entries to be pruned (in addition
>    to mount point and UUID).

Feel free to amend the commit message when you check this
in. I agree that at least it should have mentioned that
this adds a new xfsinvutil -s option.

>
> Anyway, this looks good to me.  I have one question
> below, but regardless of your answer...
>
> Reviewed-by: Alex Elder<aelder@sgi.com>
>
>> Signed-off-by: Bill Kendall<wkendall@sgi.com>
>>
>> ---
> . . .
>
>> diff --git a/invutil/invutil.c b/invutil/invutil.c
>> index af6836b..37489c0 100644
>> --- a/invutil/invutil.c
>> +++ b/invutil/invutil.c
>
> . . .
>
>> @@ -594,14 +648,8 @@ CheckAndPruneInvIndexFile( bool_t checkonly,
>>   	    removeflag = BOOL_TRUE;
>>   	}
>>
>> -	if (( !removeflag )&&  (checkonly == BOOL_FALSE)&&
>> -		( invIndexEntry[i].ie_timeperiod.tp_start<  prunetime))
>> -	{
>> -	    IdxCheckOnly = BOOL_FALSE;
>> -	    printf("          Mount point match\n");
>> -	}
>
> Why do you no longer print this in this case?

The message did not seem to serve a purpose. To reach the print
we already had to match on the mount point, and a message is
already issued for that.

As you probably noticed, the 'if' statement did not serve a
functional purpose since the prune time has to be checked for
each session anyway, and further the 'if' statement would have
to be reworked to consider whether this is a prune-by-session run.

As a side note, it's too bad that the consistency checking and
pruning is coupled together. It would be much cleaner to
implement the various pruning filters as separate functions.

Bill

>
>> -	if (CheckAndPruneStObjFile(IdxCheckOnly, invIndexEntry[i].ie_filename,
>> -		    prunetime, r_mf_label) == -1) {
>> +	if (CheckAndPruneStObjFile(checkonly, invIndexEntry[i].ie_filename,
>> +		    sessionp, prunetime, r_mf_label) == -1) {
>>   	    removeflag = BOOL_TRUE; /* The StObj is gone */
>>   	}
>>
>
> . . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
