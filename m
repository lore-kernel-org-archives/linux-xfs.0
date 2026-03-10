Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79892D73B9
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 14:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153497; cv=none; b=BhYs1DyKKBySngTC/udaUKVepZE3fr6eKRBEjerVL0t2qqumDO29T/BMtiCK6O5jDPARsww+GQ6JmgPOuOp7CQKH2TIo5ZchkFejMEqZ5cehoH8xd1DlNhX1qzIWrr/oZTVu4d4hqoWPXI+WY5Sn6c8LiacL9yDVQb1FUuoIB/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153497; c=relaxed/simple;
	bh=817l3tQYvnUDBtKklD0q1yTzF78rY+RqX9ZAtaF2TP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uyUBaNwyQn6JXFB2lcf1Ab0+qeLHvDUo7XwDswN7J9nWBn46GR7FxG6fqhDRkQwASmxLZi6NfvYfeMEjvvOV7bhekz69kYxCCIQArVpr1j5t5Suq8nno+sihs9ss2wVolpJuGsZDrmRpm00iDODHnkQBSZke0dh5yi0ymmvb0/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzC4g7Fd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzC4g7Fd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B16C19423;
	Tue, 10 Mar 2026 14:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773153497;
	bh=817l3tQYvnUDBtKklD0q1yTzF78rY+RqX9ZAtaF2TP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YzC4g7FdtDpUEwQRUiHG8mv/llriYRSTWnsbbWOG6aMl4eRve9wSRwOk1vMypoIeb
	 wfpzeSff+ODCZvh6CIRCrZkOsWZZNd1YNeTK2sMp+tgBJXjfovBafWk3n3GXVKwC+p
	 QC10DDgslf73VxHQFKXUZm2fz05sOYLsJ1k7GZ2f8jrYCBAqbZuPRv3QPL8tjYdCip
	 jioMq944eAw+TjwQmBSiEEA1UTApLT4WzlnqERY51AVg/OrKhO/6kgkHrrpu6pQJw7
	 P4140tGCZ+ZfqnrujzxOn88JnVezC2hYCVq5zN2tcSl4MjLW7pmk9LW5rI7yDg/5MJ
	 abEBepb4iw4WA==
Date: Tue, 10 Mar 2026 07:38:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 2/4] xfs: factor out xfs_da3_node_entry_remove
Message-ID: <20260310143816.GJ1105363@frogsfrogsfrogs>
References: <20260309082752.2039861-1-leo.lilong@huawei.com>
 <20260309082752.2039861-3-leo.lilong@huawei.com>
 <20260309164229.GI6033@frogsfrogsfrogs>
 <abAHX977xcOEaqRM@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abAHX977xcOEaqRM@localhost.localdomain>

On Tue, Mar 10, 2026 at 07:58:23PM +0800, Long Li wrote:
> On Mon, Mar 09, 2026 at 09:42:29AM -0700, Darrick J. Wong wrote:
> > 
> > > +	__xfs_da3_node_remove(state->args->trans, state->args->dp,
> > > +			state->args->geo, drop_blk);
> > > +}
> > > +
> > > +/*
> > > + * Remove an entry from a node at the specified index, this is an exported
> > > + * wrapper for removing entries from intermediate nodes.
> > > + */
> > > +void
> > > +xfs_da3_node_entry_remove(
> > 
> > This only applies to attr(ibute) structures, as evidenced by m_attr_geo
> > below.  I think this ought to be named xfs_attr3_node_entry_remove.
> > 
> 
> Considering that xfs_da_btree.c implements functions related to xfs_da*, 
> it might not be appropriate to place xfs_attr3_node_entry_remove here either.
> I think we could add an additional `struct xfs_da_geometry *geo` parameter
> to xfs_da3_node_entry_remove() and let it be specified externally, which
> would increase the function's generality. What do you think?

Why does it need to be general?  Don't go adding code for a user
(directories) that doesn't exist.

--D

> 
> Thanks,
> Long Li
> 
