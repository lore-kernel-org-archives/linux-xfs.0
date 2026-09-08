Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749AE33D6EA;
	Tue,  8 Sep 2026 04:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788842629; cv=none; b=O9MNOgLDMQemcuby/HWuHGw6Jcnhbx4Yinwa+UVGrjPHTQXlMWDe+oqYwaa3bkmzaxwbrT6XLGd5PdL03BMp2Pqm1zv5lND5YM36aIuwLA5sVpQHXbQd+AAhoITB3SvX10rzSCktAMPrYFpAUL5cbQBwCY7IIYmJDje+P3pB2VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788842629; c=relaxed/simple;
	bh=N7Vnqi62aWNt6Obzjp60G6gjyJXkQ6RDN0NO7zILomw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puiPy4PrXMUMoi4lmrX1nyQMb63ON+3UtK6bQFE2RSms6Jyl1M7e0gUTgT7SHB4SmDRpRVaq+wyzPGtHYslvt235mnrg6g3JNCwRkrkxjKD5UQZ3is2wfDipwPU39xefI1v5soVkJ7cQT1AvYgcfm1E6+lvekyOA9AyR/XlrL1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npiyDh2S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npiyDh2S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC4221F00A3A;
	Tue,  8 Sep 2026 04:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788842628;
	bh=FVGDBpMvowJtXD8C/9G810/mhV84GZQJMTsshBIDqDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=npiyDh2SQxKVvenlS4d0QckdEMYcxzzOKwzytMmC4X0VuGZuO3JXmkhr63ltnc/9Z
	 DvXfHL07wnWYM0aE92AD4oyLCoOwm74DfNfZjis0fm0C495yJpTgkluvqT+TpDuO5v
	 eGhOPkQcRzgU2j3/F3RFshNwKCHCGQxX7WfnA1ahfd07nwiNIjf/iO8tibu49I+xpy
	 Q29+C/VUX4VajvZ9CZBOCxxxt2i1jHt6REr63fer994+EW2AKo3g6luTcV1LXh0fB1
	 7cN0zmGnjvGS+CA+BWh2AlbqoeOCg6GQueu98eJGw9SF9L52FDLnaKWVJoy5PtmTel
	 yIkNAeP19Ravw==
Date: Mon, 7 Sep 2026 21:43:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: snapshot scrub stats when rendering them
Message-ID: <20260908044347.GA2619314@frogsfrogsfrogs>
References: <178850312462.1198660.3332635535003842521.stgit@frogsfrogsfrogs>
 <178850312518.1198660.12930219318866018921.stgit@frogsfrogsfrogs>
 <20260907055833.GA31753@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907055833.GA31753@lst.de>

On Mon, Sep 07, 2026 at 07:58:33AM +0200, Christoph Hellwig wrote:
> On Thu, Sep 03, 2026 at 11:26:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM complains about concurrency problems in the scrub stats code
> > because xchk_stats_format doesn't synchronize in any way with updates.
> > These stats are only reported through debugfs so I don't think it really
> > matters, but I guess I exist to make bots happy now.
> 
> What concurrency problem?  There should be no need to have an exact
> snapshot of all counters, so it's really READ_ONCE/WRITE_ONCE that
> are needed here I think?

Yeah, I suppose I could have gone with READ_ONCE instead of the
spinlock, but I also don't think the stats file is a hot path. :)

> Either way maybe add a comment explaining the snapshotting if we want
> to stick to it?

"Snapshot the entire stats object with a spinlock because this isn't a
hot path and we don't have to worry about users seeing slightly weird
numbers (e.g. invocations has incremented but none of the outcomes have)
if we race with xchk_stats_merge_one"?

--D
