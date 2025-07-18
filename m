Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32B82DD5F3;
	Fri, 18 Jul 2025 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752851554; cv=none; b=NWWTOpK3Kul9GK8KXS3A4zmWSHnDz+CpWIurQ6kSO5pII5Qu7pjcqVJg4yLuzMBX0tknELMKvxmTSqJUiq5TfhaHWPFJayLzxSB2c3WtQuh5dPaBBwxuemrV67JBYw6QNJHc+/cbrbH3MtsPgUqxfyivXGIaXHdIGWb+Kjtfyis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752851554; c=relaxed/simple;
	bh=Tqoja4BGY3ST/phNrW/Dx7K5ExOJa+RH+dLKgnR2GPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNSs7uvnNDBKh6mvjE852Vy6mgIPK4Mb3W7ubcoE6EUzjiF5I64hGUA0QaJ7d4gGpTfZ1nPrw6QLZ+E/IGgTWhybAoiwD2dfQc6GJCU6enMM2AX4YLaH6kvMQjHXTEbc/IX/6O0i6eS8RWQBPs/vabkDK0Fbw7xYN39MtbHUlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAIG+7N+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAIG+7N+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F66C4CEF1;
	Fri, 18 Jul 2025 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752851554;
	bh=Tqoja4BGY3ST/phNrW/Dx7K5ExOJa+RH+dLKgnR2GPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lAIG+7N+EqFKCtsiDz5rQBwIasEMnx4IXR6MX4hm23VxJt2sERXpY51ClJUInkfiv
	 DqJwbzR4eRQ+kCloNN5lDwPS9YG3UkCKD5awd0OjvR93iHMtOblOCY9kWC+wlZyUXW
	 j/+ZoGGCEUtfc9xenyjzprTv7a4H4/6/gKfmRttNkfuOrajDX/ZuRhwV0XuXnzuFvB
	 veazYVXfxlWU6eMAZCF8SP6eg3cOWPT8Sj3kNUaNMgH9/DPjB/OalLp0rwNk8Iq2TH
	 2Ij7r5hVGCodTalIBFgy+d2T0HKqJWhvE10H1+jGu9UzllhB5F3LrkStURoJE6+NZ6
	 Xzyalm0NlAKGg==
Date: Fri, 18 Jul 2025 08:12:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: or10n-cli <muhammad.ahmed.27@hotmail.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agheader: remove inappropriate use of -ENOSYS
Message-ID: <20250718151233.GS2672049@frogsfrogsfrogs>
References: <alkfwOHITuxAoSIlg-ZgfhzBV_BrXj2oC7-6qD_gksbVxsIsw9472FpW3FySIh9byZcQQUmcdojisYFr9gRuOg==@protonmail.internalid>
 <DB6PR07MB314253A24F94DAA65E0CD5D9BB50A@DB6PR07MB3142.eurprd07.prod.outlook.com>
 <rypeauv2sg6iljvklmsgmir6g242btpqv6l7yidvmyenptdsf3@cnumxkzug2mp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <rypeauv2sg6iljvklmsgmir6g242btpqv6l7yidvmyenptdsf3@cnumxkzug2mp>

On Fri, Jul 18, 2025 at 03:02:41PM +0200, Carlos Maiolino wrote:
> On Fri, Jul 18, 2025 at 05:43:24PM +0500, or10n-cli wrote:
> >  From 8b4f1f86101f2bf47a90a56321259d32d7fe55eb Mon Sep 17 00:00:00 2001
> > From: or10n-cli <muhammad.ahmed.27@hotmail.com>
> > Date: Fri, 18 Jul 2025 16:24:10 +0500
> > Subject: [PATCH] agheader: remove inappropriate use of -ENOSYS
> > 
> > The ENOSYS error code should only be used to indicate an invalid
> > system call number. Its usage in this context is misleading and
> > has been removed to align with kernel error code semantics.
> > 
> > Signed-off-by: my.user <my.mail@hotmail.com>
> > ---
> >   fs/xfs/scrub/agheader.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > index 303374df44bd..743e0584b75d 100644
> > --- a/fs/xfs/scrub/agheader.c
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -134,7 +134,6 @@ xchk_superblock(
> >           */
> >          switch (error) {
> >          case -EINVAL:   /* also -EWRONGFS */
> > -       case -ENOSYS:
> >          case -EFBIG:
> >                  error = -EFSCORRUPTED;
> >                  fallthrough;
> > --
> 
> The comment right above what you changed says:
> 
> /*
>  * The superblock verifier can return several different error codes
>  * if it thinks the superblock doesn't look right.
> .
> .
> */
> 
> What you did is basically skipping superblock inode size validation,
> now scrub will assume it's consistent even if it's corrupted.
> 
> Also. Please, go read Documentation/process/submitting-patches.rst

...and please don't send the same email to us four times in a row.

--D
