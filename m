Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qABMnwZT175819 for <xfs@oss.sgi.com>; Sun, 11 Nov 2012 16:49:58 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	115hnoJp5meCaIDQ for <xfs@oss.sgi.com>;
	Sun, 11 Nov 2012 14:51:58 -0800 (PST)
Date: Mon, 12 Nov 2012 09:51:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: add CRC infrastructure
Message-ID: <20121111225157.GO24575@dastard>
References: <1352295452-4726-1-git-send-email-david@fromorbit.com>
	<1352295452-4726-2-git-send-email-david@fromorbit.com>
	<509D7F1A.3090201@sgi.com> <20121111012643.GH6434@dastard>
	<50A00274.1080604@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A00274.1080604@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Nov 11, 2012 at 01:54:28PM -0600, Mark Tinguely wrote:
> On 11/10/12 19:26, Dave Chinner wrote:
> >On Fri, Nov 09, 2012 at 04:09:30PM -0600, Mark Tinguely wrote:
> >>On 11/07/12 07:37, Dave Chinner wrote:
> >>>From: Christoph Hellwig<hch@lst.de>
> >>>
> >>>  - add a mount feature bit for CRC enabled filesystems
> >>>  - add some helpers for generating and verifying the CRCs
> >>>  - add a copy_uuid helper
> >>>
> >>>The checksumming helpers are losely based on similar ones in sctp,
> >>>all other bits come from Dave Chinner.
> >>>
> >>>Signed-off-by: Christoph Hellwig<hch@lst.de>
> >>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >>>---
> >>>+/*
> >>>+ * Calculate the intermediate checksum for a buffer that has the CRC field
> >>>+ * inside it.  The offset of the 32bit crc fields is passed as the
> >>>+ * cksum_offset parameter.
> >>>+ */
> >>>+static inline __uint32_t
> >>>+xfs_start_cksum(char *buffer, size_t length, unsigned long cksum_offset)
> >>>+{
> >>>+	__uint32_t zero = 0;
> >>>+	__uint32_t crc;
> >>>+
> >>>+	/* Calculate CRC up to the checksum. */
> >>>+	crc = crc32c(XFS_CRC_SEED, buffer, cksum_offset);
> >>>+
> >>>+	/* Skip checksum field */
> >>>+	crc = crc32c(crc,&zero, sizeof(__u32));
> >>
> >>I know this came from sctp and I know I can't convince you to copy/null
> >>the *cksum_offset to make one block for those with hardware crc32c devices.
> >>
> >>Since the *cksum_offset value is never used in creating and verifying
> >>the checksum, the 4 bytes of zeros does not add any new information,
> >>why not just drop it from the cksum calculation?
> >
> >Because it gives a different CRC value. If we zero the CRC field,
> >and then do an entire block CRC ignoring the location of the CRC, we
> >get the same value as using the above algorithm. While we aren't
> >going to do this type of verification/calculation in the kernel
> >code, there are use cases for it, say in repair, where we don't have
> >to worry about multiple verifications of the object occurring.
> >
> >Hence by making sure we zero the CRC field during the calculation,
> >we retain the flexibility of doing faster, single pass calculation
> >and verification where it makes sense to use it.  If we optimise
> >away the zero block for the CRC, then we that flexibility when it
> >comes to implementing other tools that check and recalculate CRC
> >values.
> 
> I was mostly thinking about down the road when crc32c offloading is
> common. The copy/null/checksum/replace model of the routine can be done
> anytime that it make sense to do so (as long as only one checksum can
> happen at one time).

Sure, but it is already common - the crypto framework already has a
module for offloading CRC32c to intel CPUs rather than using the
generic implementation:

The guest:

$ grep -A 8 crc32c /proc/crypto
name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

The host:

$ $ grep -A 8 crc32c /proc/crypto
name         : crc32c
driver       : crc32c-intel
module       : crc32c_intel
priority     : 200
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

If the hardware offload is to slow for small ranges, then that is up
to the crypto driver to deal with (e.g. by not offloading it).

> 
> >
> >>>+	/* Calculate the rest of the CRC. */
> >>>+	return crc32c(crc,&buffer[cksum_offset + sizeof(__be32)],
> >>>+		      length - (cksum_offset + sizeof(__be32)));
> >>>+}
> >>>+
> >>>+/*
> >>>+ * Convert the intermediate checksum to the final ondisk format.
> >>>+ *
> >>>+ * Note that crc32c is already endianess agnostic, so no additional
> >>>+ * byte swap is needed.
> >>>+ */
> >>>+static inline __be32
> >>>+xfs_end_cksum(__uint32_t crc)
> >>>+{
> >>>+	return (__force __be32)~crc;
> >>>+}
> >>>+
> >>
> >>Wouldn't you have to cpu_to_le32() for big endian machines?
> >
> >Good catch, I hadn't noticed that fix - it's been quite a while
> >since this particular patch was originally written. So, yeah, it
> >probably does need that fix.
> >
> >FWIW, I don't have a big endian machine immediately handy to test
> >this. Do you?
> 
> I am sure there is something in the pool. I will ask on Monday.
> Someone was going to do some testing on a big endian machine before the
> user space release anyway. I guess I just volunteered. A log recovery
> test from a different endian machine sounds interesting.

Won't work. Log records are written in machine format, not endian
neutral. Log recovery can only be done on a machine of the same
endianness. Something like the patch below just to output the CRCs
in host order will be sufficient to tell us whether they'll end up
the same or different on disk without swapping will do the trick.
(i.e. if both hosts output the same CRC value, then they'll have
different endianess on disk...)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

---
 fs/xfs/xfs_super.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e0b6863..26bd864 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -51,6 +51,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
 #include "xfs_trace.h"
+#include "xfs_cksum.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1504,6 +1505,35 @@ out_destroy_workqueues:
 	goto out_free_sb;
 }
 
+static void
+xfs_crc_test(void)
+{
+	static char	buf[512];
+	int		i;
+	__u32		crc;
+	__u32		vcrc;
+	__be32		ecrc;
+	__be32		evcrc;
+
+	for (i = 0; i < 512; i++) {
+		buf[i] = i & 0xff;
+	}
+
+	crc = xfs_start_cksum(buf, 512, 64);
+	ecrc = xfs_end_cksum(crc);
+
+	xfs_warn(NULL, "crc: normal val 0x%x/0x%x, verify = %s", crc, ecrc,
+		 xfs_verify_cksum(buf, 512, 64) ? "good" : "bad");
+
+	crc = crc32c(XFS_CRC_SEED, buf, 64);
+	crc = crc32c(crc, &buf[68], 512 - 68);
+	ecrc = xfs_end_cksum(crc);
+
+	xfs_warn(NULL, "crc: skipped zero val 0x%x/0x%x, verify = %s", crc, ecrc,
+		 xfs_verify_cksum(buf, 512, 64) ? "good" : "bad");
+
+}
+
 STATIC struct dentry *
 xfs_fs_mount(
 	struct file_system_type	*fs_type,
@@ -1511,6 +1546,7 @@ xfs_fs_mount(
 	const char		*dev_name,
 	void			*data)
 {
+	xfs_crc_test();
 	return mount_bdev(fs_type, flags, dev_name, data, xfs_fs_fill_super);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
