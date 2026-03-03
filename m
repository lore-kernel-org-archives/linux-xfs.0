Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29455361674
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772558815; cv=none; b=bbysVRTFAxvSMsZkyUG6oibTCkl/j7epnpp0BCQlZLS2J6kk+4KTFstOqlAgy+/ak3EPhVQ56VjzNHGJzv1jH0Ki4pnNkQrH5zHeGYnkl3oo/7Ge0Ln6/eDfpf96ECDxggJDwyyvunzT1Sqrvh50ggyRh0jsmRwK/1JJZSIF3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772558815; c=relaxed/simple;
	bh=eql2MW2eNSlCcogBDzo5/yEcx/DC2EvM1WceOK5gU5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ip0xMRXSd98i2MIMumxgFGroLit2cu+q80gPbTwSWE3k+oVXxUHKIgetpibj8kDboX2LbjkF52CurBgF12c7OhYc6eaeOkCsQ6StnmynRoPemzu7du60Ply88RpCsnQf91vZqOMYnN+K4tiXUavXRZS/8cQlEFjVpd4tw7u02NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E76Qe3K2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E76Qe3K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A8C116C6;
	Tue,  3 Mar 2026 17:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772558814;
	bh=eql2MW2eNSlCcogBDzo5/yEcx/DC2EvM1WceOK5gU5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E76Qe3K20Gil6p779G4p03JhRpdWDcAYpLgXCVsX0qwfcD2mV+gqglslke3ZQet2s
	 iVlwQFZb/t+hNCTIoLUHqZRleU2JeZyXCd6uekhD5UUtxpagBlMdZXGbr3lPYhDx1M
	 nSDQBX/cQkhcnZ7XU31QdvoqPJsiwtdO3tO0668Jcf4e8HlF13CqUxkXo4Fr4Kd/Zm
	 +r2zyAYOIN+AgEipaEFuqrh/e/N0lc+ZYT7bIbqYWdnhcX20uPOzT1ZMcPveOMBQoB
	 PyZLROrBWEsMeFzrC+jfXOH8jDi8G6T/nwf98bMEn76zAMpoNP1IVyIG609qFLNvQ6
	 RkB7/H+5wBqUg==
Date: Tue, 3 Mar 2026 09:26:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/26] xfs_healer: use getmntent to find moved filesystems
Message-ID: <20260303172654.GQ57948@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783601.482027.9121579371607325115.stgit@frogsfrogsfrogs>
 <aacDkSiRLgD1k3Tg@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aacDkSiRLgD1k3Tg@infradead.org>

On Tue, Mar 03, 2026 at 07:51:45AM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> but in a way just grabing a weak handle at mount time and never
> dropping it would seem more useful?

Er... that /is/ what xfs_healer does -- it opens the rootdir, creates
the weakhandle, the weakhandle makes a copy of the rootdir handle, and
then xfs_healer closes the rootdir fd.

Later when xfs_healer needs to do a repair, it asks the weakhandle to
reopen the old mountpoint path, compare that fd's handle to the sample
in the weakhandle, and tell us if the fd matches.

Or did you mean that xfs_healer should keep the rootdir fd open for the
duration of its existence, that way weakhandle reconnection is trivial?

[from the next patch]

> > When xfs_healer reopens a mountpoint to perform a repair, it should
> > validate that the opened fd points to a file on the same filesystem as
> > the one being monitored.
> 
> .. and if we'd always keep the week handle around we would not need
> this?

The trouble with keeping the rootdir fd around is that now we pin the
mount and nobody can unmount the disk until they manually kill
xfs_healer.  IOWs, struct weakhandle is basically a wrapper around
struct xfs_handle with some cleverness to avoid maintaining an open fd
to the xfs filesystem when it's not needed.

(As opposed to libhandle, which maintains an open fd to the xfs
filesystem until you kill the program.)

<shrug> I might not be understanding the questions though.

--D
