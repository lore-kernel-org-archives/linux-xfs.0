Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF941C0DE7
	for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2024 05:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712812868; cv=none; b=nbtlwKVSQlsUxzB/XeuqWwxmOBvohYZe4yEYSBrQZSJb7lBd9bFGpOxa7qEvBLJ4OCthIsBRzHv0SXE6p4gylaJ41J7uLniBpsGEblh4/spK++SAJ+ZEwucwJXo5rL0Oq+f3wbE9mvTx7M8TiHqyeJNL2YK3wbOtyIYkDTuEmjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712812868; c=relaxed/simple;
	bh=cipB8H8S1XtgtHfwzjpOfPjybsCu+9ZB1xLodqh6IgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dTFZEHBL8ulHfRIrUqhhByuUdA8gnaxh+GdpGMcxAUenw+qks8rPs2MTIzlOrdn3XeCW3PBB7Z/2lsr2olotx9PU8H+IqQ6cX0nR9XmothBiq+I6rWGJBJa5uxXelhu7GB3KYMS90KJPSKhKLgk2rtUUG51JmbS6nSnczavDlFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PW+T57bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PW+T57bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E79C433C7;
	Thu, 11 Apr 2024 05:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712812867;
	bh=cipB8H8S1XtgtHfwzjpOfPjybsCu+9ZB1xLodqh6IgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PW+T57bNV1MAC3HA+7tfPgtuomklk44w1KCbaRhDX0doO22nA0VOxI1mdxbRxEaQ/
	 YVt0KqTvfcckRlTL+sIzsPt//qNp13VfumfPks2hCWWp8U6aLVfOTmepJcvy7WrUHP
	 0O6H/YdRemW9ttXi9jv956/cxAN9sOxGaBykNoiT0fAona+2FoiFDE+AkXLW/zZXH9
	 mxe0bQovHSmOg4pqsA47sRKkr0z+niM63wvXC9ztpObZOKjFNs6lyZP8uOKpfOQDet
	 grTKj32E22pFWSYmERigMVE+ryWx5P9JZGpVF4wzzQBSPAjcXH8tjnQ3KHyt7YZ7/z
	 uqvyFUy8hReZw==
Date: Wed, 10 Apr 2024 22:21:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] xfs: only iget the file once when doing vectored
 scrub-by-handle
Message-ID: <20240411052107.GY6390@frogsfrogsfrogs>
References: <171270972010.3634974.14825641209464509177.stgit@frogsfrogsfrogs>
 <171270972068.3634974.15204601732623547015.stgit@frogsfrogsfrogs>
 <ZhasUAuV6Ea_nvHh@infradead.org>
 <20240411011502.GR6390@frogsfrogsfrogs>
 <Zhdd01E-ZNYxAnHO@infradead.org>
 <20240411044132.GW6390@frogsfrogsfrogs>
 <ZhdsmeHfGx7WTnNn@infradead.org>
 <20240411045645.GX6390@frogsfrogsfrogs>
 <Zhdu3zJTO3d9gHLO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zhdu3zJTO3d9gHLO@infradead.org>

On Wed, Apr 10, 2024 at 10:02:23PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 10, 2024 at 09:56:45PM -0700, Darrick J. Wong wrote:
> > > Well, someone needs to own it, it's just not just ext4 but could us.
> > 
> > Er... I don't understand this?        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> If we set current->journal and take a page faul we could not just
> recurse into ext4 but into any fs including XFS.  Any everyone
> blindly dereferences is as only one fs can own it.

Well back before we ripped it out I had said that XFS should just set
current->journal to 1 to prevent memory corruption but then Jan Kara
noted that ext4 changes its behavior wrt jbd2 if it sees nonzero
current->journal.  That's why Dave dropped it entirely.

> > > > Alloc transaction -> lock rmap btree for repairs -> iscan filesystem to
> > > > find rmap records -> iget/irele.
> > > 
> > > So this is just the magic empty transaction?
> > 
> > No, that's the fully featured repair transaction that will eventually be
> > used to write/commit the new rmap tree.
> 
> That seems a bit dangerous to me.  I guess we rely on the code inside
> the transaction context to never race with unmount as lack of SB_ACTIVE
> will make the VFS ignore the dontcache flag.

That and we have an open fd to call the ioctl so any unmount will fail,
and we can't enter scrub if unmount already starte.

--D
