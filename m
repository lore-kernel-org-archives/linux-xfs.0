Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE007233953;
	Tue, 21 Jul 2026 08:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784623597; cv=none; b=RxzkJVEQToscW8qD07TbRaVdnd2OOWdntz5FCYwcA89p9gFwBRheDaED5FPY64wswDeajrRFiISqKt5Qua4f71PYl3gu0b/pHkjgmJMCAHJtIY3H61iDC37BxKauAsrr2wQl5sqNOg7uxoTqUsh2jlCEqh4dFfoJjtBjy77TmjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784623597; c=relaxed/simple;
	bh=O11ij9m41yf4mh94h/zXZlyjPuod7DAZZ68WQ88M3Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=asQVu18Iqy+cK7hWiv+cCjbvRdI4gWbI3escVjPTsxqCvqJotbLkHTbkgk5qkJ9mCmOQ8tr0LKe3IoxsqvrK1ToncDSYtOwYpnRNqzaDMtFKcXo/AdgjFGH+M6uR7anXeqKgWs3foG3n0I1qlh2mNkW32Gon2Y603HOzrYtHU7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAGHzQ18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAGHzQ18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2CB71F000E9;
	Tue, 21 Jul 2026 08:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623596;
	bh=0yqMpnEPq/L5fm2o1Ao627XzVu2ee0Fggb4NXRXVeyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JAGHzQ186uP7n0APk7n0/dFNl53i20DQGB7zCh1e4q6hsDp040OKtMlwF7pGod4gr
	 mXDZ6vU71e+hARgwbAqWmFqiIMex4OFZvYZpUZUBc6EsxGLKjJlHVNPcB9vnwWWo/p
	 ABrG+EK/zKTxOrneMzZ4u1b1u4P9ltDhR+OmNv+UxZm79TGfalwpcAFGq7nnkOA66G
	 k1nwuOvRK6lkWKaOE5qJs2da+htRdIeHEbaqKlo4VpG+gkp8FkpFCWOYOPTnStyb7g
	 zFmFKghqldrp04le1xoxqVIslwuG94YSwevSg1YQxTW5RXRD1tKiGI5tAHGqbWm5tm
	 iLyhvhu0tc2+Q==
Date: Tue, 21 Jul 2026 10:46:31 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
Cc: hch@lst.de, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, djwong@kernel.org, 
	linux-unionfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v12 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <al8xgOwueDOzGakK@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260720090410.3487990-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720090410.3487990-1-aalbersh@kernel.org>

I will send v13 shortly with more sashiko.dev fixes. I run these
AI reviews locally but model is not that good.

-- 
- Andrey
