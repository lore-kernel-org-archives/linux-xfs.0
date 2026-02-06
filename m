Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365AD2FD695;
	Fri,  6 Feb 2026 06:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770360412; cv=none; b=mr0Gl+CzrfNbCjy+L2wPFB3xIbav+ud4kPV8bRZ4fy9N/qXevL10G3tv64KjWpTZJmI68jfDvrkf5mZNE+PrGbVcSpZI+HaQX5eF/1G3xhvU1Kikid77Y2KttvZzQgJhCkmn8vkRRX5OLykuwHHAhIqqIIZQyWJi0yJV+MP9JNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770360412; c=relaxed/simple;
	bh=k2PGx8YTuLWjwYuCNE10h/svplgQ6zoXmngLFJVflyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FRVaBc54y6YA6jGk4zyf8d3pA5U4h53IUSFsyzYszj66EL0MQuzImgqrxRMUJtzAGP96eU3qzJe8WBPNaQ99ra+ZFvpsIfSmVP/mZNI5hH1/lpguB4HQhgdJRoFn+wLR43hrnHwoHBds7BLW9wf31v1uGzmovqVznpcUn61zc0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7638568D0E; Fri,  6 Feb 2026 07:46:47 +0100 (CET)
Date: Fri, 6 Feb 2026 07:46:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com,
	david@fromorbit.com, amir73il@gmail.com, axboe@kernel.dk,
	hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org,
	dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v3 5/6] xfs: add per-AG writeback workqueue
 infrastructure
Message-ID: <20260206064646.GA26533@lst.de>
References: <20260116100818.7576-1-kundan.kumar@samsung.com> <CGME20260116101259epcas5p1cfa6ab02e5a01f7c46cc78df95c57ce0@epcas5p1.samsung.com> <20260116100818.7576-6-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116100818.7576-6-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 16, 2026 at 03:38:17PM +0530, Kundan Kumar wrote:
> Introduce per-AG writeback worker infrastructure at mount time.
> This patch adds initialization and teardown only, without changing
> writeback behavior.

We really should not be adding extra writeback threads in the file
system.  btrfs has done this and created a lot of madness.

