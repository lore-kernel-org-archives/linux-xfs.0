Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DA0AD7F75
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 15:58:41 -0500 (CDT)
Date: Tue, 1 Oct 2013 15:58:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: get rid of count from xfs_iomap_write_allocate()
Message-ID: <20131001205840.GT1935@sgi.com>
References: <52480744.10606@oracle.com>
 <20130929223511.GF26872@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130929223511.GF26872@dastard>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Dave Chinner <dchinner@redhat.com>

On Mon, Sep 30, 2013 at 08:35:11AM +1000, Dave Chinner wrote:
> On Sun, Sep 29, 2013 at 06:56:04PM +0800, Jeff Liu wrote:
> > From: Jie Liu <jeff.liu@oracle.com>
> > 
> > Get rid of function variable count from xfs_iomap_write_allocate() as
> > it is unused.
> > 
> > Additionally, checkpatch warn me of the following for this change:
> > WARNING: extern prototypes should be avoided in .h files
> > +extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
> 
> Bah, checkpatch should be considered harmful when run on code that
> has been around for years. It's a good guide for new code, but...
> 
> $ git grep extern fs/xfs/xfs*h |wc -l
> 345
> $ git grep extern include/linux/*h |wc -l
> 6878
> $
> 
> .... and the rule of "consistent with existing coding style" when
> adding code to existing files generally trumps any "style errors"
> that checkpatch might warn about.
> 
> > So this patch also remove all extern function prototypes at xfs_iomap.h
> > to suppress it to make this code style in consistent manner in this file.
> 
> Anyway, it's a cleanup patch to begin with, and there's only a few
> of them, so it's not worth complaining about.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
