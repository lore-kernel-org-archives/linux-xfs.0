Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 86CC37F4E
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 14:38:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 639F38F8054
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:38:30 -0700 (PDT)
Date: Thu, 24 Jul 2014 15:38:26 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/18] xfs: define sparse inode chunks v5 sb feature bit
	and helper function
Message-ID: <20140724193825.GE37832@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-4-git-send-email-bfoster@redhat.com>
	<53D13D94.9030607@sgi.com> <20140724173701.GD37832@bfoster.bfoster>
	<53D1528F.5090906@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D1528F.5090906@sgi.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 24, 2014 at 01:38:07PM -0500, Mark Tinguely wrote:
> On 07/24/14 12:37, Brian Foster wrote:
> >On Thu, Jul 24, 2014 at 12:08:36PM -0500, Mark Tinguely wrote:
> >>On 07/24/14 09:22, Brian Foster wrote:
> >>>The sparse inode chunks feature will use the helper function to enable
> >>>the allocation of sparse inode chunks. The incompatible feature bit is
> >>>set on disk once a sparse inode chunk is allocated to prevent older
> >>>drivers from mounting an fs with sparse chunks.
> >>>
> >>>Note that the feature is hardcoded disabled and the feature bit not
> >>>included in the all features mask until fully implemented.
> >>>
> >>>Signed-off-by: Brian Foster<bfoster@redhat.com>
> >>>---
> >>
> >>Sorry if I missed it in the series but is there an
> >>XFS_FSOP_GEOM_FLAGS_SPINODES for xfs_info/growfs?
> >>
> >
> >Nope, looks like I missed it. It probably slipped my mind as I haven't
> >got into userspace yet and thus hadn't thought about xfs_info. I'll make
> >a note to add it, thanks!
> >
> >Brian
> 
> Again forgive my quick scanning of the series, but am I correct in thinking
> that this does not change the minimum number of reserved blocks for create
> like fs ops. The create/rename do some attempts to continue when it cannot
> get the full number of reserved blocks. Would allocating a sparse inode
> chunk make sense in that case? My gut says the complication does not.
> 

No problem, thanks for looking.

Correct... I haven't made any changes to transaction reservations or
things like XFS_CREATE_SPACE_RES(), etc. xfs_create() has the kind of
logic you describe where we set resblks = 0 if the reservation fails
with ENOSPC and try again with a flag set to indicate we can't do
allocations. My understanding is that this is justified since we could
always allocate an inode from an existing record and a dentry from an
unused slot in a directory.

Technically, I think we could explicitly allocate a sparse chunk in this
scenario if we wanted to, but we'd have to pass that down to/through the
allocation code in xfs_ialloc_ag_alloc(). I could be wrong, but I think
the reservation failure in this case will always be limited to a case
where we are truly up against ENOSPC (as opposed to failing due to an
extent length or alignment requirement), since the reservation comes out
of the sb counters. Given that, I tend to agree that it might not be
worth the extra complexity there.

Brian

> Thanks again,
> 
> --Mark.
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
