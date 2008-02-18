Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:01:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1IN0t1j001860
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 15:00:57 -0800
Date: Tue, 19 Feb 2008 10:01:12 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch, debug, 2/2] Use power-of-2 size ktrace buffers
Message-ID: <20080218230112.GU155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Now that the ktrace_enter() code is using atomics,
the non-power-of-2 buffer sizes - which require modulus
operations to get the index - are showing up as using
substantial CPU in the profiles.

Force the buffer sizes to be rounded up to the nearest
power of two and use masking rather than modulus operations
to convert the index counter to the buffer index. This
reduces ktrace_enter overhead to 8% of a CPU time, and
again almost halves the trace intensive test runtime.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/support/ktrace.c |   22 ++++++++++++++--------
 fs/xfs/support/ktrace.h |    1 +
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/support/ktrace.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/ktrace.c	2008-02-18 15:33:13.849314747 +1100
+++ 2.6.x-xfs-new/fs/xfs/support/ktrace.c	2008-02-18 15:33:16.920921133 +1100
@@ -24,7 +24,7 @@ static int          ktrace_zentries;
 void __init
 ktrace_init(int zentries)
 {
-	ktrace_zentries = zentries;
+	ktrace_zentries = roundup_pow_of_two(zentries);
 
 	ktrace_hdr_zone = kmem_zone_init(sizeof(ktrace_t),
 					"ktrace_hdr");
@@ -47,13 +47,16 @@ ktrace_uninit(void)
  * ktrace_alloc()
  *
  * Allocate a ktrace header and enough buffering for the given
- * number of entries.
+ * number of entries. Round the number of entries up to a
+ * power of 2 so we can do fast masking to get the index from
+ * the atomic index counter.
  */
 ktrace_t *
 ktrace_alloc(int nentries, unsigned int __nocast sleep)
 {
 	ktrace_t        *ktp;
 	ktrace_entry_t  *ktep;
+	int		entries;
 
 	ktp = (ktrace_t*)kmem_zone_alloc(ktrace_hdr_zone, sleep);
 
@@ -70,11 +73,12 @@ ktrace_alloc(int nentries, unsigned int 
 	/*
 	 * Special treatment for buffers with the ktrace_zentries entries
 	 */
-	if (nentries == ktrace_zentries) {
+	entries = roundup_pow_of_two(nentries);
+	if (entries == ktrace_zentries) {
 		ktep = (ktrace_entry_t*)kmem_zone_zalloc(ktrace_ent_zone,
 							    sleep);
 	} else {
-		ktep = (ktrace_entry_t*)kmem_zalloc((nentries * sizeof(*ktep)),
+		ktep = (ktrace_entry_t*)kmem_zalloc((entries * sizeof(*ktep)),
 							    sleep | KM_LARGE);
 	}
 
@@ -91,7 +95,9 @@ ktrace_alloc(int nentries, unsigned int 
 	}
 
 	ktp->kt_entries  = ktep;
-	ktp->kt_nentries = nentries;
+	ktp->kt_nentries = entries;
+	ASSERT(is_power_of_2(entries));
+	ktp->kt_index_mask = entries - 1;
 	atomic_set(&ktp->kt_index, 0);
 	ktp->kt_rollover = 0;
 	return ktp;
@@ -160,7 +166,7 @@ ktrace_enter(
 	 * Grab an entry by pushing the index up to the next one.
 	 */
 	index = atomic_add_return(1, &ktp->kt_index);
-	index = (index - 1) % ktp->kt_nentries;
+	index = (index - 1) & ktp->kt_index_mask;
 	if (!ktp->kt_rollover && index == ktp->kt_nentries - 1)
 		ktp->kt_rollover = 1;
 
@@ -197,7 +203,7 @@ ktrace_nentries(
 	if (ktp == NULL)
 		return 0;
 
-	index = atomic_read(&ktp->kt_index) % ktp->kt_nentries;
+	index = atomic_read(&ktp->kt_index) & ktp->kt_index_mask;
 	return (ktp->kt_rollover ? ktp->kt_nentries : index);
 }
 
@@ -223,7 +229,7 @@ ktrace_first(ktrace_t   *ktp, ktrace_sna
 	int             nentries;
 
 	if (ktp->kt_rollover)
-		index = atomic_read(&ktp->kt_index) % ktp->kt_nentries;
+		index = atomic_read(&ktp->kt_index) & ktp->kt_index_mask;
 	else
 		index = 0;
 
Index: 2.6.x-xfs-new/fs/xfs/support/ktrace.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/ktrace.h	2008-02-18 15:32:28.911073469 +1100
+++ 2.6.x-xfs-new/fs/xfs/support/ktrace.h	2008-02-18 15:33:16.920921133 +1100
@@ -31,6 +31,7 @@ typedef struct ktrace_entry {
 typedef struct ktrace {
 	int		kt_nentries;	/* number of entries in trace buf */
 	atomic_t	kt_index;	/* current index in entries */
+	unsigned int	kt_index_mask;
 	int		kt_rollover;
 	ktrace_entry_t	*kt_entries;	/* buffer of entries */
 } ktrace_t;
