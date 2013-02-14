Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66E1F800D
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 09:15:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E30E3AC004
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 07:15:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iFn3jphcf1oiKjRk for
	<xfs@oss.sgi.com>; Thu, 14 Feb 2013 07:15:54 -0800 (PST)
Message-ID: <511CFFA2.8030905@redhat.com>
Date: Thu, 14 Feb 2013 09:15:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add disk failure simulation test
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
	<511BBF33.20908@redhat.com> <87621vngtw.fsf@openvz.org>
In-Reply-To: <87621vngtw.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 2/14/13 7:52 AM, Dmitry Monakhov wrote:
> On Wed, 13 Feb 2013 10:28:35 -0600, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 2/13/13 9:41 AM, Dmitry Monakhov wrote:

<snip>

>>> +# get standard environment, filters and checks
>>> +. ./common.rc
>>> +. ./common.filter
>>> +
>>> +# TODO move it to common.blkdev if necessery
>>
>> maybe a comment as to why you do this?  (presumably to find the right thing in /sys)
>> I hope this always works with all udev schemes etc?
> I just ment to say that functions below are good candidates to became
> common wrappers.

Sure, but what is the reason for the wrapper?

On inspection I think its' because you need the right sysfs name; it'd
just be nice to say that it's the reason for the readlink/basename
frobbing of the existing $SCRATCH_DEV.  Not a huge deal.

>>> +SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
>>> +SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
>>> +

<snip>

>>> +_require_debugfs()
>>> +{
>>> +    #boot_params always present in debugfs
>>> +    [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
>>> +}
>>
>> Would it make more sense to look for debugfs in /proc/filesystems
>> as a test for it being *available* (as opposed to mounted somewhere?)
>>
>> I wonder if a helper (maybe in _require_debugfs) should work out if
>> it's mounted, if not, try to mount it, and in the end, export DEBUGFS_MNT
>> for any test that wants to use it.
>>
>> Otherwise if it happens to be mounted elsewhere, this'll all fail.
>> Just a thought.  Maybe that's unusual enough that there's no point.
>> But getting it mounted if it's not would be helpful I think.

Any thoughts on this?  As it stands it requires debugfs to be
at /sys/kernel/debug (by default) *and* mounted prior to the test run.
So it's another (maybe unexpected) piece of pre-test setup which might
result in this test not getting run.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
