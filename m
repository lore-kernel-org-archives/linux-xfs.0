Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCF67EEE4
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 04:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706762010; cv=none; b=DOwzz/3Ku2cvShcd4zenhZVNNiVFwgQR6E0W2w0L7dVapiM4TGelTl6yhQn1KvctnmWj8sfpN0UBYSTgJ9HYTWYWGpNpy46OXl48aUg1kuN4kIu1aGoQ1dA4e89jkS2nhAO89DX1ryLZHZFUZPObyRJk2r9ZSJw7dqaVb/llS/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706762010; c=relaxed/simple;
	bh=b1NtrW1mI77/QMHOHaHD8Kq9+GIn82rc/PQjcjdlbRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XTMzF+oWNCFonhohTci+vEG9vrrTWhPH70JYVKCI1XmiNzMoqkt6yqw8vxrxcwt7Warrd1fHUHsqVHu9ylx/X9sv8Tb4LCuBMV78LkLL4UtMNCNeDLgqkmjimdpaFZvlzEOarQRf42m3H0/Sqd9rwJWSkBy9nrROHJWh35ss7mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QSAdIiWx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QSAdIiWx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y17femd0CHXpsFMAWRAVoJ1BzYCHd35oeIoc/EHSAaE=; b=QSAdIiWxhjCPHYCFXpy8t04vyb
	KFFVgbSFA+LI18iTcd9iYD47m68ZB0FPzqmYgTVA//elHP7UC8N2ttNT6AbSCmoSJgWEZ7gPFse6P
	DMhTHQO/JHU1MdDMLHesEAF3v6Pa/S6sPWWJvayZ8serqjvvSyABVLjKNDWoHQKy1lMOHgA0o2MR6
	K+91LIc/XYEj4NDFH5R/XDHRVKmI+ue53jr9sl56vWQz6mZnT+NBqparv8NfqKNTiSLc5izu6FvBx
	zEgDNrlC/oDECs7xnlcDpTFb2n+rIAb0mODxFNEWNGCESg+y8GNjU7c/l61rXWGW4egpqYiIT+2Wz
	uFLEmbaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVOlU-00000006Wmr-3Zqm;
	Thu, 01 Feb 2024 04:33:28 +0000
Date: Wed, 31 Jan 2024 20:33:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <ZbsfGOqov--AFdBh@infradead.org>
References: <20240131230043.GA6180@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131230043.GA6180@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 31, 2024 at 03:00:43PM -0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> Christoph spied the xfs_swapext_can_use_without_log_assistance
> function[0] in the atomic file updates patchset[1] and wondered why we
> go through this inverted-bitmask dance to avoid setting the
> XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.
> 
> (The same principles apply to xfs_attri_can_use_without_log_assistance
> from the since-merged LARP series.)

xfs_attri_can_use_without_log_assistance actually is new in your
patch stack.

Not that my biggest issue is that this check actually is broken.
The point of the compat,incompat,log_incompat features is that they
move away from a linear version model where a new version implies all
previous version to one where we have a bit designating exactly what
is supported.  Optimizing away the need to set a bit just because other
bits are sit brings back this linear versining in a sneaky, undocumented
and dangerous way.

> The reason for this dance is that xfs_add_incompat_log_feature is an
> expensive operation -- it forces the log, pushes the AIL, and then if
> nobody's beaten us to it, sets the feature bit and issues a synchronous
> write of the primary superblock.  That could be a one-time cost
> amortized over the life of the filesystem,

Yes.

> Given that this set/clear dance imposes continuous runtime costs on all
> the users, I want to remove xfs_clear_incompat_log_features.  Log
> incompat bits get set once, and they never go away.  This eliminates the
> need for the rwsem, all the extra incompat-clearing bits in the log
> code, and fixes the performance problems I see.

I mostly agree.  I don't think we have to strictly say they don't
go away, but makign them go away should be explicit and we should
only do that if someone has a clear use case for it.

> Going forward, I'd make mkfs set the log incompat features during a
> fresh format if any of the currently-undefined feature bits are set,
> which means that they'll be enabled by default on any filesystem with
> directory parent pointers and/or metadata directories.  I'd also add
> mkfs -l options so that sysadmins can turn it on at format time.

Yes.

> We can discuss whether we want to allow people to set the log incompat
> features at runtime -- allowing it at least for recent filesystems (e.g.
> v5 + rmap) is easier for users, but only if we decide that we don't
> really care about the "recover with old Knoppix" surprise.  If we decide
> against online upgrades, we /could/ at least allow upgrades via
> xfs_admin like we have for bigtime/inobtcnt.  Or we could decide that
> new functionality requires a reformat.

I think a runtime add (for recent enough file systems) would be really
useful.  But it should be an explicit opt-in and not a silent upgrade,
which avoids any surprices with reocvery tools.

> Thoughts?  I vote for removing xfs_clear_incompat_log_features and
> letting people turn on log incompat features at runtime.

Please do!
