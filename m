Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8D2B7F63
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 15:43:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42064AC001
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 13:43:59 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HUCmS02dZN3G7QLf for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 13:43:57 -0800 (PST)
Date: Mon, 9 Feb 2015 08:43:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 01/18] xfs: add sparse inode chunk alignment
	superblock field
Message-ID: <20150208214355.GB4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-2-git-send-email-bfoster@redhat.com>
	<20150206224047.GO12722@dastard>
	<20150208160402.GA2927@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150208160402.GA2927@bfoster.bfoster>
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

On Sun, Feb 08, 2015 at 11:04:03AM -0500, Brian Foster wrote:
> On Sat, Feb 07, 2015 at 09:40:47AM +1100, Dave Chinner wrote:
> > On Fri, Feb 06, 2015 at 02:52:48PM -0500, Brian Foster wrote:
> > > Add sb_spinoalignmt to the superblock to specify sparse inode chunk
> > > alignment. This also currently represents the minimum allowable sparse
> > > chunk allocation size.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h | 6 +++---
> > >  fs/xfs/libxfs/xfs_sb.c     | 4 ++--
> > >  2 files changed, 5 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 8eb7189..051c24d 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -170,7 +170,7 @@ typedef struct xfs_sb {
> > >  	__uint32_t	sb_features_log_incompat;
> > >  
> > >  	__uint32_t	sb_crc;		/* superblock crc */
> > > -	__uint32_t	sb_pad;
> > > +	xfs_extlen_t	sb_spinoalignmt;/* sparse inode chunk alignment */
> > 
> > That's a mounthful. sb_spino_align is a bit easier to read, IMO.
> > 
> 
> Ok.
> 
> > > @@ -282,7 +282,7 @@ typedef enum {
> > >  	XFS_SBS_LOGSECTLOG, XFS_SBS_LOGSECTSIZE, XFS_SBS_LOGSUNIT,
> > >  	XFS_SBS_FEATURES2, XFS_SBS_BAD_FEATURES2, XFS_SBS_FEATURES_COMPAT,
> > >  	XFS_SBS_FEATURES_RO_COMPAT, XFS_SBS_FEATURES_INCOMPAT,
> > > -	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_PAD,
> > > +	XFS_SBS_FEATURES_LOG_INCOMPAT, XFS_SBS_CRC, XFS_SBS_SPINOALIGNMT,
> > >  	XFS_SBS_PQUOTINO, XFS_SBS_LSN,
> > >  	XFS_SBS_FIELDCOUNT
> > >  } xfs_sb_field_t;
> > 
> > These are gone in the for-next tree.
> > 
> 
> The per-field logging stuff is gone... this apparently still exists. It
> looks like it goes away as part of the icsb rework so this will drop
> naturally whenever that goes in.

Ah, I can't even keep up with what I'm doing! :)

Yeah, that will go into the tree as soon as the 3.20 merge
window is done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
