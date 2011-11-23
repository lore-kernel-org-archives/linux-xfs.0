Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pANJgW1o232231 for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 13:42:33 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85A3616DDF0B
	for <xfs@oss.sgi.com>; Wed, 23 Nov 2011 11:42:30 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id KaG49PfO3B1l5nmX for <xfs@oss.sgi.com>;
	Wed, 23 Nov 2011 11:42:30 -0800 (PST)
Date: Thu, 24 Nov 2011 06:42:16 +1100
From: NeilBrown <neilb@suse.de>
Subject: Re: [REVIEW] xfssyncd lost wakes circa 2.6.32
Message-ID: <20111124064216.5ff54077@notabene.brown>
In-Reply-To: <20111123163046.GQ29840@sgi.com>
References: <20111123163046.GQ29840@sgi.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7799877841297316441=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: nfbrown@suse.com, Alex Elder <elder@linux.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, ataschner@novell.com

--===============7799877841297316441==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/gJrYk2zTA4tH_.Q47TsKSqF"; protocol="application/pgp-signature"

--Sig_/gJrYk2zTA4tH_.Q47TsKSqF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 10:30:46 -0600 Ben Myers <bpm@sgi.com> wrote:

> Hi,
>=20
> I'd like to request a review for this patch.  This is related to ENOSPC
> condition and also project quotas, where we call xfs_flush_inodes from
> xfs_iomap_write_delay.  Neil and Andreas did some very heavy lifting on
> this bug (suse 722910) and found that there is a repeatable ~30ish
> second delay in xfs_write that is related to xfssyncd at ENOSPC.  From
> there I captured the interaction in this trace:
>=20
> Nov 22 15:06:39 nfs4 kernel: [  478.757337] 5571: xfs_flush_inodes (sdb1)=
 start
> Nov 22 15:06:39 nfs4 kernel: [  478.757338] 5571: xfs_syncd_queue_work (s=
db1) start
> Nov 22 15:06:39 nfs4 kernel: [  478.757341] 5571: xfs_syncd_queue_work (s=
db1) end
> Nov 22 15:06:39 nfs4 kernel: [  478.757344] 1767: xfssyncd awake
> Nov 22 15:06:39 nfs4 kernel: [  478.757346] 1767: xfs_flush_inodes_work (=
sdb1) start
> Nov 22 15:06:39 nfs4 kernel: [  478.757352] 1767: xfs_flush_inodes_work (=
sdb1) end
> Nov 22 15:06:40 nfs4 kernel: [  478.757357] 5571: xfs_flush_inodes (sdb1)=
 end
> Nov 22 15:06:40 nfs4 kernel: [  478.757367] 5571: xfs_flush_inodes (sdb1)=
 start
> Nov 22 15:06:40 nfs4 kernel: [  478.757368] 5571: xfs_syncd_queue_work (s=
db1) start
> Nov 22 15:06:40 nfs4 kernel: [  478.757370] 5571: xfs_syncd_queue_work (s=
db1) end
> Nov 22 15:06:40 nfs4 kernel: [  478.757394] 1767: xfssyncd go to sleep
> Nov 22 15:06:40 nfs4 kernel: [  508.708008] 830: xfssyncd awake
> Nov 22 15:06:40 nfs4 kernel: [  508.708011] 830 xfs_sync_worker (sda3) st=
art
> Nov 22 15:06:40 nfs4 kernel: [  508.708016] 830 xfs_sync_worker (sda3) end
> Nov 22 15:06:40 nfs4 kernel: [  508.708018] 830: xfssyncd go to sleep
> Nov 22 15:06:40 nfs4 kernel: [  514.664300] 1767: xfssyncd awake
> Nov 22 15:06:40 nfs4 kernel: [  514.664303] 1767: xfs_flush_inodes_work (=
sdb1) start
> Nov 22 15:06:40 nfs4 kernel: [  514.664317] 1767: xfs_flush_inodes_work (=
sdb1) end
> Nov 22 15:06:40 nfs4 kernel: [  514.664322] 1767 xfs_sync_worker (sdb1) s=
tart
> Nov 22 15:06:40 nfs4 kernel: [  514.664324] 5571: xfs_flush_inodes (sdb1)=
 end
> Nov 22 15:06:40 nfs4 kernel: [  514.664330] 1767 xfs_sync_worker (sdb1) e=
nd
> Nov 22 15:06:40 nfs4 kernel: [  514.664332] 1767: xfssyncd go to sleep
> Nov 22 15:06:40 nfs4 kernel: [  514.664349] 5091ef25 35s 907016877s
>                                             ^^^ xid  ^^^^^^ service time =
delay in nfsd_vfs_write
>=20
> Note that xfssyncd was going to sleep at 478.757394, even though work
> had just been queued.  It looks to me like xfs_syncd_queue_work can try
> to wake xfssyncd when it's already running, and xfssyncd can
> subsequently go back to sleep, holding off the xfs_flush_inodes_work
> until the timer pops again.  David has already rewritten this subsystem
> using work queues, but I'd rather fix this very specific issue for
> support purposes than backport a new implementation.
>=20
> To fix this we need to check m_sync_list under lock and only sleep if it
> is empty.  Also set TASK_INTERRUPTIBLE before the check so that if we're
> woken we won't sleep either.  This is discussed here:
>=20
> http://www.linuxjournal.com/node/8144/print
>=20
> I'm also adding work items to the tail of the temp list so that they are
> processed in the order they were added.  My testing of this patch shows
> that the ~30s delay is gone, but I did see a ~2s delay in there
> occasionally.
>=20
> Thanks!
> -Ben
>=20
> Index: linux/fs/xfs/linux-2.6/xfs_sync.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/fs/xfs/linux-2.6/xfs_sync.c
> +++ linux/fs/xfs/linux-2.6/xfs_sync.c
> @@ -620,13 +620,25 @@ xfssyncd(
>  	set_freezable();
>  	timeleft =3D xfs_syncd_centisecs * msecs_to_jiffies(10);
>  	for (;;) {
> -		timeleft =3D schedule_timeout_interruptible(timeleft);
> -		/* swsusp */
> -		try_to_freeze();
> -		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		spin_lock(&mp->m_sync_lock);
> +
> +		if (list_empty(&mp->m_sync_list) && !kthread_should_stop()) {
> +			spin_unlock(&mp->m_sync_lock);
> +
> +			timeleft =3D schedule_timeout_interruptible(timeleft);

This should be just "schedule_timeout(timeleft)".
This call sets TASK_INTERRUPTIBLE so we will go to sleep even if we were
only just woken up.

I don't really know the XFS code well enough to the rest looks right, but
with that small fix it certainly doesn't look wrong :-)

NeilBrown


> +			/* swsusp */
> +			try_to_freeze();
> +
> +			spin_lock(&mp->m_sync_lock);
> +		}
> +		set_current_state(TASK_RUNNING);
> +
> +		if (kthread_should_stop() && list_empty(&mp->m_sync_list)) {
> +			spin_unlock(&mp->m_sync_lock);
>  			break;
> +		}
> =20
> -		spin_lock(&mp->m_sync_lock);
>  		/*
>  		 * We can get woken by laptop mode, to do a sync -
>  		 * that's the (only!) case where the list would be
> @@ -641,7 +653,7 @@ xfssyncd(
>  					&mp->m_sync_list);
>  		}
>  		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
> -			list_move(&work->w_list, &tmp);
> +			list_move_tail(&work->w_list, &tmp);
>  		spin_unlock(&mp->m_sync_lock);
> =20
>  		list_for_each_entry_safe(work, n, &tmp, w_list) {
>=20
>=20


--Sig_/gJrYk2zTA4tH_.Q47TsKSqF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTs1MmDnsnt1WYoG5AQIzMg//RzqUYSPXyqyDP6g7OnXa+mI4RzLPpCVK
hcFPGOR1NiSAOfTquLK0RdT29kxiYVR2NbSmHOyblMbgPhxf43Hikpouf+LM7rKS
XSHPsjQ47ONUrjeHd2YvMzaFgy2zrxRkGF2e/EvpfG9dfPQPQGPS3f/EKw/6MOug
L6oWD6JD40/5F5kCTVPaG5gyO3GruokSJ4hKmuMu1SOJ/l4jlniFxRHnyqdmCXEn
TPUwqO0YPqgo+98zVcmVAd2WgoUPYPFOWrDRKSDHhdmXxU3YRUe4RBAphStx+z5e
co3cSkymMwVxWZn/4S2/wcNF3VhtNuRupx+YB1qtbBhcyfGL/eAFrDkvJEtw9IIm
sHc51z1ip8oMNahBfZnr7nobdxFKFLW1GvMWw/hsJiKYUY/vbQFHgo0fkRu1dUl4
bvJdJ+zZNEk8zfEd8ozcnLwxgVfoRlaZBF3DNzzA9qO+iRypHS7k4TNpHQKf194/
Herw+FHw5WAov1TnNboE/7aIOWCBh9sG8HMoq93M3536f74EKSFc9l4kKfvYQlBb
beDfVWHhu7ujl9wGQ2Q/qxYWtzRIQEzZynkARbOB6y2/h0TcLb4FoLzdzhpMNZiL
SWiUg6TGE0tN8rZZqtwtA7SVbZVdDEJsaLcLErJQFWQ/59zdMw2Uit6T0GJKJGvW
ZVqJTgj2KFg=
=TlNj
-----END PGP SIGNATURE-----

--Sig_/gJrYk2zTA4tH_.Q47TsKSqF--


--===============7799877841297316441==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7799877841297316441==--
