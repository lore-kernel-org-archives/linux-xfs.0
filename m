Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D89097F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 12:01:35 -0500 (CDT)
Subject: Re: [PATCH V3] xfsrestore: fix fs uuid order check for incremental
	restores
References: <20150826213133.GB3902@dastard> <55D5FB95.1280108@sgi.com>
	<20150902132112.GB23587@bfoster.bfoster>
	<20150903234346.2473A600006AF@gulag1.americas.sgi.com>
	<20150908124726.GA5305@bfoster.bfoster>
From: Rich Johnston <rjohnston@sgi.com>
Message-ID: <55F308EE.3010109@sgi.com>
Date: Fri, 11 Sep 2015 12:01:34 -0500
MIME-Version: 1.0
In-Reply-To: <20150908124726.GA5305@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 09/08/2015 07:47 AM, Brian Foster wrote:
> On Thu, Sep 03, 2015 at 06:43:46PM -0500, Rich Johnston wrote:
>> Restoring an incremental level 1 dump will fail with the following error
>> if the fs uuid of the most recent level 0 dump in the inventory does not
>> match level 1 dump we are restoring.

...

>> Index: b/inventory/inv_api.c
>> ===================================================================
>> --- a/inventory/inv_api.c
>> +++ b/inventory/inv_api.c
>> @@ -596,69 +596,78 @@ inv_free_session(

...

>>
>> -	return invmgr_query_all_sessions((void *) &level, /* in */
>> -					 (void **) ses,   /* out */
>> -			       (search_callback_t) lastsess_level_lessthan);
>> +	return invmgr_query_all_sessions(fsidp		 /* fs uuid */
>
> This doesn't compile because of a missing comma after fsidp above.
>
My mistake, happened while cleaning up whitespace.
...

>> Index: b/inventory/inv_mgr.c
>> ===================================================================
>> --- a/inventory/inv_mgr.c
>> +++ b/inventory/inv_mgr.c

...

>> @@ -178,26 +180,27 @@ invmgr_query_all_sessions (
>>   			     "INV: Open failed on %s\n"),
>>   			     fname
>>   			     );
>> -			return BOOL_FALSE;
>> +			continue;
>>   		}
>> -		result = search_invt( invfd, inarg, &objectfound, func );
>> +		result = search_invt(fsidp, invfd, inarg, &objectfound, func);
>>   		close(invfd);		
>>
>>   		/* if error return BOOL_FALSE */
>>   		if (result < 0) {
>> -			return BOOL_FALSE;
>> +			return ret;
>
> Should this always return false? It's now possible to return true if an
> error occurs after we've found one object.

*nod* Thanks I missed that one.

I'll have a V4 out shortly.

--Rich
>
> The rest seems Ok to me.
>
> Brian
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
