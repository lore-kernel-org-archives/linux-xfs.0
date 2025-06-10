Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEEE299A94
	for <linux-xfs@vger.kernel.org>; Tue, 10 Jun 2025 14:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749564047; cv=none; b=hKgnqspEGzjrE+sSs4FGMFqm03sxpb/ZrsDiffqpm6OswMIoOxY7Zx9Fup4EiYA90tTJo5KnfVfBDBQdTgjWb5KXPhk6AXbbJeuCSTX/dv1dIwzxSK670XTZEYkTpSdLCMqh4OBpAcSaHwr107fAJxh6uVJ8Rqy0SrcjpFMPcG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749564047; c=relaxed/simple;
	bh=xHFVmWuOVZWftkpO8chQ6lJ1oqoIAmQXLz5MFBW2hSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=il+6yxBiKgpmC/U6g9JxiSFekj941nr5JOnIctg0CcKDVCoUKFZJI1DgK3FOg5Vr4qYf0nO1kZ40+eI5lH6UufdfNFGym9BVXG9Ph97dru2bCoDTklrM353uE8gRXE9rhRP/NDdVzo+rljLF7dYqFrDYvvi1dgB7g48Qv7UCf/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4n4DI1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4n4DI1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285C8C4CEED;
	Tue, 10 Jun 2025 14:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749564047;
	bh=xHFVmWuOVZWftkpO8chQ6lJ1oqoIAmQXLz5MFBW2hSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V4n4DI1pxgIMcCKn2A15DP4dD5qZSs3acnMqnZf8fOlJU7cweYycpgTdUtwYoHai4
	 pjAnKwhQYN/h+/UfwToxbD6PBU/yalVnDBDgncn9Hu49q5U96YypbRa7kwZ1wDB5aw
	 EG2UtPH1TPGFDWyLeceGjJUXZZY6OO1dKbsDCF3DaF4YTzadraokpcLCZnjI1KMsnX
	 4wUe7/U9efKIrftUYR1PWTCf13jgwGDEEHDo0JbDE4YeN7NPOMLOJlOKzcDrd+7H4a
	 HRczjp/TPl2ZE49jrIIWw9d+nUh9CaQdlT36jNA8q2mNR2uraAQx/KPDuGu6yZ1dXP
	 Fiyv77ynqqYSQ==
Date: Tue, 10 Jun 2025 16:00:42 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/17] xfs: cleanup the ordered item logic in
 xlog_cil_insert_format_items
Message-ID: <63dwxkm4o47k7p2mcl7ntz2jwfkwb6oyfb7y5akrbsmfpw5js3@2gil4omksude>
References: <20250610051644.2052814-1-hch@lst.de>
 <cqWn7I8cwwfGuWnf1e0-3it6wZgwjbXDsuuqz5qtz1MSy4hWQDWfQNT8SefFV7CfDrh1OSxj8qotWfFp9SYFtQ==@protonmail.internalid>
 <20250610051644.2052814-3-hch@lst.de>
 <txjhmsaiqnyjl46nhz75ukobgnmxwy6ka3wlsb6xvdz5v6bj3t@hpkwwjwk5f5k>
 <IF10wtmvtSlFWtrw31ibrDo_KjnPuFLPOcuMR_IzOQO2tJISif7LEWAEeHdnRhNcwLkcl090w4Q2r60HcSAU1g==@protonmail.internalid>
 <20250610133235.GA28445@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250610133235.GA28445@lst.de>

On Tue, Jun 10, 2025 at 03:32:35PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 10, 2025 at 09:56:04AM +0200, Carlos Maiolino wrote:
> > > -		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED)
> > > -			ordered = true;
> > > +		if (shadow->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> > > +			if (!lv) {
> > > +				lv = shadow;
> > > +				lv->lv_item = lip;
> > > +			}
> > > +			ASSERT(shadow->lv_size == lv->lv_size);
> >
> > 			This assert is kind of confusing me. if we have an
> > 			ORDERED vector here, couldn't we still have a shadow
> > 			size smaller than the current vector?
> 
> The size of ordered items never changes, it's always the same constant
> overhead.
> 

Fair enough, thanks:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
