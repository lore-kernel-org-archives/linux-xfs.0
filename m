Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shelob.surriel.com ([96.67.55.147]:41342 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbfEIO1E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 May 2019 10:27:04 -0400
Message-ID: <76d44406cae3d0d70e8e4b209a6050a0ab49e764.camel@surriel.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
From: Rik van Riel <riel@surriel.com>
Date: Thu, 09 May 2019 10:27:00 -0400
In-Reply-To: <20190508213244.GP29573@dread.disaster.area>
References: <20190507130528.1d3d471b@imladris.surriel.com>
         <20190507212213.GO29573@dread.disaster.area>
         <3985b9feffe11dcdbb86fa8c2d9ffc4bd7ab8458.camel@surriel.com>
         <20190508213244.GP29573@dread.disaster.area>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-W/e0aVHE5QqcDTd+W71b"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <dchinner@redhat.com>


--=-W/e0aVHE5QqcDTd+W71b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-05-09 at 07:32 +1000, Dave Chinner wrote:

> Hmmm, the first wakeup in xsdc is this one, right:
>=20
> 	       /* wake up threads waiting in xfs_log_force() */
> 	       wake_up_all(&iclog->ic_force_wait);
>=20
> At the end of the iclog iteration loop? That one is under the
> ic_loglock - the lock is dropped to run callbacks, then picked up
> again once the callbacks are done and before the ic_callback_lock is
> dropped (about 10 lines above the wakeup). So unless I'm missing
> something (like enough coffee!) that one look fine.

You are right. I failed to spot that the spin_unlock unlocks=20
a different lock than the spin_lock above it takes.=20

> .....
>=20
> > I am not sure about xfs_log_force_umount(). Could the unlock=20
> > be moved to after the wake_up_all, or does that create lock
> > ordering issues with the xlog_grant_head_wake_all calls?
> > Could a simple lock + unlock of log->l_icloglock around the
> > wake_up_all do the trick, or is there some other state that
> > also needs to stay locked?
>=20
> Need to be careful which lock is used with which wait queue :)
>=20
> This one is waking the the xc_commit_wait queue (CIL push commit
> sequencing wait queue), which is protected by the
> log->l_cilp->xc_push_lock. That should nest jsut fine inside any
> locks we are holding at this point, so you should just be able to
> wrap it.  It's not a common code path, though, it'll only hit this
> code when the filesystem is already considered to be in an
> unrecoverable state.

Awesome.

--=20
All Rights Reversed.

--=-W/e0aVHE5QqcDTd+W71b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlzUOLQACgkQznnekoTE
3oNhCQgAspcyzPQilxh6iJCi12zlD4ddHwUIpoXux0E9739G+GTIGCi4EcAd3bfL
u7LBuYIQmEbWAo4LAtWldRpvKaYNMbbLih4g72nUjqKk7lgvhjqYGSRSfcuZ8y+r
/Ml8OnXuSNhSKjCGWP2eO/JcrcuNItv60bcXGKpX4Ghonscti6AdxAhDXyiTsz/x
qyptfc/xdT78bMBPxHhNiaqer5Y6JOv7fIrqz2/I8JkJm59YhowowoVLFpe/6/4F
dQOw7R8hPrQQ9AdlOGF1+/pzL7FkYktE90jNf00ahvTL9lDZe+FgqvlqRY22f1mC
/dFnf5ht+gT40TrvpKQmdjJcOzl9kA==
=UejA
-----END PGP SIGNATURE-----

--=-W/e0aVHE5QqcDTd+W71b--
