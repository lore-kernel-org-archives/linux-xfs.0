Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B18C67F51
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 19:50:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2430304039
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 17:50:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	2bBGfCJDwgKRBg4J for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 17:50:29 -0700 (PDT)
Date: Tue, 13 Aug 2013 10:50:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ***** SUSPECTED SPAM ***** Re: [PATCH 48/49] xfs: Add read-only
	support for dirent filetype field
Message-ID: <20130813005024.GS12779@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5208E243.9080403@sgi.com>
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

On Mon, Aug 12, 2013 at 08:25:23AM -0500, Mark Tinguely wrote:
> On 08/11/13 19:59, Dave Chinner wrote:
> >On Tue, Jul 30, 2013 at 02:10:32PM -0500, Mark Tinguely wrote:
> >>On 07/19/13 01:25, Dave Chinner wrote:
> >>>From: Dave Chinner<dchinner@redhat.com>
> >>>
> >>>Add support for the file type field in directory entries so that
> >>>readdir can return the type of the inode the dirent points to to
> >>>userspace without first having to read the inode off disk.
> >>>
> >>>The encoding of the type field is a single byte that is added to the
> >>>end of the directory entry name length. For all intents and
> >>>purposes, it appends a "hidden" byte to the name field which
> >>>contains the type information. As the directory entry is already of
> >>>dynamic size, helpers are already required to access and decode the
> >>>direct entry structures.
> >>>
> >>>Hence the relevent extraction and iteration helpers are updated to
> >>>understand the hidden byte.  Helpers for reading and writing the
> >>>filetype field from the directory entries are also added. Only the
> >>>read helpers are used by this patch.  It also adds all the code
> >>>necessary to read the type information out of the dirents on disk.
> >>>
> >>>Further we add the superblock feature bit and helpers to indicate
> >>>that we understand the on-disk format change. This is not a
> >>>compatible change - existing kernels cannot read the new format
> >>>successfully - so an incompatible feature flag is added. We don't
> >>>yet allow filesystems to mount with this flag yet - that will be
> >>>added once write support is added.
> >>>
> >>>Finally, the code to take the type from the VFS, convert it to an
> >>>XFS on-disk type and put it into the xfs_name structures passed
> >>>around is added, but the directory code does not use this field yet.
> >>>That will be in the next patch.
> >>>
> >>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >>>---
> >>>
> >>
> >>>+static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
> >>>+{
> >>>+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5&&
> >>>+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
> >>>  }
> >>>
> >>
> >>This feature should support inode version 2 and 3.
> >
> >Has nothing to do with the inode version number - it has to do with
> >the directory structure being modified.
> >
> >We're changing the directory structure for CRCs, and this builds on
> >top of that. It is essentially part of the V3 directory format, and
> >should be treated as such. Suggesting that we retrofit and support a
> >modified v2 directory format is close to insane - instead of only
> >having to test v2 vs v3 directory formats, you're suggesting we
> >support v2 vs v2+dtype vs v3 vs v3+dtype. We simply do not have the
> >resources to adequately test and support such an explosion of
> >filesystem configurations.
> >
> >We've had this discussion before - new on-disk features go into the
> >v5 superblock format - the v4 superblock format from this point
> >onwards is essentially legacy support from an upstream development
> >perspective.  Upstream development is about moving forward as
> >quickly and cleanly as possible - quadrupling the test matrix for
> >every minor on-disk change is simply not something we can sustain,
> >and that's why I'm pushing back *hard* on any suggestion that we
> >shoul dbe supporting new on-disk format changes on both v4 and v5
> >superblocks formats. v5 is the future and so all new features need
> >to target v5 filesystem formats and ignore the restrictions that v4
> >filesystem formats might place on them.
> >
> >That said, there's nothing to stop anyone from backporting such a
> >feature to an older kernel and maintaining it themselves - it's open
> >source software. But the idea that development should be constrained
> >by having to support both old and new formats is wrong - the old v4
> >format should be considered stable and we need think very hard about
> >changing it at all now, especially as much of the development focus
> >is now shifting to taking advantage of the additions to the v5
> >format....
> >
> >Cheers,
> >
> >Dave.
> 
> I guess we need more time to argue this out. It is not going into
> Linux 3.12 as a crc feature only.

Seriously? 

This was *always* intended as a feature that went along with the v3
directory modifications. For example, see slide 40 of this
presentation:

http://xfs.org/images/d/d1/Xfs-scalability-lca2012.pdf

the d_type field is listed alongside  version counters, inode create
times, and unlinked list logging via inode items....

The only reason this has been done as a feature bit is because I
didn't have it done in time to included it under the v5 superblock
version change.

The directory format for v4 filesystems is not going to change. We
do not have the resources to test it adequately, nor do we have the
resources to support it adequately. We're already taking on a huge
amount of risk with the v5 superblock changes, and our fallback
position is that v4 superblock formats are unchanged and so
unaffected by the format changes made for v5. Pushing format changes
intended only for v5 fielsystems back into v4 filesystems jeopodises
that fallback position and exposes all existing filesystems to
increased risk.

And that is a risk I'm not willing to take on behalf of upstream
kernel users. Those that move to CRC enabled filesystems know the
risks of being early adopters and accept that there may be problems
encountered. THose that are using v4 filesystems expect that there
are no risky, destabilising changes made to the on-disk format, yet
that's exactly what you are suggesting we do.

I'll repeat again what I've said all along - new on-disk format
changes for upstream kernels need to be done on v5 filesystems as
the v4 format is now considered stable and in maintenance mode. It
takes months to to test and stabilise format changes and such
changes do not align to the goals of maintaining a stable code base.

This is the same situationas when SGI changed from v3 superblocks to
v4 superblocks back in the Irix 6.1/6.2 days. All new features
targetted v4 superblocks, as the release process would result in all
platforms shipping with v4 superblocks for all new filesystems with
the next release a year later (6.5).

This is exactly the same situation - upstream development is solely
focussed on future releases, and as such needs to make decisions
based on what is best for us in the medium to long term. The v4
superblocks have lasted for 15 years, but we are now at a similar
line in the sand - we have a major format and focus shift with v5
superblocks and that's where we need to be focussing our development
direction and decisions.

Looking backwards by requiring new features to be chained to the old
format is a bad direction to be taking - it compromises what we can
do in the long term based on those features, and in the short term
requires more resources to develop and test the new features. It's
simply the wrong direction to be taking for upstream development.

This is why I'm pushing back hard on any suggestions that we target
new features on v4 superblocks - it's a development dead end and
therefore essentially a waste of upstream development resources....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
