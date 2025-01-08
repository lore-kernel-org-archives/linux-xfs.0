Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9036FC5
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jan 2025 00:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736296327; cv=none; b=jv/kPqVqbAfMyXFwZSdjbHji4TdiDOhQAS2Qc7NJJCZtUJPLn4Lnr2SsyU51pcMuckQDdcbG8grVuU9xjxVCtxVMctIlqRe8jQFJfoWyfZ0p5C3kcZIyy+tMl2M0WFN6MWoLC9WFm6uG2RD3D8yV50ysUOfoLclbWt7Untvd4T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736296327; c=relaxed/simple;
	bh=S83J4rPQxYgKnpDALReNsd7lh/F12yDHCHlD53xzR18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsLH7OcFtF5ow8FXEI9Gi5ID0Mv1KvNoVK4S0KD9Zcqcw5oIVvuKvJoYa+LnYtI204rGnGmrcqaZIdGg+xqsnB8XNI6DlL8BLJLNRh5P7NQdWLeZYdmpvmmDXyHNA5gVddp7Gdst0h2TicSk6jRiY8FjrVoUP/KSPNiGix4M6KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzzkdFaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzzkdFaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF21C4CED6;
	Wed,  8 Jan 2025 00:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736296327;
	bh=S83J4rPQxYgKnpDALReNsd7lh/F12yDHCHlD53xzR18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uzzkdFaHRXM+jT0FSPQCsQqLzrGPXnHz2mAeDg+XJTSxQDGHQ28o6zCPuyPGTTS43
	 1qdwqdrQLhJLhCPNohgYG88ybr2253ysSXoqWypZP+Zc5WmUBbikmy6aQvgdC0WakZ
	 Ur3RQ/2T1fGnMllGGkph5mqVjEi81ZeJtrRjWDf2XXBejmF2so/Zpb2UimL/rYtFoC
	 jofTJOWON3e+eNLsQ3oIL+AjDiTupYEhbisRi065f/EQCr1iq6uzAfGKYtgP3M+afz
	 hYtsCiivXylK6fDivNl2++3BZ90c863xrvpJoYLB5xSQa7hwLvtYaXo8CmufYMKfJz
	 Shd2x5m6NBX1g==
Date: Tue, 7 Jan 2025 16:32:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: correct the sb_rgcount when the disk not
 support rt volume
Message-ID: <20250108003206.GL6174@frogsfrogsfrogs>
References: <20241231023423.656128-1-leo.lilong@huawei.com>
 <20241231023423.656128-2-leo.lilong@huawei.com>
 <20250106195220.GK6174@frogsfrogsfrogs>
 <Z30n-9IusvggTuwP@localhost.localdomain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z30n-9IusvggTuwP@localhost.localdomain>

On Tue, Jan 07, 2025 at 09:11:23PM +0800, Long Li wrote:
> On Mon, Jan 06, 2025 at 11:52:20AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 31, 2024 at 10:34:22AM +0800, Long Li wrote:
> > > When mounting an xfs disk that incompat with metadir and has no realtime
> > > subvolume, if CONFIG_XFS_RT is not enabled in the kernel, the mount will
> > > fail. During superblock log recovery, since mp->m_sb.sb_rgcount is greater
> > > than 0, updating the last rtag in-core is required, however, without
> > > CONFIG_XFS_RT enabled, xfs_update_last_rtgroup_size() always returns
> > > -EOPNOTSUPP, leading to mount failure.
> > 
> > Didn't we fix the xfs_update_last_rtgroup_size stub to return 0?
> > 
> > --D
> 
> Indeed, when CONFIG_XFS_RT is not enabled, xfs_update_last_rtgroup_size() should
> return 0, as returning an error is meaningless.
> 
> 1) For kernels without CONFIG_XFS_RT, mounting an image with realtime subvolume will
> fail at xfs_rtmount_init().
> 
> 2) For kernels without CONFIG_XFS_RT, mounting an image without realtime subvolume
> should succeed.
> 
> However, in the current scenario, should sb_rgcount be initialized to 0 ? it will 
> consistent with metadir feature is enabled. The xfs-documentation [1] describes 
> sb_rgcount as follows:
> 
> "Count of realtime groups in the filesystem, if the XFS_SB_FEAT_RO_INCOMPAT_METADIR
> feature is enabled. If no realtime subvolume exists, this value will be zero."
> 
> [1] https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/design/XFS_Filesystem_Structure/superblock.asciidoc

Ah, I see your point finally -- if there's no realtime section, then
there's no need to allocate any incore rtgroups, nor is there any point
to set sb_rgcount==1.

That said, I think the correct tags here are:
Cc: <stable@vger.kernel.org> # v6.13-rc1
Fixes: 96768e91511bfc ("xfs: define the format of rt groups")

because 96768e91511bfc is the commit that actually added "to->sb_rgcount
= 1;".

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> Thanks,
> Long Li
> 
> > 
> > > Initializing sb_rgcount as 1 is incorrect in this scenario. If no
> > > realtime subvolume exists, the value of sb_rgcount should be set
> > > to zero. Fix it by initializing sb_rgcount based on the actual number
> > > of realtime blocks.
> > > 
> > > Fixes: 87fe4c34a383 ("xfs: create incore realtime group structures")
> > > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_sb.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > > index 3b5623611eba..1ea28f04b75a 100644
> > > --- a/fs/xfs/libxfs/xfs_sb.c
> > > +++ b/fs/xfs/libxfs/xfs_sb.c
> > > @@ -830,7 +830,7 @@ __xfs_sb_from_disk(
> > >  		to->sb_rsumino = NULLFSINO;
> > >  	} else {
> > >  		to->sb_metadirino = NULLFSINO;
> > > -		to->sb_rgcount = 1;
> > > +		to->sb_rgcount = to->sb_rblocks > 0 ? 1 : 0;
> > >  		to->sb_rgextents = 0;
> > >  	}
> > >  }
> > > -- 
> > > 2.39.2
> > > 
> > > 
> > 
> 
