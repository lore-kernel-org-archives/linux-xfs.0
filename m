Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42131 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751009AbdIABA3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 21:00:29 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v810xErW010507
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:29 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0089730.ppops.net with ESMTP id 2cps6m91g2-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2017 18:00:29 -0700
From: Richard Wareing <rwareing@fb.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: [PATCH 1/3] xfs: Add rtdefault mount option
Message-ID: <25856B28-A65C-4C5B-890D-159F8822393D@fb.com>
Date: Thu, 31 Aug 2017 18:00:21 -0700
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello all,=20

It turns out, XFS real-time volumes are actually a very useful/cool =
feature, I am wondering if there is support in the community to make =
this feature a bit more user friendly, easier to operate and interact =
with. To kick things off I bring patches table :).

For those who aren't familiar with real-time XFS volumes, they are =
basically a method of storing the data blocks of some files on a =
separate device. In our specific application, are using real-time =
devices to store large files (>256KB) on HDDS, while all metadata & =
journal updates goto an SSD of suitable endurance & capacity. We also =
see use-cases for this for distributed storage systems such as GlusterFS =
which are heavy in metadata operations (80%+ of IOPs). By using =
real-time devices to tier your XFS filesystem storage, you can =
dramatically reduce HDD IOPs (50% in our case) and dramatically improve =
metadata and small file latency (HDD->SSD like reductions).

Here are the features in the proposed patch set:

1. rtdefault  - Defaulting block allocations to the real-time device via =
a mount flag rtdefault, vs using an inheritance flag or ioctl's. This =
options gives users tier'ing of their metadata out of the box with ease, =
and in a manner more users are familiar with (mount flags), vs having to =
set inheritance bits or use ioctls (many distributed storage developers =
are resistant to including FS specific code into their stacks).

2. rtstatfs  - Returning real-time block device free space instead of =
the non-realtime device via the "rtstatfs" flag. This creates an =
experience/semantics which is a bit more familiar to users if they use =
real-time in a tiering configuration. "df" reports the space on your =
HDDs, and the metadata space can be returned by a tool like xfs_info (I =
have patches for this too if there is interest) or xfs_io. I think this =
might be a bit more intuitive for the masses than the reverse (having to =
goto xfs_io for the HDD space, and df for the SSD metadata).

3. rtfallocmin - This option can be combined with either rtdefault or =
standalone. When combined with rtdefault, it uses fallocate as "signal" =
to *exempt* storage on the real-time device, automatically promoting =
small fallocations to the SSD, while directing larger ones (or =
fallocation-less creations) to the HDD. This option also works really =
well with tools like "rsync" which support fallocate (--preallocate =
flag) so users can easily promote/demote files to/from the SSD.

Ideally, I'd like to help build-out more tiering features into XFS if =
there is interest in the community, but figured I'd start with these =
patches first.  Other ideas/improvements: automatic eviction from SSD =
once file grows beyond rtfallocmin, automatic fall-back to real-time =
device if non-RT device (SSD) is out of blocks, add support for the more =
sophisticated AG based block allocator to RT (bitmapped version works =
well for us, but multi-threaded use-cases might not do as well).

Looking forward to getting feedback!

Richard Wareing

Note: The patches should patch clean against the XFS Kernel master =
branch @ https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git (SHA: =
6f7da290413ba713f0cdd9ff1a2a9bb129ef4f6c).

=3D=3D=3D=3D=3D=3D=3D

- Adds rtdefault mount option to default writes to real-time device.
This removes the need for ioctl calls or inheritance bits to get files
to flow to real-time device.
- Enables XFS to store FS metadata on non-RT device (e.g. SSD) while
storing data blocks on real-time device.  Negates any code changes by
application, install kernel, format, mount and profit.
---
fs/xfs/xfs_inode.c |  8 ++++++++
fs/xfs/xfs_mount.h |  5 +++++
fs/xfs/xfs_super.c | 13 ++++++++++++-
3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ec9826c..1611195 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -873,6 +873,14 @@ xfs_ialloc(
		break;
	case S_IFREG:
	case S_IFDIR:
+		/* Set flags if we are defaulting to real-time device */
+		if (mp->m_rtdev_targp !=3D NULL &&
+		   mp->m_flags & XFS_MOUNT_RTDEFAULT) {
+			if (S_ISDIR(mode))
+				ip->i_d.di_flags |=3D =
XFS_DIFLAG_RTINHERIT;
+			else if (S_ISREG(mode))
+				ip->i_d.di_flags |=3D =
XFS_DIFLAG_REALTIME;
+		}
		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
			uint64_t	di_flags2 =3D 0;
			uint		di_flags =3D 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9fa312a..da25398 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -243,6 +243,11 @@ typedef struct xfs_mount {
						   allocator */
#define XFS_MOUNT_NOATTR2	(1ULL << 25)	/* disable use of attr2 =
format */

+/* FB Real-time device options */
+#define XFS_MOUNT_RTDEFAULT	(1ULL << 61)	/* Always allocate =
blocks from
+						 * RT device
+						 */
+
#define XFS_MOUNT_DAX		(1ULL << 62)	/* TEST ONLY! */


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 455a575..e4f85a9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -83,7 +83,7 @@ enum {
	Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota, =
Opt_prjquota,
	Opt_uquota, Opt_gquota, Opt_pquota,
	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, =
Opt_qnoenforce,
-	Opt_discard, Opt_nodiscard, Opt_dax, Opt_err,
+	Opt_discard, Opt_nodiscard, Opt_dax, Opt_rtdefault, Opt_err,
};

static const match_table_t tokens =3D {
@@ -133,6 +133,9 @@ static const match_table_t tokens =3D {

	{Opt_dax,	"dax"},		/* Enable direct access to bdev =
pages */

+#ifdef CONFIG_XFS_RT
+	{Opt_rtdefault,	"rtdefault"},	/* Default to real-time device =
*/
+#endif
	/* Deprecated mount options scheduled for removal */
	{Opt_barrier,	"barrier"},	/* use writer barriers for log =
write and
					 * unwritten extent conversion =
*/
@@ -367,6 +370,11 @@ xfs_parseargs(
		case Opt_nodiscard:
			mp->m_flags &=3D ~XFS_MOUNT_DISCARD;
			break;
+#ifdef CONFIG_XFS_RT
+		case Opt_rtdefault:
+			mp->m_flags |=3D XFS_MOUNT_RTDEFAULT;
+			break;
+#endif
#ifdef CONFIG_FS_DAX
		case Opt_dax:
			mp->m_flags |=3D XFS_MOUNT_DAX;
@@ -492,6 +500,9 @@ xfs_showargs(
		{ XFS_MOUNT_DISCARD,		",discard" },
		{ XFS_MOUNT_SMALL_INUMS,	",inode32" },
		{ XFS_MOUNT_DAX,		",dax" },
+#ifdef CONFIG_XFS_RT
+		{ XFS_MOUNT_RTDEFAULT,          ",rtdefault" },
+#endif
		{ 0, NULL }
	};
	static struct proc_xfs_info xfs_info_unset[] =3D {
--=20
2.9.3=
