Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E3DE7F60
	for <xfs@oss.sgi.com>; Mon, 19 Aug 2013 00:28:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 784F98F8035
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 22:28:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oBt9ankAnYDefTQR for <xfs@oss.sgi.com>;
	Sun, 18 Aug 2013 22:28:19 -0700 (PDT)
Date: Mon, 19 Aug 2013 15:28:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130819052813.GA6023@dastard>
References: <20130812005905.GK12779@dastard> <5208E243.9080403@sgi.com>
	<20130813005024.GS12779@dastard> <520A53E8.6030604@sgi.com>
	<20130814075042.GE6023@dastard> <20130814184729.GA4604@sgi.com>
	<520C6E39.7030501@redhat.com> <20130815180400.GF3783@sgi.com>
	<520D4B1B.4080602@redhat.com> <20130816140811.GA30422@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130816140811.GA30422@sgi.com>
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
To: Geoffrey Wehrman <gwehrman@sgi.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Fri, Aug 16, 2013 at 09:08:11AM -0500, Geoffrey Wehrman wrote:
> On Thu, Aug 15, 2013 at 10:41:47PM +0100, Ric Wheeler wrote:
> | On 08/15/2013 07:04 PM, Geoffrey Wehrman wrote:
> | >On Thu, Aug 15, 2013 at 06:59:21AM +0100, Ric Wheeler wrote:
> | >|
> | >| As much as the community admires your brave willingness to protect us 
> | >from
> | >| code that was entirely developed by Dave, that is not really how the
> | >| upstream kernel works.
> | >|
> | >| Dave is pretty much without equal in moving XFS along these days and this
> | >| is a key feature that we are depending on.
> | >|
> | >| Please don't try to create hurdles to other people getting work into
> | >| upstream, that kind of thing will lead to a fork of the XFS code base and
> | >| ultimately that will be harder for all of us.
> | >|
> | >| It sounds like what you really should look at doing is to work inside of
> | >| SGI to create a private, internal branch of the upstream code that you
> | >| deliver in your product. Upstream code is all about innovation and new
> | >| features, we don't let vendor specific, non-upstream branches become the
> | >| place for hardening our code.
> | >
> | >I agree Dave is a gifted, dedicated, passionate and prolific contributor
> | >to the XFS community.  His contributions are greatly appreciated as are
> | >the contributions of all other members of the XFS community.  Dave does
> | >stand out as the most significant code contributor to the project.  He
> | >has played a significant role moving XFS forward both from within SGI
> | >and from outside SGI.  This does not place his contributions beyond
> | >review or discussion however.
> | >
> | >My objection to the current readdir filetype field feature code is that
> | >the feature is not being made available to mainstream XFS users, only
> | >to those willing to run experimental code.  Dave has clearly stated that
> | >he will not do the back-porting work.  I am not expecting Dave to do the
> | >back-porting work.  Mark has volunteered to fill the back-porting role.
> | >Th porting work cannot be completed as the feature is not yet complete.
> | >The associated user space code changes have not been submitted,
> | >and tests to validate the new feature have not been submitted.  I do
> | >not consider this to be an unreasonable request, even if there were
> | >back-porting required.
> | >
> | >If Red Hat is depending on the readdir filetype field feature from Dave
> | >and do not wish to wait for the feature to be completed before pulling
> | >in the code, then perhaps Red Hat should create a internal branch of
> | >the upstream code that you can deliver in your products.  The upstream
> | >code should be stable and fully functional, not a place for incomplete,
> | >partially tested, half finished work.
> | >
> | >
> | 
> | I think that you are still unclear on what "mainstream" users are.
> | 
> | People who pay for commercial support use vendor branches of the kernel 
> | (from us, from SLES, from you, etc).
> | 
> | Upstream users and community distros normally expect to see new features in 
> | their kernels.
> | 
> | For what it's worth, Red Hat has been the largest contributor to XFS for 
> | quite a while now & XFS will be our RHEL7 default file system.
> | 
> | We don't ship "untested" or "incomplete" code.
> 
> Clearly we all have the interests of Linux users in mind whether they be
> those paying for commercial support, developers embedding Linux in other
> products, or technically savvy end users.  Clearly we don't agree all
> the time on content, time lines, and process.  We each have to be willing
> to engage in a civil conversation and be willing to compromise.
> 
> I recognize that I tend to be a silent bystander until there is
> an issue where I disagree, and only then do I join the conversation.
> I do not get involved in the general conversations on the list.  I have
> all kinds of excuses, but it comes down to the fact that I just don't
> make it a high enough priority.  Likewise, I don't tell Dave, Christoph,
> Eric, and others how much I appreciate their contributions when I do not
> have an issue.  That makes me nothing more than a whiner and complainer,
> and I apologize for as much.
> 
> I think it is great that Red Hat has been the largest contributor of XFS
> code recently.  I'm excited that XFS will be the default filesystem for
> RHEL 7.  I am not trying to sabotage any of Red Hat's plans.  Success for
> Red Hat and XFS translates into success for all Linux users.
> 
> I would like to take this opportunity to point out that SGI's
> attempts to contribute code to XFS are frequently blocked by Red
> Hat without technical merit.  Most recently we tried to submit
> code for the agskip mount option which SGI has been shipping for
> years.  [http://oss.sgi.com/archives/xfs/2013-01/msg00561.html]

There were technical problems with the patch (e.g. race conditions),
and it never got reposted by SGI, so that's SGI's failing to follow
up in response to code review that is at fault. And there were
design issues that we'd discussed months previous where we'd agreed
that the mount options weren't the best way forward....

http://oss.sgi.com/archives/xfs/2013-01/msg00588.html

> We asked for fields to be reserved in the new v3 inodes for parent
> pointers and allocation policies.  That request was soundly rejected
> despite the existence of unreserved padding in the new inode format.
> [http://oss.sgi.com/archives/xfs/2013-04/msg00214.html]

http://oss.sgi.com/archives/xfs/2013-04/msg00253.html

I asked for justification i.e. a design review of the feature that
needed to increase the on-disk inode size by 16 bytes for a feature
that had last been proposed to the community using a pure EA format.
Again, SGI did not follow up with code or design or continue the
discussion.

There's hardly a conspiracy here - getting a "you need to fix X"
reponse or a "please demonstrate why" response is a normal part of
the review process.  The responsibility to follow up with the
required fixes/information is solely on the person who proposed the
code/feature in the first place.

> The response
> to code submitted by SGI has been so negative, we don't even bother
> submitting most of our code to the list anymore as long as it does not
> affect the on-disk format.

So "please fix/justify" responses with construct criticism to a
handful of patches from SGI is so negative and hurtful that SGI has
decided can't participate in upstream development for any new code
it writes?

> A reiterate my appreciation of Red Hat's contributions to XFS.
> However, I hope that you and others at Red Hat recognize that Red
> Hat is not the sole source for innovation and contributions to
> XFS.  The playing field must be kept level and everyone in the
> community must be allowed to participate.

We have a level playing field. We've recently had significant
contributions from several different sources, and they've all
managed to handle the iterative review process just fine, following
up when asked for more information or fixing problems with the code
or pointing out the suggestions made during review are off-target
and won't work. Some patch series get to version 7 or 8 before they
pass review, yet those people have persisted and we've ended up with
good code and cool new features.

Participation requires being open about what you are doing. Posting
designs and ideas for comment, communicating your vision for the
future, posting code early and often, etc. That enables others to
participate at every stage and means that problems/issues are caught
early and rejection/acceptance occurs long before final code is
written. That's the way open source software is developed and most
of the XFS developer community understand that.

Except, it appears, the maintainers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
