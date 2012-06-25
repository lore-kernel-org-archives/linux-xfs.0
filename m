Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PMiTVv031869 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 17:44:29 -0500
Date: Mon, 25 Jun 2012 17:45:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Strange case of deleting lots of files and "df" not
	recognizing it....(unless I umount/mount) the disk...
Message-ID: <20120625224554.GQ10196@sgi.com>
References: <4FE7FDF4.6080506@tlinx.org>
	<20120625090211.3c5c2032@galadriel.home>
	<20120625205128.GA29979@sgi.com> <4FE8E14F.3080807@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE8E14F.3080807@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Linda,

On Mon, Jun 25, 2012 at 03:08:15PM -0700, Linda Walsh wrote:
> Ben Myers wrote:
> >On Mon, Jun 25, 2012 at 09:02:11AM +0200, Emmanuel Florac wrote:
> >>Le Sun, 24 Jun 2012 22:58:12 -0700 vous =E9criviez:
> >>
> >>>So when does it actually synchronize w/o me forcing it?  (I.e.
> >>>umount/mount)?
> >>>
> >>Yes, it happens sometimes and a umount/mount is needed to fix it.
> >
> >You may find that this will get the job done:
> >echo 3 > /proc/sys/vm/drop_caches
> >
> >-Ben
> =

> Yup...it went away for a LONG time...maybe 30 seconds...
> =

> Does that mean there was that much unsynchronized data being held in memo=
ry
> that wasn't being written out??
>
> It DID fix the space allocation issue.

XFS doesn't clean up the blocks for a deleted file until the last reference=
 on
the inode goes away.  Dropping caches just forces the issue.

> When I read the value before changing it, it said '0'.
> =

> when it finished, I tried to set it back to '0', but got an invalid argum=
ent.???
> Was it really '2' or something else?

Don't worry about the current value of /proc/sys/vm/drop_caches... It just
retains the last value written to it but doesn't do anything with it.  The =
only
time it takes an action is when you write to it.

> BTW -- it had been in the weird state for 13 hours before I issued the
> order to drop_caches... seems like a long time not to cache data...?

Yeah.  13 hours is a long time, esp for something you just removed.  ;)

Fortunately it's not the data that is cached, it's probably just a pesky de=
ntry
hanging around on the lru with a single reference on the inode keeping it
active, preventing xfs from freeing up the blocks.

I've had some luck on v3.0 with the following patch... it's not yet tested =
on
3.5 so YMMV.  Are you running an NFS server?  Something that often creates
anonymous dentries?

Regards,
Ben

---
 fs/xfs/xfs_vnodeops.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: xfs/fs/xfs/xfs_vnodeops.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -1203,6 +1203,41 @@ xfs_lock_two_inodes(
 	}
 }
 =

+/*
+ * Prune any disconnected dentries from the inode.  This will help to ensu=
re
+ * timely teardown of the inode by unhashing all disconnected (anonymous)
+ * dentries that may have been added by an interface that uses filehandles=
 like
+ * NFS.
+ *
+ * Here we know that there must currently be a dentry with a name on this =
inode
+ * because we're in an unlink/rmdir path, so we do not run the risk of ino=
de
+ * reclaim here because we only unhash disconnected dentries.
+ */
+static void
+xfs_d_prune_disconnected(
+	struct xfs_inode	*ip)
+{
+	struct inode		*inode =3D VFS_I(ip);
+	struct dentry		*alias;
+
+restart:
+	spin_lock(&inode->i_lock);
+	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
+		spin_lock(&alias->d_lock);
+		if (alias->d_flags & DCACHE_DISCONNECTED &&
+		    !d_unhashed(alias)) {
+			dget_dlock(alias);
+			__d_drop(alias);
+			spin_unlock(&alias->d_lock);
+			spin_unlock(&inode->i_lock);
+			dput(alias);
+			goto restart;
+		}
+		spin_unlock(&alias->d_lock);
+	}
+	spin_unlock(&inode->i_lock);
+}
+
 int
 xfs_remove(
 	xfs_inode_t             *dp,
@@ -1347,6 +1382,9 @@ xfs_remove(
 	if (error)
 		goto std_return;
 =

+	if (link_zero)
+		xfs_d_prune_disconnected(ip);
+
 	/*
 	 * If we are using filestreams, kill the stream association.
 	 * If the file is still open it may get a new one but that

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
