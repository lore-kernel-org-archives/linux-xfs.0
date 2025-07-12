Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC072A8C1;
	Sat, 12 Jul 2025 05:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752299789; cv=none; b=KTfxu2SLEJVLbUpE5usB116Rl3R++tOPqAfbXnzNHVAZQv9bOU6gPQ9Nfc+qTgLOHtkDc5AWvLY0g3ZYHasSgFLAqzAP/Zcmfwj2IZD/2GnVs6EwzwaEWd79DPjUaU6H9x4iaJN8FRZmB2z+xUDkrdEhM8hB6KMN1ihf+mQxhwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752299789; c=relaxed/simple;
	bh=uapeozIqCcHcIFbe23O5ok6CMllk+sF8R82s17ZXmeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lf2yc8K6bRoTxKoS52G1Eh3behvi5mUFkZDMRE8RtvT/gfdo98ZF9oH4OFGthlruKw/nRumDRrONY3gfiGNYShJ/8U9aOhyzKcDp0Ub9C8M7wI6t0eS5A2t3vC5s7K+vwZuWsUW777MpAFigeYBcKymrHTOTCgq1ec5+nTYM+dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogUANSJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogUANSJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7405EC4CEEF;
	Sat, 12 Jul 2025 05:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752299788;
	bh=uapeozIqCcHcIFbe23O5ok6CMllk+sF8R82s17ZXmeg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ogUANSJfPJ7b0L2/M31bUCIHUKW5Xjb0McphK8qwrcbUwGIroVAotdKsitZdBbrfl
	 pjRyNnKsmsPntc1HpPbCXGJTtwUBVHAv4leSLTHvCGt4LFszljOJJFBU/3gPvuEMGM
	 uVmahhve3+2ZX/RnD8lmQiGs2IzPohuaRFGS+y82HHjLHj/ucycrEET6moLHcs0R8p
	 oGC0W9qtPw9ndBa4DoglB2uyUaPcqG44Q/H0ZJqp+6k3wk66cVoqBEDow4p9n6Mmdf
	 tX7IrTzY9KIjTb+Eea8D6ogP80Xr7638zJtRPQxUHeDTa35Z0y9NNp/pMg8OsNklW2
	 eNC2J4g+dFTQA==
Date: Fri, 11 Jul 2025 22:56:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, cem@kernel.org,
	skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH v2] fs/xfs: replace strncpy with memtostr_pad()
Message-ID: <20250712055627.GJ2672049@frogsfrogsfrogs>
References: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
 <CAH4c4jLCyb3kF0G25GU2JpPVkOXrgMTtMF+NTWgJpXBoEUaA5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH4c4jLCyb3kF0G25GU2JpPVkOXrgMTtMF+NTWgJpXBoEUaA5w@mail.gmail.com>

On Thu, Jul 10, 2025 at 03:56:01PM +0530, Pranav Tyagi wrote:
> On Fri, Jul 4, 2025 at 3:42 PM Pranav Tyagi <pranav.tyagi03@gmail.com> wrote:
> >
> > Replace the deprecated strncpy() with memtostr_pad(). This also avoids
> > the need for separate zeroing using memset(). Mark sb_fname buffer with
> > __nonstring as its size is XFSLABEL_MAX and so no terminating NULL for
> > sb_fname.
> >
> > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h | 2 +-
> >  fs/xfs/xfs_ioctl.c         | 3 +--
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 9566a7623365..779dac59b1f3 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -112,7 +112,7 @@ typedef struct xfs_sb {
> >         uint16_t        sb_sectsize;    /* volume sector size, bytes */
> >         uint16_t        sb_inodesize;   /* inode size, bytes */
> >         uint16_t        sb_inopblock;   /* inodes per block */
> > -       char            sb_fname[XFSLABEL_MAX]; /* file system name */
> > +       char            sb_fname[XFSLABEL_MAX] __nonstring; /* file system name */
> >         uint8_t         sb_blocklog;    /* log2 of sb_blocksize */
> >         uint8_t         sb_sectlog;     /* log2 of sb_sectsize */
> >         uint8_t         sb_inodelog;    /* log2 of sb_inodesize */
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index d250f7f74e3b..c3e8c5c1084f 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -990,9 +990,8 @@ xfs_ioc_getlabel(
> >         BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
> >
> >         /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> > -       memset(label, 0, sizeof(label));
> >         spin_lock(&mp->m_sb_lock);
> > -       strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> > +       memtostr_pad(label, sbp->sb_fname);
> >         spin_unlock(&mp->m_sb_lock);
> >
> >         if (copy_to_user(user_label, label, sizeof(label)))
> > --
> > 2.49.0
> >
> Hi,
> 
> This is a gentle follow-up on this patch. I would like to
> know if there is any update on its state.

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Regards
> Pranav Tyagi
> 
