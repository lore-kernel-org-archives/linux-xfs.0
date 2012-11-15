Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFKxlc0028383 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 14:59:47 -0600
Message-ID: <50A5583D.5070101@sgi.com>
Date: Thu, 15 Nov 2012 15:01:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard> <50A52CA3.3060604@sgi.com>
	<20121115204830.GG14281@dastard>
In-Reply-To: <20121115204830.GG14281@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/15/12 14:48, Dave Chinner wrote:
> On Thu, Nov 15, 2012 at 11:55:47AM -0600, Mark Tinguely wrote:
>> On 11/14/12 00:50, Dave Chinner wrote:
>>> xfs: verify dquot blocks as they are read from disk
>>>
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Add a dquot buffer verify callback function and pass it into the
>>> buffer read functions. This checks all the dquots in a buffer, but
>>> cannot completely verify the dquot ids are correct. Also, errors
>>> cannot be repaired, so an additional function is added to repair bad
>>> dquots in the buffer if such an error is detected in a context where
>>> repair is allowed.
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> Reviewed-by: Phil White<pwhite@sgi.com>
>>> ---
>>> V2: quotacheck wasn't verifying dquots as they were read from disk
>>>
>>
>> FYI:
>>
>> The xfs_quota program does not generate output with V2 which causes
>> xfstest 050 to fails.
>
> I don't think that has anything to do with this patch orthechange
> for V2 - V2 only changes quotacheck behaviour, and that doesn't
> impact xfs_quota behaviour. The test passes just fine here:
>
> $ sudo ./check 050
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test-2 3.7.0-rc5-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
>
> 050 14s ... 15s
> Ran: 050
> Passed all 1 tests
>
> So perhaps there's something else going wrong on your machine?
>
> Cheers,
>
> Dave.

I will do more investigating. With V2 050 output:

QA output created by 050
*** user
meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
data     = bsize=XXX blocks=XXX, imaxpct=PCT
          = sunit=XXX swidth=XXX, unwritten=X
naming   =VERN bsize=XXX
log      =LDEV bsize=XXX blocks=XXX
realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX

*** report no quota settings

*** report initial settings

*** push past the soft inode limit

*** push past the soft block limit

...

Maybe it is my xfs_quota app, although it works fine with V1 kernel sources.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
