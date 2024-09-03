Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023901CDA06
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 04:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725337623; cv=none; b=ei9dmpoei/qhrXlOir0zsCX5winBONvmOwiFmcGNlqWDyL3RPTnza/R8REm6pCdNP8UAFxNfM8uAHA4I0BqAL+sHe+7AyR4wixg8EdBCnc4Q4N3kCBD+66uYfXrgKY9WuMiMBEjjkdgKzbC+8yvKThrRcHEJJ4Q1KNtLB+0jMkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725337623; c=relaxed/simple;
	bh=GTTfaQxy6PDlhVyyz0QEi6e6snT1BK0YS/dzc8TVhyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcB0hyEvy/yg6jtoGu56CEvXvCDJiXp47D+m1Biyam4xnvqBTZyMLeTv3D16b/IWla12xux6q4YR8+Gf/yhn3NkK3ZBNCt00FX5HHcs4XLCY6kyOum1uy2YM2/U++nIc5l0AwtwHgOv2ghnUSeRS62bzeTiJtel8VHhKIsDGjZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8D90E227A87; Tue,  3 Sep 2024 06:26:51 +0200 (CEST)
Date: Tue, 3 Sep 2024 06:26:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: merge xfs_attr_leaf_try_add into
 xfs_attr_leaf_addname
Message-ID: <20240903042651.GA30523@lst.de>
References: <20240824034100.1163020-1-hch@lst.de> <20240824034100.1163020-2-hch@lst.de> <87v7zemua2.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7zemua2.fsf@debian-BULLSEYE-live-builder-AMD64>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 02, 2024 at 12:08:41PM +0530, Chandan Babu R wrote:
> On Sat, Aug 24, 2024 at 05:40:07 AM +0200, Christoph Hellwig wrote:
> > xfs_attr_leaf_try_add is only called by xfs_attr_leaf_addname, and
> > merging the two will simplify a following error handling fix.
> >
> > To facilitate this move the remote block state save/restore helpers up in
> > the file so that they don't need forward declarations now.
> >
> 
> Hi,
> 
> This patch causes generic/449 to execute indefinitely when using the following
> fstest configuration,

FYI, the culprit actually was the following patch in the series, but
I've reproduced and fixed it yesterday and am about to send a fixed
up series.

