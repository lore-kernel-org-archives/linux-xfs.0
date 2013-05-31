Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 117707F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 16:54:12 -0500 (CDT)
Date: Fri, 31 May 2013 16:54:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 10/9] xfs: fix dir3 freespace block corruption
Message-ID: <20130531215410.GH20932@sgi.com>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<20130528083717.GU29466@dastard> <20130530191553.GG20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130530191553.GG20932@sgi.com>
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

On Thu, May 30, 2013 at 02:15:53PM -0500, Ben Myers wrote:
> On Tue, May 28, 2013 at 06:37:17PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When the directory freespace index grows to a second block (2017
> > 4k data blocks in the directory), the initialisation of the second
> > new block header goes wrong. The write verifier fires a corruption
> > error indicating that the block number in the header is zero. This
> > was being tripped by xfs/110.
> > 
> > The problem is that the initialisation of the new block is done just
> > fine in xfs_dir3_free_get_buf(), but the caller then users a dirv2
> > structure to zero on-disk header fields that xfs_dir3_free_get_buf()
> > has already zeroed. These lined up with the block number in the dir
> > v3 header format.
> > 
> > While looking at this, I noticed that the struct xfs_dir3_free_hdr()
> > had 4 bytes of padding in it that wasn't defined as padding or being
> > zeroed by the initialisation. Add a pad field declaration and fully
> > zero the on disk and in-core headers in xfs_dir3_free_get_buf() so
> > that this is never an issue in the future. Note that this doesn't
> > change the on-disk layout, just makes the 32 bits of padding in the
> > layout explicit.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_dir2_format.h |    1 +
> >  fs/xfs/xfs_dir2_node.c   |   13 ++++++-------
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
> > index a3b1bd8..995f1f5 100644
> > --- a/fs/xfs/xfs_dir2_format.h
> > +++ b/fs/xfs/xfs_dir2_format.h
> > @@ -715,6 +715,7 @@ struct xfs_dir3_free_hdr {
> >  	__be32			firstdb;	/* db of first entry */
> >  	__be32			nvalid;		/* count of valid entries */
> >  	__be32			nused;		/* count of used entries */
> > +	__be32			pad;		/* 64 bit alignment. */
> 
> Yeah, my count also puts nused short of 64 bit alignment.  Looks ok.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Applied this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
