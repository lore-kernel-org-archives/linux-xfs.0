Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4028F7F63
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 09:12:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AB354AC004
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 07:12:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IXSv2LhoHzHQltMt for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 07:12:55 -0700 (PDT)
Message-ID: <519CD268.10306@sandeen.net>
Date: Wed, 22 May 2013 09:12:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests comma separated group names
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
	<20130520113045.GB24543@dastard>
	<CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
	<20130521004553.GL24543@dastard>
	<CANW9uyvUgS6i+z0iUtyuJDe2YhbtnVYmYs87xB74=fJCMuG06Q@mail.gmail.com>
	<20130521052118.GM24543@dastard>
In-Reply-To: <20130521052118.GM24543@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>, xfs@oss.sgi.com

On 5/21/13 12:21 AM, Dave Chinner wrote:
> On Tue, May 21, 2013 at 12:45:32PM +0900, Itaru Kitayama wrote:
>> In the current check script the -g option assumes only one group is given.
>> With this patch, the -g option
>> understands comma separated multiple groups as the argument as well.
>> Existing scripts are not affected
>> by this patch.
>>
>> Reviewed-by: Dave Chinner <david@redhat.com>
> 
> No, I didn't. A comment on a patch is not a review.
> 
> The only time you should add tags like this is if you receive them
> in email from the person in question. Once I've actaully done a
> review of the code, I'll respond with such a tag. See
> Documentation/SubmittingPatches for more information about what the
> reviewed-by tag actually means...
> 
>> Signed-off-by: Itaru Kitayama <itaru.kitayama@gmail.com>
>>
>> ---
>>
>>  check |   23 ++++++++++++-----------
>>  1 file changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/check b/check
>> index a79747e..0e0f208 100755
>> --- a/check
>> +++ b/check
>> @@ -164,18 +164,19 @@ while [ $# -gt 0 ]; do
>>         -nfs)   FSTYP=nfs ;;
>>
>>         -g)     group=$2 ; shift ;
>> -               group_list=$(get_group_list $group)
>> -               if [ -z "$group_list" ]; then
>> -                   echo "Group \"$group\" is empty or not defined?"
>> -                   exit 1
>> -               fi
>> -
>> -               [ ! -s $tmp.list ] && touch $tmp.list
>> -               for t in $group_list; do
>> -                       grep -s "^$t\$" $tmp.list >/dev/null || \
>> -                                                       echo "$t"
>>>> $tmp.list
> 
> There's a whitespace and wrapping problem with your mailer. it's
> converting all tabs to spaces, and it's wrapping long lines in the
> patch. Please see Documentation/email-clients.txt for help to set
> your mailer up properly.

Dave is a tough teacher but you can learn a lot from him.  ;)

Thanks for sending the patch, I agree that this will be nice to have,
once the patch submission issues get fixed up.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
