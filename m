Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47B35678CF;
	Tue, 22 Sep 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098307; cv=none; b=nm7+qUQ6nWHWMXT6z2mV7XpGLuntuTVqt2YNSW9+4QFdALgo9PrKTh0jcQMT143/kSR9N6y9gOyx+bGzRcrQdFnmZqIjc9XNHU7DcgYtwqdQ1s7WTQmmDQIk66V2acuksbX3LWCXOZg7bPagADru7qg2Ss2qKxiSHuvargkTcZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098307; c=relaxed/simple;
	bh=RE2vYqLGUfFiZ5NPLEG0dYbSiI0t72JbiXXXY1QE9kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b04FoKYlYZZ2sZGPCisBYZBQfNAgTSQ5uqPpc0ylGUKbAMlHcLtrkixxVsrT24l/c0/Z5IeUsy33kaMVZYEzf/WjmzwQ2iD7LPkZaZeuE5b254OgkHIBFi33EV567HnDW7vD1pU+pYbnk2F9qOTSQimj49NO5m4Ol89Fdk5AUsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogGW57G3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogGW57G3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3A4781F0089C;
	Tue, 22 Sep 2026 17:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098302;
	bh=EdRk5FlVdvNNByYDhjinAG6JSTRi/D84DAuFdLDiiH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ogGW57G3ilRj0u2i1gIhRc/VgD4zAVnhYcHHGONK3fxo+2rSsM+TDXU//yM6nKQfH
	 GYssiu3GmE2gGh0jHm071axfh/AW71M+WfRGp/rmHFikrw6QZmpjYjZGDklwi0u7PG
	 pq8CbqYmm5Z0ogCYG/+4K2wTNrIrZ1LrQRCAHiHxSttsegSZyzGuio4jhBUBx4STf7
	 VPpzbrQyxTMWy3TJmswGc3qPFKmUTZVJE1M00mHSwY2/MTRxpFb56fKcrHur+EyCA2
	 PL5qjRUWnfDExeTeEE6DwF0NdTvCk6QnM+tMKOgugmpjgtIfBJw0zUKkFCjni3hxq3
	 fyeEHlPberA0A==
Date: Tue, 22 Sep 2026 10:31:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: fix buffer overruns in xfs_ioc_attr_list
Message-ID: <20260922173141.GS2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120615.181988.8935770811414289563.stgit@frogsfrogsfrogs>
 <arIO9JiKf_MXBb46@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIO9JiKf_MXBb46@infradead.org>

On Mon, Sep 21, 2026 at 10:15:32PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:15:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When we converted the al_offset array in struct xfs_attrlist into a VLA,
> > the size of the object shrank by 4 bytes.  Unfortunately, the buffer
> > size validation in the attrlist ioctl wasn't updated to notice this, so
> > the al_offset[0] assignment blindly writes off the end of the buffer.
> > LOLLM noticed the omitted check and complained.  Probably should've left
> > working code alone but for everyone wanting these ***n static checkers.
> 
> It's not really static checkers, but fundamental semantics.  Arrays of
> size 1 used for VLAs always were a bad idea and should have never been
> used.

Ok I'll just delete the whole sentence.

> The fix looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
