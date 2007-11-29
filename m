Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 20:12:30 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAT4CLt8004784
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 20:12:24 -0800
Subject: REVIEW: Improve "." and ".." problem detection and handling in xfs_repair
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------WpmrDzY9L2gCIlCYFMw2EE
MIME-Version: 1.0
References: <op.tyx0grm93jf8g2@pc-bnaujok.melbourne.sgi.com>
Date: Thu, 29 Nov 2007 15:13:43 +1100
Message-ID: <op.t2jco5r93jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tyx0grm93jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------WpmrDzY9L2gCIlCYFMw2EE
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit

Ping?

------- Forwarded message -------
From: "Barry Naujok" <bnaujok@sgi.com>
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc:
Subject: REVIEW: Improve "." and ".." problem detection and handling in  
xfs_repair
Date: Thu, 20 Sep 2007 17:59:05 +1000

In a non-shortform directory (ie. the directory contents is
stored within the inode on-disk), if "." or ".." are placed
in different blocks, the directory cannot be made shortform
when everything else in the directory is deleted as two
blocks still remain. This prevents the kernel from deleting
this directory saying it's "not empty" (see
http://oss.sgi.com/archives/xfs/2007-09/msg00142.html ).

The attached patch detects "." or ".." not being in the
first block and rebuilds it in repair so it may be
deleted when required.

Also, testing this patch, I found if ".." didn't exist in
a directory, yet another directory had an entry for it,
it was put in lost+found. The patch now puts ".." back in
for the directory referencing it.

I also improved the lookup of the parent when rebuilding
a directory (it did a hash lookup of ".." instead of the
already existing get_inode_parent() call).


------------WpmrDzY9L2gCIlCYFMw2EE
Content-Disposition: attachment; filename=improve_dot_and_dotdot_handling.patch
Content-Type: text/x-patch; name=improve_dot_and_dotdot_handling.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/incore_ino.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/incore_ino.c	2007-09-20 17:45:32.000000000 +1000
+++ b/xfsprogs/repair/incore_ino.c	2007-09-19 15:48:06.845973418 +1000
@@ -621,49 +621,61 @@ print_uncertain_inode_list(xfs_agnumber_
  * is the Nth bit set in the mask is stored in the Nth location in
  * the array where N starts at 0.
  */
+
 void
-set_inode_parent(ino_tree_node_t *irec, int offset, xfs_ino_t parent)
-{
-	int		i;
-	int		cnt;
-	int		target;
-	__uint64_t	bitmask;
-	parent_entry_t	*tmp;
+set_inode_parent(
+	ino_tree_node_t		*irec,
+	int			offset,
+	xfs_ino_t		parent)
+{
+	parent_list_t		*ptbl;
+	int			i;
+	int			cnt;
+	int			target;
+	__uint64_t		bitmask;
+	parent_entry_t		*tmp;
=20
-	ASSERT(full_ino_ex_data =3D=3D 0);
+	if (full_ino_ex_data)
+		ptbl =3D irec->ino_un.ex_data->parents;
+	else
+		ptbl =3D irec->ino_un.plist;
=20
-	if (irec->ino_un.plist =3D=3D NULL)  {
-		irec->ino_un.plist =3D
-			(parent_list_t*)malloc(sizeof(parent_list_t));
-		if (!irec->ino_un.plist)
+	if (ptbl =3D=3D NULL)  {
+		ptbl =3D (parent_list_t *)malloc(sizeof(parent_list_t));
+		if (!ptbl)
 			do_error(_("couldn't malloc parent list table\n"));
=20
-		irec->ino_un.plist->pmask =3D 1LL << offset;
-		irec->ino_un.plist->pentries =3D
-			(xfs_ino_t*)memalign(sizeof(xfs_ino_t), sizeof(xfs_ino_t));
-		if (!irec->ino_un.plist->pentries)
+		if (full_ino_ex_data)
+			irec->ino_un.ex_data->parents =3D ptbl;
+		else
+			irec->ino_un.plist =3D ptbl;
+
+		ptbl->pmask =3D 1LL << offset;
+		ptbl->pentries =3D (xfs_ino_t*)memalign(sizeof(xfs_ino_t),
+							sizeof(xfs_ino_t));
+		if (!ptbl->pentries)
 			do_error(_("couldn't memalign pentries table\n"));
 #ifdef DEBUG
-		irec->ino_un.plist->cnt =3D 1;
+		ptbl->cnt =3D 1;
 #endif
-		irec->ino_un.plist->pentries[0] =3D parent;
+		ptbl->pentries[0] =3D parent;
=20
 		return;
 	}
=20
-	if (irec->ino_un.plist->pmask & (1LL << offset))  {
+	if (ptbl->pmask & (1LL << offset))  {
 		bitmask =3D 1LL;
 		target =3D 0;
=20
 		for (i =3D 0; i < offset; i++)  {
-			if (irec->ino_un.plist->pmask & bitmask)
+			if (ptbl->pmask & bitmask)
 				target++;
 			bitmask <<=3D 1;
 		}
 #ifdef DEBUG
-		ASSERT(target < irec->ino_un.plist->cnt);
+		ASSERT(target < ptbl->cnt);
 #endif
-		irec->ino_un.plist->pentries[target] =3D parent;
+		ptbl->pentries[target] =3D parent;
=20
 		return;
 	}
@@ -672,7 +684,7 @@ set_inode_parent(ino_tree_node_t *irec,=20
 	cnt =3D target =3D 0;
=20
 	for (i =3D 0; i < XFS_INODES_PER_CHUNK; i++)  {
-		if (irec->ino_un.plist->pmask & bitmask)  {
+		if (ptbl->pmask & bitmask)  {
 			cnt++;
 			if (i < offset)
 				target++;
@@ -682,7 +694,7 @@ set_inode_parent(ino_tree_node_t *irec,=20
 	}
=20
 #ifdef DEBUG
-	ASSERT(cnt =3D=3D irec->ino_un.plist->cnt);
+	ASSERT(cnt =3D=3D ptbl->cnt);
 #endif
 	ASSERT(cnt >=3D target);
=20
@@ -690,23 +702,23 @@ set_inode_parent(ino_tree_node_t *irec,=20
 	if (!tmp)
 		do_error(_("couldn't memalign pentries table\n"));
=20
-	(void) bcopy(irec->ino_un.plist->pentries, tmp,
+	(void) bcopy(ptbl->pentries, tmp,
 			target * sizeof(parent_entry_t));
=20
 	if (cnt > target)
-		(void) bcopy(irec->ino_un.plist->pentries + target,
+		(void) bcopy(ptbl->pentries + target,
 				tmp + target + 1,
 				(cnt - target) * sizeof(parent_entry_t));
=20
-	free(irec->ino_un.plist->pentries);
+	free(ptbl->pentries);
=20
-	irec->ino_un.plist->pentries =3D tmp;
+	ptbl->pentries =3D tmp;
=20
 #ifdef DEBUG
-	irec->ino_un.plist->cnt++;
+	ptbl->cnt++;
 #endif
-	irec->ino_un.plist->pentries[target] =3D parent;
-	irec->ino_un.plist->pmask |=3D (1LL << offset);
+	ptbl->pentries[target] =3D parent;
+	ptbl->pmask |=3D (1LL << offset);
 }
=20
 xfs_ino_t

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/phase6.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/phase6.c	2007-09-20 17:45:33.000000000 +1000
+++ b/xfsprogs/repair/phase6.c	2007-09-19 18:15:06.105909485 +1000
@@ -1624,16 +1624,25 @@ lf_block_dir_entry_check(xfs_mount_t		*m
 		 */
 		if (is_inode_reached(irec, ino_offset))  {
 			junkit =3D 1;
-			do_warn(
-_("entry \"%s\" in dir %llu points to an already connected dir inode %llu,=
\n"),
+			do_warn(_("entry \"%s\" in dir %llu points to an "
+				"already connected dir inode %llu,\n"),
 				fname, ino, lino);
 		} else if (parent =3D=3D ino)  {
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
-		} else  {
+		} else if (parent =3D=3D NULLFSINO) {
+			/* ".." was missing, but this entry refers to it,
+			   so, set it as the parent and mark for rebuild */
+			do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
+				" .. entry, will set it in ino %llu.\n"),
+				fname, ino, lino);
+			set_inode_parent(irec, ino_offset, ino);
+			add_inode_reached(irec, ino_offset);
+			add_inode_ref(current_irec, current_ino_offset);
+		} else {
 			junkit =3D 1;
-			do_warn(
-_("entry \"%s\" in dir ino %llu not consistent with .. value (%llu) in ino=
 %llu,\n"),
+			do_warn(_("entry \"%s\" in dir ino %llu not consistent"
+				" with .. value (%llu) in ino %llu,\n"),
 				fname, ino, parent, lino);
 		}
=20
@@ -1788,10 +1797,12 @@ _("can't map leaf block %d in dir %llu,=20
=20
 static void
 longform_dir2_rebuild(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	xfs_inode_t	*ip,
-	dir_hash_tab_t	*hashtab)
+	xfs_mount_t		*mp,
+	xfs_ino_t		ino,
+	xfs_inode_t		*ip,
+	ino_tree_node_t		*irec,
+	int			ino_offset,
+	dir_hash_tab_t		*hashtab)
 {
 	int			error;
 	int			nres;
@@ -1800,7 +1811,6 @@ longform_dir2_rebuild(
 	xfs_fsblock_t		firstblock;
 	xfs_bmap_free_t		flist;
 	xfs_inode_t		pip;
-	int			byhash;
 	dir_hash_ent_t		*p;
 	int			committed;
 	int			done;
@@ -1813,19 +1823,14 @@ longform_dir2_rebuild(
 	do_warn(_("rebuilding directory inode %llu\n"), ino);
=20
 	/*
-	 * first attempt to locate the parent inode, if it can't be found,
-	 * set it to the root inode and it'll be adjusted or fixed later
-	 * if incorrect (the inode number here needs to be valid for the
-	 * libxfs_dir2_init() call).
-	 */
-	byhash =3D DIR_HASH_FUNC(hashtab, libxfs_da_hashname((uchar_t*)"..", 2));
-	pip.i_ino =3D mp->m_sb.sb_rootino;
-	for (p =3D hashtab->byhash[byhash]; p; p =3D p->nextbyhash) {
-		if (p->namelen =3D=3D 2 && p->name[0] =3D=3D '.' && p->name[1] =3D=3D '.=
') {
-			pip.i_ino =3D p->inum;
-			break;
-		}
-	}
+	 * first attempt to locate the parent inode, if it can't be
+	 * found, set it to the root inode and it'll be moved to the
+	 * orphanage later (the inode number here needs to be valid
+	 * for the libxfs_dir2_init() call).
+	 */
+	pip.i_ino =3D get_inode_parent(irec, ino_offset);
+	if (pip.i_ino =3D=3D NULLFSINO)
+		pip.i_ino =3D mp->m_sb.sb_rootino;
=20
 	XFS_BMAP_INIT(&flist, &firstblock);
=20
@@ -2273,11 +2278,25 @@ longform_dir2_entry_check_data(
 		 * skip the '..' entry since it's checked when the
 		 * directory is reached by something else.  if it never
 		 * gets reached, it'll be moved to the orphanage and we'll
-		 * take care of it then.
+		 * take care of it then. If it doesn't exist at all, the
+		 * directory needs to be rebuilt first before being added
+		 * to the orphanage.
 		 */
 		if (dep->namelen =3D=3D 2 && dep->name[0] =3D=3D '.' &&
-		    dep->name[1] =3D=3D '.')
+				dep->name[1] =3D=3D '.') {
+			if (da_bno !=3D 0) {
+				/* ".." should be in the first block */
+				nbad++;
+				if (entry_junked(_("entry \"%s\" (ino %llu) "
+						"in dir %llu is not in the "
+						"the first block"), fname,
+						inum, ip->i_ino)) {
+					dep->name[0] =3D '/';
+					libxfs_dir2_data_log_entry(tp, bp, dep);
+				}
+			}
 			continue;
+		}
 		ASSERT(no_modify || !verify_inum(mp, inum));
 		/*
 		 * special case the . entry.  we know there's only one
@@ -2291,6 +2310,16 @@ longform_dir2_entry_check_data(
 		if (ip->i_ino =3D=3D inum)  {
 			ASSERT(dep->name[0] =3D=3D '.' && dep->namelen =3D=3D 1);
 			add_inode_ref(current_irec, current_ino_offset);
+			if (da_bno !=3D 0 || dep !=3D (xfs_dir2_data_entry_t *)d->u) {
+				/* "." should be the first entry */
+				nbad++;
+				if (entry_junked(_("entry \"%s\" in dir %llu is "
+						"not the first entry"),
+						fname, inum, ip->i_ino)) {
+					dep->name[0] =3D '/';
+					libxfs_dir2_data_log_entry(tp, bp, dep);
+				}
+			}
 			*need_dot =3D 0;
 			continue;
 		}
@@ -2325,6 +2354,15 @@ _("entry \"%s\" in dir %llu points to an
 		} else if (parent =3D=3D ip->i_ino)  {
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
+		} else if (parent =3D=3D NULLFSINO) {
+			/* ".." was missing, but this entry refers to it,
+			   so, set it as the parent and mark for rebuild */
+			do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
+				" .. entry, will set it in ino %llu.\n"),
+				fname, ip->i_ino, inum);
+			set_inode_parent(irec, ino_offset, ip->i_ino);
+			add_inode_reached(irec, ino_offset);
+			add_inode_ref(current_irec, current_ino_offset);
 		} else  {
 			junkit =3D 1;
 			do_warn(
@@ -2637,7 +2675,7 @@ longform_dir2_entry_check(xfs_mount_t	*m
 				irec, ino_offset, &bplist[db], hashtab,
 				&freetab, da_bno, isblock);
 	}
-	fixit =3D (*num_illegal !=3D 0) || dir2_is_badino(ino);
+	fixit =3D (*num_illegal !=3D 0) || dir2_is_badino(ino) || *need_dot;
=20
 	/* check btree and freespace */
 	if (isblock) {
@@ -2659,8 +2697,9 @@ longform_dir2_entry_check(xfs_mount_t	*m
 		for (i =3D 0; i < freetab->naents; i++)
 			if (bplist[i])
 				libxfs_da_brelse(NULL, bplist[i]);
-		longform_dir2_rebuild(mp, ino, ip, hashtab);
+		longform_dir2_rebuild(mp, ino, ip, irec, ino_offset, hashtab);
 		*num_illegal =3D 0;
+		*need_dot =3D 0;
 	} else {
 		for (i =3D 0; i < freetab->naents; i++)
 			if (bplist[i])
@@ -2865,6 +2904,15 @@ shortform_dir_entry_check(xfs_mount_t	*m
 			} else if (parent =3D=3D ino)  {
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
+			} else if (parent =3D=3D NULLFSINO) {
+				/* ".." was missing, but this entry refers to it,
+				so, set it as the parent and mark for rebuild */
+				do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
+					" .. entry, will set it in ino %llu.\n"),
+					fname, ino, lino);
+				set_inode_parent(irec, ino_offset, ino);
+				add_inode_reached(irec, ino_offset);
+				add_inode_ref(current_irec, current_ino_offset);
 			} else  {
 				junkit =3D 1;
 				do_warn(_("entry \"%s\" in dir %llu not "
@@ -3257,6 +3305,15 @@ shortform_dir2_entry_check(xfs_mount_t	*
 			} else if (parent =3D=3D ino)  {
 				add_inode_reached(irec, ino_offset);
 				add_inode_ref(current_irec, current_ino_offset);
+			} else if (parent =3D=3D NULLFSINO) {
+				/* ".." was missing, but this entry refers to it,
+				so, set it as the parent and mark for rebuild */
+				do_warn(_("entry \"%s\" in dir ino %llu doesn't have a"
+					" .. entry, will set it in ino %llu.\n"),
+					fname, ino, lino);
+				set_inode_parent(irec, ino_offset, ino);
+				add_inode_reached(irec, ino_offset);
+				add_inode_ref(current_irec, current_ino_offset);
 			} else  {
 				junkit =3D 1;
 				do_warn(_("entry \"%s\" in directory inode %llu"

------------WpmrDzY9L2gCIlCYFMw2EE--
