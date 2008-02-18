Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 15:00:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1IMxquY001471
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 14:59:55 -0800
Date: Tue, 19 Feb 2008 10:00:10 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch, debug, 1/2] use atomic counters for ktrace buffer indexes
Message-ID: <20080218230010.GT155407@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

ktrace_enter() is consuming vast amounts of CPU time
due to the use of a single global lock for protecting
buffer index increments. Change it to use per-buffer
atomic counters - this reduces ktrace_enter() overhead
during a trace intensive test on a 4p machine from 58%
of all CPU time to 12% and halves test runtime.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/support/ktrace.c |   21 ++++++++-------------
 fs/xfs/support/ktrace.h |    2 +-
 2 files changed, 9 insertions(+), 14 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/support/ktrace.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/ktrace.c	2008-02-15 17:02:00.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/support/ktrace.c	2008-02-18 15:33:13.849314747 +1100
@@ -92,7 +92,7 @@ ktrace_alloc(int nentries, unsigned int 
 
 	ktp->kt_entries  = ktep;
 	ktp->kt_nentries = nentries;
-	ktp->kt_index    = 0;
+	atomic_set(&ktp->kt_index, 0);
 	ktp->kt_rollover = 0;
 	return ktp;
 }
@@ -151,8 +151,6 @@ ktrace_enter(
 	void            *val14,
 	void            *val15)
 {
-	static DEFINE_SPINLOCK(wrap_lock);
-	unsigned long	flags;
 	int             index;
 	ktrace_entry_t  *ktep;
 
@@ -161,12 +159,8 @@ ktrace_enter(
 	/*
 	 * Grab an entry by pushing the index up to the next one.
 	 */
-	spin_lock_irqsave(&wrap_lock, flags);
-	index = ktp->kt_index;
-	if (++ktp->kt_index == ktp->kt_nentries)
-		ktp->kt_index = 0;
-	spin_unlock_irqrestore(&wrap_lock, flags);
-
+	index = atomic_add_return(1, &ktp->kt_index);
+	index = (index - 1) % ktp->kt_nentries;
 	if (!ktp->kt_rollover && index == ktp->kt_nentries - 1)
 		ktp->kt_rollover = 1;
 
@@ -199,11 +193,12 @@ int
 ktrace_nentries(
 	ktrace_t        *ktp)
 {
-	if (ktp == NULL) {
+	int	index;
+	if (ktp == NULL)
 		return 0;
-	}
 
-	return (ktp->kt_rollover ? ktp->kt_nentries : ktp->kt_index);
+	index = atomic_read(&ktp->kt_index) % ktp->kt_nentries;
+	return (ktp->kt_rollover ? ktp->kt_nentries : index);
 }
 
 /*
@@ -228,7 +223,7 @@ ktrace_first(ktrace_t   *ktp, ktrace_sna
 	int             nentries;
 
 	if (ktp->kt_rollover)
-		index = ktp->kt_index;
+		index = atomic_read(&ktp->kt_index) % ktp->kt_nentries;
 	else
 		index = 0;
 
Index: 2.6.x-xfs-new/fs/xfs/support/ktrace.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/support/ktrace.h	2007-10-02 16:01:47.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/support/ktrace.h	2008-02-18 15:32:28.911073469 +1100
@@ -30,7 +30,7 @@ typedef struct ktrace_entry {
  */
 typedef struct ktrace {
 	int		kt_nentries;	/* number of entries in trace buf */
-	int		kt_index;	/* current index in entries */
+	atomic_t	kt_index;	/* current index in entries */
 	int		kt_rollover;
 	ktrace_entry_t	*kt_entries;	/* buffer of entries */
 } ktrace_t;
