Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from shelob.surriel.com ([96.67.55.147]:54924 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfEHOJC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 10:09:02 -0400
Message-ID: <3985b9feffe11dcdbb86fa8c2d9ffc4bd7ab8458.camel@surriel.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
From: Rik van Riel <riel@surriel.com>
Date: Wed, 08 May 2019 10:08:59 -0400
In-Reply-To: <20190507212213.GO29573@dread.disaster.area>
References: <20190507130528.1d3d471b@imladris.surriel.com>
         <20190507212213.GO29573@dread.disaster.area>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LmHS3NdtgcSLKha3w+oN"
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <dchinner@redhat.com>


--=-LmHS3NdtgcSLKha3w+oN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-05-08 at 07:22 +1000, Dave Chinner wrote:
> On Tue, May 07, 2019 at 01:05:28PM -0400, Rik van Riel wrote:
> > The code in xlog_wait uses the spinlock to make adding the task to
> > the wait queue, and setting the task state to UNINTERRUPTIBLE
> > atomic
> > with respect to the waker.
> >=20
> > Doing the wakeup after releasing the spinlock opens up the
> > following
> > race condition:
> >=20
> > - add task to wait queue
> >=20
> > -                                      wake up task
> >=20
> > - set task state to UNINTERRUPTIBLE
> >=20
> > Simply moving the spin_unlock to after the wake_up_all results
> > in the waker not being able to see a task on the waitqueue before
> > it has set its state to UNINTERRUPTIBLE.
>=20
> Yup, seems like an issue. Good find, Rik.
>=20
> So, what problem is this actually fixing? Was it noticed by
> inspection, or is it actually manifesting on production machines?
> If it is manifesting IRL, what are the symptoms (e.g. hang running
> out of log space?) and do you have a test case or any way to
> exercise it easily?

Chris spotted a hung kworker task, in UNINTERRUPTIBLE
state, but with an empty wait queue. This does not seem
like something that is easily reproducible.

> And, FWIW, did you check all the other xlog_wait() users for the
> same problem?

I did not, but am looking now. The xlog_wait code itself
is fine, but it seems there are a few other wakers that
are doing the wakeup after releasing the lock.

It looks like xfs_log_force_umount() and the other wakeup=20
in xlog_state_do_callback() suffer from the same issue.

> > The lock ordering of taking the waitqueue lock inside the
> > l_icloglock
> > is already used inside xlog_wait; it is unclear why the waker was
> > doing
> > things differently.
>=20
> Historical, most likely, and the wakeup code has changed in years
> gone by and a race condition that rarely manifests is unlikely to be
> noticed.
>=20
> ....
>=20
> Yeah, the conversion from counting semaphore outside the iclog lock
> to use wait queues in 2008 introduced this bug. The wait queue
> addition was moved inside the lock, the wakeup left outside. So:

It looks like that conversion may have introduced the
same bug in multiple places.

That first wakeup in xlog_state_do_callback() looks pretty
straightforward. That spin_unlock could be moved down as well,
or a lock & unlock pair could be placed around the wake_up_all.

I am not sure about xfs_log_force_umount(). Could the unlock=20
be moved to after the wake_up_all, or does that create lock
ordering issues with the xlog_grant_head_wake_all calls?
Could a simple lock + unlock of log->l_icloglock around the
wake_up_all do the trick, or is there some other state that
also needs to stay locked?


--=20
All Rights Reversed.

--=-LmHS3NdtgcSLKha3w+oN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAlzS4vsACgkQznnekoTE
3oNRQwf/QACRyTToqIaz1xndSyWZH+qLqp67i7IrcHPiV9FpCtZbhHSwhCH9EmJ0
OXnOECSOlEcNJUb2rjgc0tr4tvLR9JtjNipzrLDK4cCcJ705ZSK2Ss1o9trQiOmN
96W4h0GEV1vyYuTkDkgKL8k34EqGQf4vXcvJExqzZwd8EgzDYXtZ3LRLSvAS8wtC
aPme3zNJ5XUO/7XPmcVQSEpV0WL28DGUV+HF+8Mufglu6NY1fmeX5n2oJN6rlrQ/
HFfEMBvtnSSmcdpXWh5lf9FSOSx5nbyNtwGSz2wQ8nAVe+R+R2zUDbJZh9WYU+cn
gd1fwNQIfXhMPBQtfi8Wv9vg1EbSWg==
=DMDb
-----END PGP SIGNATURE-----

--=-LmHS3NdtgcSLKha3w+oN--
