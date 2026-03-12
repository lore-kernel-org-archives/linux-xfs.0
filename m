Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EF7309F1D;
	Thu, 12 Mar 2026 21:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773352471; cv=none; b=mMHUUEDkXgWqHnMqIE/Jn7oZWp0At8Co0GCMH2qqfbaG6PLalJcsxZsIvbyu0iv8UXe3tyhuXr92JhHnI8KwCcA3c52ql4HFehPSS7tYxrZD7CWN71ZPQUDRt/Ug6W6mcu06tgjweQg2s9r3BNPnyTBquSwWg+nvag/UCoWWhKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773352471; c=relaxed/simple;
	bh=CKKDH3OvgdUZHlw6DEhu3V+APgTia4OWQcwK0cNE0Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx7MCnLPASjBP1cXykypAQyXI3SHwNbX3+O09iQjZvlSq7sY0nqAOSgS7tUTtayQo39lFbMUVPfh4+9OVRyAKDZaTHpIMO66U7Zej3emE9bXfOroZDj1t+n2cmkWw2k5zF4ubXl8xzKPHWC8PtIMwK8YoV0TJj94/tvFyjnzBUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=knwvQbEG; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=4Zu9WuMX; arc=none smtp.client-ip=202.12.124.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="knwvQbEG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="4Zu9WuMX"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.stl.internal (Postfix) with ESMTP id 764DE1301B4D;
	Thu, 12 Mar 2026 17:54:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 12 Mar 2026 17:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773352468;
	 x=1773359668; bh=6rEBHIocsGomFaeNZ8FKVkPPiCLC3KUr0T88wGXsY+w=; b=
	knwvQbEGvEIqlMfPnGjtJpPojdNrNczYPtebe2Z4kPKMkUCzRctdcCXACQElzs21
	5O2a+QMmSwXVS7mmXVu2UbB62pEo78a9LLmTYGivD7du0jEWHQCQNY9CqyyjZM0D
	WxQVP+B/lLDgba8OONiDmEMwfdC99MyLWeo5sUXoJpj2s0/eqU6juECWNWTZd58e
	f2JUhGZZOdAKXc5zKwvqkmFAR+ulhtk7F4N+/VKAGM16LSYty6niYrfDL3MhwWZQ
	5F7UPhU37iVLnKURGdbIUXSCxaF0GsKm5E/ELskY9F7iGXtUNUkh7m1SAYob5ueD
	tG+cNMx+lV41n5I+6+vVUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773352468; x=1773359668; bh=6
	rEBHIocsGomFaeNZ8FKVkPPiCLC3KUr0T88wGXsY+w=; b=4Zu9WuMXKiMeGX/7/
	ze2DMZPQ/soZLDQ/oXU+K/4hHMjcEbwuRZzOQNn/0FYKubqN7uvd+xUhQsXGDVfc
	XFQx9NIeuhB4i9Fdw+0hLLcGCxsoXgvauzXIgttzQmRQRIMSqUVbZ83wnbvBzzTO
	LXU0seG7VBKWtNnozR19mdRgFEyA4pYMjPGA/j7LYSGbfIowMBFBZEYKa8ZivFjZ
	wCZFyMVCKIXP7JjAvEk3jKEPxxVTswqg27R3aHZpcyHuzR6zYaa9mxb3FygDZl2f
	k88L/InMovZo682809zK4ENFUDAn25o7ypfmHbL8vM48dnX2pKAMzl5X2ab+Svl4
	ddZIw==
X-ME-Sender: <xms:Ezazaey-fvZqInYUpzLKVh0s2v9tOotlJQb5SulL9nI4oaXgr3tSpA>
    <xme:Ezazad8MrhOleAAQOTQy2qLblBKX5WC_We4qchjQvILJ3pnRA2FxvthXMjdfjfV4w
    UoRKHkRpzuWB2q2BhG3sPKxU_JyisucUacsdZab9tuQGNM1Hw>
X-ME-Received: <xmr:EzazabbikfbFhxQsQwNIZruHOMSwYGu5ivVqXVqxLTeYxlwz9iv_yIyz17g7ZV2LlcxBcrz3VW2uBeAL_bnCWa-q56oBQi4V-rXhNxIFXune>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeejleduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:EzazaR_rDZ2cpPqieMKXHtJOQkHjLTGjyZbnPvedne1hBz6T8TNV8A>
    <xmx:EzazaVgT96boA0j1ougvrF0FQaqGb49jA9P1i0x6pBMQiTubNk5OHQ>
    <xmx:EzazaRnU5sTc9LuYwn6ue2LaL3bI3JtiIHjA8-szWM4tYJeor1kUZQ>
    <xmx:EzazaSAd69RfkLZRj40WM2JpiwTdOS31qJZu-6BnOXl0dr1anYis8Q>
    <xmx:FDazaQPDp6s81azLqtKk1OQBYAISt4wd_paeIdQbgvXGX3nCkXzwKQNo>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 17:54:14 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,	Carlos Maiolino <cem@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,	Amir Goldstein <amir73il@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,	Tyler Hicks <code@tyhicks.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-efi@vger.kernel.org
Subject: [PATCH 38/53] cephfs: Don't d_drop() before d_splice_alias()
Date: Fri, 13 Mar 2026 08:12:25 +1100
Message-ID: <20260312214330.3885211-39-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

In two places ceph drops a dentry and then calls d_splice_alias().
The d_drop() is no longer needed before d_splice_alias() and will
cause problems for proposed changes to locking.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/ceph/file.c  | 2 --
 fs/ceph/inode.c | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 66bbf6d517a9..c40d129bbd03 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -751,8 +751,6 @@ static int ceph_finish_async_create(struct inode *dir, struct inode *inode,
 			unlock_new_inode(inode);
 		}
 		if (d_in_lookup(dentry) || d_really_is_negative(dentry)) {
-			if (!d_unhashed(dentry))
-				d_drop(dentry);
 			dn = d_splice_alias(inode, dentry);
 			WARN_ON_ONCE(dn && dn != dentry);
 		}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8557b207d337..32bac5cac8c4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1517,9 +1517,6 @@ static int splice_dentry(struct dentry **pdn, struct inode *in)
 		}
 	}
 
-	/* dn must be unhashed */
-	if (!d_unhashed(dn))
-		d_drop(dn);
 	realdn = d_splice_alias(in, dn);
 	if (IS_ERR(realdn)) {
 		pr_err_client(cl, "error %ld %p inode %p ino %llx.%llx\n",
-- 
2.50.0.107.gf914562f5916.dirty

