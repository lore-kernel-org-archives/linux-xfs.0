Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752300AbdKFNHJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Nov 2017 08:07:09 -0500
Date: Mon, 6 Nov 2017 08:07:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171106130708.GB30884@bfoster.bfoster>
References: <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103112626.GA19974@bfoster.bfoster>
 <20171105235104.GF4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171105235104.GF4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 10:51:04AM +1100, Dave Chinner wrote:
> On Fri, Nov 03, 2017 at 07:26:27AM -0400, Brian Foster wrote:
> > On Fri, Nov 03, 2017 at 10:30:17AM +1100, Dave Chinner wrote:
> > > On Thu, Nov 02, 2017 at 07:25:33AM -0400, Brian Foster wrote:
> > > > On Thu, Nov 02, 2017 at 10:53:00AM +1100, Dave Chinner wrote:
> > > > > On Wed, Nov 01, 2017 at 10:17:21AM -0400, Brian Foster wrote:
> > > > > > On Wed, Nov 01, 2017 at 11:45:13AM +1100, Dave Chinner wrote:
> > > > > > > On Tue, Oct 31, 2017 at 07:24:32AM -0400, Brian Foster wrote:
> > > > > > > > On Tue, Oct 31, 2017 at 08:09:41AM +1100, Dave Chinner wrote:
> > > > > > > > > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> > > > > > > > > > On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > ...
> > > > > > BTW, was there ever any kind of solution to the metadata block
> > > > > > reservation issue in the thin case? We now hide metadata reservation
> > > > > > from the user via the m_usable_blocks account. If m_phys_blocks
> > > > > > represents a thin volume, how exactly do we prevent those metadata
> > > > > > allocations/writes from overrunning what the admin has specified as
> > > > > > "usable" with respect to the thin volume?
> > > > > 
> > > > > The reserved metadata blocks are not accounted from free space when
> > > > > they are allocated - they are pulled from the reserved space that
> > > > > has already been removed from the free space.
> > > > > 
> > > > 
> > > > Ok, so the user can set a usable blocks value of something less than the
> > > > fs geometry, then the reservation is pulled from that, reducing the
> > > > reported "usable" value further. Hence, what ends up reported to the
> > > > user is actually something less than the value set by the user, which
> > > > means that the filesystem overall respects how much space the admin says
> > > > it can use in the underlying volume.
> > > > 
> > > > For example, the user creates a 100T thin volume with 10T of usable
> > > > space. The fs reserves a further 2T out of that for metadata, so then
> > > > what the user sees is 8T of writeable space.  The filesystem itself
> > > > cannot use more than 10T out of the volume, as instructed. Am I
> > > > following that correctly? If so, that sounds reasonable to me from the
> > > > "don't overflow my thin volume" perspective.
> > > 
> > > No, that's not what happens. For thick filesystems, the 100TB volume
> > > gets 2TB pulled from it so it appears as a 98TB filesystem. This is
> > > done by modifying the free block counts and m_usable_space when the
> > > reservations are made.
> > > 
> > 
> > Ok..
> > 
> > > For thin filesystems, we've already got 90TB of space "reserved",
> > > and so the metadata reservations and allocations come from that.
> > > i.e. we skip the modification of free block counts and m_usable
> > > space in the case of a thinspace filesystem, and so the user still
> > > sees 10TB of usable space that they asked to have.
> > > 
> > 
> > Hmm.. so then I'm slightly confused regarding the thin use case
> > regarding prevention of pool depletion. The usable blocks value that the
> > user settles on is likely based on how much space the filesystem should
> > use to safely avoid pool depletion.
> 
> I did say up front that the user data thinspace accounting would not
> be an exact reflection of underlying storage pool usage. Things like
> partially written blocks in the underlying storage pool mean write
> amplification factors would need to be considered, but that's
> something the admin already has to deal with in thinly provisioned
> storage.
> 

Ok, I recall this coming up one way or another. For some reason I
thought something might have changed in the implementation since then
and/or managed to confuse myself over the current behavior.

> > If a usable value of 10T means the
> > filesystem can write to the usable 10T + some amount of metadata
> > reservation, how does the user determine a sane usable value based on
> > the current pool geometry?
> 
> From an admin POV it's damn easy to document in admin guides that
> actual space usage of a thinspace filesysetm is going to be in the
> order of 2% greater than the space given to the filesystem for user
> data. Use an overhead of 2-5% for internal management and the "small
> amount of extra space for internal metadata" issue can be ignored.
> 

It's easy to document whatever we want. :) I'm not convinced that is as
effective as a hard limit based on the fs features, but the latter is
more complex and may be overkill in most cases. So, documentation works
for me until/unless testing or real usage shows otherwise.

If it does come up, perhaps a script or userspace tool that somehow
presents the current internal reservation calculations (combined with
whatever geometry information is relevant) as something consumable for
the user (whether it be a simple dump of the active reservations, the
worst case consumption of a thin fs, etc.) might be a nice compromise.

> > > > The best I can read into the response here is that you think physical
> > > > shrink is unlikely enough to not need to care very much what kind of
> > > > interface confusion could result from needing to rev the current growfs
> > > > interface to support physical shrink on thin filesystems in the future.
> > > > Is that a fair assessment..?
> > > 
> > > Not really. I understand just how complex a physical shrink
> > > implementation is going to be, and have a fair idea of the sorts of
> > > craziness we'll need to add to xfs_growfs to support/co-ordinate a
> > > physical shrink operation.  From that perspective, I don't see a
> > > physical shrink working with an unchanged growfs interface. The
> > > discussion about whether or not we should physically shrink
> > > thinspace filesystems is almost completely irrelevant to the
> > > interface requirements of a physical shrink....
> > 
> > So it's not so much about the likelihood of realizing physical shrink,
> > but rather the likelihood that physical shrink would require to rev the
> > growfs structure anyways (regardless of this feature).
> 
> Yup, pretty much.
> 

Ok. I don't agree, but at least I understand your perspective. ;)

Brian

> Cheers,
> 
> Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
