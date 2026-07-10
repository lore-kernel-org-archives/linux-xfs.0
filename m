Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E40B3BBA1E;
	Fri, 10 Jul 2026 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718904; cv=none; b=jyH9ogtyXTp9MzY1WWE9TwL4HLQdkzAllrtxwwYss9uN74O9GldQzQMuTzyYpdRjbyxmAB4J+DqtIESQqmK/grrQF+p/TvLZKgexBXKhFcyIsU4vK4KUV0+GLS57nkKcy4K9gsR6Bm/ZxWBH8IFA46UvMPwL/03US6NfncgVfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718904; c=relaxed/simple;
	bh=PJWerdtvHB5S0cqTX7UgTPfBijZIZyJQKkqNm2CtAAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDjtc5wBKwkEBBgVezrQBfordVG/DjxJkK6OL66rI20xiGC3wJvH/V5dti6QbRUeFi0ShpbJYkGi2ewtDw/k9g6PwR61TB5fVqL3hROnH5+pddt8YRmfAcWG6deTbI0apw5d9i7fMfhpWRpo59NXLSAq+laCs2ZJtgO8EnEt22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKP4VFek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKP4VFek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFF01F000E9;
	Fri, 10 Jul 2026 21:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783718903;
	bh=ZCdcaplzXS+st+F9pQrq95mwr9V9sUpfcWrc6HigFVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lKP4VFekqRrDXMUTynV25kuSERjqn9hJ9Ch0qp7i3OsmYvjVwp0Cgl5OBlQG0zDUV
	 9HX29Cyg8gnEdC5tCHZxQHWINeS8H3WxYk/C91oaOM0P1m8zoOKuv2z8FeZgcKEFtp
	 77vpCAn+8eTZ6KsoLUFqwjLhrxldcsj8sHOSpV7/zueTjxNXjALnzm0KavI4TV3ERI
	 Ac6Bp0WfTi67wQ/AyI20TCSkg7zPnMtmzL6nmRecfZ7QAImIpfVd8L7eD4vaO3Gg0u
	 mIbhaU4kKik5G5EQE1l6AnZ1u6y4Ir6Uc7cBcUuHBhfvzR1IOSj4U38l1NA/aZ5l1P
	 CAybVm3D/zbTA==
Date: Fri, 10 Jul 2026 17:28:20 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-xfs@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	Keith Busch <kbusch@meta.com>, cem@kernel.org, aalbersh@kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>, tytso@mit.edu,
	linux-fsdevel@vger.kernel.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH] fs: report direct io constraints through
 file_getattr
Message-ID: <20260710212820.GC1911@quark>
References: <20260708011843.1036846-1-kbusch@meta.com>
 <20260709071352.GA20180@lst.de>
 <ak9f0CXSegLq8l5w@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9f0CXSegLq8l5w@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Jul 09, 2026 at 10:51:39AM +0200, Andrey Albershteyn via Linux-f2fs-devel wrote:
> > Andrey, is there a man page or other official documentation for
> > file_setattr/file_getattr?
> 
> No, I had a draft in cover letter but haven't got to sending it to
> man-pages. I will prepare a man page.

Or just abandon this series, and read the statx(2) man page which
documents the already-existing UAPI for getting the DIO alignments?

- Eric
