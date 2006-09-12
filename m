Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Sep 2006 09:30:40 -0700 (PDT)
Received: from a.mx.filmlight.ltd.uk (host217-40-27-25.in-addr.btopenworld.com [217.40.27.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k8CGUKif032100
	for <xfs@oss.sgi.com>; Tue, 12 Sep 2006 09:30:27 -0700
Message-ID: <002601c6d687$ad012420$6701a8c0@BODDINGTON>
From: "Roger Willcocks" <roger@filmlight.ltd.uk>
Subject: LEAFN node level is N -- bogus warning
Date: Tue, 12 Sep 2006 17:22:41 +0100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0022_01C6D690.0DD70D70"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_0022_01C6D690.0DD70D70
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_0023_01C6D690.0DD70D70"

------=_NextPart_001_0023_01C6D690.0DD70D70
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

In xfs_repair / dir2.c there's a check for the 'level' of a directory leaf =
node within the btree hierarchy. A warning 'LEAFN node level is N' is gener=
ated if the level >=3D 1.

But leaf nodes don't have a /level/ member, although internal nodes do (com=
pare xfs_dir2_leaf_hdr_t and xfs_da_intnode_t). xfs_repair is actually test=
ing leaf->hdr.stale - so the warning is bogus.

The attached patch removes the test and make the relationship between magic=
 numbers and pointer types more explicit.

--
Roger


------=_NextPart_001_0023_01C6D690.0DD70D70
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Diso-8859-1">
<META content=3D"MSHTML 6.00.2900.2963" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff background=3D"">
<DIV><FONT face=3DArial size=3D2>In xfs_repair / dir2.c there's a check for=
 the=20
'level' of a directory leaf node within the btree hierarchy.&nbsp;A warning=
=20
'LEAFN node level is N' is generated if the level &gt;=3D 1.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>But leaf nodes don't have a /level/ member=
,=20
although internal nodes do (compare xfs_dir2_leaf_hdr_t and=20
xfs_da_intnode_t).&nbsp;xfs_repair is actually testing&nbsp;leaf-&gt;hdr.st=
ale=20
-&nbsp;so the warning is bogus.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>The attached patch removes the test and ma=
ke the=20
relationship between magic numbers and pointer types more explicit.</FONT><=
/DIV>
<DIV><FONT face=3DArial size=3D2></FONT><FONT face=3DArial size=3D2></FONT>=
&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>--</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>Roger</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_001_0023_01C6D690.0DD70D70--

------=_NextPart_000_0022_01C6D690.0DD70D70
Content-Type: application/octet-stream;
	name="dir2.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dir2.patch"

--- dir2.c.~1.19.~      2006-06-30 15:38:12.000000000 +0100
+++ dir2.c      2006-09-12 17:04:44.000000000 +0100
@@ -258,5 +258,6 @@
        xfs_dabuf_t             *bp;
        int                     i;
        int                     nex;
+       xfs_da_blkinfo_t        *info;
        xfs_da_intnode_t        *node;
        bmap_ext_t              lbmp;

@@ -268,5 +269,5 @@
         */
        bno =3D mp->m_dirleafblk;
        i =3D -1;
-       node =3D NULL;
+       info =3D NULL;
        da_cursor->active =3D 0;

        do {
@@ -291,2 +292,2 @@
                        goto error_out;
                }

-               node =3D bp->data;
+               info =3D bp->data;

-               if (INT_GET(node->hdr.info.magic, ARCH_CONVERT) =3D=3D
+               if (INT_GET(info->magic, ARCH_CONVERT) =3D=3D
                                        XFS_DIR2_LEAFN_MAGIC)  {
                        if ( i !=3D -1 ) {
                                do_warn(_("found non-root LEAFN node in ino=
de "
                                          "%llu bno =3D %u\n"),
                                        da_cursor->ino, bno);
                        }
-                       if (INT_GET(node->hdr.level, ARCH_CONVERT) >=3D 1) {
-                               do_warn(_("LEAFN node level is %d inode %ll=
u "
-                                         "bno =3D %u\n"),
-                                       INT_GET(node->hdr.level, ARCH_CONVE=
RT),
-                                               da_cursor->ino, bno);
-                       }
                        *rbno =3D 0;
                        da_brelse(bp);
                        return(1);
-               } else if (INT_GET(node->hdr.info.magic, ARCH_CONVERT) !=3D
+               } else if (INT_GET(info->magic, ARCH_CONVERT) !=3D
                                        XFS_DA_NODE_MAGIC)  {
                        da_brelse(bp);
                        do_warn(_("bad dir magic number 0x%x in inode %llu "
                                  "bno =3D %u\n"),
-                               INT_GET(node->hdr.info.magic, ARCH_CONVERT),
+                               INT_GET(info->magic, ARCH_CONVERT),
                                        da_cursor->ino, bno);
                        goto error_out;
                }
+               node =3D bp->data;
+               ASSERT(INT_GET(node->hdr.info.magic, ARCH_CONVERT) =3D=3D
+                      XFS_DA_NODE_MAGIC);
                if (INT_GET(node->hdr.count, ARCH_CONVERT) >
                                                mp->m_dir_node_ents)  {
                        da_brelse(bp);

------=_NextPart_000_0022_01C6D690.0DD70D70--
