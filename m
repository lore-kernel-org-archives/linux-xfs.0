Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D9687F51
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:41:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CED58F8065
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:41:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id yzvJcOvxPzU4FEyh for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 11:41:18 -0700 (PDT)
Message-ID: <520D20CB.4080907@sandeen.net>
Date: Thu, 15 Aug 2013 13:41:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
	<51F80FA8.4060304@sgi.com> <20130812005905.GK12779@dastard>
	<5208E243.9080403@sgi.com> <20130813005024.GS12779@dastard>
	<520A53E8.6030604@sgi.com> <20130814075042.GE6023@dastard>
	<20130814184729.GA4604@sgi.com> <520D06C0.3040207@sandeen.net>
	<20130815183205.GG3783@sgi.com>
In-Reply-To: <20130815183205.GG3783@sgi.com>
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

On 8/15/13 1:32 PM, Geoffrey Wehrman wrote:
> On Thu, Aug 15, 2013 at 11:50:08AM -0500, Eric Sandeen wrote:
> | On 8/14/13 1:47 PM, Geoffrey Wehrman wrote:
> | > On Wed, Aug 14, 2013 at 05:50:42PM +1000, Dave Chinner wrote:
> | > | On Tue, Aug 13, 2013 at 10:42:32AM -0500, Mark Tinguely wrote:
> | > | > On 08/12/13 19:50, Dave Chinner wrote:
> | > | > >On Mon, Aug 12, 2013 at 08:25:23AM -0500, Mark Tinguely wrote:
> | > | > >>On 08/11/13 19:59, Dave Chinner wrote:
> | > | > >>>On Tue, Jul 30, 2013 at 02:10:32PM -0500, Mark Tinguely wrote:
> | > | > >>>>On 07/19/13 01:25, Dave Chinner wrote:
> | > | > >>>>>From: Dave Chinner<dchinner@redhat.com>
> | > | > >>>>>
> | > | > >>>>>Add support for the file type field in directory entries so that
> | > | > >>>>>readdir can return the type of the inode the dirent points to to
> | > | > >>>>>userspace without first having to read the inode off disk.
> | > | .....
> | > | > >>>>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> | > | > >>>>>---
> | > | > >>>>>
> | > | > >>>>
> | > | > >>>>>+static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
> | > | > >>>>>+{
> | > | > >>>>>+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5&&
> | > | > >>>>>+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE);
> | > | > >>>>>  }
> | > | > >>>>>
> | > | > >>>>
> | > | > >>>>This feature should support inode version 2 and 3.
> | > | > >>>
> | > | > >>>Has nothing to do with the inode version number - it has to do with
> | > | > >>>the directory structure being modified.
> | > | > >>>
> | > | > >>>We're changing the directory structure for CRCs, and this builds on
> | > | > >>>top of that. It is essentially part of the V3 directory format, and
> | > | > >>>should be treated as such. Suggesting that we retrofit and support a
> | > | > >>>modified v2 directory format is close to insane - instead of only
> | > | > >>>having to test v2 vs v3 directory formats, you're suggesting we
> | > | > >>>support v2 vs v2+dtype vs v3 vs v3+dtype. We simply do not have the
> | > | > >>>resources to adequately test and support such an explosion of
> | > | > >>>filesystem configurations.
> | > | > >>>
> | > | > >>>We've had this discussion before - new on-disk features go into the
> | > | > >>>v5 superblock format - the v4 superblock format from this point
> | > | > >>>onwards is essentially legacy support from an upstream development
> | > | > >>>perspective.
> | > | ....
> | > | > >>>That said, there's nothing to stop anyone from backporting such a
> | > | > >>>feature to an older kernel and maintaining it themselves - it's open
> | > | > >>>source software. But the idea that development should be constrained
> | > | > >>>by having to support both old and new formats is wrong - the old v4
> | > | > >>>format should be considered stable and we need think very hard about
> | > | > >>>changing it at all now, especially as much of the development focus
> | > | > >>>is now shifting to taking advantage of the additions to the v5
> | > | > >>>format....
> | > | > >>
> | > | > >>I guess we need more time to argue this out. It is not going into
> | > | > >>Linux 3.12 as a crc feature only.
> | > | > >
> | > | > >Seriously?
> | > | > 
> | > | > yes seriously.
> | > | 
> | > | Great, another random roadblock from the XFS maintainers to deal
> | > | with.
> | > 
> | > The addition of the file type field to directory entries is a great
> | > new feature.  Your implementation of adding a "hidden" byte to the name
> | > field is especially clever.  This is a feature that can benefit both
> | > dir2 and dir3 format filesystems and is completely independent of your
> | > CRC and self describing metadata feature work.  I understand that you
> | > are not interested in porting the capability to dir2 format filesystems
> | > yourself and do not have the resources to provide the associated testing
> | > and support.  Myself and others within SGI have discussed these issues,
> | > and we are willing to take on the work ourselves rather than have this
> | > feature go only into v5 superblock filesystems where the feature is only
> | > accessible to those who are willing to risk using experimental code.
> | > Given that SGI will be doing the work to support the file type field
> | > in dir2 format filesystems, it doesn't make sense to add the code to
> | > v5 filesystems until all of the work is complete as there could be
> | > additional considerations for the on disk changes.
> | > 
> | > We also noted that this feature should not be added to the kernel until
> | > userspace code is available to support this feature.  Specifically,
> | > xfs_repair needs to validate and if needed repair the the file type field.
> | > Also, tests are needed to validate the new functionality.  While I
> | > expect that you will provide this support for v5 superblock and dir3
> | > filesystems, one of us at SGI will extend the support to v4 superblock
> | > and dir2 filesystems.
> | 
> | These requirements are very, very late in the process.  Dave's work has
> | been discussed for a long time in public, with plenty of time for input
> | and cooperation and coordination.
> | 
> | If the type field is critical to SGI on V4 superblocks, I'd have expected
> | to see patches from SGI by now, either prior to, or in coordination with,
> | Dave's work.  So it's hard for me to tell if this is a strategic requirement
> | for you, or an effort to delay the CRC work which you seem to be uneasy with.
> | Indeed, you floated this as a requirement many weeks (months?) ago, but as far
> | as I know, no actual work or patches or proposals to implement it have been
> | forthcoming from SGI.
> | 
> | I apologize for not being up to speed on the technical details of what it
> | might take, but I figure surely SGI is on top of it, if you're signing up
> | to do the work.
> | 
> | So I'd propose (and the guys in the trenches can bang this around) that if
> | you are serious about this, you commit to producing patches which address your
> | stated requirements without negatively affecting Dave's V5 design, with all
> | necessary retesting, any of Dave's outstanding patches rebased as necessary,
> | and everything ready for upstream integration on the original schedule.
> | 
> | You've had plenty of time to do this, but it's not been done AFAICT.
> | I think you need to get busy and back up your words with patches pronto, or drop
> | the above stated requirement; perhaps there is a way to add the support to V4
> | superblocks retroactively if you miss this window.
> | 
> | There may well be technical hurdles I'm not aware of, but I think we need to see
> | SGI's proposed implementation to be able to discuss that efficiently.
> 
> I'll admit that I'm not a close follower of the oss-xfs mail list, but
> the first mention I can find of the dirent filetype field feature on
> the list is in Dave's patch posted July 19 along with 48 other patches.
> http://oss.sgi.com/archives/xfs/2013-07/msg00422.html

> If there was discussion on the list about this feature prior to the
> above posting, I apologize.  Had I known the dirent filetype feature
> was coming and would not be supported in v4 filesystems, I would have
> been able to start this conversation earlier.

You brought this topic up on an xfs community call months ago,
as I recall.  I thought we had put it to rest, because we didn't hear
from you again until now.

Am I misremembering?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
