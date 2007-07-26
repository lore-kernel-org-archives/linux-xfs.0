Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 16:31:43 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6QNVZbm032371
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 16:31:37 -0700
Date: Fri, 27 Jul 2007 09:31:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070726233129.GM12413810@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A8DF7E.4090006@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: markgw@sgi.com, David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 26, 2007 at 10:53:02AM -0700, Michael Nishimoto wrote:
> Mark Goodwin wrote:
> >David Chinner wrote:
> >>
> >> The next question is the hard one. What do we do when we detect
> >> a log record CRC error? Right now it just warns and sets a flag
> >> in the log. I think it should probably prevent log replay from
> >> replaying past this point (i.e. trim the head back to the last
> >> good log record) but I'm not sure what the best thing to do here.
> >>
> >> Comments?
> >
> >1. perhaps use a new flag XLOG_CRC_MISMATCH instead of 
> >XLOG_CHKSUM_MISMATCH
> >2. is there (or could there be if we added it), correction for n-bit 
> >errors?
> >
> >-- Mark
> >
> I don't see the original message in the archives.

Strange. I received the original email to a different address, so it
definitely got through the list daemon. I've put it inline at the
bottom of the mail.

> Is CRC checking being added to xfs log data?

Yes. it's a little used debug option right now, and I'm
planning on making it default behaviour.

> If so, what data has been collected to show that this needs to be added?

The size of high-end filesystems are now at the same order of
magnitude as the bit error rate of the storage hardware. e.g. 1PB =
10^16 bits. The bit error rate of high end FC drives? 1 in 10^16
bits.  For "enterprise" SATA drives? 1 in 10^15 bits. For desktop
SATA drives it's 1 in 10^14 bits (i.e. 1 in 10TB).

We've got filesystems capable of moving > 2 x 10^16 bits of data
*per day* and we see lots of instances of multi-TB arrays made out
of desktop SATA disks. Given the recent studies of long-term disk
reliability, these vendor figures are likely to be the best error
rates we can hope for.....

IOWs, we don't need evidence to justify this sort of error detection
detection because simple maths says there is going to be errors.  We
have to deal with that, and hence we are going to be adding CRC
checking to on-disk metadata structures so we can detect bit errors
that would otherwise go undetected and result in filesystem
corruption.

This means that instead of getting shutdown reports for some strange
and unreproducable btree corruption, we'll get a shutdown for a CRC
failure on the btree block. It is very likely that this will occur
much earlier than a subtle btree corruption would otherwise be
detected and hence we'll be less likely to propagate errors around
the fileystem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

Date: Wed, 25 Jul 2007 19:24:45 +1000
From: David Chinner <dgc@sgi.com>
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>
Subject: RFC: log record CRC validation

Folks,

I've just fixed up the never-used-debug log record checksumming
code with an eye to permanently enabling it for production
filesystems.

Firstly, I updated the simple 32 bit wide XOR checksum to use the
crc32c module. This places an new dependency on XFS - it will now
depends on CONFIG_LIBCRC32C. I'm also not sure what the best
method to use is - the little endian or big endian CRC algorithm
so I just went for the default (crc32c()).

This then resulted in recovery failing to verify the checksums,
and it turns out that is because xfs_pack_data() gets passed a
padded buffer and size to checksum (padded to 512 bytes), whereas
the unpacking (recovery) only checksummed the unpadded record
length. Hence this code probably never worked reliably if anyone
ever enabled it.

This does bring up a question - probably for Tim - do we only get
rounded to BBs or do we get rounded to the log stripe unit when
packing the log records before writeout? It seems froma quick test
that it is only BBs, but confirmation would be good....

The next question is the hard one. What do we do when we detect
a log record CRC error? Right now it just warns and sets a flag
in the log. I think it should probably prevent log replay from
replaying past this point (i.e. trim the head back to the last
good log record) but I'm not sure what the best thing to do here.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/Kconfig               |    2 -
 fs/xfs/linux-2.6/xfs_linux.h |    1 
 fs/xfs/xfs_log_priv.h        |    2 -
 fs/xfs/xfs_log_recover.c     |   80 ++++++++++++++++++-------------------------
 4 files changed, 37 insertions(+), 48 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_priv.h	2007-07-23 11:09:52.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_priv.h	2007-07-25 11:43:02.706927249 +1000
@@ -329,7 +329,7 @@ typedef struct xlog_rec_header {
 	int	  h_len;	/* len in bytes; should be 64-bit aligned: 4 */
 	xfs_lsn_t h_lsn;	/* lsn of this LR			:  8 */
 	xfs_lsn_t h_tail_lsn;	/* lsn of 1st LR w/ buffers not committed: 8 */
-	uint	  h_chksum;	/* may not be used; non-zero if used	:  4 */
+	__be32	  h_crc;	/* log record crc value			:  4 */
 	int	  h_prev_block; /* block number to previous LR		:  4 */
 	int	  h_num_logops;	/* number of log operations in this LR	:  4 */
 	uint	  h_cycle_data[XLOG_HEADER_CYCLE_SIZE / BBSIZE];
Index: 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log_recover.c	2007-07-25 10:42:54.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_log_recover.c	2007-07-25 19:10:12.185803348 +1000
@@ -3302,28 +3302,18 @@ xlog_recover_process_iunlinks(
 }
 
 
-#ifdef DEBUG
+#define XLOG_CHKSUM_SEED	0x4c585343	/* 'XLCS' */
 STATIC void
-xlog_pack_data_checksum(
+xlog_pack_data_crc(
 	xlog_t		*log,
 	xlog_in_core_t	*iclog,
 	int		size)
 {
-	int		i;
-	uint		*up;
-	uint		chksum = 0;
-
-	up = (uint *)iclog->ic_datap;
-	/* divide length by 4 to get # words */
-	for (i = 0; i < (size >> 2); i++) {
-		chksum ^= INT_GET(*up, ARCH_CONVERT);
-		up++;
-	}
-	INT_SET(iclog->ic_header.h_chksum, ARCH_CONVERT, chksum);
+	u32		crc;
+
+	crc = crc32c(XLOG_CHKSUM_SEED, iclog->ic_datap, size);
+	iclog->ic_header.h_crc = cpu_to_be32(crc);
 }
-#else
-#define xlog_pack_data_checksum(log, iclog, size)
-#endif
 
 /*
  * Stamp cycle number in every block
@@ -3340,7 +3330,7 @@ xlog_pack_data(
 	xfs_caddr_t		dp;
 	xlog_in_core_2_t	*xhdr;
 
-	xlog_pack_data_checksum(log, iclog, size);
+	xlog_pack_data_crc(log, iclog, size);
 
 	cycle_lsn = CYCLE_LSN_DISK(iclog->ic_header.h_lsn);
 
@@ -3368,41 +3358,38 @@ xlog_pack_data(
 	}
 }
 
-#if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
 STATIC void
-xlog_unpack_data_checksum(
+xlog_unpack_data_crc(
 	xlog_rec_header_t	*rhead,
 	xfs_caddr_t		dp,
 	xlog_t			*log)
 {
-	uint			*up = (uint *)dp;
-	uint			chksum = 0;
-	int			i;
-
-	/* divide length by 4 to get # words */
-	for (i=0; i < INT_GET(rhead->h_len, ARCH_CONVERT) >> 2; i++) {
-		chksum ^= INT_GET(*up, ARCH_CONVERT);
-		up++;
-	}
-	if (chksum != INT_GET(rhead->h_chksum, ARCH_CONVERT)) {
-	    if (rhead->h_chksum ||
-		((log->l_flags & XLOG_CHKSUM_MISMATCH) == 0)) {
-		    cmn_err(CE_DEBUG,
-			"XFS: LogR chksum mismatch: was (0x%x) is (0x%x)\n",
-			    INT_GET(rhead->h_chksum, ARCH_CONVERT), chksum);
-		    cmn_err(CE_DEBUG,
-"XFS: Disregard message if filesystem was created with non-DEBUG kernel");
-		    if (XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb)) {
-			    cmn_err(CE_DEBUG,
-				"XFS: LogR this is a LogV2 filesystem\n");
-		    }
-		    log->l_flags |= XLOG_CHKSUM_MISMATCH;
-	    }
+	u32	hdr_crc;
+	u32	crc;
+	int	size;
+
+	/* XXX: XLOG_LSUNITTOB for v2 logs? Initial tests
+	 * seem to indicate it's not needed... */
+	size = BBTOB(BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT)));
+	hdr_crc = be32_to_cpu(rhead->h_crc);
+	crc = crc32c(XLOG_CHKSUM_SEED, dp, size);
+	if (hdr_crc != crc) {
+		cmn_err(CE_ALERT, "XFS Recovery: Log Record CRC error: "
+				"was (0x%x), computed (0x%x), size 0x%x.\n",
+				hdr_crc, crc, size);
+		print_hex_dump(KERN_ALERT, "record: ", 0, 32, 1, dp, 32, 0);
+
+		/*
+		 * XXX: What should we do here? if we've detected a
+		 * log record corruption, then we can't recovery past
+		 * this point, right?
+		 *
+		 * Leave it to a higher layer to detect this flag and
+		 * act appropriately?
+		 */
+		log->l_flags |= XLOG_CHKSUM_MISMATCH;
 	}
 }
-#else
-#define xlog_unpack_data_checksum(rhead, dp, log)
-#endif
 
 STATIC void
 xlog_unpack_data(
@@ -3412,6 +3399,7 @@ xlog_unpack_data(
 {
 	int			i, j, k;
 	xlog_in_core_2_t	*xhdr;
+	xfs_caddr_t		odp = dp;
 
 	for (i = 0; i < BTOBB(INT_GET(rhead->h_len, ARCH_CONVERT)) &&
 		  i < (XLOG_HEADER_CYCLE_SIZE / BBSIZE); i++) {
@@ -3429,7 +3417,7 @@ xlog_unpack_data(
 		}
 	}
 
-	xlog_unpack_data_checksum(rhead, dp, log);
+	xlog_unpack_data_crc(rhead, odp, log);
 }
 
 STATIC int
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-07-23 17:16:56.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2007-07-25 11:47:07.411080498 +1000
@@ -76,6 +76,7 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/crc32c.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
Index: 2.6.x-xfs-new/fs/xfs/Kconfig
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/Kconfig	2007-01-16 10:54:14.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/Kconfig	2007-07-25 12:16:50.804060182 +1000
@@ -1,6 +1,6 @@
 config XFS_FS
 	tristate "XFS filesystem support"
-	depends on BLOCK
+	depends on BLOCK && LIBCRC32C
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
