Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 79B40801E
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 09:22:39 -0500 (CDT)
Message-ID: <51432EC5.5090208@sgi.com>
Date: Fri, 15 Mar 2013 09:23:01 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3 V4] xfstests: btrfs tests for basic informational
	commands
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
	<1363186623-1378-4-git-send-email-sandeen@redhat.com>
	<5140AB9D.2070001@redhat.com> <5140CB3F.5010704@redhat.com>
	<5140CD26.7050201@sandeen.net> <20130315101625.GE6369@dastard>
	<737235E6-72C8-45F5-A6F4-EEEFD094706E@redhat.com>
In-Reply-To: <737235E6-72C8-45F5-A6F4-EEEFD094706E@redhat.com>
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
To: Eric Sandeen <esandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 03/15/2013 08:46 AM, Eric Sandeen wrote:
> Yep sorry.  I figure its always a race in numbers do I don't bother with fixing them up.  Should I?
>

Eric,
I was going to revert and resubmit as test 306, is that OK with you?

> On Mar 15, 2013, at 5:16 AM, Dave Chinner <david@fromorbit.com> wrote:
>
>> On Wed, Mar 13, 2013 at 02:01:58PM -0500, Eric Sandeen wrote:
>>> Run basic btrfs information commands in various ways, performing
>>> sanity tests of: filesystem show, label, sync, and device stats
>>> (sync is included just because it's simple).  These are mostly
>>> just smoke tests, although for example show by label & UUID
>>> should verify that the correct fs was shown.
>>>
>>> This also add2730c49a3s quite a few new filters to accommodate the output
>>> of the new commands.
>>>
>>> Cc: linux-btrfs@vger.kernel.org
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> V2: sort & uniq device stats output to account for variable
>>> nrs. of devices.  Optionally check that the proper nr. of
>>> devices was returned, as well.
>>>
>>> V3: _filter_uuid needs to pay attention to $1, not hope
>>> that the caller has set $UUID.  Oops.
>>>
>>> V4: fix stats filter to set UNIQ_OPT in both cases, ugh.
>>
>> Something I just noticed in this commit:
>>
>>> +# get standard environment, filters and checks
>>> +. ./common.rc
>>> +. ./btrfs.filter
>>
>> That should probably have been named "common.filter.btrfs".

Dave,
Do you want me to rename btrfs.filter to common.filter.btrfs when I 
resubmit this patch?

Regards
--Rich

>> I found this updating my patchset that moves all the common.* files
>> into a common/ directory....
>>
>> I'll rename it to common/filter.btrfs....
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
