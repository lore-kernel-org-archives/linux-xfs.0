Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-bn3nam01on0046.outbound.protection.outlook.com ([104.47.33.46]:7344
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751172AbeEVKKX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 06:10:23 -0400
From: Javier Gonzalez <javier@cnexlabs.com>
Subject: Re: [PATCH 04/12] lightnvm: convert to bioset_init()/mempool_init()
Date: Tue, 22 May 2018 10:10:13 +0000
Message-ID: <84EF687A-078F-4807-A667-39A8A91D48D0@cnexlabs.com>
References: <20180520222558.7053-1-kent.overstreet@gmail.com>
 <20180520222558.7053-5-kent.overstreet@gmail.com>
In-Reply-To: <20180520222558.7053-5-kent.overstreet@gmail.com>
Content-Language: en-US
Content-Type: multipart/signed;
        boundary="Apple-Mail=_D7977032-5A8D-4CA1-930F-7A6C48C19BE4";
        protocol="application/pgp-signature"; micalg=pgp-sha512
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, "colyli@suse.de" <colyli@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "clm@fb.com" <clm@fb.com>, "bacik@fb.com" <bacik@fb.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>

--Apple-Mail=_D7977032-5A8D-4CA1-930F-7A6C48C19BE4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

> On 21 May 2018, at 00.25, Kent Overstreet <kent.overstreet@gmail.com> =
wrote:
>=20
> Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
> ---
> drivers/lightnvm/pblk-core.c     | 30 ++++++-------
> drivers/lightnvm/pblk-init.c     | 72 ++++++++++++++++----------------
> drivers/lightnvm/pblk-read.c     |  4 +-
> drivers/lightnvm/pblk-recovery.c |  2 +-
> drivers/lightnvm/pblk-write.c    |  8 ++--
> drivers/lightnvm/pblk.h          | 14 +++----
> 6 files changed, 65 insertions(+), 65 deletions(-)
>=20
> diff --git a/drivers/lightnvm/pblk-core.c =
b/drivers/lightnvm/pblk-core.c
> index 94d5d97c9d..934341b104 100644
> --- a/drivers/lightnvm/pblk-core.c
> +++ b/drivers/lightnvm/pblk-core.c
> @@ -40,7 +40,7 @@ static void pblk_line_mark_bb(struct work_struct =
*work)
> 	}
>=20
> 	kfree(ppa);
> -	mempool_free(line_ws, pblk->gen_ws_pool);
> +	mempool_free(line_ws, &pblk->gen_ws_pool);
> }
>=20
> static void pblk_mark_bb(struct pblk *pblk, struct pblk_line *line,
> @@ -102,7 +102,7 @@ static void pblk_end_io_erase(struct nvm_rq *rqd)
> 	struct pblk *pblk =3D rqd->private;
>=20
> 	__pblk_end_io_erase(pblk, rqd);
> -	mempool_free(rqd, pblk->e_rq_pool);
> +	mempool_free(rqd, &pblk->e_rq_pool);
> }
>=20
> /*
> @@ -237,15 +237,15 @@ struct nvm_rq *pblk_alloc_rqd(struct pblk *pblk, =
int type)
> 	switch (type) {
> 	case PBLK_WRITE:
> 	case PBLK_WRITE_INT:
> -		pool =3D pblk->w_rq_pool;
> +		pool =3D &pblk->w_rq_pool;
> 		rq_size =3D pblk_w_rq_size;
> 		break;
> 	case PBLK_READ:
> -		pool =3D pblk->r_rq_pool;
> +		pool =3D &pblk->r_rq_pool;
> 		rq_size =3D pblk_g_rq_size;
> 		break;
> 	default:
> -		pool =3D pblk->e_rq_pool;
> +		pool =3D &pblk->e_rq_pool;
> 		rq_size =3D pblk_g_rq_size;
> 	}
>=20
> @@ -265,13 +265,13 @@ void pblk_free_rqd(struct pblk *pblk, struct =
nvm_rq *rqd, int type)
> 	case PBLK_WRITE:
> 		kfree(((struct pblk_c_ctx =
*)nvm_rq_to_pdu(rqd))->lun_bitmap);
> 	case PBLK_WRITE_INT:
> -		pool =3D pblk->w_rq_pool;
> +		pool =3D &pblk->w_rq_pool;
> 		break;
> 	case PBLK_READ:
> -		pool =3D pblk->r_rq_pool;
> +		pool =3D &pblk->r_rq_pool;
> 		break;
> 	case PBLK_ERASE:
> -		pool =3D pblk->e_rq_pool;
> +		pool =3D &pblk->e_rq_pool;
> 		break;
> 	default:
> 		pr_err("pblk: trying to free unknown rqd type\n");
> @@ -292,7 +292,7 @@ void pblk_bio_free_pages(struct pblk *pblk, struct =
bio *bio, int off,
>=20
> 	for (i =3D off; i < nr_pages + off; i++) {
> 		bv =3D bio->bi_io_vec[i];
> -		mempool_free(bv.bv_page, pblk->page_bio_pool);
> +		mempool_free(bv.bv_page, &pblk->page_bio_pool);
> 	}
> }
>=20
> @@ -304,12 +304,12 @@ int pblk_bio_add_pages(struct pblk *pblk, struct =
bio *bio, gfp_t flags,
> 	int i, ret;
>=20
> 	for (i =3D 0; i < nr_pages; i++) {
> -		page =3D mempool_alloc(pblk->page_bio_pool, flags);
> +		page =3D mempool_alloc(&pblk->page_bio_pool, flags);
>=20
> 		ret =3D bio_add_pc_page(q, bio, page, =
PBLK_EXPOSED_PAGE_SIZE, 0);
> 		if (ret !=3D PBLK_EXPOSED_PAGE_SIZE) {
> 			pr_err("pblk: could not add page to bio\n");
> -			mempool_free(page, pblk->page_bio_pool);
> +			mempool_free(page, &pblk->page_bio_pool);
> 			goto err;
> 		}
> 	}
> @@ -1593,7 +1593,7 @@ static void pblk_line_put_ws(struct work_struct =
*work)
> 	struct pblk_line *line =3D line_put_ws->line;
>=20
> 	__pblk_line_put(pblk, line);
> -	mempool_free(line_put_ws, pblk->gen_ws_pool);
> +	mempool_free(line_put_ws, &pblk->gen_ws_pool);
> }
>=20
> void pblk_line_put(struct kref *ref)
> @@ -1610,7 +1610,7 @@ void pblk_line_put_wq(struct kref *ref)
> 	struct pblk *pblk =3D line->pblk;
> 	struct pblk_line_ws *line_put_ws;
>=20
> -	line_put_ws =3D mempool_alloc(pblk->gen_ws_pool, GFP_ATOMIC);
> +	line_put_ws =3D mempool_alloc(&pblk->gen_ws_pool, GFP_ATOMIC);
> 	if (!line_put_ws)
> 		return;
>=20
> @@ -1752,7 +1752,7 @@ void pblk_line_close_ws(struct work_struct =
*work)
> 	struct pblk_line *line =3D line_ws->line;
>=20
> 	pblk_line_close(pblk, line);
> -	mempool_free(line_ws, pblk->gen_ws_pool);
> +	mempool_free(line_ws, &pblk->gen_ws_pool);
> }
>=20
> void pblk_gen_run_ws(struct pblk *pblk, struct pblk_line *line, void =
*priv,
> @@ -1761,7 +1761,7 @@ void pblk_gen_run_ws(struct pblk *pblk, struct =
pblk_line *line, void *priv,
> {
> 	struct pblk_line_ws *line_ws;
>=20
> -	line_ws =3D mempool_alloc(pblk->gen_ws_pool, gfp_mask);
> +	line_ws =3D mempool_alloc(&pblk->gen_ws_pool, gfp_mask);
>=20
> 	line_ws->pblk =3D pblk;
> 	line_ws->line =3D line;
> diff --git a/drivers/lightnvm/pblk-init.c =
b/drivers/lightnvm/pblk-init.c
> index 91a5bc2556..9a984abd3d 100644
> --- a/drivers/lightnvm/pblk-init.c
> +++ b/drivers/lightnvm/pblk-init.c
> @@ -23,7 +23,7 @@
> static struct kmem_cache *pblk_ws_cache, *pblk_rec_cache, =
*pblk_g_rq_cache,
> 				*pblk_w_rq_cache;
> static DECLARE_RWSEM(pblk_lock);
> -struct bio_set *pblk_bio_set;
> +struct bio_set pblk_bio_set;
>=20
> static int pblk_rw_io(struct request_queue *q, struct pblk *pblk,
> 			  struct bio *bio)
> @@ -341,7 +341,7 @@ static int pblk_core_init(struct pblk *pblk)
> {
> 	struct nvm_tgt_dev *dev =3D pblk->dev;
> 	struct nvm_geo *geo =3D &dev->geo;
> -	int max_write_ppas;
> +	int ret, max_write_ppas;
>=20
> 	atomic64_set(&pblk->user_wa, 0);
> 	atomic64_set(&pblk->pad_wa, 0);
> @@ -375,33 +375,33 @@ static int pblk_core_init(struct pblk *pblk)
> 		goto fail_free_pad_dist;
>=20
> 	/* Internal bios can be at most the sectors signaled by the =
device. */
> -	pblk->page_bio_pool =3D mempool_create_page_pool(NVM_MAX_VLBA, =
0);
> -	if (!pblk->page_bio_pool)
> +	ret =3D mempool_init_page_pool(&pblk->page_bio_pool, =
NVM_MAX_VLBA, 0);
> +	if (ret)
> 		goto free_global_caches;
>=20
> -	pblk->gen_ws_pool =3D =
mempool_create_slab_pool(PBLK_GEN_WS_POOL_SIZE,
> -							pblk_ws_cache);
> -	if (!pblk->gen_ws_pool)
> +	ret =3D mempool_init_slab_pool(&pblk->gen_ws_pool, =
PBLK_GEN_WS_POOL_SIZE,
> +				     pblk_ws_cache);
> +	if (ret)
> 		goto free_page_bio_pool;
>=20
> -	pblk->rec_pool =3D mempool_create_slab_pool(geo->all_luns,
> -							pblk_rec_cache);
> -	if (!pblk->rec_pool)
> +	ret =3D mempool_init_slab_pool(&pblk->rec_pool, geo->all_luns,
> +				     pblk_rec_cache);
> +	if (ret)
> 		goto free_gen_ws_pool;
>=20
> -	pblk->r_rq_pool =3D mempool_create_slab_pool(geo->all_luns,
> -							=
pblk_g_rq_cache);
> -	if (!pblk->r_rq_pool)
> +	ret =3D mempool_init_slab_pool(&pblk->r_rq_pool, geo->all_luns,
> +				     pblk_g_rq_cache);
> +	if (ret)
> 		goto free_rec_pool;
>=20
> -	pblk->e_rq_pool =3D mempool_create_slab_pool(geo->all_luns,
> -							=
pblk_g_rq_cache);
> -	if (!pblk->e_rq_pool)
> +	ret =3D mempool_init_slab_pool(&pblk->e_rq_pool, geo->all_luns,
> +				     pblk_g_rq_cache);
> +	if (ret)
> 		goto free_r_rq_pool;
>=20
> -	pblk->w_rq_pool =3D mempool_create_slab_pool(geo->all_luns,
> -							=
pblk_w_rq_cache);
> -	if (!pblk->w_rq_pool)
> +	ret =3D mempool_init_slab_pool(&pblk->w_rq_pool, geo->all_luns,
> +				     pblk_w_rq_cache);
> +	if (ret)
> 		goto free_e_rq_pool;
>=20
> 	pblk->close_wq =3D alloc_workqueue("pblk-close-wq",
> @@ -433,17 +433,17 @@ static int pblk_core_init(struct pblk *pblk)
> free_close_wq:
> 	destroy_workqueue(pblk->close_wq);
> free_w_rq_pool:
> -	mempool_destroy(pblk->w_rq_pool);
> +	mempool_exit(&pblk->w_rq_pool);
> free_e_rq_pool:
> -	mempool_destroy(pblk->e_rq_pool);
> +	mempool_exit(&pblk->e_rq_pool);
> free_r_rq_pool:
> -	mempool_destroy(pblk->r_rq_pool);
> +	mempool_exit(&pblk->r_rq_pool);
> free_rec_pool:
> -	mempool_destroy(pblk->rec_pool);
> +	mempool_exit(&pblk->rec_pool);
> free_gen_ws_pool:
> -	mempool_destroy(pblk->gen_ws_pool);
> +	mempool_exit(&pblk->gen_ws_pool);
> free_page_bio_pool:
> -	mempool_destroy(pblk->page_bio_pool);
> +	mempool_exit(&pblk->page_bio_pool);
> free_global_caches:
> 	pblk_free_global_caches(pblk);
> fail_free_pad_dist:
> @@ -462,12 +462,12 @@ static void pblk_core_free(struct pblk *pblk)
> 	if (pblk->bb_wq)
> 		destroy_workqueue(pblk->bb_wq);
>=20
> -	mempool_destroy(pblk->page_bio_pool);
> -	mempool_destroy(pblk->gen_ws_pool);
> -	mempool_destroy(pblk->rec_pool);
> -	mempool_destroy(pblk->r_rq_pool);
> -	mempool_destroy(pblk->e_rq_pool);
> -	mempool_destroy(pblk->w_rq_pool);
> +	mempool_exit(&pblk->page_bio_pool);
> +	mempool_exit(&pblk->gen_ws_pool);
> +	mempool_exit(&pblk->rec_pool);
> +	mempool_exit(&pblk->r_rq_pool);
> +	mempool_exit(&pblk->e_rq_pool);
> +	mempool_exit(&pblk->w_rq_pool);
>=20
> 	pblk_free_global_caches(pblk);
> 	kfree(pblk->pad_dist);
> @@ -1297,18 +1297,18 @@ static int __init pblk_module_init(void)
> {
> 	int ret;
>=20
> -	pblk_bio_set =3D bioset_create(BIO_POOL_SIZE, 0, 0);
> -	if (!pblk_bio_set)
> -		return -ENOMEM;
> +	ret =3D bioset_init(&pblk_bio_set, BIO_POOL_SIZE, 0, 0);
> +	if (ret)
> +		return ret;
> 	ret =3D nvm_register_tgt_type(&tt_pblk);
> 	if (ret)
> -		bioset_free(pblk_bio_set);
> +		bioset_exit(&pblk_bio_set);
> 	return ret;
> }
>=20
> static void pblk_module_exit(void)
> {
> -	bioset_free(pblk_bio_set);
> +	bioset_exit(&pblk_bio_set);
> 	nvm_unregister_tgt_type(&tt_pblk);
> }
>=20
> diff --git a/drivers/lightnvm/pblk-read.c =
b/drivers/lightnvm/pblk-read.c
> index 9eee10f69d..c844ffb6ae 100644
> --- a/drivers/lightnvm/pblk-read.c
> +++ b/drivers/lightnvm/pblk-read.c
> @@ -294,7 +294,7 @@ static int pblk_partial_read_bio(struct pblk =
*pblk, struct nvm_rq *rqd,
> 		kunmap_atomic(src_p);
> 		kunmap_atomic(dst_p);
>=20
> -		mempool_free(src_bv.bv_page, pblk->page_bio_pool);
> +		mempool_free(src_bv.bv_page, &pblk->page_bio_pool);
>=20
> 		hole =3D find_next_zero_bit(read_bitmap, nr_secs, hole + =
1);
> 	} while (hole < nr_secs);
> @@ -429,7 +429,7 @@ int pblk_submit_read(struct pblk *pblk, struct bio =
*bio)
> 		struct bio *int_bio =3D NULL;
>=20
> 		/* Clone read bio to deal with read errors internally */
> -		int_bio =3D bio_clone_fast(bio, GFP_KERNEL, =
pblk_bio_set);
> +		int_bio =3D bio_clone_fast(bio, GFP_KERNEL, =
&pblk_bio_set);
> 		if (!int_bio) {
> 			pr_err("pblk: could not clone read bio\n");
> 			goto fail_end_io;
> diff --git a/drivers/lightnvm/pblk-recovery.c =
b/drivers/lightnvm/pblk-recovery.c
> index 3e079c2afa..364ad52a5b 100644
> --- a/drivers/lightnvm/pblk-recovery.c
> +++ b/drivers/lightnvm/pblk-recovery.c
> @@ -60,7 +60,7 @@ void pblk_submit_rec(struct work_struct *work)
> 		goto err;
> 	}
>=20
> -	mempool_free(recovery, pblk->rec_pool);
> +	mempool_free(recovery, &pblk->rec_pool);
> 	return;
>=20
> err:
> diff --git a/drivers/lightnvm/pblk-write.c =
b/drivers/lightnvm/pblk-write.c
> index 3e6f1ebd74..aef7fa2d40 100644
> --- a/drivers/lightnvm/pblk-write.c
> +++ b/drivers/lightnvm/pblk-write.c
> @@ -122,7 +122,7 @@ static void pblk_end_w_fail(struct pblk *pblk, =
struct nvm_rq *rqd)
> 	if (unlikely(nr_ppas =3D=3D 1))
> 		ppa_list =3D &rqd->ppa_addr;
>=20
> -	recovery =3D mempool_alloc(pblk->rec_pool, GFP_ATOMIC);
> +	recovery =3D mempool_alloc(&pblk->rec_pool, GFP_ATOMIC);
>=20
> 	INIT_LIST_HEAD(&recovery->failed);
>=20
> @@ -134,7 +134,7 @@ static void pblk_end_w_fail(struct pblk *pblk, =
struct nvm_rq *rqd)
> 		/* Logic error */
> 		if (bit > c_ctx->nr_valid) {
> 			WARN_ONCE(1, "pblk: corrupted write request\n");
> -			mempool_free(recovery, pblk->rec_pool);
> +			mempool_free(recovery, &pblk->rec_pool);
> 			goto out;
> 		}
>=20
> @@ -142,7 +142,7 @@ static void pblk_end_w_fail(struct pblk *pblk, =
struct nvm_rq *rqd)
> 		entry =3D pblk_rb_sync_scan_entry(&pblk->rwb, &ppa);
> 		if (!entry) {
> 			pr_err("pblk: could not scan entry on write =
failure\n");
> -			mempool_free(recovery, pblk->rec_pool);
> +			mempool_free(recovery, &pblk->rec_pool);
> 			goto out;
> 		}
>=20
> @@ -156,7 +156,7 @@ static void pblk_end_w_fail(struct pblk *pblk, =
struct nvm_rq *rqd)
> 	ret =3D pblk_recov_setup_rq(pblk, c_ctx, recovery, comp_bits, =
c_entries);
> 	if (ret) {
> 		pr_err("pblk: could not recover from write failure\n");
> -		mempool_free(recovery, pblk->rec_pool);
> +		mempool_free(recovery, &pblk->rec_pool);
> 		goto out;
> 	}
>=20
> diff --git a/drivers/lightnvm/pblk.h b/drivers/lightnvm/pblk.h
> index 9c682acfc5..feafa4de26 100644
> --- a/drivers/lightnvm/pblk.h
> +++ b/drivers/lightnvm/pblk.h
> @@ -664,12 +664,12 @@ struct pblk {
>=20
> 	struct list_head compl_list;
>=20
> -	mempool_t *page_bio_pool;
> -	mempool_t *gen_ws_pool;
> -	mempool_t *rec_pool;
> -	mempool_t *r_rq_pool;
> -	mempool_t *w_rq_pool;
> -	mempool_t *e_rq_pool;
> +	mempool_t page_bio_pool;
> +	mempool_t gen_ws_pool;
> +	mempool_t rec_pool;
> +	mempool_t r_rq_pool;
> +	mempool_t w_rq_pool;
> +	mempool_t e_rq_pool;
>=20
> 	struct workqueue_struct *close_wq;
> 	struct workqueue_struct *bb_wq;
> @@ -841,7 +841,7 @@ void pblk_write_should_kick(struct pblk *pblk);
> /*
>  * pblk read path
>  */
> -extern struct bio_set *pblk_bio_set;
> +extern struct bio_set pblk_bio_set;
> int pblk_submit_read(struct pblk *pblk, struct bio *bio);
> int pblk_submit_read_gc(struct pblk *pblk, struct pblk_gc_rq *gc_rq);
> /*
> --
> 2.17.0

Looks like two patches in one, but the changes look good to me as part =
of
the series.

checkpatch complains on a couple of patches in the series. Nothing big,
but you probably want to have a look.

Reviewed-by: Javier Gonz=C3=A1lez <javier@cnexlabs.com>


--Apple-Mail=_D7977032-5A8D-4CA1-930F-7A6C48C19BE4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE+ws7Qq+qZPG1bJoyIX4xUKFRnnQFAlsD7IEACgkQIX4xUKFR
nnQJjw/+NH6iHDT0GWNvH1Sm+9q7oSCR3jKn6z1iWLSl1jn769+VPciqMkaSmFfD
DHQiZd1w2/jZTMOntnl862u6eOLggaZy3TS5GukpScd1JxshPeQzBpWRszsU6q9t
/nSroB9h/2TmvXr/MU5Am4JVxQuPHDdk7M5icx/Kqe9DT67V4SUZgPqcxNuwNcnZ
C/rwmH/Usm6KyDdPLyFoYGb3aXh/DsAOTCjfJgq+18sc2huA+s6NABfjr7ZdWszD
Th7vnlYxa0y6EkRivwFu4rwZc4K1km+GrfPsA1YnoZ5tEwoHb//oe6aUbM9JiBxX
lDiQH9M9i7HMG8f6XYfUjKD1ij6LVIry3upy/VwU2QP5Rq8B4vmnzFtP3mqKG7vN
K3fRWgjjggIH+P1us6RPrWeOYAOZ9OLc0u3X5vzL3pdA1DhoHYCx8wVhKpM4rPd6
BeivGn4jGU0kDS9i0rE6q1Vw+vcHWJOH4E0KaaiQKTlk5eCMZnEVgLay1V9GUZuZ
gGxJwn/NIYnrqOh3OVJJIoxjEXApEUXEUl0KOlEdu97/EuppHgX0sK73RXUpbMXH
ZUHER951lo72t4RL0UvJKRDPzg0rr/cQoynCWQiFiOyLLABzT20akFVoe+LKCnc8
2LgUL5NtaGXnewSgg8jexNJ/4xkaLA/I0dAsyoFxCqICq8K9eUY=
=aSf2
-----END PGP SIGNATURE-----

--Apple-Mail=_D7977032-5A8D-4CA1-930F-7A6C48C19BE4--
