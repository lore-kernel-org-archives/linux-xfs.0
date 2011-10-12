Return-Path: <xfs-bounces@oss.sgi.com>
Received: from oss.sgi.com (localhost [127.0.0.1])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id p9C6xfSJ046011;
	Wed, 12 Oct 2011 01:59:41 -0500
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9C6xc2C045996 for <xfs@oss.sgi.com>; Wed, 12 Oct 2011 01:59:38 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8A9F1C80ED2
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:59:35 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id Ryj257GvUPBZfOjv
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:59:35 -0700 (PDT)
Received: by bkbzt12 with SMTP id zt12so770616bkb.26
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 23:59:34 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 12 Oct 2011 17:59:34 +1100
Message-ID: <CAOmWOSDnJ-wC73AhJwMpWzFrOaLPoX7xC0ppPwthsdJfad3t7w@mail.gmail.com>
Subject: XFS Hex Offset Map/Values
From: Peter McManus <maltmanic@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5134513930449178785=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5134513930449178785==
Content-Type: multipart/alternative; boundary=001517477fe40f236804af14910d

--001517477fe40f236804af14910d
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I'm fairly new to XFS and am preparing a report (for both my own and my
team's education) on the low-level partition structure of an XFS primary
superblock. This is from a computer forensic perspective.

I'm currently trying to determine the actual hexidecimal offset structure
for all the fields within a primary superblock of an XFS partition.

For example, I know that the value for the field XFS_SB_MAGIC is 0x58465342
as this is readily available in XFS documentation, however I need to know
the hex offsets, byte lengths, and method of interpretation for all of the
following fields as defined within xfs_sb:

__uint32_t          sb_magicnum;         /* magic number == XFS_SB_MAGIC */
__uint32_t          sb_blocksize;           /* logical block size, bytes */
xfs_drfsbno_t      sb_dblocks;            /* number of data blocks */
xfs_drfsbno_t      sb_rblocks;             /* number of realtime blocks */
xfs_drtbno_t        sb_rextents;           /* number of realtime extents */
uuid_t                  sb_uuid;                 /* file system unique id */
xfs_dfsbno_t       sb_logstart;            /* starting block of log if
internal */
xfs_ino_t             sb_rootino;             /* root inode number */
xfs_ino_t             sb_rbmino;             /* bitmap inode for realtime
extents */
xfs_ino_t             sb_rsumino;           /* summary inode for rt bitmap
*/
xfs_agblock_t      sb_rextsize;           /* realtime extent size, blocks */
xfs_agblock_t       sb_agblocks;        /* size of an allocation group */
xfs_agnumber_t   sb_agcount;         /* number of allocation groups */
xfs_extlen_t         sb_rbmblocks;      /* number of rt bitmap blocks */
xfs_extlen_t        sb_logblocks;        /* number of log blocks */
__uint16_t           sb_versionnum;    /* header version == XFS_SB_VERSION
*/
__uint16_t           sb_sectsize;         /* volume sector size, bytes */
__uint16_t           sb_inodesize;       /* inode size, bytes */
__uint16_t           sb_inopblock;      /* inodes per block */
char                     sb_fname[12];     /* file system name */
__uint8_t             sb_blocklog;        /* log2 of sb_blocksize */
__uint8_t             sb_sectlog;          /* log2 of sb_sectsize */
__uint8_t             sb_inodelog;        /* log2 of sb_inodesize */
__uint8_t             sb_inopblog;        /* log2 of sb_inopblock */
__uint8_t             sb_agblklog;        /* log2 of sb_agblocks (rounded
up) */
__uint8_t             sb_rextslog;         /* log2 of sb_rextents */
__uint8_t             sb_inprogress;     /* mkfs is in progress, don't mount
*/
__uint8_t             sb_imax_pct;       /* max % of fs for inode space */

At http://kerneldox.net/dir_73a2d815072069310dd9b6b9499ac462.html I was able
to look through the code of the "alloc" files for further info however was
not able to find a full or definitive list. I understand that it may be
possible that the field values are contiguous but I still require a byte
length description for each field.

Can someone please let me know if/where I can find documentation for this
kind of very low level partition structure analysis?

Also, can you please tell me if the values are all in little or big endian?
Some file systems, particularly those of mobile phones, use both little and
big though I can't see a reason for the use of alternating values within XFS
(but then again I'm relatively novice to this).

Thank you for your time.

P. McManus

--001517477fe40f236804af14910d
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br>I&#39;m fairly new to XFS and am preparing a report (for both my=
 own and my team&#39;s education) on the low-level partition structure of a=
n XFS primary superblock. This is from a computer forensic perspective.<br>
<br>I&#39;m currently trying to determine the actual hexidecimal offset str=
ucture for all the fields within a primary superblock of an XFS partition.<=
br><br>For example, I know that the value for the field XFS_SB_MAGIC is 0x5=
8465342 as this is readily available in XFS documentation, however I need t=
o know the hex offsets, byte lengths, and method of interpretation for all =
of the following fields as defined within xfs_sb:<br>
<br>__uint32_t=A0=A0=A0 =A0 =A0=A0=A0 sb_magicnum;=A0 =A0 =A0=A0=A0=A0 /* m=
agic number =3D=3D XFS_SB_MAGIC */<br>__uint32_t=A0=A0 =A0=A0 =A0 =A0 sb_bl=
ocksize;=A0 =A0 =A0=A0=A0=A0 =A0 /* logical block size, bytes */<br>xfs_drf=
sbno_t =A0 =A0=A0 sb_dblocks;=A0=A0=A0 =A0 =A0=A0=A0 =A0 /* number of data =
blocks */<br>
xfs_drfsbno_t =A0 =A0=A0 sb_rblocks;=A0=A0 =A0 =A0 =A0=A0=A0=A0=A0 /* numbe=
r of realtime blocks */<br>xfs_drtbno_t=A0 =A0 =A0 =A0 sb_rextents;=A0 =A0 =
=A0 =A0 =A0=A0 /* number of realtime extents */<br>uuid_t=A0=A0=A0=A0=A0=A0=
 =A0 =A0 =A0 =A0 =A0=A0 sb_uuid;=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0=A0 =A0 /* f=
ile system unique id */<br>
xfs_dfsbno_t=A0=A0 =A0 =A0 sb_logstart;=A0 =A0 =A0 =A0 =A0=A0=A0 /* startin=
g block of log if internal */<br>xfs_ino_t=A0=A0=A0 =A0 =A0 =A0=A0 =A0 sb_r=
ootino;=A0=A0=A0 =A0 =A0 =A0=A0=A0=A0 /* root inode number */<br>xfs_ino_t=
=A0=A0=A0 =A0 =A0 =A0 =A0=A0 sb_rbmino;=A0=A0=A0 =A0 =A0 =A0=A0=A0=A0 /* bi=
tmap inode for realtime extents */<br>
xfs_ino_t=A0=A0 =A0 =A0 =A0=A0=A0 =A0 sb_rsumino;=A0=A0 =A0 =A0 =A0=A0=A0 /=
* summary inode for rt bitmap */<br>xfs_agblock_t=A0=A0=A0=A0=A0 sb_rextsiz=
e;=A0=A0 =A0 =A0 =A0 =A0 /* realtime extent size, blocks */<br>xfs_agblock_=
t=A0=A0=A0 =A0=A0 sb_agblocks;=A0 =A0 =A0 =A0 /* size of an allocation grou=
p */<br>
xfs_agnumber_t =A0 sb_agcount;=A0=A0=A0 =A0 =A0=A0 /* number of allocation =
groups */<br>xfs_extlen_t=A0 =A0 =A0 =A0=A0 sb_rbmblocks; =A0 =A0=A0 /* num=
ber of rt bitmap blocks */<br>xfs_extlen_t =A0 =A0=A0 =A0 sb_logblocks; =A0=
 =A0 =A0=A0 /* number of log blocks */<br>
__uint16_t=A0=A0=A0 =A0 =A0=A0 =A0 sb_versionnum; =A0=A0 /* header version =
=3D=3D XFS_SB_VERSION */<br>__uint16_t=A0=A0 =A0=A0 =A0=A0 =A0 sb_sectsize;=
 =A0 =A0 =A0 =A0 /* volume sector size, bytes */<br>__uint16_t=A0=A0 =A0 =
=A0 =A0 =A0 sb_inodesize; =A0=A0 =A0=A0 /* inode size, bytes */<br>
__uint16_t=A0 =A0 =A0 =A0 =A0=A0 sb_inopblock;=A0=A0=A0=A0=A0 /* inodes per=
 block */<br>char=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0=A0 sb_fnam=
e[12];=A0=A0=A0=A0 /* file system name */<br>__uint8_t=A0=A0 =A0 =A0 =A0=A0=
 =A0=A0 sb_blocklog;=A0=A0=A0=A0=A0=A0=A0 /* log2 of sb_blocksize */<br>__u=
int8_t=A0=A0=A0 =A0 =A0 =A0=A0 =A0 sb_sectlog;=A0=A0=A0=A0=A0=A0=A0=A0=A0 /=
* log2 of sb_sectsize */<br>
__uint8_t=A0=A0 =A0 =A0 =A0=A0 =A0=A0 sb_inodelog;=A0=A0=A0=A0=A0=A0=A0 /* =
log2 of sb_inodesize */<br>__uint8_t=A0=A0 =A0 =A0 =A0=A0 =A0=A0 sb_inopblo=
g;=A0=A0=A0=A0=A0=A0=A0 /* log2 of sb_inopblock */<br>__uint8_t=A0=A0=A0=A0=
 =A0 =A0 =A0 =A0 sb_agblklog;=A0=A0 =A0 =A0=A0 /* log2 of sb_agblocks (roun=
ded up) */<br>
__uint8_t=A0 =A0 =A0 =A0=A0 =A0=A0=A0 sb_rextslog;=A0=A0 =A0 =A0 =A0 /* log=
2 of sb_rextents */<br>__uint8_t=A0=A0=A0 =A0 =A0 =A0=A0 =A0 sb_inprogress;=
=A0=A0=A0=A0 /* mkfs is in progress, don&#39;t mount */<br>__uint8_t=A0=A0=
=A0 =A0 =A0 =A0=A0 =A0 sb_imax_pct;=A0=A0=A0=A0=A0=A0 /* max % of fs for in=
ode space */<br>
<br>At <a href=3D"http://kerneldox.net/dir_73a2d815072069310dd9b6b9499ac462=
.html">http://kerneldox.net/dir_73a2d815072069310dd9b6b9499ac462.html</a> I=
 was able to look through the code of the &quot;alloc&quot; files for furth=
er info however was not able to find a full or definitive list. I understan=
d that it may be possible that the field values are contiguous but I still =
require a byte length description for each field.<br>
<br>Can someone please let me know if/where I can find documentation for th=
is kind of very low level partition structure analysis?<br><br>Also, can yo=
u please tell me if the values are all in little or big endian? Some file s=
ystems, particularly those of mobile phones, use both little and big though=
 I can&#39;t see a reason for the use of alternating values within XFS (but=
 then again I&#39;m relatively novice to this).<br>
<br>Thank you for your time.<br><br>P. McManus<br><br><br><div style=3D"vis=
ibility: hidden; left: -5000px; position: absolute; z-index: 9999; padding:=
 0px; margin-left: 0px; margin-top: 0px; overflow: hidden; word-wrap: break=
-word; color: black; font-size: 10px; text-align: left; line-height: 130%;"=
 id=3D"avg_ls_inline_popup">
</div>

--001517477fe40f236804af14910d--


--===============5134513930449178785==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5134513930449178785==--
