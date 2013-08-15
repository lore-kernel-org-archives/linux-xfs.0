Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 324C229DFB
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 23:22:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B209BAC002
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 21:22:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	yxMWnrtsF7B2qAHE for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 21:22:14 -0700 (PDT)
Date: Thu, 15 Aug 2013 14:22:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130815042210.GN6023@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130814184729.GA4604@sgi.com>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Aug 14, 2013 at 01:47:30PM -0500, Geoffrey Wehrman wrote:
> On Wed, Aug 14, 2013 at 05:50:42PM +1000, Dave Chinner wrote:
> | On Tue, Aug 13, 2013 at 10:42:32AM -0500, Mark Tinguely wrote:
> | > On 08/12/13 19:50, Dave Chinner wrote:
> | > >On Mon, Aug 12, 2013 at 08:25:23AM -0500, Mark Tinguely wrote:
> | > >>On 08/11/13 19:59, Dave Chinner wrote:
> | > >>>On Tue, Jul 30, 2013 at 02:10:32PM -0500, Mark Tinguely wrote:
> | > >>>>On 07/19/13 01:25, Dave Chinner wrote:
> | > >>>>>From: Dave Chinner<dchinner@redhat.com>
> | > >>>>>
> | > >>>>>Add support for the file type field in directory entries so that
> | > >>>>>readdir can return the type of the inode the dirent points to to
> | > >>>>>userspace without first having to read the inode off disk.
> | .....
> | > >>>>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> | > >>>>>---
> | > >>>>>
> | > >>>>
> | > >>>>>+static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
> | > >>>>>+{
> | > >>>>>+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5&&
> | > >>>>>+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
> | > >>>>>  }
> | > >>>>>
> | > >>>>
> | > >>>>This feature should support inode version 2 and 3.
> | > >>>
> | > >>>Has nothing to do with the inode version number - it has to do with
> | > >>>the directory structure being modified.
> | > >>>
> | > >>>We're changing the directory structure for CRCs, and this builds on
> | > >>>top of that. It is essentially part of the V3 directory format, and
> | > >>>should be treated as such. Suggesting that we retrofit and support a
> | > >>>modified v2 directory format is close to insane - instead of only
> | > >>>having to test v2 vs v3 directory formats, you're suggesting we
> | > >>>support v2 vs v2+dtype vs v3 vs v3+dtype. We simply do not have the
> | > >>>resources to adequately test and support such an explosion of
> | > >>>filesystem configurations.
> | > >>>
> | > >>>We've had this discussion before - new on-disk features go into the
> | > >>>v5 superblock format - the v4 superblock format from this point
> | > >>>onwards is essentially legacy support from an upstream development
> | > >>>perspective.
> | ....
> | > >>>That said, there's nothing to stop anyone from backporting such a
> | > >>>feature to an older kernel and maintaining it themselves - it's open
> | > >>>source software. But the idea that development should be constrained
> | > >>>by having to support both old and new formats is wrong - the old v4
> | > >>>format should be considered stable and we need think very hard about
> | > >>>changing it at all now, especially as much of the development focus
> | > >>>is now shifting to taking advantage of the additions to the v5
> | > >>>format....
> | > >>
> | > >>I guess we need more time to argue this out. It is not going into
> | > >>Linux 3.12 as a crc feature only.
> | > >
> | > >Seriously?
> | > 
> | > yes seriously.
> | 
> | Great, another random roadblock from the XFS maintainers to deal
> | with.
> 
> The addition of the file type field to directory entries is a great
> new feature.  Your implementation of adding a "hidden" byte to the name
> field is especially clever.

Then go thank Christoph for that - I'm pretty sure he came up with
the idea one night when we drinking in a bar somewhere a few years
ago...

> This is a feature that can benefit both
> dir2 and dir3 format filesystems and is completely independent of your
> CRC and self describing metadata feature work.  I understand that you
> are not interested in porting the capability to dir2 format filesystems
> yourself and do not have the resources to provide the associated testing
> and support.

Yes, I've been pretty clear about that.

> Myself and others within SGI have discussed these issues,

But not with the community.

So the SGI hivemind decided something behind closed doors, and
you're expecting us to just swallow that decision and not question
it?

> and we are willing to take on the work ourselves rather than have this
> feature go only into v5 superblock filesystems where the feature is only
> accessible to those who are willing to risk using experimental code.

Great. So Ben's going to merge the patches then?

> Given that SGI will be doing the work to support the file type field
> in dir2 format filesystems, it doesn't make sense to add the code to
> v5 filesystems until all of the work is complete as there could be
> additional considerations for the on disk changes.

<groan>

No, you're saying that merging is now dependent on whenever SGI gets
around to doing v4 support work?

So, what's the plan of action here?  Who is going to do that work?
How long is it going to take them? Are we talking about a delay of
couple of days, a few weeks, or months?

But let's address the core premise being asserted here by the SGI
hivemind - that we can't add a v5 feature until it's also made for
v4 filesystems.  I've said it time and time again: the v5 format
will not be compromised by having to cater for supporting v4
structures. I've been saying this for over 3 years. Indeed, in that
presentation at LCA 18 months ago: I said on slide 36:

" * No attempt to provide backwards or forwards
    compatibility for format changes.

	* Avoids compromising the new on-disk format design"

This still holds true. This directory format change is designed
specifically for v5 superblocks formats, and the process you are
insisting on is that that we should compromise the format change so
that we can support the same feature on v4 filesystems.  This is the
complete antithesis of the design and architectural principles that
have been guiding our work over the past 3 years, and I'm not about
to compromise on it now because it's a matter of *principle*.

This should not come as a surprise to anyone at SGI, but we've been
open and clear about the processes that we have using to design new
features for a quite a long time now. If SGI disagrees with the
processes and principles we strive to acheive, then perhaps we need
to have a different discussion.....

> We also noted that this feature should not be added to the kernel until
> userspace code is available to support this feature.  Specifically,
> xfs_repair needs to validate and if needed repair the the file type field.

Sure. I've been waiting for review of the code first so that any
nasty problems could be dealt with without having to double handle
the code changes in userspace. Instead of review, all I've got from
SGI is two weeks of silence and then a "get stuffed until you do v4
support as well" response.

I'll send the patches for repair support on top of that stack
tomorrow, and then this is not longer a barrier to merging it. Will
you merge it then?

> Also, tests are needed to validate the new functionality.

They can be written now that xfs_io readdir support hase been
merged. Though I've already done manual tests with the getdents
example code from the getdents(2) man page so I know it does
actually work correctly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
