Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC8D2BE652
	for <linux-xfs@vger.kernel.org>; Wed, 15 Oct 2025 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559981; cv=none; b=Uok9kBZEpAQGzBGsIz89Qlvm3MdRp23qoRWa8lMnd9pdS85fRJGCx1HJ4YClb6OMOpH//GoSkCLHz27mvNEtCKb0H1oNo5kVF3uSA7IGIev9fRbcMOeVqmImytS/q+sFWtTSIbwYHF74pkFMBzR/vVkuv+yeC8reRIspKQv4C3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559981; c=relaxed/simple;
	bh=rH8yEEZGj/r22kAqm5PG/ZRkAvWqACkvxC2fKgbam0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1FGAI25fFo1gW8ax8S61pRdRT1tfhECIEB3THWIKSG5lEcHpQaMenP+0I8kdoijHKAwopT5ZQUXW02te2KdGTpGPu68sgt3dsx/wFkAVb36I8BfSnU4YDiVl7cJJebgXe9MzGfmrTbOheBWXd3rT9m5nItT2U28J3oC4Mj8VnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pS3d7foP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pS3d7foP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD7C4CEF8;
	Wed, 15 Oct 2025 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760559980;
	bh=rH8yEEZGj/r22kAqm5PG/ZRkAvWqACkvxC2fKgbam0w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pS3d7foPLA8lMtop3kw1/win2w/Mnc0s9Zyh8rWYvBwOZjRtY6u2apJ0pahGywoRe
	 RVxSOGdHBSdAkNLeb/LnWlOGZFUUL7khE31U+8xnjxG4YJ8+o3YfhEXvChU9Phim4+
	 GOnMmHr2PY0cGGgEakCUsDevXBKPdpgR3qhFYAAER4EU0L91r3DtAJY1eVLP/dp4Ek
	 oWUORynFl/B6EuqtFc/OzfwyUsaZ88fP2XfM5L2UBdrpJH3pOykMBdgqAerzVZHgKh
	 d3mbX2Fgf0HHmdbrzMqu5ueDDB82M4k+gE8qGlvURzIxEqW6r11oUT448/pGZPJmzE
	 LINl9OpI/Ylhw==
Date: Wed, 15 Oct 2025 13:26:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: don't use xlog_in_core_2_t in struct
 xlog_in_core
Message-ID: <20251015202620.GF6188@frogsfrogsfrogs>
References: <20251013024228.4109032-1-hch@lst.de>
 <20251013024228.4109032-4-hch@lst.de>
 <20251014214742.GI6188@frogsfrogsfrogs>
 <20251015043422.GB7253@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251015043422.GB7253@lst.de>

On Wed, Oct 15, 2025 at 06:34:22AM +0200, Christoph Hellwig wrote:
> On Tue, Oct 14, 2025 at 02:47:42PM -0700, Darrick J. Wong wrote:
> > On Mon, Oct 13, 2025 at 11:42:07AM +0900, Christoph Hellwig wrote:
> > > Most accessed to the on-disk log record header are for the original
> > > xlog_rec_header.  Make that the main structure, and case for the
> > > single remaining place using other union legs.
> > > 
> > > This prepares for removing xlog_in_core_2_t entirely.
> > 
> > Er... so xlog_rec_header is the header that gets written out at the
> > start of any log buffer?
> 
> Yes.
> 
> > And if a log record has more than
> > XLOG_CYCLE_DATA_SIZE basic blocks (BBs) in it, then it'll have some
> > quantity of "extended" headers in the form of a xlog_rec_ext_header
> > right after the xlog_rec_header, right?
> 
> They are not directly behіnd the current definition of the
> xlog_rec_header, but rather at each multiple of 512 bytes past the
> start of the xlog_rec_header.

<nod> And that only became obvious after I read through that patch that
removes xlog_in_core_2_t.

> > And both the regular and ext
> > headers both have a __be32 array containing the original first four
> > bytes of each BB, because each BB has a munged version of the LSN cycle
> > stamped into the first four bytes, right?
> 
> Yes.
> 
> > The previous patch refactored how the cycle_data transformation
> > happened, right?
> 
> Yes.
> 
> > So this patch just gets rid of the strange ic_header #define, and
> > updates the code to access ic_data->hic_header directly?  And now that
> > we have xlog_cycle_data to abstract the xlog_rec_header ->
> > xlog_in_core_2_t casting, this just works fine here.  Right?
> 
> Yes.

I'm satisfied then.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

