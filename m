Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19896 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdDLGLf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Apr 2017 02:11:35 -0400
Date: Tue, 11 Apr 2017 23:11:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: allow write -d to inodes
Message-ID: <20170412061127.GL8502@birch.djwong.org>
References: <20170411225334.GE8502@birch.djwong.org>
 <0bdbeabb-f632-b5d3-4400-a8aedf590013@redhat.com>
 <5a8a9a91-cf57-5077-3f86-ca5830e52ebd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8a9a91-cf57-5077-3f86-ca5830e52ebd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Tue, Apr 11, 2017 at 09:58:44PM -0500, Eric Sandeen wrote:
> On 4/11/17 9:09 PM, Eric Sandeen wrote:
> > On 4/11/17 5:53 PM, Darrick J. Wong wrote:
> >> From: Darrick J. Wong <darrick.wong@oracle.com>
> >>
> >> Add a helper function to xfs_db so that we can recalculate the CRC of an
> >> inode whose field we just wrote.  This enables us to write arbitrary
> >> values with a good CRC for the purpose of checking the read verifiers on
> >> a v5 filesystem.  Mention this newfound ability in the manpage.
> > 
> > -d isn't new, so I'd really rather have a patch to document the existing
> > behavior, followed by a patch to extend it to inodes.
> > 
> > There are actually several structures for which -d still won't work, so
> > it would be good if that fact were documented - reading "including
> > inodes" may leave some heads scratching.
> > 
> > Let me ruminate on the inode crc writing, I have this nagging feeling
> > that there's an easier generic way to handle these structures,
> > ...but I'm probably wrong.
> 
> I don't know where I was going with that idea.  :/
> 
> I can split this up into a manpage patch and an inode crc patch on
> the way in if you'd like.

Works for me.

--D

> 
> For the content as-is, 
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> -Eric
> 
> > Thanks,
> > -Eric
> > 
> >> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> ---
> >>  db/io.c           |   11 +++++++++++
> >>  db/io.h           |    1 +
> >>  db/write.c        |    7 ++++++-
> >>  man/man8/xfs_db.8 |    7 ++++++-
> >>  4 files changed, 24 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/db/io.c b/db/io.c
> >> index f398195..67ed5f9 100644
> >> --- a/db/io.c
> >> +++ b/db/io.c
> >> @@ -465,6 +465,17 @@ xfs_dummy_verify(
> >>  }
> >>  
> >>  void
> >> +xfs_verify_recalc_inode_crc(
> >> +	struct xfs_buf *bp)
> >> +{
> >> +	ASSERT(iocur_top->ino_buf);
> >> +	ASSERT(iocur_top->bp == bp);
> >> +
> >> +	libxfs_dinode_calc_crc(mp, iocur_top->data);
> >> +	iocur_top->ino_crc_ok = 1;
> >> +}
> >> +
> >> +void
> >>  xfs_verify_recalc_crc(
> >>  	struct xfs_buf *bp)
> >>  {
> >> diff --git a/db/io.h b/db/io.h
> >> index c69e9ce..12d96c2 100644
> >> --- a/db/io.h
> >> +++ b/db/io.h
> >> @@ -64,6 +64,7 @@ extern void	set_cur(const struct typ *t, __int64_t d, int c, int ring_add,
> >>  extern void     ring_add(void);
> >>  extern void	set_iocur_type(const struct typ *t);
> >>  extern void	xfs_dummy_verify(struct xfs_buf *bp);
> >> +extern void	xfs_verify_recalc_inode_crc(struct xfs_buf *bp);
> >>  extern void	xfs_verify_recalc_crc(struct xfs_buf *bp);
> >>  
> >>  /*
> >> diff --git a/db/write.c b/db/write.c
> >> index 5c83874..70c9865 100644
> >> --- a/db/write.c
> >> +++ b/db/write.c
> >> @@ -137,7 +137,9 @@ write_f(
> >>  		return 0;
> >>  	}
> >>  
> >> -	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
> >> +	if (invalid_data &&
> >> +	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
> >> +	    !iocur_top->ino_buf) {
> >>  		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
> >>  		return 0;
> >>  	}
> >> @@ -164,6 +166,9 @@ write_f(
> >>  	if (corrupt) {
> >>  		local_ops.verify_write = xfs_dummy_verify;
> >>  		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
> >> +	} else if (iocur_top->ino_buf) {
> >> +		local_ops.verify_write = xfs_verify_recalc_inode_crc;
> >> +		dbprintf(_("Allowing write of corrupted inode with good CRC\n"));
> >>  	} else { /* invalid data */
> >>  		local_ops.verify_write = xfs_verify_recalc_crc;
> >>  		dbprintf(_("Allowing write of corrupted data with good CRC\n"));
> >> diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
> >> index 460d89d..b1c341d 100644
> >> --- a/man/man8/xfs_db.8
> >> +++ b/man/man8/xfs_db.8
> >> @@ -755,7 +755,7 @@ and
> >>  bits respectively, and their string equivalent reported
> >>  (but no modifications are made).
> >>  .TP
> >> -.BI "write [\-c] [" "field value" "] ..."
> >> +.BI "write [\-c] [\-d] [" "field value" "] ..."
> >>  Write a value to disk.
> >>  Specific fields can be set in structures (struct mode),
> >>  or a block can be set to data values (data mode),
> >> @@ -778,6 +778,11 @@ with no arguments gives more information on the allowed commands.
> >>  .B \-c
> >>  Skip write verifiers and CRC recalculation; allows invalid data to be written
> >>  to disk.
> >> +.TP 0.4i
> >> +.B \-d
> >> +Skip write verifiers but perform CRC recalculation.
> >> +This allows invalid data, including inodes, to be written to disk to
> >> +test detection of invalid data.
> >>  .RE
> >>  .SH TYPES
> >>  This section gives the fields in each structure type and their meanings.
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
