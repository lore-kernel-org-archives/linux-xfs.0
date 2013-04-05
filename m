Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61E7C29DFE
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 06:37:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF686AC002
	for <xfs@oss.sgi.com>; Fri,  5 Apr 2013 04:37:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aQvLkOyOcePgAXng for
	<xfs@oss.sgi.com>; Fri, 05 Apr 2013 04:37:41 -0700 (PDT)
Message-ID: <515EB6E4.7060508@redhat.com>
Date: Fri, 05 Apr 2013 07:35:00 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 23/22] xfs: add metadata CRC documentation
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<20130405070006.GJ12011@dastard>
In-Reply-To: <20130405070006.GJ12011@dastard>
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

On 04/05/2013 03:00 AM, Dave Chinner wrote:
> xfs: add metadata CRC documentation
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add some documentation about the self describing metadata and the
> code templates used to implement it.

Thanks for the write up. Very nice read. A couple minor/random comments
and a question to follow...

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  .../filesystems/xfs-self-describing-metadata.txt   |  352 ++++++++++++++++++++
>  1 file changed, 352 insertions(+)
> 
> diff --git a/Documentation/filesystems/xfs-self-describing-metadata.txt b/Documentation/filesystems/xfs-self-describing-metadata.txt
> new file mode 100644
> index 0000000..da7edc9
> --- /dev/null
> +++ b/Documentation/filesystems/xfs-self-describing-metadata.txt
> @@ -0,0 +1,352 @@
> +XFS Self Describing Metadata
> +----------------------------
> +
> +Introduction
> +------------
> +
...
> +
> +
> +Self Describing Metadata
> +------------------------
> +
...
> +
> +Different types of metadata have different owner identifiers. For example,
> +directory, attribute and extent tree blocks are all owned by an inode, whilst
> +freespace btree blocks are owned by an allocation group. Hence the size and
> +contents of the owner field are determined by the type of metadata object we are
> +looking at. For example, directories, extent maps and attributes are owned by
> +inodes, while freespace btree blocks are owned by a specific allocation group.

Looks like repetition from the sentence before last.

> +THe owner information can also identify misplaced writes (e.g. freespace btree
> +block written to the wrong AG).
> +
> +Self describing metadata also needs to contain some indication of when it was
> +written to the filesystem. One of the key information points when doing forensic
> +analysis is how recently the block was modified. Correlation of set of corrupted
> +metadata blocks based on modification times is important as it can indicate
> +whether the corruptions are related, whether there's been multiple corruption
> +events that lead to the eventual failure, and even whether there are corruptions
> +present that the run-time verification is not detecting.
> +
> +For example, we can determine whether a metadata object is supposed to be free
> +space or still allocated when it is still referenced by it's owner can be
> +determined by looking at when the free space btree block that contains the block

I think you mean to drop the "can be determined" mid-sentence.

> +was last written compared to when the metadata object itself was last written.
> +If the free space block is more recent than the object and the objects owner,
> +then there is a very good chance that the block should have been removed from
> +it's owner.
> +
...
> +
> +Runtime Validation
> +------------------
> +
...
> +
> +The first step in read verification is checking the magic number and determining
> +whether CRC validating is necessary. If it is, the CRC32c is caluclated and

What do you mean by "determining whether CRC validating is necessary?"
In other words, it's not always enabled but rather triggered by
something else that elevates suspicion on the object?

/me should probably use this to look at the code... ;)

Brian

> +compared against the value stored in the object itself. Once this is validated,
> +further checks are made against the location information, followed by extensive
> +object specific metadata validation. If any of these checks fail, then the
> +buffer is considered corrupt and the EFSCORRUPTED error is set appropriately.
> +
> +Write verification is the opposite of the read verification - first the object
> +is extensively verified and if it is OK we then update the LSN from the last
> +modification made to the object, After this, we calculate the CRC and insert it
> +into the object. Once this is done the write IO is allowed to continue. If any
> +error occurs during this process, the buffer is again marked with a EFSCORRUPTED
> +error for the higher layers to catch.
> +
> +Structures
> +----------
> +
> +A typical on-disk structure needs to contain the following information:
> +
> +struct xfs_ondisk_hdr {
> +        __be32  magic;		/* magic number */
> +        __be32  crc;		/* CRC, not logged */
> +        uuid_t  uuid;		/* filesystem identifier */
> +        __be64  owner;		/* parent object */
> +        __be64  blkno;		/* location on disk */
> +        __be64  lsn;		/* last modification in log, not logged */
> +};
> +
> +Depending on the metadata, this information may be part of a header stucture
> +separate to the metadata contents, or may be distributed through an existing
> +structure. The latter occurs with metadata that already contains some of this
> +information, such as the superblock and AG headers.
> +
> +Other metadata may have different formats for the information, but the same
> +level of information is generally provided. For example:
> +
> +	- short btree blocks have a 32 bit owner (ag number) and a 32 bit block
> +	  number for location. The two of these combined provide the same
> +	  information as @owner and @blkno in eh above structure, but using 8
> +	  bytes less space on disk.
> +
> +	- directory/attribute node blocks have a 16 bit magic number, and the
> +	  header that contains the magic number has other information in it as
> +	  well. hence the additional metadata headers change the overall format
> +	  of the metadata.
> +
> +A typical buffer read verifier is structured as follows:
> +
> +#define XFS_FOO_CRC_OFF		offsetof(struct xfs_ondisk_hdr, crc)
> +
> +static void
> +xfs_foo_read_verify(
> +	struct xfs_buf	*bp)
> +{
> +       struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +        if ((xfs_sb_version_hascrc(&mp->m_sb) &&
> +             !xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
> +					XFS_FOO_CRC_OFF)) ||
> +            !xfs_foo_verify(bp)) {
> +                XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +                xfs_buf_ioerror(bp, EFSCORRUPTED);
> +        }
> +}
> +
> +The code ensures that the CRC is only checked if the filesystem has CRCs enabled
> +by checking the superblock of the feature bit, and then if the CRC verifies OK
> +(or is not needed) it then verifies the actual contents of the block.
> +
> +The verifier function will take a couple of different forms, depending on
> +whether the magic number can be used to determine the format of the block. In
> +the case it can't, the code will is structured as follows:
> +
> +static bool
> +xfs_foo_verify(
> +	struct xfs_buf		*bp)
> +{
> +        struct xfs_mount	*mp = bp->b_target->bt_mount;
> +        struct xfs_ondisk_hdr	*hdr = bp->b_addr;
> +
> +        if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
> +                return false;
> +
> +        if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +		if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
> +			return false;
> +		if (bp->b_bn != be64_to_cpu(hdr->blkno))
> +			return false;
> +		if (hdr->owner == 0)
> +			return false;
> +	}
> +
> +	/* object specific verification checks here */
> +
> +        return true;
> +}
> +
> +If there are different magic numbers for the different formats, the verifier
> +will look like:
> +
> +static bool
> +xfs_foo_verify(
> +	struct xfs_buf		*bp)
> +{
> +        struct xfs_mount	*mp = bp->b_target->bt_mount;
> +        struct xfs_ondisk_hdr	*hdr = bp->b_addr;
> +
> +        if (hdr->magic == cpu_to_be32(XFS_FOO_CRC_MAGIC)) {
> +		if (!uuid_equal(&hdr->uuid, &mp->m_sb.sb_uuid))
> +			return false;
> +		if (bp->b_bn != be64_to_cpu(hdr->blkno))
> +			return false;
> +		if (hdr->owner == 0)
> +			return false;
> +	} else if (hdr->magic != cpu_to_be32(XFS_FOO_MAGIC))
> +		return false;
> +
> +	/* object specific verification checks here */
> +
> +        return true;
> +}
> +
> +Write verifiers are very similar to the read verifiers, they just do things in
> +the opposite order to the read verifiers. A typical write verifier:
> +
> +static void
> +xfs_foo_write_verify(
> +	struct xfs_buf	*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
> +
> +	if (!xfs_foo_verify(bp)) {
> +		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
> +		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		return;
> +	}
> +
> +	if (!xfs_sb_version_hascrc(&mp->m_sb))
> +		return;
> +
> +
> +	if (bip) {
> +		struct xfs_ondisk_hdr	*hdr = bp->b_addr;
> +		hdr->lsn = cpu_to_be64(bip->bli_item.li_lsn);
> +	}
> +	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length), XFS_FOO_CRC_OFF);
> +}
> +
> +This will verify the internal structure of the metadata before we go any
> +further, detecting corruptions that have occurred as the metadata has been
> +modified in memory. If the metadata verifies OK, and CRCs are enabled, we then
> +update the LSN field (when it was last modified) and calculate the CRC on the
> +metadata. Once this is done, we can issue the IO.
> +
> +Inodes and Dquots
> +-----------------
> +
> +Inodes and dquots are special snowflakes. They have per-object CRC and
> +self-identifiers, but they are packed so that there are multiple objects per
> +buffer. Hence we do not use per-buffer verifiers to do the work of per-object
> +verification and CRC calculations. The per-buffer verifiers simply perform basic
> +identification of the buffer - that they contain inodes or dquots, and that
> +there are magic numbers in all the expected spots. All further CRC and
> +verification checks are done when each inode is read from or written back to the
> +buffer.
> +
> +The structure of the verifiers and the identifiers checks is very similar to the
> +buffer code described above. The only difference is where they are called. For
> +example, inode read verification is done in xfs_iread() when the inode is first
> +read out of the buffer and the struct xfs_inode is instantiated. The inode is
> +already extensively verified during writeback in xfs_iflush_int, so the only
> +addition here add the LSN and CRC to the inode as it is copied back into the
> +buffer.
> +
> +XXX: inode unlinked list modification doesn't recalculate the inode CRC! None of
> +the unlinked list modifications check or update CRCs, neither during unlink nor
> +log recovery. So, it's gone unnoticed until now. This won't matter immediately -
> +repair will probably complain about it - but it needs to be fixed.
> +
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
