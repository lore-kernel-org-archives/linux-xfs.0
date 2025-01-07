Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A81DE89C
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 10:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245489; cv=none; b=o3fFsUC/a9uFCglDzDt6cpdhygtg/Zk3ZTeL8f36xBlEcXtzud/NlIoXVuVyzlU0zaXyBfTTMs0iX8u0oyJnrdGfYg6Buml8P+hiA9z+aTG9LVs/2Ib76DPa+iACFuD20fGVuYlDiONTkmNgK3RYOiN1UIPtKoOWlI9keTq7BbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245489; c=relaxed/simple;
	bh=hvtdOSj2dPRdk6qrSjC/y1LqPQ/xdEkMprXLBgJj/XA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyUndLJwonJ461zkjrOruwr9XMe8bJU1z+AwjCeBYaPjzjU8eHI/qWgEBOSOuvgQ8az3D9udU2PB0JC2HTj/LBHiSwAuugoCj/YE7K0B8z3SLjRQ+nGGmHO8MvPZY5MwC/Y9rwuNJNdB+TToLLbBOTh+xksCZpiP+vwjjLDTlSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A91Mmvez; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A91Mmvez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736245485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fMNjGVohpSFPLdzs7PtBvl+2ioB9JQMTV7LYPM4EVdg=;
	b=A91Mmvez8on6os+gUPfIBCDvkkCPKmdiXnzzJT+bAhox+/BeTqkqQ/MF5qUlX0nWR+TaQW
	H+sYKbMALVCSIIzLbBJteTJBVCTZvwgxS3sytfLwWYO+kVQX6uVTd3rCNhy/5iqcun21Uh
	YTkwGCF7U/e4qrZ/BPQd2rNxe3/Y1W0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-oTBWsQZ8P3mATuWBz3AG-A-1; Tue, 07 Jan 2025 05:24:44 -0500
X-MC-Unique: oTBWsQZ8P3mATuWBz3AG-A-1
X-Mimecast-MFC-AGG-ID: oTBWsQZ8P3mATuWBz3AG-A
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa634496f58so861569866b.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Jan 2025 02:24:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736245483; x=1736850283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMNjGVohpSFPLdzs7PtBvl+2ioB9JQMTV7LYPM4EVdg=;
        b=kiCqmTLqnRrcJK+5Tem+KysXbbxb2oAM0Cee6logvvqb1dkKGAb0KYmmq1TkLSh+ba
         nwwMnM8NjGgFCd5/Y7WjlXCIuh25bOpuAUwNq/Nl1PvqSJ5ZPg0y3lv0zjPLz9jCzQDb
         Gb4yjRolFt4WqBe3VtD69P0Xa0GC0Cg9TzZUfQNRVHWI+6ea41gxFCwqJF5sPn6e3mvT
         eZ8Typs/OhCEi9bQfW2R+YzfDDOvj3PcZFtEgFEn3f6qYNEghKIE24Wcb+3tERkim2FV
         OatYsUP+TR0aQrGsM5802KpucA9cPldMHuJopZAzavJeHt7Zxprzp5OhXawaNHD92PNh
         qnGg==
X-Gm-Message-State: AOJu0YxzoIvnR2sUk/ZLby4V2P1RcL2yHaA/ewQtz7oGaday2YGaasoJ
	oBsWck2eF19GB5jwXVgNLD6Vr0qfsHAUsjIpFDEqGm/IpinXOAquPOQKf9Y5i0qeJIjAuq9SeK1
	D4WBlMtPzAyqMYaeGLNvfntIMo888XGi1v5Jtui8CF3d4YK1skgy5/2us
X-Gm-Gg: ASbGncsQYnln6wW8dVwDb0uFn/Hi8aQKAqX2SjYRsdgrrgtc6T0S6+NN19lpmEiP32q
	eYajEIXprN4KkmmRxdfxxDU2DVhAhblR7lI0rsnSEDq+P1cwhK83VZxw4UlcBJUckoli+xKxN5r
	zIdTUOKbRdlyIxWU2WiXK1WYs+GIh0lxXG9NwDZQSXe5o4ylacbhc8iOF1CV8q3mwa5K+dOnB6q
	joLRUdWigttH5ELNHcSA8neZRMVeqdOMU46loY2WbdxPgI33lKxngcOt4wGQ30k0l4dyFIRcQ+N
X-Received: by 2002:a05:6402:270d:b0:5d0:bcdd:ffa8 with SMTP id 4fb4d7f45d1cf-5d81dd83b92mr52910386a12.1.1736245482468;
        Tue, 07 Jan 2025 02:24:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHfidwQZzvZacEDwA4VxkLg5vNTskr1hOZY8LbjfLmCGVpsuMiOL0XS0WaHQnizROOUsc1ng==
X-Received: by 2002:a05:6402:270d:b0:5d0:bcdd:ffa8 with SMTP id 4fb4d7f45d1cf-5d81dd83b92mr52910349a12.1.1736245481840;
        Tue, 07 Jan 2025 02:24:41 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80675a72asm23955348a12.8.2025.01.07.02.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 02:24:41 -0800 (PST)
Date: Tue, 7 Jan 2025 11:24:40 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de, 
	Andrey Albershteyn <aalbersh@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] xfs: direct mapped xattrs design documentation
Message-ID: <odeqjchui2v7764dcaa2zo2dz7yt6atuz3rafamzhy7bxnsxv2@lxeyg2abo6as>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133501.1192867-1-aalbersh@kernel.org>
 <20250107014141.GP6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107014141.GP6174@frogsfrogsfrogs>

On 2025-01-06 17:41:41, Darrick J. Wong wrote:
> [add ebiggers to cc]
> 
> On Sun, Dec 29, 2024 at 02:35:01PM +0100, Andrey Albershteyn wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Direct mapped xattrs are a form of remote xattr that don't contain
> > internal self describing metadata. Hence the xattr data can be
> > directly mapped into page cache pages by iomap infrastructure
> > without needing to go through the XFS buffer cache.
> > 
> > This functionality allows XFS to implement fsverity data checksum
> > information externally to the file data, but interact with XFS data
> > checksum storage through the existing page cache interface.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  .../xfs/xfs-direct-mapped-xattr-design.rst    | 304 ++++++++++++++++++
> >  1 file changed, 304 insertions(+)
> >  create mode 100644 Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst
> > 
> > diff --git a/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst b/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst
> > new file mode 100644
> > index 000000000000..a0efa9546eca
> > --- /dev/null
> > +++ b/Documentation/filesystems/xfs/xfs-direct-mapped-xattr-design.rst
> > @@ -0,0 +1,304 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=====================================
> > +XFS Direct Mapped Extended Atrtibutes
> > +=====================================
> > +
> > +Background
> > +==========
> > +
> > +We have need to support fsverity in XFS. An attempt to support fsverity
> > +using named remote xattrs has already been made, but the complexity of the
> > +solution has made acceptance of that implementation .... challenging.
> > +
> > +The fundamental problem caused by using remote xattr blocks to store the
> > +fsverity checksum data is that the data is stored as opaque filesystem block
> > +sized chunks of data and accesses them directly through a page cache based
> > +interface interface.
> > +
> > +These filesystem block sized chunks do not fit neatly into remote xattr blocks
> > +because the remote xattr blocks have metadata headers in them containing self
> > +describing metadata and CRCs for the metadata. Hence filesystem block sized data
> > +now spans two filesystem blocks and is not contiguous on disk (it is split up
> > +by headers).
> > +
> > +The fsverity interfaces require page aligned data blocks, which then requires
> > +copying the fsverity data out of the xattr buffers into a separate bounce buffer
> > +which is then cached independently of the xattr buffer. IOWs, we have to double
> > +buffer the fsverity checksum data and that costs a lot in terms of complexity.
> > +
> > +Because the remote xattr data is also using the generic xattr read code, it
> > +requires use of xfs metadata buffers to read and write it to disk. Hence we have
> > +block based IO requirements for the fsverity data, not page based IO
> > +requirements. Hence there is an impedence mismatch between the fsverity IO model
> > +and the XFS xattr IO model as well.
> > +
> > +
> > +Directories, Xattrs and dabtrees
> > +================================
> > +
> > +Directories in XFS are complex - they maintain two separate lookup indexes to
> > +the dirent data because we have to optimise for two different types of access.
> > +We also have dirent stability requirements for seek operations.
> > +
> > +Hence directories have an offset indexed data segment that hold dirent data,
> > +with each individual dirent at an offset that is fixed for the life of the
> > +dirent. This provides dirent stability as the offset of the dirent can be used
> > +as a seek cookie. This offset indexed data segment is optimised for dirent
> > +reading by readdir/getdents which iterates sequentially through the dirent data
> > +and requires stable cookies for iteration continuation.
> > +
> > +Directories must also support lookup by name - path based directory lookups need
> > +to find the dirent by name rather than by offset. This is implemented by the
> > +dabtree in the directory. It stores name hashes and the leaf records for a
> > +specific name hash point to the offset of the dirent with that hash. Hence name
> > +based lookups are fast and efficient when directed through the dabtree.
> > +Importantly, the dabtree does not store dirent data, it simply provides a
> > +pointer to the external dirent: the stable offset of the dirent in the offset
> > +indexed data segment.
> > +
> > +In comparison, the attr fork dabtree only has one index - the name hash based
> > +dabtree. Everything stored in the xattr fork needs to be named and the record
> > +for the xattr data is indexed by the hash of that name. As there is no external
> > +stable offset based index data segment, data that does not fit inline in the
> > +xattr leaf record gets stored in a dynamically allocated remote xattr extent.
> > +The remote extent is created at the first largest hole in the xattr address space,
> > +so the remote xattr data does not get allocated sequentially on disk.
> > +
> > +Further, because everything is name hash indexed, sequential offset indexed data
> > +is not going to hash down to sequential record indexes in the dabtree. Hence
> > +access to offset index based xattr data is not going to be sequential in either
> > +record lookup patterns nor xattr data read patterns. This isn't a huge issue
> > +as the dabtree blocks rapidly get cached, but it does consume more CPU time
> > +that doing equivalent sequential offset based access in the directory structure.
> > +
> > +Darrick Wong pondered whether it would help to create a sequentially
> > +indexed segment in the xattr fork for the merkle tree blocks when discussing
> > +better ways to handle fsverity metadata. This document is intended to flesh out
> > +that concept into something that is usable by mutable data checksum
> > +functionality.
> > +
> > +
> > +fsverity is just data checksumming
> > +==================================
> > +
> > +I had a recent insight into fsverity when discussing what to do with the
> > +fsverity code with Andrey. That insight came from realising that all fsverity
> > +was doing is recording a per-filesystem block checksum and then validating
> > +it on read. While this might seem obvious now that I say it, the previous
> > +approach we took was all about fsverity needing to read and write opaque blocks
> > +of individually accessed metadata.
> > +
> > +Storing opaque, externally defined metadata is what xattrs are intended to be
> > +used for, and that drove the original design. i.e. a fsverity merkle tree block
> > +was just another named xattr object that encoded the tree index in the xattr
> > +name. Simple and straight forward from the xattr POV, but all the complexity
> > +arose in translating the xattr data into a form that fsverity could use.
> > +
> > +Fundamentally, however, the merkle tree blocks just contain data checksums.
> > +Yes, they are complex, cryptographically secure data checksums, but the
> > +fundamental observation is that there is a direct relationship between the file
> > +data at a given offset and the contents of merkle tree block at a given tree
> > +index.
> > +
> > +fsverity has a mechanism to calculate the checksums from the file data and store
> > +them in filesystem blocks, hence providing external checksum storage for the
> > +file data. It also has mechanism to read the external checksum storage and
> > +compare that against the calculated checksum of the data. Hence fsverity is just
> > +a fancy way of saying the filesystem provides "tamper proof read-only data
> > +checksum verification"
> 
> Ok, so fsverity's merkle tree is (more or less) block-indexable, so you
> want to use xattrs to map merkle block indexes to headerless remote
> xattr blocks which you can then read into the pagecache and give to
> fsverity.  Is that right?

Yes, the indexing could probably be a block aligned for blocks
smaller than fsb size, so we can pack more of them in one xattr, but
otherwise it the same.

> 
> I'm puzzled by all this, because the design here feels like it's much
> more complex than writing the merkle tree as post-eof data like ext4 and
> f2fs already do, and it prevents us from adding trivial fscrypt+fsverity
> support.  There must be something that makes the tradeoff worthwhile,
> but I'm not seeing it, unless...
> 
> > +But what if we want data checksums for normal read-write data files to be able
> > +to detect bit-rot in data at rest?
> 
> ...your eventual plan here is to support data block checksums as a
> totally separate feature from fsverity?  And you'll reuse the same
> "store two checksums with every xattr remote value" code to facilitate
> this...  somehow?  I'm not sure how, since I don't think I see any of
> code for that in the patches.

Yes, that's kinda an idea, but this patchset doesn't try to do
anything with it. The only goal here for now is get support for
fs-verity in form which could be used for that.

> 
> Or are you planning to enhance fsverity itself to support updates?

No

> 
> <confused>
> 
> > +
> > +
> > +Direct Mapped Xattr Data
> > +========================
> > +
> > +fsverity really wants to read and write it's checksum data through the page
> 
> "its checksum data", no apostrophe
> 
> > +cache. To do this efficiently, we need to store the fsverity metadata in block
> > +aligned data storage. We don't have that capability in XFS xattrs right now, and
> > +this is what we really want/need for data checksum storage. There are two ways
> > +of doing direct mapped xattr data.
> > +
> > +A New Remote Xattr Record Format
> > +--------------------------------
> > +
> > +The first way we can do direct mapped xattr data is to change the format of the
> > +remote xattr. The remote xattr header currently looks like this:
> > +
> > +.. code-block:: c
> > +
> > +	typedef struct xfs_attr_leaf_name_remote {
> > +		__be32  valueblk;               /* block number of value bytes */
> > +		__be32  valuelen;               /* number of bytes in value */
> > +		__u8    namelen;                /* length of name bytes */
> > +		/*
> > +		 * In Linux 6.5 this flex array was converted from name[1] to name[].
> > +		 * Be very careful here about extra padding at the end; see
> > +		 * xfs_attr_leaf_entsize_remote() for details.
> > +		 */
> > +		__u8    name[];                 /* name bytes */
> > +	} xfs_attr_leaf_name_remote_t;
> > +
> > +It stores the location and size of the remote xattr data as a filesystem block
> > +offset into the attr fork, along with the xattr name. The remote xattr block
> > +contains then this self describing header:
> > +
> > +.. code-block:: c
> > +
> > +	struct xfs_attr3_rmt_hdr {
> > +		__be32  rm_magic;
> > +		__be32  rm_offset;
> > +		__be32  rm_bytes;
> > +		__be32  rm_crc;
> > +		uuid_t  rm_uuid;
> > +		__be64  rm_owner;
> > +		__be64  rm_blkno;
> > +		__be64  rm_lsn;
> > +	};
> > +
> > +This is the self describing metadata that we use to validate the xattr data
> > +block is what it says it is, and this is the cause of the unaligned remote xattr
> > +data.
> > +
> > +The key field in the self describing metadata is ``*rm_crc``. This
> > +contains the CRC of the xattr data, and that tells us that the contents of the
> > +xattr data block are the same as what we wrote to disk. Everything else in
> > +this header is telling us who the block belongs to, it's expected size and
> > +when and where it was written to. This is far less critical to detecting storage
> > +errors than the CRC.
> > +
> > +Hence if we drop this header and move the ``rm_crc`` field to the ``struct
> > +xfs_attr_leaf_name_remote``, we can still check that the xattr data is has not
> > +been changed since we wrote the data to storage. If we have rmap enabled we
> > +have external tracking of the owner for the xattr data block, as well as the
> > +offset into the xattr data fork. ``rm_lsn`` is largely meaningless for remote
> > +xattrs because the data is written synchronously before the dabtree remote
> > +record is committed to the journal.
> > +
> > +Hence we can drop the headers from the remote xattr data blocks and not really
> > +lose much in way of robustness or recovery capability when rmap is enabled. This
> > +means all the xattr data is now filesystem block aligned, and this enables us to
> > +directly map the xattr data blocks directly for read IO.
> 
> So you're moving rm_crc to the remote name structure and eliminating the
> headers.  That weakens the self describing metadata, but chances are the
> crc isn't going to match if there's a torn write.  Probably not a big
> loss.
> 
> > +However, we can't easily directly map this xattr data for write operations. The
> > +xattr record header contains the CRC, and this needs to be updated
> > +transactionally. We can't update this before we do a direct mapped xattr write,
> > +because we have to do the write before we can recalculate the CRC. We can't do
> > +it after the write, because then we can have the transaction commit before the
> > +direct mapped data write IO is submitted and completed. This means recovery
> > +would result in a CRC mismatch for that data block. And we can't do it after the
> > +data write IO completes, because if we crash before the transaction is committed
> > +to the journal we again have a CRC mismatch.
> > +
> > +This is made more complex because we don't allow xattr headers to be
> > +re-written. Currently an update to an xattr requires a "remove and recreate"
> > +operation to ensure that the update is atomic w.r.t. remote xattr data changes.
> > +
> > +One approach which we can take is to use two CRCs - for old and new xattr data.
> > +``rm_crc`` becomes ``rm_crc[2]`` and xattr gains new bit flag
> > +``XFS_ATTR_RMCRC_SEL_BIT``. This bit defines which of the two fields contains
> > +the primary CRC. When we write a new CRC, we write it into the secondary
> > +``rm_crc[]`` field (i.e. the one the bit does not point to). When the data IO
> > +completes, we toggle the bit so that it points at the new primary value.
> > +
> > +If the primary does not match but the secondary does, we can flag an online
> > +repair operation to run at the completion of whatever operation read the xattr
> > +data to correct the state of the ``XFS_ATTR_RMCRC_SEL_BIT``.
> 
> I'm a little lost on what this rm_crc[] array covers -- it's intended to
> check the value of the remote xattr value, right?  And either of crc[0]
> or crc[1] can match?  So I guess the idea here is that you can overwrite
> remote xattr value blocks like this:
> 
> 1. update remote name with crc[0] == current crc and crc[1] == new crc
> 2. write directly to remote xattr value blocsk
> 
> and this is more efficient than running through the classic REPLACE
> machinery?
> 
> Since each merkle tree block is stored as a separate xattr, you can
> write to the merkle tree blocks in this fashion, which avoids
> inconsistencies in the ondisk xattr structure so long as the xattr value
> write itself doesn't tear.
> 
> But we only write the merkle tree once.  So why is the double crc
> necessary?  If the sealing process fails, we never set the ondisk iflag.

The reason for rm_crc[] is that by separating CRC from the data we
can't update CRC and data at once. If CRC is wrong we don't know if
update was consistent and what went wrong. The CRC has to tell us
that what we sent to disk got to disk.

In current implementation the data is updated together with CRC
transactionally. But with data going through iomap only CRC will be
updated in transaction.

So, by trading off a bit of space we have two CRCs - before and after
IO completion. This way we can detect what happened and take
appropriate action.

This is not an alternatiive to REPLACE operation but a more or less
general interface for writing leaf xattr data through iomap without
dependency on fs-verity.

> 
> > +If neither CRCs match, then we have an -EFSCORRUPTED situation, and that needs
> > +to mark the attr fork as sick (which brings it to the attention of scrub/repair)
> > +and return -EFSCORRUPTED to the reader.
> > +
> > +Offset-based Xattr Indexing Segments
> > +------------------------------------
> > +
> > +The other mechanism for direct mapping xattr data is to introduce an offset
> > +indexed segment similar to the directory data segment. The xattr data fork uses
> > +32 bit filesystem block addressing, so on a 4kB block size filesystem we can
> > +index 16TB of address space. A dabtree that indexes this amount of data would be
> > +massive and quite inefficient, and we'd likely be hitting against the maximum
> > +extent count limits for the attr fork at this point, anyway (32 bit extent
> > +count).
> > +
> > +Hence taking half the address space (the upper 8TB) isn't going to cause any
> > +significant limitations on what we can store in the existing attr fork dabtree.
> > +It does, however, provide us with a significant amount of data address space we
> > +can use for offset indexed based xattr data. We can even split this upper region
> > +into multiple segments so that it can have multiple separate sets of data and
> > +even dabtrees to index them.
> > +
> > +At this point in time, I do not see a need for these xattr segments to be
> > +directly accessible from userspace through existing xattr interfaces. If there
> > +is need for the data the kernel stores in an xattr data segment to be exposed to
> > +userspace, we can add the necessary interfaces when they are required.
> > +
> > +For the moment, let's first concentrate on what is needed in kernel space for
> > +the fsverity merkle tree blocks.
> > +
> > +
> > +Fsverity Data Segment
> > +`````````````````````
> > +
> > +Let's assume we have carved out a section of the inode address space for fsverity
> > +metadata. fsverity only supports file sizes up to 4TB (see `thread
> > +<https://lore.kernel.org/linux-xfs/Y5rDCcYGgH72Wn%2Fe@sol.localdomain/>`_::
> > +and so at a 4kB block size and 128 bytes per fsb the amount of addressing space
> > +needed for fsverity is a bit over 128GiB. Hence we could carve out a fixed
> > +256GiB address space segment just for fsverity data if we need to.
> > +
> > +When fsverity measures the file and creates the merkle tree block, it requires
> > +the filesystem to persistently record that inode is undergoing measurement. It
> > +also then tells the filesystem when measurement is complete so that the
> > +filesystem can remove the "under measurement" flag and seal the inode as
> > +fsverity protected.
> > +
> > +Hence with these persistent notifications, we don't have to care about
> > +persistent creation of the merkle tree data. As long as it has been written back
> > +before we seal the inode with a synchronous transaction, the merkle tree data
> > +will be stable on disk before the seal is written to the journal thanks to the
> > +cache flushes issued before the journal commit starts.
> > +
> > +This also means that we don't have to care about what is in the fsverity segment
> > +when measurement is started - we can just punch out what is already there (e.g.
> > +debris from a failed measurement) as the measurement process will rewrite
> > +the entire segment contents from scratch.
> > +
> > +Ext4 does this write process via the page cache into the inode's mapping. It
> > +operates at the aops level directly, but that won't work for XFS as we use iomap
> > +for buffered IO. Hence we need to call through iomap to map the disk space
> > +and allocate the page cache pages for the merkle tree data to be written.
> > +
> > +This will require us to provide an iomap_ops structure with a ->begin_iomap
> > +method that allocates and maps blocks from the attr fork fsverity data segment.
> > +We don't care what file offset the iomap code chooses to cache the folios that
> > +are inserted into the page cache, all we care about is that we are passed the
> > +merkle tree block position that it needs to be stored at.
> > +
> > +This will require iomap to be aware that it is mapping external metadata rather
> > +than normal file data so that it can offset the page cache index it uses for
> > +this data appropriately. The writeback also needs to know that it's working with
> > +fsverity folios past EOF. This requires changes to how those folios are mapped
> > +as they are indexed by xattr dabtree. The differentiation factor will be the
> > +fact that only merkle tree data can be written while inode is under fsverity
> > +initialization or filesystems also can check if these page is in "fsverity"
> > +region of the page cache.
> > +
> > +The writeback mapping of these specially marked merkle tree folios should be, at
> > +this point, relatively trivial. We will need to call fsverity ->map_blocks
> > +callback to map the fsverity address space rather than the file data address
> > +space, but other than that the process of allocating space and mapping it is
> > +largely identical to the existing data fork allocation code. We can even use
> > +delayed allocation to ensure the merkle tree data is as contiguous as possible.
> 
> Ok, so all this writeback stuff is to support the construction of the
> initial merkle tree at FS_IOC_ENABLE_VERITY time, /not/ to support
> read-write data integrity.

Yes, with fs-verity writeback will happen during tree construction.

> 
> > +The read side is less complex as all it needs to do is map blocks directly from
> > +the fsverity address space. We can read from the region intended for the
> > +fsverity metadata, then ->begin_iomap will map this request to xattr data blocks
> > +instead of file blocks.
> > +
> > +Therefore, we can have something like iomap_read_region() and
> > +iomap_write_region() to know that we are righting metadata and no filesize or
> > +any other data releated checks need to be done. This interface will take normal
> > +IO arguments and an offset of the region allowing filesystem to read relative to
> > +this offset.
> > -- 
> > 2.47.0
> > 
> > 
> 

-- 
- Andrey

