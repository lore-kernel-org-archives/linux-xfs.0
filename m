Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 058407FB7
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 02:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9E2C8F8035
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 00:50:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7nXqbOGh38cW09RH for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 00:50:48 -0700 (PDT)
Date: Wed, 14 Aug 2013 17:50:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ***** SUSPECTED SPAM ***** Re: [PATCH 48/49] xfs: Add read-only
	support for dirent filetype field
Message-ID: <20130814075042.GE6023@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520A53E8.6030604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 13, 2013 at 10:42:32AM -0500, Mark Tinguely wrote:
> On 08/12/13 19:50, Dave Chinner wrote:
> >On Mon, Aug 12, 2013 at 08:25:23AM -0500, Mark Tinguely wrote:
> >>On 08/11/13 19:59, Dave Chinner wrote:
> >>>On Tue, Jul 30, 2013 at 02:10:32PM -0500, Mark Tinguely wrote:
> >>>>On 07/19/13 01:25, Dave Chinner wrote:
> >>>>>From: Dave Chinner<dchinner@redhat.com>
> >>>>>
> >>>>>Add support for the file type field in directory entries so that
> >>>>>readdir can return the type of the inode the dirent points to to
> >>>>>userspace without first having to read the inode off disk.
.....
> >>>>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >>>>>---
> >>>>>
> >>>>
> >>>>>+static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
> >>>>>+{
> >>>>>+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5&&
> >>>>>+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
> >>>>>  }
> >>>>>
> >>>>
> >>>>This feature should support inode version 2 and 3.
> >>>
> >>>Has nothing to do with the inode version number - it has to do with
> >>>the directory structure being modified.
> >>>
> >>>We're changing the directory structure for CRCs, and this builds on
> >>>top of that. It is essentially part of the V3 directory format, and
> >>>should be treated as such. Suggesting that we retrofit and support a
> >>>modified v2 directory format is close to insane - instead of only
> >>>having to test v2 vs v3 directory formats, you're suggesting we
> >>>support v2 vs v2+dtype vs v3 vs v3+dtype. We simply do not have the
> >>>resources to adequately test and support such an explosion of
> >>>filesystem configurations.
> >>>
> >>>We've had this discussion before - new on-disk features go into the
> >>>v5 superblock format - the v4 superblock format from this point
> >>>onwards is essentially legacy support from an upstream development
> >>>perspective.
....
> >>>That said, there's nothing to stop anyone from backporting such a
> >>>feature to an older kernel and maintaining it themselves - it's open
> >>>source software. But the idea that development should be constrained
> >>>by having to support both old and new formats is wrong - the old v4
> >>>format should be considered stable and we need think very hard about
> >>>changing it at all now, especially as much of the development focus
> >>>is now shifting to taking advantage of the additions to the v5
> >>>format....
> >>
> >>I guess we need more time to argue this out. It is not going into
> >>Linux 3.12 as a crc feature only.
> >
> >Seriously?
> 
> yes seriously.

Great, another random roadblock from the XFS maintainers to deal
with.

Mark, this is not a question of how complex the code is to implement it,
it's a question of testing and support. I simply do not have the
resources available to me to adequately test on-disk format changes
to both v4 and v5 format filesystems. I do not require the
functionality on v4 format filesystems, nor do I have the time to
support users that will make use of such functionality on v4
filesystems. Let it stabilise in v5 filesystems first, then we can
backport it in 6-12 months time.

> >This was *always* intended as a feature that went along with the v3
> >directory modifications. For example, see slide 40 of this
> >presentation:
> >
> >http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf
> >
> >the d_type field is listed alongside  version counters, inode create
> >times, and unlinked list logging via inode items....
> >
> >The only reason this has been done as a feature bit is because I
> >didn't have it done in time to included it under the v5 superblock
> >version change.
> >
> >The directory format for v4 filesystems is not going to change. We
> >do not have the resources to test it adequately, nor do we have the
> >resources to support it adequately. We're already taking on a huge
> >amount of risk with the v5 superblock changes, and our fallback
> >position is that v4 superblock formats are unchanged and so
> >unaffected by the format changes made for v5. Pushing format changes
> >intended only for v5 fielsystems back into v4 filesystems jeopodises
> >that fallback position and exposes all existing filesystems to
> >increased risk.
> >
> >And that is a risk I'm not willing to take on behalf of upstream
> >kernel users. Those that move to CRC enabled filesystems know the
> >risks of being early adopters and accept that there may be problems
> >encountered. THose that are using v4 filesystems expect that there
> >are no risky, destabilising changes made to the on-disk format, yet
> >that's exactly what you are suggesting we do.
....
> >This is why I'm pushing back hard on any suggestions that we target
> >new features on v4 superblocks - it's a development dead end and
> >therefore essentially a waste of upstream development resources....
> 
> v4 is hardly dead end. Feature bits can keep the filesystem stable.

Features bits don't keep a filesystem stable. Adequate testing and
enough resources to support users is what keeps the filesystem
stable.  I don't scale to supporting an exponential feature matrix.
I'm providing features appropriate to what I can support. If SGI
needs this feature on v4 superblocks *right now*, then they are
welcome to write the patch and supply the testing and community
level support necessary. I'd appreciate some help writing the
userspace code needed to support it properly...

> v5 superblock is experimental and is not the automatically the
> default and only version.

Sure, but you are saying that the only way to get a brand new
experimental feature into the experimental on-disk format is to also
provide, test and support that experimental format change in the
stable format?

What happened to the ultimatum I was given for getting CRC support
into the kernel? i.e "thou shalt not regress existing filesystems
with code to support new on disk formats". I mean, that's the rule
you guys laid down for the 3.10 CRC merge and other work. it's the
rule I've been working to for the past year or so while developing
all this stuff.

Why has the story has changed now that we're starting to roll
out all sorts of interesting performance improvements based on new
on-disk formats? Somebody doesn't want the CRC features because they
are "overhead" and "bloat", but they want performance features
because "faster is better"?

Sheesh!

> Geoffrey has been expressing concerns about v5 and I agree with
> them. We came to the party too late, and despite our concerns, SGI
> has worked hard to get the crc pieces reviewed, tested and
> committed. The concerns are still there.

I've addressed all of Geoffrey's stated concerns more than once. If
he's got any new ones, then I'm more than willing to discuss them
with him. For better or for worse, v5 filesystems are here to stay
so but please stop using nebulous "concerns" as a reason for
stopping us from making forwards progress.

> Yes, I am serious. v4 is not dead and should get new features where
> appropriate.

And it's not appropriate right now. In 6 months to a year - once
we've stabilised the feature on v5 superblocks and have robust
userspace tool support - we can add the 5 lines of code to support
the feature bit on v4 superblocks. But right now it's asking way too
much.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
