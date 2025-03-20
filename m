Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1022A1F1
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 20:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742503228; cv=none; b=f838a9f+G4E530KBJKtV9FPwQtiNsAfttjDWmtGswymLQ7r8ceHK54x7Rl+CV7pqbCXyihxFz1qeEAwgSah6xCVmQVuhOZPNJpb7TdaJxCZdla66jCfuinu9z5jHnaiNxjylXFgH2iQJQdWxsOwDpPqxHtPuHKYbLgF3d17E/Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742503228; c=relaxed/simple;
	bh=r7fKqh3ha/8+KYZC6xa3BoMX05xUOSODsqMhTwzsdfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J9cBAKNeuJebqvNWTgecVwgsEDzbIEHiwW0mQelFmFAtS/FW7WAtS7cXoK0w/y1ZFDHjFe1j+oGC3Wriuhd7IFXM3lr6jdM5u5EYollk5T2fhadqSg177lfRirm0Yqxfh7usPXZPyd/z0NVgBGO5H0hIsYKS28s1bwMfCMPz5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZOWYqzvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZOWYqzvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5087C4CEDD;
	Thu, 20 Mar 2025 20:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742503227;
	bh=r7fKqh3ha/8+KYZC6xa3BoMX05xUOSODsqMhTwzsdfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZOWYqzvg4HL3dnofUtsjt5Z7tdB8uKAZhb08ZjqM9jdIkHWIY8FY+zqTlUvkl5Ehn
	 2Lw2Zz62hpk/eRGTF2tiI3JOMRgKVEeSXWBqPnLYkZgAGaL3s8evBuA+2aCt8U8hTN
	 hT205fqVmo3rCaCOece/jSAIIAojI4fdYqaayY5EjIaCxCW91msPnZdN1YRGI2U5eI
	 /5r97LKKgFIsbZtTjJ0lgGaKt4n2PUlzqCxvwqMa5fZFDTtUMKNMUOyeAFJ4Gpw2og
	 E3a87PDz6Ry4hH45xH4106pQMbIzXFdmaQUogVaFFVTv4W9SzYciuo96fsRXznoWcI
	 vq1VLsonXib1g==
Date: Thu, 20 Mar 2025 13:40:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Hans.Holmberg@wdc.com
Subject: Re: [PATCH] design: document the zoned on-disk format
Message-ID: <20250320204027.GE2803749@frogsfrogsfrogs>
References: <20250320160541.1635550-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250320160541.1635550-1-hch@lst.de>

On Thu, Mar 20, 2025 at 05:05:41PM +0100, Christoph Hellwig wrote:
> Document the feature flags, superblock fields and new dinode union.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../ondisk_inode.asciidoc                     | 13 ++++++-
>  .../realtime.asciidoc                         | 34 +++++++++++++++++++
>  .../superblock.asciidoc                       | 25 ++++++++++++++
>  3 files changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> index ab4a503b4da6..ba111ebe6e3a 100644
> --- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> +++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
> @@ -139,7 +139,10 @@ struct xfs_dinode_core {
>       __be64                    di_changecount;
>       __be64                    di_lsn;
>       __be64                    di_flags2;
> -     __be32                    di_cowextsize;
> +     union {
> +             __be32            di_cowextsize;
> +             __be32            di_used_blocks;
> +     };
>       __u8                      di_pad2[12];
>       xfs_timestamp_t           di_crtime;
>       __be64                    di_ino;
> @@ -425,6 +428,14 @@ the source file to the destination file if the sharing operation completely
>  overwrites the destination file's contents and the destination file does not
>  already have +di_cowextsize+ set.
>  
> +*di_used_blocks*::
> +
> +Used only for the xref:Real_time_Reverse_Mapping_Btree[Reverse-Mapping B+tree]
> +inode on filesystems with a xref:Zoned[Zoned Real-time Device].  Tracks the
> +number of filesystem blocks in the rtgroup that have been written but not
> +unmapped, i.e. the number of blocks that are referenced by at least one rmap
> +entry.
> +
>  *di_pad2*::
>  Padding for future expansion of the inode.
>  
> diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
> index 16641525e201..fff0f691594a 100644
> --- a/design/XFS_Filesystem_Structure/realtime.asciidoc
> +++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
> @@ -397,3 +397,37 @@ meta_uuid = 7e55b909-8728-4d69-a1fa-891427314eea
>  include::rtrmapbt.asciidoc[]
>  
>  include::rtrefcountbt.asciidoc[]
> +
> +[[Zoned]]
> +== Zoned Real-time Devices
> +
> +If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, the real time device
> +uses an entirely different space allocator.  This features does not use the
> +xref:Real-Time_Bitmap_Inode[Free Space Bitmap Inode] and
> +xref:Real-Time_Summary_Inode[Free Space Summary Inode].
> +Instead, writes to the storage hardware must always occur sequentially
> +from the start to the end of a rtgroup.  To support this requirement,
> +file data are always written out of place using the so called copy on write
> +or COW write path (which actually just redirects on write and never copies).
> +
> +When an rtgroup runs out of space to write, free space is reclaimed by
> +copying and remapping still valid data from the full rtgroups into
> +another rtgroup.  Once the rtgroup is empty, it is written to from the
> +beginning again.  For this, the
> +xref:Real_time_Reverse_Mapping_Btree[Reverse-Mapping B+tree] is required.
> +
> +For storage hardware that supports hardware zones, each rtgroup is mapped
> +to exactly one zone.  When a file system is created on a a zoned storage
> +device that does support conventional (aka random writable) zones at the
> +beginning of the LBA space, those zones are used for the xfs data device
> +(which in this case is primarily used for metadata), and the zoned requiring
> +sequential writes are presented as the real-time device.  But when an external

Dumb nit: sentence doesn't need to begin with "But", e.g.

"When an external real-time device is used..."

Otherwise I think this description matches what I saw in the kernel
changes so with that one silly nit fixed,

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Actually, wait, I'm the maintainer of xfs-docs.  I'll fix it on commit
if there isn't a v2 in the next week or so.

--D

> +real-time device is used, rtgroups might also map to conventional zones.
> +
> +Filesystems with a zoned real-time device by default use the real-time device
> +for all data, and the data device only for metadata, which makes the
> +terminology a bit confusing.  But this is merely the default setting.  Like
> +any other filesystem with a realtime volume, the +XFS_DIFLAG_REALTIME+ flag
> +can be cleared on an empty regular file to target the data device; and the
> ++XFS_DIFLAG_RTINHERIT+ flag can be cleared on a directory so that new
> +children will target the data device."
> diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
> index f04553046357..bd34eb0d3066 100644
> --- a/design/XFS_Filesystem_Structure/superblock.asciidoc
> +++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
> @@ -74,6 +74,8 @@ struct xfs_dsb {
>  	__be32		sb_rgextents;
>  	__u8		sb_rgblklog;
>  	__u8		sb_pad[7];
> +	__be64		sb_rtstart;
> +	__be64		sb_rtreserved;
>  
>  	/* must be padded to 64 bit alignment */
>  };
> @@ -449,6 +451,16 @@ pointers] for more information.
>  Metadata directory tree.  See the section about the xref:Metadata_Directories[
>  metadata directory tree] for more information.
>  
> +| +XFS_SB_FEAT_INCOMPAT_ZONED+ |
> +Zoned RT device.  See the section about the xref:Zoned[Zoned Real-time Devices]
> +for more information.
> +
> +| +XFS_SB_FEAT_INCOMPAT_ZONE_GAPS+ |
> +Each hardware zone has unusable space at the end of its LBA range, which is
> +mirrored by unusable filesystem blocks at the end of the rtgroup.  The
> ++xfs_rtblock_t startblock+ in file mappings is linearly mapped to the
> +hardware LBA space.
> +
>  |=====
>  
>  *sb_features_log_incompat*::
> @@ -505,6 +517,19 @@ generate absolute block numbers defined in extent maps from the segmented
>  *sb_pad[7]*::
>  Zeroes, if the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled.
>  
> +*sb_rtstart*::
> +
> +If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, this is the start
> +of the internal RT section.  That is the RT section is placed on the same
> +device as the data device, and starts at this offset into the device.
> +The value is in units of file system blocks.
> +
> +*sb_rtreserved*::
> +
> +If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, this is the amount
> +of space in the realtime section that is reserved for internal use
> +by garbage collection and reorganization algorithms.
> +
>  === xfs_db Superblock Example
>  
>  A filesystem is made on a single disk with the following command:
> -- 
> 2.45.2
> 
> 
