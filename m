Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7973B38B4;
	Fri, 19 Jun 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781888182; cv=none; b=MdCbQ9lOe9Ltze0Kkl7lGXDmozbslxJhHiv7NXCJZgS8mNqXMHNegtUwSXaxFO2TVzI3B85dHLS64MZaeLZKprPp4xn6u5T/jo2rObtUp3zo/zusBKV5UBw4t0FTzhtpn41KbQ4XwS9Hdta1qySfFztgcpbbM4zS8VHk6GtLP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781888182; c=relaxed/simple;
	bh=ikxZrrHtTEwRwlSyKa2TSoeJ3Jvgpjp6HfvvF3KoJj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LF8NK1/supuYydlwLZervtUQaqZugPokkJR45eQc9pjGa8ygiuxM1xl5TrwkwFjErfJ/kZs/JxAdjL5I5u29Aa3VMOOAidoD2EEx01WMrTotK/w0gcMfUwH02hLj1EVnPQUYVYCPwkSxn8jSwIuqsFh++JcLadWMCbEwB55+0LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Shn1glci; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Shn1glci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F0B1F000E9;
	Fri, 19 Jun 2026 16:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781888181;
	bh=9Pc+roecy0N9fcSZhZ72+qSw1o+IjhE+4/qpcF1Vmgk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Shn1glcirGu1wXLyw5SX0iBWhoHUNgPUYmU8oRgEF5R3UfunAR/3yR1wGLaOhqZl6
	 MpE/n+QWAPWVxdK3LJ8/X2j33uGDZ0TvVuTjBkn7bpSkSlyuSrMWvO9ep3WkVTOO05
	 mbhAU6MeJya50Kd3/vda+WFYnkAzPRZywQm3HkKzDDozrePtQdjbXWwifpBJuDTJeD
	 6wh1fWSUDSDkVniWShwwXXFI74T7qKkPY8t422Qa6eciuECvWYLv0KFqR04t4BbFPL
	 UQj8fLdwGxzyj9eiyahw7qYBlKUc/U8Bz+AvhujKQxITT/mvPTlAYM4cvpW45DlAjg
	 Ra8kcktUx+xLg==
Date: Fri, 19 Jun 2026 09:54:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260619165448.GB3223@sol>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260520123722.405752-4-aalbersh@kernel.org>
 <20260520190719.GB3424023@google.com>
 <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh_hfiSwMw8ABhhrz7GguZWjHEiBmvb3eq16Wfqw0+ZrQ@mail.gmail.com>

On Fri, Jun 19, 2026 at 09:28:31AM +0200, Amir Goldstein wrote:
> On Wed, May 20, 2026 at 9:07 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> > > fsverity now exposes fsverity_ensure_verity_info() which could be used
> > > instead of opening file to ensure that fsverity info is loaded and
> > > attached to inode.
> > >
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > Acked-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/util.c | 14 +++-----------
> > >  1 file changed, 3 insertions(+), 11 deletions(-)
> >
> > Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> >
> > I'm still confused by the new implementation of fsverity_active() that
> > got introduced by "fsverity: use a hashtable to find the fsverity_info",
> > though.  I should have caught this during review of that commit.  For
> > one its comment is outdated, but also the memory barrier seems to be
> > specific to the fsverity_get_info() caller and probably should be moved
> > to there.  Anyway, that's not directly related to this patch.
> 
> Eric, Andrey,
> 
> Did you see the Sashiko review for this patch and others in this series?
> 
> https://sashiko.dev/#/patchset/20260520123722.405752-1-aalbersh%40kernel.org
> 
> It annotated some review comments as high and critical.
> For this patch it is about interaction with fscrypt.
> 
> Please take a look and say if this is concerning or false positive.

Yes, this patch is broken and should be dropped.  I need to remember to
look at the Sashiko reviews for other people's patches and not just
trust that the submitter will.  Fortunately this one wasn't applied yet.

I pointed out the HIGHMEM performance bug in
"fsverity: generate and store zero-block hash" earlier
(https://lore.kernel.org/linux-fsdevel/20260401222717.GH2466@quark/).  I
assume it was decided that no one will care about the combination of XFS
&& fsverity && HIGHMEM.  But the XFS folks should double-check that.

Andrey, could you check the Sashiko reviews for the other patches too?

- Eric
