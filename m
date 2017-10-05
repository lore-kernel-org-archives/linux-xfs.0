Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:49895 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbdJEQoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2017 12:44:11 -0400
Received: by mail-lf0-f54.google.com with SMTP id c82so13794901lfc.6
        for <linux-xfs@vger.kernel.org>; Thu, 05 Oct 2017 09:44:10 -0700 (PDT)
From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <jg@lightnvm.io>
Message-Id: <EA950BBA-ADA7-43FD-8B29-61BF556E6A29@lightnvm.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_81F2408D-34EB-4FDC-BD0E-A5B13B2B753C";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: Circular locking dependency with pblk
Date: Thu, 5 Oct 2017 18:44:06 +0200
In-Reply-To: <daf6d403-1199-b5d8-2e35-59f361ed1360@kernel.dk>
References: <84EF6A42-AE7A-40B5-AB00-5E4A1617C41E@lightnvm.io>
 <daf6d403-1199-b5d8-2e35-59f361ed1360@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, darrick.wong@oracle.com, Christoph Hellwig <hch@infradead.org>


--Apple-Mail=_81F2408D-34EB-4FDC-BD0E-A5B13B2B753C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

> On 5 Oct 2017, at 18.24, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> On 10/05/2017 04:53 AM, Javier Gonz=C3=A1lez wrote:
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
>=20
> But the very trace you are posting shows the completion being down
> inline, since we catch it at submission time:
>=20
>> [ 8558.256328]  complete+0x29/0x60
>> [ 8558.259469]  pblk_end_io_sync+0x12/0x20
>> [ 8558.263297]  nvm_end_io+0x2b/0x30
>> [ 8558.266607]  nvme_nvm_end_io+0x2e/0x50
>> [ 8558.270351]  blk_mq_end_request+0x3e/0x70
>> [ 8558.274360]  nvme_complete_rq+0x1c/0xd0
>> [ 8558.278194]  nvme_pci_complete_rq+0x7b/0x130
>> [ 8558.282459]  __blk_mq_complete_request+0xa3/0x160
>> [ 8558.287156]  blk_mq_complete_request+0x16/0x20
>> [ 8558.291592]  nvme_process_cq+0xf8/0x1e0
>> [ 8558.295424]  nvme_queue_rq+0x16e/0x9a0
>> [ 8558.299172]  blk_mq_dispatch_rq_list+0x19e/0x330
>> [ 8558.303787]  ? blk_mq_flush_busy_ctxs+0x91/0x130
>> [ 8558.308400]  blk_mq_sched_dispatch_requests+0x19d/0x1d0
>> [ 8558.313617]  __blk_mq_run_hw_queue+0x12e/0x1d0
>> [ 8558.318053]  __blk_mq_delay_run_hw_queue+0xb9/0xd0
>> [ 8558.322837]  blk_mq_run_hw_queue+0x14/0x20
>> [ 8558.326928]  blk_mq_sched_insert_request+0xa4/0x180
>> [ 8558.331797]  blk_execute_rq_nowait+0x72/0xf0
>> [ 8558.336061]  nvme_nvm_submit_io+0xd9/0x130
>> [ 8558.340151]  nvm_submit_io+0x3c/0x70
>> [ 8558.343723]  pblk_submit_io+0x1b/0x20> [ 8558.347379]  =
pblk_submit_read+0x1ec/0x3a0
>=20
> [snip]
>=20
> This happens since we call nvme_process_cq() after submitting IO,
> just in case there's something we can complete.
>=20

Hmm. It's still interesting that the FS is allowed to take the
rw_semaphore before we get to fully complete the read bio in pblk. I'll
look into it tomorrow.

 Also, is it normal that we switch core when calling nvme_process_cq()
 on the submission path?

Javier

--Apple-Mail=_81F2408D-34EB-4FDC-BD0E-A5B13B2B753C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEm1mT7zen+vs9+T8kYx8FO3WZGMoFAlnWYVYACgkQYx8FO3WZ
GMor9g//XQR0tG78nSLObaHrdJawe6KXmacAN+jkxIuM9MI+Vzy+e2YPjfcMKxW4
THzOUXNvK5eT5jg0TtUYt9ke/bUivVZOGJVMBZ2MnkNGDbhAFIPgny89ufD4PHA9
F2ESTao8dAS6Raof+o4bpQA6YMixS+GJdM5h3GhO3ptlJnlcp0CRtm/wHUMKLpBj
DhUwhYXLD6EugYvBt3Ol5Gd7qY3LUzxoTPxAhFJgr0/JXh8BUMY4zyNGVx+GVNxN
a00X1rbVreWFgOibz0OChZOqtVUlmu8tYPJYmNUEbfXln6EwlRhlniWVV3IVFEmL
c3wh7N/GTUREbKg195lxy4Hk3X9AU+PQoL2uwP+WoBZrzmQsEHKDmLvdi/rz/yvM
RsltVm3UAWW25IKNzJFaescYyJ7aPOmcC5k4IOJNJMHPCiqPhyBuSXmVBt2cXGXl
SID/BdJmNPoWpIZLtfeVfLl0+9uTRjiMgIb6w4p3Jr7A3fv7J6Dr4aDCp6dvoatA
Wsj+SYrpVqqUPoUkX6UfO9uXoUdchjaPUYbGkmqCSLrVyFdvEQxocNlNUE4rbGbA
OUB9ZRecgekRnD5BAdAJEyv2SsOx4NLeE7Cpt/dhjdVeSXiPH2jgwk9+mv0uVMjQ
Ax9gbTg5UekO5y6lggfO4GxuGBmLyZCg427QLa69ZVzf/t1VR04=
=yrpD
-----END PGP SIGNATURE-----

--Apple-Mail=_81F2408D-34EB-4FDC-BD0E-A5B13B2B753C--
