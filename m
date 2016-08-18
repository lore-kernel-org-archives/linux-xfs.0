Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E21C77CA0
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:37:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5EB47AC001
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:37:12 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id XP3ej65ZyNFTZxRn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:37:09 -0700 (PDT)
Date: Thu, 18 Aug 2016 19:37:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] xfs: remove i_iolock and use i_rwsem in the VFS
	inode instead
Message-ID: <20160818173707.GA1240@lst.de>
References: <1470935423-12329-1-git-send-email-hch@lst.de>
	<20160811215444.GY30192@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160811215444.GY30192@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Aug 11, 2016 at 11:54:44PM +0200, Peter Zijlstra wrote:
> Sure, find below. Not been near a compiler.

It has now.  Below are the additions I need, and things seem to be
passing fine with that.

Note that to fit the existing XFS lock asserts I'm using
_lockdep_is_held directly instead of lockdep_assert_held_exclusive.
All the exports are there, but I'm just trying to make sure you're
not going to shout at me for that later :)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 7f0098d..4cef9f8 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -345,7 +345,8 @@ static inline int lock_is_held(struct lockdep_map *lock)
 	return _lock_is_held(lock, -1);
 }
 
-#define lockdep_is_held(lock)	lock_is_held(&(lock)->dep_map)
+#define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)
+#define _lockdep_is_held(lock, r)	_lock_is_held(&(lock)->dep_map, (r))
 
 extern void lock_set_class(struct lockdep_map *lock, const char *name,
 			   struct lock_class_key *key, unsigned int subclass,
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index abec578..f39573b 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3778,7 +3778,7 @@ void lock_release(struct lockdep_map *lock, int nested,
 }
 EXPORT_SYMBOL_GPL(lock_release);
 
-int lock_is_held(struct lockdep_map *lock, int read)
+int _lock_is_held(struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
 	int ret = 0;
@@ -3796,7 +3796,7 @@ int lock_is_held(struct lockdep_map *lock, int read)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(lock_is_held);
+EXPORT_SYMBOL_GPL(_lock_is_held);
 
 struct pin_cookie lock_pin_lock(struct lockdep_map *lock)
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
