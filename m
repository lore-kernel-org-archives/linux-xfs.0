Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32912F4A;
	Mon, 30 Jun 2025 18:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751308448; cv=none; b=kFoXPQFGxJ7N05FFI6zSeGAFgL6F+e20Hgjwqge9lAcIvmjfpwR2CGqWWQdeQmy1aqJeSawD4T3Xz9v3LDfhiK3HhBQbJ9qXczEt2jrD7EcO36lZqyhEKizXweyBQDDdcpAj/DH+x9R9q0+Bmhv3+IMI3W2+97yOkb5phWh/VKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751308448; c=relaxed/simple;
	bh=cQluqwPmQ2qsJ0mZQhJax1umRyFueorbna/ZicjbzcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZZ5Z8MfJiGr9kqVj65E+MSuLUPhYeX5Pt6t5gKCYS8bhgFzv0oQZbyEzn1WuEqOWBOshSJFTYuohh9CYbammDOw1gToh3WFGS+QRGAjtdPNUxQqSIjGnhKK5cZ/M0Zo6Qv4YXlMVrqxIbMV5I8NBrAXlY29zOavi9ysTR9tkPNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=onWCYXb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="onWCYXb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFBFC4CEEB;
	Mon, 30 Jun 2025 18:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751308447;
	bh=cQluqwPmQ2qsJ0mZQhJax1umRyFueorbna/ZicjbzcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=onWCYXb8/9mUvdcFcjocorSkYQRThisfHLh6JbXX4ob7K3UIsUZCwtAp0lbbGnE/h
	 6h/rQmI39xQwKR8ziHUm08Rf9ek5qtgubJksQDDLngnOFE3bibqZpKDBsu46+mOgcc
	 2ZmRFe11+eqzCkYhy0BeWgIQdEhIDg+RoaOUZlyNf0CDSHoMqNxm9f+TbXB4klMY1u
	 4fz02L5R5OBrNkE3uVyAuquqqg7W01f6zZp7M4i1VklEG2aSHG6gWlsjOeQqgIBoJs
	 xylnCGmB/T9gtgGb6b/3pnhgrIp+PlZyRYRFgEAEIuBqIfqLTA6yzuWdit3akf4Mhe
	 56gPi+NmYwRvA==
Date: Mon, 30 Jun 2025 20:34:03 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Pranav Tyagi <pranav.tyagi03@gmail.com>
Cc: skhan@linuxfoundation.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] xfs: replace strncpy with memcpy in xattr listing
Message-ID: <aaywkct2isosqxd37njlua4xxxll2vlvv7huhh34ko3ths7iw4@cdgrtvlp3cwh>
References: <oxpeGQP7AC5GXfnifSYyeW7X_URDJhOvCxTG09iGmuvIXd330ZdXanoBmbUB3wpOcIORP1CakEzevsjtJKynhw==@protonmail.internalid>
 <20250617131446.25551-1-pranav.tyagi03@gmail.com>
 <huml6d5naz4kf6a3kh5g74dyrtivlaqyzajzwwmyvnpsqhuj3d@7zazaxb3225t>
 <rkCSJQOnZAt9nfcVUrC8gHDWqHhzMThp3xx38GD2BgJZM4iXJfvVgXZwa21-3xikSHHLO-scI4_47aO-O1d5FQ==@protonmail.internalid>
 <CAH4c4j+dhh9uW=GOoxaaefBTWQtbLeWQs1SqrWwpka9R8mwBTg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH4c4j+dhh9uW=GOoxaaefBTWQtbLeWQs1SqrWwpka9R8mwBTg@mail.gmail.com>

On Mon, Jun 30, 2025 at 06:18:06PM +0530, Pranav Tyagi wrote:
> On Mon, Jun 30, 2025 at 5:49 PM Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Tue, Jun 17, 2025 at 06:44:46PM +0530, Pranav Tyagi wrote:
> > > Use memcpy() in place of strncpy() in __xfs_xattr_put_listent().
> > > The length is known and a null byte is added manually.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Pranav Tyagi <pranav.tyagi03@gmail.com>
> > > ---
> > >  fs/xfs/xfs_xattr.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> > > index 0f641a9091ec..ac5cecec9aa1 100644
> > > --- a/fs/xfs/xfs_xattr.c
> > > +++ b/fs/xfs/xfs_xattr.c
> > > @@ -243,7 +243,7 @@ __xfs_xattr_put_listent(
> > >       offset = context->buffer + context->count;
> > >       memcpy(offset, prefix, prefix_len);
> > >       offset += prefix_len;
> > > -     strncpy(offset, (char *)name, namelen);                 /* real name */
> > > +     memcpy(offset, (char *)name, namelen);                  /* real name */
> > >       offset += namelen;
> > >       *offset = '\0';
> >
> > What difference does it make?
> 
> I intended this to be a cleanup patch as strncpy()
> is deprecated and its use discouraged.

Fair enough. This is the kind of information that's worth
to add to the patch description on your future patches.

No need to re-send this again.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Regards
> Pranav Tyagi
> >
> >
> > >
> > > --
> > > 2.49.0
> > >
