Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7556F29E1A
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:19:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0FE1AAC001
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:19:39 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id yAtZfxp6V6Y8pFPt (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:19:37 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:37 +1000
Subject: [PATCH 15/19] nfsd: set PF_FSTRANS when client_mutex is held.
Message-ID: <20140416040336.10604.67828.stgit@notabene.brown>
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

When loop-back NFS with NFSv4 is in use, client_mutex might be needed
to reclaim memory, so any memory allocation while client_mutex is held
must avoid __GFP_FS, so best to set PF_FSTRANS.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/nfsd/nfs4state.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d5d070fbeb35..7b7fbcbe20cb 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -75,6 +75,7 @@ static int check_for_locks(struct nfs4_file *filp, struct nfs4_lockowner *lowner
 
 /* Currently used for almost all code touching nfsv4 state: */
 static DEFINE_MUTEX(client_mutex);
+static unsigned int client_mutex_pflags;
 
 /*
  * Currently used for the del_recall_lru and file hash table.  In an
@@ -93,6 +94,7 @@ void
 nfs4_lock_state(void)
 {
 	mutex_lock(&client_mutex);
+	current_set_flags_nested(&client_mutex_pflags, PF_FSTRANS);
 }
 
 static void free_session(struct nfsd4_session *);
@@ -127,6 +129,7 @@ static __be32 nfsd4_get_session_locked(struct nfsd4_session *ses)
 void
 nfs4_unlock_state(void)
 {
+	current_restore_flags_nested(&client_mutex_pflags, PF_FSTRANS);
 	mutex_unlock(&client_mutex);
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
