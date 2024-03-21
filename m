Received: from xmailer.gwdg.de (xmailer.gwdg.de [134.76.10.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6A753E1E
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 09:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711015176; cv=none; b=dzA7BBfUQ5wUwm3VDh4Yku5BeCCo6zCT0KCPilsYv3z9FrA5UMZp6jvrlCihe2XDQFDZr2fYb0sLrb9PVfcOp55Q/b9DoWIXhqqrSWD0KbctyjMQ5L49mEcnZgMbNSCZjvmn7eF6reuuOYFrQNn+0eC5nnPAYEv6JhE1vHiEEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711015176; c=relaxed/simple;
	bh=V+wfSujrcvImCTBMnzB9WGV1eTnDGG9qt83MHNoaL0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcikZdXcIoB0kyZIBG015XNEmM/NXYKXD9FJlEhRYYXS8TZemUO7x+7Gfv+0HFwo6/zHyQs7GzbQiP3fMr3QLErumbvZ5Qm7qoqUFWSoQQETuCn6lL3HUhZPFmPipiLEMqB5Tgy4tozLb0TkNT0OhaVrr9Hj1XQh/jIwbyUGlek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de; spf=pass smtp.mailfrom=tuebingen.mpg.de; arc=none smtp.client-ip=134.76.10.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuebingen.mpg.de
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <maan@tuebingen.mpg.de>)
	id 1rnFCi-0003O6-2V;
	Thu, 21 Mar 2024 10:59:23 +0100
Received: from [10.35.40.80] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 47098173; Thu, 21 Mar 2024 10:59:22 +0100
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Thu, 21 Mar 2024 10:59:22 +0100
Date: Thu, 21 Mar 2024 10:59:22 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: reactivate XFS_NEED_INACTIVE inodes from
 xfs_iget
Message-ID: <ZfwE-k0irgGBfI5r@tuebingen.mpg.de>
References: <20240319001707.3430251-1-david@fromorbit.com>
 <20240319001707.3430251-5-david@fromorbit.com>
 <Zfqg3b3mC8Se7GMU@tuebingen.mpg.de>
 <20240320145328.GX1927156@frogsfrogsfrogs>
 <ZfsVzV52CG9ukVn-@tuebingen.mpg.de>
 <ZftofP8nbKzUdqMZ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0O+klYKTr/vElliM"
Content-Disposition: inline
In-Reply-To: <ZftofP8nbKzUdqMZ@dread.disaster.area>
User-Agent: Mutt/2.2.13 (00d56288) (2024-03-09)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav


--0O+klYKTr/vElliM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 09:51, Dave Chinner wrote
> I just haven't thought to run sparse on XFS recently - running
> sparse on a full kernel build is just .... awful. I think I'll
> change my build script so that when I do an '--xfs-only' built it
> also enables sparse as it's only rebuilding fs/xfs at that point....

Would it be less awful to run coccinelle with a selected set of
semantic patches that catch defective patterns such as double
unlock/free?

> > > (Doesn't simple lock debugging catch these sorts of things?)
> >=20
> > Maybe this error path doesn't get exercised because xfs_reinit_inode()
> > never fails. AFAICT, it can only fail if security_inode_alloc()
> > can't allocate the composite inode blob.
>=20
> Which syzkaller triggers every so often. I also do all my testing
> with selinux enabled, so security_inode_alloc() is actually being
> exercised and definitely has the potential to fail on my small
> memory configs...

One could try to trigger ENOMEM more easily in functions like this
by allocating bigger slab caches for debug builds.

> > > ((It sure would be nice if locking returned a droppable "object" to do
> > > the unlock ala Rust and then spin_lock could be __must_check.))
> >=20
> > There's the *LOCK_GUARD* macros which employ gcc's cleanup attribute
> > to automatically call e.g. spin_unlock() when a variable goes out of
> > scope (see 54da6a0924311).
>=20
> IMO, the LOCK_GUARD stuff is an awful anti-pattern. It means some
> error paths -look broken- because they lack unlocks, and we have to
> explicitly change code to return from functions with the guarded
> locks held. This is a diametrically opposed locking pattern to the
> existing non-guarded lockign patterns - correct behaviour in one
> pattern is broken behaviour in the other, and vice versa.
>=20
> That's just -insane- from a code maintenance point of view.

Converting all locks in fs/xfs in one go is not an option either, as
this would be too big to review, and non-trivial to begin with. There
are 180+ calls to spin_lock(), and that's just the spinlocks. Also
these patches would interfere badly with ongoing work.

> And they are completely useless for anythign complex like these
> XFS icache functions because the lock scope is not balanced across
> functions.
>
> The lock can also be taken by functions called within the guard
> scope, and so using guarded lock scoping would result in deadlocks.
> i.e. xfs_inodegc_queue() needs to take the i_flags_lock, so it must
> be dropped before we call that.

Yup, these can't use the LOCK_GUARD macros, which leads to an unholy
mix of guarded and unguarded locks.

> So, yeah, lock guards seem to me to be largely just a "look ma, no
> need for rust because we can mightily abuse the C preprocessor!"
> anti-pattern looking for a problem to solve.

Do you think there is a valid use case for the cleanup attribute,
or do you believe that the whole concept is mis-designed?

Thanks for sharing your opinions.
Andre
--=20
Max Planck Institute for Biology
Tel: (+49) 7071 601 829
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany
http://people.tuebingen.mpg.de/maan/

--0O+klYKTr/vElliM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCZfwE9wAKCRBa2jVAMQCT
D87NAJ456rxseL0kaBINjY8JjKE4Xc6SRwCggecNrHYifDko+dGkreVZlhBXXDk=
=qtpz
-----END PGP SIGNATURE-----

--0O+klYKTr/vElliM--
