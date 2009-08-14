Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7EHvSaZ119860 for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 12:57:43 -0500
Received: from slurp.thebarn.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFC3F14B0DDE
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 10:57:40 -0700 (PDT)
Received: from slurp.thebarn.com (mail.thebarn.com [208.42.117.202]) by
	cuda.sgi.com with ESMTP id c5wuqnAqCfLaREVY for
	<xfs@oss.sgi.com>; Fri, 14 Aug 2009 10:57:40 -0700 (PDT)
Message-ID: <4A85A582.5000701@thebarn.com>
Date: Fri, 14 Aug 2009 12:57:22 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: xfs buffers
References: <9ee2fe770908131117o5b7ec317me4524d020bbe216b@mail.gmail.com>
In-Reply-To: <9ee2fe770908131117o5b7ec317me4524d020bbe216b@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: kanishk rastogi <kanishk.85@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

kanishk rastogi wrote:
> hi all, I was trying to understand the xfs_buf_t management in XFS.
>  I was looking at the xfs_bufhash_t which is used to keep the info
> of buffers which have ongoing transactions. I wanted to know if it
> uses it for caching these pages.
>
> As far as i can see in xfs_buf_relse  calls ::
>
> list_del_init(&bp->b_hash_list);
>
> if the count drops down to 0 for the buffer...
>
> if (atomic_dec_and_lock(&bp->b_hold, &hash->bh_lock)) { if
> (bp->b_relse) { ----->set only in case of error??
> atomic_inc(&bp->b_hold); spin_unlock(&hash->bh_lock);
> (*(bp->b_relse)) (bp); } else if (bp->b_flags & XBF_FS_MANAGED) {
> ----> mostly unset......\
Indeed. that flag is used on exactly one buffer, the superblock.
Basically the superblock is pinned in memory and only flushed by the
filesystem.
> spin_unlock(&hash->bh_lock); } else { ASSERT(!(bp->b_flags &
> (XBF_DELWRI|_XBF_DELWRI_Q))); *list_del_init(&bp->b_hash_list);*
> spin_unlock(&hash->bh_lock); xfs_buf_free(bp); } }
>
> ---------------
>
> CMIIW: So it doesnt keeps buffers if they are not in use....  ??
buffers are released back to the buf_t  zone when they are done.

zone allocation / free is very fast so managing lists of "free"
buffers doesn't make a lot of sense.

>
> I dont think that should be the case...
>
> -- regards kanishk
>
> ----------------------------------------------------------------------
>
>
> _______________________________________________ xfs mailing list
> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKhaWBNRmM+OaGhBgRAtqgAJ9CZfj0QXz8Yy7P4jYemgEPsvR9pQCfcSWM
a9OI8A4ckMdOuiXQ60o4PLE=
=OJAD
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
