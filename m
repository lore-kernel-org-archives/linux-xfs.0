Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4TDJX5f055532 for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:19:33 -0500
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2225F1A41256
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 06:19:43 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.168]) by cuda.sgi.com with ESMTP id
	eP5ue1zNqZK5EcN4 for <xfs@oss.sgi.com>;
	Fri, 29 May 2009 06:19:43 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so1932533wff.32
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 06:19:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090528121947.GB30037@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090528121947.GB30037@infradead.org>
Date: Fri, 29 May 2009 18:49:39 +0530
Message-ID: <921ca19c0905290619l46fa73abj380238058ce6efc6@mail.gmail.com>
Subject: Re: [PATCH 9/7] xfs: remove SYNC_BDFLUSH
From: Sujit Karataparambil <sjt.kar@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi,
Newbie question?
Kindly tell me where this code is called from do you have pagedeamon
on vfs or is it some thing else?

Sorry for bothering you.

On Thu, May 28, 2009 at 5:49 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> SYNC_BDFLUSH is a leftover from IRIX and rather misnamed for todays
> code. =A0Make xfs_sync_fsdata and xfs_dq_sync use the SYNC_TRYLOCK flag
> for not blocking on logs just as the inode sync code already does.
>
> For xfs_sync_fsdata it's a trivial 1:1 replacement, but for xfs_qm_sync
> I use the opportunity to decouple the non-blocking lock case from the
> different flushing modes, similar to the inode sync code.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c =A0 =A0 =A0 =A02009-05-27 13:02:=
57.426938830 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c =A0 =A0 2009-05-27 13:07:53.227939055=
 +0200
> @@ -350,7 +350,7 @@ xfs_sync_fsdata(
> =A0 =A0 =A0 =A0 * If this is xfssyncd() then only sync the superblock if =
we can
> =A0 =A0 =A0 =A0 * lock it without sleeping and it is not pinned.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (flags & SYNC_BDFLUSH) {
> + =A0 =A0 =A0 if (flags & SYNC_TRYLOCK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ASSERT(!(flags & SYNC_WAIT));
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bp =3D xfs_getsb(mp, XFS_BUF_TRYLOCK);
> @@ -415,7 +415,7 @@ xfs_quiesce_data(
>
> =A0 =A0 =A0 =A0/* push non-blocking */
> =A0 =A0 =A0 =A0xfs_sync_data(mp, 0);
> - =A0 =A0 =A0 xfs_qm_sync(mp, SYNC_BDFLUSH);
> + =A0 =A0 =A0 xfs_qm_sync(mp, SYNC_TRYLOCK);
> =A0 =A0 =A0 =A0xfs_filestream_flush(mp);
>
> =A0 =A0 =A0 =A0/* push and block */
> @@ -565,8 +565,8 @@ xfs_sync_worker(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FO=
RCE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_reclaim_inodes(mp, XFS_IFLUSH_DELWRI_E=
LSE_ASYNC);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* dgc: errors ignored here */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_qm_sync(mp, SYNC_BDFLUSH);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_sync_fsdata(mp, SYNC_BDFLUSH);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_qm_sync(mp, SYNC_TRYLOCK);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 error =3D xfs_sync_fsdata(mp, SYNC_TRYLOCK);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (xfs_log_need_covered(mp))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D xfs_commit_dummy=
_trans(mp, XFS_LOG_FORCE);
> =A0 =A0 =A0 =A0}
> Index: xfs/fs/xfs/quota/xfs_qm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs.orig/fs/xfs/quota/xfs_qm.c =A0 =A0 =A02009-05-27 13:04:00.6078422=
93 +0200
> +++ xfs/fs/xfs/quota/xfs_qm.c =A0 2009-05-27 13:10:21.688940102 +0200
> @@ -905,11 +905,6 @@ xfs_qm_dqdetach(
> =A0 =A0 =A0 =A0}
> =A0}
>
> -/*
> - * This is called to sync quotas. We can be told to use non-blocking
> - * semantics by either the SYNC_BDFLUSH flag or the absence of the
> - * SYNC_WAIT flag.
> - */
> =A0int
> =A0xfs_qm_sync(
> =A0 =A0 =A0 =A0xfs_mount_t =A0 =A0 *mp,
> @@ -918,17 +913,13 @@ xfs_qm_sync(
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 recl, restarts;
> =A0 =A0 =A0 =A0xfs_dquot_t =A0 =A0 *dqp;
> =A0 =A0 =A0 =A0uint =A0 =A0 =A0 =A0 =A0 =A0flush_flags;
> - =A0 =A0 =A0 boolean_t =A0 =A0 =A0 nowait;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 error;
>
> =A0 =A0 =A0 =A0if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> + =A0 =A0 =A0 flush_flags =3D (flags & SYNC_WAIT) ? XFS_QMOPT_SYNC : XFS_=
QMOPT_DELWRI;
> =A0 =A0 =A0 =A0restarts =3D 0;
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* We won't block unless we are asked to.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 nowait =3D (boolean_t)(flags & SYNC_BDFLUSH || (flags & SYN=
C_WAIT) =3D=3D 0);
>
> =A0 again:
> =A0 =A0 =A0 =A0xfs_qm_mplist_lock(mp);
> @@ -948,18 +939,10 @@ xfs_qm_sync(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * don't 'seem' to be dirty. ie. don't acq=
uire dqlock.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * This is very similar to what xfs_sync d=
oes with inodes.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & SYNC_BDFLUSH) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (! XFS_DQ_IS_DIRTY(dqp))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & SYNC_TRYLOCK) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!XFS_DQ_IS_DIRTY(dqp))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nowait) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Try to acquire the dqu=
ot lock. We are NOT out of
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* lock order, but we jus=
t don't want to wait for this
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* lock, unless somebody =
wanted us to.
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (! xfs_qm_dqlock_nowait(=
dqp))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!xfs_qm_dqlock_nowait(d=
qp))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_dqlock(dqp);
> @@ -976,7 +959,7 @@ xfs_qm_sync(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* XXX a sentinel would be better */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0recl =3D XFS_QI_MPLRECLAIMS(mp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!xfs_dqflock_nowait(dqp)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nowait) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flags & SYNC_TRYLOCK) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_dqunlo=
ck(dqp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -994,7 +977,6 @@ xfs_qm_sync(
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * Let go of the mplist lock. We don't wan=
t to hold it
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * across a disk write
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 flush_flags =3D (nowait) ? XFS_QMOPT_DELWRI=
 : XFS_QMOPT_SYNC;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_qm_mplist_unlock(mp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0xfs_dqtrace_entry(dqp, "XQM_SYNC: DQFLUSH"=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D xfs_qm_dqflush(dqp, flush_flags);
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.h =A0 =A0 =A0 =A02009-05-27 13:07:=
58.997814418 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.h =A0 =A0 2009-05-27 13:08:19.922972203=
 +0200
> @@ -29,9 +29,8 @@ typedef struct xfs_sync_work {
> =A0 =A0 =A0 =A0struct completion =A0 =A0 =A0 *w_completion;
> =A0} xfs_sync_work_t;
>
> -#define SYNC_WAIT =A0 =A0 =A0 =A0 =A0 =A0 =A00x0004 =A0/* wait for i/o t=
o complete */
> -#define SYNC_BDFLUSH =A0 =A0 =A0 =A0 =A0 0x0008 =A0/* BDFLUSH is calling=
 -- don't block */
> -#define SYNC_TRYLOCK =A0 =A0 =A0 =A0 =A0 0x0020 =A0/* only try to lock i=
nodes */
> +#define SYNC_WAIT =A0 =A0 =A0 =A0 =A0 =A0 =A00x0001 =A0/* wait for i/o t=
o complete */
> +#define SYNC_TRYLOCK =A0 =A0 =A0 =A0 =A0 0x0002 =A0/* only try to lock i=
nodes */
>
> =A0int xfs_syncd_init(struct xfs_mount *mp);
> =A0void xfs_syncd_stop(struct xfs_mount *mp);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- =

-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
