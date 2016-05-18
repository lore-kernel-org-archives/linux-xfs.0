Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF2AD7CA1
	for <xfs@oss.sgi.com>; Tue, 17 May 2016 23:45:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 936D3304048
	for <xfs@oss.sgi.com>; Tue, 17 May 2016 21:45:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sbwoVttTPS9eWTEa for <xfs@oss.sgi.com>;
	Tue, 17 May 2016 21:45:07 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 198DB9E
	for <xfs@oss.sgi.com>; Tue, 17 May 2016 23:45:07 -0500 (CDT)
Subject: Re: [PATCH] xfs_quota: only round up timer reporting > 1 day
References: <2ff612ed-4212-922e-49d2-6d5667288622@redhat.com>
	<20160518030850.GA18083@dhcp12-143.nay.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6792df44-1e38-5905-5004-a7aee8ef05e7@sandeen.net>
Date: Tue, 17 May 2016 23:45:06 -0500
MIME-Version: 1.0
In-Reply-To: <20160518030850.GA18083@dhcp12-143.nay.redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com



On 5/17/16 10:08 PM, Zorro Lang wrote:
> On Tue, May 17, 2016 at 02:36:29PM -0500, Eric Sandeen wrote:
>> I was too hasty with:
>>
>> d1fe6ff xfs_quota: remove extra 30 seconds from time limit reporting
>>
>> The point of that extra 30s, turns out, was to allow the user
>> to set a limit, query it, and get back what they just set, if
>> it is set to more than a day.
>>
>> Without it, if we set a grace period to i.e. 3 days, and query it
>> 1 second later, the rounding in the time_to_string function returns
>> "2 days" not "3 days" as it did before, because we are at 
>> 2 days 23:59:59 and it essentially applies a floor() for
>> brevity.  I guess this was confusing.
>>
>> (I've run into this same conundrum on my stove digital timer;
>> if you set it to 10m, it blinks "10" at you twice so that you
>> know what you set, then quickly flips to 9 as it counts down).
>>
>> In some cases, however (and this is the case that prompted the
>> prior patch), we display a full "XYZ days hh:mm:ss" - we do this
>> if the verbose flag is set, or if the timer is less than one day.
>> In these cases, we should not add the 30s, because we are showing
>> full time resolution to the user.
>>
>> Reported-by: Zorro Lang <zlang@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (I don't like my patch title, but I can't think of a better one)
>>
>> diff --git a/quota/util.c b/quota/util.c
>> index 7c43fbd..5e988f9 100644
>> --- a/quota/util.c
>> +++ b/quota/util.c
>> @@ -43,6 +43,18 @@ time_to_string(
>>  		timer = MAX(origin - now, 0);
>>  	}
>>  
>> +	/*
>> +	 * If we are in verbose mode, or if less than a day remains, we
>> +	 * will show "X days hh:mm:ss" so the user knows the exact timer status.
>> +	 *
>> +	 * Otherwise, we round down to the nearest day - so we add 30s here
>> +	 * such that setting and reporting a limit in rapid succession will
>> +	 * show the limit which was just set, rather than immediately reporting
>> +	 * one day less.
>> +	 */
>> +	if ((timer > SECONDS_IN_A_DAY) && !(flags & VERBOSE_FLAG))
>> +		timer += 30;	/* seconds */
>> +
> 
> hmm... you nearly bring "d1fe6ff" back.

Yep :)

But it only messes with "day" reporting, not full-resolution reporting,
which was why I sent that commit in the first place.  I just missed that
it was used for sane "set+query" behavior, until you pointed out the
difference.

> I don't know if +30s is better, but it
> nearly won't effect other things. So looks fine for me:)
> 
> I have changed the timer in my case from "3days" to "73h", it can keep print
> "3day" in one hour, that's enough for my case run over. I saw some other cases
> deal with this problem differently, some cases use a filter likes:
> 
>     sed -e "/\[2 days\]/s/2 days/3 days/g"
> 
> Even if give more 30s, but maybe someone hope to see 3 days become to 2 days
> after sleep 5 seconds(although that's really unnecessary).

Well, at some point it will change as time goes by, of course.

Unfortunately IIRC I couldn't find the reason for the original commit;  it's
been that way for a very longtime.  I just had to infer that it was so
you could set & query and get back the "days" value that was just set.

> So I think the necessary thing is we make a clear decision and tell the "users"
> about the timer problem, tell them we will show +30s(or not), tell them the
> "second" field is always changing, the output can't accurate to the second(it
> always older than the real time). Let them know, and notice that, and deal with
> it by themselves if they need.

Eh, I think this is getting too much into the details.  The user doesn't
need to know all the details of every single programming decision.  :)

-Eric

> Let the documented problem become a known feature, or we maybe always need
> to explain it for someone who feel the timer is not correct:)
> 
> What do you think?
> 
> Thanks,
> Zorro
> 
>>  	days = timer / SECONDS_IN_A_DAY;
>>  	if (days)
>>  		timer %= SECONDS_IN_A_DAY;
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
