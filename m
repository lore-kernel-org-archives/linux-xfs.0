Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C2F397CBC
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 14:04:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81770304039
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2016 12:04:06 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id km0vHtOLahtSfaC0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2016 12:04:01 -0700 (PDT)
Date: Fri, 23 Sep 2016 20:03:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 05/11] skb_splice_bits(): get rid of callback
Message-ID: <20160923190357.GC2356@ZenIV.linux.org.uk>
References: <20160909023452.GO2356@ZenIV.linux.org.uk>
	<CA+55aFwHQMjO4-vtfB9-ytc=o+DRo-HXVGckvXLboUxgpwb7_g@mail.gmail.com>
	<20160909221945.GQ2356@ZenIV.linux.org.uk>
	<CA+55aFzTOOB6oEVaaGD0N7Uznk-W9+ULPwzsxS_L_oZqGVSeLA@mail.gmail.com>
	<20160914031648.GB2356@ZenIV.linux.org.uk>
	<CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
	<20160914042559.GC2356@ZenIV.linux.org.uk>
	<20160917082007.GA6489@ZenIV.linux.org.uk>
	<20160917190023.GA8039@ZenIV.linux.org.uk>
	<20160923190032.GA25771@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160923190032.GA25771@ZenIV.linux.org.uk>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, CAI Qian <caiqian@redhat.com>, Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

since pipe_lock is the outermost now, we don't need to drop/regain
socket locks around the call of splice_to_pipe() from skb_splice_bits(),
which kills the need to have a socket-specific callback; we can just
call splice_to_pipe() and be done with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/skbuff.h |  8 +-------
 net/core/skbuff.c      | 28 ++--------------------------
 net/ipv4/tcp.c         |  3 +--
 net/kcm/kcmsock.c      | 16 +---------------
 net/unix/af_unix.c     | 17 +----------------
 5 files changed, 6 insertions(+), 66 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0f665cb..f520251 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3021,15 +3021,9 @@ int skb_copy_bits(const struct sk_buff *skb, int offset, void *to, int len);
 int skb_store_bits(struct sk_buff *skb, int offset, const void *from, int len);
 __wsum skb_copy_and_csum_bits(const struct sk_buff *skb, int offset, u8 *to,
 			      int len, __wsum csum);
-ssize_t skb_socket_splice(struct sock *sk,
-			  struct pipe_inode_info *pipe,
-			  struct splice_pipe_desc *spd);
 int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int len,
-		    unsigned int flags,
-		    ssize_t (*splice_cb)(struct sock *,
-					 struct pipe_inode_info *,
-					 struct splice_pipe_desc *));
+		    unsigned int flags);
 void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
 unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
 int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3864b4b6..208a9bc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1962,37 +1962,13 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 	return false;
 }
 
-ssize_t skb_socket_splice(struct sock *sk,
-			  struct pipe_inode_info *pipe,
-			  struct splice_pipe_desc *spd)
-{
-	int ret;
-
-	/* Drop the socket lock, otherwise we have reverse
-	 * locking dependencies between sk_lock and i_mutex
-	 * here as compared to sendfile(). We enter here
-	 * with the socket lock held, and splice_to_pipe() will
-	 * grab the pipe inode lock. For sendfile() emulation,
-	 * we call into ->sendpage() with the i_mutex lock held
-	 * and networking will grab the socket lock.
-	 */
-	release_sock(sk);
-	ret = splice_to_pipe(pipe, spd);
-	lock_sock(sk);
-
-	return ret;
-}
-
 /*
  * Map data from the skb to a pipe. Should handle both the linear part,
  * the fragments, and the frag list.
  */
 int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    struct pipe_inode_info *pipe, unsigned int tlen,
-		    unsigned int flags,
-		    ssize_t (*splice_cb)(struct sock *,
-					 struct pipe_inode_info *,
-					 struct splice_pipe_desc *))
+		    unsigned int flags)
 {
 	struct partial_page partial[MAX_SKB_FRAGS];
 	struct page *pages[MAX_SKB_FRAGS];
@@ -2009,7 +1985,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
 
 	if (spd.nr_pages)
-		ret = splice_cb(sk, pipe, &spd);
+		ret = splice_to_pipe(pipe, &spd);
 
 	return ret;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ffbb218..ddd2179 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -688,8 +688,7 @@ static int tcp_splice_data_recv(read_descriptor_t *rd_desc, struct sk_buff *skb,
 	int ret;
 
 	ret = skb_splice_bits(skb, skb->sk, offset, tss->pipe,
-			      min(rd_desc->count, len), tss->flags,
-			      skb_socket_splice);
+			      min(rd_desc->count, len), tss->flags);
 	if (ret > 0)
 		rd_desc->count -= ret;
 	return ret;
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index cb39e05..994baae 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1461,19 +1461,6 @@ out:
 	return copied ? : err;
 }
 
-static ssize_t kcm_sock_splice(struct sock *sk,
-			       struct pipe_inode_info *pipe,
-			       struct splice_pipe_desc *spd)
-{
-	int ret;
-
-	release_sock(sk);
-	ret = splice_to_pipe(pipe, spd);
-	lock_sock(sk);
-
-	return ret;
-}
-
 static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 			       struct pipe_inode_info *pipe, size_t len,
 			       unsigned int flags)
@@ -1503,8 +1490,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	if (len > rxm->full_len)
 		len = rxm->full_len;
 
-	copied = skb_splice_bits(skb, sk, rxm->offset, pipe, len, flags,
-				 kcm_sock_splice);
+	copied = skb_splice_bits(skb, sk, rxm->offset, pipe, len, flags);
 	if (copied < 0) {
 		err = copied;
 		goto err_out;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f1dffe8..e7707ca 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2488,28 +2488,13 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 	return unix_stream_read_generic(&state);
 }
 
-static ssize_t skb_unix_socket_splice(struct sock *sk,
-				      struct pipe_inode_info *pipe,
-				      struct splice_pipe_desc *spd)
-{
-	int ret;
-	struct unix_sock *u = unix_sk(sk);
-
-	mutex_unlock(&u->readlock);
-	ret = splice_to_pipe(pipe, spd);
-	mutex_lock(&u->readlock);
-
-	return ret;
-}
-
 static int unix_stream_splice_actor(struct sk_buff *skb,
 				    int skip, int chunk,
 				    struct unix_stream_read_state *state)
 {
 	return skb_splice_bits(skb, state->socket->sk,
 			       UNIXCB(skb).consumed + skip,
-			       state->pipe, chunk, state->splice_flags,
-			       skb_unix_socket_splice);
+			       state->pipe, chunk, state->splice_flags);
 }
 
 static ssize_t unix_stream_splice_read(struct socket *sock,  loff_t *ppos,
-- 
2.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
