Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BEB22CBEC;
	Tue, 15 Jul 2025 08:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752568893; cv=none; b=szHfKoaCn3eC0EqVTl87y1F/zuafDaVBi/8aKCziZbYEIZNbicdWwSWbgZS4tZOrW7B2+x6nfGw3kQ9CNB5u3FF8od5No24YINLQH081Pf/9vaj+THairL7M9dy5uFkL8pfaX+GIfYGOh2hCruNdr6Y91xtr3NawvvOPO8aOe+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752568893; c=relaxed/simple;
	bh=it5bcb7P/86igKa4ZM+4PpjhFToNWvbyGywblQFSY8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fL9/O7SyGVg0Dh2YiTQzSAacOuu2V43vZ4adZqA/tn/XuPqbhiFcgr+MMT8usYtA5cQ0YnAQ45v8G+6wCXf4aztugDVLeXQOcULfkmndA8RFVVWxdsJfkhLvmI6RKyz3x11c2W0kpTzxS1VNdAzLuHqpvY+Z1nrKgn1qCSCZExc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHdhSE0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHdhSE0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B03C4CEE3;
	Tue, 15 Jul 2025 08:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752568893;
	bh=it5bcb7P/86igKa4ZM+4PpjhFToNWvbyGywblQFSY8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mHdhSE0ZD4u52G5NgHZJ1Ui3tB/8/Y/IBU2XbHFiFnEtk38HmTH796BLA5Jt629ve
	 DGsn7AtBbaChShOGrrpX2l+O6fh2tqwwpz/MYi70++/TfvJtKWjSrD+aDosMqh3tZb
	 nzNvTmF4KMHkWk8oVPejCPnkQahGaCz9Y1kGirYQT9OpM3DaohpRWHGJ9GKX8qhJ9o
	 o/wyIyENWZAzpCZsIP4R1lC/0gLrNkfZnUMKbrKmfy/vQduwhYSJ2mk56pebJYzIW5
	 VK2bsTGLDwnVJIM2X1z78EQHdHMgbpNXL3xI+hyH4dxYAaWQW/DNQFjaTbYirP683y
	 epTfBXDGYEpSQ==
Date: Tue, 15 Jul 2025 10:41:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	djwong@kernel.org, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH v2] fs/xfs: replace strncpy with memtostr_pad()
Message-ID: <5cwrwinj6j6nqhk2gc6aj4th3csls5ga3noydzykj6fkk2v4zi@qvboar3cyh7x>
References: <20250704101250.24629-1-pranav.tyagi03@gmail.com>
 <K5x4H41jqElESRuxXyh2MqE-igMg5PS77kCZOTtYzKuSMeRMHVp8VJC2eTQqblSYtoWkt6KGDsHr2g-S-zGbPg==@protonmail.internalid>
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

Looks fine to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


> 
> Regards
> Pranav Tyagi
> 
