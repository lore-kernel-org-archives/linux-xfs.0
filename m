Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34635 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935277AbcJ1DVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2016 23:21:36 -0400
Received: by mail-pf0-f194.google.com with SMTP id u84so4297836pfj.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2016 20:21:36 -0700 (PDT)
Date: Fri, 28 Oct 2016 14:21:25 +1100
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [rfc] larger batches for crc32c
Message-ID: <20161028142125.44959f7b@roar.ozlabs.ibm.com>
In-Reply-To: <20161027182900.GC32036@birch.djwong.org>
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
        <20161027182900.GC32036@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>

On Thu, 27 Oct 2016 11:29:00 -0700
"Darrick J. Wong" <darrick.wong@oracle.com> wrote:

> On Fri, Oct 28, 2016 at 03:17:47AM +1100, Nicholas Piggin wrote:
> > Hi guys,
> > 
> > We're seeing crc32c_le show up in xfs log checksumming on a MySQL benchmark
> > on powerpc. I could reproduce similar overheads with dbench as well.
> > 
> > 1.11%  mysqld           [kernel.vmlinux]            [k] __crc32c_le
> >         |
> >         ---__crc32c_le
> >            |          
> >             --1.11%--chksum_update
> >                       |          
> >                        --1.11%--crypto_shash_update
> >                                  crc32c
> >                                  xlog_cksum
> >                                  xlog_sync
> >                                  _xfs_log_force_lsn
> >                                  xfs_file_fsync
> >                                  vfs_fsync_range
> >                                  do_fsync
> >                                  sys_fsync
> >                                  system_call
> >                                  0x17738
> >                                  0x17704
> >                                  os_file_flush_func
> >                                  fil_flush
> > 
> > As a rule, it helps the crc implementation if it can operate on as large a
> > chunk as possible (alignment, startup overhead, etc). So I did a quick hack
> > at getting XFS checksumming to feed crc32c() with larger chunks, by setting
> > the existing crc to 0 before running over the entire buffer. Together with
> > some small work on the powerpc crc implementation, crc drops below 0.1%.
> > 
> > I don't know if something like this would be acceptable? It's not pretty,
> > but I didn't see an easier way.
> > 
> > diff --git a/fs/xfs/libxfs/xfs_cksum.h b/fs/xfs/libxfs/xfs_cksum.h
> > index fad1676..88f4431 100644
> > --- a/fs/xfs/libxfs/xfs_cksum.h
> > +++ b/fs/xfs/libxfs/xfs_cksum.h
> > @@ -9,20 +9,9 @@
> >   * cksum_offset parameter.
> >   */
> >  static inline __uint32_t
> > -xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> > +xfs_start_cksum(void *buffer, size_t length)
> >  {
> > -	__uint32_t zero = 0;
> > -	__uint32_t crc;
> > -
> > -	/* Calculate CRC up to the checksum. */
> > -	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> > -
> > -	/* Skip checksum field */
> > -	crc = crc32c(crc, &zero, sizeof(__u32));
> > -
> > -	/* Calculate the rest of the CRC. */
> > -	return crc32c(crc, &buffer[cksum_offset + sizeof(__be32)],
> > -		      length - (cksum_offset + sizeof(__be32)));
> > +	return crc32c(XFS_CRC_SEED, buffer, length);
> >  }
> >  
> >  /*
> > @@ -42,22 +31,29 @@ xfs_end_cksum(__uint32_t crc)
> >   * Helper to generate the checksum for a buffer.
> >   */
> >  static inline void
> > -xfs_update_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> > +xfs_update_cksum(void *buffer, size_t length, unsigned long cksum_offset)
> >  {
> > -	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
> > +	__le32 *crcp = buffer + cksum_offset;
> >  
> > -	*(__le32 *)(buffer + cksum_offset) = xfs_end_cksum(crc);
> > +	*crcp = 0; /* set to 0 before calculating checksum */
> > +	*crcp = xfs_end_cksum(xfs_start_cksum(buffer, length));
> >  }
> >  
> >  /*
> >   * Helper to verify the checksum for a buffer.
> >   */
> >  static inline int
> > -xfs_verify_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> > +xfs_verify_cksum(void *buffer, size_t length, unsigned long cksum_offset)
> >  {
> > -	__uint32_t crc = xfs_start_cksum(buffer, length, cksum_offset);
> > +	__le32 *crcp = buffer + cksum_offset;
> > +	__le32 crc = *crcp;
> > +	__le32 new_crc;
> > +
> > +	*crcp = 0;
> > +	new_crc = xfs_end_cksum(xfs_start_cksum(buffer, length));
> > +	*crcp = crc; /* restore original CRC in place */  
> 
> So... this temporarily modifies the metadata buffer as part of verifying
> checksums in the read path.  I'm not sure about this, but what prevents
> a situation where a read verifier races with the buffer actually being
> written back to disk by the log?

It does. Yes that's probably the nastiest bit of it. If it was to
be turned into a "real" patch, perhaps it should be a burden on the
callers to clear the checksum themselves and do the comparison.
Although it may turn out to be a premature optimisation because I
have only been looking at log heavy write operations at the moment.

> 
> The reason I ask is that we just ripped this optimization out of ext4
> because it turned out that it does actually allow multiple readers of a
> directory block (I think because the VFS now allows it).  ext4 allows
> for multiple threads to call the read verifier on a block, which lead to
> races and verifier errors.  Normally the journal mediates write access
> to buffers, but we don't allocate transactions for a readdir.  Worse
> yet, I think the Samsung engineers who reported the ext4 issue also saw
> zeroed checksums on disk because the journal can be writing buffers back
> to disk concurrently with other processes having read access to the
> buffer.
> 
> I /think/ XFS buffer locking rules prevent verifier races by only
> allowing one owner of a buffer at a time.  However, I think if we ever
> wanted to allow multiple threads to have read access to a buffer then
> this is a bug waiting to happen.


XFS *looked* like it's pretty tight there, at least the inode and
buffer paths I looked at (though not knowing much about XFS). But I
agree with you and Dave it's not something that can be taken lightly.

As an aside, it's interesting ext4 is doing concurrent verifications
on the same block. Is that to avoid checksumming in IO completion?

Thanks,
Nick
