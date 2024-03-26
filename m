Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F51C6B9
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 16:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711470607; cv=none; b=Xwkg0IcqtDnsi4sGLM7VutJ1596LD8FDlJP334aWmzEOeWmfF8XP0knaxV7LNrcGqG9enLVIo5E5fRMbCppveEYvQLvr4DFTAvujs8OkaPGz0pWradLxvChgb4RfPpZhIpgOKmuw5g/yacfxbcaHG86Q0BEP1lwdiikH6qPvFUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711470607; c=relaxed/simple;
	bh=9wIeCIeo+JeMhkBCWPlWRG0oOrmRr4FM8bfWOUzOqQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DT3PScUbYgLwXuuhmHSUNinZTzGg841R7U57Dtg4v1QftB+FafUWcx/zS7akD53wJfnjfh8l7fhAVMyMUuduEE6HFeKbvzsr7p9VOm3xNUBSIcDGrgS7FCf5Z7fCPibam85Tg5/YfCGEt4urgyDT14fwQSN2r9YdxB0OZXftW1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s0zzSUMu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s0zzSUMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F51C43399;
	Tue, 26 Mar 2024 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711470607;
	bh=9wIeCIeo+JeMhkBCWPlWRG0oOrmRr4FM8bfWOUzOqQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s0zzSUMulYp5tEFqK3Xyi7K0+rwpIjoMnFXOQXnRDjVdgdcCCNsAx4pEOSvfpmokx
	 C1FOq76AbM0KgWVAY03B/bOEFyF/ToXTQI8otCcXIxF72qrbzIoUzK3jKlvibBOceB
	 8o4W36OLDFO/Xm/RP9axKRbWHMXCCsbWlILlF28wpoyTrJpvNjerandM/ZUZTQeVSS
	 2e7qxD2b7rEixInHQ0QeQPvGVzYjU7OxtB8esZPqnEruPiUs8Kgbik7Mpm6jQN0x0/
	 k9KGOvG+b9fFnmdyTPvlAGpo7wHhl8108IZJVGHPlM0iSx6g7Qb693rX+DveN11CH1
	 hUo8AdDCWnT1Q==
Date: Tue, 26 Mar 2024 09:30:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_scrub: fix threadcount estimates for phase 6
Message-ID: <20240326163006.GJ6390@frogsfrogsfrogs>
References: <171142128559.2214086.13647333402538596.stgit@frogsfrogsfrogs>
 <171142128608.2214086.995178391368862173.stgit@frogsfrogsfrogs>
 <ZgJZ5t7hoeckBmig@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgJZ5t7hoeckBmig@infradead.org>

On Mon, Mar 25, 2024 at 10:15:18PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 08:21:37PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a filesystem has a realtime device or an external log device, the
> > media scan can start up a separate readverify controller (and workqueue)
> > to handle that.  Each of those controllers can call progress_add, so we
> > need to bump up nr_threads so that the progress reports controller knows
> > to make its ptvar big enough to handle all these threads.
> 
> Maybe add a comment to the code stating this?

	/*
	 * Each read-verify pool starts a thread pool, and each worker thread
	 * can contribute to the progress counter.  Hence we need to set
	 * nr_threads appropriately to handle that many threads.
	 */
	*nr_threads = disk_heads(ctx->datadev);
	if (ctx->rtdev)
		*nr_threads += disk_heads(ctx->rtdev);
	if (ctx->logdev)
		*nr_threads += disk_heads(ctx->logdev);

--D
