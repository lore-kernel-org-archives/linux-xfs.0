Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD271C4A36
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951434; cv=none; b=iBz/Vt8O0Sbkg6aQO6MI7J04JV9ZJEXtrgJaNavYHrkhiTsAbG+5ieD7BCzycduxbUHICtX7Ax3DDidadpDfAaJuohCV/yq7/1F2WRB74fMny6bQye/wkW0N/wxXSiopBG1NFsAR/emnnA7/HL/sNP9FacRruN/fOwZyt6Wf/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951434; c=relaxed/simple;
	bh=vv4fIvnfV1IsmYvAvh6qUTBl9t2u/AzsSQdoyiKQrDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KJyyucx5Cv3BaleRqaOXdfBwRZGJUr8A7228VN9cFK+yzrMLEHVo1n2ZjoCPQBdh3nGN6LvZJbi7gv5ZGIJdAOg9WMN5tfJq6pwYVtXxBuTTgh71VrA2mYjfy2FmFYJT2WWigO430Lj4buXs6ZJRl5se1KMTXXI1pee8OBbErJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ueuPUUgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueuPUUgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D99C4CEE0;
	Wed, 11 Dec 2024 21:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733951433;
	bh=vv4fIvnfV1IsmYvAvh6qUTBl9t2u/AzsSQdoyiKQrDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ueuPUUgkZWc2A1wuxCmqD8W6v0/UlIxFaegF54dp03313Hzngn6AH0qVJGmpqVWXN
	 2yXTI6b5vcmGSOYrjmgX3wVpSSjqRwLxu/2vdMPNrKie6AkmVLmsCRsEYvg4XtzxCc
	 BpTMPV4290n/QpRIT4CofkgJWWPF+5um35SJD9PVSDk32dOgPMtkknev4S9HtUUctH
	 8JBhb1HpiH2gpbPAVCyiIZEjuNc4RESlKyr7YV05aIQfxPkgVe9RpW2FWZ5iYM5uCU
	 G9+52ALwBUv1xrfNyoXqOSreGG/wfrVNE/34FeQfnO8z39baJ6DoB3+ht7wW77+9UF
	 WVGTxPYmX74pg==
Date: Wed, 11 Dec 2024 13:10:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/41] xfs_repair: preserve the metadirino field when
 zeroing supers
Message-ID: <20241211211033.GM6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748558.122992.7333141265239426688.stgit@frogsfrogsfrogs>
 <Z1fMAPolMirVb3aC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fMAPolMirVb3aC@infradead.org>

On Mon, Dec 09, 2024 at 09:05:04PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 03:45:07PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The metadata directory root inumber is now the last field in the
> > superblock, so extend the zeroing code to know about that.
> 
> The commit message matches the code, but the subject seems to directly
> contradict it, so it'll need a little fixup.

Ah, yeah.  Let's change it to:

"xfs_repair: preserve the metadirino field when zeroing supers"

> The code changes themselves look good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
