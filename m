Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793696608;
	b=DU9mrYFYA+9tbkXceLPmH5ce/A6DpApLNJNTvE9fwKFRTvTuBo8wQR2M77tZ7SXbNCjs
	 20KX0V2kzPJCYPVl17sjxBYoSCIuNLS8QjZw5ixngMLryH2QBeODsKpvhMCxH/339xsdD
	 gB+6ZAJrOQsBluQkYM/gmRWxOxBaCjFEIGVe3ggT1HETAJ2GoYBYvh9LCRpl8+dxAUVxJ
	 YOiEGxPyPzSpCJ+whgZn28L7iwXKtC9WaLM3KqzC5eM8HV5nMSOOXP8wfNuwUk12wiGYV
	 8EgGAwlbKUQ42VZLBlcMj7fAMbOSi1Pnf0GnMtCFviahGs4HsYudk0bMZrkUGdxL7Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793696608;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=GHGz850caSwjJKS3oE56h9NFkxUphg5/vIJAawh3jok=;
	b=k4yxZeiMWGruwUyXYm5MCV4jiMCyRAzW14y/arMovpcLNNxCzvT/8s2zgQanriJkU+PF
	 bDkID6GDpEv8GYvX8eqRy082/BwqOXdZsdHSLk1wex9zscouIVutCZwl4Dq/iHQ/osTA9
	 o9UwFnSsbWOkihshU5OQBj/sCuVcqZkSPVqvk/YhKlWxIk7CFdxsCG9fxpjxUa+ho5ZrS
	 lqwzbeCETJwKgHNOSB49ZhJSdm9VlBUMn3x2tewC6KtjMwocRa65kiZ490NuJ9nJmXWjf
	 m/6/XtfxCuqkYqwlHd3F9h1qo99qblwpaeROMrl2YUeFwl7LYV/+ZWAfGSCt4B7I2mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F7D606A324;
	Tue,  3 Nov 2026 09:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0F7D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5881F68B05; Tue,  3 Nov 2026 10:03:23 +0100 (CET)
Date: Tue, 3 Nov 2026 10:03:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>,
	ecryptfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	exfat@lists.linux.dev, linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103090323.GA5314@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org> <20261103054155.GB1559@lst.de> <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-galgen-ehebruch-stehen-a967c14ce53e@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 03, 2026 at 09:41:58AM +0100, Christian Brauner wrote:
> On Tue, Nov 03, 2026 at 06:41:55AM +0100, Christoph Hellwig wrote:
> > Btw, if my previous reply wasn't clear:  please add the test for this
> > to xfstests where they actually get run regularly and not the kernel
> > selftests which for file systems are basically unused.
> > 
> > Bonus points for having generic tests instead of purely file system
> > specific ones.
> 
> I can drop the tests from this series but xfstests for this will be a
> follow-up.

I'd much prefer to have one canonical place for the tests over having
them in two places.
