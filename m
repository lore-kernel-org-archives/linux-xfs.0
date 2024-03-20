Received: from xmailer.gwdg.de (xmailer.gwdg.de [134.76.10.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA9810FA
	for <linux-xfs@vger.kernel.org>; Wed, 20 Mar 2024 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710953940; cv=none; b=d3LGU61SmwRO8AOofor2a8EPSXPV4ImWmlw3nRmjrAE6f1SvadR6OuuA3La4EVWw+hSVKcS6UsiRSSHmRvKWJC1f+pG0ZPZyaorQSzu3QJvwzFQJ0i5IysoWWRdCM602afmecraQWYaLxaoTmIXq7v/0yfqGAIM0daBnmTZK4QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710953940; c=relaxed/simple;
	bh=l6a8aRg4Yf26pn0KOPlZ7/50XxAeSGmG5AkOtPzsNYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3eI0WwH96qchb+Y8kWyJArrU4jz2c6zDLN7QpvSaZuDBO7/IAz2Ci0rMjb8SrDxhSUKqxm2jRwfrlDC00LMxNyJxfDprsox0OBrE15VubydzDMuCzXrJ2yk+PCSlytTcQ/v9F2L8b/11/ZmoTK83G6lwlk04kEzgcjWh4R+SRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de; spf=pass smtp.mailfrom=tuebingen.mpg.de; arc=none smtp.client-ip=134.76.10.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuebingen.mpg.de
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <maan@tuebingen.mpg.de>)
	id 1rmzH9-0002lI-35;
	Wed, 20 Mar 2024 17:58:54 +0100
Received: from [10.35.40.80] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 47088460; Wed, 20 Mar 2024 17:58:53 +0100
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Wed, 20 Mar 2024 17:58:53 +0100
Date: Wed, 20 Mar 2024 17:58:53 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <ZfsVzV52CG9ukVn-@tuebingen.mpg.de>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
 <20240320145328.GX1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vuBbPI5TQgdLf9ZF"
Content-Disposition: inline
In-Reply-To: <20240320145328.GX1927156@frogsfrogsfrogs>
User-Agent: Mutt/2.2.13 (00d56288) (2024-03-09)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav


--vuBbPI5TQgdLf9ZF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 07:53, Darrick J. Wong wrote
> On Wed, Mar 20, 2024 at 09:39:57AM +0100, Andre Noll wrote:
> > On Tue, Mar 19, 11:16, Dave Chinner wrote
> > > +		/*
> > > +		 * Well, that sucks. Put the inode back on the inactive queue.
> > > +		 * Do this while still under the ILOCK so that we can set the
> > > +		 * NEED_INACTIVE flag and clear the INACTIVATING flag an not
> > > +		 * have another lookup race with us before we've finished
> > > +		 * putting the inode back on the inodegc queue.
> > > +		 */
> > > +		spin_unlock(&ip->i_flags_lock);
> > > +		ip->i_flags |=3D XFS_NEED_INACTIVE;
> > > +		ip->i_flags &=3D ~XFS_INACTIVATING;
> > > +		spin_unlock(&ip->i_flags_lock);
> >=20
> > This doesn't look right. Shouldn't the first spin_unlock() be spin_lock=
()?
>=20
> Yes.  So much for my hand inspection of code. :(

Given enough hand inspections, all bugs are shallow :)

> (Doesn't simple lock debugging catch these sorts of things?)

Maybe this error path doesn't get exercised because xfs_reinit_inode()
never fails. AFAICT, it can only fail if security_inode_alloc()
can't allocate the composite inode blob.

> ((It sure would be nice if locking returned a droppable "object" to do
> the unlock ala Rust and then spin_lock could be __must_check.))

There's the *LOCK_GUARD* macros which employ gcc's cleanup attribute
to automatically call e.g. spin_unlock() when a variable goes out of
scope (see 54da6a0924311).

Best
Andre
--=20
Max Planck Institute for Biology
Tel: (+49) 7071 601 829
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany
http://people.tuebingen.mpg.de/maan/

--vuBbPI5TQgdLf9ZF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCZfsVygAKCRBa2jVAMQCT
D2ItAKCcd0hNJF5+ngpO+jd3oACUs/px1QCdFc4oDHt36v/p3J5FvcBdOYiGnZs=
=IosO
-----END PGP SIGNATURE-----

--vuBbPI5TQgdLf9ZF--
