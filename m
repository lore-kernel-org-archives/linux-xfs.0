Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C857AEACD;
	Fri,  5 Jun 2026 04:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780633135; cv=none; b=FCR8WMi91kA+e++FKaZsjjnDMfyU0P1o8qEXDCFID2KwoEiwyNPlKCYeKytESUeho8z0wRN2KI6sis+5UYrpU0sLQN+b+I8qsJjgos7AtAsZYaCjjrAYf1l4ePKzNNH1f1mVKP4XMjXQPz07ZGlEjUpYjCNfWVqkQIXdAnI1HgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780633135; c=relaxed/simple;
	bh=jfffhCahlQeEtjzWlHu6IYX6cg/xPBm7iisjqlx4HG4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Eqh1Nw3ya5ennfCIWT5TcmSD0ThgkY9K33sKMtHaObDFAxSuiEzbovmec6XYTpnEqfkMo839fiF4e/ljGUnDzIje02ljWCAx6vn/QdxL79/6ToMTUvTa6hYQoXTrWvnNyZyzv+pN7hylOU0vkVqUVUeow4Zz11vlrYFuuUuRaic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BXKP/nA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BXKP/nA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CE01F00893;
	Fri,  5 Jun 2026 04:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780633132;
	bh=QtXkgBzgoalyqyfwddDrgqDOam+b3lalcp4gNfvQD4Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BXKP/nA4iHg2N0lt7m+0QTuEUsi626BMz165Hx0eytH5HKfSpEbwX8gpztmxdfBAc
	 g1k3Hoay3JiGFv/0vRsuR5GMNNtaP7W2ws3t8O2UyD3Z/Hvkb1gVGXGxJRqB6ur1qd
	 NGto+oI9gdB5O7RtTLCgZzn9paudIp9NXJXYvfH+ApF1Z69+CGH4op70hYca3gbkBJ
	 oB3akDEu7XXqFqoWVvOZ4pfNbZ6w4tGCiLoLHLuONzBvhjEZ7bughIuelA5702USDB
	 MI7FZYpTpg9PvnJwu3fYuMETEMqlTKvC16kpl26aQ0tT3XIJYgsVDhnU0+xxfBVllm
	 5h6wZvIaGkYxA==
Message-ID: <5c97f096ec32c164ac36a8fc2daaf88bd2721014.camel@kernel.org>
Subject: Re: [PATCH] xfs: fix unreachable BIGTIME check in dquot flush
 validation
From: Allison Henderson <achender@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>, Alexey Nepomnyashih <sdl@nppct.ru>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, stable@vger.kernel.org
Date: Thu, 04 Jun 2026 21:18:51 -0700
In-Reply-To: <20260603210811.GV6078@frogsfrogsfrogs>
References: <20260603204148.232530-1-sdl@nppct.ru>
	 <20260603210811.GV6078@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-06-03 at 14:08 -0700, Darrick J. Wong wrote:
> [fix some addresses]
>=20
> On Wed, Jun 03, 2026 at 08:41:47PM +0000, Alexey Nepomnyashih wrote:
> > The dqp->q_id =3D=3D 0 check inside the XFS_DQTYPE_BIGTIME block is
> > unreachable because root dquots return successfully earlier. Reject roo=
t
> > dquots with XFS_DQTYPE_BIGTIME before that early return, preserving the
> > intended validation and removing the unreachable condition.
> >=20
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> >=20
> > Fixes: 4ea1ff3b4968 ("xfs: widen ondisk quota expiration timestamps to =
handle y2038+")
> > Cc: stable@vger.kernel.org # v5.10+
> > Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>
Hi Alexey,

Looks good, thanks for catching this!
Reviewed-by: Allison Henderson <achender@kernel.org>

>=20
> Yeah, that looks like a screwup...
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>=20
> --D
>=20
> > ---
> >  fs/xfs/xfs_dquot.c | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index 69e9bc588c8b..c311f61d9554 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -1216,6 +1216,14 @@ xfs_qm_dqflush_check(
> >  	    type !=3D XFS_DQTYPE_PROJ)
> >  		return __this_address;
> > =20
> > +	/* bigtime flag should never be set on root dquots */
> > +	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> > +		if (!xfs_has_bigtime(dqp->q_mount))
> > +			return __this_address;
> > +		if (dqp->q_id =3D=3D 0)
> > +			return __this_address;
> > +	}
> > +
> >  	if (dqp->q_id =3D=3D 0)
> >  		return NULL;
> > =20
> > @@ -1231,14 +1239,6 @@ xfs_qm_dqflush_check(
> >  	    !dqp->q_rtb.timer)
> >  		return __this_address;
> > =20
> > -	/* bigtime flag should never be set on root dquots */
> > -	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> > -		if (!xfs_has_bigtime(dqp->q_mount))
> > -			return __this_address;
> > -		if (dqp->q_id =3D=3D 0)
> > -			return __this_address;
> > -	}
> > -
> >  	return NULL;
> >  }
> > =20
> > --=20
> > 2.43.0
> >=20
> >=20

