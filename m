Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 311677F60
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10D85304062
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:28 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id CfDqMxDVWGTQXYM7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:25 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/20] nfsd: pNFS block layout driver
Date: Thu, 22 Jan 2015 12:10:01 +0100
Message-Id: <1421925006-24231-16-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Add a small shim between core nfsd and filesystems to translate the
somewhat cumbersome pNFS data structures and semantics to something
more palatable for Linux filesystems.

Thanks to Rick McNeal for the old prototype pNFS blocklayout server
code, which gave a lot of inspiration to this version even if no
code is left from it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/nfs/pnfs-block-server.txt          |  37 ++++
 fs/nfsd/Makefile                                   |   2 +-
 fs/nfsd/blocklayout.c                              | 190 +++++++++++++++++++++
 fs/nfsd/blocklayoutxdr.c                           | 157 +++++++++++++++++
 fs/nfsd/blocklayoutxdr.h                           |  62 +++++++
 fs/nfsd/nfs4layouts.c                              |   8 +
 fs/nfsd/pnfs.h                                     |   1 +
 7 files changed, 456 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/filesystems/nfs/pnfs-block-server.txt
 create mode 100644 fs/nfsd/blocklayout.c
 create mode 100644 fs/nfsd/blocklayoutxdr.c
 create mode 100644 fs/nfsd/blocklayoutxdr.h

diff --git a/Documentation/filesystems/nfs/pnfs-block-server.txt b/Documentation/filesystems/nfs/pnfs-block-server.txt
new file mode 100644
index 0000000..2143673
--- /dev/null
+++ b/Documentation/filesystems/nfs/pnfs-block-server.txt
@@ -0,0 +1,37 @@
+pNFS block layout server user guide
+
+The Linux NFS server now supports the pNFS block layout extension.  In this
+case the NFS server acts as Metadata Server (MDS) for pNFS, which in addition
+to handling all the metadata access to the NFS export also hands out layouts
+to the clients to directly access the underlying block devices that are
+shared with the client.
+
+To use pNFS block layouts with with the Linux NFS server the exported file
+system needs to support the pNFS block layouts (currently just XFS), and the
+file system must sit on shared storage (typically iSCSI) that is accessible
+to the clients in addition to the MDS.  As of now the file system needs to
+sit directly on the exported volume, striping or concatenation of
+volumes on the MDS and clients is not supported yet.
+
+On the server, pNFS block volume support is automatically if the file system
+support it.  On the client make sure the kernel has the CONFIG_PNFS_BLOCK
+option enabled, the blkmapd daemon from nfs-utils is running, and the
+file system is mounted using the NFSv4.1 protocol version (mount -o vers=4.1).
+
+If the nfsd server needs to fence a non-responding client it calls
+/sbin/nfsd-recall-failed with the first argument set to the IP address of
+the client, and the second argument set to the device node without the /dev
+prefix for the file system to be fenced. Below is an example file that shows
+how to translate the device into a serial number from SCSI EVPD 0x80:
+
+cat > /sbin/nfsd-recall-failed << EOF
+#!/bin/sh
+
+CLIENT="$1"
+DEV="/dev/$2"
+EVPD=`sg_inq --page=0x80 ${DEV} | \
+	grep "Unit serial number:" | \
+	awk -F ': ' '{print $2}'`
+
+echo "fencing client ${CLIENT} serial ${EVPD}" >> /var/log/pnfsd-fence.log
+EOF
diff --git a/fs/nfsd/Makefile b/fs/nfsd/Makefile
index 6cba933..9a6028e 100644
--- a/fs/nfsd/Makefile
+++ b/fs/nfsd/Makefile
@@ -17,4 +17,4 @@ nfsd-$(CONFIG_NFSD_V3)	+= nfs3proc.o nfs3xdr.o
 nfsd-$(CONFIG_NFSD_V3_ACL) += nfs3acl.o
 nfsd-$(CONFIG_NFSD_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4idmap.o \
 			   nfs4acl.o nfs4callback.o nfs4recover.o
-nfsd-$(CONFIG_NFSD_PNFS) += nfs4layouts.o
+nfsd-$(CONFIG_NFSD_PNFS) += nfs4layouts.o blocklayout.o blocklayoutxdr.o
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
new file mode 100644
index 0000000..9bced6c
--- /dev/null
+++ b/fs/nfsd/blocklayout.c
@@ -0,0 +1,190 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
+ */
+#include <linux/exportfs.h>
+#include <linux/genhd.h>
+#include <linux/slab.h>
+#include <linux/raid_class.h>
+
+#include <linux/nfsd/debug.h>
+
+#include "blocklayoutxdr.h"
+#include "pnfs.h"
+
+#define NFSDDBG_FACILITY	NFSDDBG_PNFS
+
+
+static int
+nfsd4_block_get_device_info_simple(struct super_block *sb,
+		struct nfsd4_getdeviceinfo *gdp)
+{
+	struct pnfs_block_deviceaddr *dev;
+	struct pnfs_block_volume *b;
+
+	dev = kzalloc(sizeof(struct pnfs_block_deviceaddr) +
+		      sizeof(struct pnfs_block_volume), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	gdp->gd_device = dev;
+
+	dev->nr_volumes = 1;
+	b = &dev->volumes[0];
+
+	b->type = PNFS_BLOCK_VOLUME_SIMPLE;
+	b->simple.sig_len = PNFS_BLOCK_UUID_LEN;
+	return sb->s_export_op->get_uuid(sb, b->simple.sig, &b->simple.sig_len,
+			&b->simple.offset);
+}
+
+static __be32
+nfsd4_block_proc_getdeviceinfo(struct super_block *sb,
+		struct nfsd4_getdeviceinfo *gdp)
+{
+	if (sb->s_bdev != sb->s_bdev->bd_contains)
+		return nfserr_inval;
+	return nfserrno(nfsd4_block_get_device_info_simple(sb, gdp));
+}
+
+static __be32
+nfsd4_block_proc_layoutget(struct inode *inode, const struct svc_fh *fhp,
+		struct nfsd4_layoutget *args)
+{
+	struct nfsd4_layout_seg *seg = &args->lg_seg;
+	struct super_block *sb = inode->i_sb;
+	u32 block_size = (1 << inode->i_blkbits);
+	struct pnfs_block_extent *bex;
+	struct iomap iomap;
+	u32 device_generation = 0;
+	int error;
+
+	/*
+	 * We do not attempt to support I/O smaller than the fs block size,
+	 * or not aligned to it.
+	 */
+	if (args->lg_minlength < block_size) {
+		dprintk("pnfsd: I/O too small\n");
+		goto out_layoutunavailable;
+	}
+	if (seg->offset & (block_size - 1)) {
+		dprintk("pnfsd: I/O misaligned\n");
+		goto out_layoutunavailable;
+	}
+
+	/*
+	 * Some clients barf on non-zero block numbers for NONE or INVALID
+	 * layouts, so make sure to zero the whole structure.
+	 */
+	error = -ENOMEM;
+	bex = kzalloc(sizeof(*bex), GFP_KERNEL);
+	if (!bex)
+		goto out_error;
+	args->lg_content = bex;
+
+	error = sb->s_export_op->map_blocks(inode, seg->offset, seg->length,
+					    &iomap, seg->iomode != IOMODE_READ,
+					    &device_generation);
+	if (error) {
+		if (error == -ENXIO)
+			goto out_layoutunavailable;
+		goto out_error;
+	}
+
+	if (iomap.length < args->lg_minlength) {
+		dprintk("pnfsd: extent smaller than minlength\n");
+		goto out_layoutunavailable;
+	}
+
+	switch (iomap.type) {
+	case IOMAP_MAPPED:
+		if (seg->iomode == IOMODE_READ)
+			bex->es = PNFS_BLOCK_READ_DATA;
+		else
+			bex->es = PNFS_BLOCK_READWRITE_DATA;
+		bex->soff = (iomap.blkno << 9);
+		break;
+	case IOMAP_UNWRITTEN:
+		if (seg->iomode & IOMODE_RW) {
+			/*
+			 * Crack monkey special case from section 2.3.1.
+			 */
+			if (args->lg_minlength == 0) {
+				dprintk("pnfsd: no soup for you!\n");
+				goto out_layoutunavailable;
+			}
+
+			bex->es = PNFS_BLOCK_INVALID_DATA;
+			bex->soff = (iomap.blkno << 9);
+			break;
+		}
+		/*FALLTHRU*/
+	case IOMAP_HOLE:
+		if (seg->iomode == IOMODE_READ) {
+			bex->es = PNFS_BLOCK_NONE_DATA;
+			break;
+		}
+		/*FALLTHRU*/
+	case IOMAP_DELALLOC:
+	default:
+		WARN(1, "pnfsd: filesystem returned %d extent\n", iomap.type);
+		goto out_layoutunavailable;
+	}
+
+	error = nfsd4_set_deviceid(&bex->vol_id, fhp, device_generation);
+	if (error)
+		goto out_error;
+	bex->foff = iomap.offset;
+	bex->len = iomap.length;
+
+	seg->offset = iomap.offset;
+	seg->length = iomap.length;
+
+	dprintk("GET: %lld:%lld %d\n", bex->foff, bex->len, bex->es);
+	return 0;
+
+out_error:
+	seg->length = 0;
+	return nfserrno(error);
+out_layoutunavailable:
+	seg->length = 0;
+	return nfserr_layoutunavailable;
+}
+
+static __be32
+nfsd4_block_proc_layoutcommit(struct inode *inode,
+		struct nfsd4_layoutcommit *lcp)
+{
+	loff_t new_size = lcp->lc_last_wr + 1;
+	struct iattr iattr = { .ia_valid = 0 };
+	struct iomap *iomaps;
+	int nr_iomaps;
+	int error;
+
+	nr_iomaps = nfsd4_block_decode_layoutupdate(lcp->lc_up_layout,
+			lcp->lc_up_len, &iomaps, 1 << inode->i_blkbits);
+	if (nr_iomaps < 0)
+		return nfserrno(nr_iomaps);
+
+	if (lcp->lc_mtime.tv_nsec == UTIME_NOW ||
+	    timespec_compare(&lcp->lc_mtime, &inode->i_mtime) < 0)
+		lcp->lc_mtime = current_fs_time(inode->i_sb);
+	iattr.ia_valid |= ATTR_ATIME | ATTR_CTIME | ATTR_MTIME;
+	iattr.ia_atime = iattr.ia_ctime = iattr.ia_mtime = lcp->lc_mtime;
+
+	if (new_size > i_size_read(inode)) {
+		iattr.ia_valid |= ATTR_SIZE;
+		iattr.ia_size = new_size;
+	}
+
+	error = inode->i_sb->s_export_op->commit_blocks(inode, iomaps,
+			nr_iomaps, &iattr);
+	kfree(iomaps);
+	return nfserrno(error);
+}
+
+const struct nfsd4_layout_ops bl_layout_ops = {
+	.proc_getdeviceinfo	= nfsd4_block_proc_getdeviceinfo,
+	.encode_getdeviceinfo	= nfsd4_block_encode_getdeviceinfo,
+	.proc_layoutget		= nfsd4_block_proc_layoutget,
+	.encode_layoutget	= nfsd4_block_encode_layoutget,
+	.proc_layoutcommit	= nfsd4_block_proc_layoutcommit,
+};
diff --git a/fs/nfsd/blocklayoutxdr.c b/fs/nfsd/blocklayoutxdr.c
new file mode 100644
index 0000000..9da89fd
--- /dev/null
+++ b/fs/nfsd/blocklayoutxdr.c
@@ -0,0 +1,157 @@
+/*
+ * Copyright (c) 2014 Christoph Hellwig.
+ */
+#include <linux/sunrpc/svc.h>
+#include <linux/exportfs.h>
+#include <linux/nfs4.h>
+
+#include "nfsd.h"
+#include "blocklayoutxdr.h"
+
+#define NFSDDBG_FACILITY	NFSDDBG_PNFS
+
+
+__be32
+nfsd4_block_encode_layoutget(struct xdr_stream *xdr,
+		struct nfsd4_layoutget *lgp)
+{
+	struct pnfs_block_extent *b = lgp->lg_content;
+	int len = sizeof(__be32) + 5 * sizeof(__be64) + sizeof(__be32);
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, sizeof(__be32) + len);
+	if (!p)
+		return nfserr_toosmall;
+
+	*p++ = cpu_to_be32(len);
+	*p++ = cpu_to_be32(1);		/* we always return a single extent */
+
+	p = xdr_encode_opaque_fixed(p, &b->vol_id,
+			sizeof(struct nfsd4_deviceid));
+	p = xdr_encode_hyper(p, b->foff);
+	p = xdr_encode_hyper(p, b->len);
+	p = xdr_encode_hyper(p, b->soff);
+	*p++ = cpu_to_be32(b->es);
+	return 0;
+}
+
+static int
+nfsd4_block_encode_volume(struct xdr_stream *xdr, struct pnfs_block_volume *b)
+{
+	__be32 *p;
+	int len;
+
+	switch (b->type) {
+	case PNFS_BLOCK_VOLUME_SIMPLE:
+		len = 4 + 4 + 8 + 4 + b->simple.sig_len;
+		p = xdr_reserve_space(xdr, len);
+		if (!p)
+			return -ETOOSMALL;
+
+		*p++ = cpu_to_be32(b->type);
+		*p++ = cpu_to_be32(1);	/* single signature */
+		p = xdr_encode_hyper(p, b->simple.offset);
+		p = xdr_encode_opaque(p, b->simple.sig, b->simple.sig_len);
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return len;
+}
+
+__be32
+nfsd4_block_encode_getdeviceinfo(struct xdr_stream *xdr,
+		struct nfsd4_getdeviceinfo *gdp)
+{
+	struct pnfs_block_deviceaddr *dev = gdp->gd_device;
+	int len = sizeof(__be32), ret, i;
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, len + sizeof(__be32));
+	if (!p)
+		return nfserr_resource;
+
+	for (i = 0; i < dev->nr_volumes; i++) {
+		ret = nfsd4_block_encode_volume(xdr, &dev->volumes[i]);
+		if (ret < 0)
+			return nfserrno(ret);
+		len += ret;
+	}
+
+	/*
+	 * Fill in the overall length and number of volumes at the beginning
+	 * of the layout.
+	 */
+	*p++ = cpu_to_be32(len);
+	*p++ = cpu_to_be32(dev->nr_volumes);
+	return 0;
+}
+
+int
+nfsd4_block_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
+		u32 block_size)
+{
+	struct iomap *iomaps;
+	u32 nr_iomaps, expected, i;
+
+	if (len < sizeof(u32)) {
+		dprintk("%s: extent array too small: %u\n", __func__, len);
+		return -EINVAL;
+	}
+
+	nr_iomaps = be32_to_cpup(p++);
+	expected = sizeof(__be32) + nr_iomaps * NFS4_BLOCK_EXTENT_SIZE;
+	if (len != expected) {
+		dprintk("%s: extent array size mismatch: %u/%u\n",
+			__func__, len, expected);
+		return -EINVAL;
+	}
+
+	iomaps = kcalloc(nr_iomaps, sizeof(*iomaps), GFP_KERNEL);
+	if (!iomaps) {
+		dprintk("%s: failed to allocate extent array\n", __func__);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_iomaps; i++) {
+		struct pnfs_block_extent bex;
+
+		memcpy(&bex.vol_id, p, sizeof(struct nfsd4_deviceid));
+		p += XDR_QUADLEN(sizeof(struct nfsd4_deviceid));
+
+		p = xdr_decode_hyper(p, &bex.foff);
+		if (bex.foff & (block_size - 1)) {
+			dprintk("%s: unaligned offset %lld\n",
+				__func__, bex.foff);
+			goto fail;
+		}
+		p = xdr_decode_hyper(p, &bex.len);
+		if (bex.len & (block_size - 1)) {
+			dprintk("%s: unaligned length %lld\n",
+				__func__, bex.foff);
+			goto fail;
+		}
+		p = xdr_decode_hyper(p, &bex.soff);
+		if (bex.soff & (block_size - 1)) {
+			dprintk("%s: unaligned disk offset %lld\n",
+				__func__, bex.soff);
+			goto fail;
+		}
+		bex.es = be32_to_cpup(p++);
+		if (bex.es != PNFS_BLOCK_READWRITE_DATA) {
+			dprintk("%s: incorrect extent state %d\n",
+				__func__, bex.es);
+			goto fail;
+		}
+
+		iomaps[i].offset = bex.foff;
+		iomaps[i].length = bex.len;
+	}
+
+	*iomapp = iomaps;
+	return nr_iomaps;
+fail:
+	kfree(iomaps);
+	return -EINVAL;
+}
diff --git a/fs/nfsd/blocklayoutxdr.h b/fs/nfsd/blocklayoutxdr.h
new file mode 100644
index 0000000..fdc7903
--- /dev/null
+++ b/fs/nfsd/blocklayoutxdr.h
@@ -0,0 +1,62 @@
+#ifndef _NFSD_BLOCKLAYOUTXDR_H
+#define _NFSD_BLOCKLAYOUTXDR_H 1
+
+#include <linux/blkdev.h>
+#include "xdr4.h"
+
+struct iomap;
+struct xdr_stream;
+
+enum pnfs_block_extent_state {
+	PNFS_BLOCK_READWRITE_DATA	= 0,
+	PNFS_BLOCK_READ_DATA		= 1,
+	PNFS_BLOCK_INVALID_DATA		= 2,
+	PNFS_BLOCK_NONE_DATA		= 3,
+};
+
+struct pnfs_block_extent {
+	struct nfsd4_deviceid		vol_id;
+	u64				foff;
+	u64				len;
+	u64				soff;
+	enum pnfs_block_extent_state	es;
+};
+#define NFS4_BLOCK_EXTENT_SIZE		44
+
+enum pnfs_block_volume_type {
+	PNFS_BLOCK_VOLUME_SIMPLE	= 0,
+	PNFS_BLOCK_VOLUME_SLICE		= 1,
+	PNFS_BLOCK_VOLUME_CONCAT	= 2,
+	PNFS_BLOCK_VOLUME_STRIPE	= 3,
+};
+
+/*
+ * Random upper cap for the uuid length to avoid unbounded allocation.
+ * Not actually limited by the protocol.
+ */
+#define PNFS_BLOCK_UUID_LEN	128
+
+struct pnfs_block_volume {
+	enum pnfs_block_volume_type	type;
+	union {
+		struct {
+			u64		offset;
+			u32		sig_len;
+			u8		sig[PNFS_BLOCK_UUID_LEN];
+		} simple;
+	};
+};
+
+struct pnfs_block_deviceaddr {
+	u32				nr_volumes;
+	struct pnfs_block_volume	volumes[];
+};
+
+__be32 nfsd4_block_encode_getdeviceinfo(struct xdr_stream *xdr,
+		struct nfsd4_getdeviceinfo *gdp);
+__be32 nfsd4_block_encode_layoutget(struct xdr_stream *xdr,
+		struct nfsd4_layoutget *lgp);
+int nfsd4_block_decode_layoutupdate(__be32 *p, u32 len, struct iomap **iomapp,
+		u32 block_size);
+
+#endif /* _NFSD_BLOCKLAYOUTXDR_H */
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 1650075..7152250 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -26,6 +26,7 @@ static struct nfsd4_callback_ops nfsd4_cb_layout_ops;
 static const struct lock_manager_operations nfsd4_layouts_lm_ops;
 
 const struct nfsd4_layout_ops *nfsd4_layout_ops[LAYOUT_TYPE_MAX] =  {
+	[LAYOUT_BLOCK_VOLUME]	= &bl_layout_ops,
 };
 
 /* pNFS device ID to export fsid mapping */
@@ -116,8 +117,15 @@ nfsd4_set_deviceid(struct nfsd4_deviceid *id, const struct svc_fh *fhp,
 
 void nfsd4_setup_layout_type(struct svc_export *exp)
 {
+	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
+
 	if (exp->ex_flags & NFSEXP_NOPNFS)
 		return;
+
+	if (sb->s_export_op->get_uuid &&
+	    sb->s_export_op->map_blocks &&
+	    sb->s_export_op->commit_blocks)
+		exp->ex_layout_type = LAYOUT_BLOCK_VOLUME;
 }
 
 static void
diff --git a/fs/nfsd/pnfs.h b/fs/nfsd/pnfs.h
index a9616a4..fedb4d6 100644
--- a/fs/nfsd/pnfs.h
+++ b/fs/nfsd/pnfs.h
@@ -34,6 +34,7 @@ struct nfsd4_layout_ops {
 };
 
 extern const struct nfsd4_layout_ops *nfsd4_layout_ops[];
+extern const struct nfsd4_layout_ops bl_layout_ops;
 
 __be32 nfsd4_preprocess_layout_stateid(struct svc_rqst *rqstp,
 		struct nfsd4_compound_state *cstate, stateid_t *stateid,
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
