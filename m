Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36116 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935747AbcJ0S3J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 14:29:09 -0400
Date: Thu, 27 Oct 2016 11:29:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161027182900.GC32036@birch.djwong.org>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nicholas Piggin <npiggin@gmail.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Fri, Oct 28, 2016 at 03:17:47AM +1100, Nicholas Piggin wrote:
> Hi guys,
> 
> We're seeing crc32c_le show up in xfs log checksumming on a MySQL benchmark
> on powerpc. I could reproduce similar overheads with dbench as well.
> 
> 1.11%  mysqld           [kernel.vmlinux]            [k] __crc32c_le
>         |
>         ---__crc32c_le
>            |          
>             --1.11%--chksum_update
>                       |          
>                        --1.11%--crypto_shash_update
>                                  crc32c
>                                  xlog_cksum
>                                  xlog_sync
>                                  _xfs_log_force_lsn
>                                  xfs_file_fsync
>                                  vfs_fsync_range
>                                  do_fsync
>                                  sys_fsync
>                                  system_call
>                                  0x17738
>                                  0x17704
>                                  os_file_flush_func
>                                  fil_flush
> 
> As a rule, it helps the crc implementation if it can operate on as large a
> chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> the existing crc to 0 before running over the entire buffer. Together with
> some small work on the powerpc crc implementation, crc drops below 0.1%.
> 
> I don't know if something like this would be acceptable? It's not pretty,
> but I didn't see an easier way.
> 
> diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
> index fad1676..88f4431 100644
> --- a/fs/xfs/libxfs/xfs_cksum.h
> +++ b/fs/xfs/libxfs/xfs_cksum.h
> @@ -9,20 +9,9 @@
>   * cksum_offset parameter.
>   */
>  static inline __uint32_t
> -xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> +xfs_start_cksum(void *buffer, size_t length)
>  {
> -	__uint32_t zero = 0;
> -	__uint32_t crc;
> -
> -	/* Calculate CRC up to the checksum. */
> -	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> -
> -	/* Skip checksum field */
> -	crc = crc32c(crc, &zero, sizeof(__u32));
> -
> -	/* Calculate the rest of the CRC. */
> -	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
> -		      length - (cksum_offset + sizeof(__be32)));
> +	return crc32c(XFS_CRC_SEED, buffer, length);
>  }
>  
>  /*
> @@ -42,22 +31,29 @@ xfs_end_cksum(__uint32_t crc)
>   * Helper to generate the checksum for a buffer.
>   */
>  static inline void
> -xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> +xfs_update_cksum(void *buffer, size_t length, unsigned long cksum_offset)
>  {
> -	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
> +	__le32 *crcp = buffer + cksum_offset;
>  
> -	*(__le32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
> +	*crcp = 0; /* set to 0 before calculating checksum */
> +	*crcp = xfs_end_cksum(xfs_start_cksum(buffer, length));
>  }
>  
>  /*
>   * Helper to verify the checksum for a buffer.
>   */
>  static inline int
> -xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> +xfs_verify_cksum(void *buffer, size_t length, unsigned long cksum_offset)
>  {
> -	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
> +	__le32 *crcp = buffer + cksum_offset;
> +	__le32 crc = *crcp;
> +	__le32 new_crc;
> +
> +	*crcp = 0;
> +	new_crc = xfs_end_cksum(xfs_start_cksum(buffer, length));
> +	*crcp = crc; /* restore original CRC in place */

So... this temporarily modifies the metadata buffer as part of verifying
checksums in the read path.  I'm not sure about this, but what prevents
a situation where a read verifier races with the buffer actually being
written back to disk by the log?

The reason I ask is that we just ripped this optimization out of ext4
because it turned out that it does actually allow multiple readers of a
directory block (I think because the VFS now allows it).  ext4 allows
for multiple threads to call the read verifier on a block, which lead to
races and verifier errors.  Normally the journal mediates write access
to buffers, but we don't allocate transactions for a readdir.  Worse
yet, I think the Samsung engineers who reported the ext4 issue also saw
zeroed checksums on disk because the journal can be writing buffers back
to disk concurrently with other processes having read access to the
buffer.

I /think/ XFS buffer locking rules prevent verifier races by only
allowing one owner of a buffer at a time.  However, I think if we ever
wanted to allow multiple threads to have read access to a buffer then
this is a bug waiting to happen.

--D

>  
> -	return *(__le32 *)(buffer + cksum_offset) == xfs_end_cksum(crc);
> +	return new_crc == crc;
>  }
>  
>  #endif /* _XFS_CKSUM_H */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 8de9a3a..efd8daa 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -419,15 +419,11 @@ xfs_dinode_calc_crc(
>  	struct xfs_mount	*mp,
>  	struct xfs_dinode	*dip)
>  {
> -	__uint32_t		crc;
> -
>  	if (dip->di_version < 3)
>  		return;
>  
>  	ASSERT(xfs_sb_version_hascrc(&mp->m_sb));
> -	crc = xfs_start_cksum((char *)dip, mp->m_sb.sb_inodesize,
> -			      XFS_DINODE_CRC_OFF);
> -	dip->di_crc = xfs_end_cksum(crc);
> +	xfs_update_cksum(dip, mp->m_sb.sb_inodesize, XFS_DINODE_CRC_OFF);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 3b74fa0..4e242f0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1658,7 +1658,7 @@ xlog_pack_data(
>   * This is a little more complicated than it should be because the various
>   * headers and the actual data are non-contiguous.
>   */
> -__le32
> +void
>  xlog_cksum(
>  	struct xlog		*log,
>  	struct xlog_rec_header	*rhead,
> @@ -1667,10 +1667,9 @@ xlog_cksum(
>  {
>  	__uint32_t		crc;
>  
> -	/* first generate the crc for the record header ... */
> -	crc = xfs_start_cksum((char *)rhead,
> -			      sizeof(struct xlog_rec_header),
> -			      offsetof(struct xlog_rec_header, h_crc));
> +	/* first generate the crc for the record header with 0 crc... */
> +	rhead->h_crc = 0;
> +	crc = xfs_start_cksum(rhead, sizeof(struct xlog_rec_header));
>  
>  	/* ... then for additional cycle data for v2 logs ... */
>  	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb)) {
> @@ -1691,7 +1690,7 @@ xlog_cksum(
>  	/* ... and finally for the payload */
>  	crc = crc32c(crc, dp, size);
>  
> -	return xfs_end_cksum(crc);
> +	rhead->h_crc = xfs_end_cksum(crc);
>  }
>  
>  /*
> @@ -1840,8 +1839,7 @@ xlog_sync(
>  	}
>  
>  	/* calculcate the checksum */
> -	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
> -					    iclog->ic_datap, size);
> +	xlog_cksum(log, &iclog->ic_header, iclog->ic_datap, size);
>  #ifdef DEBUG
>  	/*
>  	 * Intentionally corrupt the log record CRC based on the error injection
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2b6eec5..18ba385 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -432,7 +432,7 @@ xlog_recover_finish(
>  extern int
>  xlog_recover_cancel(struct xlog *);
>  
> -extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
> +extern void	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
>  			    char *dp, int size);
>  
>  extern kmem_zone_t *xfs_log_ticket_zone;
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 9b3d7c7..3f62d9a 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5114,8 +5114,13 @@ xlog_recover_process(
>  {
>  	int			error;
>  	__le32			crc;
> +	__le32			old_crc;
>  
> -	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
> +	old_crc = rhead->h_crc;
> +	rhead->h_crc = 0;
> +	xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
> +	crc = rhead->h_crc;
> +	rhead->h_crc = old_crc;
>  
>  	/*
>  	 * Nothing else to do if this is a CRC verification pass. Just return
> -- 
> 2.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
