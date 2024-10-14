Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A9D1C302E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728949267; cv=none; b=MyQkQMHTUtTPuqc884C0tuimZEFsO6gC7NGlgu4XKU6EKfQqRAouMXmZV40I8vSAUV3jIy0thd+vnqN5Ud4ZrZTrFD7fK+LBzjsjdAeGBtq/OAqMN5mQwevO7iQTPC2xAatZV7Z4tg2cQhfE/NIDO3Lmn1bQw15osIe8TC2HM90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728949267; c=relaxed/simple;
	bh=3KBn8fezGMRz9HyUgP7KnH5dBFRw9CBzIII0uRSWofQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mP9KUFaPi+BRRsOnqdAe+oyfUuY2C1Oy3qXfxpqoC+ZauCWzEC7dXq48rQsVs31KfuPJB+zw3jr0Lp9L8tfJo/uHvxa/sE4VgmIODCfydRxetKisZbpHGSpjp4dcTDXpUgrfKklzsMej7/fDXpKK7uWFHN1u7KZCXNBzWqxGOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YkKP7BPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YkKP7BPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE69BC4CEC3;
	Mon, 14 Oct 2024 23:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728949266;
	bh=3KBn8fezGMRz9HyUgP7KnH5dBFRw9CBzIII0uRSWofQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YkKP7BPeysJq4QN1bANuOga47d6YmmR93zb5GxOsz7uL1EL6nxvDo3vsYHUXHIP/M
	 ELiuyPwkRVLKgJ4Pn5+kFsEfupqHGtQZOr/RXfCw5UKdGxW+0ODGS4UJ1nZNX2iwPV
	 ktWgKL17OgZhxN49Eg7C3O5is5epgelPJ+mVmvdjiOaFwRl34j+Xy09zDlvdZT2hmM
	 te9w++p5laxJuKVnDqxZEM2kaYPGJapvZit0xp4FgmV3EQx25NmPQ+GTmwS6lid59Z
	 Z7ledVlR5YSpo4QZi+m0Ay98kaTdDxDtbUNHGGzAYls28CoJ8v99UanEXHih38NPsl
	 GsleqzzPCOSIQ==
Date: Mon, 14 Oct 2024 16:41:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: add a xfs_qm_unmount_rt helper
Message-ID: <20241014234106.GI21853@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
 <172860643085.4177836.784622735507950940.stgit@frogsfrogsfrogs>
 <ZwzObUb46IcTP1HD@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzObUb46IcTP1HD@infradead.org>

On Mon, Oct 14, 2024 at 12:55:25AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 05:57:46PM -0700, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > RT group enabled file systems fix the bug where we pointlessly attach
> > quotas to the RT bitmap and summary files.  Split the code to detach the
> > quotas into a helper, make it conditional and document the differing
> > behavior for RT group and pre-RT group file systems.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This should have your signof below mine if you pass on the patches.
> Same for several more patches past this one.

Aha, I thought I was missing something!

For patches 8-11:
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
