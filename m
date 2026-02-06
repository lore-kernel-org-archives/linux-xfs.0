Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA03EBF19;
	Fri,  6 Feb 2026 04:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770353206; cv=none; b=VKtzm9yoS/ibqdNz1p4BmE3aqHa2HS+nLjcJ/m4FWX08VlvdzByEcLuCiyilSOaRqacnPBUX5UQbznLidgDqtJMCYEOVWyy8CUV1dMWXN69es4a4FysKM7Ynbw6Trk4z58E2xvF2d9SPTncezNqW/+hVt/R0u91//TzK0eDTd20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770353206; c=relaxed/simple;
	bh=3wyrS6FuHzMi0+gcu8RfA1Uj4G7edrBpeSx7MqKTXc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFiqBiHq95pRONSqHfO9JnK5dJx55ZcgfTmO2WHahsCTadPTNDi4ZFrCQX/atonktMMMHANBRAEbxswRUWtgFknIjVtIIJPrATYJjX88bR04ZtKOvqtKZS8KljdJVxgJS5tyb62GO76tMh0l19a3zAO/+D8u3XFi96LlyV1on4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gb0hV1/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gb0hV1/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8686C116C6;
	Fri,  6 Feb 2026 04:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770353205;
	bh=3wyrS6FuHzMi0+gcu8RfA1Uj4G7edrBpeSx7MqKTXc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gb0hV1/2aS4cm+FFVdaFLDw82LwMIn15ByAImVqGV/EmXaq1YC99V5YDtygkhEgbE
	 wXANfGHqz39YEnOYDCjXev6WmJ6Dn0RxkECibf5B/Sqlvqh5oW7ZlL0YK9rG3KSO03
	 rfnwjbBht1vdJL2nYXdcJj/gSrfy5PCNkwYjvthR6RF8Y1y31DUeAVy4xhx/mO/eQY
	 jRYleYWKz++PjArgHMKffQTojav69bI+hkYUrv3g6UMeOZ9kagGRtZDdM7tqk8AbbZ
	 036WeX8Ic3Y1qqSpaLEpq/6xuZ1TEBtWjf3D3CYEDE/mHePD12Yynk3dLYpGVN75S9
	 c+OljczaNLADQ==
Date: Thu, 5 Feb 2026 20:46:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chris Mason <clm@meta.com>
Cc: cem@kernel.org, r772577952@gmail.com, stable@vger.kernel.org,
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: only call xf{array,blob}_destroy if we have a
 valid pointer
Message-ID: <20260206044645.GT7712@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
 <176897723586.207608.15038929489815852871.stgit@frogsfrogsfrogs>
 <20260205194211.2307232-1-clm@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205194211.2307232-1-clm@meta.com>

On Thu, Feb 05, 2026 at 11:40:27AM -0800, Chris Mason wrote:
> "Darrick J. Wong" <djwong@kernel.org> wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Only call the xfarray and xfblob destructor if we have a valid pointer,
> > and be sure to null out that pointer afterwards.  Note that this patch
> > fixes a large number of commits, most of which were merged between 6.9
> > and 6.10.
> 
> Hi everyone,
> 
> I'm trying out my AI review prompts on a few more trees, and I ran it
> on the fuse-iomap-cache branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=fuse-iomap-cache
> 
> This was the latest email lore could find, apologies if I grabbed the wrong one.
> 
> Hopefully the review below is useful, please let me know if there are places it
> has gone wildly wrong.  I kept the header to make it obvious exactly which
> commit I'd run through.
> 
> I was really going for the fuse patches, but this ended up in my git
> rev-list output, and it looks valid to me:
> 
> commit 1e4e64674c788423e24610612e4981eb1dc9b28b
> Author: Darrick J. Wong <djwong@kernel.org>
> 
> xfs: only call xf{array,blob}_destroy if we have a valid pointer
> 
> This patch adds null pointer checks before calling xfarray_destroy and
> xfblob_destroy functions across multiple XFS scrub/repair teardown
> functions, and nulls out the pointers afterwards to prevent dangling
> pointer issues.
> 
> Cc: r772577952@gmail.com
> Cc: <stable@vger.kernel.org> # v6.12
> Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
> 
> > diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> > index a2f6a7f71d839..6e3fef36d6614 100644
> > --- a/fs/xfs/scrub/agheader_repair.c
> > +++ b/fs/xfs/scrub/agheader_repair.c
> 
> [ ... ]
> 
> > diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
> > index 7a21b688a4715..d5a55eabf6801 100644
> > --- a/fs/xfs/scrub/dir_repair.c
> > +++ b/fs/xfs/scrub/dir_repair.c
> > @@ -172,8 +172,12 @@ xrep_dir_teardown(
> >  	struct xrep_dir		*rd = sc->buf;
> >
> >  	xrep_findparent_scan_teardown(&rd->pscan);
> > -	xfblob_destroy(rd->dir_names);
> > -	xfarray_destroy(rd->dir_entries);
> > +	if (rd->dir_names)
> > +		xfblob_destroy(rd->dir_names);
> > +	rd->dir_names = NULL;
> > +	if (rd->dir_entries)
> > +		xfarray_destroy(rd->dir_entries);
> > +	rd->dir_names = NULL;
>                  ^^^^^^^^^^
> 
> In xrep_dir_teardown, after destroying rd->dir_entries, the code sets
> rd->dir_names = NULL instead of rd->dir_entries = NULL. This leaves
> dir_entries as a dangling pointer after the xfarray is freed.
> 
> The commit message states the patch should "be sure to null out that
> pointer afterwards", and the pattern in xrep_agi_buf_cleanup correctly
> nulls both iunlink_prev and iunlink_next pointers. This change should
> null both dir_names (line 177) and dir_entries (line 180), but line 180
> incorrectly nulls dir_names again.
> 
> Shouldn't line 180 be rd->dir_entries = NULL?

Yep.  Will fix this.

> [ ... ]
> 
> > Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
> 
> The existing Fixes: tag points to commit ab97f4b1c03075, but this is not
> the first commit that introduced the bug. The bug was first introduced by
> commit f1184081ac97 ("xfs: teach scrub to check file nlinks") on
> 2024-02-22, which unconditionally called xfarray_destroy without checking
> for NULL pointers. The commit ab97f4b1c03075 (2024-04-15) is one of
> several later commits that perpetuated the same bug pattern.
> 
> Should the Fixes: tag reference f1184081ac97 instead?

Strictly speaking there should have been separate patches for each of
the files fixed in this patch, but I went with the more recent commit
which was introduced in 6.12 rather than the oldest commit from 6.9
because only 6.12 is receiving fixes anyway.

--D
