Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BE33911AB;
	Tue, 29 Sep 2026 03:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790653412; cv=none; b=uTGL6D96xDFbVYV2kKGcGVy5P1C6qQUG6hcsrSVMUkiNBnSninBKbk+LSs9IdJBzScIdi3yPFq1twljlNoBTb3thYi7NhYQZWeSLQqvKHGO0L2JzX7nw31trDIZjSavleUr0X67waG1dVt6/NB08d9U04JKpkg6dWYJsxmf7+8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790653412; c=relaxed/simple;
	bh=BUKP6ZBxDQKiHy+aaX4nGCkk+zX30KgPIeLyY14Bg8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiIhSWTjO8XumsFqxBqQ9SlM4d5bFg0WTmIvVJma1HxRjyM9LzIpJM7TNflVkzaZuQpJ37MbTRvebO4UDVqjURS6Cxrafetwv+5GR6cNZJa7rvYrGTDeWDGI2cw3QK0ROcOCFlzKmqfyVVQnDXB/MX9XSGuGB+j561AGuQmovWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=Cwxa84pJ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=S/0V/WsE; arc=none smtp.client-ip=202.12.124.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="Cwxa84pJ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="S/0V/WsE"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailflow.stl.internal (Postfix) with ESMTP id 6CE321301954;
	Mon, 28 Sep 2026 23:43:29 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 28 Sep 2026 23:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790653409;
	 x=1790660609; bh=lsKfDwVY/s9QOcVsVfQ184vGtQP89p1qx6OKonmdfWY=; b=
	Cwxa84pJo7NCVKIxjS98cnuf1G3GApyKdhkfpdCq5ZzQjtwWmtz9R9kx30GoUKRn
	2OspMv6mBz7OqfH30W718sZmL/HlhpLOqI9HOvBwqDcCTZaOx8tr6RRim54NFAal
	+xngEmAQvOPO25Wd66fPvmgxg0AM8F3ml5Q+/FI0Fi8rAyj+z3raP/CkOkkAyhJa
	oQnVL/1xQ3XXGhnhkrn49i2AuOmrQlnSGtfE4iEMwaAZ3ipeILIK6D2kH4BQ/vcH
	+5LCtiM6PPaJ0J669zzSrESTa5VCLsqLBuAxkDRMeKC+jNfQxHZPr5KcLCOiojIK
	MYZquKLRB9H231fg1x6o/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790653409; x=1790660609; bh=l
	sKfDwVY/s9QOcVsVfQ184vGtQP89p1qx6OKonmdfWY=; b=S/0V/WsEs99kvFZu9
	+XY1gSZ64yHrE8DRbyGS7oncnDgnGWU65Nnk9sgIOsHF7Gf5DPQfQx8wbcSc0cWn
	KoX5NG+ehEgC4ZAt3x2oZssi5VLUe96H6HTVJ+Kt1pCTZo9rd4iGWsqx5R9KrhcC
	OG4+qHClD8AmAap2VEL7kbYD5PKz1t/cZOCv2zmUReugjc43scHQhrdowkvjJLfJ
	t2Zpd/Uxqsfh79tRNG2EAON3mvm3hMA7b4/JT1Ppil5kfcSg+UE91qbtBqIOMlqk
	ku2rR87f20g1y2l70AEQu8E3HB76ajzT86zboxcXCWOmbAe/RYo4E6/8WV1ZhlRa
	Dv13g==
X-ME-Sender: <xms:4TO7arolaOHFwXK56Qa6xykR14IrzwemNkzpFDIguv5nMRRVhZPPJw>
    <xme:4TO7aolKtq65vDScMy5_UMgBYjif_VbWjcmJnooQ7HXQlfB1b_DERWRxQZt3xh-8L
    um53PFynUa8tZvjyLgjH_FWDUD7j0vaq0jktY2ivXSDQFKOxK8>
X-ME-Received: <xmr:4TO7agYnqQtKbVg8TnfAvT7BFKR0QCBoNSjKwjELgz_U_mRFyq8CTREX8QhPabar8zn2mF9plyA2VopTwFdFCwMFYygBP7g>
X-ME-Proxy-Cause: dmFkZTFf22swud/kgH+7IFCsdfS5PKwRmLOVVMPsMM0oPEJSrxXomK5MGA2HpoM/4Fayjy
    8t4bbaFpw2j2uTWWtWZZBpnJUdMuyskk1hWd9qXGF45eabe2keg8OPLCDZxOgY/dlPK4Uf
    QMGNQJm9P9MUeaNZkZs6ns50gsKFwCc8XWol2sagqa5lM1ggO/E+N7weoZuVf58v2SDU1z
    oJNwy/LJrQkxx961Dkry0BeNl+v6sGxsoTx0ccz/AOIQhh4NsfwUFrJwksoVGSAcoAhOYU
    GWH6kx36jaIyiQRhXdfFML1Yw6upasUkEITsWtrtlu14hKvTsqzmkbnDRYufVwBOwNEZQo
    T1B4oFJSiHfE5i9loHVwvhK+O2Y5BVb3Dv0iGvqbzQqA9qN7MAhuRpy7uZ8AMY3dfP2DLq
    nvbhs207NBSaa5MDvoBmSdevJXJtKK5Hlt0NVJSsIpNU0NopecJXOW0MfIAOhZU4+jqsip
    x4Wljyqn/g9FYR38Rjhm7LMDLFmhlY1lNIcxOONWExp8BUma7cICS8hD3tc+nEgnqBg/Or
    nNxADsnPDnuyJLFgOdrItdzIYZlwJ+9r4jPnl2FGAjhzcmOtPLr3fcGSTnvIZ5qEsLqmit
    nguUxdpJLF5/eSu32nMJ+qQkmH76GJPJzO/qTwuHVsJN3RUSfT1BjKRxMs8Q
X-ME-Proxy: <xmx:4TO7atullrr627O3cusaGrNIKgU85qn6rncQsX3LDWoUzed2yCE3KQ>
    <xmx:4TO7apq93rdUjA9jN49DV3ARwlkMmify2m0Web5YX443O54h9L8H7g>
    <xmx:4TO7anksVDf-DVzjhpOiOg2FzstokCT-dspNpyK47SNuUo4Zl0X_6A>
    <xmx:4TO7apTC6Lml8eeXrajxP0WH1_weLxIDimYZ4JBuvSDCiB2Sc_DFwQ>
    <xmx:4TO7angk9EneeKswcti_o90s6_OLRNXOoyoRMO4fzAp9wIlIomwtE6OU>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 23:43:21 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Joel Granados <joel.granados@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jan Harkes <jaharkes@cs.cmu.edu>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-um@lists.infradead.org,
	codalist@coda.cs.cmu.edu,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in iterate_shared()
Date: Tue, 29 Sep 2026 13:36:06 +1000
Message-ID: <20260929034158.1455429-7-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260929034158.1455429-1-neilb@ownmail.net>
References: <20260929034158.1455429-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

When procfs finds a name in iterate_shared() that isn't in the dcache it
*must* add it so that it can have a stable inode number to report
(inodes are only accessible from the dcache in procfs).

It uses d_alloc_parallel().  A planned change to locking will make it
unsafe to call d_alloc_parallel() while holding the directory lock.

Other filesystems which prime the dcache in iterate_shared() use
d_alloc_trylock() which is safe but can fail if it races with ->lookup.
As procfs cannot handle failure we need something better.

procfs doesn't *need* the parent to be locked.  There are no shared data
structures accessed that don't have their own locking.  So it is safe to
drop and re-take the parent lock.  We could do this around the whole
iteration, but as failure of d_alloc_trylock() is rare it is more
efficient to drop and retake it just around a call of d_alloc_parallel()
when d_alloc_trylock does fail.

Other code that drops and retakes the lock in iterate_shared needs to
be careful to check S_DEAD which could be set while the lock is
dropped.  This is not needed in procfs as the flag is never set.

As d_alloc_trylock() calls try_lookup_noperm(), we can skip that call
and simplify the code.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/proc/base.c        | 36 ++++++++++++++++++-------------
 fs/proc/proc_sysctl.c | 49 ++++++++++++++++++++++++-------------------
 2 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62..49939527763d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2106,24 +2106,32 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	unsigned type = DT_UNKNOWN;
 	ino_t ino = 1;
 
-	child = try_lookup_noperm(&qname, dir);
+	child = d_alloc_trylock(dir, &qname);
 	if (IS_ERR(child))
 		goto end_instantiate;
 
-	if (!child) {
+	if (child == ERR_PTR(-EWOULDBLOCK)) {
+		/*
+		 * Need to drop directory lock, which isn't really
+		 * needed here anyway.  As rmdir never happens in procfs
+		 * we don't need to be concerned about S_DEAD being set
+		 * while unlocked.
+		 */
+		inode_unlock_shared(dir->d_inode);
 		child = d_alloc_parallel(dir, &qname);
-		if (IS_ERR(child))
-			goto end_instantiate;
-		if (d_in_lookup(child)) {
-			struct dentry *res;
-			res = instantiate(child, task, ptr);
-			d_lookup_done(child);
-			if (unlikely(res)) {
-				dput(child);
-				child = res;
-				if (IS_ERR(child))
-					goto end_instantiate;
-			}
+		inode_lock_shared(dir->d_inode);
+	}
+	if (IS_ERR(child))
+		goto end_instantiate;
+	if (d_in_lookup(child)) {
+		struct dentry *res;
+		res = instantiate(child, task, ptr);
+		d_lookup_done(child);
+		if (unlikely(res)) {
+			dput(child);
+			child = res;
+			if (IS_ERR(child))
+				goto end_instantiate;
 		}
 	}
 	inode = d_inode(child);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 04a382178c65..de96a08a1e64 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -686,29 +686,34 @@ static bool proc_sys_fill_cache(struct file *file,
 	ino_t ino = 0;
 	unsigned type = DT_UNKNOWN;
 
-	qname.name = table->procname;
-	qname.len  = strlen(table->procname);
-	qname.hash = full_name_hash(dir, qname.name, qname.len);
-
-	child = d_lookup(dir, &qname);
-	if (!child) {
+	qname = QSTR(table->procname);
+	child = d_alloc_trylock(dir, &qname);
+	if (child == ERR_PTR(-EWOULDBLOCK)) {
+		/*
+		 * Need to drop directory lock, which isn't really
+		 * needed here anyway.  As rmdir never happens in procfs
+		 * we don't need to be concerned about S_DEAD being set
+		 * while unlocked.
+		 */
+		inode_unlock_shared(dir->d_inode);
 		child = d_alloc_parallel(dir, &qname);
-		if (IS_ERR(child))
-			return false;
-		if (d_in_lookup(child)) {
-			struct dentry *res;
-			inode = proc_sys_make_inode(dir->d_sb, head, table);
-			res = d_splice_alias_ops(inode, child,
-						 &proc_sys_dentry_operations);
-			d_lookup_done(child);
-			if (unlikely(res)) {
-				dput(child);
-
-				if (IS_ERR(res))
-					return false;
-
-				child = res;
-			}
+		inode_lock_shared(dir->d_inode);
+	}
+	if (IS_ERR(child))
+		return false;
+	if (d_in_lookup(child)) {
+		struct dentry *res;
+		inode = proc_sys_make_inode(dir->d_sb, head, table);
+		res = d_splice_alias_ops(inode, child,
+					 &proc_sys_dentry_operations);
+		d_lookup_done(child);
+		if (unlikely(res)) {
+			dput(child);
+
+			if (IS_ERR(res))
+				return false;
+
+			child = res;
 		}
 	}
 	inode = d_inode(child);
-- 
2.50.0.107.gf914562f5916.dirty

