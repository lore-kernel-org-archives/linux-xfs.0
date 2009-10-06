Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96IpQhq085062 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 13:51:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF224174778F
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 11:52:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id miRZSjChQCrN2Pp2 for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 11:52:52 -0700 (PDT)
Date: Tue, 6 Oct 2009 14:52:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: allow using libblkid instead of libdisk
Message-ID: <20091006185252.GA10250@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: util-linux-ng@vger.kernel.org

Add a new --enable-blkid switch to use libblkid from util-linux to detect
the device geometry and check for existing partitions or filesystem on a
device.  Note that this requires the latest blkid from util-linux-ng git
for the topology calls, odler ones won't work.  If I had a little more
autoconf fu we might be able to detect a too early one, but right now it
just fails if it's too old and --enable-blkid is specified.  We also
stop building libdisk in the blkid case as it's an internal static library
not otherwise used.

For the actual checks I tried to stay as close as possible to the old
code, so we still don't check topology for external log devices.  I hope
to add this at a later stage.

As a small addition we also print a warning if trying to create a filesystem
on a partition that is not properly aligned.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/mkfs/Makefile
===================================================================
--- xfsprogs-dev.orig/mkfs/Makefile	2009-10-06 18:31:03.000000000 +0000
+++ xfsprogs-dev/mkfs/Makefile	2009-10-06 18:31:05.000000000 +0000
@@ -11,14 +11,27 @@ FSTYP = fstyp
 HFILES = xfs_mkfs.h
 CFILES = maxtrres.c proto.c xfs_mkfs.c
 
-LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBDISK) $(LIBRT) $(LIBPTHREAD)
-LTDEPENDENCIES = $(LIBXFS) $(LIBDISK)
+LLDLIBS = $(LIBXFS) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
+LTDEPENDENCIES = $(LIBXFS)
 LLDFLAGS = -static
 
+ifeq ($(ENABLE_BLKID),yes)
+LLDLIBS += $(LIBBLKID)
+CFLAGS += -DENABLE_BLKID
+else
+LLDLIBS += $(LIBDISK)
+LTDEPENDENCIES += $(LIBDISK)
+endif
+
+
 LSRCFILES = $(FSTYP).c
 LDIRT = $(FSTYP)
 
-default: $(FSTYP) $(LTCOMMAND)
+default: $(LTCOMMAND)
+
+ifneq ($(ENABLE_BLKID),yes)
+default: $(FSTYP)
+endif
 
 include $(BUILDRULES)
 
Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2009-10-06 18:31:03.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2009-10-06 18:45:58.000000000 +0000
@@ -17,12 +17,26 @@
  */
 
 #include <xfs/libxfs.h>
+#include <ctype.h>
+#ifdef ENABLE_BLKID
+#include <blkid/blkid.h>
+#else
 #include <disk/fstyp.h>
 #include <disk/volume.h>
-#include <ctype.h>
+#endif
 #include "xfs_mkfs.h"
 
 /*
+ * Device topology information.
+ */
+struct fs_topology {
+	int	dsunit;		/* stripe unit - data subvolume */
+	int	dswidth;	/* stripe width - data subvolume */
+	int	rtswidth;	/* stripe width - rt subvolume */
+	int	sectoralign;
+};
+
+/*
  * Prototypes for internal functions.
  */
 static void conflict(char opt, char *tab[], int oldidx, int newidx);
@@ -267,6 +281,105 @@ calc_stripe_factors(
 	}
 }
 
+#ifdef ENABLE_BLKID
+static int
+check_overwrite(
+	char		*device)
+{
+	const char	*type;
+	blkid_probe	pr;
+	int		ret = 0;
+
+	if (!device || !*device)
+		return 0;
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		return -1;
+
+	if (blkid_probe_enable_partitions(pr, 1))
+		goto out_free_probe;
+
+	if (blkid_do_fullprobe(pr))
+		goto out_free_probe;
+
+	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
+		fprintf(stderr,
+			_("%s: %s appears to contain an existing "
+			"filesystem (%s).\n"), progname, device, type);
+		ret = 1;
+	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
+		fprintf(stderr,
+			_("%s: %s appears to contain a partition "
+			"table (%s).\n"), progname, device, type);
+		ret = 1;
+	}
+
+out_free_probe:
+	blkid_free_probe(pr);
+	return ret;
+}
+
+static void blkid_get_topology(const char *device, int *sunit, int *swidth)
+{
+	blkid_topology tp;
+	blkid_probe pr;
+	unsigned long val;
+
+	pr = blkid_new_probe_from_filename(device);
+	if (!pr)
+		return;
+
+	tp = blkid_probe_get_topology(pr);
+	if (!tp)
+		goto out_free_probe;
+
+	/*
+	 * Blkid reports the information in terms of bytes, but we want it in
+	 * terms of 512 bytes blocks (just to convert it to bytes later..)
+	 *
+	 * If the reported values are just the normal 512 byte block size
+	 * do not bother to report anything.  It will just causes warnings
+	 * if people specifier larger stripe units or widths manually.
+	 */
+	val = blkid_topology_get_minimum_io_size(tp) >> 9;
+	if (val > 1)
+		*sunit = val;
+	val = blkid_topology_get_optimal_io_size(tp) >> 9;
+	if (val > 1)
+		*swidth = val;
+
+	if (blkid_topology_get_alignment_offset(tp) != 0) {
+		fprintf(stderr,
+			_("warning: device is not properly aligned %s\n"),
+			device);
+	}
+
+	blkid_free_probe(pr);
+	return;
+
+out_free_probe:
+	blkid_free_probe(pr);
+	fprintf(stderr,
+		_("warning: unable to probe device toplology for device %s\n"),
+		device);
+}
+
+static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
+{
+	if (!xi->disfile) {
+		const char *dfile = xi->volname ? xi->volname : xi->dname;
+
+		blkid_get_topology(dfile, &ft->dsunit, &ft->dswidth);
+	}
+
+	if (xi->rtname && !xi->risfile) {
+		int dummy;
+
+		blkid_get_topology(xi->rtname, &dummy, &ft->rtswidth);
+	}
+}
+#else /* ENABLE_BLKID */
 static int
 check_overwrite(
 	char		*device)
@@ -290,6 +403,24 @@ check_overwrite(
 	return 0;
 }
 
+static void get_topology(libxfs_init_t *xi, struct fs_topology *ft)
+{
+	char *dfile = xi->volname ? xi->volname : xi->dname;
+
+	if (!xi->disfile) {
+		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
+				&ft->dsunit, &ft->dswidth, &ft->sectoralign);
+	}
+
+	if (xi->rtname && !xi->risfile) {
+		int dummy1;
+
+		get_subvol_stripe_wrapper(dfile, SVTYPE_RT, &dummy1,
+					  &ft->rtswidth, &dummy1);
+	}
+}
+#endif /* ENABLE_BLKID */
+
 static void
 fixup_log_stripe_unit(
 	int		lsflag,
@@ -715,7 +846,6 @@ main(
 	char			*rtfile;
 	char			*rtsize;
 	xfs_sb_t		*sbp;
-	int			sectoralign;
 	int			sectorlog;
 	unsigned int		sectorsize;
 	__uint64_t		sector_mask;
@@ -725,8 +855,7 @@ main(
 	uuid_t			uuid;
 	int			worst_freelist;
 	libxfs_init_t		xi;
-	int 			xlv_dsunit;
-	int			xlv_dswidth;
+	struct fs_topology	ft;
 	int			lazy_sb_counters;
 
 	progname = basename(argv[0]);
@@ -1416,12 +1545,10 @@ main(
 		usage();
 	}
 
-	sectoralign = 0;
-	xlv_dsunit = xlv_dswidth = 0;
-	if (!xi.disfile)
-		get_subvol_stripe_wrapper(dfile, SVTYPE_DATA,
-				&xlv_dsunit, &xlv_dswidth, &sectoralign);
-	if (sectoralign) {
+	memset(&ft, 0, sizeof(ft));
+	get_topology(&xi, &ft);
+
+	if (ft.sectoralign) {
 		sectorsize = blocksize;
 		sectorlog = libxfs_highbit32(sectorsize);
 		if (loginternal) {
@@ -1569,14 +1696,15 @@ main(
 		 * and the underlying volume is striped, then set rtextblocks
 		 * to the stripe width.
 		 */
-		int		dummy1, rswidth;
+		int		rswidth;
 		__uint64_t	rtextbytes;
 
-		dummy1 = rswidth = 0;
+		rswidth = 0;
 
 		if (!norsflag && !xi.risfile && !(!rtsize && xi.disfile))
-			get_subvol_stripe_wrapper(dfile, SVTYPE_RT, &dummy1,
-						  &rswidth, &dummy1);
+			rswidth = ft.rtswidth;
+		else
+			rswidth = 0;
 
 		/* check that rswidth is a multiple of fs blocksize */
 		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
@@ -1823,27 +1951,27 @@ _("size %s specified for log subvolume i
 		agsize = dblocks / agcount + (dblocks % agcount != 0);
 	else
 		calc_default_ag_geometry(blocklog, dblocks,
-				xlv_dsunit | xlv_dswidth, &agsize, &agcount);
+				ft.dsunit | ft.dswidth, &agsize, &agcount);
 
 	if (!nodsflag) {
 		if (dsunit) {
-			if (xlv_dsunit && xlv_dsunit != dsunit) {
+			if (ft.dsunit && ft.dsunit != dsunit) {
 				fprintf(stderr,
 					_("%s: Specified data stripe unit %d "
 					"is not the same as the volume stripe "
 					"unit %d\n"),
-					progname, dsunit, xlv_dsunit);
+					progname, dsunit, ft.dsunit);
 			}
-			if (xlv_dswidth && xlv_dswidth != dswidth) {
+			if (ft.dswidth && ft.dswidth != dswidth) {
 				fprintf(stderr,
 					_("%s: Specified data stripe width %d "
 					"is not the same as the volume stripe "
 					"width %d\n"),
-					progname, dswidth, xlv_dswidth);
+					progname, dswidth, ft.dswidth);
 			}
 		} else {
-			dsunit = xlv_dsunit;
-			dswidth = xlv_dswidth;
+			dsunit = ft.dsunit;
+			dswidth = ft.dswidth;
 			nodsflag = 1;
 		}
 	} /* else dsunit & dswidth can't be set if nodsflag is set */
Index: xfsprogs-dev/Makefile
===================================================================
--- xfsprogs-dev.orig/Makefile	2009-10-06 18:31:03.000000000 +0000
+++ xfsprogs-dev/Makefile	2009-10-06 18:31:05.000000000 +0000
@@ -16,10 +16,14 @@ LDIRT = config.log .dep config.status co
 	Logs/* built .census install.* install-dev.* *.gz autom4te.cache/* \
 	libtool include/builddefs include/platform_defs.h
 
-LIB_SUBDIRS = libxfs libxlog libxcmd libhandle libdisk
+LIB_SUBDIRS = libxfs libxlog libxcmd libhandle $(LDISK)
 TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 		mdrestore repair rtcp m4 man doc po debian build
 
+ifneq ($(ENABLE_BLKID), yes)
+LIB_SUBDIRS += libdisk
+endif
+
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/platform_defs.h
@@ -36,10 +40,14 @@ db logprint: libxfs libxlog
 fsr: libhandle
 growfs: libxfs libxcmd
 io: libxcmd libhandle
-mkfs: libxfs libdisk
+mkfs: libxfs
 quota: libxcmd
 repair: libxfs libxlog
 
+ifneq ($(ENABLE_BLKID), yes)
+mkfs: libdisk
+endif
+
 ifeq ($(HAVE_BUILDDEFS), yes)
 include $(BUILDRULES)
 else
Index: xfsprogs-dev/configure.in
===================================================================
--- xfsprogs-dev.orig/configure.in	2009-10-06 18:31:03.000000000 +0000
+++ xfsprogs-dev/configure.in	2009-10-06 18:31:05.000000000 +0000
@@ -35,6 +35,12 @@ AC_ARG_ENABLE(termcap,
 	test $enable_termcap = yes && libtermcap="-ltermcap",)
 AC_SUBST(libtermcap)
 
+AC_ARG_ENABLE(blkid,
+[ --enable-blkid=[yes/no] Enable block device id library [default=no]],
+	test $enable_blkid = yes && libblkid="-lblkid",)
+AC_SUBST(libblkid)
+AC_SUBST(enable_blkid)
+
 AC_ARG_ENABLE(lib64,
 [ --enable-lib64=[yes/no] Enable lib64 support [default=yes]],,
 	enable_lib64=yes)
Index: xfsprogs-dev/include/builddefs.in
===================================================================
--- xfsprogs-dev.orig/include/builddefs.in	2009-10-06 18:31:03.000000000 +0000
+++ xfsprogs-dev/include/builddefs.in	2009-10-06 18:31:05.000000000 +0000
@@ -31,6 +31,7 @@ LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
 LIBREADLINE = @libreadline@
+LIBBLKID = @libblkid@
 LIBXFS = $(TOPDIR)/libxfs/libxfs.la
 LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
 LIBXLOG = $(TOPDIR)/libxlog/libxlog.la
@@ -85,6 +86,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 ENABLE_EDITLINE	= @enable_editline@
 ENABLE_READLINE	= @enable_readline@
+ENABLE_BLKID	= @enable_blkid@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
