Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3BJxqi002182 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 06:19:59 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D25351CDDC9B
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 04:19:53 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id C65DZ4AXMSbjyKh3
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 04:19:53 -0700 (PDT)
Received: by faai28 with SMTP id i28so1534881faa.26
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 04:19:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20111103100647.GA1002@infradead.org>
References: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
	<20111103070246.GA10579@infradead.org>
	<CADDb1s3UN4HMKEA2kSEM0HsUCC7DE63B1oJAoL6QpqXBdDCEqQ@mail.gmail.com>
	<20111103100647.GA1002@infradead.org>
Date: Thu, 3 Nov 2011 16:49:53 +0530
Message-ID: <CADDb1s2ZiPqHqkm01eG24jD+ytU9w3vJwKckXneMkL0wbUEb1Q@mail.gmail.com>
Subject: Re: [Patch] xfs: serialise unaligned direct IOs
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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

After all modifications and running checkpatch.pl.

Thanks & Regards,
Amit Sahrawat

xfs: serialise unaligned direct IOs

[ This patch published in 2.6.38 kernel(Original reference
http://oss.sgi.com/archives/xfs/2011-01/msg00013.html), but
can not be applied to 2.6.35 kernel directly, because of the
absence of required function, its reimplmented to resolve
xfstest test 240 fail.]

When two concurrent unaligned, non-overlapping direct IOs are issued
to the same block, the direct Io layer will race to zero the block.
The result is that one of the concurrent IOs will overwrite data
written by the other IO with zeros. This is demonstrated by the
xfsqa test 240.

To avoid this problem, serialise all unaligned direct IOs to an
inode with a big hammer. We need a big hammer approach as we need to
serialise AIO as well, so we can't just block writes on locks.
Hence, the big hammer is calling xfs_ioend_wait() while holding out
other unaligned direct IOs from starting.

We don't bother trying to serialised aligned vs unaligned IOs as
they are overlapping IO and the result of concurrent overlapping IOs
is undefined - the result of either IO is a valid result so we let
them race. Hence we only penalise unaligned IO, which already has a
major overhead compared to aligned IO so this isn't a major problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

diff -Nurp linux-Orig/fs/xfs/linux-2.6/xfs_file.c
linux-Updated/fs/xfs/linux-2.6/xfs_file.c
--- linux-Orig/fs/xfs/linux-2.6/xfs_file.c	2011-11-02 12:10:52.000000000 +0=
530
+++ linux-Updated/fs/xfs/linux-2.6/xfs_file.c	2011-11-03
16:39:08.000000000 +0530
@@ -587,6 +587,7 @@ xfs_file_aio_write(
 	xfs_fsize_t		isize, new_size;
 	int			iolock;
 	size_t			ocount =3D 0, count;
+	int			unaligned_io =3D 0;
 	int			need_i_mutex;

 	XFS_STATS_INC(xs_write_calls);
@@ -640,8 +641,26 @@ start:
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			return XFS_ERROR(-EINVAL);
 		}
+	/*
+	 * In most cases the direct IO writes will be done with IOLOCK_SHARED
+	 * allowing them to be done in parallel with reads and other direct IO
+	 * writes. However,if the IO is not aligned to filesystem blocks, the
+	 * direct IO layer needs to do sub-block zeroing and that requires
+	 * serialisation against other direct IOs to the same block. In this
+	 * case we need to serialise the submission of the unaligned IOs so
+	 * that we don't get racing block zeroing in the dio layer.
+	 * To avoid the problem with aio, we also need to wait for outstanding
+	 * IOs to complete so that unwritten extent conversion is completed
+	 * before we try to map the overlapping block. This is currently
+	 * implemented by hitting it with a big hammer (i.e. xfs_ioend_wait()).
+	 */
+
+		if ((pos & mp->m_blockmask) ||
+		   ((pos + count) & mp->m_blockmask))
+			unaligned_io =3D 1;

-		if (!need_i_mutex && (mapping->nrpages || pos > ip->i_size)) {
+		if (!need_i_mutex &&
+		   (unaligned_io || mapping->nrpages || pos > ip->i_size)) {
 			xfs_iunlock(ip, XFS_ILOCK_EXCL|iolock);
 			iolock =3D XFS_IOLOCK_EXCL;
 			need_i_mutex =3D 1;
@@ -700,12 +719,18 @@ start:
 		}

 		if (need_i_mutex) {
-			/* demote the lock now the cached pages are gone */
-			xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-			mutex_unlock(&inode->i_mutex);
-
-			iolock =3D XFS_IOLOCK_SHARED;
-			need_i_mutex =3D 0;
+			if (unaligned_io)
+				xfs_ioend_wait(ip);
+			else {
+				/*
+				 * demote the lock now the cached pages
+				 * are gone if we can
+				 */
+				xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
+				iolock =3D XFS_IOLOCK_SHARED;
+				mutex_unlock(&inode->i_mutex);
+				need_i_mutex =3D 0;
+			}
 		}

 		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);




On Thu, Nov 3, 2011 at 3:36 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 03, 2011 at 03:29:18PM +0530, Amit Sahrawat wrote:
>> > You probably should keep the original Signoff and reviewed-by tags,
>> > and add your editor note on the top into [ ] ?brackets.
>> Ok, will do so in the final patch. Actually was unaware of information
>> to keep in backported patches?
>
> The standard procedure is to keep patches basically as-is. =A0This doesn't
> quite apply for your case, so I think just adding a comment in
> [ ] brackets on the top is the best you can do.
>
>> > You also need to make the i_mutex unlock and need_i_mutex update
>> > conditional here, otherwise you still serialize all O_DIRECT writes.
>> >
>> you mean, keeping need_i_mutex=3D0 and mutex_unlock as part of 'else' st=
atement.
>
> Yes.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
