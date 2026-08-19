Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B73630A7;
	Wed, 19 Aug 2026 23:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787180922; cv=none; b=PLqwtOXkNBGWRWBg1deqCSGIuLjlsOvrjQ6E7J8CJu77hFivrRmiNzgftbu1j1DhoLqfCExcsyxf4pZmvHD4TUi6m8s/1LUqygfSqv9rzocwdSQTyaD1SvYEJ8Iiky1/wY7Fz3qNyMzuU14qj8ENBlQIcTA7uBdjviMHrBFMoNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787180922; c=relaxed/simple;
	bh=chwpOKWy7vARC3b2V1acQT6+hv/83P3daL6Imd1VbiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WA6wUEPaV5glTkbF90gc7G6MIUSZp7+bzpB+RYQ+howvWFROtbkb33q3o2LTxs+FS3M9IeFGGxr/FuUNhdSZBIDnKTBWGeaKM50PSlkKpaM1ieednCtiBHQnHeMjNU3PvfiHDw0EDZ5nVx+9/TxL7EBI4JjnCrQdqpWuEZCx6sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdkbKZye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdkbKZye"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6B5361F00A3A;
	Wed, 19 Aug 2026 23:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787180920;
	bh=Qq+atXIHZbG6mI56G+lYANahihiyvp/0gCb69c6qhfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GdkbKZye7t4d/DrPoeSyG+HWShT6K1eXPIkcRya8k7isgR/WeA1Qop8tykVUTFxY9
	 QYd2Xxg03cuRtbRe4iXKIqALeRUIU1GkAeX6/6ouFGg83i/WZ2aAqFGIDhOROJIlFH
	 c6bR/4f04h37PRU9gxjjSAVUMx1iRAONkqgM85ANIc3JiIBbJplkOD+PvT85ZrV+wl
	 QY4UcePc3cji0Bncx9t6VRuJhWm74BZaZyWHXeNYIxQEpmT0t4C3XNH0Pp6es5Tdpu
	 R710E88iu4ju//L/EerNnbJS0jyuQxuoblJxRxbFQq6Kdvl/zSMFMfTvv2kOst4W5f
	 aIPTCaxRfZTeQ==
Date: Wed, 19 Aug 2026 16:08:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: adjust datadev sector count to reflect internal
 rt volumes
Message-ID: <20260819230839.GB6072@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
 <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
 <aoVOIZqmmAI7FYlm@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoVOIZqmmAI7FYlm@infradead.org>

On Tue, Aug 18, 2026 at 11:33:05PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 12, 2026 at 10:25:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > A media scan of a filesystem containing an internal rt volume produced
> > an error in xfs_scrub phase 6 complaining about a truncated realtime
> > device.  The rt device wasn't truncated, but the media scan code thought
> > we were trying to start a scan past the end of m_rtdev_targp.  That in
> > turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> > nr_sectors to the size of the data section.  Oops.
> 
> Can you share your reproducer for this?

# mkfs.xfs -f /dev/sda -r zoned=1 -d rtinherit=1
# mount /dev/sda /mnt
# dd if=/dev/zero of=/mnt/a bs=1024k count=100
# sync
# xfs_info /mnt
meta-data=/dev/sda               isize=512    agcount=4, agsize=32768 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
         =                       exchange=1   metadir=1
data     =                       bsize=4096   blocks=131072, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =internal               extsz=4096   blocks=1114112, rtextents=1114112
         =                       rgcount=17   rgsize=65536 extents
         =                       zoned=1      start=131072 reserved=53248

IOWS: 512M data volume, 3.1G internal rt section
Now let's try some media verification:

# xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt
verified 536870912/536870912 bytes at offset 0
512 MiB, 1 ops; 0.0496 sec (10.067 GiB/sec and 20.1345 ops/sec)
verified 536870912/536870912 bytes at offset 0
512 MiB, 1 ops; 0.0409 sec (12.222 GiB/sec and 24.4439 ops/sec)

Notice how xfs_io says we only verified 512M of the rt volume?
If you run btrace in the background you'll see that we read the first
512M of the volume (aka the data section) twice and never read anything
from the rt section.

Ofc my solution does too /much/ work:

# xfs_io -c 'verifymedia -d' -c 'verifymedia -r' /mnt
verified 5100273664/5100273664 bytes at offset 0
4.750 GiB, 1 ops; 0.2894 sec (16.410 GiB/sec and 3.4548 ops/sec)
verified 5100273664/5100273664 bytes at offset 0
4.750 GiB, 1 ops; 0.2635 sec (18.020 GiB/sec and 3.7936 ops/sec)

We really only needed to 

> > On these filesystems, the internal rt section comes immediately after
> > the data section.  We need to set the sector count for the data device
> > buftarg to the size of both sections.  Without this, media scans don't
> > work and media failure notifications from the kernel will be discarded
> > silently.
> > 
> > We also need to fix the superblock buffer recovery code to do the same.
> 
> I still think messing with the kernel buftarg nr_sectors is wrong for
> this.

I had thought of an alternate version of this patch which would do
something like this:

xfs_daddr_t
xfs_verify_media_nr_sectors(struct xfs_mount *mp, enum xfs_device d)
{
	switch (d) {
	case XFS_DATA_DEV:
		return XFS_FSB_TO_BB(sb_dblocks);
	case XFS_LOG_DEV:
		if (!sb_logstart)
			return 0;
		return XFS_FSB_TO_BB(sb_logblocks);
	case XFS_RT_DEV:
		if (sb_rtstart)
			return XFS_FSB_TO_BB(sb_rtstart + sb_rtblocks);
		return XFS_FSB_TO_BB(sb_rtblocks):
	}
}

and then you clamp the inputs based on xfs_verify_media_nr_sectors
instead of btp->nr_sectors.  You'd also have to change
xfs_dax_translate_range tbecause it clamps the range that the dax code
gives it to (0..nr_sectors].  One could reuse the function above to fix
that, but at that point I decided to just fix the buftarg.

> The kernel view of the buftarg should be correct and just include
> the part of the device that matters.  So I think the right fix in the
> kernel is changing xfs_verify_media to add the internal RT device offset
> before sending the bios.   We might need additional userland fixes,
> but from a quick look I think it should be fine (famous last words)

Add?  The interface for the media verification ioctl already requires
that the caller already added rtstart to the starting address, because
xfs_daddr_to_rtb subtracts rtstart from the user's start value to find
the rtgroup.

Remember that GETFSMAP returns physical addresses that include rtstart.
xfs_scrub takes those fsmap addresses and passes those directly to the
media verification ioctl.

What do you think of changing xfs_verify_media to ignore the first
rtstart blocks on an internal rt volume?  Something like this:

diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
index 5ead3976d51151..f47c4b851082f2 100644
--- a/fs/xfs/xfs_verify_media.c
+++ b/fs/xfs/xfs_verify_media.c
@@ -268,6 +268,8 @@ xfs_verify_media(
 	struct xfs_buftarg	*btp = NULL;
 	struct bio		*bio;
 	struct folio		*folio;
+	xfs_daddr_t		start_daddr = 0;
+	xfs_daddr_t		end_daddr = 0;
 	xfs_daddr_t		daddr;
 	uint64_t		bbcount;
 	int			error = 0;
@@ -277,13 +279,19 @@ xfs_verify_media(
 	switch (me->me_dev) {
 	case XFS_DEV_DATA:
 		btp = mp->m_ddev_targp;
+		end_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
 		break;
 	case XFS_DEV_LOG:
-		if (mp->m_logdev_targp != mp->m_ddev_targp)
+		if (mp->m_logdev_targp != mp->m_ddev_targp) {
 			btp = mp->m_logdev_targp;
+			end_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+		}
 		break;
 	case XFS_DEV_RT:
 		btp = mp->m_rtdev_targp;
+		start_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
+		end_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart +
+					      mp->m_sb.sb_rblocks);
 		break;
 	}
 	if (!btp)
@@ -293,8 +301,8 @@ xfs_verify_media(
 	 * If the caller told us to verify beyond the end of the disk, tell the
 	 * user exactly where that was.
 	 */
-	if (me->me_end_daddr > btp->bt_nr_sectors)
-		me->me_end_daddr = btp->bt_nr_sectors;
+	if (me->me_end_daddr > end_daddr)
+		me->me_end_daddr = end_daddr;
 
 	/* start and end have to be aligned to the lba size */
 	if (!IS_ALIGNED(BBTOB(me->me_start_daddr | me->me_end_daddr),
@@ -312,8 +320,9 @@ xfs_verify_media(
 	 * There are three ranges involved here:
 	 *
 	 *  - [me->me_start_daddr, me->me_end_daddr) is the range that the
-	 *    user wants to verify.  end_daddr can be beyond the end of the
-	 *    disk; we'll constrain it to the end if necessary.
+	 *    user wants to verify.  me_end_daddr can be beyond the end of the
+	 *    disk; we'll constrain it to the end if necessary.  me_start_daddr
+	 *    can be before the start of the disk; we'll constrain that too.
 	 *
 	 *  - [daddr, me->me_end_daddr) is the range that we have not yet
 	 *    verified.  We update daddr after each successful read.
@@ -322,9 +331,8 @@ xfs_verify_media(
 	 *  - [daddr, daddr + bio_bbcount) is the range that we're currently
 	 *    verifying.
 	 */
-	daddr = me->me_start_daddr;
-	bbcount = min_t(sector_t, me->me_end_daddr, btp->bt_nr_sectors) -
-			  me->me_start_daddr;
+	daddr = max_t(sector_t, start_daddr, me->me_start_daddr);
+	bbcount = min_t(sector_t, me->me_end_daddr, end_daddr) - daddr;
 
 	folio = xfs_verify_alloc_folio(xfs_verify_iosize(me, btp, bbcount));
 	if (!folio)

--D
