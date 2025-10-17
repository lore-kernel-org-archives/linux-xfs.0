Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF44B2E22B5
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 23:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760742557; cv=none; b=ccJirPtT1puYvvChJpG5UzYQTRw2wkGkZzbbHqz5UHjlN14TfuJD7hOUW92T98nCH1K7+hbYXx75wMmUh8YOkQFIPhLOzsdFGgjiyfCRmzFE62jbC1DqZVgO/gLFPVtJjKGfjW8MtxrhYgwxHWztxuSK82NcGrJ47mJQUp0A0F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760742557; c=relaxed/simple;
	bh=arzKr41bIUXfNrJGM759bph95/w/1n6YHg9FwWIk6qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWyTr+pbqPttm7NjtA6prEOhc1HbcmvT6NisGcSHYpPRckevK+eNG4OdjB/ATlQ0T8he2837tYrgukBK56mtN2b68AtySVFB81YVOaw693yAfOyrlIPMglpH97bcsIchT1DGvbp+qzqM795cM1D9DjV9Rwso0onIkkuFFkBI/AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qb/9oJYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qb/9oJYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E28FC4CEE7;
	Fri, 17 Oct 2025 23:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760742557;
	bh=arzKr41bIUXfNrJGM759bph95/w/1n6YHg9FwWIk6qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qb/9oJYBhrs6oHtY4fQxh1GIOsFVVYC1ttVrgKQlgPwqJXZKA/+8Jzyrd/MLjcYFG
	 kecPKoRIRJpjiBQMvQyEgZXrgW+pBw0Xtpz5VTue0YpQLQchYJzDVpkyTVvRmHU779
	 zHDQOcO057/o4mX909C6GdikE3th0Fiy9UHjGKLxSMEbpoA2OXnMrZSC3WP4qKnxH9
	 vp5dqyAQw+8ku3+ip4F/ETJBCs8piWgHamyNZisFfL2371JGizpFVodTpxpm1JSczV
	 VXbgNgsNIQC8ui97n+5/Byis1LOmQMGhLKqCjPlZAM96TOWdjQKxtsgu9l9hp+XojG
	 ZuBYa/QPxVMXg==
Date: Fri, 17 Oct 2025 16:09:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/17] xfs: reduce ilock roundtrips in xfs_qm_vop_dqalloc
Message-ID: <20251017230916.GE3356773@frogsfrogsfrogs>
References: <20251013024851.4110053-1-hch@lst.de>
 <20251013024851.4110053-18-hch@lst.de>
 <20251015212707.GM2591640@frogsfrogsfrogs>
 <20251016042348.GC29822@lst.de>
 <20251016155941.GA3356773@frogsfrogsfrogs>
 <20251017035043.GA29428@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017035043.GA29428@lst.de>

On Fri, Oct 17, 2025 at 05:50:43AM +0200, Christoph Hellwig wrote:
> On Thu, Oct 16, 2025 at 08:59:41AM -0700, Darrick J. Wong wrote:
> > > > ...and I guess we no longer detach dquots from live inodes now, so we
> > > > really only need ILOCK_EXCL to prevent multiple threads from trying to
> > > > allocate and attach a new xfs_dquot object to the same inode, right?
> > > 
> > > Yes.
> > 
> > I wonder then, if there /were/ two threads racing to dqattach the same
> > inode, won't the radix_tree_insert return EEXIST, preventing us
> > from exposing two dquot for the same id because xfs_qm_dqget will just
> > loop again?
> 
> I think so.
> 
> > [Though looking at that xfs_qm_dqget -> xfs_qm_dqget_cache_insert ->
> > radix_tree_insert sequence, it looks like we can also restart
> > indefinitely on other errors like ENOMEM.]
> 
> Yes.  I have patches fixing that as part of moving to xarrays instead
> of radix trees.  But I suspect a resizable hash table might actually
> be the better fit, so I didn't look into submitting that quite yet.

<nod> Well if either of those are coming next then this looks ok to me.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
