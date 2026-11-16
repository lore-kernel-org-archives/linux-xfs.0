Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873726;
	b=0QiztQGLbnNDkhCDHKUTLT5GfdfUvrLGzViwgj1wmPx18LIhFOaxy989xziesDXdHUcR
	 NUWFkZo88t/BHdV4Uy2fKs3pGygsfxRnm9lPdGoJRJjOsNDv0IbafNDAg4dgp531cAsQG
	 ll4EUA7CfzRLyiO6hTR6bPzSvcjjW17tJUabLsH62g4XKc+jnaQUR08RgICS3nsXtgucZ
	 nV3CfOiWhtrgsV8adPEuVQynQT84oqGb3TrRkxLH7QfQ4eFOU516oEYSfmN6OaV3aTqYd
	 2bUNqpKfWY1l8A6X6FoBP5Kef8JzPiikq2bDCxONdg0LKZTADiabGeOg0l9bc/cfZSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873726;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:Reply-To:MIME-Version:Content-Transfer-Encoding;
	bh=YDOCxCJWDJqJIkf3L73TGXB4ljsEc/eId8XIHFekXOM=;
	b=SNGMl+77UEHIY2MbCJWaChDFnfHcc1WkuzEzBeh94XtqdVJCr4SGA1CI5S7a72/sKKO7
	 Q0rt6HGmDtfhmjzE6O1aKaUW9vCtNzFS5iQOYFIy7gDT2BqOeJejSWT0soEYy3J94h2Yn
	 HOqS0pPMhSF3NK2pWVgcH/cTqdrRQsm0bhBr9HcLLDSMX9Ipf2KXcWU/CqeoaF/WqbuVT
	 OPcKTMux2ZKz/tCd0h9OfAgSZUWXpVWXyt1AQhwaSMK0Fz+CaT0ww8FS3Zi/ZGwhZfgGt
	 ADIMthNh/EGgcUUsqvYprV7P0cJR6V2Ff4W0iBflDxv1YE2xs/H/oYWqKEANZfgt4cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=LrAEGOut;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="G/991CMp";
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306AE606A32A
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 00:02:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 306AE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=LrAEGOut;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=G/991CMp
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 60451140008F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 19:02:04 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 16 Nov 2026 19:02:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm3; t=1794873724;
	 x=1794960124; bh=YDOCxCJWDJqJIkf3L73TGXB4ljsEc/eId8XIHFekXOM=; b=
	LrAEGOutj/fEDpkherYfjRcba5B+qwjNIX2drnjuqOtUadqAK1cDPbFLXAqOx00Y
	idok/AqqHTHgFjHfbnf/FzaqzP5kpQ3jzNtcHB9MAXFxnB5Q7MTxEaDk4bVonOHD
	SLono/S+WXJvu7MwRg6c47KWdWozhbVL0+o4kHkf6HTfk/rMyKnEYjPtBxZaYGeL
	b2Cu9TZIDG872wBM/ynuT0Rb4UAh/24wQtkzacRXYys3qxSCFCb2k/xZdPmISXp5
	SD60CXAqF1W6HllT+joIBc+IQHrv3jMnXTEeczCypO07By/x9MgpH69ZVNI06Kx1
	OWvGwq93bFb5kMQoyQex7Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794873724; x=1794960124; bh=Y
	DOCxCJWDJqJIkf3L73TGXB4ljsEc/eId8XIHFekXOM=; b=G/991CMpe+rkygEPv
	MzBLcBAxp89foSKY6imaihFdopM+YoOlI8vapd2ikcySIzej5TT0jU/XrCKcY3nC
	IecimzCfU/hADs05eyRzz778hdulFjC2J0XcybPLi94cAxFx3l5ji5U/NEshO++c
	BPUuOQDnNkKNCgCnwwEiY5sygPnbIhleSuxc4/n1k/CyacCvPFOoogMa35jVw+R5
	CddE5syW7LzK8suIq2U5zqvZSEt67IJQy3qKLCHOQJysBeWLIzVUuwJ69V8nmy5s
	M/ymPSNIn3ilXBhn+CyvtS0uR+qh2J6pUZmZyzlngD+bqvmKNcs51kpGa8niGya2
	Q2l+A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794873724; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:bKOY0iIHsW7KM9kL07fGQmDoIUYX19Ovi9gK3IE+gwoIIq1
	X1uJQYnucs32cTHoNoSH1x3b2u9leUEGLpDhraAcP6LwyVuyzau0ND/Nms5Q0U7t
	m3jLeRx1cE2RDW470uyyrQ8CICQ186IiuutUmXRF/8FLcPowLxzRYHDJwQGP25KE
	+rwRb3aZ0dGHvLkXLyis/dvB4Gnj+27Yu/5atCh6yH7uvAmwPEDhiE2lnmJWlDy/
	QCDTm/8E2Ay4lQ1GERt/uLGBhIW9As/eD/CpMKnPmlFjS3EpG5iTeFOvAVIEQ2iB
	RHpDasF8VmfMwpSzdzV/PaWTEPfIN4jIkL0Ul4w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:KLb+aNcrlCIzLw/CrX8F1zNBPXZ5qht9VWLPhGN8oVg=:TyEeQ2WbtApDIcpylAufMXXQHBaC+fnd6qv+WPqAU0M=;
X-ME-Sender: <xms:fJn7auNoB9aStyQlcCU6RoN9U-DdGXVZ1n93vdG5uq07_wfQvu3ZLw>
    <xme:fJn7auRLefInTwjA3wFbimASFMoL41sP0mPHO-sxdH4dJWKRZdWLH-0xpliSbYIx7
    RViZ2hzSQCZ2YrcwLEDkXtWwO_h6yoes1T1LeuJttGruxb1BAE>
X-ME-Received: <xmr:fJn7ap4sM4HNuH6GdI0b7bBmg8qVyEuvRxCohTUS7ayNEzEsuD2kj6RgIrS8gM2Kkn71ACf8PBjNTnpduRNpBelNE909fTQ>
X-ME-Proxy-Cause: dmFkZTGGotaiYc6jX+Efo7FfH08Alfcyz1yUAKcrzpQNrmoLgcPafsnobnYOqLvo4mJtkF
    PYFI+SEpdh6P6uJ+JBWsOFa4gkOXDxkMIr9MIVoGI0JvO5Zg4EqqsXXVOn/H6RRUtAxq+1
    EVKpzTt5GIhYHN6h/oiWbLGUPZ9O05HUQ+tFi7QXtPgWqIYl0AEcRTZ7l/mSUrqw7P2PD7
    qXZfb0N/6DeU6oDLwgqeTlBA3LYqFMc69tkvLyKY6jqun48ZMJ6rvkihuv0ULaVS3/m5JS
    LQN08anR90iFPJyFSW1N/GjCCGU7kBbZsYhkA5zqcEOlthCtJYhrqQZ8vIn9hbHykUS8Si
    HeIVp0lzHFs11mmIwCUiGCECrwD+nd1NUkgH+tOtfevEBaZ9mU68TdMm9b/DlGo0CuDwpU
    33ig+oGYmX/htL/AqJlM25rCxRk4WY0QDq/Z/fgzfvFFlG6vUH8L7nV0PWBNuL3cjK6qui
    RDncO/6czdSPKVdr1Ajr37jjTBQJNJSvel57zUpGPjhcl+YyBjgB68lJz75xXyJ2S3jLIA
    wwiMS7Q+qnx8/cnCtMJU58JatfEde/YRVW2/E4YYB2xbs9fghhDIR1Mitqy7JFpo+vTx4Y
    QgnTzvxQLkbTx9AfEeDxgZACCTrjUN732qQj9IXNfvtGMWrfaVgc18xt08qA
X-ME-Proxy: <xmx:fJn7ahabQ82jeeIorTwdBX8YVpjDp_QTYZb7X_ZanEM69ro2BDUUPQ>
    <xmx:fJn7atZpjHXIeXly0Uqh18LpOQfh1nCOMILdDG0CPl0WhzCIE4UpSQ>
    <xmx:fJn7ak0blHTZNwJAb7hE3FYUq-gIoz_onlYvy5Wj21ixoIzjPDVGnQ>
    <xmx:fJn7alYRUXmC0-Y2gytkaK2JPhjmEt6exOGPEphogTswy3CDURFg5g>
    <xmx:fJn7ajUC_-ipU59tz3CSKSSVMYJCKImAVv7_HlH7FyhpBw3pLkpO3Ebu>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 19:01:58 -0500 (EST)
From: NeilBrown <neilb@ownmail.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu,
	Jan Kara <jack@suse.cz>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel@vger.kernel.org,
	codalist@coda.cs.cmu.edu,
	linux-fsdevel@vger.kernel.org,
	linux-um@lists.infradead.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 4/4] procfs: drop parent lock for d_alloc_parallel() in iterate_shared()
Date: Tue, 17 Nov 2026 10:55:01 +1100
Message-ID: <20261117000115.1433875-5-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20261117000115.1433875-1-neilb@ownmail.net>
References: <20261117000115.1433875-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
 fs/proc/base.c        | 38 +++++++++++++++++++--------------
 fs/proc/proc_sysctl.c | 49 ++++++++++++++++++++++++-------------------
 2 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7685660c3624..5f9ec524ae2a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2106,24 +2106,30 @@ bool proc_fill_cache(struct file *file, struct dir_context *ctx,
 	unsigned type = DT_UNKNOWN;
 	ino_t ino = 1;
 
-	child = try_lookup_noperm(&qname, dir);
-	if (IS_ERR(child))
-		goto end_instantiate;
+	child = d_alloc_trylock(dir, &qname);
 
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
index 6c0859c66563..08bcda3bbc59 100644
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

