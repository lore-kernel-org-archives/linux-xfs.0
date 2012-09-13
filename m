Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D2Goe8092612 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 21:16:50 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id MHKwlF7OUTIqUbIZ
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 19:17:55 -0700 (PDT)
Message-ID: <5051424E.8090502@canonical.com>
Date: Wed, 12 Sep 2012 19:17:50 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
Subject: Re: Ubuntu Ext4 regression testing
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
	<5051177E.6000903@canonical.com> <505126D4.5030106@redhat.com>
	<50512BB1.5010605@canonical.com> <50513C1A.9020504@redhat.com>
	<50513F22.3040201@canonical.com> <50514061.2050801@redhat.com>
In-Reply-To: <50514061.2050801@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On 09/12/2012 07:09 PM, Eric Sandeen wrote:
> On 9/12/12 9:04 PM, Brad Figg wrote:
>> On 09/12/2012 06:51 PM, Eric Sandeen wrote:
>>> On 9/12/12 7:41 PM, Brad Figg wrote:
>>>
>>>> Eric,
>>>>
>>>> Thanks for taking the time to point this out. We will adjust our testing accordingly.
>>>> We initially tried to run xfstest against ext2, ext3, ext4, xfs and btrfs. We are also
>>>> trying to get these tests to run on several different kernel versions as you can
>>>> see from our test results. We were running into issues on different kernels and various
>>>> file-systems while getting our act together, we did this as a band-aid.
>>>
>>> I see.
>>>
>>>> I accept that we have some things to learn w.r.t. running this test suite. We will work
>>>> to run the xfstests "as is" without any outside "intelligence". We do recognise that
>>>> is a dynamic set of tests that people are adding to regularly.
>>>>
>>>> I am not attempting to get just a series of "pass" results. If that were my goal
>>>> I could accomplish it much easier and would not have engaged with the community
>>>> on the mailing list. We want to help where we can and will accept constructive
>>>> criticism.
>>>
>>> Sorry, it sounds like I came across too strong there - it was just a little worrying to see failing or problematic tests disabled or otherwise artificially restricted.
>>>
>>> I'm actually very excited to see you setting up ongoing, public testing using xfstests, I think it'll be a great benefit, especially if there's a way to see a particular test's results across several kernel versions and/or filesystems and/or architectures, so that patterns of failure can emerge.
>>>
>>> If you find that xfstests is missing some feature or behavior which would facilitate testing in the automated environment, please do let us know what you need - or send patches.  :)
>>>
>>> Thanks,
>>> -Eric
>>>
>>>> Brad
>>>>
>>>
>>
>> No harm, no foul. We really don't mind constructive criticism. We are also
>> eager to get this setup and running. We will try to contribute more than
>> just running tests.
> 
> Just running them and publishing results is definitely useful.
> 
>> I do want to point out that we are using the xfstests which is a snapshot
>> in autotest. We do also look at the latest xfstests in the official xfstests
>> repo and add it in when we see a delta. We will also work with the autotest
>> maintainers to stay more up-to-date with xfstests.
> 
> Ah, I didn't know that autotest had a snapshot.  I wonder if there's a way to
> tease that back out, and pull down xfstests from git daily.
> 
> FWIW, it's a little confusing - we have 2 repos:
> 
> git://oss.sgi.com/xfs/cmds/xfstests.git
> git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
> 
> the one on kernel.org is where most rapid development seems to happen, and changes get pulled over to sgi.  Sometimes, it goes the other way.
> 
> Did autotest make any changes to what's upstream?
> 
> -Eric
> 
>> Thanks,
>> Brad
>>
> 

No, it seems to be an unmodified snapshot. As long as it's kept up-to-date,
which is something we have a vested interest in seeing is done, I'm fine
with this. We then take this (autotest) and also roll it into our QA team
for even more testing. They will also be making their testing results public.

I grabbed from the oss.sgi repository. If one is more "authoritative" or
one you'd rather see us use, just let me/us know.

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
