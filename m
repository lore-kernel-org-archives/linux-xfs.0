Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F27DB29DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 20:25:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78D92AC002
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 18:25:22 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id tB9dgTeGiSPGPFLk for
	<xfs@oss.sgi.com>; Sun, 12 Jan 2014 18:25:20 -0800 (PST)
Message-ID: <52D34EBD.4020508@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 10:26:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Add pairing mount options test
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
	<52D01CA9.4040107@sandeen.net> <52D33F92.2000609@cn.fujitsu.com>
	<52D342F0.5020402@sandeen.net> <20140113015239.GD3469@dastard>
In-Reply-To: <20140113015239.GD3469@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On mon, 13 Jan 2014 12:52:39 +1100, Dave Chinner wrote:
> On Sun, Jan 12, 2014 at 07:35:44PM -0600, Eric Sandeen wrote:
>> On 1/12/14, 7:21 PM, Qu Wenruo wrote:
>>> On fri, 10 Jan 2014 10:15:37 -0600, Eric Sandeen wrote:
>>>> On 1/8/14, 12:30 AM, Qu Wenruo wrote:
>>>>> Test remount btrfs with different pairing options like barrier and no barrier.
>>>> It seems that while this tests that the remount succeeds, and that
>>>> the option string is present in /proc/mounts, it does not test that
>>>> the mount option is actually in effect.
>>> Yes, this is what the new test case is intended to do.
>>> This case was just a test case tests the mount options themselves
>>> to ensure all the pairing mount options works during remounting,
>>> since most pairing options are missing before.
>>>> I suppose for many of these options that would be hard to test; for
>>>> i.e. acl though it should be trivial.
>>>>
>>>> What do you think, is this enough to ensure that remount handling
>>>> is working as expected for all of these options?
>>> In my opinion, this test should just focuses on the remount handling and
>>> the pairing options.
>>> For the detailed function should be examineed in other test cases.
>> Except those won't test that a remount with those options actually *worked*;
>> in fact they don't do remount at all.
>>
>> In other words, all this does is test that an option flag was set or unset in
>> the superblock, but it doesn't really test whether the option has been
>> properly set up (or torn down) as a result.
>>
>> I won't say no to this, but it seems to be of somewhat limited use.
> What happens to the test when mount options are deprecated/removed?
> How are we going to handle the matrix of testable/untestable mount
> options across kernels with different mount option support?
>
> Cheers,
>
> Dave.
In my opinion,there may be two ways to deal it:
1) Introduce up_limit_kver and down_limit_kver to *every* mount option.
If needed also add deprecated flags.

Ithink this can handle the version related things quite well.
But for the test case, it may be overkilled.
Most codes will be focused on theversion handling even though the case only
tests the flags.

On the other hand, it would be quitenice if xfstests framework can 
introduce such
version handling systems.

2) Manual editing after mount options change.
If any options become deprecated/removed, just remove them from 
PAIRING_OPTIONS and HIDDEN_OPTIONS.

For the old kernels with does not support these new options, NG is what 
it should be.
Since missing pairing options meaning that users can't trigger a funtion 
without unmount,
NG inform users the fact.
(Recently, one user asked why there is no "barrier" mountoption in 
btrfs. From the respect of users,
missing pairing mount options is a defeat)

This method will introduce more effort tomaintain the test case, but due 
to the small codes and
relativly less changes in mount options, I consider it as an acceptable 
method.

It would be quite nice if any one can provide any better idea.

Thanks
Qu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
