Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4CF37F3F
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 20:59:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF6C38F8039
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 18:59:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id YX0BpdeEOAELDcI7 for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 18:59:05 -0800 (PST)
Message-ID: <528D76F7.5060505@sandeen.net>
Date: Wed, 20 Nov 2013 20:59:03 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: use correct size value in generic/273
References: <1384970070-58732-1-git-send-email-bfoster@redhat.com>
	<20131121024605.GB6188@dastard>
In-Reply-To: <20131121024605.GB6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 11/20/13, 8:46 PM, Dave Chinner wrote:
> On Wed, Nov 20, 2013 at 12:54:30PM -0500, Brian Foster wrote:
>> generic/273 factors the "space available" output from df into the
>> calculation for the size of the origin data set. Recent commit
>>
>>   bfdd1e72b358 xfstests: added -P option to $DF_PROG
>>
>> ... converted the use of 'df' to $DF_PROG. This implicitly adds the
>> -T parameter to add the fs type column, shifts the available space
>> column over by one and unintentionally causes 273 to look at "used
>> space" and create too small of a data set for a useful test.
>> Realign to the to the available space value.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>  tests/generic/273 | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tests/generic/273 b/tests/generic/273
>> index 63bbf9b..2d54493 100755
>> --- a/tests/generic/273
>> +++ b/tests/generic/273
>> @@ -68,7 +68,7 @@ _file_create()
>>  
>>  	cd $SCRATCH_MNT/origin
>>  
>> -	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 3]; break}}}'`
>> +	_disksize=`$DF_PROG --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 4]; break}}}'`
>>  	_disksize=$(($_disksize / 3))
>>  	_num=$(($_disksize / $count / $threads / 4096))
>>  	_count=$count
> 
> Just what is this bunch of unmaintainable line noise actually doing?
> 
> $ df -T -P --block-size=1 $SCRATCH_DEV | awk -v sd=$SCRATCH_DEV 'BEGIN{c=0}{for(i=1;i<=NF;++i){a[c]=$i;++c}}END{for(entry in a){if(a[entry] ~ sd){print a[entry + 4]; break}}}'
> 5282562048
> $
> 
> Ok, someone didn't know about --output:

I sure didn't.  Not in my manpage or in my df --help output...  Is it new?

$ df --block-size=1 --output=avail /
df: unrecognized option '--output=avail'
Try `df --help' for more information.

The above chicken-scratching went in w/ 1fce0780f63ccdd308767e23fe39a18d30d973d6 because:

    273: fix of reading scratch size and removing lost+found
    
    There were two reasons why test 273 was failing. Firstrly, when running on
    ext4 fs it was removing everything from SCRATCH_MNT directory at the beginning
    of tests including the lost+found directory. This caused error while checking
    scratch fs after finishing test. Secondly, obtaining of the partition size was
    not counting with with behaviour of df utility which may split the line containg
    informations about one partition when it is too long thus it may have returned
    nothing.
    
    First problem was solved with removing all unnecessary rm -rf commands and the
    second one was fixed with alternative awk script which is able to deal with
    any line splitting possible. Also 'umount $SCRATCH_DEV' was substituted for
    '_scratch_unmount'.


presumably from long lvm devicenames.

# df --block-size=1 /dev/mapper/vg_bp05-lv_home
Filesystem           1B-blocks      Used Available Use% Mounted on
/dev/mapper/vg_bp05-lv_home
                     437264879616 254143942656 183120936960  59% /home

> $ df --block-size=1 --output=avail $SCRATCH_DEV | tail -1
> 5282562048
> $
> 
> But --output is incompatible with DF_PROG="df -T -P" and so we need
> to do:
> 
> $ df -T -P --block-size=1 $SCRATCH_DEV | tail -1 | awk '// { print $5 }'
> 5282562048
> $
> 
> Looks a little easier to understand, yes?

yeah, and I guess it does work:

# df -T -P --block-size=1 /dev/mapper/vg_bp05-lv_home | tail -1 | awk '// { print $5 }'
183120936960

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
