Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48F14C6D;
	Wed,  1 Apr 2026 06:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775024321; cv=none; b=fIoHdtMJVCo+/B4Iu6q/24PPFbibOGHI4PgbXFiaP/eotXUNP25OF2RT5NwKibbEo7JmOLk5g5dgnxUewmYZSV2l4sBXDudDF4FKz6III2/mkDB6AizkzVGPpH0oInkr3D1AFyIIxpze3sjm1mMKs+AoeEgKW87m5pXDErb9E6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775024321; c=relaxed/simple;
	bh=2hwIID4iq9hK9w6vA8eHMCsFpcEPB9/JTX+CbITl+WI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUNfXcSDozUX2tTDbavRSYaVo6j+ORM1kTayYld93kX0A3ZHBKxbQDmp0BbICg5eplJ8gC70PD2mnnbP1vwgTGpDPSRoyvnXOfzt6LKz7cqjPVb+9MtITthHJdc3T7JRmG4jhrEa1zUW1ULsStP90mL+KyCv6SVAOrZtY/Rs5io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A403768AFE; Wed,  1 Apr 2026 08:18:28 +0200 (CEST)
Date: Wed, 1 Apr 2026 08:18:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, djwong@kernel.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260401061828.GA24293@lst.de>
References: <20260331152341.4047725-1-hch@lst.de> <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 01, 2026 at 05:18:07AM +0800, Zorro Lang wrote:
> > +
> > +_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> > +	> "$seqres.full" 2>&1
> 
> I usually tack on "|| _fail 'mkfs failed'" after _scratch_mount if it's
> using extra options. That way, we'll know for sure if the mkfs actually
> failed.

Yes, that is useful here, especially if we want to support older kernels
before the zoned device support or !CONFIG_XFS_RT kernels.

> > +_has_fs_sysfs_attr $SCRATCH_DEV zoned/nr_open_zones || \
> > +	_notrun "This test requires /sys/fs/${FSTYP}/$SCRATCH_DEV/zoned/nr_open_zones"
> 
> Can this be replaced with "_require_fs_sysfs_attr" ? _require_fs_sysfs_attr also can
> help to get the real path to the sysfs directory for the fs on a device.

No, this must happen on the scratch file system where we force the
zoned allocator, as the attribute only exists for those.

