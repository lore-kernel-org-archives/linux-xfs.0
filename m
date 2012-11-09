Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA9EFJFs115193 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 08:15:19 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Bx12yrkXA12civco for
	<xfs@oss.sgi.com>; Fri, 09 Nov 2012 06:17:18 -0800 (PST)
Message-ID: <509D10D2.1050508@redhat.com>
Date: Fri, 09 Nov 2012 09:18:58 -0500
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH RFC] xfstests: speculative preallocaction trimming test
References: <1352405889-41186-1-git-send-email-bfoster@redhat.com>
	<20121108222949.GT6434@dastard>
In-Reply-To: <20121108222949.GT6434@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/08/2012 05:29 PM, Dave Chinner wrote:
> On Thu, Nov 08, 2012 at 03:18:09PM -0500, Brian Foster wrote:
>> The speculative preallocation trimming test verifies that files
>> with post-EOF blocks are trimmed when the scan is invoked.
>> Background scans and the various scan filters are tested as well.
>>
>> Signed-off-by: Brian Foster <bfoster@redhat.com>
>> ---
>>
>> Hi all,
>>
...
> 
> I'll have to get a basic version of the spacemen patchset I have
> sent out again so that we can get this into xfsprogs ASAP. I think
> we might be waiting until after the release is done before that
> happens, though....
> 

No problem. Keep me posted on any significant changes and I'll keep this
up to date.

>>
>>  290           |  176 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  290.out       |   55 ++++++++++++++++++
>>  common.config |    1 +
>>  common.rc     |   10 +++
>>  group         |    1 +
>>  5 files changed, 243 insertions(+), 0 deletions(-)
>>  create mode 100755 290
>>  create mode 100644 290.out
>>
>> diff --git a/290 b/290
>> new file mode 100755
>> index 0000000..12ce9c2
>> --- /dev/null
>> +++ b/290
>> @@ -0,0 +1,176 @@
>> +#! /bin/bash
>> +# FS QA Test No. 290
>> +#
...
>> +
>> +_scratch_mkfs_xfs -d size=200m >> $seq.full 2>&1 || _fail "mkfs failed"
> 
> _scratch_mkfs_sized 200m >> $seq.full 2>&1
> 
> And once again, there's generally no need to check for mkfs failure.
> 

Ok, thanks for the general tips on the filters and error checking.

>> +_scratch_mount
>> +
>> +echo "==================="
>> +echo -e "speculative preallocation trim"
>> +
>> +_create_files
>> +echo -e "\nfiles"
> 
> I can't say I like the extra line output here. "pretty" .out
> contents isn't really necessary, especially when it makes the test
> code harder to read...
> 
>> +_stat_files
>> +# trim all files
>> +_trim_prealloc $SCRATCH_MNT "-s"
>> +echo -e "\nno filter"
>> +_stat_files
> 
> If you are going to put progress output in the $seq.out file (which
> I still think is unnecessary), then put it in the function doing
> that work.
> 

I'll remove the newlines and things that uglify the code. I'd like to
keep the text headers such that the output is somewhat readable in the
event that the test fails, particularly since the output is repetitive.

>> +echo -e "\nuid/gid filter"
>> +_stat_files
>> +
>> +echo -e "\n==================="
>> +echo -e "background speculative preallocation trim"
>> +
>> +# Clean up (unmount), set the lifetime to 5s and remount to ensure that the new
>> +# lifetime kicks in immediately.
>> +
>> +_cleanup
>> +_set_speculative_prealloc_lifetime 5
> 
> old_lifetime=`cat ....`
> echo 5 > ....
> 

Ok.

>> +
>> +_scratch_mount
> 
> Did I miss an unmount somewhere?
> 

_cleanup is called immediately prior to the
_set_speculative_prealloc_lifetime call. There's a comment there too. ;)

>> +_create_files
>> +
>> +# flush and wait a few scan intervals
>> +sync
>> +sleep 15
>> +echo -e "\nbackground scan"
>> +_stat_files
>> +
>> +_set_speculative_prealloc_lifetime 300
> 
> echo $old_lifetime > ....
> 
>> diff --git a/group b/group
>> index a846b60..675d5b5 100644
>> --- a/group
>> +++ b/group
>> @@ -408,3 +408,4 @@ deprecated
>>  287 auto dump quota quick
>>  288 auto quick ioctl trim
>>  289 auto quick
>> +290 auto quick
> 
> I'd suggest that the rw and ioctl groups are appropriate here as
> well.
> 

Ok. Thanks!

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
