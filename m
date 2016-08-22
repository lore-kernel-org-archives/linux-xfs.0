Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07F877CA0
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 19:54:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 706DA304032
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2016 17:54:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ip09lgQ7jI3CYZM5 for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2016 17:54:43 -0700 (PDT)
Date: Mon, 22 Aug 2016 10:54:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V5] xfs_db: add crc manipulation commands
Message-ID: <20160822005441.GO19025@dastard>
References: <8cb34b7c-5154-ebb4-7706-1375e94abd74@redhat.com>
	<0bb88897-3dfc-de4e-05fb-b737221f0d80@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0bb88897-3dfc-de4e-05fb-b737221f0d80@sandeen.net>
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

On Sun, Aug 14, 2016 at 07:30:51PM -0500, Eric Sandeen wrote:
> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
> 
> If a structure has a CRC field, we can validate it, invalidate/corrupt
> it, or revalidate/rewrite it:
> 
> xfs_db> sb 0
> xfs_db> crc -v
> crc = 0x796c814f (correct)
> xfs_db> crc -i
> Metadata CRC error detected at block 0x0/0x200
> crc = 0x796c8150 (bad)
> xfs_db> crc -r
> crc = 0x796c814f (correct)
> 
> (-i and -r require "expert" write-capable mode)
> 
> This requires temporarily replacing the write verifier with
> a dummy which won't recalculate the CRC on the way to disk.
> 
> It also required me to write a new flist function, which is
> totally foreign to me, so hopefully done right - but it seems
> to work here.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Actually, this need more help....

> @@ -473,12 +474,15 @@ xfs_verify_recalc_crc(
>  void
>  write_cur(void)
>  {
> +	int skip_crc = (iocur_top->bp->b_ops->verify_write == xfs_dummy_verify);
> +

bool, and we can't use the iocur until we've checked if it's valid.
i.e. after this first check:

>  	if (iocur_sp < 0) {
>  		dbprintf(_("nothing to write\n"));
>  		return;
>  	}
>  
> -	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf) {
> +	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf &&
> +	    !skip_crc) {
>  		libxfs_dinode_calc_crc(mp, iocur_top->data);
>  		iocur_top->ino_crc_ok = 1;
>  	}

The line of code below this calculates CRCs for dquot buffers, so it
seems kind of broken to be skipping crc update for an inode but not
a dquot given they are updated in the same way....

Shouldn't this "skip_crc" condition also be applied to dquot
buffers, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
