Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C111542376F;
	Mon, 17 Aug 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786981040; cv=none; b=LKMj58gKScNP2xQ4nKI5Vcf2QTSMcBWFlbKwFZ6DBSUUMFjUFiSVHXdkdjBktK0NO34C80XlIz36nw+7jq3zHeDvAMzMZTwCMcR+h0VWcaBHfOD8xt7theiAkbXgZjT121zW8YQVum7o6k2w1jwmtqa4tZrAOd8dEfnc97dgAA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786981040; c=relaxed/simple;
	bh=FYWamzuJoFxSWCKL5fNKW+4hDr4mdtZK1qgkB3I75c8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWqjFgDv+0Yawn2u4rYN+Zw7t81RVQ3uIlmjEMpokcunBf2PccYr+JeZB/TEzgimXStGRvpVHmxI/o/VXJw8PS7pSUhvDU6nla0Gp6eZfYMCda3P5TfGGizCpQtRTyaMM+irFLB+Lnyk3KxgBmEMYv+EzpjXAWOHHzGccgcuMoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGUAcbzZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGUAcbzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56531F000E9;
	Mon, 17 Aug 2026 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786981039;
	bh=SiFMhNBo85XeONQYI7xMysmswB/FDKlJ+i51HWi9xO0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YGUAcbzZ5cNJGgU4kbM36LvX8HXYWptaedVRNfDWS7UgO1DwWF/UPjl03V1ss/rQj
	 hUFeQX8CoOWt3AwUeaPDRSsM0CKLuOXtG5McpewY2MmN/xtH15oo2JytenZjFrUKzB
	 ja8fV4RBqzEiERzmEZ3HasocYKuInrX8t346KnDsYft2AmUpzevAFurIxUsthbhjfA
	 mq+I+pACO2iP41xjR27lbtgwcgo20gce2YbwGNpYAbc7NIo3YijQPTnWxfnaPc9y4L
	 VdJ0DnhYiFn80BuTXB/SLOsb5AoQ1C8us5MgfDk7SSBsMvlo8rqq9zUNhEz5lQoLMC
	 QOLHcx0Z5GUPw==
Date: Mon, 17 Aug 2026 17:37:13 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, ebiggers@kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 00/25] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <aoMZaqbKxmp9lhKs@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260814092448.1818082-1-aalbersh@kernel.org>
 <20260817070240.GA17371@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817070240.GA17371@lst.de>

On 2026-08-17 09:02:40, Christoph Hellwig wrote:
> On Fri, Aug 14, 2026 at 11:24:17AM +0200, Andrey Albershteyn wrote:
> > Hi all,
> > 
> > This is next revision of fsverity for XFS.
> > 
> > Range-diff with v14 also below.
> > 
> > Patches without review:
> > [PATCH v15 07/25] block: add task-context bio completion
> > [PATCH v15 08/25] block: don't delay bio task completions
> > [PATCH v15 16/25] xfs: handle fsverity I/O in write/read path
> > [PATCH v15 18/25] xfs: make xfs_free_eofblocks() work with fsverity
> > 
> > The patchset include some patches from lazy-bounce@hch-misc series for
> > BIO completion in task context
> 
> A different version of that landed in the block tree.  

oh didn't know that

> So let's hash
> out how we want to handle this for the 7.4-rc merge window after the
> dust for the current merges settles.

7.3-rc?

> I can have the lazy bounce series
> ready early for the merge window, and should be able to send it out
> once all depdendency trees hit mainline.  Does that sound good?
> Or should we split the minimum requirements into a separate
> branch?

Then the only patches I will need is IOMAP_IOEND_INTEGRITY with the
helper. This is probably a bit too small change for separate series,
but this will also work.
I'm fine with waiting for lazy bounce, as I still will have at least
one more revision.

-- 
- Andrey
