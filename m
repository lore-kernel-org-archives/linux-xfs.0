Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895CB2690EC;
	Tue, 19 May 2026 14:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779202790; cv=none; b=YjDxfvIu98mgUaBrEnU9RtGgwb2nH8BdNb4bpAiTQKOrzk/XtQ8caKKmPnDKBfZ/P8DlUygw9A/MXgcb/dzjP+6PHRMpRVmftWBXD/S5QisETam/YtcHI4XP0/dnRFfljEVkwPOkZyeZDfi+ylbDSePhV9nvUhRFeysYJeI9rHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779202790; c=relaxed/simple;
	bh=eJBwjfOZxIJAwmCkYYYu+7ClYV8SZV8YtcOqLakZ4gU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N5uup1u/pHX7MD2LWBiVl7y6ONz/9K3LEROdVtSx/vHFxrjEjMoGONGma1qlfw4KNELvMdIToUalHdA+RDHWKGwsoXgTpxNS5sPm+FDSln/xOtnYyo59Q/HUtd/v6rXbO5UOiosXqks7cErqsqy7FcZX8TBbCW3FgDD8X+Pn/0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iDYcNGk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iDYcNGk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5ECC2BCB3;
	Tue, 19 May 2026 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779202790;
	bh=eJBwjfOZxIJAwmCkYYYu+7ClYV8SZV8YtcOqLakZ4gU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iDYcNGk+W87espzbLwYeIaaHULL09yJc3sXDkJ7lIeqwnuPr/GRwTWAItwECAwbmH
	 ckJyVXMakc4dgDLft1DmVqzJXKxhYc1PuGV7xAnRa2ZCDvh7frg0VlZAHcW9/cZEN0
	 cCGSkxiLjdd2Zfh12QtKMwLLRRIiF+kSsg+tO2sLfD8BlVIuJfjClHAbE3XLMTcqt0
	 1tTzizzwULWsEW8tdydOKHcoVJEUU4Vl3t0l3FG6SqhoCn1YKIxFoyRMu7mbMfJdfp
	 zsPoIEDj+ZyLRx7T7Ugg9kz8H+v8xIU91E6j3t5KD3eLx/dcPx5kt4pk2Rw6xkqovn
	 PVivVR0J+iIog==
Date: Tue, 19 May 2026 07:59:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dai Ngo <dai.ngo@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix overlapping extents returned for pNFS
 LAYOUTGET
Message-ID: <20260519145949.GH9555@frogsfrogsfrogs>
References: <961eb355-2f52-47a0-9399-e050a4e535a2@oracle.com>
 <06d9b1ae-e46f-459c-bcb4-1a5ca4ded4b0@oracle.com>
 <20260514002513.GQ9555@frogsfrogsfrogs>
 <26365a46-bdac-4e8a-a951-de904c3e5606@oracle.com>
 <ageSguSyf2kBY33a@dread>
 <b9860332-7b1e-448e-869a-ad59d8d5b7c0@oracle.com>
 <agqfBPRWXQDR2ImG@infradead.org>
 <606c4cea-70d2-4601-9db2-611cd35c3687@oracle.com>
 <agwDhixPAAA0-cTa@infradead.org>
 <55c7c22a-8edb-4833-be3f-1f6555ba90ed@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c7c22a-8edb-4833-be3f-1f6555ba90ed@oracle.com>

On Tue, May 19, 2026 at 06:44:18AM -0700, Dai Ngo wrote:
> 
> On 5/18/26 11:30 PM, Christoph Hellwig wrote:
> > On Mon, May 18, 2026 at 12:55:17PM -0700, Dai Ngo wrote:
> > > As shown, the file map changes. Entry# 7 and 8 before the NFSD calls
> > > merged into entry#7 after the calls. So there must be some activities
> > > that cause the map to change. I don't know whether the activities were
> > > triggered by NFS or something in XFS or the block device layer.
> > Hmm.  We only insert layouts (and search for conflicts) after calling
> > ->proc_layoutget.  So this might be racy against unwritten extent
> > conversion, or other writers, which is a bit of an issue.  I guess
> > we need to fix nfsd4_layoutget to insert an in-progress layout before
> > calling into ->layouget.
> 
> I can't quite see the race condition regarding layoutget here. Could you
> please explain?

/me has no idea about nfs layouts but has thoughts anyway :)

1) xfs_fs_map_blocks only takes i_rwsem and XFS_ILOCK; it doesn't take
the mmap invalidation lock.  Does that mean that pagefaults could wander
in and mess with the layout?

(I think the race that Christoph is referring to here is that any other
thread can wander in and change the mapping after a ->map_blocks call
returns, because nfs isn't holding any kind of lock on the inode)

2) Now that NFS apparently can serve up multiple mappings at once,
should ->map_blocks pass in an array element count so that we can do
multiple iomaps in a single lock cycle?

3) Do the reflink and realtime inode checks need to be re-assessed after
grabbing the ilock since they can change?

--D

> > > However, based on this data I think it's better to change the bmapi_flags
> > > from XFS_BMAPI_ENTIRE to '0' to address the overlap issue.
> > We absolutely should be doing that as I said from my first reply.
> > Still trying to understand what is going on here at a higher level,
> > though.
> 
> I'll resubmit the patch series with both fixes combined: the uninitialized
> imap handling in the error path and the replacement of XFS_BMAPI_ENTIRE
> with 0.
> 
> Thanks,
> -Dai
> 
> 
