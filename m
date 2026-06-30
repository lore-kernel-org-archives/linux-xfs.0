Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA23E833B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 10:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782813677; cv=pass; b=W5FrrTHZRiGbp08ppaUM/9HqtO2lmuuYUifQsuGj+lKan65OVKqBDtgbyJUFH9v2oauT+JNUGP5VGheau5v+Dlw1J3u8Flc+4OCcP/REPzFKTvNkGZdAUuFSg0yFE6Q+lNMG4vysIDScXQr/rnRRA82HHSYx1utig6hbQKeA4i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782813677; c=relaxed/simple;
	bh=BU8JH/JOv4QfhOcoG4nN41cEWWJ+yoErkc6ymqiy3mk=;
	h=In-Reply-To:References:MIME-Version:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bF+ZSD96yDoU0VV1gmtESY2I5iXR/B3BDLg1FFbxW0WN3BQ8zMeCZhaHgfN4PnM40wV2YW/0mmp4Utn5Tc1wMJZRe/QZNyeJKc0h6bTkTznV/m00udvTzu/w9pTtjKflk9TD8GnPuf3feXEibz/GYum1hIG4BzYb0vokDPVGtqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPaL+u7t; arc=pass smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPaL+u7t"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-80a1fb0c683so37627047b3.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 03:01:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782813675; cv=none;
        d=google.com; s=arc-20260327;
        b=sV6j48sKFFYga4Xf0pyCXDsvhmn7HoC16ehJYT1Bt8Lxq2iBAz+jZ7kDgJU6vIbSXp
         qV6vUpnaFRlcjzsMUPWKUifBj8lMUgib5uRbMqhA8ZKCNnjc8aNAIvLU8kEphhBAOeAB
         A/Kz5Xwug6vX4pc4LE2nBK8+IeYAPSLuFSr1W53LQw7uFOZWtNzYRhlPTDkVBVyiLR7L
         96mSXNm2m7o5eFN/bfGg9vV7szov7YmDlIxUemAAzXMDaU8HJdl3fEzmjEBHfs/IchRh
         SEuiC1ZeRk7NUmc56sy4i5wfLZ4CZLlADrwvXXWGmQqMTDKTHVIpFUtaODAxeU3qNM/9
         KKqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=BU8JH/JOv4QfhOcoG4nN41cEWWJ+yoErkc6ymqiy3mk=;
        fh=rWRyiVUNrWBLtR1Pc2m50mq23MAO0gvX9dQJh5hv9+M=;
        b=gimzLpvCfq38BQ//IW3rMudMqDNYk88v9TTGyAu3Lkf52lBMoOPX1ahqUxDeKlnWAb
         /Bp+LYY0kkAW6+tINQh2a3WVGxyQ5xk+3J/W+kgrKW6+R8B7YsnWRmnAKkIHYIK+cAGK
         Dot+kAjJQcPrwyyp9yYCp4TIx7NPjLXimAt8d22t/oZZxOWPDHL3vtp4shqTVcn6z0kl
         I1VHXmbqJxB206esX0+9ZH1bRuYMJN+zynrnNq819dtt4ZlRYJfJ7gtTBFSXnKQ571rZ
         bjdR9fUROKXmFYfamSS8WSHv7RQ8ciOX3X26Mu77ZcGRzKnhZFOAraE6quGp0ia4QAE/
         SaJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782813675; x=1783418475; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BU8JH/JOv4QfhOcoG4nN41cEWWJ+yoErkc6ymqiy3mk=;
        b=CPaL+u7tZyg6q8JqiZIQCnevYwkTiYcFgN4EXE9XzrjQ3y/dZ6QVG9xiiBPEhjDpws
         lzm82z2pFIfMpTdn0BYvT5xR/bYjw9RYojzy+jJUPUef0E1/F1wtZTpiz29xroJURrah
         R2iTlNt5bxaQ4DWrCkoEhXDpciXJ2I4ml5zjRwrgyscBJ2DNqrCAIkfQAQDrsAHG+z/S
         c0krm2DB9foaeWFusuI22q+7fmEfGX7ht8Qg+raLFo4eugVVLpvVOkl63sSWL9rGCQNQ
         bQh4r8BcOzJwb/mcBOYeJ+lkg62XgIEkszHlUhEooHF7WVez550xwgUHXe3VIr7C41ET
         UVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782813675; x=1783418475;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BU8JH/JOv4QfhOcoG4nN41cEWWJ+yoErkc6ymqiy3mk=;
        b=Ja5YhlvvGwyKPy8+uc787gVs3K6uEMx/MSdKkGBUelCoFhluLKXEyRRRv1zry8ytJj
         +ihFOwY4hlX2hfvyvmuvxK0cKTeT1I2O1DScbRxiecjlUYpeG29lPoDfEr4K7gH3JwL0
         04FMRLCb0zMsJBsX09Abgonxzj+ZSg/qSDsqMoOiSJuwKrGan7LdEkV6aMRpckCJHwCd
         dpWg0WiQQdeJxuc+1Q5ZQ+EgpPlelUSeHVwwWQs5/2ZQuKn8KxqzEMSWpiZZ+oGuox1I
         fC+l16AZbEnlOc6It64iDQiIm5W0l/vGeRC3J8Lbcu9uK1QHvq4qRjn8TxLD4oqCblgN
         03cQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbWU4Pt4pfy/9gesTLmLSD0/fPTEbXYOpHhGgnS7kB8opfUP/GSkHVvvecjdz6inzS8IVkQgoQXsg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOjPKnIjulwMnczh1PCArVsWEDxivEOS+WQGsGu/h0kGEKSHhI
	VpNy8gddq33iFIY9gzTPMNpTj2RaaGJCXvZkzZfLfrH4iZsFBmcg8Toecv/ZcZOb7qzpSI4edYQ
	QT0n0as3aDFf129V9QOJ/UExLPZM+bUU=
X-Gm-Gg: AfdE7cnvAGNZff373RGcvqYa5IZ/UPjIvcxEEI72YY+iQ8k8wbcoJ+ijZyj3sonTeQP
	2TWU2Dl5pj6un/AKZf+ANgg9p7cizGSuDQj+GXnx4ppHILplh9HDlzSKqcWYSS9dJy5Z6kjKPzW
	s5VBXNZyORbXPTKHwq+dS7uWp3YKBFeTjIVpxFvcPPlZw03sSr89RBi4/h4KaarbmJAAgrHRN+e
	eLdtMKhUhlxM8a4sDnxoCDnzV7F4Zp6D8fPdMCZeZcbSz1Jg5D7aOrgqebLlucSI4UPSMn3
X-Received: by 2002:a05:690c:6186:b0:80a:a005:8415 with SMTP id
 00721157ae682-810d9f0dfdcmr33829617b3.53.1782813674742; Tue, 30 Jun 2026
 03:01:14 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 30 Jun 2026 12:01:13 +0200
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 30 Jun 2026 12:01:13 +0200
In-Reply-To: <20260629203959.GD6078@frogsfrogsfrogs>
References: <20260628094748.46578-1-alhouseenyousef@gmail.com> <20260629203959.GD6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
Date: Tue, 30 Jun 2026 12:01:13 +0200
X-Gm-Features: AVVi8Cc_DhIdO3oFvX3YF7lE0hO5f0INVLW3aYt7sEymvlUtFIcfTvhSp8X8zwQ
Message-ID: <CAMuQ4bXUrZV000bcc-XfPoyBoWFGWAwZRZb-1WDG+BrT5pzuCg@mail.gmail.com>
Subject: Re: [PATCH] xfs: zero newly allocated btree root space
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

It can, but krealloc() requires __GFP_ZERO on the initial allocation
and every subsequent allocation/reallocation of the object. I missed
that requirement here.

I'll send v2 using __GFP_ZERO consistently in xfs_broot_alloc() and
all allocation paths in xfs_broot_realloc(), instead of the explicit
memset.

Thanks,
Yousef

On Mon, 29 Jun 2026 13:39:59 -0700, "Darrick J. Wong" <djwong@kernel.org> wrote:
> On Sun, Jun 28, 2026 at 11:47:48AM +0200, Yousef Alhouseen wrote:
> > xfs_broot_realloc() preserves the existing in-inode btree root while
> > growing its allocation, but leaves the added bytes uninitialized. The
> > inode log formatter copies if_broot_bytes bytes into the journal, so those
> > bytes reach the log record and its CRC calculation before every location
> > has necessarily been overwritten by btree updates.
> >
> > Clear the newly allocated tail immediately after a successful growth to
> > keep stale heap contents out of the filesystem log.
> >
> > Fixes: 6c1c55ac3c05 ("xfs: refactor the inode fork memory allocation functions")
> > Reported-by: syzbot+97f2c05378c5d68dcb8c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=97f2c05378c5d68dcb8c
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
> > ---
> > fs/xfs/libxfs/xfs_inode_fork.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index 606a36526ce2..0d81c78f5afe 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -398,6 +398,8 @@ xfs_broot_realloc(
> > struct xfs_ifork *ifp,
> > size_t new_size)
> > {
> > + size_t old_size = ifp->if_broot_bytes;
> > +
> > /* No size change? No action needed. */
> > if (new_size == ifp->if_broot_bytes)
> > return ifp->if_broot;
> > @@ -430,6 +432,7 @@ xfs_broot_realloc(
> > */
> > ifp->if_broot = krealloc(ifp->if_broot, new_size,
> > GFP_KERNEL | __GFP_NOFAIL);
> > + memset((char *)ifp->if_broot + old_size, 0, new_size - old_size);
>
> Why doesn't GFP_ZERO work to clear the new memory?
>
> --D
>
> > ifp->if_broot_bytes = new_size;
> > return ifp->if_broot;
> > }
> > --
> > 2.54.0
> >
> >
