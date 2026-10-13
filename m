Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83505172EC;
	Tue, 13 Oct 2026 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791902034; cv=none; b=gskHVnMwr+Wc4L1DjsLgPVrp4oL9a/KXyErsfqlysnz1B1kKYRpYc3ukBFbsDqmiWx7oCl/PbDxHVcrnFZYerfeXzTKzei5vauBlBLv1xJQ/YwI7yG0AVLV02b/AazEU5f6Zhl1iKq2iTgwMN8ddbK+ene8dTG0Cu52pdRYi/ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791902034; c=relaxed/simple;
	bh=QRkw4cKEIiDlqzPo/Db4Mv8S2GtAQr2eRWHP6mPAAS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ietygLOVIlwW9kvZ6ram6HOhK+KqSk2Blf9RgtwnsYVRZEGLlLD2ByuGhcyw7jGPvkpZ0H4uxN/uFHNGSgfYgIe7jEGxrqF5RJpq9b5oe/8ZOaACYNBkNYtuw8GUYglppnh016jmeYQSwN+VKsxPGy2FW6XTfQozZtDBCWPAgmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eITRIBbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eITRIBbD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B5501F000FF;
	Tue, 13 Oct 2026 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791902033;
	bh=BX1KWAM6D6ALdcjrVIUSy6X9uY/GbAyQZAVWJBydNxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eITRIBbD9qEywxeidSTARqzlJBc2iam8W8GlMmTixvp3z2fjIcVw+onpQw1YOx6ai
	 KbXL/M1BmUAq0kPdh2Ayl0QWMzoYd3Z7oG/IDREG3ToQuo9kfxBnn6kQEWx8n07Qys
	 xdaNBIT/3tS8PYb+3JiHt8Eb5X708Bc5+dIL7fbgESNJI1bExfV5jP8EpW0WgIeu8c
	 glQiyOkBFr0FqUdVFm7EnxzHb+7CLOvrr6EDJZZj0jonCRCasTqDSQQaXefEMzX9Q5
	 uijHVh1zWHuo2PLy/B4h4waiCVWb5nLTGCH0ZxZ1idb4dxg5wOaRa99fIeufEO/rSF
	 leDwdDtiTEdLg==
Date: Tue, 13 Oct 2026 07:33:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: Fix duplicate assignment in xfs_alloc_read_agf.
Message-ID: <20261013143353.GB1615495@frogsfrogsfrogs>
References: <20261001145153.308087-1-siddh.raman.pant@oracle.com>
 <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as5AloTkTT3bZkyq@nidhogg.toxiclabs.cc>

On Tue, Oct 13, 2026 at 04:31:04PM +0200, Carlos Maiolino wrote:
> On Thu, Oct 01, 2026 at 08:21:53PM +0530, Siddh Raman Pant wrote:
> > Probably an (harmless) error in copy-paste.
> > 
> > Fixes: db6a2274162d ("xfs: catch stale AGF/AGF metadata")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
> > ---
> > Put in stables <= 6.12 after the backport series lands.
> 
> Fix the tags accordingly to Darrick's review and re-send please.

Might I suggest this?
https://lore.kernel.org/linux-xfs/179158948300.3720929.2141793283079787803.stgit@frogsfrogsfrogs/

--D

> > 
> >  fs/xfs/libxfs/xfs_alloc.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index f762dcce8d13..0ffa82400007 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3461,7 +3461,6 @@ xfs_alloc_read_agf(
> >  	if (!xfs_is_shutdown(pag_mount(pag))) {
> >  		bool	ok = true;
> >  
> > -		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
> >  		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
> >  		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
> >  		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
> > -- 
> > 2.53.0
> > 
> > 
