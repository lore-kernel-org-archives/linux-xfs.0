Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 18AF529DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:22:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF29DAC008
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:22:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7Gg2eI7HUoc14VEL for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 14:22:25 -0700 (PDT)
Date: Sat, 7 Sep 2013 07:22:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 03/11] xfs: support the XFS_BTNUM_FINOBT free inode
	btree type
Message-ID: <20130906212220.GA12541@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-4-git-send-email-bfoster@redhat.com>
	<20130905005428.GQ23571@dastard> <5228AE80.5050908@redhat.com>
	<20130906000754.GO12779@dastard> <5229BBC6.5000808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5229BBC6.5000808@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Sep 06, 2013 at 07:25:58AM -0400, Brian Foster wrote:
> On 09/05/2013 08:07 PM, Dave Chinner wrote:
> > On Thu, Sep 05, 2013 at 12:17:04PM -0400, Brian Foster wrote:
> >> On 09/04/2013 08:54 PM, Dave Chinner wrote:
> >>> On Tue, Sep 03, 2013 at 02:25:00PM -0400, Brian Foster wrote:
> ...
> >>>
> >>> What we really need here is for xfs_ialloc_log_agi to consider that
> >>> there are two distinct regions for range logging - the first spaces
> >>> from offset 0 to offset of agi_unlinked, and the second is from the
> >>> the offset of agi_free_root to the end of the xfs_agi_t....
> >>>
> >>> It's abit messy, I know, but we couldn't easily add new padding to
> >>> the AGI in the existing range logging area like was done for the AGF
> >>> because of the unlinked list hash table already defining the end of
> >>> the range logging region....
> >>>
> >>
> >> ... but where would that ever happen? The existing invocations of
> >> xfs_ialloc_log_agi() seem to log either the agi inode count values or
> >> the btree root/level values (i.e., never the range across both). I think
> >> I've introduced at least a couple new invocations throughout this set,
> >> but I've not changed that model (i.e., an XFS_AGI_FREECOUNT instance in
> >> the new lookup code and an XFS_AGI_FREE_ROOT|*_LEVEL instance in the new
> >> btree code).
> > 
> > Right, we don't current log across the range because of the way the
> > code is currently written, but there's no rule that says that
> > logging fields must be done this way.
> > 
> > I can see that there may be reason for logging
> > XFS_AGI_FREE_ROOT|*_LEVEL and XFS_AGI_NEW_INODE all in one go -
> > pointing new inode allocation at recently freed inodes is not
> > unreasonable, and if we split the finobt and update agi_newino in
> > the one update, we will log across this gap.
> > 
> 
> For the sake of argument, it seems a little strange to me to set an
> inode level value in the agi in the context of a btree operation, such
> as a split...

Like we do with the AGF to record changes to the longest
extent in the btree? It's not a stretch to think we might update
the "allocation from here" target in the AGI when we make a specific
type of btree record change.... ;)

True, that is still an isolated logging event, but my point is that
specific btree operations may drive other logging events in the
header than just root/level...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
