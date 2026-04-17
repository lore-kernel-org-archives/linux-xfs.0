Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8B937475B;
	Fri, 17 Apr 2026 07:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776411283; cv=none; b=KCQmMVCpzg6/JXgRm9sSLhF0AtaBy8+lkisf4MVisSHlBC2aBG/Vipe0gm50uX+H9yxfQ9NuhL5uSD7foRzN7ljV55czb2IoEhg2SG0DVj+6bQ4cS5QWjYtOVxNTRhuXXxYaObaSwS4dG2Dh0XWlBvcba40HEIfDv6DqHVMKoVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776411283; c=relaxed/simple;
	bh=D8/T8svr3sRwE4NB5Zmn92Ipf3ZN+L1v5ShW9biAut0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fYjOeCUduuyeh46LFm7Fegn4AzWsxhk2tCzWYSIZCTtLXamGwC8unsh3Ux64K+Tg8UmBe31BZv/7dfDvdLPFRFi4S/jU0TdN+Ar0NHuZnK3Klj0b3SJCySiJuz259v9E94Oxq88XHFqsyQ25I0pDZgiG+EF/pcWctEk+v9mpCMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=srW/KBGd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="srW/KBGd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G/xcbv7FN0TDW/FGXZ1oKR5Pn2YoSCY6DUSTosy6E/g=; b=srW/KBGdkOX9OsO8BrHrbC0zY8
	6gAd8jfwv5kppGiDOn/ZHShdMDPv3RrpgNYTtbwBEUSJ4swtF96/dklbcf8LtT0SzSZZ6X+zU4Ii0
	CBpre1OcTBpFs2SuG8LKfZKc6fmqyvgKqYXctK8FjCEHifwaWAPj430R8IxT41M3qLVf0cu82t6Yy
	YECdHgK1Rwi8oDRJ44Lf2aiLirFLKwcpxpNvo7Qy1/a1q94copeTYdl/Kxf1WTvCV2ohEF6KMvaEM
	QYSLToLrKsTlfg/mw58yxIDCESgEYUQXIrdDnL791Evjd0JgGn+yDDQYramxDmMEt97o0isV8iISn
	imt3dqDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDdiq-00000003ao7-2eae;
	Fri, 17 Apr 2026 07:34:40 +0000
Date: Fri, 17 Apr 2026 00:34:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	Anand Jain <asj@kernel.org>, dsterba@suse.com
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <aeHikJwRmFdDg5FW@infradead.org>
References: <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org>
 <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
 <20260409131238.GC18443@macsyma-wired.lan>
 <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b593ab17-afaf-4128-97eb-0ab9c23dec5c@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 16, 2026 at 11:21:41PM +0800, Anand Jain wrote:
> > But given that you originally stumbled across this with Overlayfs,
> > because it was originally using s_uuid, and that didn't work well for
> > btrfs, why not change overlayfs to just use s_uuid plus kdev_t in its
> > xattr, and just fix the problem for overlayfs?  That has the benefit
> > that it will work for all file system types in Linux, not just for
> > those where we have changed what f_fsid does.
> 
> Using `kdev_t` (or any derivation of it) for persistent storage, such
> as Overlayfs xattrs, is problematic. Since `kdev_t` is transient and
> inconsistent across reboots or device re-discovery, it could lead to
> broken associations.

Yes, using a dev_t in anything persistent is a really bad ida.

> It seems we've reached the functional limits of f_fsid.
> If we want to solve this properly for Overlayfs, NFS handles, or a
> complex system monitoring..etc, we need a new identifier let's call
> it f_fsid_v2, that meets the following requirements:
> 
>   System-wide Uniqueness: Must distinguish between cloned filesystems.
> 
>   Persistence: Must remain consistent across reboots/HW re-enumeration.
> 
>   Non-On-Disk: Must not be stored on-disk.

The third requirement doesn't make much sense to me.  If it is
persistent it. or something it can be derived from must be stored
on-disk.

> 
> 
> One possible implementation for f_fsid_v2 could be:
> 
>    f_fsid_v2 =  hash(s_uuid, block_device_serial, [subvol_id])
> 
> For pseudo block devices (virtio-blk, loop, nbd, brd,..),
> the serial could be derived recursively:
> 
>    serial_number = hash(backing_file.f_fsid_v2, backing_file.ino)

What i the point in this?  All of this seems to be better served
by s_uuid.

> Note on Hardware Serials:
>  Standard storage protocols (T10, NVMe, SAS) mandate unique,
>  persistent serials per LUN. While I've seen T10 protocol
>  violations during my time authoring Solaris HBA drivers, I
>  believe these outliers shouldn't dictate the design.

No, T10 does not actually mandate unique identifiers, NVMe does, but the
implementations are often totally broken.

