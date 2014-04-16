Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E3437F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:20:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9DE3304081
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:59 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 52umEIG0GuHVaqgw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:58 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:37 +1000
Subject: [PATCH 18/19] nfsd: set PF_FSTRANS during nfsd4_do_callback_rpc.
Message-ID: <20140416040337.10604.52860.stgit@notabene.brown>
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
Cc: xfs@oss.sgi.com

nfsd will sometimes call flush_workqueue on the workqueue running
nfsd4_do_callback_rpc, so we must ensure that it doesn't block in
filesystem reclaim.
So set PF_FSTRANS.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/nfsd/nfs4callback.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 7f05cd140de3..7784b5d4edf0 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -997,6 +997,9 @@ static void nfsd4_do_callback_rpc(struct work_struct *w)
 	struct nfsd4_callback *cb = container_of(w, struct nfsd4_callback, cb_work);
 	struct nfs4_client *clp = cb->cb_clp;
 	struct rpc_clnt *clnt;
+	unsigned int pflags;
+
+	current_set_flags_nested(&pflags, PF_FSTRANS);
 
 	if (clp->cl_flags & NFSD4_CLIENT_CB_FLAG_MASK)
 		nfsd4_process_cb_update(cb);
@@ -1005,11 +1008,13 @@ static void nfsd4_do_callback_rpc(struct work_struct *w)
 	if (!clnt) {
 		/* Callback channel broken, or client killed; give up: */
 		nfsd4_release_cb(cb);
+		current_restore_flags_nested(&pflags, PF_FSTRANS);
 		return;
 	}
 	cb->cb_msg.rpc_cred = clp->cl_cb_cred;
 	rpc_call_async(clnt, &cb->cb_msg, RPC_TASK_SOFT | RPC_TASK_SOFTCONN,
 			cb->cb_ops, cb);
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
 }
 
 void nfsd4_init_callback(struct nfsd4_callback *cb)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
