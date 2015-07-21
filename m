Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EE517F90
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 10:45:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 055C1304053
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2015 08:45:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KgTP1cLdUr7yS0Tq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Jul 2015 08:45:50 -0700 (PDT)
Date: Tue, 21 Jul 2015 11:45:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_copy: fix up initial sb buffer read on CRC fs
Message-ID: <20150721154547.GG23013@bfoster.bfoster>
References: <55A7F5EE.5000500@sandeen.net>
	<20150721123158.GF23013@bfoster.bfoster>
	<9B4E8358-4DAC-4092-AF1F-A9E5A71C18C5@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9B4E8358-4DAC-4092-AF1F-A9E5A71C18C5@sandeen.net>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 21, 2015 at 10:11:05AM -0500, Eric Sandeen wrote:
> 
> 
> > On Jul 21, 2015, at 7:31 AM, Brian Foster <bfoster@redhat.com> wrote:
> > 
> >> On Thu, Jul 16, 2015 at 01:20:30PM -0500, Eric Sandeen wrote:
> >> My prior commit, aaf90a2 xfs_copy: fix copy of hard 4k devices
> >> causes xfs_copy to emit a CRC error warning when copying a
> >> CRC filesystem.
> >> 
> >> This is because we are now reading the maximum sector size,
> >> and attempting to verify the CRC based on that (likely incorrect)
> >> length.
> >> 
> >> In xfs_db, we currently just don't verify this read, so it's
> >> not a problem.  In xfs_copy, we almost certainly want to verify.
> >> 
> >> So, first do the maximal read with no verifier; once it's read,
> >> drop that buffer, and re-read with the proper sector size and
> >> verifier.
> >> 
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >> 
> >> diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
> >> index 44a32e8..fd96e15 100644
> >> --- a/copy/xfs_copy.c
> >> +++ b/copy/xfs_copy.c
> >> @@ -654,11 +654,17 @@ main(int argc, char **argv)
> >> 
> >>    memset(&mbuf, 0, sizeof(xfs_mount_t));
> >>    libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
> >> +    /* We don't yet know the sector size, so read maximal size */
> >>    sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
> >> -                 1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT),
> >> -                 0, &xfs_sb_buf_ops);
> >> +                 1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
> >>    sb = &mbuf.m_sb;
> >>    libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
> >> +    /* Do it again, now with proper length and verifier */
> >> +    libxfs_putbuf(sbp);
> >> +    libxfs_purgebuf(sbp);
> > 
> > Why the purge? On a quick look, it looks like the buffer cache code
> > would handle this if the buffer size changes.
> > 
> > Hmm, is it to ensure the verification occurs if the buffer size doesn't
> > actually change? If so, I'd suggest to enhance the comment. :)
> > 
> Without the purge, a re-read of a different size at the same offset seems to cause  cache mismatch problems.
> 

Ok, fair enough. Care to update the comment? Otherwise this seems good
to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> Eric
> 
> > Brian
> > 
> >> +    sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
> >> +                 1 << (sb->sb_sectlog - BBSHIFT),
> >> +                 0, &xfs_sb_buf_ops);
> >> 
> >>    /*
> >>     * For now, V5 superblock filesystems are not supported without -d;
> >> 
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> > 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
