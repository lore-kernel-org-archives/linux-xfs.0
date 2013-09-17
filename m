Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9005E7F50
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 08:51:12 -0500 (CDT)
Message-ID: <52385E4D.4040007@sgi.com>
Date: Tue, 17 Sep 2013 08:51:09 -0500
From: Mark Tinguely <tinguely@sgi.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 09/16/13 20:04, Dave Chinner wrote:
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
>
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
>
>> Large inodes are an old and supported use case, although
>> probably not as heavily tested as it should.  By introducing two
>> different large inode cases we don't really help increasing test
>> coverage for a code path that is the same for v4 and v5.
>
> I think you've got it wrong - 512 byte inodes have not been
> regularly or heavily tested until we introduced v5 filesystems. Now
> they are getting tested all the time on v5 filesystems, but AFAICT
> there's only one person other than me regularly testing v5
> filesystems and reporting bugs (Michael Semon).  Hence, AFAICT there
> is very little ongoing test coverage of large inodes on v4
> filesystems, and so the expansion of the test matrix to cover large
> inodes on v4 filesystem is a very relevant concern.
>
> We will be enabling both d_type and large inode clusters on v5
> filesystems at all times - they won't be optional features. Hence
> test matrix is simple - enable v5, all new features are enabled and
> are tested.
>
> However, for v4 filesystems, we've now got default v4, v4 X dtype,
> v4 X dtype X 512 byte inodes, v4 X dtype X 512 byte inodes X inode
> alignment (i.e. forwards and backwards compatibility of large inode
> cluster configs on old 8k cluster kernels) and finally v4 X dtype X
> 512 byte inodes X inode alignment X large clusters.
>
> IOWs, every change we make for v4 filesystems adds another
> *optional* dimension to the v4 filesystem test matrix. Such an
> explosion of feature configurations is not sustainable or
> maintainable - ext4 has proven that beyond a doubt.  We have to
> consider the cross multiplication of the optional v4 feature matrix,
> and consider that everything needs to work correctly for all the
> different combinations that can be made.
>
> So, code paths might be shared between v4 and v5 filesystems, but we
> don't have an optional feature matrix on v5 (yet), nor do we have
> concerns about backwards and forwards compatibility, and so adding
> new features to v5 filesystems has a far, far lower testing and QA
> burden than adding a new feature to a v4 filesystem.
>
> As I've repeatedly said, if someone wants to do all the v4
> validation work I've mentioned above faster than I can do it, then
> they can provide the patches for the v4 support in kernel and
> userspace and all the tests needed to validate it on v4 filesystems.
>
> [ And even then, the v4 dtype fiasco shows that some people have a
> major misunderstanding of what is necessary to enable a feature on a
> v4 filesystem. I'm still waiting for all the missing bits I
> mentioned in my review of the patch to add the feature bit that were
> ignored. e.g. the XFS_IOC_FSGEOM support for the feature bit, the
> changes to xfs_info to emit that it's enabled, mkfs to emit that
> it's enabled, xfs_db support for the field on v4 filesystems, etc.
>
> IOWs, there is still a significant amount missing from the v4 dtype
> support and so, again, I have little confidence that such things
> will get done properly until I get around to doing them. I'll be be
> pleasently surprised if the patches appear before I write them (the
> kernel XFS_IOC_FSGEOM support needs to be in before 3.12 releases),
> but I fear that I'm going to be forced to write them soon.... ]
>
>> That being said as long as you're still prototyping I'm not going to
>> interfere.
>
> Until I see other people pro-actively fixing regressions, I don't
> see that there is any scope for changing my approach. Right now the
> only person I can really rely on to proactively fix problems is
> myself, and I have limited time and resources...
>
> Cheers,
>
> Dave.

We are *not* screaming for this on v4. Not screaming for this to be 
mandatory on v5.

It will make inode allocation more difficult as the drive fragments.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
