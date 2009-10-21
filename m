Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9L9hdsi237578 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 04:43:39 -0500
Received: from mail-ew0-f221.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E8F41D81DB7
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 02:45:12 -0700 (PDT)
Received: from mail-ew0-f221.google.com (mail-ew0-f221.google.com
	[209.85.219.221]) by cuda.sgi.com with ESMTP id
	AOAVKRJzHxnQaJbb for <xfs@oss.sgi.com>;
	Wed, 21 Oct 2009 02:45:12 -0700 (PDT)
Received: by ewy21 with SMTP id 21so5030537ewy.8
	for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 02:45:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091020034048.GA9464@discord.disaster>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
	<20091019011600.GO9464@discord.disaster>
	<20091019035426.GB18296@infradead.org>
	<20091020034048.GA9464@discord.disaster>
Date: Wed, 21 Oct 2009 11:45:11 +0200
Message-ID: <89c4f90c0910210245h4691cd82hd1d63f5ed72fb2e3@mail.gmail.com>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
From: Tommy van Leeuwen <tommy@news-service.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Patrick Schreurs <patrick@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Tue, Oct 20, 2009 at 5:40 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Oct 18, 2009 at 11:54:26PM -0400, Christoph Hellwig wrote:
>> On Mon, Oct 19, 2009 at 12:16:00PM +1100, Dave Chinner wrote:
>> > > + =A0* The hash lock here protects a thread in xfs_iget from racing =
with
>> > > + =A0* us on recycling the inode. =A0Once we have the XFS_IRECLAIM f=
lag set
>> > > + =A0* it will not touch it.
>> > > =A0 =A0*/
>> > > - write_lock(&pag->pag_ici_lock);
>> >
>> > Did you mean to remove this write_lock? The patch does not remove
>> > the unlocks....
>>
>> It's taken by the caller.
>
> Ah, I guess I need to see the whole patch series, then.

This is the full patch we're using now on 2.6.31.4. (Just running btw
so no results yet).

diff -ru linux-2.6.31.4/fs/xfs/linux-2.6/xfs_sync.c
linux-2.6.31.4-xfspatch/fs/xfs/linux-2.6/xfs_sync.c
--- linux-2.6.31.4/fs/xfs/linux-2.6/xfs_sync.c  2009-09-10
00:13:59.000000000 +0200
+++ linux-2.6.31.4-xfspatch/fs/xfs/linux-2.6/xfs_sync.c 2009-10-21
11:24:56.000000000 +0200
@@ -180,6 +180,11 @@
                return EFSCORRUPTED;
        }

+       if (xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM)=
) {
+               read_unlock(&pag->pag_ici_lock);
+               return ENOENT;
+       }
+
        /*
         * If we can't get a reference on the inode, it must be in reclaim.
         * Leave it for the reclaim code to flush. Also avoid inodes that
@@ -191,7 +196,7 @@
        }
        read_unlock(&pag->pag_ici_lock);

-       if (is_bad_inode(inode) || xfs_iflags_test(ip, XFS_INEW)) {
+       if (is_bad_inode(inode)) {
                IRELE(ip);
                return ENOENT;
        }
@@ -655,22 +660,21 @@
 {
        xfs_perag_t     *pag =3D xfs_get_perag(ip->i_mount, ip->i_ino);

-       /* The hash lock here protects a thread in xfs_iget_core from
-        * racing with us on linking the inode back with a vnode.
-        * Once we have the XFS_IRECLAIM flag set it will not touch
-        * us.
+       /*
+        * The hash lock here protects a thread in xfs_iget from racing with
+        * us on recycling the inode.  Once we have the XFS_IRECLAIM flag s=
et
+        * it will not touch it.
         */
-       write_lock(&pag->pag_ici_lock);
        spin_lock(&ip->i_flags_lock);
-       if (__xfs_iflags_test(ip, XFS_IRECLAIM) ||
-           !__xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {
+       ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+       if (__xfs_iflags_test(ip, XFS_IRECLAIM)) {
                spin_unlock(&ip->i_flags_lock);
                write_unlock(&pag->pag_ici_lock);
                if (locked) {
                        xfs_ifunlock(ip);
                        xfs_iunlock(ip, XFS_ILOCK_EXCL);
                }
-               return -EAGAIN;
+               return 0;
        }
        __xfs_iflags_set(ip, XFS_IRECLAIM);
        spin_unlock(&ip->i_flags_lock);
@@ -764,6 +768,88 @@
        xfs_put_perag(mp, pag);
 }

+STATIC xfs_inode_t *
+xfs_reclaim_ag_lookup(
+       struct xfs_mount        *mp,
+       struct xfs_perag        *pag,
+       uint32_t                *first_index)
+{
+       int                     nr_found;
+       struct xfs_inode        *ip;
+
+       /*
+        * use a gang lookup to find the next inode in the tree
+        * as the tree is sparse and a gang lookup walks to find
+        * the number of objects requested.
+        */
+       write_lock(&pag->pag_ici_lock);
+       nr_found =3D radix_tree_gang_lookup_tag(&pag->pag_ici_root,
+                       (void **)&ip, *first_index, 1, XFS_ICI_RECLAIM_TAG);
+       if (!nr_found)
+               goto unlock;
+
+       /*
+        * Update the index for the next lookup. Catch overflows
+        * into the next AG range which can occur if we have inodes
+        * in the last block of the AG and we are currently
+        * pointing to the last inode.
+        */
+       *first_index =3D XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+       if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+               goto unlock;
+
+       return ip;
+
+unlock:
+       write_unlock(&pag->pag_ici_lock);
+       return NULL;
+}
+
+STATIC int
+xfs_reclaim_ag_walk(
+       struct xfs_mount        *mp,
+       xfs_agnumber_t          ag,
+       int                     flags)
+{
+       struct xfs_perag        *pag =3D &mp->m_perag[ag];
+       uint32_t                first_index;
+       int                     last_error =3D 0;
+       int                     skipped;
+
+restart:
+       skipped =3D 0;
+       first_index =3D 0;
+       do {
+               int             error =3D 0;
+               xfs_inode_t     *ip;
+
+               ip =3D xfs_reclaim_ag_lookup(mp, pag, &first_index);
+               if (!ip)
+                       break;
+
+               error =3D xfs_reclaim_inode(ip, 0, flags);
+               if (error =3D=3D EAGAIN) {
+                       skipped++;
+                       continue;
+               }
+               if (error)
+                       last_error =3D error;
+               /*
+                * bail out if the filesystem is corrupted.
+                */
+               if (error =3D=3D EFSCORRUPTED)
+                       break;
+
+       } while (1);
+
+       if (skipped) {
+               delay(1);
+               goto restart;
+       }
+       xfs_put_perag(mp, pag);
+       return last_error;
+}
+
 STATIC int
 xfs_reclaim_inode_now(
        struct xfs_inode        *ip,
@@ -785,6 +871,19 @@
        xfs_mount_t     *mp,
        int             mode)
 {
-       return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
-                                       XFS_ICI_RECLAIM_TAG);
+       int                     error =3D 0;
+       int                     last_error =3D 0;
+       xfs_agnumber_t          ag;
+
+       for (ag =3D 0; ag < mp->m_sb.sb_agcount; ag++) {
+               if (!mp->m_perag[ag].pag_ici_init)
+                       continue;
+               error =3D xfs_reclaim_ag_walk(mp, ag, mode);
+               if (error) {
+                       last_error =3D error;
+                       if (error =3D=3D EFSCORRUPTED)
+                               break;
+               }
+       }
+       return XFS_ERROR(last_error);
 }
diff -ru linux-2.6.31.4/fs/xfs/xfs_iget.c
linux-2.6.31.4-xfspatch/fs/xfs/xfs_iget.c
--- linux-2.6.31.4/fs/xfs/xfs_iget.c    2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.31.4-xfspatch/fs/xfs/xfs_iget.c   2009-10-14
13:56:33.000000000 +0200
@@ -242,6 +242,8 @@

                error =3D -inode_init_always(mp->m_super, inode);
                if (error) {
+                       printk("XFS: inode_init_always failed to
re-initialize inode\n");
+
                        /*
                         * Re-initializing the inode failed, and we are in =
deep
                         * trouble.  Try to re-add it to the reclaim list.
@@ -538,17 +540,21 @@
 {
        struct xfs_mount        *mp =3D ip->i_mount;
        struct xfs_perag        *pag;
+       xfs_agino_t             agino =3D XFS_INO_TO_AGINO(mp, ip->i_ino);

        XFS_STATS_INC(xs_ig_reclaims);

        /*
-        * Remove the inode from the per-AG radix tree.  It doesn't matter
-        * if it was never added to it because radix_tree_delete can deal
-        * with that case just fine.
+        * Remove the inode from the per-AG radix tree.
+        *
+        * Because radix_tree_delete won't complain even if the item was ne=
ver
+        * added to the tree assert that it's been there before to catch
+        * problems with the inode life time early on.
         */
        pag =3D xfs_get_perag(mp, ip->i_ino);
        write_lock(&pag->pag_ici_lock);
-       radix_tree_delete(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_in=
o));
+       ASSERT(radix_tree_lookup(&pag->pag_ici_root, agino));
+       radix_tree_delete(&pag->pag_ici_root, agino);
        write_unlock(&pag->pag_ici_lock);
        xfs_put_perag(mp, pag);

diff -ru linux-2.6.31.4/fs/xfs/xfs_vnodeops.c
linux-2.6.31.4-xfspatch/fs/xfs/xfs_vnodeops.c
--- linux-2.6.31.4/fs/xfs/xfs_vnodeops.c        2009-09-10
00:13:59.000000000 +0200
+++ linux-2.6.31.4-xfspatch/fs/xfs/xfs_vnodeops.c       2009-10-14
13:56:33.000000000 +0200
@@ -2465,45 +2465,36 @@
 xfs_reclaim(
        xfs_inode_t     *ip)
 {
-
        xfs_itrace_entry(ip);

        ASSERT(!VN_MAPPED(VFS_I(ip)));

        /* bad inode, get out here ASAP */
-       if (is_bad_inode(VFS_I(ip))) {
-               xfs_ireclaim(ip);
-               return 0;
-       }
+       if (is_bad_inode(VFS_I(ip)))
+               goto out_reclaim;

        xfs_ioend_wait(ip);

        ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks =3D=
=3D 0);

        /*
-        * Make sure the atime in the XFS inode is correct before freeing t=
he
-        * Linux inode.
+        * We should never get here with one of the reclaim flags already s=
et.
         */
-       xfs_synchronize_atime(ip);
+       BUG_ON(xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+       BUG_ON(xfs_iflags_test(ip, XFS_IRECLAIM));

        /*
         * If we have nothing to flush with this inode then complete the
-        * teardown now, otherwise break the link between the xfs inode and=
 the
-        * linux inode and clean up the xfs inode later. This avoids flushi=
ng
-        * the inode to disk during the delete operation itself.
-        *
-        * When breaking the link, we need to set the XFS_IRECLAIMABLE flag
-        * first to ensure that xfs_iunpin() will never see an xfs inode
-        * that has a linux inode being reclaimed. Synchronisation is provi=
ded
-        * by the i_flags_lock.
+        * teardown now, otherwise delay the flush operation.
         */
-       if (!ip->i_update_core && (ip->i_itemp =3D=3D NULL)) {
-               xfs_ilock(ip, XFS_ILOCK_EXCL);
-               xfs_iflock(ip);
-               xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-               return xfs_reclaim_inode(ip, 1, XFS_IFLUSH_DELWRI_ELSE_SYNC=
);
+       if (ip->i_update_core || ip->i_itemp) {
+               xfs_inode_set_reclaim_tag(ip);
+               return 0;
        }
        xfs_inode_set_reclaim_tag(ip);
+
+out_reclaim:
+       xfs_ireclaim(ip);
        return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
