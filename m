Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BFF57F3F
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 12:45:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E4418F8073
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 10:45:58 -0700 (PDT)
Message-ID: <5140BB50.9080403@redhat.com>
Date: Wed, 13 Mar 2013 12:45:52 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-3-git-send-email-sandeen@redhat.com>
	<5140BAAC.4050508@sgi.com>
In-Reply-To: <5140BAAC.4050508@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 3/13/13 12:43 PM, Rich Johnston wrote:
> On 03/13/2013 09:57 AM, Eric Sandeen wrote:
>> SCRATCH_DEV_POOL processing actually takes the first
>> device out for SCRATCH_DEV and leaves the rest in
>> SCRATCH_DEV_POOL.
>>
>> I'm not totally sold on that behavior, but for now,
>> at least don't populate SCRATCH_DEV_POOL with newlines.
> 
>>
>> Cc: linux-btrfs@vger.kernel.org
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>   common.config |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/common.config b/common.config
>> index ed0f44c..5ac58bf 100644
>> --- a/common.config
>> +++ b/common.config
>> @@ -258,7 +258,7 @@ if [ ! -z "$SCRATCH_DEV_POOL" ]; then
>>           exit 1
>>       fi
>>       SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>> -    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
>> +    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
>>   fi
>>
>>   echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
>>
> 
> Is the purpose of this patch is so future improvements will be able to parse/use SCRATCH_DEV_POOL easier from within bash?

Yep, and just generally since it's used as an argument, feeding a string w/ newlines to any command is just a bit odd.

-Eric

> Looks good Eric.
> 
> Reviewed-by: <rjohnston@sgi.com>
> 
> Regards
> --Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
