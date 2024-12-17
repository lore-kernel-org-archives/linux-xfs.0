Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E282150994
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734469021; cv=none; b=m2WtMCbDNazDwrRDMU9IU3CM+jRkIMyAajBz/dkpLs+2Z2wBaeIT+GqcbLEnhF0zvYmOzhwLJEIlEFrFbv5T1n4xEw/lpChbj/5hFyvmbMZLfwPZHWi02ZEXpxMHkM+j3RGN5zoBycW4BBXKGWM+e2D5h4Y2eZH6ABhRMg0sJkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734469021; c=relaxed/simple;
	bh=GSwamYUsHQJubNVoCiWnBw0IUxOVZnyNRBBv9YAYIiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3TzTIxhCm+mAK/dJKwieNs2Xq8gBGvR9VxtHVb/sZ4s6Gm8bp9nz2HlGHaglr1rugLPFSO6qDOyqFOkRkekXHIyJInuQViPlWcuGZ7EeZitDLjrnzSXHO1gMMbG02BkR/Sus/fCTsDCwZP1795vw0ZYNEBDHQX4fKa7EdcmgZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nin4F4pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nin4F4pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ED5C4CED3;
	Tue, 17 Dec 2024 20:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734469020;
	bh=GSwamYUsHQJubNVoCiWnBw0IUxOVZnyNRBBv9YAYIiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nin4F4pO1jBnjTl+ID0Kq0xIcsHEec/CMjpb2hBD4Xw7KSRtyo+7l6EOKcec3JeDl
	 smfBK64UG9LrfQAJxb9FNa5XDR6jPYlzvG6OC3KEr4o6sbonp5CKj66vSmhZ/CcaMC
	 RHIeFzqIZX/fmttierksvaYVX6Cy6yuTvT5F1AFkpZSc35lfPOK6q6negGb8VPcl/J
	 4oPD5iLSJz+r1b8MWOTFtAiQwze1SzxSrlEu7Furts7OdeM0PiF7kJuYUX3BeQnE+e
	 rJ4Iz7PzdGOWyTzrrEo+WQQ2G04rHzzprLwv9CDJtB/BgLYRUKVX1ucBnY8i8G2+Y0
	 mHcySO3J/6jPg==
Date: Tue, 17 Dec 2024 12:57:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 43/43] xfs: enable realtime reflink
Message-ID: <20241217205700.GW6174@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125304.1182620.11655711195171869232.stgit@frogsfrogsfrogs>
 <Z1v9nl9DP4N_1mNQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1v9nl9DP4N_1mNQ@infradead.org>

On Fri, Dec 13, 2024 at 01:25:50AM -0800, Christoph Hellwig wrote:
> > -		if (xfs_globals.always_cow) {
> > +		/*
> > +		 * always-cow mode is not supported on filesystems with rt
> > +		 * extent sizes larger than a single block because we'd have
> > +		 * to perform write-around for unaligned writes because remap
> > +		 * requests must be aligned to an rt extent.
> > +		 */
> > +		if (xfs_globals.always_cow &&
> > +		    (!xfs_has_realtime(mp) || mp->m_sb.sb_rextsize == 1)) {
> 
> This looks unrelated to the rest of the patch, or am I missing
> something?

Yeah, this belongs in the next series.

--D
