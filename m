Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8381F956
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 14:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753799652; cv=none; b=NUvvosrIpVqJSJk1wjqwHZeSiZL7f/njJyHiNfwIlEhobZTCj5lUhyoTOwg45hsoMEi9Pr3UhpI0TpYmZ67yRIXk5A7ShsyHy4eVsVqymc72reTI7YXvy+sgQevVsrSNTEf34tMCQVw1mMCCCeV+xqxm0KGFrSZl/yWPBjUMioU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753799652; c=relaxed/simple;
	bh=rpz0MpyDZ2wnU599ndCa0kwYHAhetQUCWOO8/LVFJWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuiT5H1SKIQ9H/RbSlcB/tfP7nTEUf0sE6UbwjhLaZUvZu4GHRQG9QCKAD3DeNU2mCJUT28XhQLVlHi16+QQE5MqwhBIzT9nWvjVkb3QEkZdS09x8ud6GsMmxsFc4FUrye0Rm3UTt4q09DCY0b0VLHp7nk+QBfw3G88SAjxB6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCJY7jyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCJY7jyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0175DC4CEEF;
	Tue, 29 Jul 2025 14:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753799652;
	bh=rpz0MpyDZ2wnU599ndCa0kwYHAhetQUCWOO8/LVFJWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZCJY7jyobVagQWDxZZ7nJ4HN8KdwKUCAVDBM6u2qx3AlQXwbqOKWkSemqOktnf2dn
	 fT/aFmokfnq+5AwFoOLYnoRELNIKTCMjGlMWnSOvXh0MK8WuAuvaa9Uz7aHSAHLnr9
	 mwgzdEx74GohriaXxRtLQp1/OyXDnDvM3cApJhjYcjjyLJjM9xd15jAA5YdabWwd3a
	 INgErsJkiHZI7duosd5va8UUCVEGNCmgTuUEtr0xDWZIH8pV50bd052UbxO3oCB2Cn
	 ap9RCm1hhSeqXR3vTInxKLbpAY6tfI9w8UpBtwxa8f5LVCwTravY9GufkAI8yM3Xs6
	 M/FEStkdHvbTg==
Date: Tue, 29 Jul 2025 07:34:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Use new syscalls to set filesystem inode attributes
 on any inode
Message-ID: <20250729143411.GA2672049@frogsfrogsfrogs>
References: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729-xfs-xattrat-v1-0-7b392eee3587@kernel.org>

On Tue, Jul 29, 2025 at 01:00:34PM +0200, Andrey Albershteyn wrote:
> With addition of new syscalls file_getattr/file_setattr allow changing
> filesystem inode attributes on special files. Fix project ID inheritance
> for special files in renames.
> 
> Cc: linux-xfs@vger.kernel.org
> 
> ---
> Darrick, I left your reviewed-by tags, as the code didn't changed, I just
> updated the commit messages. Let me know if you have any new feedback on
> this.

It all looks ok except for s/(file| )extended attribute/fileattr/

Seeing as the VFS part just went in for 6.17 this should probably get
merged soonish, right?

--D

> ---
> Andrey Albershteyn (3):
>       xfs: allow renames of project-less inodes
>       xfs: allow setting xattrs on special files
>       xfs: add .fileattr_set and fileattr_get callbacks for symlinks
> 
>  fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_ioctl.c |  6 -----
>  fs/xfs/xfs_iops.c  |  2 ++
>  3 files changed, 36 insertions(+), 36 deletions(-)
> ---
> base-commit: 86aa721820952b793a12fc6e5a01734186c0c238
> change-id: 20250320-xfs-xattrat-b31a9f5ed284
> 
> Best regards,
> -- 
> Andrey Albershteyn <aalbersh@kernel.org>
> 
> 
