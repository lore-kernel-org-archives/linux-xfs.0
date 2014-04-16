Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4374E29DF7
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:19:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C0008F8052
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:03 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TYT7kMHLLaWZ8aLE (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:02 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 10/19] NET: set PF_FSTRANS while holding sk_lock
Message-ID: <20140416040336.10604.96000.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
MIME-Version: 1.0
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
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, xfs@oss.sgi.com

sk_lock can be taken while reclaiming memory (in nfsd for loop-back
NFS mounts, and presumably in nfs), and memory can be allocated while
holding sk_lock, at least via:

 inet_listen -> inet_csk_listen_start ->reqsk_queue_alloc

So to avoid deadlocks, always set PF_FSTRANS while holding sk_lock.

This deadlock was found by lockdep.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 include/net/sock.h |    1 +
 net/core/sock.c    |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index b9586a137cad..27c355637e44 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -324,6 +324,7 @@ struct sock {
 #define sk_v6_rcv_saddr	__sk_common.skc_v6_rcv_saddr
 
 	socket_lock_t		sk_lock;
+	unsigned int		sk_pflags; /* process flags before taking lock */
 	struct sk_buff_head	sk_receive_queue;
 	/*
 	 * The backlog queue is special, it is always used with
diff --git a/net/core/sock.c b/net/core/sock.c
index cf9bd24e4099..8bc677ef072e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2341,6 +2341,7 @@ void lock_sock_nested(struct sock *sk, int subclass)
 	/*
 	 * The sk_lock has mutex_lock() semantics here:
 	 */
+	current_set_flags_nested(&sk->sk_pflags, PF_FSTRANS);
 	mutex_acquire(&sk->sk_lock.dep_map, subclass, 0, _RET_IP_);
 	local_bh_enable();
 }
@@ -2352,6 +2353,7 @@ void release_sock(struct sock *sk)
 	 * The sk_lock has mutex_unlock() semantics:
 	 */
 	mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
+	current_restore_flags_nested(&sk->sk_pflags, PF_FSTRANS);
 
 	spin_lock_bh(&sk->sk_lock.slock);
 	if (sk->sk_backlog.tail)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
