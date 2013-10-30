Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 249AF7F54
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 13:51:19 -0500 (CDT)
Date: Wed, 30 Oct 2013 13:51:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 12/15] xfs: make dir2 ftype offset pointers explicit
Message-ID: <20131030185118.GJ1935@sgi.com>
References: <1383045118-31107-1-git-send-email-david@fromorbit.com>
	<1383045118-31107-13-git-send-email-david@fromorbit.com>
	<20131029200008.GF1935@sgi.com> <20131029221545.GD6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131029221545.GD6188@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Oct 30, 2013 at 09:15:45AM +1100, Dave Chinner wrote:
> On Tue, Oct 29, 2013 at 03:00:08PM -0500, Ben Myers wrote:
> > On Tue, Oct 29, 2013 at 10:11:55PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Rather than hiding the ftype field size accounting inside the dirent
> > > padding for the ".." and first entry offset functions for v2
> > > directory formats, add explicit functions that calculate it
> > > correctly.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_da_format.c | 23 +++++++++++++++++++++--
> > >  1 file changed, 21 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_da_format.c b/fs/xfs/xfs_da_format.c
> > > index 5991b26..5a5767c 100644
> > > --- a/fs/xfs/xfs_da_format.c
> > > +++ b/fs/xfs/xfs_da_format.c
> > > @@ -334,6 +334,25 @@ xfs_dir2_data_first_entry_p(
> > >  }
> > >  
> > >  static struct xfs_dir2_data_entry *
> > > +xfs_dir2_ftype_data_dotdot_entry_p(
> > > +	struct xfs_dir2_data_hdr *hdr)
> > > +{
> > > +	return (struct xfs_dir2_data_entry *)
> > > +		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> > > +				XFS_DIR3_DATA_ENTSIZE(1));
> > > +}
> > > +
> > > +static struct xfs_dir2_data_entry *
> > > +xfs_dir2_ftype_data_first_entry_p(
> > > +	struct xfs_dir2_data_hdr *hdr)
> > > +{
> > > +	return (struct xfs_dir2_data_entry *)
> > > +		((char *)hdr + sizeof(struct xfs_dir2_data_hdr) +
> > > +				XFS_DIR3_DATA_ENTSIZE(1) +
> > > +				XFS_DIR3_DATA_ENTSIZE(2));
> > > +}
> > 
> > 363 static struct xfs_dir2_data_entry *
> > 364 xfs_dir3_data_dotdot_entry_p(
> > 365         struct xfs_dir2_data_hdr *hdr)
> > 366 {
> > 367         return (struct xfs_dir2_data_entry *)
> > 368                 ((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
> > 369                                 XFS_DIR2_DATA_ENTSIZE(1));
> > 370 }
> > 371 
> > 372 static struct xfs_dir2_data_entry *
> > 373 xfs_dir3_data_first_entry_p(
> > 374         struct xfs_dir2_data_hdr *hdr)
> > 375 {
> > 376         return (struct xfs_dir2_data_entry *)
> > 377                 ((char *)hdr + sizeof(struct xfs_dir3_data_hdr) +
> > 378                                 XFS_DIR2_DATA_ENTSIZE(1) +
> > 379                                 XFS_DIR2_DATA_ENTSIZE(2));
> > 380 }
> > 					   3
> > 
> > We want dir3 entry size there, I think?
> 
> Fixed in V2 of the patch that introduced the problem.

Fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
