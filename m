Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB8716DEB3;
	Tue,  8 Jul 2025 09:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751968791; cv=none; b=hISDR6VSCM36f8S7cEIRkjLkCpjhtfykt2EV3pAvzy/kL7Ux3AFL+Gyyun45Bd/wB152bOWqneIJTuJ0Do4uPfbMjewIHaiOmlAxTB35OicrFpjm3g5cqxkYrGYYq6r6wEsJ9G4wLnWJSj7uGKxMPY62KX48dPp/JFtQOJJejeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751968791; c=relaxed/simple;
	bh=U+ALmIvtauUGQfRxu/HLRvT7GiUuFduo9KYZ9g3pIvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRNCw2BjPqBdVUpkvoLAjGS7QRoXYGZuIpRj2iLTDXQDae5c37Dp74tRpR2SWsop86lGHJWN8Qp3KLZBV/A3ekpm5yzcSHXrWlhZifuAvF1sxpww1zRjqgEqQvrc2qo0FPwJDR/Ymdb+EZ2m80jUc16i57WHZPiL7m90BzqSoXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Amefj1Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Amefj1Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3950C4CEED;
	Tue,  8 Jul 2025 09:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751968790;
	bh=U+ALmIvtauUGQfRxu/HLRvT7GiUuFduo9KYZ9g3pIvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Amefj1Rmg+fI/XRubKDeZ7IUZEnSfmrH6Njg7/73ml52H0kWvBbZjY/CP1IOIxRZv
	 N3E3IQUet2ziFlYsm/lda+gLecuMRZFaTlON02n8IQ0Pj2vjIvnwZl2ewYXp7FsjYL
	 AYTiwHzezEenNnQZg81CRyIHJG2YJ7Rp4XjploQio+6d4QqVlmXfqMIosH/0mHTOtT
	 8ObsTXXeEyt9iSz7nCVEL52ohy24GZZHTp8VCgwy3Fgw9Iy0Ods4HDpRjV2HOTGDmk
	 qvPhfxArg3zgagcFyw9QJiO6seV+rgwR8X7+Qpky+WzEqZjOSSYke77G1AbTN9OYMa
	 mEYFGprXBIEoA==
Date: Tue, 8 Jul 2025 11:59:44 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, skhan@linuxfoundation.org, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Message-ID: <l6sjutxf7g3gafcmwtzaadm7ngoqoss5lh6sc4f6naugb3vo2b@e4mdbr43xwge>
References: <oxpeGQP7AC5GXfnifSYyeW7X_URDJhOvCxTG09iGmuvIXd330ZdXanoBmbUB3wpOcIORP1CakEzevsjtJKynhw==@protonmail.internalid>
 <20250617131446.25551-1-pranav.tyagi03@gmail.com>
 <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
 <rkCSJQOnZAt9nfcVUrC8gHDWqHhzMThp3xx38GD2BgJZM4iXJfvVgXZwa21-3xikSHHLO-scI4_47aO-O1d5FQ==@protonmail.internalid>
 <CAH4c4j+dhh9uW=GOoxaaefBTWQtbLeWQs1SqrWwpka9R8mwBTg@mail.gmail.com>
 <aaywkct2isosqxd37njlua4xxxll2vlvv7huhh34ko3ths7iw4@cdgrtvlp3cwh>
 <pygwb44kAWjcvW1e9Rveg6qGlQmY2r81JtgZ1dM1qhWT6DxalgoXub31RDJH0Mcx2S3cNbWTiFXM9o74gelVnA==@protonmail.internalid>
 <CAH4c4jKisoACHNOQH5Cusduu-_51_PcevxYJT3k_o6MjBWsVJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH4c4jKisoACHNOQH5Cusduu-_51_PcevxYJT3k_o6MjBWsVJw@mail.gmail.com>

On Mon, Jul 07, 2025 at 08:02:06PM +0530, Pranav Tyagi wrote:
> On Tue, Jul 1, 2025 at 12:04 AM Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Mon, Jun 30, 2025 at 06:18:06PM +0530, Pranav Tyagi wrote:
> > > On Mon, Jun 30, 2025 at 5:49 PM Carlos Maiolino <cem@kernel.org> wrote:
> > > >
> > > > On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> > > > > Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> > > > > The length is known and a null byte is added manually.
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > > > > ---
> > > > >  fs/xfs/xfs_xattr.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > > > index 0f641a9091ec..ac5cecec9aa1 100644
> > > > > --- a/fs/xfs/xfs_xattr.c
> > > > > +++ b/fs/xfs/xfs_xattr.c
> > > > > @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
> > > > >       offset = context->buffer + context->count;
> > > > >       memcpy(offset, prefix, prefix_len);
> > > > >       offset += prefix_len;
> > > > > -     strncpy(offset, (char *)name, namelen);                 /* real name */
> > > > > +     memcpy(offset, (char *)name, namelen);                  /* real name */
> > > > >       offset += namelen;
> > > > >       *offset = '\0';
> > > >
> > > > What difference does it make?
> > >
> > > I intended this to be a cleanup patch as strncpy()
> > > is deprecated and its use discouraged.
> >
> > Fair enough. This is the kind of information that's worth
> > to add to the patch description on your future patches.
> >
> > No need to re-send this again.
> >
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Thanks Darrick and Carlos for the Reviewed-by tag.
> 
> I also wanted to ask if this patch has been queued for merging.

xfs teams sends an ANNOUNCE email every merge done to the for-next
branch, you can check if your patches are mentioned there, if not
they are not queued up yet.

Also, you'll likely receive a message saying your patch has been pushed
into for-next.

Note though that just because your patch has been added to for-next,
doesn't automatically mean it will be merged. Several tests still
happens on patches pushed to for-next branch (which are merged into
linux-next) and linux-next 'after' your patch has been merged into.

So your patch(es) being merged are conditional to that.

Carlos

> 
> Regards
> Pranav Tyagi
> >
> > >
> > > Regards
> > > Pranav Tyagi
> > > >
> > > >
> > > > >
> > > > > --
> > > > > 2.49.0
> > > > >
> 
