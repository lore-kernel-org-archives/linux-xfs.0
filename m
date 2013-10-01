Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DB9F29DFB
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 17:19:10 -0500 (CDT)
Message-ID: <524B4A58.3050607@sgi.com>
Date: Tue, 1 Oct 2013 17:19:04 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: add locks around the inventory put
References: <524AF8C3.8020904@sgi.com> <524B395C.6030705@sandeen.net>
In-Reply-To: <524B395C.6030705@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>



On 10/01/2013 04:06 PM, Eric Sandeen wrote:
> hi Rich -
>
> On 10/1/13 11:30 AM, Rich Johnston wrote:
>> From: Phil White <cerise-xfs@l.armory.com>
>>
>> Add locks around the inventory put to prevent inventory
>> corruption.
>>
>> Signed-off-by: Phil White <cerise-xfs@l.armory.com>
>
> Similar questions here; it says it's thread-safe, but apparently
> not.  But why not?  what happens?  Is there a testcase?

Phil worked on this for a long time. To my knowledge the corruption 
occured with multistream dumps only.  I did not change his code but we 
have had reports from the field on corruption when using multistream 
dumps which does not occur with this fix.

Not sure what else Phil did to reproduce this other than a multistream 
dump/restore (20 streams), which fails.

Testcase?? Good point I need to submit a testcase for both patches.

>
> (you guys probably have longer history in ptools, maybe you
> can see what if anything changed since the original comment
> was added - or maybe when it was added, etc?)
>
I did not look into this further, I will see if there is a better 
explaination in our bug writeup.

> Thanks,
> -Eric
>
>> diff --git a/dump/content.c b/dump/content.c
>> index ac19021..b8977bb 100644
>> --- a/dump/content.c
>> +++ b/dump/content.c
>> @@ -2550,8 +2550,11 @@ decision_more:
>>                          scwhdrp->cih_startpt.sp_offset );
>>               }
>>
>> -            /* already thread-safe, don't need to lock
>> +            /* Supposedly already thread-safe, according to the
>> +             * previous revisions, but corruption of inventory
>> +             * objects can occur.
>>                */
>>                */
>> +            lock();
>>               ok = inv_put_mediafile( inv_stmt,
>>                           &mwhdrp->mh_mediaid,
>>                           mwhdrp->mh_medialabel,
>> @@ -2565,6 +2568,7 @@ decision_more:
>>                           &&
>>                           ! empty_mediafile,
>>                           BOOL_FALSE );
>> +            unlock();
>>               if ( ! ok ) {
>>                   mlog( MLOG_NORMAL, _(
>>                         "inventory media file put failed\n") );
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
