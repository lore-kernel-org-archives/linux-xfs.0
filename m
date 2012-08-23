Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NGBniu019395 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 11:11:49 -0500
Message-ID: <50365669.2090202@sgi.com>
Date: Thu, 23 Aug 2012 11:12:25 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: Replace lstat64 with cat in test 120
References: <20120822185456.4F189B010E6D@gulag1.americas.sgi.com>
	<5035481C.5050503@inktank.com>
In-Reply-To: <5035481C.5050503@inktank.com>
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
To: Alex Elder <elder@inktank.com>
Cc: xfs@oss.sgi.com

On 08/22/2012 03:59 PM, Alex Elder wrote:
> On 08/22/2012 01:54 PM, Rich Johnston wrote:
>> The later versions of libtool (i.e.2.4+) create a wrapper (bash script) for
>> lstat64 in the src directory.  The wrapper calls the real binary created by
>> libtool (.libs/lstat64)
>>
>> Test 120 only copies src/lstat64 to $SCRATCH_MNT.  If a later version of
>> libtool is used then only the wrapper is copied to $SCRATCH_MNT and the wrapper
>> will fail to find .libs/lstat64.
>>
>>     ~/xfstests # diff 120.out 120.out.bad
>>     /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
>>     This script is just a wrapper for lstat64.
>>     See the libtool documentation for more information.
>>
>> This patch copies /usr/bin/cat (which is readily availible on unix systems) to
>> $SCRATCH_MNT instead of src/lstat64.
>
> I was going to suggest you use /bin/cat instead, but it appears
> the actual patch does.
>
> Please update your description.  Otherwise, looks good to me.

Thanks for the review Alex.  Good catch, yes I will correct it when I 
commit this patch along with a few Description corrections pointed out 
by Dave C.

--Rich
>
> Reviewed-by: Alex Elder <elder@inktank.com>
>
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>>
>> ---
>>   120 |    8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> Index: b/120
>> ===================================================================
>> --- a/120
>> +++ b/120
>> @@ -68,12 +68,12 @@ fi
>>
>>   #executable file
>>   echo "*** copying file ***"
>> -cp src/lstat64 $SCRATCH_MNT
>> -src/lstat64 $SCRATCH_MNT/lstat64 >$tmp.out
>> +cp /bin/cat $SCRATCH_MNT
>> +src/lstat64 $SCRATCH_MNT/cat >$tmp.out
>>   sleep 5
>>   echo "*** executing file ***"
>> -$SCRATCH_MNT/lstat64 $SCRATCH_MNT/lstat64 >/dev/null
>> -_compare_access_times $SCRATCH_MNT/lstat64 "executing file"
>> +$SCRATCH_MNT/cat $SCRATCH_MNT/cat >/dev/null
>> +_compare_access_times $SCRATCH_MNT/cat "executing file"
>>
>>   #reading file
>>   echo "*** creating file ***"
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
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
