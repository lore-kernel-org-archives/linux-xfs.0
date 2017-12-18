Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934187AbdLRTfZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 14:35:25 -0500
Message-ID: <1513625720.3422.68.camel@kernel.org>
Subject: Re: [PATCH v3 19/19] fs: handle inode->i_version more efficiently
From: Jeff Layton <jlayton@kernel.org>
Date: Mon, 18 Dec 2017 14:35:20 -0500
In-Reply-To: <20171218173651.GB12454@fieldses.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
         <20171218151156.14565-20-jlayton@kernel.org>
         <20171218163418.GF30350@quack2.suse.cz>
         <1513617740.3422.30.camel@kernel.org> <20171218173651.GB12454@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

On Mon, 2017-12-18 at 12:36 -0500, J. Bruce Fields wrote:
> On Mon, Dec 18, 2017 at 12:22:20PM -0500, Jeff Layton wrote:
> > On Mon, 2017-12-18 at 17:34 +0100, Jan Kara wrote:
> > > On Mon 18-12-17 10:11:56, Jeff Layton wrote:
> > > >  static inline bool
> > > >  inode_maybe_inc_iversion(struct inode *inode, bool force)
> > > >  {
> > > > -	atomic64_t *ivp = (atomic64_t *)&inode->i_version;
> > > > +	u64 cur, old, new;
> > > >  
> > > > -	atomic64_inc(ivp);
> > > > +	cur = (u64)atomic64_read(&inode->i_version);
> > > > +	for (;;) {
> > > > +		/* If flag is clear then we needn't do anything */
> > > > +		if (!force && !(cur & I_VERSION_QUERIED))
> > > > +			return false;
> > > 
> > > The fast path here misses any memory barrier. Thus it seems this query
> > > could be in theory reordered before any store that happened to modify the
> > > inode? Or maybe we could race and miss the fact that in fact this i_version
> > > has already been queried? But maybe there's some higher level locking that
> > > makes sure this is all a non-issue... But in that case it would deserve
> > > some comment I guess.
> > > 
> > 
> > There's no higher-level locking. Getting locking out of this codepath is
> > a good thing IMO. The larger question here is whether we really care
> > about ordering this with anything else.
> > 
> > The i_version, as implemented today, is not ordered with actual changes
> > to the inode. We only take the i_lock today when modifying it, not when
> > querying it. It's possible today that you could see the results of a
> > change and then do a fetch of the i_version that doesn't show an
> > increment vs. a previous change.
> > 
> > It'd be nice if this were atomic with the actual changes that it
> > represents, but I think that would be prohibitively expensive. That may
> > be something we need to address. I'm not sure we really want to do it as
> > part of this patchset though.
> 
> I don't think we need full atomicity, but we *do* need the i_version
> increment to be seen as ordered after the inode change.  That should be
> relatively inexpensive, yes?
> 
> Otherwise an inode change could be overlooked indefinitely, because a
> client could cache the old contents with the new i_version value and
> never see the i_version change again as long as the inode isn't touched
> again.
> 
> (If the client instead caches new data with the old inode version, there
> may be an unnecessary cache invalidation next time the client queries
> the change attribute.  That's a performance bug, but not really a
> correctness problem, at least for clients depending only on
> close-to-open semantics: they'll only depend on seeing the new change
> attribute after the change has been flushed to disk.  The performance
> problem should be mitigated by the race being very rare.)

Perhaps something like this patch squashed into #19?

This should tighten up the initial loads and stores, like Jan was
suggesting (I think). The increments are done via cmpxchg so they
already have a full implied barrier (IIUC), and we don't exit the loop
until it succeeds or it looks like the flag is set.

To be clear though:

This series does not try to order the i_version update with any other
inode metadata or data (though we generally do update it after a write
is done, rather than before or during).

Inode field updates are not at all synchronized either and this series
does not change that. A stat() is also generally done locklessly so you
can easily get a half-baked attributes there if you hit the timing
wrong.

-------------------------8<--------------------------

[PATCH] SQUASH: add memory barriers around i_version accesses

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/iversion.h | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index a9fbf99709df..39ec9aa9e08e 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -87,6 +87,25 @@ static inline void
 inode_set_iversion_raw(struct inode *inode, const u64 val)
 {
 	atomic64_set(&inode->i_version, val);
+	smp_wmb();
+}
+
+/**
+ * inode_peek_iversion_raw - grab a "raw" iversion value
+ * @inode: inode from which i_version should be read
+ *
+ * Grab a "raw" inode->i_version value and return it. The i_version is not
+ * flagged or converted in any way. This is mostly used to access a self-managed
+ * i_version.
+ *
+ * With those filesystems, we want to treat the i_version as an entirely
+ * opaque value.
+ */
+static inline u64
+inode_peek_iversion_raw(const struct inode *inode)
+{
+	smp_rmb();
+	return atomic64_read(&inode->i_version);
 }
 
 /**
@@ -152,7 +171,7 @@ inode_maybe_inc_iversion(struct inode *inode, bool force)
 {
 	u64 cur, old, new;
 
-	cur = (u64)atomic64_read(&inode->i_version);
+	cur = inode_peek_iversion_raw(inode);
 	for (;;) {
 		/* If flag is clear then we needn't do anything */
 		if (!force && !(cur & I_VERSION_QUERIED))
@@ -183,23 +202,6 @@ inode_inc_iversion(struct inode *inode)
 	inode_maybe_inc_iversion(inode, true);
 }
 
-/**
- * inode_peek_iversion_raw - grab a "raw" iversion value
- * @inode: inode from which i_version should be read
- *
- * Grab a "raw" inode->i_version value and return it. The i_version is not
- * flagged or converted in any way. This is mostly used to access a self-managed
- * i_version.
- *
- * With those filesystems, we want to treat the i_version as an entirely
- * opaque value.
- */
-static inline u64
-inode_peek_iversion_raw(const struct inode *inode)
-{
-	return atomic64_read(&inode->i_version);
-}
-
 /**
  * inode_iversion_need_inc - is the i_version in need of being incremented?
  * @inode: inode to check
@@ -248,7 +250,7 @@ inode_query_iversion(struct inode *inode)
 {
 	u64 cur, old, new;
 
-	cur = atomic64_read(&inode->i_version);
+	cur = inode_peek_iversion_raw(inode);
 	for (;;) {
 		/* If flag is already set, then no need to swap */
 		if (cur & I_VERSION_QUERIED)
-- 
2.14.3

