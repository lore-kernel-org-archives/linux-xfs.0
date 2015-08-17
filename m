Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B7FEC7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:30:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7BF68F8040
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 13:30:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WK5zVvwczCsM0fqH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 13:30:35 -0700 (PDT)
Date: Mon, 17 Aug 2015 13:30:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 01/10] libxfs: readahead of dir3 data blocks should use
	the read verifier
Message-ID: <20150817203030.GM10043@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
	<20150815014344.1839.12045.stgit@birch.djwong.org>
	<55D2287B.9060900@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D2287B.9060900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 01:31:23PM -0500, Eric Sandeen wrote:
> On 8/14/15 8:43 PM, Darrick J. Wong wrote:
> > In the dir3 data block readahead function, use the regular read
> > verifier to check the block's CRC and spot-check the block contents
> > instead of calling the spot-checking routine directly.  This prevents
> > corrupted directory data blocks from being read into the kernel, which
> > can lead to garbage ls output and directory loops (if say one of the
> > entries contains invalid characters).
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  libxfs/xfs_dir2_data.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
> > index c475ba8..466e096 100644
> > --- a/libxfs/xfs_dir2_data.c
> > +++ b/libxfs/xfs_dir2_data.c
> > @@ -250,7 +250,8 @@ xfs_dir3_data_reada_verify(
> >  		return;
> >  	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
> >  	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
> > -		xfs_dir3_data_verify(bp);
> > +		bp->b_ops = &xfs_dir3_block_buf_ops;
> > +		bp->b_ops->verify_read(bp);
> 
> Shouldn't that be xfs_dir3_data_buf_ops ?

D'oh.  Yep, good catch.

--D

> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
