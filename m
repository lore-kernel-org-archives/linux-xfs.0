Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D09AEADC;
	Mon, 30 Jun 2025 18:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751308693; cv=none; b=L/fd73yB2arOYNHHnh6g/kdoCjrr6UiJK9Db95RO7bXycMLjzT1HEC+Wzns3VYYbfJW/SHxKaG1wCUwIHGgOuzgLUwM4EB6cgdEqZqTAEu9FaNhYGQNC4YuBJCfvhGmdN2+Xma10ZBLW+9oHiZEP1AKQhF9uEvtp28I8B1RrhLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751308693; c=relaxed/simple;
	bh=SFIdcYrq5Q88LPXoFIVLXlwzcx8YD6QNMwRzmkI9Dp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9S3497opCHr2CS4Y58s4Ly803VvQiAjOfKAgEDJMP+K8VIv6TN5OXRsx/AbJw8oa9+p5qId4KvMdyZ4HmF1nMZ9N3mQkmt/zJbq7e/lU+elQNTAfn9V7jSWDhkJL9zmkixZJNLt2sg4pCxgnoSnlEtgT0aKp8KhuaAhPoxsaKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQujNAHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQujNAHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B07C4CEE3;
	Mon, 30 Jun 2025 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751308692;
	bh=SFIdcYrq5Q88LPXoFIVLXlwzcx8YD6QNMwRzmkI9Dp0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQujNAHqJXzyU0+wI5QuEtq3II7dIwcAcY1GgDoSFk4EcTOh9huZHfqmynSryvROu
	 Xjkp+vTxybo+jickeG4xhgCeZYOicbptcjUNt4Rg++7PhVU7+J5MCnaZQobBdWDTHH
	 2ybSnPCRFJMY3L4k3dQ3F1n1JQW75riWbYT1XZPhq0KpIZxyDxTmzJK3tT26V6QC63
	 avV7JqqPhAzltiievS7BnhFnaU6VBiKZCQ1mb1h2Apcwu9Y/nyKGDDPZ8IKrmaCHpD
	 6jSKyy+imYH/eIvk2HyTI12RkHz6XH0Szw0otqho93P2SCP4+p75eCphQK6wkz45e+
	 gawT01Et6qiBQ==
Date: Mon, 30 Jun 2025 20:38:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/xfs: replace strncpy with strscpy
Message-ID: <6grkelqkotgz6hnwce5n7gzdixgzlaqkwzo243f7vyqjas3c4g@viyu57vmxltz>
References: <BgUaxdxshFCssVdvh_jiOf_C2IyUDDKB9gNz_bt5pLaC8fFmFa0E_Cvq6s9eXOGe8M0fvBUFYG3bqVQAsCyz3w==@protonmail.internalid>
 <20250617124546.24102-1-pranav.tyagi03@gmail.com>
 <qlogdnggv2y4nbzzt62oq4yguitq4ytkqavdwele3xrqi6gwfo@aj45rl7f3eik>
 <WBE4B1OP-kfASGRcvWwSonfk0K1Gt9aaX533GfEvt007c_wee2NnaupnonhPygu25xVhRW0racnd4Jig_diSMA==@protonmail.internalid>
 <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH4c4jLjiBEqVxgRG0GH37RELDp=Py3EoY6bcJhzA+ydfV=Q1A@mail.gmail.com>

On Mon, Jun 30, 2025 at 02:36:01PM +0530, Pranav Tyagi wrote:
> On Mon, Jun 30, 2025 at 2:09 PM Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Tue, Jun 17, 2025 at 06:15:46PM +0530, Pranav Tyagi wrote:
> > > Replace the deprecated strncpy() with strscpy() as the destination
> > > buffer should be NUL-terminated and does not require any trailing
> > > NUL-padding. Also, since NUL-termination is guaranteed,
> >
> > NUL-termination is only guaranteed if you copy into the buffer one less
> > byte than the label requires, i.e XFSLABEL_MAX.
> >
> > > use sizeof(label) in place of XFSLABEL_MAX as the size
> > > parameter.
> >
> > This is wrong, see below why.
> >
> > >
> > > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > > ---
> > >  fs/xfs/xfs_ioctl.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > index d250f7f74e3b..9f4d68c5b5ab 100644
> > > --- a/fs/xfs/xfs_ioctl.c
> > > +++ b/fs/xfs/xfs_ioctl.c
> > > @@ -992,7 +992,7 @@ xfs_ioc_getlabel(
> > >       /* 1 larger than sb_fname, so this ensures a trailing NUL char */
> > >       memset(label, 0, sizeof(label));
> > >       spin_lock(&mp->m_sb_lock);
> > > -     strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> > > +     strscpy(label, sbp->sb_fname, sizeof(label));
> >
> > This is broken and you created a buffer overrun here.
> >
> > XFSLABEL_MAX is set to 12 bytes. The current label size is 13 bytes:
> >
> > char                    label[XFSLABEL_MAX + 1];
> >
> > This ensures the label will always have a null termination character as
> > long as you copy XFSLABEL_MAX bytes into the label.
> >
> > - strncpy(label, sbp->sb_fname, XFSLABEL_MAX);
> >
> > Copies 12 bytes from sb_fname into label. This ensures we always have a
> > trailing \0 at the last byte.
> >
> > Your version:
> >
> > strscpy(label, sbp->sb_fname, sizeof(label));
> >
> > Copies 13 bytes from sb_fname into the label buffer.
> >
> > This not only could have copied a non-null byte to the last byte in the
> > label buffer, but also But sbp->sb_fname size is XFSLABEL_MAX, so you
> > are reading beyond the source buffer size, causing a buffer overrun as you
> > can see on the kernel test robot report.
> >
> > Carlos
> >
> > >       spin_unlock(&mp->m_sb_lock);
> > >
> > >       if (copy_to_user(user_label, label, sizeof(label)))
> > > --
> > > 2.49.0
> > >
> 
> Hi,
> 
> Thank you for the feedback. I understand that my patch is incorrect and
> it causes a buffer overrun. The destination buffer is indeed, already, null
> terminated. Would you like me to send a corrected patch which uses
> strscpy() (as strncpy() is deprecated)?

Sure, do so.

Carlos

> 
> Regret the inconvenience.
> 
> Regards
> Pranav Tyagi
