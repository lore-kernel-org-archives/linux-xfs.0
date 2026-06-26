Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439813D6491;
	Fri, 26 Jun 2026 06:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782454604; cv=none; b=IFS6q1kTcF2yG0XUoGpUcwJFX428VmLqLbudDQmAGb7zgiViFjLne+gtMNSoF1+BFM3ph4VfUl6FJoz3fN10BShN0dPmiCak5CbdxcGniKSSMgr4Yqj74t6oDKJHMk0nNKvZOQAZCtENn99v22yA6AVP93JBsP2sUSw/kX0nzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782454604; c=relaxed/simple;
	bh=b4eZyh2SQyqH97WLw4olwZeQrRJ6vlGNff2ajbXVab4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAk5nrhZH/ymH1t8PtASuVBM+TFGEJ6+oUUswteze2e4RMVI82DKY46mEz5EwsdJznJjek8n5W00cqWTU1AFzm7KnSdOEu4AtxVr8evnNvxnTSp8780FrD4q/yz08iqkoXqWx2P+JA885KI5mU1yFg1p+7nQdvLjUZmdUbMR4Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0352068B05; Fri, 26 Jun 2026 08:16:37 +0200 (CEST)
Date: Fri, 26 Jun 2026 08:16:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] iomap: submit read bio after each extent
Message-ID: <20260626061637.GA10337@lst.de>
References: <20260625120803.2462291-1-hch@lst.de> <20260625120803.2462291-3-hch@lst.de> <20260625174758.GE6078@frogsfrogsfrogs> <CAJnrk1YFeirQ4g7qcVsda-8qPLeAtoiyW6ZBuJb2qDsGpxi-tg@mail.gmail.com> <20260626043319.GC8078@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626043319.GC8078@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 26, 2026 at 06:33:19AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 25, 2026 at 11:32:40AM -0700, Joanne Koong wrote:
> > Yes, that works. I think that's a good idea. fuse only needs
> > submit_read logic for readahead. The change would just be:
> 
> A nice, I'll fold that in.

Btw, can I get a signoff from you for this?  It looks like splitting
this into a separate patch actually works better.  If you have a
preferred commit log I'd take that as well instead of mine.

This is what I'm currently testing:

https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/iomap-read-submit-bio
