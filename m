Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029C1263F5D;
	Tue, 23 Jun 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222785; cv=none; b=kMDlrkqyRdDTId1lGR6+91cowvYSQdOnu5JPe6xZRoDxvNOj/5OurUxgone/i5Y1EQVByQeJWCkkW0zginAqgeylJLMkFPX27NgHz+CzbgMDkSi2WnvoDrglRAEtnHRlzkGyuECA0+NzMi4zF+OfDwrJaedusxabY4yyMYdWiyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222785; c=relaxed/simple;
	bh=IU35pXaCxbba6lk74nkqid4mkn3LULJzvPghf/ZGitY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CN6qOuwwymj9kOGpmXuiOeCpS6WspQc/RGzrwAoE9TrvrLVakE6pLQuQlwyBu1L70Pw65oB8WQn4Di7J/9pFxZuSSz95gADg6wJnBcTeUbTJlqt7t2raMJpaOa4YaVcHHSQ9ZLg15h6Qqw76MHs6WMQYCAdeDE0lVbGW3XkqYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 54A3968B05; Tue, 23 Jun 2026 15:52:59 +0200 (CEST)
Date: Tue, 23 Jun 2026 15:52:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Kelu Ye <yekelu1@huawei.com>,
	Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: submit read bio after each extent
Message-ID: <20260623135258.GA8720@lst.de>
References: <20260619050105.439956-1-hch@lst.de> <20260619050105.439956-2-hch@lst.de> <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1ad7Wxr9CB4P1=VZPUS_BRmHTTmRVXVgRjM628iFCZh0w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 02:51:36PM -0700, Joanne Koong wrote:
> Does it make sense to move this line to the bio submit_read callback
> instead of unconditionally clearing it here? If we clear it here, I
> think this makes read_ctx only able to hold per-mapping state instead
> of also being able to hold persistent state across mappings. fuse
> currently uses read_ctx to hold per-request state (though this patch
> wouldn't break anything since fuse only ever returns one mapping
> covering the whole request).

I've done that for v2, also we also need a new argument to
->submit_read for that to be useful.

