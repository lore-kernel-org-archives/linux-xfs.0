Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BFBFB7F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 19:56:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B1EA68F8040
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 17:56:14 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7hOktQYdK4vaIsbN for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 17:56:12 -0700 (PDT)
Date: Thu, 14 May 2015 10:55:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] percpu_counter: batch size aware
	__percpu_counter_compare()
Message-ID: <20150514005553.GD4316@dastard>
References: <1431474754-15764-1-git-send-email-david@fromorbit.com>
	<1431474754-15764-2-git-send-email-david@fromorbit.com>
	<20150513135919.GS11388@htj.duckdns.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150513135919.GS11388@htj.duckdns.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 13, 2015 at 09:59:19AM -0400, Tejun Heo wrote:
> Hello, Dave.
> 
> On Wed, May 13, 2015 at 09:52:33AM +1000, Dave Chinner wrote:
> > @@ -116,6 +121,12 @@ static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
> >  		return 0;
> >  }
> >  
> > +static inline int
> > +percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
> > +{
> > +	return percpu_counter_compare(fbc, rhs);
> > +}
> 
> I don't think this is right.  Looks fine to me otherwise.

Ah, no, it's not. My bad, stale patch. Corrected version below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


percpu_counter: batch size aware __percpu_counter_compare()

From: Dave Chinner <dchinner@redhat.com>

XFS uses non-stanard batch sizes for avoiding frequent global
counter updates on it's allocated inode counters, as they increment
or decrement in batches of 64 inodes. Hence the standard percpu
counter batch of 32 means that the counter is effectively a global
counter. Currently Xfs uses a batch size of 128 so that it doesn't
take the global lock on every single modification.

However, Xfs also needs to compare accurately against zero, which
means we need to use percpu_counter_compare(), and that has a
hard-coded batch size of 32, and hence will spuriously fail to
detect when it is supposed to use precise comparisons and hence
the accounting goes wrong.

Add __percpu_counter_compare() to take a custom batch size so we can
use it sanely in XFS and factor percpu_counter_compare() to use it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/percpu_counter.h | 13 ++++++++++++-
 lib/percpu_counter.c           |  6 +++---
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 50e5009..84a1094 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -41,7 +41,12 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
-int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
+int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch);
+
+static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+{
+	return __percpu_counter_compare(fbc, rhs, percpu_counter_batch);
+}
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
@@ -116,6 +121,12 @@ static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 		return 0;
 }
 
+static inline int
+__percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
+{
+	return percpu_counter_compare(fbc, rhs);
+}
+
 static inline void
 percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 48144cd..f051d69 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -197,13 +197,13 @@ static int percpu_counter_hotcpu_callback(struct notifier_block *nb,
  * Compare counter against given value.
  * Return 1 if greater, 0 if equal and -1 if less
  */
-int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
+int __percpu_counter_compare(struct percpu_counter *fbc, s64 rhs, s32 batch)
 {
 	s64	count;
 
 	count = percpu_counter_read(fbc);
 	/* Check to see if rough count will be sufficient for comparison */
-	if (abs(count - rhs) > (percpu_counter_batch*num_online_cpus())) {
+	if (abs(count - rhs) > (batch * num_online_cpus())) {
 		if (count > rhs)
 			return 1;
 		else
@@ -218,7 +218,7 @@ int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 	else
 		return 0;
 }
-EXPORT_SYMBOL(percpu_counter_compare);
+EXPORT_SYMBOL(__percpu_counter_compare);
 
 static int __init percpu_counter_startup(void)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
