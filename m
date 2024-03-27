Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537605227
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562761; cv=none; b=nll1nCBIc4XIfA4p2xcJ63VYtA1vpaHuV55MtOVp3j888G8gc27RBYjpoCUIhzLHhe5lR4mcsdhfr0SpV/kGWv4WmsuqHSGL+avpvjKtYY7do7ci/DDq+0v8dqgboqYLlhuWTCvC/C6mJOoeAjx30nvt6vL1LqzMWCg/D/xqV/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562761; c=relaxed/simple;
	bh=36RdiE2s7IE7YxPLlY5N7tA9oYOe/DDZxGuuGosQ9DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXedkW9XHU8uFNPMDTcWv8e0XCaWaVrHqsvmKjh2MRJwQyYCC0CDDT03O0ICVE/HrCt8JKDausxoPpwFATAuPjqmiZaCnNfXVk+42iyp2Q0urki0Qs6XilL9ueanO2C2xYCVYnOCZL7fGh+gE8PvTxB5LKtbpEEb/l0UOHLOvI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWuM4JhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWuM4JhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE84C43390;
	Wed, 27 Mar 2024 18:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711562760;
	bh=36RdiE2s7IE7YxPLlY5N7tA9oYOe/DDZxGuuGosQ9DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWuM4JhYgmmpGRe48J/v5E7A+s+lJACMuOBpjFYZMBcjWyDQOFRfORsgTjzF6AKbe
	 QS51Ftsz7nTzy1zT74H2U0UfXxROgOzSaxWMySm+cyqTDQcjipVMozkZZkwak1RHF2
	 kTneCHsBIP37w4zF+AY3tOsMloU55q9om2MrqlCCw/azqI0HgO3PUngQETkmYknxC7
	 vFj2lycxJCIX/I3rxmchMZ34PM6oS6wVHLnHGHRa0eZt9YjDxRjrLhgxxpp/2nZSNv
	 HPX2LlYLwG4IgYwpeOdg6EhHBNmBYXirYc8Lvz1nZ2XaRRz3nd23gWxWAQSOsAypvu
	 4ll/llGPSANRg==
Date: Wed, 27 Mar 2024 11:06:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: move RT inode locking out of __xfs_bunmapi
Message-ID: <20240327180600.GC6390@frogsfrogsfrogs>
References: <20240327110318.2776850-1-hch@lst.de>
 <20240327110318.2776850-5-hch@lst.de>
 <20240327150755.GX6390@frogsfrogsfrogs>
 <20240327170632.GC32019@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327170632.GC32019@lst.de>

On Wed, Mar 27, 2024 at 06:06:32PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 27, 2024 at 08:07:55AM -0700, Darrick J. Wong wrote:
> > How does it happen that xfs_rtfree_blocks gets called more than once in
> > the same transaction?  Is that simply the effect of xfs_bunmapi_range
> > and xfs_unmap_exten calling __xfs_bunmapi with
> > nextents == XFS_ITRUNC_MAX_EXTENTS==2?
> 
> Yes.
> 
> > What if we simply didn't unmap multiple extents per bunmapi call for
> > realtime files?  Would that eliminate the need for
> > XFS_TRANS_RTBITMAP_LOCKED?
> 
> Probably.  Not that I really want to rock that boat now when we'll
> also have the extent free item / defer ops based path soon.

<nod> I think once we get to the rtgroups patchset then all we have to
do in __xfs_bunmapi is:

	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK &&
	    !xfs_has_rtgroups(mp))
		nexts = 1;

and then the XFS_TRANS_RTBITMAP_LOCKED flag can go away?

If so, then
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
