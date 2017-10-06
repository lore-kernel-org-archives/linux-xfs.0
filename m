Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:56532 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdJFGwd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Oct 2017 02:52:33 -0400
Received: by mail-wm0-f45.google.com with SMTP id l68so5932761wmd.5
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2017 23:52:32 -0700 (PDT)
From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <jg@lightnvm.io>
Message-Id: <231B3089-7B11-4491-ABE6-97AC00862DDE@lightnvm.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_B5987310-BEDF-46C2-A380-7DE5AC0BF175";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Circular locking dependency with pblk
Date: Fri, 6 Oct 2017 08:52:28 +0200
In-Reply-To: <20171005233609.GP3666@dastard>
References: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
 <20171005233609.GP3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, darrick.wong@oracle.com, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>


--Apple-Mail=_B5987310-BEDF-46C2-A380-7DE5AC0BF175
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

> On 6 Oct 2017, at 01.36, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Thu, Oct 05, 2017 at 12:53:50PM +0200, Javier Gonz=C3=A1lez wrote:
>> Hi,
>>=20
>> lockdep is reporting a circular dependency when using XFS and pblk,
>> which I am a bit confused about.
>>=20
>> This happens when XFS sends a number of nested reads and (at least) =
one
>> of them hits partially pblk's cache. In this case, pblk will retrieve
>> the cached lbas and form a new bio, which is submitted =
_synchronously_
>> to the media using struct completion. The original bio is then =
populated
>> with the read data.
>>=20
>> What lockdep complains about, is that the unlocking operation in
>> complete() has a circular dependency with ionode->i_rwsem when they =
both
>> happen on the same core, which is different from the core that issued
>> wait_for_completion_io_timeout() and is waiting for the partial read.
>> However, AFAIU complete() happens in interrupt context, so this =
should
>> not be a problem.
>>=20
>> The only thing I can think of is that XFS is making an assumption =
when
>> submitting direct I/O that there will be no synchronous I/O coming =
from
>> anybody underneath.
>>=20
>> Any thoughts?
>=20
> The new lockdep completion tracking that was included in 4.14 can
> throw false positives because it doesn't (yet) have the capability
> to understand the multiply layered completion contexts we have in
> the storage stack.
>=20
> Peter, here's another for you to ponder....
>=20
>> TRACE:
>> [ 8557.938336] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [ 8557.944513] WARNING: possible circular locking dependency detected
>> [ 8557.950688] 4.14.0-rc2--509811f1f2df #726 Not tainted
>> [ 8557.955739] ------------------------------------------------------
>> [ 8557.961919] rocksdb:bg11/19129 is trying to acquire lock:
>> [ 8557.967319]  (&inode->i_rwsem){++++}, at: [<ffffffffad5648d1>] =
xfs_ilock+0x1a1/0x230
>> [ 8557.975063]
>>               but now in release context of a crosslock acquired at =
the following:
>> [ 8557.983921]  ((complete)&wait#5){+.+.}, at: [<ffffffffad933d0a>] =
pblk_fill_partial_read_bio+0x22a/0x520
>> [ 8557.993318]
>>               which lock already depends on the new lock.
>>=20
>> [ 8558.001490]
>>               the existing dependency chain (in reverse order) is:
>> [ 8558.008966]
>>               -> #1 ((complete)&wait#5){+.+.}:
>> [ 8558.014715]        __lock_acquire+0x1186/0x11d0
>> [ 8558.019245]        lock_acquire+0xed/0x1e0
>> [ 8558.023337]        wait_for_completion_io_timeout+0x65/0x180
>> [ 8558.028989]        pblk_fill_partial_read_bio+0x22a/0x520
>> [ 8558.034375]        pblk_submit_read+0x158/0x3a0
>> [ 8558.038900]        pblk_make_rq+0xc1/0x110
>> [ 8558.042992]        generic_make_request+0x11d/0x3c0
>> [ 8558.047862]        submit_bio+0x73/0x140
>> [ 8558.051781]        iomap_dio_actor+0x1f8/0x3a0
>> [ 8558.056216]        iomap_apply+0xa1/0x110
>> [ 8558.060220]        iomap_dio_rw+0x26f/0x3c0
>> [ 8558.064398]        xfs_file_dio_aio_read+0x88/0x1c0
>> [ 8558.069269]        xfs_file_read_iter+0xab/0xc0
>> [ 8558.073794]        __vfs_read+0xef/0x160
>> [ 8558.077709]        vfs_read+0xa8/0x150
>> [ 8558.081454]        SyS_pread64+0x98/0xc0
>> [ 8558.085372]        entry_SYSCALL_64_fastpath+0x23/0xc2
>=20
> This is completely normal, blocked on a bio completion with a
> filesystem lock held. More commonly we see this sort of thing
> through through submit_bio_wait().

Yes. We do the same construct in pblk.

>=20
>> [ 8558.125636]  Possible unsafe locking scenario by crosslock:
>>=20
>> [ 8558.132672]        CPU0                    CPU1
>> [ 8558.137196]        ----                    ----
>> [ 8558.141720]   lock(&inode->i_rwsem);
>> [ 8558.145291]   lock((complete)&wait#5);
>> [ 8558.149035]                                lock(&inode->i_rwsem);
>> [ 8558.155118]                                =
unlock((complete)&wait#5);
>> [ 8558.161550]
>>                *** DEADLOCK ***
>>=20
>> [ 8558.167461] 4 locks held by rocksdb:bg11/19129:
>> [ 8558.171984]  #0:  (&inode->i_rwsem){++++}, at: =
[<ffffffffad5648d1>] xfs_ilock+0x1a1/0x230
>> [ 8558.180148]  #1:  (rcu_read_lock){....}, at: [<ffffffffad72b8cc>] =
__blk_mq_run_hw_queue+0xec/0x1d0
>> [ 8558.189091]  #2:  (&(&nvmeq->q_lock)->rlock){-.-.}, at: =
[<ffffffffad9d438c>] nvme_queue_rq+0x14c/0x9a0
>> [ 8558.198384]  #3:  (&x->wait#17){-.-.}, at: [<ffffffffad16444d>] =
complete+0x1d/0x60
>> [ 8558.205948]
>>               stack backtrace:
>> [ 8558.210300] CPU: 6 PID: 19129 Comm: rocksdb:bg11 Not tainted =
4.14.0-rc2--509811f1f2df #726
>> [ 8558.218550] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a =
06/23/2016
>> [ 8558.225675] Call Trace:
>> [ 8558.228123]  dump_stack+0x85/0xc7
>> [ 8558.231438]  print_circular_bug+0x226/0x330
>> [ 8558.235616]  ? print_bfs_bug+0x40/0x40
>> [ 8558.239358]  check_prev_add+0x432/0x840
>> [ 8558.243190]  ? __lock_acquire+0x736/0x11d0
>> [ 8558.247282]  lock_commit_crosslock+0x3d3/0x5d0
>> [ 8558.251718]  ? lock_commit_crosslock+0x3d3/0x5d0
>> [ 8558.256328]  complete+0x29/0x60
>> [ 8558.259469]  pblk_end_io_sync+0x12/0x20
>> [ 8558.263297]  nvm_end_io+0x2b/0x30
>> [ 8558.266607]  nvme_nvm_end_io+0x2e/0x50
>=20
> And this is where lockdep gets confused. Up until this point, it's
> only ever seen the bio completion come from /outside/ the XFS
> i_rwsem context (i.e. async completion form interupts). With a
> synchronous completion like this, the completion has now been done
> from inside the i_rwsem context and that is what triggers lockdep.
>=20
> This is safe to do because even if we have a bio blocked on a
> completion queue, we've got all we way down to this complete() call
> from a *different bio context* inside a read locked i_rwsem. Hence
> there's no way this can be a deadlock even if the two processes are
> holding the same i_rwsem.
>=20
> Therefore: false positive.

Thanks for the explanation Dave. I could not see how waiting for a
struct complete under generic_make_request could in anyway interleave
with a FS lock, but it is good to have it confirmed.

Javier.




--Apple-Mail=_B5987310-BEDF-46C2-A380-7DE5AC0BF175
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEm1mT7zen+vs9+T8kYx8FO3WZGMoFAlnXKCwACgkQYx8FO3WZ
GMrvDhAA5ZLqOu0b28yvCPf6K7Z7hISWcMBRIJc/HegbEjHBvB1jGUMbw+ceKcj4
7rfppcp7AuCcLeeJ1QawQxRVaSdXVgKr2KoYAJguIjXBdy9ynVgoMWkFH0PdL/0/
wrkoFYo5iPW20es3IwJM64oxAX5+i9+/uq8zS5YZ2AVf97ZBzlcUlCATWtZ1trBe
tN/LChgt+ipcQNeoEOjuk9iPRiijo2E7NxPyUuPq3VehsoZDC9j8TcL4JrGxd1jl
Uud2sXQlZ7tRlKg6S8om+Xa41Yl7QH/C88elt73AHItcwW0WJkdjcjLMYacQC01f
Ub3O/wub18XbGzKMPqv3du6jFA9QN19zhKKqed30jWa84LOVbelGe6GM8T7REvCy
UNobz/dRHaGmeoxBkMDQfpB+pZUVEXEXsz4sLQGxepXqaWzdCENTBOjpIPFcuD4y
afiBlv9HMYE0peVxZCnsFL5YRwrXixFRcrCCuRxWHOxevRpPIyypUXTy/FoWw5a/
Cbb5/UW62fz64FC8oRx8qTxOWuiVm4DdcxAnS6DCitkm1TKxjClffOPVqZB4niMr
OizeGkXGLxxfZuEULxkenN45Io56dlUzawsRxJkpfH6EulcVLMWDQXybtRiosT+N
BCLWMykhOcDnntqyS0P8H19gGSKYrEJvsCM0Xo4ytImCOQoEi1o=
=Ksk+
-----END PGP SIGNATURE-----

--Apple-Mail=_B5987310-BEDF-46C2-A380-7DE5AC0BF175--
