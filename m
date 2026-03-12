Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E515D242D7F;
	Fri, 13 Mar 2026 00:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773362698; cv=none; b=WcTBQk8n5rJYwwM5Tw4Na0PX42E9cOdlQoxn3QMquHCcKnhZJgSRq+Ewlear1qW5w4jwOCCxVs3jKFWsAZHyJ59krvRoQdHDRaxmqRpcfWEJkII+sXS5Au93/untsuQxIYwZkHmfa0X+T1/ULBOqxHRhhjb6Xc9Wp1D1KwLwlgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773362698; c=relaxed/simple;
	bh=1GEdUWGxzBWcip32FwhChqRsoRwk1KYoMgvnGuh140U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2wb/09Mh94SJDGmh4qYpLAC4dRiB6QLi8VWcP3EL7fvTpBfHSRXQbM6BTOKcDC3I5ByYGmoSjdgoKZIK4NL4/iCNvaRsmUyUDUriFr0xgRrSssA8xwlJQteX52d31pKVQiZNzZG+DbDShMHx9mn8dsCyAp6JR2cZgug3Ue28Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=CqROUpl0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=z24mIuT+; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="CqROUpl0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="z24mIuT+"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 273051301B3C;
	Thu, 12 Mar 2026 20:44:55 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 12 Mar 2026 20:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362695;
	 x=1773369895; bh=epUsWlAclv1DX2KFvnl7YFoPpzqQm77MgVOFM+B8UxU=; b=
	CqROUpl0SFgdLYM+5S4HfZslkqN7s5xdFeJrWFhMGpiUdyODd7Z+7ZvN1Cp31hpK
	ZT7KdwX8nus+Re9RyFZ7Lmx2HS/y4aAbuKPyjNSlyG4QT9GlQP35c7Qc/wveUpJc
	R6fyTEJL1SYXniLv5tJqSk0lVP4TG9izP0Z5673lCC1cVr3QRjNHb2xuAnovPDIN
	SWebynoCqykrPAnihTtAf4L4HNSaXCdZDUwo3lrKJrbCjD9/oexYvaM0MJCepNAl
	UAzWnRabXqQJKdQ+UqQhD+TSINUJmdz5L/8VPRv5cvG/4/0ylXxVgi/4RB5tBewr
	q+8rr17BgBMChmtR+WIx8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362695; x=1773369895; bh=e
	pUsWlAclv1DX2KFvnl7YFoPpzqQm77MgVOFM+B8UxU=; b=z24mIuT+M2aYx8BDn
	/SvHK2UeiuT9Zv020rqyHMZx6iwO9BhUEN4xj0P9wfCsYHthOQ7I3eXW+qtsed2n
	/hGxBGJFKKkTmgXNYq9tJp1zytp6kg+1P5x0LuPwfGAY/urC++X+Rh/67vfy5hZl
	DF1pkcDi9UQPUY2J1H/YNQzRgxd7MjUUl8aQvK/mKz5IoPlHl9bi+l9YIlwoaZgH
	Zk1LmrrSqNDSvYiABRJ2cxUaljb/oxyhp6EmBjDzWaeW+e+D8vTq2jf3ic7Ke1iv
	RjnCU9b8SvZ4hBQDdVmd8EVd30w+Luquz27gPL6jEjG5gzX9KlTD0SzRez021FFn
	iosiw==
X-ME-Sender: <xms:Bl6zaStXJ9WAw-16S3bYaCz_RnS8tYIFCyfwjxNZHNrhQ9Ae5W9-Xg>
    <xme:Bl6zabJ5U1axuX6nlB6VWQLXTnvvS2mY7Jgk-rmULAb0W5ZhgWxydmDeaAFefR9aW
    TEl-nDM2wCNr6XpJ9HBJO6rHcSSiZmkWgKeXXxmS55kQhKFIA>
X-ME-Received: <xmr:Bl6zaY3KSkPbpdXhtNRFclXHaXrF71EMYZcvCFtn3vRjXfFhyhDzrAo3wC1O5tXXPk3IWimgPTOXKMOae_kBFPhBSEbSvIB5v8w_BH0Myp5z>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
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
X-ME-Proxy: <xmx:Bl6zaarLR5ShQVdaOoWUVtIhXP2j0-a8MHXe_bBheeqOXSt1kFPCYw>
    <xmx:Bl6zaYeQfHS5JnVFj1qQxZXh5cdBT39G07cL5E5Dm-e7x3pBmT-Rgg>
    <xmx:Bl6zaRxbiV781OoMd07m9PkrWVRBBoGMyd0NWxXe_GpCM4BzatSIGA>
    <xmx:Bl6zaWdLL1WOPvL9MrrQBGVzVZJ-LjPPQ0X0uOHzWW3JziVEDBVF8Q>
    <xmx:B16zab6RlMl90xxVmmES_1mzBODI5Ga6UsScuDL74A1RJ5HwqAPRxTmx>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:44:41 -0400 (EDT)
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
Subject: [PATCH 31/53] configfs: stop using d_add().
Date: Fri, 13 Mar 2026 08:12:18 +1100
Message-ID: <20260312214330.3885211-32-neilb@ownmail.net>
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

"Best practice" is to use d_splice_alias() at the end of a ->lookup
function.  d_add() often works and is not incorrect in configfs, but as
it is planned to remove d_add(), change to use d_splice_alias().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/configfs/dir.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index c82eca0b5d73..6ec589b6b8a4 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -501,8 +501,7 @@ static struct dentry * configfs_lookup(struct inode *dir,
 	}
 	spin_unlock(&configfs_dirent_lock);
 done:
-	d_add(dentry, inode);
-	return NULL;
+	return d_splice_alias(inode, dentry);
 }
 
 /*
-- 
2.50.0.107.gf914562f5916.dirty

