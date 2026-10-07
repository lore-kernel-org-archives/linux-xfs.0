Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A7F3659FB
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 20:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405070; cv=none; b=avhVqr+Fd2iUU7xK9WRp9Bth7d7Tf7awAZKtMYmDCweo/3B3BWeExHUvcmKfpq1j466mHQtpje0WOvhdszW4d9Af6qyM4H+gKPd2t7zbuUuBLcUlLqwba+1KQEQJYfghJKWv2fjsF3bis/7VIJtVnOQJjJz2oNUxnTBvshaVByI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405070; c=relaxed/simple;
	bh=txtZq1JgfVhdOfJzpmwk4N8dp1rtcTLdn5xy/r2Jkho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hbprqk/T7Ai5HAI74G4C41EDU0WfUjSKgtVAwDa68kJccbQEUb6bFNu5TtLMuSe4/KvAJGz6spy6RZ0RpzSScKnB28ZSMJ4h3ovw1yRMl375kihOydLsrCu83eEWMtgyi1j3CNFtHXDU2UyIy3dvNVAmQvhohrCDLmp5vG46M7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+4touEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+4touEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7211F000FF;
	Wed,  7 Oct 2026 20:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791405069;
	bh=NuAz6y2iZHn6EOGYZ9YvsP9/0aopHrE/Wju+8Bupexk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T+4touEK3R8GwOEbKRx68a+2yRN5N7pYc6Ol0x2uzp/Fka3jFzBMJFC+JH1R9E3vC
	 LW4z9mRsWVfaAjXiG+z2VmlPVkFuBobGt7mrEdaIqKoLbDzMjTSOLyYx6ACbXBovym
	 jNNRCQn/eDjeuWTlNKnNxN4LQTkeItb+mgZA2JeP/rV/NMTj/rZkPDOFT61ZZbZRGf
	 JgD5rRGSCsyC04uiPJAi/5XGvl6pjtTQjw3+KKMGeXPar3svImqqhcOJ0jTr1Ndnr2
	 cbhA7UZg2LnCqv23OJYVMfHSnDKMyDmtGhY1F8dZr5uLrc3riLzpKiDRpTcK8VKb6E
	 PcsRAJIaeavrQ==
Date: Thu, 8 Oct 2026 07:31:01 +1100
From: Dave Chinner <dgc@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: stop exchanging reflink flags when exchanging
 mappings
Message-ID: <asasBb7Dt-6FW9E-@dread>
References: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EFFDC5C8-D154-419E-BC3E-050AD53F55F8@doyensec.com>

On Wed, Oct 07, 2026 at 04:43:22PM +0200, Norbert Szetei wrote:
> When an exchange covers both files from offset 0 to i_disk_size,
> xmi_can_exchange_reflink_flags() assumes every mapping moved and hands
> the reflink flag over to the other file.
> 
> That assumption is wrong.  A file can still own shared blocks past
> i_disk_size, e.g. after EXCHANGE_RANGE_TO_EOF sets a smaller size
> without unmapping anything.  The flag is cleared anyway, and the next
> write to such a block happens in place instead of CoW, corrupting the
> other file that shares it.
> 
> Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
> issue with INO1_WRITTEN") fixed one instance of this.  Rather than add
> another special case, stop moving the flags.
> xfs_exchmaps_ensure_reflink() already sets the flag on both inodes
> before the exchange, so both just keep it.
> 
> Nothing sets CLEAR_INO{1,2}_REFLINK anymore.  Intents logged by older
> kernels may still carry them; recovery already masks them off, so they
> stay in the log format mask and are ignored.
> 
> XFS_IOC_SWAPEXT has the same problem: it moves the reflink flag from
> one inode to the other along with the extents.  Just removing that is
> not enough here: the exchange path flags both inodes up front in
> xfs_exchmaps_ensure_reflink(), but swapext has no such step, so the
> inode receiving the shared extents would be left without the flag.
> Set it on both inodes instead, and make sure both have a CoW fork,
> since an inode with the reflink flag is expected to have one.
> 
> The flag now stays until FALLOC_FL_UNSHARE_RANGE, xfs_scrub, or a
> truncate to zero removes it.
> 
> Fixes: 966ceafc7a43 ("xfs: create deferred log items for file mapping exchanges")
> Fixes: f0bc4d134b46 ("xfs: swap inode reflink flags when swapping inode extents")
> Cc: stable@vger.kernel.org # v6.10
> Assisted-by: LLM
> Signed-off-by: Norbert Szetei <norbert@doyensec.com>
> ---
> v2: also handle XFS_IOC_SWAPEXT
> v1: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
> Discussion: https://lore.kernel.org/linux-xfs/20261006050914.GU2705364@frogsfrogsfrogs/

Agreed, this seems like the best course of action given the recurring issues
in this area.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
dgc@kernel.org
