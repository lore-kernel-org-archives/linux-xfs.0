Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873700;
	b=j6uFbhsIT3uEelgXSdp3DwBajQm+srXB9XjwBBT578LR4qVujV6anFy2IZl0kRoJGLrM
	 Pyz7/f0rVqZqVnSqN295v7/5BR15so2+17RrpjoRIv0/fmWOCnFMRwmWrXlCVWlOqIpv7
	 pq9I/iLs7Rfm9DiA6YG0QWiUzERpOV00gWER3Kg3Z1Cxx727+O9a19bjSJxA5fCfDTxtR
	 tsUm6hHtotWewHNoB6fxr5fDZKXEPOu0kR8z0drt3JjbctwiIPERD4C2mFtJVKNlf93tJ
	 I3ZS2lAVQhBwp8D0SNFykWJULG6pXNLUOm21V/7Ul9KTUfA/DlERYk+LbVBqEEnvOvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873700;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:Reply-To:MIME-Version:Content-Transfer-Encoding;
	bh=av34aLRQ9yOhBTYqBMp3EX9jisd3zEyC0HaxasON9CQ=;
	b=sMsAhIUl8/1JjZXuO36Y7YwGRjPLsJURv4eVgjNnplAO9eev6yYsxeDERh10G982JPEa
	 dA8oSYoSpRYTYnVqmjscHTz47HAE9HwwC//ADVBVdSHf6FawY29f2ukbERvKB4UCNE4z1
	 fVE4zOgCSUOqJQkcPR3WXBhV0k02LSgIjuoNRbC0rumz9IwNNvC00oRhsEuJSWQ3+RNK0
	 64xn92I3SjAUVZiy5bgFJMpsu2TE4kKuyzGErxBnSD6ux2h/CrRkrQNA5nFuyZ2bkiudV
	 n+PNBbyQ9GuFLpVZXMW+YFZmMgjkRTuhcfxLglTBbvx+fir61EbCq/UIny8w4tc4Kvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=i2j3P8Lg;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=smZ0oewD;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF83606A32C
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 00:01:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FF83606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=i2j3P8Lg;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=smZ0oewD
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 28FCAEC083D
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 19:01:39 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 16 Nov 2026 19:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm3; t=1794873699;
	 x=1794960099; bh=av34aLRQ9yOhBTYqBMp3EX9jisd3zEyC0HaxasON9CQ=; b=
	i2j3P8Lgn+UodUf1HySuVNIHzv230xwkfMZiSkdxEwkVNqh1zJ8MOML0ssO/8qLn
	dqHSlQXy6ZdcJkusyLQ0BxJrde4eVIcgWUgOC9dttqzB4+sm+NeEq+oWE0czI0J8
	hPfRO+QDYPP5rxIEH0oalIYtadwsu+uCYMLMcaJAcU1/VvEg+CUYNFbfoZzlzccc
	ECW0Bm+pFibPTN2EAJAoqBezIRismacpIeKtq1evVaE/CEJAQmEYnRjXvPoOfmoh
	dphMmhC4rLZULVEOxNhCeNO+NCaBPVbs87amdTU40Wt+a2DYoJX4WsFbtOuGsoBf
	k8KQOWULfqaUt0Eca6WfSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794873699; x=1794960099; bh=a
	v34aLRQ9yOhBTYqBMp3EX9jisd3zEyC0HaxasON9CQ=; b=smZ0oewDH8PkdBlqD
	Lih5Y9H2j4X3qYgfz+O37duIzlp8tRZUZOdMspXQAiElxt+rt9J051hzzS8R3sHd
	A9+pomVeoeK52y21PyINiPHTZJ5pk1tnGZLzcgFH/3AQpz1uLBq6bRWkHMwwkak5
	kuxGapWpaaXoZTBoeK19OvIdG2KYwBBElA6NUNWWjzCPt4JRq6Ut4LRxwW+6vyFI
	PFCXVp4qN0CuFzUcnbW7+KEvbdAZVPCFKXwwKGq6sHIKQlwJ3Yl+FvQBcAefrOmd
	letcN6Nn4lpIPcujkiQ54kuerwyo5EKf5S27fAhohUXr6cNHXKtcGSCTIQQZDBJk
	HK4MA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794873699; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:udnitcYNdoVklaodefajZ467u51zPBJSLc0KnRU8fa8Cx1B
	VJsqK6yo3FScN+Udfz9LaIWShJj0RYnGQKWix2zDXN2kVIlIPr8zuXh5EXqgTq+h
	d+3EXHAbfOzy0lZ3McoRxFFTr2t5gOFfBxpUZ2z7oJy7fReIl6VY8AFiXADyp03J
	wMrkNK9OwHvBdVB/DAnAvc/fPIC4EBEucR4hlsfcC4nDf8hf5OFxpL3b/7beX1ea
	3aypW5ozdP27s9IjizfS0vJO8C+tJeY6SidA5NY9m0xQyAKgRD2pcw3qCWEUjz3q
	5CekVBu1QZUbqgzMa/B6i36Gy2Cs2N6JmqRnXPg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:Z20dVrMxqOiASISKH1zfSrQItQDFZphjEOPmDTnUDRk=:X+HTCYJx70nUOlEnYJkjtFjje0AX7LpGBgWqVfYQghs=;
X-ME-Sender: <xms:Ypn7auWsHoYImXeKj7e5dvZaAsB3vQWcv2LPbJCqa-T3W7KzZagQLw>
    <xme:Ypn7ar4MU0HbAJZ-BoZy6njhjPSiyQiJLvqdKfYUkv_-l7bO5tGkqNfhcWey8iwpH
    2x3c_osfh4qbFF08PtoNb0Ntr_EnXtuPenxqA_SjgjXHyk2kQ>
X-ME-Received: <xmr:Ypn7anAlJoyCiiLcpUY01Ne1NtNA6fkFhEVI0J0_VIYkggV3HWvoUpdtkDFB0LlfZVpMQN5eUKzjbf5vqu3eEAf9LsFZV9k>
X-ME-Proxy-Cause: dmFkZTEWLllwmZbCQ7cO93As6sGHtjiFdYj9k/VSqMvUwk1xfk9pKn/ZCX7mnpLkIaqMef
    K/82szmVYemJN/I0DCAIOCHeaPZ7/Xa2GnBqk902ewdx8hjF22LzMBgW8kwMwZuhDEqmG+
    fRzfUtzcgzHNqdnt0hptgxxppIMFQUfVlAsIvg7fvTNv54Da321pj6NeCTNh6yP98D0Rix
    0qUujhXor+6vA1uX99KaZah7Remd9bF8xjGXqzB2MsscQiqTyvs6dLxlge9fkMF8nj1I3u
    +RSOpU+TvlDvjmsK8NtReLJ34nN/1FLS6YOAknIb84eISWftGKSVwY1LnVjpVMr2cR7DCi
    W3CSaSFjmENxXg0y7ldo/iTIwMI2qIyuA9nXlgmWjFjPwK/UTJ0VwPcu5hIoA9QFdeWvxa
    je0YTxa8uUDVkM6OboIk02vGHPWWOMsf3kMUGg8Rfr2vo8a0fHeZFPFx6baFUx/wVmBwE0
    GqjuwPypbzpcqYX5tilDfdHFLGHrCD2EMsfy5IOHTj0I15PqjbQ+mCC0hV5sxu3eRr1En7
    5Oy8Lor+dNhpHXtJC7+5Gdm3fl+iXlm4xI9HP8ugP9ShDQVfmX1TyYMIznWG1S327a2eA/
    WAPPLR8RrqT9KoOoTR68ceYOkAksn01W3nfN6CbaeSwUkpNwCTRTIJs8bTVA
X-ME-Proxy: <xmx:Ypn7aoA43D_2C123HBINo_ws-wHudC_Bpa_UcqzlMAGmoS44SvTFkA>
    <xmx:Ypn7avirrGdq-hjOSlrUqxH7X5vuhpRAqNe46mre9dtnqDqLXdpESw>
    <xmx:Ypn7asfPEvtnFDaQc7xVmNkliVWzyLHFG9VhFF1kmZvYDhCkXs7HNw>
    <xmx:Ypn7akiF4b_tycfEs89gcV_o_eABeKIvagU3UyG0hjxZZpIKBHJ8Fg>
    <xmx:Y5n7at9Q1Riv-Ik5qbFvjSaN66LW1vjgJeYXog50FQejC_IA6JAwKqHK>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 19:01:32 -0500 (EST)
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
Subject: [PATCH v2 1/4] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel() in d_add_ci()
Date: Tue, 17 Nov 2026 10:54:58 +1100
Message-ID: <20261117000115.1433875-2-neilb@ownmail.net>
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

A proposed change will invert the lock ordering between
d_alloc_parallel() and inode_lock() on the parent.
When that happens it will not be safe to call d_alloc_parallel() while
holding the parent lock - even shared.

We don't need to keep the parent lock held when d_add_ci() is run - the
VFS doesn't need it as dentry is exclusively held due to
DCACHE_PAR_LOOKUP and the filesystem has finished its work.

So drop and reclaim the lock (shared or exclusive as determined by
LOOKUP_SHARED) to avoid future deadlock.

Signed-off-by: NeilBrown <neil@brown.name>
---
 Documentation/filesystems/porting.rst |  7 ++++++
 fs/dcache.c                           | 32 +++++++++++++++++++++++----
 fs/ntfs/namei.c                       |  2 +-
 fs/xfs/xfs_iops.c                     |  2 +-
 include/linux/dcache.h                |  3 ++-
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c38f5df755bb..4cab51e1bd6c 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -1422,3 +1422,10 @@ helpers take a const struct mnt_idmap *. mnt_idmap() and file_mnt_idmap()
 return one. The idmapping is immutable so nothing should have modified it
 anyway. References are taken and dropped via mnt_idmap_get() and
 mnt_idmap_put() as before, both accept a const pointer.
+
+---
+
+**mandatory**
+
+d_add_ci() must now be passed the flags arguemnt that was given to ->lookup
+
diff --git a/fs/dcache.c b/fs/dcache.c
index 720b32cb2e03..255ebdad303d 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2419,6 +2419,7 @@ EXPORT_SYMBOL(d_obtain_root);
  * @dentry: the negative dentry that was passed to the parent's lookup func
  * @inode:  the inode case-insensitive lookup has found
  * @name:   the case-exact name to be associated with the returned dentry
+ * @lookup_flags: flags passed to ->lookup
  *
  * This is to avoid filling the dcache with case-insensitive names to the
  * same inode, only the actual correct case is stored in the dcache for
@@ -2431,9 +2432,10 @@ EXPORT_SYMBOL(d_obtain_root);
  * the exact case, and return the spliced entry.
  */
 struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
-			struct qstr *name)
+			struct qstr *name, unsigned int lookup_flags)
 {
 	struct dentry *found, *res;
+	bool must_relock = false;
 
 	/*
 	 * First check if a dentry matching the name already exists,
@@ -2445,24 +2447,46 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
 		return found;
 	}
 	if (d_in_lookup(dentry)) {
+		/*
+		 * We are holding parent lock and so don't want to wait
+		 * for a d_in_lookup() dentry.  We can safely drop the
+		 * parent lock and reclaim it as we have exclusive
+		 * access to dentry as it is d_in_lookup() (so
+		 * ->d_parent is stable) and we are near the end
+		 * ->lookup() and will shortly drop the lock anyway.
+		 * We cannot retake the lock while the new dentry is in-lookup
+		 */
+		if (lookup_flags & LOOKUP_SHARED)
+			inode_unlock_shared(d_inode(dentry->d_parent));
+		else
+			inode_unlock(d_inode(dentry->d_parent));
+		must_relock = true;
 		found = d_alloc_parallel(dentry->d_parent, name);
 		if (IS_ERR(found) || !d_in_lookup(found)) {
 			iput(inode);
-			return found;
+			goto out_relock;
 		}
 	} else {
 		found = d_alloc(dentry->d_parent, name);
 		if (!found) {
 			iput(inode);
 			return ERR_PTR(-ENOMEM);
-		} 
+		}
 	}
 	res = d_splice_alias(inode, found);
 	if (res) {
 		d_lookup_done(found);
 		dput(found);
-		return res;
+		found = res;
 	}
+	if (!must_relock)
+		return found;
+out_relock:
+	d_lookup_done(dentry);
+	if (lookup_flags & LOOKUP_SHARED)
+		inode_lock_shared(d_inode(dentry->d_parent));
+	else
+		inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARENT);
 	return found;
 }
 EXPORT_SYMBOL(d_add_ci);
diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
index b46fe44b63b5..16ed6027fa13 100644
--- a/fs/ntfs/namei.c
+++ b/fs/ntfs/namei.c
@@ -332,7 +332,7 @@ static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
 		}
 		nls_name.hash = full_name_hash(dent, nls_name.name, nls_name.len);
 
-		dent = d_add_ci(dent, dent_inode, &nls_name);
+		dent = d_add_ci(dent, dent_inode, &nls_name, flags);
 		kfree(nls_name.name);
 		return dent;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d307ec97fac8..ec08c882c6f7 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -368,7 +368,7 @@ xfs_vn_ci_lookup(
 	/* else case-insensitive match... */
 	dname.name = ci_name.name;
 	dname.len = ci_name.len;
-	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
+	dentry = d_add_ci(dentry, VFS_I(ip), &dname, flags);
 	kfree(ci_name.name);
 	return dentry;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index aaa4ba7a1299..9dd91ba2fe33 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -267,7 +267,8 @@ struct dentry *d_duplicate(struct dentry *dentry);
 /* weird procfs mess; *NOT* exported */
 extern struct dentry * d_splice_alias_ops(struct inode *, struct dentry *,
 					  const struct dentry_operations *);
-extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
+extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,
+				unsigned int);
 extern bool d_same_name(const struct dentry *dentry, const struct dentry *parent,
 			const struct qstr *name);
 extern struct dentry *d_find_any_alias(struct inode *inode);

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.50.0.107.gf914562f5916.dirty

