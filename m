Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C9D917F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 09:46:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47EE4AC003
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 07:46:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LlHKCTDvkeQbTQk1 for <xfs@oss.sgi.com>;
	Tue, 17 Sep 2013 07:46:17 -0700 (PDT)
Message-ID: <52386B37.4060108@sandeen.net>
Date: Tue, 17 Sep 2013 09:46:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] [RFC] xfs: increase inode cluster size for v5 filesystems
References: <1378715664-19969-1-git-send-email-david@fromorbit.com>
	<20130909133254.GA14778@infradead.org>
	<20130909153546.GT12779@dastard>
	<20130911162159.GA29319@infradead.org>
	<20130917010449.GH19103@dastard>
In-Reply-To: <20130917010449.GH19103@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 9/16/13 8:04 PM, Dave Chinner wrote:
> On Wed, Sep 11, 2013 at 09:21:59AM -0700, Christoph Hellwig wrote:
>> On Tue, Sep 10, 2013 at 01:35:47AM +1000, Dave Chinner wrote:
>>> The test matrix of having to test everything on v4 and v5 is just
>>> nasty, especially if we are talking about prototyping code. I'd much
>>> prefer to bring things to v5 filesytsems where we have much lower
>>> exposure and risk of corruption problems, and then when we know it's
>>> solid because of the QA we've done on it, then we can expose the
>>> majority of the XFS userbase to it by bringing it back to v4
>>> filesystems.
>>
>> I think the test matrix is a reason for not enabling this only on v5
>> filesystems. 
> 
> You're assuming that someone is doing lots of QA on v4 filesystems.
> Most of my attention is focussed on v5 filesystems and compared to
> the amount of v5 QA I'm doing, there is very little v4 QA. All my
> development and prototyping is being done on v5 filesystems, and the
> code I post indicates that.

Red Hat QE is doing quite a lot of testing of V4 at this point, although
not on totally bleeding-edge kernels.

> I'm not about to propose new features for v4 filesystems if I
> haven't tested them robustly. And, in many cases, the new features
> I'm proposing require a new filesystem to be made (like this one
> does because of the inode alignment requirement) and userspace tool
> support, and so it's going to be months (maybe a year) before
> userspace support is in the hands of distro-based users.
> 
> People testing v5 filesystems right now are handrolling their
> userspace code, and so they are following the bleeding edge of both
> user and kernel space development. They are not using the bleeding
> edge to test new v4 filesystem features. 
> 
> Given this, it makes sense to roll the v5 code first, then a
> kernel release or 2 later roll in the v4 support once the v5 code
> has been exposed and we've flushed out the problems. It minimises
> our exposure to filesystem corruption issues, it gets the code into
> the hands of early adopters and testers quickly, and it gets rolled
> back into v4 filesystems in the same timeframe as distros will be
> picking up the feature in v5 filesystems for the first time.
> 
> Nobody has yet given a technical reason why such a careful, staged
> approach to new feature rollout for v4 filesystems is untenable. All
> I'm hearing is people shouting at me for not bringing new features
> to v4 filesystems.  Indeed, my reasons and plans to bring the
> features to v4 in the near future are being completely ignored to
> the point of recklessness...

That sounds perfectly reasonable to me; from your original RFC
it wasn't clear to me that that was the plan (stage it & roll it out
for V4 later).

>> Large inodes are an old and supported use case, although
>> probably not as heavily tested as it should.  By introducing two
>> different large inode cases we don't really help increasing test
>> coverage for a code path that is the same for v4 and v5.
> 
> I think you've got it wrong - 512 byte inodes have not been
> regularly or heavily tested until we introduced v5 filesystems.

Gluster users have been advised to use 512-byte inodes for quite
some time, actually.
(http://www.gluster.org/community/documentation/index.php/QuickStart)

So there is some real-world coverage, and presumably QE as well.

I understand your valid concerns (snipped below as well) but let's not
overstate the case either; V4 and 512-byte are both seeing some coverage
even today.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
